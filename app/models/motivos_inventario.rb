class MotivosInventario < ActiveRecord::Base
  validates :codigo, :descripcion, presence: true


end
