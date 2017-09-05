class Lote < ActiveRecord::Base
  belongs_to :producto
  has_many :lote_depositos, :dependent => :destroy
  default_scope {includes(:lote_depositos)
                 .includes(:producto)
                 .references(:producto)
                 .references(:lote_depositos)
                 }
  scope :by_codigo, -> codigo { where("codigo_lote like ?", "#{codigo}") }
  scope :by_producto, -> producto { where("lotes.producto_id = ?", producto)}
  scope :by_fecha_vencimiento_before, -> before{ where("fecha_vencimiento::date < ?", Date.parse(before)) }
  scope :by_fecha_vencimiento_on, -> on { where("fecha_vencimiento::date = ?", Date.parse(on)) }
  scope :by_fecha_vencimiento_after, -> after { where("fecha_vencimiento::date > ?", Date.parse(after)) }
  scope :last_lotes, -> producto_id { joins(:producto).where("productos.id = ?", producto_id).order(:created_at).limit(10)}

  def fecha_vencimiento_str
    if !fecha_vencimiento
      return "Sin fecha de Vencimiento"
    end
    fecha_vencimiento.strftime("%d/%m/%Y")
  end

  def eliminar
    transaction do
      begin
        destroy
      rescue ActiveRecord::InvalidForeignKey
        self.errors[:base] << "El lote ya fue utilizado"
      end
    end
  end

  def guardar
    transaction(requires_new: true) do
      if !save
        raise ActiveRecord::Rollback
      end
    end
  end
end
