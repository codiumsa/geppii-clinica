class Paciente < ActiveRecord::Base
  belongs_to :persona, autosave: true
  has_many :candidaturas, :dependent => :destroy
  has_many :ficha_cirugias, dependent: :destroy
  has_many :ventas, through: :persona, dependent: :destroy
  has_many :venta_detalles, through: :ventas, dependent: :destroy
  accepts_nested_attributes_for :persona
  validates :numero_paciente, uniqueness: true


  attr_accessor :info_paciente, :anhos

  #Default scope filters only active patients
  default_scope { where(:activo => true).order(numero_paciente: :asc) }
  scope :by_all_attributes, -> value { joins(:persona).where("
          personas.nombre ilike ?
          OR personas.apellido ilike ?
          OR personas.tipo_persona ilike ?
          OR personas.ci_ruc ilike ?
          OR personas.direccion ilike ?
          OR personas.barrio ilike ?
          OR personas.telefono ilike ?
          OR personas.celular ilike ?
          OR to_char(numero_paciente, '9999999999') ilike ?",
          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%",
          "%#{value}%", "%#{value}%", "%#{value}%","%#{value}%")
                                       }
  scope :by_persona, -> value { joins(:persona).where("personas.nombre like ? or personas.apellido ilike ? or personas.razon_social ilike ?", "%#{value}%","%#{value}%","%#{value}%" )}
  scope :by_nombre, -> value{ joins(:persona).where("personas.nombre like ? ", "%#{value}%" )}
  scope :by_apellido, -> value{ joins(:persona).where("personas.apellido like ? ", "%#{value}%" )}
  scope :by_sexo, -> value{ joins(:persona).where("personas.sexo = ?", "#{value}" )}
  scope :by_tipo_persona, -> value{ joins(:persona).where("personas.tipo_persona = ?", "#{value}" )}
  scope :by_nacionalidad, -> value{ joins(:persona).where("personas.nacionalidad = ?", "#{value}" )}
  scope :by_persona_id, -> persona_id {where("persona_id = ?", persona_id )}
  scope :by_numero_paciente, -> value {where("numero_paciente = ?", value )}
  scope :by_id, -> value {where("id = ?", value )}
  scope :by_fecha_registro_before, -> before{ where("created_at::date < ?", Date.parse(before)) }
  scope :by_fecha_registro_on, -> on{ where("created_at::date = ?", Date.parse(on)) }
  scope :by_fecha_registro_after, -> after{ where("created_at::date > ?", Date.parse(after)) }
  scope :by_fecha_modificacion_before, -> before{ where("updated_at::date < ?", Date.parse(before)) }
  scope :by_fecha_modificacion_on, -> on{ where("updated_at::date = ?", Date.parse(on)) }
  scope :by_fecha_modificacion_after, -> after{ where("updated_at::date > ?", Date.parse(after)) }
  scope :by_fecha_consulta_before, -> before{ includes(:consultas).where("consultas.fecha_agenda::date > ? and consultas.estado = 'ATENDIDO'", Date.parse(before)) }
  scope :by_fecha_consulta_on, -> on{ includes(:consultas).where("consultas.fecha_agenda::date > ? and consultas.estado = 'ATENDIDO'", Date.parse(on)) }
  scope :by_fecha_consulta_after, -> after{ includes(:consultas).where("consultas.fecha_agenda::date > ? and consultas.estado = 'ATENDIDO'", Date.parse(after)) }
  scope :by_tratamiento, -> value{ includes(:ficha_cirugias).where("fichas_cirugia.estado = 'VIGENTE' and fichas_cirugia.tratamientos_realizados @> '{\"tratamientos\":[{\"nombre\":\"#{value}\"}]}'") }
  scope :by_medicamento, -> value{ includes(:venta_detalles).where("venta_detalles.producto_id = ?", value) }

  def info_paciente
    personas = Persona.all
    if personas.length > 0
      persona = Persona.find(persona_id)
      if persona.razon_social
        return persona.razon_social
      end
    end
  end

  def anhos
    if !persona.fecha_nacimiento.nil?
      bd = persona.fecha_nacimiento.to_date
      d = Date.today
      if !bd.nil?
        # Difference in years, less one if you have not had a birthday this year.
        a = d.year - bd.year
        a = a - 1 if (
          bd.month >  d.month or
          (bd.month >= d.month and bd.day > d.day)
        )
        a
      end
    end
  end

  def self.get_next_nro_paciente()
    self.find_by_sql "select nextval('paciente_nro_paciente_sec') as numero_paciente;"
  end
  def self.get_next_nro_ficha()
    self.find_by_sql "select nextval('nro_ficha_sec') as nro_ficha;"
  end
end
