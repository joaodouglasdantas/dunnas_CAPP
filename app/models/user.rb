class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :usuario_papeis, class_name: "UsuarioPapel", foreign_key: "usuario_id", dependent: :destroy
  has_many :papeis, through: :usuario_papeis, source: :papel
  has_many :moradores_unidades, class_name: "MoradoresUnidade", foreign_key: "user_id", dependent: :destroy

  has_many :unidades, through: :moradores_unidades
  # para ir da cidade A para a cidade C, você precisa passar através (through) da cidade B

  has_many :chamados, class_name: "Chamado", foreign_key: "user_id", dependent: :destroy
  has_many :comentarios, class_name: "Comentario", foreign_key: "user_id", dependent: :destroy

  validates :nome, presence: true

  after_create :log_criacao

  def tem_papel?(nome_papel)
    papeis.exists?(nome: nome_papel)
  end

  def administrador?
    tem_papel?("administrador")
  end

  def colaborador?
    tem_papel?("colaborador")
  end

  def morador?
    tem_papel?("morador")
  end

  def log_criacao
    LogAuditorium.registrar(nil, "Usuário #{nome} (#{email}) criado no sistema")
  end
end
