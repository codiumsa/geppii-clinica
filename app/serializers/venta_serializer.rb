class VentaSerializer < ActiveModel::Serializer
  attributes :id, :descuento, :total, :iva10, :iva5, :credito, :tarjeta_credito, :pagado, :cantidad_cuotas,
   :fecha_registro, :nro_factura, :uso_interno, :deuda, :ganancia, :anulado, :supervisor, :descuento_redondeo,:cirugia,:cantidad_cirugias,:nombre_campanha,
   :nombre_cliente, :ruc_cliente, :porcentaje_recargo, :nro_contrato
  has_one :campanha, embed: :id, include: false
  has_one :cliente, embed: :id, include: false
  has_one :vendedor, embed: :id, include: false
  has_one :persona, embed: :id, include: false
  has_one :tipo_credito, embed: :id, include: false
  has_one :sucursal, embed: :id, include: false
  has_many :venta_detalles, embed: :id, include: false
  has_many :venta_cuotas, embed: :id, include: false
  has_many :venta_medios, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
  has_one :tipo_salida, embed: :id, include: false
  has_one :medio_pago, embed: :id, include: false
  has_one :tarjeta, embed: :id, include: false
  has_one :garante, embed: :id, include: false
  has_one :colaborador, embed: :id, include: false
  has_one :consultorio, embed: :id, include: false



end
