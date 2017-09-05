class VentaMedioSerializer < ActiveModel::Serializer
    attributes :id, :monto
    has_one :venta, embed: :id, include: false
    has_one :tarjeta, embed: :id, include: false
    has_one :medio_pago, embed: :id, include: false
end