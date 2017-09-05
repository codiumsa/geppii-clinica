class UsuarioSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :apellido, :email, :username
  has_many :roles, embed: :id,  include: false, autosave: true
  has_many :sucursales, embed: :id,  include: false, autosave: true
end
