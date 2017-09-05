class Categoria < ActiveRecord::Base
  has_and_belongs_to_many :productos
  validates :nombre, presence: true
  scope :by_nombre, -> nombre { where("nombre ilike ?", "%#{nombre}%") }
  scope :by_comision, -> nombre { where("comision = ?", "#{nombre}") }
  #scope :by_activo, ->activo { where("activo=?", "#{activo}") }
  scope :unpaged, -> { order("nombre") }

  scope :by_all_attributes, -> value { 
    where("nombre ilike ?", "%#{value}%")
  }

  scope :ids, lambda { |id| where(:id => id) }
  
end
