class RecargoSerializer < ActiveModel::Serializer
	has_one :tipo_credito, embed: :id, include: false
	has_one :medio_pago, embed: :id, include: false
  attributes :id, :cantidad_cuotas, :interes
end
