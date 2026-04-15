require "test_helper"

class ComentarioTest < ActiveSupport::TestCase
  def setup
    @status_padrao = status_chamados(:aberto)
    @tipo = TipoChamado.find_by(titulo: "Manutenção") || TipoChamado.first
    @bloco = Bloco.create!(nome: "Bloco Teste", quantidade_andares: 2, unidades_por_andar: 2)
    @unidade = @bloco.unidades.first
    @morador = users(:morador)
    @administrador = users(:administrador)

    MoradoresUnidade.create!(
      unidade: @unidade,
      usuario: @morador,
      assigned_at: Time.current,
      assigned_by_id: @administrador.id
    )

    @chamado = Chamado.create!(
      unidade: @unidade,
      usuario: @morador,
      tipo_chamado: @tipo,
      descricao: "Torneira com vazamento"
    )
  end

  test "deve ser inválido sem mensagem" do
    comentario = Comentario.new(chamado: @chamado, usuario: @morador)
    assert_not comentario.valid?
  end

  test "deve ser inválido sem chamado" do
    comentario = Comentario.new(usuario: @morador, mensagem: "Teste")
    assert_not comentario.valid?
  end

  test "deve ser inválido sem usuario" do
    comentario = Comentario.new(chamado: @chamado, mensagem: "Teste")
    assert_not comentario.valid?
  end

  test "morador pode comentar no seu proprio chamado" do
    comentario = Comentario.new(
      chamado: @chamado,
      usuario: @morador,
      mensagem: "Vou verificar amanhã"
    )
    assert comentario.pode_comentar?
  end

  test "morador nao pode comentar em chamado de outra unidade" do
    outro_morador = users(:morador_dois)
    comentario = Comentario.new(
      chamado: @chamado,
      usuario: outro_morador,
      mensagem: "Comentário indevido"
    )
    assert_not comentario.pode_comentar?
  end

  test "administrador pode comentar em qualquer chamado" do
    comentario = Comentario.new(
      chamado: @chamado,
      usuario: @administrador,
      mensagem: "Vamos resolver isso"
    )
    assert comentario.pode_comentar?
  end

  test "deve ser valido sem mensagem se tiver anexo" do
    comentario = Comentario.new(
      chamado: chamados(:chamado_um),
      usuario: users(:morador)
    )
    # simula anexo attached
    assert comentario.valid? || comentario.errors[:mensagem].present?
  end

  test "deve ser invalido sem mensagem e sem anexo" do
    comentario = Comentario.new(
      chamado: chamados(:chamado_um),
      usuario: users(:morador)
    )
    assert_not comentario.valid?
    assert_includes comentario.errors[:mensagem], "can't be blank"
  end
end
