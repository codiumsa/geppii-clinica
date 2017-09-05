class CampanhaColaborador < ActiveRecord::Base
  belongs_to :colaborador
  belongs_to :campanha

  scope :ids, lambda { |id| where(:id => id) }
  scope :by_campanha, -> value { where("campanha_id = ?", value) }
  scope :by_colaborador, -> value { where("colaborador_id = ?", value) }

end
