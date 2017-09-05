class ConsultaDetalle < ActiveRecord::Base
  belongs_to :consulta
  belongs_to :producto

  scope :ids, lambda { |id| where(:id => id) }

end
