# encoding: utf-8
# == Schema Information
#
# Table name: vinculo_familiares
#
#  id         :integer          not null, primary key
#  tipo       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class VinculoFamiliar < ActiveRecord::Base
  
  scope :unpaged, -> { order("tipo") }
  scope :by_id, -> value{ where("id = ?", "#{value}") }
end
