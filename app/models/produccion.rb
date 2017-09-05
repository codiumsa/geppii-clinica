class Produccion < ActiveRecord::Base
  belongs_to :producto
  belongs_to :deposito
  has_many :produccion_detalles, :dependent => :destroy

end
