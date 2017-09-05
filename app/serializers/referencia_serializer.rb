# encoding: utf-8
class ReferenciaSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :telefono, :tipo_referencia, :tipo_cuenta, :activa
end
