class ProcesoDetalle < ActiveRecord::Base
  belongs_to :proceso, :class_name => 'Proceso'
  belongs_to :producto
  scope :ids, lambda { |id| where(:id => id) }
end
