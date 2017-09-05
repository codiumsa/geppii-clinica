class LoteDeposito < ActiveRecord::Base
  belongs_to :lote
  belongs_to :deposito
  belongs_to :contenedor
  belongs_to :producto
  attr_accessor :descripcion
  attr_accessor :lote_id_aux

  default_scope {includes(:lote)
                 .includes(:deposito)
                 .includes(:contenedor)
                 .references(:lote)
                 .references(:deposito)
                 .references(:contenedor)
                 }

  #validates :cantidad, :numericality => { :greater_than_or_equal_to => 0, :message => "La cantidad debe ser mayor o igual a 0."}

  scope :by_deposito_id, -> deposito_id { where("deposito_id = ?", "#{deposito_id}" )}
  scope :by_all_attributes, -> value { joins(:deposito).joins(:producto).joins(:lote).joins(:contenedor).
                                       where("depositos.nombre ilike ? OR productos.codigo_barra ilike ? OR productos.descripcion ilike ? OR to_char(lotes.fecha_vencimiento, 'DD/MM/YYYY') ilike ? OR lotes.codigo_lote ilike ? OR contenedores.codigo ilike ?",
                                             "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%" , "%#{value}%" ,"%#{value}%" )
                                       }

  scope :by_producto_id, -> producto_id { where("lote_depositos.producto_id = ?", "#{producto_id}") }
  scope :by_excluye_fuera_de_stock, -> { where("cantidad > 0")}
  scope :by_categoria_id, -> categoria_id { where("lote_depositos.producto_id in (select producto_id from categorias_productos where categorias_productos.categoria_id = ?)", categoria_id) }
  scope :producto_activo, -> producto { joins(:producto).where("productos.activo = true")}
  scope :obtener_depositos, -> producto { where("lote_depositos.producto_id = ? ", producto) }
  scope :obtener_lotes_by_deposito_producto, ->deposito, producto { where("lote_depositos.producto_id = ? and lote_depositos.deposito_id = ? ", producto, deposito) }
  scope :obtener_lotes_by_deposito_producto_existente, ->deposito, producto { where("lote_depositos.producto_id = ? and lote_depositos.deposito_id = ? and cantidad > 0", producto, deposito) }
  scope :obtener_lotes_by_producto, ->producto { where("lote_depositos.producto_id = ?", producto) }
  scope :existencia, -> deposito, lote { where("lote_depositos.deposito_id = ? AND lote_depositos.lote_id = ?", deposito, lote) }
  scope :usa_lote, -> { joins(:lote).where("lote.fecha_vencimiento IS NOT NULL")}
  scope :by_deposito, -> deposito { where("deposito_id = ?", deposito) }
  scope :by_lote, -> lote_id { where("lote_id = ?", lote_id) }

  def descripcion
    # puts lote
    if(!lote.fecha_vencimiento.nil?)
      return "Lote: #{lote.codigo_lote} - Cantidad: #{cantidad} - Vto.: #{lote.fecha_vencimiento.strftime("%d/%m/%Y")}"
    else
      return "Lote: #{lote.codigo_lote} - Cantidad: #{cantidad}}"
    end
  end
  def lote_id_aux
    # puts lote
    return lote.id
  end
end
