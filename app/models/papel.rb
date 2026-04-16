class Papel < ApplicationRecord
  has_many :usuario_papeis, class_name: "UsuarioPapel"
  has_many :users, through: :usuario_papeis
  has_many :papel_permissoes, class_name: "PapelPermissao"
  has_many :permissoes, through: :papel_permissoes, source: :permissao
end
