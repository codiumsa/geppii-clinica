class TipoCredito < ActiveRecord::Base
  has_many :compras, dependent: :destroy
  has_many :ventas, dependent: :destroy

  validates :descripcion, :plazo, :unidad_tiempo, presence: true

  def self.unidades 
    {"D" => 1.day,
     "W" => 1.week,
     "M" => 1.month
    }
  end

  #ver para mejorar esto
  scope :by_contado, -> { where("descripcion = 'Contado'") }
  scope :by_credito, -> { where("descripcion != 'Contado'") }
  scope :unpaged, -> { order("id") }
  
  scope :by_all_attributes, -> value { 
  where("descripcion ilike ? OR unidad_tiempo ilike ?", 
          "%#{value}%", "%#{value}%")
  }
    
end
