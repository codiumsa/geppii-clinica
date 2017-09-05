class SucursalVendedor < ActiveRecord::Base
  belongs_to :sucursal
  belongs_to :vendedor

  scope :by_vendedor_id, -> vendedor_id { where("vendedor_id = ?", vendedor_id) }
  scope :by_sucursal_id, -> sucursal_id { where("sucursal_id = ?", sucursal_id) }
end
