class AjusteInventario < ActiveRecord::Base
	belongs_to :deposito
	belongs_to :usuario
	has_many :detalles, :class_name => 'AjusteInventarioDetalle', :dependent => :destroy, :foreign_key => 'ajuste_inventario_id'

	validates :observacion, :fecha, :deposito_id, presence: true

	scope :by_deposito_id, -> deposito { where("deposito_id = ?", "#{deposito}") }
	scope :by_fecha_before, -> before{ where("fecha::date < ?", Date.parse(before)) }
  scope :by_fecha_on, -> on { where("fecha::date = ?", Date.parse(on)) }
  scope :by_fecha_after, -> after { where("fecha::date > ?", Date.parse(after)) }

	scope :by_all_attributes, -> value { joins(:deposito).
	where("ajuste_inventarios.observacion ilike ? OR depositos.nombre ilike ? OR to_char(fecha, 'DD/MM/YYYY') ilike ?" ,
	    "%#{value}%", "%#{value}%", "%#{value}%").references(:depositos)
	}


    def save_with_details
      	transaction do
					puts detalles.to_yaml
	      	detalles.each do |detalle|
	      		puts "\n\n\n\n\n\nACTUALIZAR STOCK\n\n\n\n\n\n"
	          	Producto.actualizar_stock!(detalle.lote_id, deposito_id, detalle.cantidad)
	      	end
	      	if !save
	          raise ActiveRecord::Rollback
	      	end
      	end
  	end
end
