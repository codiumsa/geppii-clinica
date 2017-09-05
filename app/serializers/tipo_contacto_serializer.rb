class TipoContactoSerializer < ActiveModel::Serializer
  attributes :id, :codigo, :descripcion, :con_campanha, :con_mision, :activo
end
