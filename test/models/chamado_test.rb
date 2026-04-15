require "test_helper"

class ChamadoTest < ActiveSupport::TestCase
  def setup
    @status_padrao = status_chamados(:aberto)
    @status_concluido = status_chamados(:concluido)
    @tipo = TipoChamado.find_by(titulo: "Manutenção") || TipoChamado.first
    @bloco = Bloco.create!(nome: "Bloco Teste", quantidade_andares: 2, unidades_por_andar: 2)
    @unidade = @bloco.unidades.first
    @usuario = users(:morador)
  end

  test "deve ser inválido sem descrição" do
    chamado = Chamado.new(unidade: @unidade, usuario: @usuario, tipo_chamado: @tipo)
    assert_not chamado.valid?
  end

  test "deve iniciar com status padrão automaticamente" do
    chamado = Chamado.create!(
      unidade: @unidade,
      usuario: @usuario,
      tipo_chamado: @tipo,
      descricao: "Torneira com vazamento"
    )
    assert_equal @status_padrao, chamado.status_chamado
  end

  test "deve registrar finalizado_em ao ser concluído" do
    chamado = Chamado.create!(
      unidade: @unidade,
      usuario: @usuario,
      tipo_chamado: @tipo,
      descricao: "Torneira com vazamento"
    )
    assert_nil chamado.finalizado_em
    chamado.update!(status_chamado: @status_concluido)
    assert_not_nil chamado.finalizado_em
  end

  test "deve ser inválido sem unidade" do
    chamado = Chamado.new(usuario: @usuario, tipo_chamado: @tipo, descricao: "Teste")
    assert_not chamado.valid?
  end

  test "deve ser inválido sem tipo de chamado" do
    chamado = Chamado.new(unidade: @unidade, usuario: @usuario, descricao: "Teste")
    assert_not chamado.valid?
  end

  test "scope ativos retorna apenas chamados nao arquivados" do
    chamado_ativo = Chamado.create!(
      descricao: "ativo",
      unidade: unidades(:unidade_101),
      usuario: users(:morador),
      tipo_chamado: TipoChamado.first
    )
    chamado_arquivado = Chamado.create!(
      descricao: "arquivado",
      unidade: unidades(:unidade_101),
      usuario: users(:morador),
      tipo_chamado: TipoChamado.first,
      arquivado: true
    )
    assert_includes Chamado.ativos, chamado_ativo
    assert_not_includes Chamado.ativos, chamado_arquivado
  end

  test "scope arquivados retorna apenas chamados arquivados" do
    chamado_arquivado = Chamado.create!(
      descricao: "arquivado",
      unidade: unidades(:unidade_101),
      usuario: users(:morador),
      tipo_chamado: TipoChamado.first,
      arquivado: true
    )
    assert_includes Chamado.arquivados, chamado_arquivado
  end

  test "arquivar_antigos nao arquiva chamados nao concluidos" do
    chamado = Chamado.create!(
      descricao: "aberto",
      unidade: unidades(:unidade_101),
      usuario: users(:morador),
      tipo_chamado: TipoChamado.first
    )
    Chamado.arquivar_antigos!
    assert_not chamado.reload.arquivado
  end

  test "arquivar_antigos arquiva chamados concluidos com mais de 30 dias" do
    concluido = status_chamados(:concluido)
    chamado = Chamado.create!(
      descricao: "concluido antigo",
      unidade: @unidade,
      usuario: users(:morador),
      tipo_chamado: @tipo,
      status_chamado: concluido,
      finalizado_em: 31.days.ago,
      arquivado: false
    )
    Chamado.arquivar_antigos!
    assert chamado.reload.arquivado
  end

  test "registra bloco junto com unidade no log de criacao" do
    chamado = Chamado.create!(
      unidade: @unidade,
      usuario: @usuario,
      tipo_chamado: @tipo,
      descricao: "Teste de log"
    )
    log = LogAuditorium.last
    assert_includes log.acao, @unidade.bloco.nome
  end
end
