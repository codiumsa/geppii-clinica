class Curso < ActiveRecord::Base

  validates :descripcion, presence: true
  validates :observaciones, presence: true
  validates :observaciones, presence: true
  has_many :curso_colaboradores, :dependent => :destroy

  scope :by_colaborador_id, -> colaborador_id {joins(:curso_colaboradores).where("curso_colaboradores.colaborador_id = ?", colaborador_id)}
  scope :by_descripcion, -> descripcion { where("descripcion ilike ?", "%descripcion%") }
  scope :by_id, -> id { where("id = ?", id ) }
  scope :by_lugar, -> lugar { where("lugar ilike ?", "%#{lugar}%") }
  scope :by_fecha_after, -> after{ where("fecha_inicio::date > ?", Date.parse(after)) }
  scope :by_fecha_before, -> before{ where("fecha_fin::date < ?", Date.parse(before)) }
  scope :by_fecha_on, -> on{ where("fecha_inicio::date = ?", Date.parse(on)) }


end
