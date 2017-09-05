class PromocionSerializer < ActiveModel::Serializer
  attributes :id, :descripcion, :fecha_vigencia_desde, :fecha_vigencia_hasta, :permanente, :exclusiva, :cantidad_general, :porcentaje_descuento, :tipo, :con_tarjeta, :a_partir_de, :por_unidad

  has_many :detalles, embed: :id, include: false
  has_one :tarjeta, embed: :id, include: false
end
