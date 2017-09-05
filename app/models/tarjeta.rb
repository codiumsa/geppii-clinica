class Tarjeta < ActiveRecord::Base
  
  belongs_to :medio_pago
  has_many :promociones, dependent: :destroy
  validates :banco, :marca, :afinidad, :medio_pago, presence: true
  validates :banco, :uniqueness => {:scope => [:marca, :afinidad], :message => :tarjeta_combinacion}
  scope :unpaged, -> { order("banco") }
  scope :by_banco, -> banco { where("banco like ?", "%#{banco}%") }
  scope :by_marca, -> marca { where("marca like ?", "%#{marca}%") }
  scope :by_afinidad, -> afinidad { where("afinidad like ?", "%#{afinidad}%") }
  scope :by_activo, ->activo { where("tarjetas.activo=?", "#{activo}") }
  scope :by_all_attributes, -> value { 
    where("marca ilike ? OR banco like ? OR afinidad ilike ?", "%#{value}%", "%#{value}%", "%#{value}%")
  }

  scope :by_codigo_medio_pago, -> codigo { joins(:medio_pago).where("medio_pagos.codigo = ?", codigo) }
end
