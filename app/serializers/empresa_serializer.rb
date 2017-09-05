class EmpresaSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :activo, :ruc, :codigo
end
