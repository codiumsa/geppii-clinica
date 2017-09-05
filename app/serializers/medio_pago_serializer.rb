class MedioPagoSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :codigo, :registra_pago, :activo
end
