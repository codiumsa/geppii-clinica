class Proceso < ActiveRecord::Base
  belongs_to :producto
  has_many :proceso_detalles, :class_name => 'ProcesoDetalle', :dependent => :destroy, :foreign_key => 'proceso_id'

  validates :descripcion, :estado, :producto, :cantidad, presence: true
  validates :descripcion, uniqueness: {message: :descripcion_taken}

  scope :by_producto_id, -> producto_id { where("producto_id = ?", "#{producto_id}") }
  scope :by_descripcion, -> descripcion { where("descripcion = ?", "#{descripcion}") }
  scope :by_estado, -> estado { where("estado = ?", "#{estado}") }
  scope :by_cantidad, -> cantidad { where("cantidad = ?", "#{cantidad}") }
  scope :by_producible,  -> estado {where("estado = ?", "#{estado}") }

  scope :by_all_attributes, -> value { 
    joins(:producto).
    where("productos.id = ? OR procesos.cantidad = ? OR productos.descripcion ilike ? OR procesos.descripcion ilike ?  OR procesos.estado ilike ? " ,
          number?(value) ? value.to_i : nil,
          number?(value) ? value.to_i : nil,
          "%#{value}%", "%#{value}%","%#{value}%")
  }
  def self.number? (string)
    true if Float(string) rescue false
  end  
end
