class ProductoDeposito < ActiveRecord::Base
  belongs_to :producto
  belongs_to :deposito

  validates :existencia, :numericality => { :greater_than_or_equal_to => 0, :message => "La existencia debe ser mayor o igual a 0."}
  scope :by_deposito_id, -> deposito_id { where("deposito_id = ?", "#{deposito_id}" )}

  scope :by_all_attributes, -> value { joins(:deposito).joins(:producto).
    where("depositos.nombre ilike ? OR productos.codigo_barra ilike ? OR productos.descripcion ilike ?", 
          "%#{value}%", "%#{value}%", "%#{value}%" )
  }

  scope :by_producto_id, -> producto_id { where("producto_depositos.producto_id = ?", "#{producto_id}") }
  scope :by_excluye_fuera_de_stock, -> { where("existencia > 0")}
  scope :by_categoria_id, -> categoria_id { where("producto_depositos.producto_id in (select producto_id from categorias_productos where categorias_productos.categoria_id = ?)", categoria_id) }
  scope :producto_activo, -> producto { joins(:producto).where("productos.activo = true")}
  scope :existencia, -> deposito, producto { where("deposito_id = ? AND producto_id = ?", deposito, producto) }
  scope :obtenerDepositos, -> producto { where("producto_id = ? ", producto) }

end
