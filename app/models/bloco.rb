class Bloco < ApplicationRecord
  has_many :unidades, dependent: :destroy

  validates :nome, presence: true
  validates :quantidade_andares, presence: true, numericality: { greater_than: 0 }
  validates :unidades_por_andar, presence: true, numericality: { greater_than: 0 }

  after_create :gerar_unidades
  after_create :log_criacao

  private

  def gerar_unidades
    quantidade_andares.times do |andar|
      numero_andar = andar + 1
      unidades_por_andar.times do |unidade|
        numero_unidade = unidade + 1
        identificacao = "#{numero_andar}#{numero_unidade.to_s.rjust(2, '0')}"
        unidades.create!(
          numero_andar: numero_andar,
          numero_unidade: numero_unidade,
          identificacao: identificacao
        )
      end
    end
  end

  def log_criacao
    LogAuditorium.registrar(nil, "Bloco #{nome} criado com #{quantidade_andares} andares e #{unidades_por_andar} unidades por andar")
  end
end
