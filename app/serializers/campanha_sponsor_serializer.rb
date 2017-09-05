class CampanhaSponsorSerializer < ActiveModel::Serializer
  attributes :id
  has_one :sponsor, embed: :id, include: false
  has_one :campanha, embed: :id, include: false
end
