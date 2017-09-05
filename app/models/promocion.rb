# encoding: utf-8
class Promocion < ActiveRecord::Base

  has_many :promocion_productos, :dependent => :destroy
  # validates_length_of :descripcion, :maximum => 255, :message=> "No debe superar los 255 caracteres"
  validates :descripcion, presence: true
  #validates :porcentaje_descuento, numericality: { greater_than: 0, message: "El número debe ser mayor o igual a cero" }

  # validates :descripcion, :presence => true, :length => { :maximum => 255}, :message=> "No debe superar los 255 caracteres"
  has_many :detalles, :class_name => 'PromocionProducto', :dependent => :destroy, :foreign_key => 'promocion_id'
  belongs_to :tarjeta
  scope :ids, lambda { |id| where(:id => id) }

  attr_accessor :tipo
  scope :by_descripcion, ->value{ where("descripcion ilike ?","%#{value}%")}
	scope :vigentes, -> { where("? between fecha_vigencia_desde AND fecha_vigencia_hasta OR permanente = true", Date.today) }
  scope :vigentes_no_exclusivas, -> { where("(? between fecha_vigencia_desde AND fecha_vigencia_hasta OR permanente = true) and exclusiva = false and con_tarjeta = false", Date.today) }
  scope :vigentes_no_exclusivas_no_tarjeta, -> { where("(? between fecha_vigencia_desde AND fecha_vigencia_hasta OR permanente = true) and exclusiva = false AND con_tarjeta = false", Date.today) }
  scope :isPermanente, -> {where("permanente = true")}
  scope :by_exclusiva, -> value{ where("descripcion ilike ? and exclusiva = true","%#{value}%")}
  scope :by_categoria_vigentes, ->  categoria_cliente_id {joins(:categoria_clientes_promociones).where("categoria_clientes_promociones.categoria_cliente_id = ?", "#{categoria_cliente_id}" )}
  scope :by_tarjeta_id, -> value{ where("tarjeta_id = ?","#{value}")}
  scope :tiene_producto, -> promo_id, producto_id {joins(:promocion_productos).where("promocion_productos.producto_id = ? and promocion_productos.promocion_id = ?", "#{producto_id}", "#{promo_id}" )}
  scope :by_activo, -> { where("promociones.activo = true") }
  
  scope :by_all_attributes, -> value { joins(:promocion_productos).joins(:promocion_productos => :producto).where(
          "promociones.descripcion ilike ? 
          OR productos.descripcion ilike ? 
          OR productos.codigo_barra ilike ?
          OR promociones.porcentaje_descuento = ?
          OR to_char(promociones.fecha_vigencia_desde, 'DD/MM/YYYY') ilike ?
          OR to_char(promociones.fecha_vigencia_hasta, 'DD/MM/YYYY') ilike ?",
          "%#{value}%",
          "%#{value}%",
          "%#{value}%",
          number?(value) ? value.to_i : nil, 
          "%#{value}%",
          "%#{value}%").uniq
  }
  
  def isVigente
    (permanente and fecha_vigencia_desde <= Date.today) or (fecha_vigencia_desde..fecha_vigencia_hasta).cover?(Date.today)
  end

  def self.number? (string)
    true if Float(string) rescue false
  end

  def save_with_details
    transaction do

      if !save
        raise ActiveRecord::Rollback
      end

    end
  end

  def eliminar
    transaction do
      begin
        destroy
      rescue ActiveRecord::InvalidForeignKey
        self.errors[:base] << "La promocion ya fue aplicada"
      end
    end
  end
  
  def self.get_tipo (p)
    puts "OBTENER TIPO PROMOCION #{p}"
    s = ""
    if p.con_tarjeta
      s += " TC #{p.tarjeta.afinidad}"
    end
    if p.exclusiva
      s += " Exclusiva"
    end
    if p.cantidad_general > 0
      s += " >= #{p.cantidad_general}"
    end
    if (not p.promocion_productos.nil? and p.promocion_productos.size > 0)
      s += " Producto "
    end
    return s
  end
  def precio_descuento_general(producto)
    if porcentaje_descuento
      precio_promo = producto.precio - producto.precio * (porcentaje_descuento / 100)
    else
      producto.precio
    end
  end
end
