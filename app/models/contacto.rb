class Contacto < ActiveRecord::Base
  belongs_to :sponsor
  belongs_to :tipo_contacto
  belongs_to :campanha
  has_many :contacto_detalles, :dependent => :destroy

  attr_accessor :compromiso_total,:estado_actual,:compromiso_pagado,:tiene_detalle_in_kind,:compromiso_pagado_in_kind

  validates_presence_of :sponsor, :message => "Ingrese un Patrocinador"

  scope :ids, lambda { |id| where(:id => id) }
  scope :by_campanha, -> value { where("campanha_id = ?", "#{value}" ) }
  scope :by_sponsor, -> value { where("sponsor_id = ?", "#{value}" ) }

  scope :by_all_attributes, -> value {
    joins(:tipo_contacto).joins(:sponsor).joins(:sponsor => :persona).
    where(
      "contactos.observacion = ?
    OR tipo_contactos.ticodigo ilike ?
     OR personas.razon_social ilike ?
      OR personas.ci_ruc ilike ?
       OR to_char(contactos.fecha, 'DD/MM/YYYY') ilike ?",
    "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%")
  }

  def tiene_detalle_in_kind
    if !contacto_detalles.empty?
      contacto_detalles.map do |contacto|
        if ((contacto.estado.eql? "Comprometido In Kind") || (contacto.estado.eql? "Recibido In Kind"))
          return true
        end
      end
    end
    return false
  end

  def compromiso_total
    if !contacto_detalles.empty?
      contacto_detalles_monedas = contacto_detalles.group_by(&:moneda_id)
      sum = 0
      resultados = []
      contacto_detalles_monedas.map do |k,v|
        v.map do |contacto_detalle|
          if !contacto_detalle.compromiso.nil?
            sum = contacto_detalle.compromiso + sum
          end
        end
        resultados.push([v.first.moneda.nombre + ': ' + sum.to_s])
        sum = 0
      end
      return resultados.join(' - ')
    end
  end

  def compromiso_pagado
    if !contacto_detalles.empty?
      contacto_detalles_monedas = contacto_detalles.group_by(&:moneda_id)
      sumaComprometido = 0
      sumaRecibido = 0
      resultados = []
      contacto_detalles_monedas.map do |k,v|
        v.map do |contacto_detalle|
          if !contacto_detalle.compromiso.nil?
            if contacto_detalle.estado.eql? "Comprometido"
              sumaComprometido = sumaComprometido + contacto_detalle.compromiso
            end
            if contacto_detalle.estado.eql? "Recibido"
              sumaRecibido = contacto_detalle.compromiso + sumaRecibido
            end
          end
        end
        if v.first.moneda.simbolo.eql? "Gs."
          resultados.push([v.first.moneda.nombre + ': ' + ActionController::Base.helpers.number_to_currency(sumaRecibido, precision: 0, unit: "",  separator: ",", delimiter: ".") + "/" + ActionController::Base.helpers.number_to_currency(sumaComprometido, precision: 0, unit: "",  separator: ",", delimiter: ".")])
        elsif v.first.moneda.simbolo.eql? "US$"
          resultados.push([v.first.moneda.nombre + ': ' + ActionController::Base.helpers.number_to_currency(sumaRecibido, precision: 2, unit: "",  separator: ",", delimiter: ".") + "/" + ActionController::Base.helpers.number_to_currency(sumaComprometido, precision: 2, unit: "",  separator: ",", delimiter: ".")])
        end
        sumaComprometido = 0
        sumaRecibido = 0
      end
      return resultados.join('<br>')
    end
  end

  def compromiso_pagado_in_kind
    if !contacto_detalles.empty?
      contacto_detalles_monedas = contacto_detalles.group_by(&:moneda_id)
      sumaComprometido = 0
      sumaRecibido = 0
      comprometidoik = []
      recibidoik = []
      resultados = []
      contacto_detalles_monedas.map do |k,v|
        v.map do |contacto_detalle|
          if !contacto_detalle.compromiso.nil?
            if contacto_detalle.estado.eql? "Comprometido"
              sumaComprometido = sumaComprometido + contacto_detalle.compromiso
            end
            if contacto_detalle.estado.eql? "Recibido"
              sumaRecibido = contacto_detalle.compromiso + sumaRecibido
            end
            if contacto_detalle.estado.eql? "Comprometido In Kind"
              comprometidoik.push(contacto_detalle.observacion)
            end
            if contacto_detalle.estado.eql? "Recibido In Kind"
              recibidoik.push(contacto_detalle.observacion)
            end
          else
            if contacto_detalle.estado.eql? "Comprometido In Kind"
              comprometidoik.push(contacto_detalle.observacion)
            end
            if contacto_detalle.estado.eql? "Recibido In Kind"
              recibidoik.push(contacto_detalle.observacion)
            end
          end
        end
        if v.first.moneda.simbolo.eql? "Gs."
          resultados.push([v.first.moneda.nombre + ': ' + ActionController::Base.helpers.number_to_currency(sumaRecibido, precision: 0, unit: "",  separator: ",", delimiter: ".") + "/" + ActionController::Base.helpers.number_to_currency(sumaComprometido, precision: 0, unit: "",  separator: ",", delimiter: ".")])
        elsif v.first.moneda.simbolo.eql? "US$"
          resultados.push([v.first.moneda.nombre + ': ' + ActionController::Base.helpers.number_to_currency(sumaRecibido, precision: 2, unit: "",  separator: ",", delimiter: ".") + "/" + ActionController::Base.helpers.number_to_currency(sumaComprometido, precision: 2, unit: "",  separator: ",", delimiter: ".")])
        end
        sumaComprometido = 0
        sumaRecibido = 0
      end
      if ((comprometidoik.length > 0) || (recibidoik.length > 0))
        return resultados.join('<br>') + "<br>" + "Recibido In Kind: " + recibidoik.join(', ') + "<br>" + "Comprometido In Kind: " + comprometidoik.join(', ')
      else
        return resultados.join('<br>')
      end
    end
  end

  def estado_actual
    if !contacto_detalles.empty?
      return contacto_detalles.order(created_at: :desc).first.estado
    end
  end

end
