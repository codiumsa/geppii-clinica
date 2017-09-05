# encoding: utf-8
class Sucursal < ActiveRecord::Base
  has_many :cajas, dependent: :destroy
  has_and_belongs_to_many :usuarios
  belongs_to :deposito
  belongs_to :empresa
  belongs_to :vendedor

	attr_accessor :crear_deposito,:nueva_caja_id

  validates :codigo, :descripcion, :deposito, :empresa, presence: true

  scope :unpaged, -> { order("id") }
  scope :by_id, -> id { where("id = ?", id) }
  scope :by_activo, -> { where("activo = true") }
  scope :by_empresa, -> empresa_id { where("empresa_id = ?", empresa_id) }
	scope :by_codigo, -> codigo { where("codigo like ?", "#{codigo}") }
	scope :by_descripcion, -> descripcion { where("descripcion ilike ?", "%#{descripcion}%") }

  scope :by_all_attributes, -> value { 
    where("codigo like ? OR descripcion like ?", 
          "%#{value}%", "%#{value}%")
  }

  # default_scope { where(activo: true) }

  def caja_principal
    return Caja.where("tipo_caja = 'P' and sucursal_id = #{id}").first
  end

  def create_sequence_for_nro_factura
    ActiveRecord::Base.connection.execute("CREATE SEQUENCE sucursal_" + id.to_s + "_nro_factura_seq
                                            INCREMENT 1
                                            MINVALUE 1
                                            MAXVALUE 9223372036854775807
                                            START 1
                                            CACHE 1;")
  end

  def create_sequence_for_transferencia
    ActiveRecord::Base.connection.execute("CREATE SEQUENCE sucursal_" + id.to_s + "_nro_transferencia_seq
                                            INCREMENT 1
                                            MINVALUE 1
                                            MAXVALUE 9223372036854775807
                                            START 1
                                            CACHE 1;")
  end

  def guardar
    transaction do
      write_attribute(:activo, true)

      if not color
        code = 0
        codigo.each_byte{|b| code += b}
        generator = ColorGenerator.new saturation: 0.3, lightness: 0.75 , seed: code
        color = generator.create_hex
        write_attribute(:color, "#" + color)
      end

      if not empresa_id
        empresa_default = ParametrosEmpresa.default_empresa.first

        write_attribute(:empresa_id, empresa_default.empresa_id)
      end

      if crear_deposito
        depositoNuevo = Deposito.new
        if !vendedor_id.nil? and !vendedor_id.eql('')
          vendedorSeleccionado = Vendedor.by_id(vendedor_id).first
          depositoNuevo.nombre = vendedorSeleccionado.nombre + ' ' + vendedorSeleccionado.apellido
          depositoNuevo.descripcion = 'Dep. del Vendedor: ' + vendedorSeleccionado.nombre + ' ' + vendedorSeleccionado.apellido

          if !depositoNuevo.save
            raise ActiveRecord::Rollback
            return
          end
          depositoNuevo.nombre = depositoNuevo.nombre + ' ' + depositoNuevo.id.to_s
          if !depositoNuevo.save
            raise  ActiveRecord::Rollback
            return
          end
        else
          #Crear deposito de sucursal sin vendedor
          depositoNuevo.nombre = 'Deposito - ' + codigo
          depositoNuevo.descripcion = 'Dep. de Sucursal: ' + descripcion

          if !depositoNuevo.save
            raise ActiveRecord::Rollback
            return
          end
          depositoNuevo.nombre = depositoNuevo.nombre + ' ' + depositoNuevo.id.to_s
          if !depositoNuevo.save
            raise  ActiveRecord::Rollback
            return
          end
        end
        write_attribute(:deposito_id, depositoNuevo.id) 
      end
      
      if !save
        raise ActiveRecord::Rollback
        return
      end
      create_sequence_for_nro_factura
      create_sequence_for_transferencia

      #Creación de cajas chicha y principal

      caja_principal = Caja.new
      caja_principal.codigo = "caja_principal_" + codigo
      caja_principal.descripcion = "Caja Princial de " + descripcion
      caja_principal.tipo_caja = "P"
      caja_principal.sucursal_id = id
      caja_principal.saldo = 0
      

      if !caja_principal.save
        raise ActiveRecord::Rollback
        return
      end

      # caja_principal.inicializarCaja

      # caja_chica = Caja.new
      # caja_chica.codigo = "caja_chica_" + codigo
      # caja_chica.descripcion = "Caja Chica de Sucursal"
      # caja_chica.tipo_caja = "C"
      # caja_chica.sucursal_id = id
      # caja_chica.save

      # if !caja_chica.save
      #   raise ActiveRecord::Rollback
      #   return
      # end

      #caja_chica.inicializarCaja

      genera_sucursal_vendedor
    end
  end

  def genera_sucursal_vendedor
    sucursal_vendedor = SucursalVendedor.by_sucursal_id(id).by_vendedor_id(vendedor_id).first
    if not sucursal_vendedor
      sucursal_vendedor = SucursalVendedor.new
      sucursal_vendedor.sucursal_id = id
      sucursal_vendedor.vendedor_id = vendedor_id
      sucursal_vendedor.save
    end
  end



  def get_next_nro_factura
    next_value = Sucursal.get_next_nro_factura_by_id(id)[0]["nro_factura"]
    max_from_ventas = Venta.maximum(:nro_factura, :conditions => ['sucursal_id = ?', id])

    if Venta.number?(max_from_ventas) and max_from_ventas.to_i >= next_value
      next_value = max_from_ventas.to_i + 1
      Sucursal.set_next_nro_factura_by_id(id, next_value)
    end

    next_value.to_s
  end

  def self.get_next_nro_factura_by_id(id)
    self.find_by_sql "select nextval('sucursal_" + id.to_s + "_nro_factura_seq') as nro_factura;"
  end

  def self.set_next_nro_factura_by_id(id, value)
    self.find_by_sql "select setval('sucursal_" + id.to_s + "_nro_factura_seq', " + value.to_s + ");"
  end


  def get_next_nro_transferencia
    next_value = Sucursal.get_next_nro_transferencia_by_id(id)[0]["nro_transferencia"]
    max_from_transferencias = TransferenciaDeposito.maximum(:nro_transferencia)

    if Venta.number?(max_from_transferencias) and max_from_transferencias.to_i >= next_value
      next_value = max_from_transferencias.to_i + 1
      Sucursal.set_next_nro_transferencia_by_id(id, next_value)
    end

    next_value.to_s
  end

  def self.get_next_nro_transferencia_by_id(id)
    self.find_by_sql "select nextval('sucursal_" + id.to_s + "_nro_transferencia_seq') as nro_transferencia;"
  end

  def self.set_next_nro_transferencia_by_id(id, value)
    self.find_by_sql "select setval('sucursal_" + id.to_s + "_nro_transferencia_seq', " + value.to_s + ");"
  end

end
