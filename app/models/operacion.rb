require 'colorize.rb'
class Operacion < ActiveRecord::Base
  belongs_to :caja, class_name: 'Caja'
  belongs_to :caja_destino, class_name: 'Caja'
  belongs_to :tipo_operacion
  belongs_to :categoria_operacion
  belongs_to :moneda
  validates :monto, presence: true

  has_many :movimientos, autosave: true, :dependent => :destroy
  attr_accessor :codigo_tipo_operacion
  
  scope :by_caja_id, -> caja_id { where("caja_id = ?", "#{caja_id}")}
  scope :by_cajas_id, -> caja_id { where("caja_id = ? or caja_destino_id = ?", "#{caja_id}", "#{caja_id}")}
  scope :by_tipo_operacion, -> tipo_operacion_id { where("tipo_operacion_id = ?", "#{tipo_operacion_id}") }
  scope :by_categoria_operacion, -> categoria_operacion_id { where("categoria_operacion_id = ?", "#{categoria_operacion_id}") }
  scope :by_usuario, -> usuario_id { joins(:caja).where("cajas.usuario_id = ?", "#{usuario_id}")}
  
  scope :by_fecha_before, -> before{ where("fecha::date < ?", Date.parse(before)) }
  scope :by_fecha_on, -> on { where("fecha::date = ?", Date.parse(on)) }
  scope :by_fecha_after, -> after { where("fecha::date > ?", Date.parse(after)) }


  def self.generarOperacion(caja_id, codigo_tipo_operacion, caja_destino_id, referencia_id, monto, moneda_id, current_sucursal = nil, categoria_operacion_id = nil)
    puts "\t\t[generarOperacion]: #{caja_id} , #{codigo_tipo_operacion}, Destino: #{caja_destino_id}, #{referencia_id}, #{monto}, #{moneda_id}, suc: #{current_sucursal}".red.on_white
    caja = Caja.find(caja_id)
    caja_destino = caja_destino_id.nil? ? nil : Caja.find(caja_destino_id)
    if moneda_id.nil?
      moneda_id = caja.moneda_id
    end
    puts "\t\tcategoria_operacion_id: "
    puts categoria_operacion_id
    # if !categoria_operacion_id.nil?
    #   categoria_operacion = CategoriaOperacion.by_id(categoria_operacion_id).first
    # else
    #   categoria_operacion = nil
    # end
    
    tipo_operacion = TipoOperacion.by_codigo(codigo_tipo_operacion).first
    cierre = TipoOperacion.by_codigo("cierre").first
    apertura = TipoOperacion.by_codigo("apertura").first

    cierre_automatico = ParametrosEmpresa.default_empresa().first.cierre_automatico_caja

    
    if codigo_tipo_operacion == "apertura" and caja_destino
      if caja_destino.abierta
        raise ActiveRecord::Rollback
      end
      caja_destino.abierta = true
      caja_destino.save
    end

    if codigo_tipo_operacion == "cierre" and caja
      if not caja.abierta
        raise ActiveRecord::Rollback
      end
      caja.abierta = false
      caja.save
    end
    
    if codigo_tipo_operacion == "apertura" and caja_destino.forzar_cierre and cierre_automatico
      puts ">>>>> 1. self.generarOperacion: Cierre Forzoso a la caja #{caja.codigo} por operacion #{codigo_tipo_operacion}".red.on_white
      monto_cierre = Settings.cajas.monto_cierre == "total" ? caja_destino.saldo : 0
      generar_operacion(caja_destino, cierre, caja, referencia_id, monto_cierre, moneda_id, categoria_operacion_id)
    elsif codigo_tipo_operacion != "cierre" and caja.forzar_cierre and cierre_automatico
      puts ">>>>> 2. self.generarOperacion: Cierre Forzoso a la caja #{caja.codigo} por operacion #{codigo_tipo_operacion}".red.on_white
      monto_cierre = Settings.cajas.monto_cierre == "total" ? caja.saldo : 0
      generar_operacion(caja, cierre, current_sucursal.caja_principal , referencia_id, monto_cierre, moneda_id, categoria_operacion_id)
    end
    puts ">>>>> 4. [generarOperacion]: Caja=#{caja.id} , C.Destino=#{caja_destino}, Operacion=#{tipo_operacion.codigo}, Ref=#{referencia_id}, Monto=#{monto}, Moneda=#{moneda_id}".red.on_white
    generar_operacion(caja, tipo_operacion, caja_destino, referencia_id, monto, moneda_id, categoria_operacion_id)
  end

  def self.generar_operacion(caja, tipo_operacion, caja_destino, referencia_id, monto, moneda_id, categoria_operacion_id = nil)
    puts ">>>>> 1. [generar_operacion]: Caja=#{caja.id} , C.Destino=#{caja_destino}, Operacion=#{tipo_operacion.codigo}, Ref=#{referencia_id}, Monto=#{monto}, Moneda=#{moneda_id}".blue.on_white
    transaction do
      operacion = Operacion.new
      operacion.caja_id = caja.id
      operacion.tipo_operacion = tipo_operacion
      if caja_destino
        operacion.caja_destino_id = caja_destino.id
      end
      operacion.referencia_id = referencia_id
      operacion.monto = monto
      operacion.moneda_id = moneda_id
      operacion.fecha = Date.today()
      operacion.categoria_operacion_id = categoria_operacion_id
      operacion.guardar
      return operacion
    end
  end

  def guardar()
    puts ">>>>> 1. [guardar]: Tiene detalles = #{not self.tipo_operacion.tipo_operacion_detalles[0].nil?}".green.on_white
    transaction do
      self.movimientos = []
      #Controlar que existan los detalles
      self.tipo_operacion.tipo_operacion_detalles.order(:secuencia).each do |detalle|
        movimiento = crear_movimiento(detalle)
        if !movimiento.nil?
          self.movimientos << movimiento
        end
      end
      #Se debería guardar la operacion y sus movimientos
      save!
    end
  end

  def crear_movimiento(detalle)
    if detalle.caja_destino
      caja = self.caja_destino
    else
      caja = self.caja
    end
    
    
    if !detalle.tipo_operacion.referencia.nil? and detalle.tipo_operacion.referencia == 'operacion'
      puts "#{detalle.id} #{self.referencia_id}"
      op_padre = Operacion.find(self.referencia_id)
      valor = op_padre.movimientos[detalle.secuencia-1].monto
    else
      # genera_diferencia en cierre de caja debería generar un movimiento con la diferencia entre el
      if detalle.genera_diferencia
          valor = caja.saldo
      else
        valor = self.monto
      end
    end

    puts ">>>>> 6. Creando movimiento #{detalle.tipo_movimiento.descripcion} en Caja = #{caja} con valor = #{valor}".blue.on_white

    #if valor != 0
      movimiento = Movimiento.new
      movimiento.caja = caja
      movimiento.monto = valor
      movimiento.monto_cotizado = Cotizacion.convertir(movimiento.monto, self.moneda, self.caja.moneda)
      movimiento.moneda_id = self.caja.moneda.id
      movimiento.descripcion = detalle.descripcion
      movimiento.tipo_operacion_detalle_id = detalle.id
      movimiento.fecha = Date.today()

      puts ">>>>> 7. Actualizando saldo #{self.caja.codigo} con un #{detalle.tipo_movimiento.codigo} su saldo actual es #{self.caja.saldo.nil? ? 'nulo' : self.caja.saldo}"
      if movimiento.caja.saldo.nil?
        movimiento.caja.saldo = 0
      end
      #Se deja el saldo de la consistente caja_destino
      if detalle.tipo_movimiento.codigo == 'C'
        movimiento.saldo =  movimiento.caja.saldo + movimiento.monto
      elsif detalle.tipo_movimiento.codigo == 'D'
        movimiento.saldo = movimiento.caja.saldo - movimiento.monto
      end
      movimiento.caja.saldo = movimiento.saldo
      #Se guarda el estado actual de la caja
      movimiento.caja.save
      return movimiento    
    #else
    #  return nil
    #end
  end
  def self.reversarOperacion(operacion, current_sucursal)
		
		puts "----------------------- REVERSAR OPERACION #{operacion.tipo_operacion.descripcion}"
    #def self.generarOperacion(caja_id, codigo_tipo_operacion, caja_destino_id, referencia_id, monto, moneda_id)
		if not operacion.reversado
      tipo_operacion_reversion = TipoOperacion.where("codigo = ?", operacion.tipo_operacion.tipo_operacion_reversion).first
  		caja_origen = operacion.caja_id
  		caja_destino = operacion.caja_destino_id

  		if (tipo_operacion_reversion.referencia === 'operacion')
        puts "SE HACE REVERSION DE UNA OPERACION"
        Operacion.generarOperacion(caja_origen, tipo_operacion_reversion.codigo, caja_destino, operacion.id, operacion.monto, operacion.moneda_id, current_sucursal)
      else
        Operacion.generarOperacion(caja_origen, tipo_operacion_reversion.codigo, caja_destino, operacion.referencia_id, operacion.monto, operacion.moneda_id, current_sucursal)
  		end
      
      operacion.reversado = true
      operacion.save!
    end
	end

	def self.reversarOperacionViejo(operacion)
		operacion_reversion = Operacion.new
		operacion_reversion.caja_id = operacion.caja_id
		#Se debe obtener el tipo de operacion inverso a la operacion inicial
		operacion_reversion.tipo_operacion = TipoOperacion.where("codigo = ?", operacion.tipo_operacion.tipo_operacion_reversion).first
		operacion_reversion.caja_destino_id = operacion.caja_destino_id
		operacion_reversion.referencia_id = operacion.referencia_id
		operacion_reversion.monto = operacion.monto

		operacion_reversion.moneda_id = operacion.moneda_id
		operacion_reversion.fecha = Date.today()
		
		#Se debe crear un movimiento por cada detalle dependiendo de su tipo de operacion
		operacion_reversion.tipo_operacion.tipo_operacion_detalles.order(:secuencia).each do |detalle|
			movimiento = Movimiento.new
			movimiento.tipo_operacion_detalle = detalle
			movimiento_padre = nil
			#Se almacenara en movimiento_padre cual es el movimiento con el cual se machea el movimiento actual
			#Esto depende de si es caja destino, o no.
			if detalle.caja_destino
				movimiento.caja = operacion.caja_destino
				operacion.movimientos.each do |mov|
					if mov.tipo_operacion_detalle.caja_destino
						movimiento_padre = mov
					end
				end
			else
				movimiento.caja = operacion.caja
				operacion.movimientos.each do |mov|
					if not mov.tipo_operacion_detalle.caja_destino
						movimiento_padre = mov
					end
				end
			end
			
			movimiento.moneda_id = movimiento_padre.moneda_id
			movimiento.monto = movimiento_padre.monto
			movimiento.monto_cotizado = movimiento_padre.monto_cotizado
			movimiento.fecha = Date.today()
		end
    
  end
	
	def self.get_operacion_by_referencia(objecto_referencia, codigo_tipo_operacion)
		tipo_operacion = TipoOperacion.where("codigo = ?", codigo_tipo_operacion).first
		Operacion.where("referencia_id = ? and tipo_operacion_id = ?", objecto_referencia.id, tipo_operacion.id).first
	end

  def referencia
    puts "OPERACION: #{id} - REFERENCIA: #{referencia_id} #{tipo_operacion.descripcion}"
    if not tipo_operacion.referencia.nil?
      if tipo_operacion.referencia === 'ventas'
        venta = Venta.where('id = ?', referencia_id).first
        if not venta.nro_factura.nil?
          return 'Venta/Factura Nro. ' + venta.nro_factura
        else
          return 'Venta/Id Nro. ' + venta.id.to_s
        end        
      elsif tipo_operacion.referencia === 'compras'
        compra = Compra.where('id = ?',referencia_id).first
        if not compra.nil? 
         if not compra.nro_factura.nil?
            return 'Compra/Factura Nro. ' + compra.nro_factura
          else
            return 'Compra/Id Nro. ' + compra.id.to_s
          end
        end
      elsif tipo_operacion.referencia === 'operacion'
        op = Operacion.where('id = ?',referencia_id).first
        if not op.nil?
          return 'Operacion Id Nro. ' + op.id.to_s
        end
      elsif tipo_operacion.referencia === 'pagos'
        pago = Pago.where('id = ?', referencia_id).first
        if not pago.nil?
          return 'Pago Id Nro. ' + pago.id.to_s
        end
      elsif tipo_operacion.referencia === 'N/A'
        return 'N/A'
      end
    end
    return 'N/A'
  end

end
