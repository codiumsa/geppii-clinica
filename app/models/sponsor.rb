class Sponsor < ActiveRecord::Base
  belongs_to :persona, autosave: true, :dependent => :destroy
  accepts_nested_attributes_for :persona
  has_many :contactos, :dependent => :destroy
  has_many :campanha_sponsors, :dependent => :destroy
  attr_accessor :info_sponsor
  attr_accessor :razon_social
  attr_accessor :id_persona
  attr_accessor :comprometido
  attr_accessor :pagado
  attr_accessor :ci_ruc
  #validate :must_have_persona
  scope :by_activo, -> value{ joins(:persona).where("activo = ?", value).order("personas.razon_social asc")}
  scope :by_campanha_id, -> value{ joins(:campanha_sponsors).where("campanha_sponsors.campanha_id = ?","#{value}")}
  # scope :by_contacto_sponsor, -> contacto_id { joins(:contactos).where(" and contactos.sponsor","#{value}")}
  scope :by_contacto_campanha, -> campanha_id { joins(:contactos).where("contactos.campanha_id = ?","#{campanha_id}")}
  scope :ignorar_sponsor_default, -> value{ joins(:persona).where("personas.ci_ruc <> '0'")}
  scope :by_ciRuc, -> value{ joins(:persona).where("personas.ci_ruc = ?", "#{value}" )}
  scope :by_persona_id, -> persona_id {where("persona_id = ?", persona_id )}
  scope :by_persona, -> value { joins(:persona).where("personas.razon_social ilike ? OR personas.nombre ilike ? OR personas.apellido ilike ?","%#{value}%", "%#{value}%", "%#{value}%") }
  scope :by_tipo_persona, -> value { joins(:persona).where("personas.tipo_persona = ?", "#{value}") }
  scope :by_tipo_patrocinador, -> value { where("sponsors.tipo_sponsor ilike ?", "%#{value}%") }

  scope :by_all_attributes, -> value {
    joins(:persona).where("personas.razon_social ilike ?
          OR personas.nombre ilike ?
          OR personas.apellido ilike ?
          OR personas.tipo_persona ilike ?
          OR personas.ci_ruc ilike ?
          OR personas.direccion ilike ?
          OR personas.barrio ilike ?
          OR personas.telefono ilike ?
          OR personas.celular ilike ?
          OR personas.estado_civil ilike ?
          OR personas.correo ilike ?",
                          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%",
                          "%#{value}%", "%#{value}%", "%#{value}%","%#{value}%","%#{value}%","%#{value}%")
  }


  def guardar
    transaction do
      puts "GUARDANDO SPONSOR"
      if !save
        raise ActiveRecord::Rollback
      end
    end
  end


  def info_sponsor
    persona = Persona.find(persona_id)
    if persona.razon_social
      return 'Nombre: ' + persona.razon_social + ' - RUC: ' + persona.ci_ruc
    else
      return 'Nombre: ' + persona.nombre + ' ' + persona.apellido + ' - RUC: ' + persona.ci_ruc
    end
  end

  def id_persona
    return persona_id
    #return persona.id
  end

  def pagado
    if !contactos.empty?
      resultados = []
      sumaRecibido = 0
      contactos.map do |contacto|
        if !contacto.contacto_detalles.empty?
          contactosAnhoActual = contacto.contacto_detalles.where('extract(year from fecha) = ?', Time.now.year)
          puts "contactosAnhoActual #{contactosAnhoActual.to_yaml}"
          if !contactosAnhoActual.empty?
            contacto_detalles_monedas = contactosAnhoActual.group_by(&:moneda_id)
            contacto_detalles_monedas.map do |k,v|
              v.map do |contacto_detalle|
                if !contacto_detalle.compromiso.nil?
                  if contacto_detalle.estado.eql? "Recibido"
                    sumaRecibido = contacto_detalle.compromiso + sumaRecibido
                  end
                end
              end
              resultados.push([sumaRecibido.to_s + " " + v.first.moneda.simbolo ])
              sumaRecibido = 0
            end
          end
        end
      end
      return resultados.join(' - ')
    end
  end

  def comprometido
    if !contactos.empty?
      resultados = []
      sumaComprometido = 0
      contactos.map do |contacto|
        if !contacto.contacto_detalles.empty?
          contactosAnhoActual = contacto.contacto_detalles.where('extract(year from fecha) = ?', Time.now.year)
          puts "contactosAnhoActual #{contactosAnhoActual.to_yaml}"
          if !contactosAnhoActual.empty?
            contacto_detalles_monedas = contactosAnhoActual.group_by(&:moneda_id)
            contacto_detalles_monedas.map do |k,v|
              v.map do |contacto_detalle|
                if !contacto_detalle.compromiso.nil?
                  if contacto_detalle.estado.eql? "Comprometido"
                    sumaComprometido = contacto_detalle.compromiso + sumaComprometido
                  end
                end
              end
              resultados.push([sumaComprometido.to_s + " " + v.first.moneda.simbolo ])
              sumaComprometido = 0
            end
          end
        end
      end
      return resultados.join(' - ')
    end
  end

  def razon_social
    persona = Persona.find(persona_id)
    if persona.razon_social
      return persona.razon_social
    else
      return persona.nombre + ' ' + persona.apellido
    end
  end

  def ci_ruc
    persona = Persona.find(persona_id)
    if persona.ci_ruc
      return persona.ci_ruc
    end
  end

end
