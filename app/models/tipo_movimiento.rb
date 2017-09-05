class TipoMovimiento < ActiveRecord::Base
  self.table_name = "tipos_movimiento"
  has_one :tipo_operacion_detalle
  
  scope :by_codigo, -> codigo { where("codigo ilike ?", "#{codigo}") }
end
