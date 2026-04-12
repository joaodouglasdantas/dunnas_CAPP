class LogAuditorium < ApplicationRecord
  belongs_to :usuario, class_name: "User", foreign_key: "usuario_id", optional: true

  def self.registrar(usuario, acao)
    create!(
      usuario_id: usuario&.id,
      acao: acao,
      created_at: Time.current
    )
  end
end
