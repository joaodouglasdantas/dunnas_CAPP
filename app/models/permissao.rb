class Permissao < ApplicationRecord
  has_many :papel_permissoes, class_name: "PapelPermissao"
  has_many :papeis, through: :papel_permissoes
end
