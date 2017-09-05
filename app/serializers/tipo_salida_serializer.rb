class TipoSalidaSerializer < ActiveModel::Serializer
    attributes :id, :codigo, :descripcion, :muestra_medios_pago
end
