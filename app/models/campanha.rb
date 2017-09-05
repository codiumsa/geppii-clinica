class Campanha < ActiveRecord::Base
  belongs_to :persona
  belongs_to :tipo_campanha
  #has_and_belongs_to_many :colaboradores
  #has_many :campanhas_colaboradores, :class_name => 'CampanhaColaborador'
  has_many :campanhas_colaboradores, :dependent => :destroy, :class_name => 'CampanhaColaborador'
  #has_many :colaboradores, through: :campanhas_colaboradores, autosave: :true


  scope :by_colaborador_id, -> colaborador_id {joins(:campanhas_colaboradores).where("campanhas_colaboradores.colaborador_id = ? and activo = true", colaborador_id)}
  scope :by_id, -> id { where("id = ?", id ) }
  scope :by_persona_id, -> persona_id {where("persona_id = ?", "#{persona_id}" )}
  scope :by_tipo_campanha, -> tipo_campanha {joins(:tipo_campanha).where("tipo_campanhas.nombre ilike ? and activo = true","#{tipo_campanha}")}
  scope :by_tipo_conctacto, -> tipo_contacto_id {where("tipo_campanha_id = ? and activo = true","#{tipo_campanha}")}
  scope :by_activo, -> value {where("activo = ?","#{value}")}
  scope :by_tipo_mision, -> value {joins(:tipo_campanha).where("tipo_campanhas.nombre ilike ? and  activo = true", "Misión")}
  scope :by_tipo_mision_especifica, -> value {joins(:tipo_campanha).where("tipo_campanhas.nombre ilike ? and campanhas.nombre ilike ? and activo = true", "Misión", "%#{value}%")}
  scope :by_vigente, -> value{ where("? between fecha_incio AND fecha_fin and activo = true", Date.today) }
  scope :by_descripcion, -> value{ joins(:tipo_campanha).where("tipo_campanhas.nombre ilike ? OR campanhas.nombre ilike ? and activo = true",  "%#{value}%",  "%#{value}%") }
  scope :by_nombre, -> value { where("campanhas.nombre ilike ?", "%#{value}%") }

  scope :by_all_attributes, -> value { includes(:tipo_campanha).where("activo = true and (campanhas.nombre ilike ? or campanhas.descripcion ilike ? or tipo_campanhas.nombre ilike ?)","%#{value}%","%#{value}%", "%#{value}%") }

  def self.by_tipo_contacto(tipo_contacto_id)
    tipo_contacto = TipoContacto.find(tipo_contacto_id)
    if (tipo_contacto.con_campanha)
      return Campanha.by_tipo_campanha(Settings.campanha.tipo_campanha)
    end
    if(tipo_contacto.con_mision)
      return Campanha.by_tipo_campanha(Settings.campanha.tipo_mision)
    end
  end
end
