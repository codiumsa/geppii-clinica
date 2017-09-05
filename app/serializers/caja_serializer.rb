class CajaSerializer < ActiveModel::Serializer
	attributes :id, :codigo, :descripcion, :tipo_caja, :saldo, :abierta, :limite_alivio, :necesita_alivio
  has_one :sucursal, embed: :id, include: false
  has_one :moneda,embed: :id, include:false
  has_one :usuario,embed: :id, include:false

end
