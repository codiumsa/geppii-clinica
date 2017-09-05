class ProductoSerializer < ActiveModel::Serializer
  attributes :id, :codigo_barra, :descripcion, :unidad, :margen, :precio_compra, :precio, :iva, :existencia, :descuento, :descripcion_codigo,:nro_inventario,:nro_serie,:asignado,:responsable_mantenimiento,:anho_fabricacion,:fecha_adquisicion,:area,:modelo,:descontinuado,
    :stock_minimo, :precio_promedio, :pack, :cantidad, :url_foto, :activo, :descripcion_externa, :descripcion_local,:nro_referencia,
    :codigo_local, :codigo_externo, :es_procedimiento, :marca,:presentacion,:necesita_consentimiento_firmado
  has_many :categorias, embed: :id,  include: false, autosave: true
  has_many :promocion_productos, embed: :id, include: false
  has_many :lotes, embed: :id, include: true
  has_one :promocion_aplicada
  has_one :producto, embed: :id, include: false
  has_one :moneda, embed: :id, include: false
  has_one :especialidad, embed: :id, include: false
  has_one :tipo_producto, embed: :id, include: false
  has_many :producto_detalles, embed: :id, include: false
end
