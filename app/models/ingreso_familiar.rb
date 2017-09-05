class IngresoFamiliar < ActiveRecord::Base
  belongs_to :vinculo_familiar
  belongs_to :cliente
end
