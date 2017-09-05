class VentaDetalle < ActiveRecord::Base
  belongs_to :venta
  belongs_to :producto
  belongs_to :promocion
  belongs_to :cotizacion
  belongs_to :moneda
  belongs_to :lote
  


  scope :ids, lambda { |id| where(:id => id) }

  attr_accessor :subtotal, :subtotal_sin_descuento, :multiplicar_cotizacion

  def subtotal
    stotal = precio * cantidad
    stotal = cotizar_subtotal(stotal)
    stotal -= descuento
    stotal
  end

  def costo
    cost = producto.precio_promedio * cantidad
    cost = cotizar_subtotal(cost)
    cost
  end

  def subtotal_sin_descuento
    cotizar_subtotal(precio * cantidad)
  end

  def cotizar_subtotal(subtotal)
    cotizado = subtotal
    if not monto_cotizacion.nil?
      if multiplicar_cotizacion
        cotizado *= monto_cotizacion
      else
        cotizado /= monto_cotizacion
      end
    end

    if venta.moneda.redondeo
      cotizado.round(0)
    else
      cotizado.round(2)
    end
  end

  def multiplicar_cotizacion
    venta.moneda.id == cotizacion.moneda_base.id
  end
end
