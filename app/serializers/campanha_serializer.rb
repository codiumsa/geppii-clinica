class CampanhaSerializer < ActiveModel::Serializer
  attributes :id, :nombre, :descripcion, :fecha_incio, :fecha_fin, :estado
  has_one :persona,embed: :id, include: true
  has_one :tipo_campanha,embed: :id, include: false
	has_many :campanhas_colaboradores, embed: :id, include: false
end
