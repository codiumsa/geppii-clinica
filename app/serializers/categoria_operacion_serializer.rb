class CategoriaOperacionSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :descripcion, :activo, :tipo_operacion_id
end
