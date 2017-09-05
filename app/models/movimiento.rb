class Movimiento < ActiveRecord::Base
  belongs_to :caja
  belongs_to :operacion
  belongs_to :tipo_operacion_detalle, class_name: 'TipoOperacionDetalle'
  belongs_to :moneda
 
  scope :ids, lambda { |id| where(:id => id) }
  scope :by_operacion_id, -> operacion_id { where("operacion_id = ?", "#{operacion_id}") }
  scope :by_caja_id, -> caja_id { where("movimientos.caja_id = ?", "#{caja_id}")}
  scope :by_usuario, -> usuario_id { joins(:caja).where("cajas.usuario_id = ?", "#{usuario_id}")}
  scope :by_all_attributes, -> value { 
    joins(:caja).joins(:operacion).joins(:tipoOperacion).where("cajas.descripcion ilike ? OR tipoOperacion.descripcion ilike ?", 
          "%#{value}%", "%#{value}%")}
  # scope :by_tipo_operacion, -> value { joins(:operacion).joins(:tipo_operacion).where("operaciones.tipos_operacion.codigo ilike ?", "%#{value}%")}
  scope :by_fecha_before, -> before{ where("fecha::date < ?", Date.parse(before)) }
  scope :by_fecha_on, -> on { where("fecha::date = ?", Date.parse(on)) }
  scope :by_fecha_after, -> after { where("fecha::date > ?", Date.parse(after)) }



  attr_accessor :referencia

    def self.by_cierre_no_genera_diferencia(movimientos)
    movimientosnew = []
    movimientos.map do |movimiento|
      tipo_operacion = TipoOperacion.find(movimiento.operacion.tipo_operacion_id)
      if (tipo_operacion.codigo == 'cierre' && !movimiento.tipo_operacion_detalle.genera_diferencia)
        movimientosnew.push(movimiento)
      end
    end
        return movimientosnew
    end


    def self.by_tipo_operacion(movimientos,codigo)
            movimientosnew = []
            movimientos.map do |movimiento|
                  tipo_operacion = TipoOperacion.find(movimiento.operacion.tipo_operacion_id)
                if(tipo_operacion.codigo == codigo)
                    movimientosnew.push(movimiento)
                end
            end
        return movimientosnew
    end

  def referencia
    operacion.referencia
  end

    def self.referencia_id(movimiento)
        puts movimiento.operacion

        if not movimiento.operacion.tipo_operacion.referencia.nil?
          if movimiento.operacion.tipo_operacion.referencia === 'ventas'
            venta = Venta.where('id = ?',movimiento.operacion.referencia_id).first
              if not venta.nil? 
                return venta.id.to_s
              end
          elsif movimiento.operacion.tipo_operacion.referencia === 'compras'
            compra = Compra.where('id = ?', movimiento.operacion.referencia_id).first
            if not compra.nil? 
                return compra.id
            end
          elsif movimiento.operacion.tipo_operacion.referencia === 'operacion'
            op = Operacion.where('id = ?',movimiento.operacion.referencia_id).first
            if not op.nil?
              return op.id
            end
          elsif movimiento.operacion.tipo_operacion.referencia === 'pagos'
            pago = Pago.where('id = ?',movimiento.operacion.referencia_id).first
            if not pago.nil?
              return pago.id.to_s
            end
          elsif movimiento.operacion.tipo_operacion.referencia === 'N/A'
            return 'N/A'
          end
        end
        return 'N/A'
    end
end
