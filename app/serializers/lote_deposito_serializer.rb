class LoteDepositoSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :descripcion, :lote_id_aux
  has_one :lote, embed: :id, include: false
  has_one :deposito, embed: :id, include: false
  has_one :contenedor, embed: :id, include: false
  
end
