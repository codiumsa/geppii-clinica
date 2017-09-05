class TipoOperacionDetalle < ActiveRecord::Base
  belongs_to :tipo_operacion
  belongs_to :tipo_movimiento
  scope :ids, lambda { |id| where(:id => id) }
end
