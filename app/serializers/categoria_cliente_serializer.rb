class CategoriaClienteSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :descripcion
  has_many :promociones, embed: :id, include: false, autosave: true
end
