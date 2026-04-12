class StatusChamado < ApplicationRecord
  has_many :chamados

  validates :nome, presence: true
  validates :padrao, uniqueness: { conditions: -> { where(padrao: true) },
    message: "já existe um status padrão definido" }

  before_destroy :verificar_se_pode_deletar
  before_destroy :log_remocao
  before_update :verificar_remocao_padrao

  after_create :log_criacao
  after_update :log_atualizacao

  private

  def verificar_se_pode_deletar
    if padrao?
      errors.add(:base, "Não é possível excluir o status padrão do sistema.")
      throw :abort
    end

    if chamados.any?
      errors.add(:base, "Não é possível excluir um status que está sendo usado em chamados.")
      throw :abort
    end
  end

  def log_remocao
    LogAuditorium.registrar(Current.usuario, "Status '#{nome}' removido do sistema")
  end

  def verificar_remocao_padrao
    if padrao_changed? && !padrao? && StatusChamado.where(padrao: true).count <= 1
      errors.add(:base, "Não é possível remover o status padrão sem definir outro como padrão antes.")
      throw :abort
    end
  end

  def log_criacao
    LogAuditorium.registrar(Current.usuario, "Status '#{nome}' criado no sistema")
  end

  def log_atualizacao
    mudancas = saved_changes.except("updated_at")
    return if mudancas.empty?
    detalhes = mudancas.map do |campo, (anterior, novo)|
      "#{campo}: '#{anterior}' → '#{novo}'"
    end.join(", ")
    LogAuditorium.registrar(Current.usuario, "Status '#{nome}' atualizado — #{detalhes}")
  end
end
