class TipoProducto < ActiveRecord::Base
    validates :descripcion, presence: true
    validates :codigo, presence: true


    scope :by_descripcion, -> descripcion { where("descripcion ilike ?", "#{descripcion}") }
    scope :by_codigo, -> codigo { where("codigo ilike ?", "#{codigo}") }
    scope :by_all_attributes, -> value { where("codigo ilike ? OR descripcion ilike ?", "%#{value}%", "%#{value}%") }

    

end
