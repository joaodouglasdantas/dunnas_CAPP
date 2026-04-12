class TipoChamado < ApplicationRecord
  validates :titulo, presence: true
  validates :sla_horas, presence: true, numericality: { greater_than: 0 }

  before_destroy :log_remocao

  private

  def log_remocao
    LogAuditorium.registrar(nil, "Tipo de chamado '#{titulo}' removido do sistema")
  end
end
