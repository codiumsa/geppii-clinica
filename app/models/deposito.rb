class Deposito < ActiveRecord::Base
  validates :nombre, presence: true
  has_many :inventario, dependent: :destroy


  scope :by_nombre, -> nombre { where("nombre ilike ?", "%#{nombre}%") }
  scope :by_descripcion, -> descripcion { where("descripcion ilike ?", "%#{descripcion}%") }
  scope :by_all_attributes, -> value { where("nombre ilike ? OR descripcion ilike ?", "%#{value}%", "%#{value}%") }
  scope :by_id, -> id { where("id = ?", "#{id}") }
  scope :unpaged, -> { order("id") }
  #scope :by_activo, ->activo { where("activo=?", "#{activo}") }

  scope :ids, lambda { |id| where(:id => id) }
end