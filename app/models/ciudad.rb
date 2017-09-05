# encoding: utf-8
# == Schema Information
#
# Table name: ciudades
#
#  id         :integer          not null, primary key
#  codigo     :string(255)
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Ciudad < ActiveRecord::Base
  scope :unpaged, -> { order("nombre") }
  scope :by_id, -> value{ where("id = ?", "#{value}") }
  scope :by_codigo, -> value{ where("codigo = ?", "#{value}") }
  scope :by_nombre, -> value{ where("nombre ilike ?", "%#{value}%")}
end
