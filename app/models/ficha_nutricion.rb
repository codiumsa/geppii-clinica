class FichaNutricion < ActiveRecord::Base
  belongs_to :paciente
  scope :paciente_id, -> value{where("paciente_id = ?", "#{value}" ).order(created_at: :desc).limit(1)}

  attr_accessor :consulta_id
  
end
