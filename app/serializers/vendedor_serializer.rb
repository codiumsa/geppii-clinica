class VendedorSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :apellido, :direccion, :telefono, :email, :activo, :comision
  has_many :sucursales, embed: :id,  include: false, autosave: true
end
