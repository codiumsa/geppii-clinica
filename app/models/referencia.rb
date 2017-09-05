# encoding: utf-8
# == Schema Information
#
# Table name: referencias
#
#  id              :integer          not null, primary key
#  nombre          :string(255)
#  telefono        :string(255)
#  tipo_referencia :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  cliente_id      :integer
#  tipo_cuenta     :string(255)
#  activa          :boolean
#

class Referencia < ActiveRecord::Base
  belongs_to :cliente

  scope :by_cliente, -> cliente_id { where("cliente_id = ?", "#{cliente_id}").order("tipo_referencia desc") }
end
