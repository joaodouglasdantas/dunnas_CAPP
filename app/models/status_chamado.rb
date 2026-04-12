class StatusChamado < ApplicationRecord
  has_many :chamados

  validates :nome, presence: true
  validates :padrao, uniqueness: { conditions: -> { where(padrao: true) },
    message: "já existe um status padrão definido" }

  before_destroy :verificar_se_pode_deletar

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
end
