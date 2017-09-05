# encoding: utf-8
# == Schema Information
#
# Table name: calificaciones
#
#  id          :integer          not null, primary key
#  codigo      :string(255)
#  descripcion :string(255)
#  dias_atraso :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Calificacion < ActiveRecord::Base
	#id, codigo, descripcion, dias_atraso
  scope :by_codigo, ->codigo { where("codigo = :codigo",  codigo).order('dias_atraso ASC') }
  scope :unpaged, -> { order("descripcion") }
  validates :codigo, :descripcion, presence: true
	validates :codigo, uniqueness: {message: :codigo_taken}
	validates :descripcion, uniqueness: {message: :descripcion_taken}
	validates :dias_atraso, uniqueness: {message: :dias_atraso_taken}
	
  scope :by_all_attributes, -> value { 
	where("codigo ilike ? OR descripcion ilike ? OR dias_atraso = ?",
        "%#{value}%",
        "%#{value}%",
	      number?(value) ? value.to_i : nil)
	}

  def self.get_calificacion(dias_atraso)
    calificacion = Calificacion.where("dias_atraso >= ?", dias_atraso).order(:dias_atraso).first
    if not calificacion
      calificacion = Calificacion.order(dias_atraso: :desc).first
    end
    return calificacion
  end

	def self.number? (string)
    true if Float(string) rescue false
  end

end
