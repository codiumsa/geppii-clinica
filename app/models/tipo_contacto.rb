# encoding: utf-8
# == Schema Information
#
# Table name: tipo_contactos
#
#  id            :integer          not null, primary key
#  codigo        :string(255)
#  descripcion   :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  con_prestamo  :boolean
#  con_cuota     :boolean
#  con_solicitud :boolean
#  activo        :boolean
#

class TipoContacto < ActiveRecord::Base
  has_many :contactos, dependent: :destroy

  validates :descripcion, :codigo, presence: true

  scope :unpaged, -> { order("codigo") }
  scope :by_activo, -> { where("activo = true") }

  scope :by_all_attributes, -> value { 
  where("descripcion ilike ? OR codigo ilike ?", 
          "%#{value}%", "%#{value}%")
  }

  def eliminar
    transaction do
      write_attribute(:activo, false)
      save
    end
  end
end
