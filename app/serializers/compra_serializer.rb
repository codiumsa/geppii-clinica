class CompraSerializer < ActiveModel::Serializer

  attributes :id, :total, :iva10, :iva5, :credito, :pagado, :cantidad_cuotas,
      :nro_factura, :tipo_credito, :fecha_registro, :deuda, :retencioniva, :monto_cotizacion, :periodos, :donacion,:razon_social_proveedor
  has_one :sucursal, embed: :id, include: false
  has_one :tipo_credito, embed: :id, include: false
  has_one :proveedor, embed: :id, include: false
  has_one :campanha, embed: :id, include: false
  has_one :sponsor, embed: :id, include: false
  has_many :compra_detalles, embed: :id, include: false
  has_many :compra_cuotas, embed: :id, include: false
  has_one :deposito, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
  has_one :cotizacion, embed: :id, include: false
end
