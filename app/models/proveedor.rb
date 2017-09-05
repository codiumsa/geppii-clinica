class Proveedor < ActiveRecord::Base
  has_many :compras, dependent: :destroy

  validates :razon_social, :ruc, presence: true
  validates :ruc, uniqueness: {message: :ruc_taken}
  validates :email, email: true, allow_blank: true
  validates :telefono, phone_number: true, allow_blank: true
  validates :telefono_contacto, phone_number: true, allow_blank: true
  attr_accessor :info_proveedor

  scope :by_razon_social, -> razon_social { where("razon_social ilike ?", "%#{razon_social}%") }
  scope :by_ruc, -> ruc { where("ruc ilike ?", "%#{ruc}%") }
  scope :by_all_attributes, -> value {
    where("razon_social ilike ? OR ruc ilike ? OR direccion ilike ? OR telefono ilike ? OR email ilike ? OR persona_contacto ilike ?
      OR telefono_contacto ilike ?",
          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%")
  }

  scope :ignorar_proveedor_default, -> ruc {where("ruc <> '0'")}
  scope :ruc, -> ruc { where("ruc = ?", "#{ruc}") }
  #scope :by_activo, ->activo { where("activo=?", "#{activo}") }
  scope :unpaged, -> { order("razon_social") }


  def info_proveedor
    if razon_social
      return 'Nombre: ' + razon_social + ' - RUC: ' + ruc
    end
  end
  def eliminar
    transaction do
      begin
        destroy
      rescue ActiveRecord::InvalidForeignKey
        self.errors[:base] << "El proveedor ya fue utilizado"
      end
    end
  end

end
