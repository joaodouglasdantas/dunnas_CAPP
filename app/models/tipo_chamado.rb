class TipoChamado < ApplicationRecord
  validates :titulo, presence: true
  validates :sla_horas, presence: true, numericality: { greater_than: 0 }

  before_destroy :log_remocao

  after_create :log_criacao
  after_update :log_atualizacao

  private

  def log_remocao
    LogAuditorium.registrar(Current.usuario, "Tipo de chamado '#{titulo}' removido do sistema")
  end

  def log_criacao
    LogAuditorium.registrar(Current.usuario, "Tipo de chamado '#{titulo}' criado no sistema")
  end

  def log_atualizacao
    mudancas = saved_changes.except("updated_at")
    return if mudancas.empty?
    detalhes = mudancas.map do |campo, (anterior, novo)|
      "#{campo}: '#{anterior}' → '#{novo}'"
    end.join(", ")
    LogAuditorium.registrar(Current.usuario, "Tipo de chamado '#{titulo}' atualizado — #{detalhes}")
  end
end
