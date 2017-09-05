class MonedaSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :simbolo, :anulado, :redondeo
end
