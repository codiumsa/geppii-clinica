class MedioPago < ActiveRecord::Base
  belongs_to :tarjeta
  validates :nombre, :codigo, presence: true
  validates :nombre, uniqueness: {message: :nombre_medio_pago_taken}
  validates :codigo, uniqueness: {message: :codigo_medio_pago_taken}

  scope :unpaged, -> { order("id") }
  scope :by_activo, ->activo { where("activo=?", "#{activo}") }
  scope :by_nombre, -> nombre { where("nombre like ?", "%#{nombre}%") }
	scope :by_codigo, -> codigo { where("codigo like ?", "%#{codigo}%") }
  scope :by_all_attributes, -> value { 
    where("codigo ilike ? OR id ilike ? OR nombre like ?", "%#{value}%", "%#{value}%", "%#{value}%")
  }

  default_scope order("id ASC")

  def eliminar
    transaction do
      begin
        destroy
      rescue ActiveRecord::InvalidForeignKey
        self.errors[:base] << "El medio de pago ya fue utilizado"
      end
    end
  end

end
