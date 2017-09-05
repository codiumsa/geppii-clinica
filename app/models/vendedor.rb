class Vendedor < ActiveRecord::Base
	belongs_to :venta
	has_and_belongs_to_many :sucursales
	has_many :sucursal_vendedores, dependent: :destroy
	validates :nombre, :apellido, presence: true
	validates :email, email: true, allow_blank: true
	validates :telefono, phone_number: true, allow_blank: true

	scope :by_nombre, -> nombre { where("nombre ilike ?", "%#{nombre}%") }
	scope :by_apellido, -> apellido { where("apellido ilike ?", "%#{apellido}%") }
	scope :by_direccion, -> direccion { where("direccion ilike ?", "%#{direccion}%")}
	scope :by_telefono, -> telefono { where("telefono ilike ?", "%#{telefono}%") }
	scope :by_email, -> email { where("email ilike ?", "%#{email}%") }
	scope :by_activo, -> { where("activo = true") }
	scope :by_id, -> id { where("id = ?", "#{id}") }
	scope :by_comision, -> comision { where("comision = ?", "#{comision}") }
	scope :unpaged, -> { order("nombre") }
  	scope :by_sucursal_id, -> sucursal_id {joins(:sucursal_vendedores).where("sucursales_vendedores.sucursal_id = ?", sucursal_id)}

	scope :by_all_attributes, -> value { 
    where("activo = true and nombre ilike ? 
    	OR apellido ilike ? 
    	OR  direccion ilike ? 
    	OR telefono ilike ? 
    	OR email ilike ?", 
          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%")
  	}
end
