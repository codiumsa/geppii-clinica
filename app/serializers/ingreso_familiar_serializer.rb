# encoding: utf-8
class IngresoFamiliarSerializer < ActiveModel::Serializer
  attributes :id, :ingreso_mensual
  has_one :cliente
  has_one :vinculo_familiar,embed: :id, include: true
end
