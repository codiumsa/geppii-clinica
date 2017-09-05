class Especialidad < ActiveRecord::Base

  scope :by_descripcion, -> descripcion { where("especialidades.descripcion ilike ?", "%#{descripcion}%") }
  scope :habilita_consulta, -> value { where("habilita_consulta = ?", value)}


end
