require "test_helper"

class ColaboradorTipoChamadoTest < ActiveSupport::TestCase
  def setup
    @colaborador = users(:colaborador)
    @tipo = TipoChamado.create!(titulo: "Manutenção", sla_horas: 24)
  end

  test "deve ser inválido sem usuario" do
    vinculo = ColaboradorTipoChamado.new(tipo_chamado: @tipo)
    assert_not vinculo.valid?
  end

  test "deve ser inválido sem tipo de chamado" do
    vinculo = ColaboradorTipoChamado.new(user: @colaborador)
    assert_not vinculo.valid?
  end

  test "nao deve permitir vincular o mesmo tipo duas vezes ao mesmo colaborador" do
    ColaboradorTipoChamado.create!(user: @colaborador, tipo_chamado: @tipo)
    duplicado = ColaboradorTipoChamado.new(user: @colaborador, tipo_chamado: @tipo)
    assert_not duplicado.valid?
  end

  test "deve permitir o mesmo tipo para colaboradores diferentes" do
    outro_colaborador = users(:administrador)
    ColaboradorTipoChamado.create!(user: @colaborador, tipo_chamado: @tipo)
    vinculo2 = ColaboradorTipoChamado.new(user: outro_colaborador, tipo_chamado: @tipo)
    assert vinculo2.valid?
  end
end
