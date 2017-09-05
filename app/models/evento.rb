class Evento < ActiveRecord::Base
  belongs_to :usuario

  scope :by_usuario_id, -> usuario_id { where("usuario_id = ?", "#{usuario_id}")}
  scope :by_tipo, -> tipo { where("tipo = ?", "#{tipo}")}

  scope :by_fecha_registro_before, -> before{ where("fecha::date < ?", Date.parse(before)) }
  scope :by_fecha_registro_on, -> on { where("fecha::date = ?", Date.parse(on)) }
  scope :by_fecha_registro_after, -> after { where("fecha::date > ?", Date.parse(after)) }


	def self.tipos 
  	{
  		"venta_cero" => "Venta con Monto 0",
   		"cambio_de_precio" => "Cambio en precio de producto",
   		"aplicacion_descuento" => "Aplicaciones de descuentos"
  	}
	end

  def tipoFormateado
    Evento.tipos[tipo]
  end
  
	def self.venta_cero(observaciones, usuario_id)
		evento = Evento.new
		evento.fecha = Date.today()
		evento.tipo = "venta_cero"
		evento.observacion = observaciones
    evento.usuario_id = usuario_id
		evento.save
	end

	def self.aplicacion_descuento(observaciones, usuario_id)
		evento = Evento.new
		evento.fecha = Date.today()
		evento.tipo = "aplicacion_descuento"
		evento.observacion = observaciones
    evento.usuario_id = usuario_id
		evento.save
	end

  def self.cambio_precio(observaciones, usuario_id)
    evento = Evento.new
    evento.fecha = Date.today()
    evento.tipo = "cambio_de_precio"
    evento.observacion = observaciones
    evento.usuario_id = usuario_id
    evento.save
  end
end
