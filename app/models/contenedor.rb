class Contenedor < ActiveRecord::Base
    
    scope :by_codigo, -> codigo { where("codigo like ?", "%#{codigo}%") }

    def eliminar
        transaction do
          begin
            destroy
          rescue ActiveRecord::InvalidForeignKey
              self.errors[:base] << "El container ya fue utilizado"
          end
        end
    end

end
