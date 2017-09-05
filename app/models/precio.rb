class Precio < ActiveRecord::Base
  #default_scope { order('fecha DESC') }
  scope :by_producto, -> producto_id { joins(:compra_detalle).where('compra_detalles.producto_id = ?',"#{producto_id}").order("fecha DESC") }
  belongs_to :compra_detalle

  def self.crearHistorialPrecio(fecha_registro, detalle)
    @precio = Precio.new(:fecha =>fecha_registro, :precio_compra => detalle.precio_compra, :compra_detalle => detalle)
    @precio.save!
  end

end
