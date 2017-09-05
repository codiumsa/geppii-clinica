class Consultorio < ActiveRecord::Base
  belongs_to :especialidad
  validates :codigo, :descripcion, :especialidad, presence: true
	
	scope :unpaged, -> { order("descripcion") }
  scope :by_all_attributes, -> value {
  	joins(:especialidad).
		where("consultorios.codigo ilike ? OR consultorios.descripcion ilike ? OR especialidades.descripcion ilike ?",
	        "%#{value}%",
	        "%#{value}%",
		      "%#{value}%")
		}
	scope :by_descripcion, -> value {
		joins(:especialidad).
		where("consultorios.codigo ilike ? OR consultorios.descripcion ilike ? OR especialidades.descripcion ilike ?",
	        "%#{value}%",
	        "%#{value}%",
		      "%#{value}%")
		}
end
