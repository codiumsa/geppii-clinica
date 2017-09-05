class CategoriaOperacion < ActiveRecord::Base
  belongs_to :tipo_operacion

  validates :nombre, :descripcion, presence: true

  scope :unpaged, -> { order("nombre") }
  scope :by_id, -> id { where("id = ?", "#{id}") }

  scope :con_tipo_operacion, -> {  where.not(:tipo_operacion_id => nil) }

  scope :by_nombre, -> nombre { where("nombre like ?", "%#{nombre}%") }
  scope :by_activo, -> activo { where("activo = ?", "#{activo}") }
  scope :by_tipo_operacion, -> tipo_operacion_id { where("tipo_operacion_id = ? or tipo_operacion_id is null", "#{tipo_operacion_id}") }
  scope :by_all_attributes, -> value { joins(:tipo_operacion).
    where("categoria_operaciones.nombre ilike ? OR categoria_operaciones.descripcion ilike ? OR tipos_operacion.descripcion ilike ?", "%#{value}%", "%#{value}%", "%#{value}%")
  }

end
