class TipoColaboradorSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :descripcion, :tiene_viajes, :tiene_licencia, :es_club
end
