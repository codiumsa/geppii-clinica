class Empresa < ActiveRecord::Base
  scope :by_activo, -> { where("activo = true") }
  scope :unpaged, -> { order("nombre") }
  
  default_scope { where(activo: true) }
  scope :by_codigo, -> codigo { where("codigo like ?", "%#{codigo}%") }
  scope :by_nombre, -> nombre { where("nombre ilike ?", "%#{nombre}%") }

  def get_next_nro_factura
    next_value = Empresa.get_next_nro_factura_by_id(id)[0]["nro_factura"]
    max_from_ventas = Empresa.find_by_sql("select max(nro_factura) as nro_factura from ventas where sucursal_id in
    	(select id from sucursales where sucursales.empresa_id = " + id.to_s + ");")[0]["nro_factura"]
    
    if Venta.number?(max_from_ventas) and max_from_ventas.to_i >= next_value
      next_value = max_from_ventas.to_i + 1
      Empresa.set_next_nro_factura_by_id(id, next_value)
    end

    next_value.to_s
  end

  def self.get_next_nro_factura_by_id(id)
    self.find_by_sql "select nextval('empresa_" + id.to_s + "_nro_factura_seq') as nro_factura;"
  end

  def self.set_next_nro_factura_by_id(id, value)
    self.find_by_sql "select setval('empresa_" + id.to_s + "_nro_factura_seq', " + value.to_s + ");"
  end

  def get_next_nro_recibo
    next_value = Empresa.get_next_nro_recibo_by_id(id)[0]["nro_recibo"]

    max_from_ventas = Empresa.find_by_sql "select max(nro_recibo) from pagos where venta_id in
    	(select sucursal_id from ventas where ventas.sucursal_id in
    		(select sucursal_id from empresas where empresas.id = " + id.to_s + ")) and
				not (select uso_interno from ventas where id = venta_id);"

    if Venta.number?(max_from_ventas) and max_from_ventas.to_i >= next_value
      next_value = max_from_ventas.to_i + 1
      Empresa.set_next_nro_recibo_by_id(id, next_value)
    end

    next_value.to_s
  end

  def self.get_next_nro_recibo_by_id(id)
    self.find_by_sql "select nextval('empresa_" + id.to_s + "_nro_recibo_seq') as nro_recibo;"
  end

  def self.set_next_nro_recibo_by_id(id, value)
    self.find_by_sql "select setval('empresa_" + id.to_s + "_nro_recibo_seq', " + value.to_s + ");"
  end



  def get_next_nro_recibo_interno
    next_value = Empresa.get_next_nro_recibo_interno_by_id(id)[0]["nro_recibo_interno"]

    max_from_ventas = Empresa.find_by_sql "select max(nro_recibo) from pagos where venta_id in
    	(select sucursal_id from ventas where ventas.sucursal_id in
    		(select sucursal_id from empresas where empresas.id = " + id.to_s + ")) and
				(select uso_interno from ventas where id = venta_id);"

    if Venta.number?(max_from_ventas) and max_from_ventas.to_i >= next_value
      next_value = max_from_ventas.to_i + 1
      Empresa.set_next_nro_recibo_interno_by_id(id, next_value)
    end

    next_value.to_s
  end

  def self.get_next_nro_recibo_interno_by_id(id)
    self.find_by_sql "select nextval('empresa_" + id.to_s + "_nro_recibo_interno_seq') as nro_recibo_interno;"
  end

  def self.set_next_nro_recibo_interno_by_id(id, value)
    self.find_by_sql "select setval('empresa_" + id.to_s + "_nro_recibo_interno_seq', " + value.to_s + ");"
  end

end
