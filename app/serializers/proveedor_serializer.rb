class ProveedorSerializer < ActiveModel::Serializer
  attributes :id, :razon_social, :ruc, :direccion, :telefono, :email, :persona_contacto, :telefono_contacto,:info_proveedor
end
