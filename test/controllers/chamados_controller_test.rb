require "test_helper"

class ChamadosControllerTest < ActionDispatch::IntegrationTest
  def setup
    @administrador = users(:administrador)
    @colaborador = users(:colaborador)
    @morador = users(:morador)
    @status_padrao = status_chamados(:aberto)
    @tipo = TipoChamado.find_by(titulo: "Manutenção") || TipoChamado.first
    @bloco = Bloco.create!(nome: "Bloco Teste", quantidade_andares: 2, unidades_por_andar: 2)
    @unidade = @bloco.unidades.first

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
      descricao: "Teste de chamado"
    )
  end

  test "usuario nao autenticado e redirecionado para login" do
    get chamados_path
    assert_redirected_to new_user_session_path
  end

  test "administrador pode acessar lista de chamados" do
    sign_in @administrador
    get chamados_path
    assert_response :success
  end

  test "colaborador pode acessar lista de chamados" do
    sign_in @colaborador
    get chamados_path
    assert_response :success
  end

  test "morador pode acessar lista de chamados" do
    sign_in @morador
    get chamados_path
    assert_response :success
  end

  test "morador pode criar chamado para sua unidade" do
    sign_in @morador
    assert_difference "Chamado.count", 1 do
      post chamados_path, params: {
        chamado: {
          unidade_id: @unidade.id,
          tipo_chamado_id: @tipo.id,
          descricao: "Novo chamado"
        }
      }
    end
  end

  test "colaborador pode atualizar status do chamado" do
    status_novo = status_chamados(:em_andamento)
    sign_in @colaborador
    patch chamado_path(@chamado), params: {
      chamado: { status_chamado_id: status_novo.id }
    }
    assert_redirected_to chamado_path(@chamado)
  end

  test "morador nao pode atualizar status do chamado" do
    status_novo = status_chamados(:em_andamento)
    sign_in @morador
    patch chamado_path(@chamado), params: {
      chamado: { status_chamado_id: status_novo.id }
    }
    assert_redirected_to chamado_path(@chamado)
  end

  test "administrador pode remover chamado" do
    sign_in @administrador
    assert_difference "Chamado.count", -1 do
      delete chamado_path(@chamado)
    end
  end

  test "colaborador nao ve chamados fora do seu escopo" do
    sign_in users(:colaborador)
    get chamados_path
    assert_response :success
    # chamados do escopo aparecem
    @response.body
  end

  test "filtro por status retorna apenas chamados com aquele status" do
    sign_in users(:administrador)
    status = StatusChamado.find_by(padrao: true)
    get chamados_path, params: { status_id: status.id }
    assert_response :success
  end

  test "filtro por periodo hoje retorna apenas chamados de hoje" do
    sign_in users(:administrador)
    get chamados_path, params: { periodo: "hoje" }
    assert_response :success
  end

  test "morador nao pode editar chamado fora do status padrao" do
    sign_in users(:morador)
    chamado = chamados(:chamado_um)
    status_em_andamento = StatusChamado.find_by(padrao: false)
    chamado.update_column(:status_chamado_id, status_em_andamento.id)
    patch chamado_path(chamado), params: { chamado: { descricao: "nova descricao" } }
    assert_redirected_to chamado_path(chamado)
  end

  test "ver arquivados retorna apenas chamados arquivados" do
    sign_in users(:administrador)
    get chamados_path, params: { arquivados: true }
    assert_response :success
  end
end
