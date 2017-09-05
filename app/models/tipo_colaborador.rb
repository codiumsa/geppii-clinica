class TipoColaborador < ActiveRecord::Base
  scope :unpaged, -> { order("id") }
  belongs_to :colaborador
  scope :by_all_attributes, -> value { where("nombre ilike ? or descripcion ilike ?","%#{value}%","%#{value}%")}
end
