# encoding: utf-8
# == Schema Information
#
# Table name: clientes
#
#  id                      :integer          not null, primary key
#  persona_id              :integer
#  numero_cliente          :integer
#  created_at              :datetime
#  updated_at              :datetime
#  activo                  :boolean          default(TRUE)
#  calificacion_id         :integer
#  antiguedad              :float
#  salario_mensual         :float
#  matricula_nro           :string(255)
#  ramo                    :string(255)
#  otros_ingresos          :float
#  empleador               :string(255)
#  pariente1               :string(255)
#  pariente2               :string(255)
#  ingreso_pariente2       :float
#  domicilio               :string(255)
#  cargo                   :string(255)
#  telefono                :string(255)
#  jubilado                :string(255)
#  institucion             :string(255)
#  comerciante             :string(255)
#  empleado                :boolean
#  profesion               :string(255)
#  actividad_empleador     :string(255)
#  direccion_empleador     :string(255)
#  ciudad_id               :integer
#  barrio_empleador        :string(255)
#  fecha_pago_sueldo       :date
#  concepto_otros_ingresos :string(255)
#  ips                     :boolean
#

class Cliente < ActiveRecord::Base
  belongs_to :persona, autosave: true
  belongs_to :calificacion
  belongs_to :ciudad

  has_many :prestamos, dependent: :destroy
  has_many :referencias, :dependent => :destroy
  has_many :documentos, :dependent => :destroy
  has_many :ingreso_familiares, :class_name => 'IngresoFamiliar', :dependent => :destroy, :foreign_key => 'cliente_id'

  accepts_nested_attributes_for :persona

  validate :must_have_persona

  attr_accessor :info_cliente
  attr_accessor :razon_social_cliente
  attr_accessor :id_persona

  default_scope { where(:activo => true).order(numero_cliente: :asc) }

  scope :by_all_attributes, -> value { joins(:persona).where("personas.razon_social ilike ?
          OR personas.nombre ilike ?
          OR personas.apellido ilike ?
          OR personas.tipo_persona ilike ?
          OR personas.ci_ruc ilike ?
          OR personas.direccion ilike ?
          OR personas.barrio ilike ?
          OR personas.telefono ilike ?
          OR personas.celular ilike ?
          OR personas.estado_civil ilike ?
          OR personas.correo ilike ?
          OR to_char(antiguedad, '999D99S') ilike ?
          OR matricula_nro ilike ?
          OR ramo ilike ?
          OR to_char(numero_cliente, '9999999999') ilike ?",
                                                             "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%","%#{value}%","%#{value}%","%#{value}%","%#{value}%","%#{value}%","%#{value}%","%#{value}%")
                                       }

  scope :by_numero_cliente, ->value{ where("numero_cliente = ?", "#{value}") }
  scope :by_id, -> value{ where("id = ?", "#{value}") }
  scope :by_ciRuc, -> value{ joins(:persona).where("personas.ci_ruc = ?", "#{value}" )}
  scope :by_razon_social, -> value{ joins(:persona).where("personas.razon_social ilike ? ", "%#{value}%" )}
  scope :by_nombre, -> value{ joins(:persona).where("personas.nombre ilike ? ", "%#{value}%" )}
  scope :by_apellido, -> value{ joins(:persona).where("personas.apellido ilike ? ", "%#{value}%" )}
  scope :ignorar_cliente_default, -> value{where("numero_cliente <> 0")}
  scope :by_sexo, -> value{ joins(:persona).where("personas.sexo = ?", "#{value}" )}
  scope :by_tipo_persona, -> value{ joins(:persona).where("personas.tipo_persona = ?", "#{value}" )}
  scope :by_estado_civil, -> value{ joins(:persona).where("personas.estado_civil = ?", "#{value}" )}
  scope :by_nacionalidad, -> value{ joins(:persona).where("personas.nacionalidad = ?", "#{value}" )}
  scope :by_numero_hijos, -> value{ joins(:persona).where("personas.numero_hijos = ?", "#{value}" )}
  scope :by_estudios_realizados, -> value{ joins(:persona).where("personas.estudios_realizados = ?", "#{value}" )}
  scope :by_ciudad, -> value{ joins(:persona).where("personas.ciudad_id = ?", "#{value}" )}
  scope :by_calificacion, -> value{ joins(:calificacion).where("calificaciones.codigo = ?", "#{value}" )}
  scope :by_barrio, -> value{ joins(:persona).where("personas.barrio = ?", "#{value}" )}
  scope :by_es_empleado, -> value{ where("empleado = ?", "#{value}" )}
  scope :by_antiguedad, -> value{ where("empleado = ?", "#{value}" )}
  scope :by_fecha_nacimiento_before, -> before{ joins(:persona).where("personas.fecha_nacimiento::date <= ?", Date.parse(before)) }
  scope :by_fecha_nacimiento_on, -> on { joins(:persona).where("personas.fecha_nacimiento::date = ?", Date.parse(on)) }
  scope :by_fecha_nacimiento_after, -> after { joins(:persona).where("personas.fecha_nacimiento::date >= ? ", Date.parse(after)) }
  scope :by_profesion, -> value{ where("profesion = ?", "#{value}" )}
  scope :by_cargo, -> value{ where("cargo = ?", "#{value}" )}
  scope :by_fecha_pago_sueldo_before, -> before{ where("fecha_pago_sueldo::date <= ?", Date.parse(before)) }
  scope :by_fecha_pago_sueldo_on, -> on { where("fecha_pago_sueldo::date = ?", Date.parse(on)) }
  scope :by_fecha_pago_sueldo_after, -> after { where("fecha_pago_sueldo::date >= ? ", Date.parse(after)) }
  scope :by_salario_mensual, -> value{ where("salario_mensual = ?", "#{value}" )}
  scope :by_search_input, -> value{joins(:persona).where("personas.nombre ilike ? OR personas.apellido ilike ? OR personas.razon_social ilike ? OR personas.ci_ruc = ?", "%#{value}%", "%#{value}%","%#{value}%","#{value}")}
  scope :by_estado_vencida, -> { joins(:prestamos => :cuotas).where("cuotas.fecha_vencimiento::date < ?", DateTime.now.to_date )}

  scope :by_fecha_vencimiento_cuota_before, -> before{ joins(:prestamos => :cuotas).where("cuotas.fecha_vencimiento::date <= ?", Date.parse(before)) }
  scope :by_fecha_vencimiento_cuota_on, -> on { joins(:prestamos => :cuotas).where("cuotas.fecha_vencimiento::date = ?", Date.parse(on)) }
  scope :by_fecha_vencimiento_cuota_after, -> after { joins(:prestamos => :cuotas).where("cuotas.fecha_vencimiento::date >= ?", Date.parse(after)) }

  scope :by_dias_atraso_eq, ->value{
    joins(:prestamos => :cuotas).
  where("fecha_vencimiento::date < ? and cuotas.estado <> 'PAGADA' and cuotas.dias_atraso = ?", DateTime.now.to_date, "#{value}") }
  scope :by_dias_atraso_gt, ->value{
    joins(:prestamos => :cuotas).
  where("fecha_vencimiento::date < ? and cuotas.estado <> 'PAGADA' and cuotas.dias_atraso > ?", DateTime.now.to_date, "#{value}") }
  scope :by_dias_atraso_lt, ->value{
    joins(:prestamos => :cuotas).
  where("fecha_vencimiento::date < ? and cuotas.estado <> 'PAGADA' and cuotas.dias_atraso < ?", DateTime.now.to_date, "#{value}") }

  scope :by_fecha_ingreso_informconf_before, -> before{ where("fecha_ingreso_informconf::date <= ?", Date.parse(before)) }
  scope :by_fecha_ingreso_informconf_on, -> before{ where("fecha_ingreso_informconf::date = ?", Date.parse(before)) }
  scope :by_fecha_ingreso_informconf_after, -> before{ where("fecha_ingreso_informconf::date >= ?", Date.parse(before)) }

  scope :by_fecha_egreso_informconf_before, -> before{ where("fecha_egreso_informconf::date <= ?", Date.parse(before)) }
  scope :by_fecha_egreso_informconf_on, -> before{ where("fecha_egreso_informconf::date = ?", Date.parse(before)) }
  scope :by_fecha_egreso_informconf_after, -> before{ where("fecha_egreso_informconf::date >= ?", Date.parse(before)) }


  def info_cliente
    persona = Persona.find(persona_id)
    if persona.razon_social
      return 'Nombre: ' + persona.razon_social + ' - RUC: ' + persona.ci_ruc
    else
      return 'Nombre: ' + persona.nombre + ' ' + persona.apellido + ' - RUC: ' + persona.ci_ruc
    end
  end

  def id_persona
    persona = Persona.find(persona_id)
    return persona.id
  end

  def razon_social_cliente
    persona = Persona.find(persona_id)
    if persona.razon_social
      return persona.razon_social
    else
      return persona.nombre + ' ' + persona.apellido
    end
  end

  def self.find_by_ruc(ciruc)
    clientes = Cliente.find(:all)
    clientes.map do |cliente|
      cliente.to_yaml
      if cliente.persona.ci_ruc == ciruc
        return cliente
      end
    end
  end


  def must_have_persona()
    puts "VALIDANDO PERSONA...."
    if persona.direccion.nil? or persona.direccion.to_s == ""
      errors.add('persona.direccion', 'Ingrese una dirección')
    end
    if persona.barrio.nil? or persona.barrio.to_s == ""
      errors.add('persona.barrio', 'Ingrese un barrio')
    end

    #validates_presence_of :fecha_nacimiento, :message => "Ingrese una fecha de nacimiento"
    #validates_presence_of :direccion, :message => "Ingrese una dirección"
    #validates_presence_of :barrio, :message => "Ingrese un barrio"
    #validates_presence_of :direccion, :message => "Ingrese una dirección"
    #validates_presence_of :barrio, :message => "Ingrese un barrio"
  end

  def self.actualizar_calificaciones
    puts 'Actualizando calificaciones'
    enviado = false
    transaction do
      begin
        Cliente.find_each do |cliente|
          ultimo_prestamo = Prestamo.ultimo_prestamo(cliente)
          atraso_promedio = 0.0

          if not ultimo_prestamo.nil?
            atraso_total = ultimo_prestamo.cuotas.reduce(0.0) do |sum, cuota|
              sum + cuota.dias_atraso
            end
            atraso_promedio = atraso_total / ultimo_prestamo.cuotas.length
          end
          cliente.calificacion = Calificacion.get_calificacion(atraso_promedio)
          cliente.save!
        end
      rescue
        puts "Enviando correo electrónico..."
        ProcessNotifier.process_notifier_mail("Actualización de Calificaciones de Cliente", "Error al actualizar calificaciones")
        enviado=true
      end
    end
    if not enviado
      puts "Enviando correo electrónico..."
      ProcessNotifier.process_notifier_mail("Actualización de Calificaciones de Cliente", nil)
    end
  end

  def self.enviar_correo
    ProcessNotifier.process_notifier_mail("prueba_envio correos").deliver!
  end

  def guardar
    transaction do

      if !save
        raise ActiveRecord::Rollback
      end

      referencias.each do |ref|
        ref.save!
      end

      ingreso_familiares.each do |ing|
        ing.save!
      end

      documentos.each do |doc|
        doc.save!
      end
    end
  end

  def informconf
    informconf = 'No'
    if not self.fecha_ingreso_informconf.nil?
      if not self.fecha_egreso_informconf.nil?
        if self.fecha_egreso_informconf < Time.now
          informconf = 'No'
        else
          informconf = 'Si'
        end
      else
        informconf = 'Si'
      end
    end
    informconf
  end
end
