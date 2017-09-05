class SponsorSerializer < ActiveModel::Serializer
  attributes :id, :segmento, :activo, :contacto_nombre, :ci_ruc, :contacto_apellido, :contacto_celular, :contacto_cargo, :contacto_email, :razon_social, :info_sponsor,:comprometido,:pagado, :tipo_sponsor
  has_one :persona, embed: :id, include: true
end
