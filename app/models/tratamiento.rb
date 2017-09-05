class Tratamiento < ActiveRecord::Base
  scope :by_nombre, -> nombre { where("nombre ilike ?", "%#{nombre}%") }
  scope :by_all_attributes, -> value { where("nombre ilike ?", "%#{value}%") }
  belongs_to :especialidad
end
