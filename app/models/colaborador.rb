class Colaborador < ActiveRecord::Base
  belongs_to :persona, autosave: true
  belongs_to :tipo_colaborador
  belongs_to :especialidad
  #has_and_belongs_to_many :campanhas
  has_many :campanhas_colaboradores, :class_name => 'CampanhaColaborador', dependent: :destroy
  #has_many :campanhas, through: :campanhas_colaboradores, autosave: :true

  accepts_nested_attributes_for :persona

  validates :persona_id, uniqueness: true, uniqueness: {message: :persona_colaborador_taken}
  scope :by_persona, -> persona {joins(:persona).where("(personas.razon_social ilike ? or personas.nombre ilike ? or personas.apellido ilike ?) and activo = true", "%#{persona}%","%#{persona}%","%#{persona}%" )}
  scope :by_persona_id, -> persona_id {where("persona_id = ?", persona_id )}
  scope :by_tipo_colaborador_id, -> tipo_colaborador_id {where("tipo_colaborador_id = ?", tipo_colaborador_id)}
  scope :by_especialidad_id, -> value {where("especialidad_id = ?", value)}
  scope :by_activo, -> value {where("activo = ?", value)}
  scope :by_cirujano, -> value {joins(:especialidad).joins(:tipo_colaborador).where("especialidades.codigo ilike ? AND tipo_colaboradores.nombre ilike ? and activo = true", "CIR","Doctor")}
  scope :by_colaborador_id, -> value {where("id = ?", value)}
  scope :by_all_attributes, -> value { joins(:persona).includes(:especialidad).includes(:tipo_colaborador).where("
          personas.nombre ilike ?
          OR personas.apellido ilike ?
          OR personas.tipo_persona ilike ?
          OR personas.ci_ruc ilike ?
          OR personas.direccion ilike ?
          OR personas.barrio ilike ?
          OR personas.telefono ilike ?
          OR personas.celular ilike ?
          OR especialidades.descripcion ilike ?
          OR tipo_colaboradores.nombre ilike ?","%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%",
          "%#{value}%", "%#{value}%", "%#{value}%","%#{value}%","%#{value}%")}

  attr_accessor :razon_social

  def razon_social
    if(!persona.razon_social.nil?)
      return "#{persona.razon_social}"
    end
  end

  def nombre_especialidad
    if especialidad.nil?
      return "Sin Especialidad"
    else
      return especialidad.descripcion
    end
  end

end
