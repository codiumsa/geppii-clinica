class ProduccionDetalle < ActiveRecord::Base
  belongs_to :produccion
  belongs_to :lote
  belongs_to :deposito
  belongs_to :producto

end
