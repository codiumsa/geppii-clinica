class TransferenciaDeposito < ActiveRecord::Base
  self.table_name = "transferencias_deposito"

  validates :origen, presence: true
  validates :destino, presence: true
  validates :usuario, presence: true

  validates :nro_transferencia, uniqueness: {message: :nro_transferencia_taken, allow_nil: true }

  scope :by_fecha_registro_before, -> before{ where("fecha_registro::date < ?", Date.parse(before)) }
  scope :by_fecha_registro_on, -> on { where("fecha_registro::date = ?", Date.parse(on)) }
  scope :by_fecha_registro_after, -> after { where("fecha_registro::date > ?", Date.parse(after)) }
  scope :by_origen_id, -> origen_id { where("origen_id = ?", "#{origen_id}") }
  scope :by_destino_id, -> destino_id { where("destino_id = ?", "#{destino_id}") }
  scope :by_usuario, -> username {joins(:usuario).where("usuarios.nombre ilike ?", "%#{username}%" )}

  scope :by_origen, -> value { joins(:origen).where('depositos.nombre ilike (?)', value) }
  scope :by_destino, -> value { joins(:destino).where('depositos.nombre ilike (?)', value) }

  scope :by_all_attributes, -> value { joins(:origen).joins(:destino).joins(:usuario).
    where("depositos.nombre ilike ? OR transferencias_deposito.descripcion ilike ? OR nro_transferencia ilike ? OR destinos_transferencias_deposito.nombre ilike ? OR usuarios.nombre ilike ? OR to_char(fecha_registro, 'DD/MM/YYYY') ilike ?" ,
          "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%").references(:depositos).references(:depositos)

  }


  belongs_to :origen, :class_name => 'Deposito'
  belongs_to :destino, :class_name => 'Deposito'
  belongs_to :usuario
  has_many :detalles, :class_name => 'TransferenciaDepositoDetalle', :dependent => :destroy, :foreign_key => 'transferencia_id'

  def save_with_details(sucursal_id)
    transaction do

      if not nro_transferencia
        sucursal = Sucursal.find(sucursal_id)
        nro_transferencia = sucursal.get_next_nro_transferencia
        
        puts nro_transferencia
        write_attribute(:nro_transferencia, nro_transferencia)
      end

      if !save
        raise ActiveRecord::Rollback
      end

      detalles.each do |detalle|
        # if ProductoDeposito.existencia(destino_id, detalle.lote_id).first.nil?
        #   self.errors[:base] << "No existe #{detalle.producto.descripcion} en el deposito destino."
        # end
          lote = Lote.find(detalle.lote_id)
          if(!(lote.producto.tipo_producto.codigo == 'S'))
            if !Producto.actualizar_stock!(detalle.lote, destino_id, detalle.cantidad)
              puts "error +"
              raise ActiveRecord::Rollback
            end

            if !Producto.actualizar_stock!(detalle.lote, origen_id, -detalle.cantidad)
              puts "error -"
              raise ActiveRecord::Rollback
            end
        end
      end
      if !self.errors[:base].empty?
          raise ActiveRecord::Rollback
      end
    end
  end

  def destroy_with_details
    transaction do
      errors = []
      @detalles = TransferenciaDepositoDetalle.where("transferencia_id = ?", id)
      @detalles.each do |det|
        begin
          if(!Lote.find(det.lote_id).tipo_producto.codigo == 'S')
            if !Lote.actualizar_stock!(det.lote, destino_id, -det.cantidad)
              puts "error - eliminar"
              raise ActiveRecord::Rollback
            end

            if !Lote.actualizar_stock!(det.lote, origen_id, det.cantidad)
              puts "error + eliminar"
              raise ActiveRecord::Rollback
            end
          end
        rescue ActiveRecord::RecordInvalid
          self.errors[:base] << "No existe stock suficiente de #{det.lote.producto.descripcion}"
        end
        if !self.errors[:base].empty?
          raise ActiveRecord::Rollback
        end
       det.destroy!
      end

      destroy!
    end
  end
end
