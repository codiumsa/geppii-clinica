class ViajeColaboradorSerializer < ActiveModel::Serializer
  attributes :id, :observacion, :companhia, :costo_ticket, :costo_estadia
  has_one :viaje, embed: :id, include: false
  has_one :colaborador, embed: :id, include: false
end
