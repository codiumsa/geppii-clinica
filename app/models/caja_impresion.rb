class CajaImpresion < ActiveRecord::Base
    has_many :impresoras, dependent: :destroy
    
    validates :nombre, presence: true
    scope :by_nombre, -> nombre { where("nombre like ?", "%#{nombre}%") }
    
end
