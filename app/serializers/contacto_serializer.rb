class ContactoSerializer < ActiveModel::Serializer
  attributes :id, :observacion, :fecha,:compromiso_total,:estado_actual,:compromiso_pagado, :tiene_detalle_in_kind, :compromiso_pagado_in_kind
  has_one :sponsor, embed: :id, include: false
  has_one :tipo_contacto, embed: :id, include: false
  has_one :campanha, embed: :id, include: false
  has_many :contacto_detalles, embed: :id, include: false

end
