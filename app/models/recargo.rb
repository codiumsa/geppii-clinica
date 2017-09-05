class Recargo < ActiveRecord::Base
	belongs_to :tipo_credito
	belongs_to :medio_pago

	validates :cantidad_cuotas, :interes, presence: true

	scope :by_medio_pago, -> medio_pago_id { where("medio_pago_id = ?", medio_pago_id) }
	scope :by_tipo_credito, -> tipo_credito_id { where("tipo_credito_id = ?", tipo_credito_id) }
	scope :by_cantidad_cuotas, -> cantidad_cuotas { where("cantidad_cuotas >= ?", cantidad_cuotas) }
	scope :unpaged, -> { order("cantidad_cuotas ASC") }

	scope :by_all_attributes, -> value { joins(:tipo_credito).joins(:medio_pago).
    where("tipo_creditos.descripcion ilike ? OR medio_pagos.nombre ilike ? OR to_char(cantidad_cuotas, '999') ilike ?" ,
          "%#{value}%", "%#{value}%", "%#{value}%")
  }
end
