class Comentario < ApplicationRecord
  belongs_to :chamado
  belongs_to :usuario, class_name: "User", foreign_key: "user_id"

  validates :mensagem, presence: true
  validates :chamado, presence: true
  validates :usuario, presence: true

  after_create :log_criacao

  def pode_comentar?
    return true if usuario.administrador? || usuario.colaborador?
    chamado.unidade.moradores.include?(usuario)
  end

  private

  def log_criacao
    LogAuditorium.registrar(usuario, "Comentário adicionado no chamado ##{chamado.id} por #{usuario.nome}")
  end
end
