class TipoCampanha < ActiveRecord::Base
  scope :unpaged, -> { order("id") }
  
  scope :by_all_attributes, -> value { where("descripcion ilike ? OR nombre ilike ?", 
    "%#{value}%", "%#{value}%")}
end
