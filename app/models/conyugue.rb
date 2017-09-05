# == Schema Information
#
# Table name: conyugues
#
#  id                      :integer          not null, primary key
#  nombre                  :string(255)
#  apellido                :string(255)
#  nacionalidad            :string(255)
#  cedula                  :string(255)
#  fecha_nacimiento        :date
#  lugar_nacimiento        :string(255)
#  empleador               :string(255)
#  actividad_empleador     :string(255)
#  cargo                   :string(255)
#  profesion               :string(255)
#  ingreso_mensual         :float
#  concepto_otros_ingresos :string(255)
#  otros_ingresos          :float
#

class Conyugue < ActiveRecord::Base
  scope :by_id, -> value{ where("id = ?", "#{value}") }
end
