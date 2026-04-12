# Minitest
require "test_helper"

class BlocoTest < ActiveSupport::TestCase
  test "deve ser inválido sem nome" do
    bloco = Bloco.new(quantidade_andares: 3, unidades_por_andar: 4)
    assert_not bloco.valid?
  end

  test "deve ser inválido sem quantidade de andares" do
    bloco = Bloco.new(nome: "Bloco A", unidades_por_andar: 4)
    assert_not bloco.valid?
  end

  test "deve ser inválido sem unidades por andar" do
    bloco = Bloco.new(nome: "Bloco A", quantidade_andares: 3)
    assert_not bloco.valid?
  end

  test "deve gerar unidades automaticamente ao ser criado" do
    bloco = Bloco.create!(
      nome: "Bloco A",
      quantidade_andares: 3,
      unidades_por_andar: 4
    )
    assert_equal 12, bloco.unidades.count
  end

  test "deve gerar identificacoes corretas nas unidades" do
    bloco = Bloco.create!(
      nome: "Bloco A",
      quantidade_andares: 2,
      unidades_por_andar: 2
    )
    identificacoes = bloco.unidades.pluck(:identificacao).sort
    assert_equal [ "101", "102", "201", "202" ], identificacoes
  end
end
