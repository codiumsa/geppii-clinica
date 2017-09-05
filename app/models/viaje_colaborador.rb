class ViajeColaborador < ActiveRecord::Base
  belongs_to :viaje
  belongs_to :colaborador

end
