class Moneda < ActiveRecord::Base

	validates :nombre, :simbolo, presence: true
	validates :nombre, uniqueness: true

	scope :by_activo, -> { where("anulado = false") }
		
	scope :by_all_attributes, -> value { 
    where("nombre ilike ? OR simbolo ilike ?", 
          "%#{value}%", "%#{value}%")
  	}

	def eliminar
	    transaction do
	      self.anulado = true
	      deleted_at = Time.now
	      save
	      if !self.errors[:base].empty?
	        raise ActiveRecord::Rollback
	      end
	    end
  	end
end
