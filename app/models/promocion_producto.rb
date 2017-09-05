class PromocionProducto < ActiveRecord::Base
  belongs_to :promocion, :class_name => 'Promocion'
  belongs_to :producto
  belongs_to :moneda
  scope :ids, lambda { |id| where(:id => id) }
  scope :by_prod_promo_id,-> producto_id, promo_id {where("producto_id = ? and promocion_id = ?", "#{producto_id}", "#{promo_id}" )}
  
  def self.promociones(cantidad, producto)
    result = where("cantidad <= ? AND producto_id = ?", cantidad.to_i, producto.to_i)
  end

  def precio_con_descuento(cnt_venta, calienteParam, a_partir_de, por_unidad)
     puts "PROMOCION_PRODUCTO.precio_con_descuento (#{cnt_venta} unidades): #{cantidad}, #{precio_descuento}, % #{porcentaje} %caliente pp % #{caliente}" + 
  "  - % caliente param #{calienteParam} "
    if cantidad > 0 and cnt_venta >= cantidad.to_i and caliente == calienteParam
          puts "ES UN DESCUENTO FIJO (#{cnt_venta} unidades): #{cantidad} promo, #{producto.precio}, #{precio_producto} "
        return PromocionProducto.precio_x_cantidad_fija(cnt_venta, cantidad, producto.precio, precio_producto, a_partir_de, por_unidad)
    else
      return producto.precio  
    end
  end

  def precio_producto
    if porcentaje
      precio_promo = producto.precio - producto.precio * (precio_descuento / 100)
    else
      precio_promo = precio_descuento
    end
  end

  def self.precio_x_cantidad_fija(cnt_venta, cnt_promo, precio_original, precio_descuento, a_partir_de, por_unidad)
    puts "Calculando descuento CANTIDAD FIJA: #{cnt_venta} #{cnt_promo} #{precio_original} #{precio_descuento}"
    if not a_partir_de
      cantidad_veces_aplicacion = cnt_venta.to_i / cnt_promo.to_i
      cantidad_veces_NO_aplicacion =  cnt_venta.to_i % cnt_promo
      puts "(precio_descuento * cantidad_veces_aplicacion * cnt_promo) + (precio_original * cantidad_veces_NO_aplicacion)" 
      puts "(#{precio_descuento} * #{cantidad_veces_aplicacion} * #{cnt_promo}) + (#{precio_original} * #{cantidad_veces_NO_aplicacion})"
      if por_unidad
        total_con_descuento = (precio_descuento * cantidad_veces_aplicacion * cnt_promo) + (precio_original * cantidad_veces_NO_aplicacion)
        puts "TOTAL CON DESCUENTO: #{(precio_descuento * cantidad_veces_aplicacion * cnt_promo) + (precio_original * cantidad_veces_NO_aplicacion)}"
      else
        total_con_descuento = (precio_descuento * cantidad_veces_aplicacion) + (precio_original * cantidad_veces_NO_aplicacion)
        puts "TOTAL CON DESCUENTO: #{(precio_descuento * cantidad_veces_aplicacion) + (precio_original * cantidad_veces_NO_aplicacion)}"
      end

      precio_promo = total_con_descuento / cnt_venta #Saber cuanto sale cada producto con descuento
      puts "PROMOCION_PRODUCTO.precio_x_cantidad_fija: #{total_con_descuento} / #{cnt_venta} = #{precio_promo}"
    else
      precio_promo = precio_descuento
    end

    return precio_promo
  end
end
