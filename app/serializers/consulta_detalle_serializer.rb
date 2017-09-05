class ConsultaDetalleSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :referencia_id, :referencia_nombre, :estado, :id_ficha, :fecha_inicio, :fecha_fin,:consentimiento_firmado
  has_one :consulta, embed: :id,  include: false
  has_one :producto, embed: :id,  include: false
end
