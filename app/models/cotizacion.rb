class Cotizacion < ActiveRecord::Base
  belongs_to :moneda
  belongs_to :moneda_base, class_name: 'Moneda'
  belongs_to :usuario

  default_scope order("fecha_hora DESC")

	scope :by_moneda, -> id { where("moneda_id = ?", id) }
	scope :by_moneda_base, -> id { where("moneda_base_id = ?", id) }
  scope :unpaged, -> { order("fecha_hora DESC") }

  scope :ultima_cotizacion, -> moneda_id, moneda_base_id { where("moneda_id = ? AND moneda_base_id = ?", moneda_id, moneda_base_id).limit(1) }

  scope :by_all_attributes, -> value { 
    joins(:moneda).
    where("cotizaciones.monto = ? OR cotizaciones.fecha_hora ilike ? OR monedas.nombre ilike ", 
          number?(value) ? value.to_i : nil, "%#{value}%", "%#{value}%")
  }

  def self.get_cotizacion(moneda_base_id, moneda_id)
    Cotizacion.where('moneda_base_id = ? and moneda_id = ?', moneda_base_id, moneda_id)
              .order(fecha_hora: :desc).limit(1).first
  end

  def self.convertir(monto, moneda_origen, moneda_destino)
    puts "Cotizando #{monto} origen: #{moneda_origen} destino: #{moneda_destino}"
		cotizacion = Cotizacion.get_cotizacion(moneda_origen, moneda_destino)
		dividir = true
		if cotizacion.nil?
			cotizacion = Cotizacion.get_cotizacion(moneda_destino, moneda_origen)
			dividir = false
		end
		convertido = 0
		if dividir
			convertido = monto / cotizacion.monto
		else
			convertido = monto * cotizacion.monto
		end
		return convertido
  end
end
