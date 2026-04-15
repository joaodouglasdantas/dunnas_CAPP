require "test_helper"

class StatusChamadoTest < ActiveSupport::TestCase
  test "deve ser inválido sem nome" do
    status = StatusChamado.new
    assert_not status.valid?
  end

  test "deve existir apenas um status padrão" do
    status_duplicado = StatusChamado.new(nome: "Novo", padrao: true)
    assert_not status_duplicado.valid?
  end

  test "nao deve permitir deletar status padrao" do
    status = status_chamados(:aberto)
    assert_no_difference "StatusChamado.count" do
      status.destroy
    end
    assert status.errors[:base].any?
  end

  test "nao deve permitir desmarcar unico status padrao" do
    status = status_chamados(:aberto)
    status.update(padrao: false)
    assert status.errors[:base].any?
  end

  test "deve permitir deletar status nao padrao sem chamados" do
    status = status_chamados(:em_andamento)
    assert_difference "StatusChamado.count", -1 do
      status.destroy
    end
  end
end
