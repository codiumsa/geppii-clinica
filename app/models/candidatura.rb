class Candidatura < ActiveRecord::Base
  belongs_to :paciente
  belongs_to :especialidad
  belongs_to :colaborador
  belongs_to :campanha



  scope :by_fecha_posible_before, -> before{ where("fecha_posible::date < ?", Date.parse(before)) }
  scope :by_fecha_posible_on, -> on { where("fecha_posible::date = ?", Date.parse(on)) }
  scope :by_fecha_posible_after, -> after { where("fecha_posible::date > ?", Date.parse(after)) }
  scope :by_campanha_id, -> campanha_id { where("campanha_id = ?", "#{campanha_id}")}
  scope :by_excluye_campanhas, -> value { where("clinica = ?", value)}


end
