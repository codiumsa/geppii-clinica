class Consulta < ActiveRecord::Base
  belongs_to :colaborador
  belongs_to :especialidad
  belongs_to :paciente

  has_many :consulta_detalles, :dependent => :destroy

  validates :paciente, presence: true
  validates :especialidad, presence: true
  validates :fecha_agenda, presence: true


  scope :by_especialidad, -> value { includes(:especialidad).where("especialidades.codigo ilike ?","#{value}") }
  scope :by_nro_ficha, -> value { where("nro_ficha = ?",value) }
  scope :by_fecha_agenda_after, -> after{ where("fecha_agenda::date > ?", Date.parse(after)) }
  scope :by_fecha_agenda_before, -> before{ where("fecha_agenda::date < ?", Date.parse(before)) }
  scope :by_fecha_agenda_on, -> on{ where("fecha_agenda::date = ?", Date.parse(on)) }
  scope :descarta_cancelado, -> value { where("estado != ?",'CANCELADO') }
  scope :by_especialidad_id, -> value {where("especialidad_id = ?", value)}
  scope :by_paciente_id, -> value {where("paciente_id = ?", value)}
  scope :by_all_attributes, -> value {
    joins(:especialidad).joins(:paciente => :persona).where("
          especialidades.codigo ilike ?
          OR especialidades.descripcion ilike ?
          OR personas.nombre ilike ?
          OR personas.ci_ruc ilike ?",
          "%#{value}%",
          "%#{value}%",
          "%#{value}%",
          "%#{value}%")
  }
  scope :by_estado, -> value { select(:especialidad_id, :paciente_id, 'min(fecha_agenda) as fecha_agenda').where("estado ilike ?", "#{value}").group(:especialidad_id, :paciente_id) }
  scope :by_estado_actual, -> value { where("estado ilike ?", "#{value}")}


end
