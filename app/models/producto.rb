# encoding: utf-8
class Producto < ActiveRecord::Base
  has_and_belongs_to_many :categorias
  has_many :promocion_productos, dependent: :destroy
  has_many :producto_depositos, dependent: :destroy
  has_many :producto_detalles, :foreign_key => 'producto_padre_id', :autosave => :true, :inverse_of => :producto_padre, dependent: :destroy
  has_many :categoria_productos, dependent: :destroy
  has_many :lotes, :dependent => :destroy
  has_many :lote_depositos, dependent: :destroy
  belongs_to :producto
  belongs_to :moneda
  belongs_to :especialidad
  belongs_to :tipo_producto
  validates :codigo_barra, uniqueness: {message: :codigo_barra_taken, scope: :activo}, if: 'is_activo?'
  validates :precio, :precio_compra,:descripcion,:codigo_barra, presence: true
  validate :margen, allow_blank: true
  validates :producto, pack: true, mismo_tipo_producto: true
  validates :cantidad, producto_cantidad_presence: true

  attr_accessor :promocion_aplicada, :existencia, :descuento, :url_foto#, :lotes
  attr_accessor :descripcion_codigo

  def is_activo?
    activo == true
  end

  has_attached_file :foto,
    :styles => { :small => ["350x350", :png]},
    :url => "/images/:class/:id/:style.png",
    :path => ':rails_root/public:url',
    :default_url => '/images/missing_:style.png',
    :use_timestamp => true


  validates_attachment_file_name :foto, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/, /PNG\Z/, /JPE?G\Z/, /GIF\Z/]
  validates_attachment_content_type :foto, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]


  def foto_url
    @url_foto = foto.url(:small)
  end
  scope :by_id, -> id { where("id = ?", "#{id}") }

  scope :by_categoria, -> value { joins(:categoria).where("categorias.nombre ilike ?", "%#{value}%") }
  scope :by_tipo_producto, -> value { joins(:tipo_producto).where("tipo_productos.codigo = ?", "#{value}") }
  scope :by_codigo_especialidad, -> value { joins(:especialidad).where("especialidades.codigo ilike ?", "%#{value}%") }
  scope :by_especialidad_id, -> value { where("especialidad_id =  ?", value) }
  scope :by_excluye_tipo_producto, -> value { joins(:tipo_producto).where("tipo_productos.codigo != ?", "#{value}") }
  scope :by_deposito, -> value { joins(:lote_depositos).where("lote_depositos.deposito_id = ? and pack = false", "#{value}") }
  scope :by_ultimo_modificado, -> value{ order("productos.updated_at DESC")}
  scope :by_activo, -> { where("productos.activo = true") }

  scope :by_pack, -> {where ("pack = false")}
  scope :by_set, -> value { joins(:tipo_producto).where("tipo_productos.codigo ilike ? and productos.descripcion ilike ?", "SET", "%#{value}%" ) }
  scope :by_stock, -> value { joins(:tipo_producto).joins(:lote_depositos).where("lote_depositos.cantidad > 0 and activo = true and tipo_productos.stock = true and productos.descripcion ilike ?", "%#{value}%") }
  scope :by_inicio_descripcion, -> descripcion { where("descripcion ilike ? and activo = true", "#{descripcion}%").limit(10) }
  scope :by_descripcion_union, -> { union_scope(by_inicio_descripcion, by_descripcion.limit(10)) }

  scope :by_fecha_vencimiento_before, -> before{ joins(:lote).where("lotes.fecha_vencimiento::date < ?", Date.parse(before)) }
  scope :by_fecha_vencimiento_on, -> on { joins(:lote).where("lotes.fecha_vencimiento::date = ?", Date.parse(on)) }
  scope :by_fecha_vencimiento_after, -> after { joins(:lote).where("lotes.fecha_vencimiento::date > ?", Date.parse(after)) }

  scope :codigo_barra, -> codigo_barra { where("codigo_barra = ?", "#{codigo_barra}") }
  scope :by_codigo_barra, ->codigo_barra { where("codigo_barra ilike ? and activo = true", "#{codigo_barra}") }
  scope :by_descripcion, -> descripcion { where("productos.descripcion ilike ? and activo = true", "%#{descripcion}%") }
  scope :by_admite_proceso, -> codigo_barra { where("codigo_barra = ? AND pack = false and activo = true", "#{codigo_barra}") }
  scope :by_all_attributes, -> value { includes(:especialidad).includes(:categorias)
    .where("activo = true and (productos.descripcion ilike ? OR codigo_barra ilike ? OR categorias.nombre ilike ? OR especialidades.descripcion ilike?)",
                                                                   "%#{value}%", "%#{value}%", "%#{value}%", "%#{value}%")#.group("productos.id")
                                       }

  PROMO_POR_TARJETA_CREDITO = "por tarjeta de crédito"

  #Al parecer se aplica para obtener la cantidad de productos "pack"

  def descripcion_codigo
    return "Descripcion: " + descripcion + " - Codigo: " + codigo_barra
  end
  def establecer_existencia sucursal_id
    sucursal = Sucursal.find_by(id: sucursal_id)
    puts "Codigo Sucursal: #{sucursal.codigo} deposito_id: #{sucursal.deposito_id}"
    if pack
      id_producto = producto_id
    else
      id_producto = id
    end

    cantidad_total_producto = obtener_existencia(sucursal.deposito_id)

    if cantidad_total_producto > 0
      if pack
        @existencia = cantidad_total_producto / cantidad
      else
        @existencia = cantidad_total_producto
      end
    else
      @existencia = 0
    end
  end

  def obtener_existencia(deposito_id)

    if deposito_id
      lotes_depositos = LoteDeposito.obtener_lotes_by_deposito_producto(deposito_id, id)
    else
      lotes_depositos = LoteDeposito.obtener_lotes_by_producto(id)
    end

    existencia = 0

    lotes_depositos.each do |lote|
      existencia += lote.cantidad
    end

    return existencia
  end

  def existencia
    return obtener_existencia nil
  end

  def self.aplicar_promocion(ruc, cantidad, codigo, moneda_id, moneda_producto_id, tarjeta_id, monto_cotizacion, sucursal_id, tipo_credito_id,
                             medio_pago_id, cantidad_cuotas, caliente)
    producto = codigo_barra(codigo).by_activo.first

    if (producto)
      parametro = ParametrosEmpresa.by_sucursal(sucursal_id).first
      if parametro and parametro.recargo_precio_venta #short circuit del if
        recargo = Recargo.by_medio_pago(medio_pago_id).by_tipo_credito(tipo_credito_id).by_cantidad_cuotas(cantidad_cuotas).unpaged.first
        if recargo
          producto.precio = producto.precio_promedio * (1 + recargo.interes / 100)
        end
      end


      puts "Precio original #{producto.precio}"
      precioSinDescuento = producto.precio * cantidad

      if moneda_producto_id.nil?
        moneda_producto_id = producto.moneda.id
      end

      if not moneda_id.nil?
        cotizacion = Cotizacion.get_cotizacion(moneda_id, moneda_producto_id)

        if not cotizacion.nil? and monto_cotizacion.nil?
          monto_cotizacion = cotizacion.monto
        end

        if monto_cotizacion.nil?
          monto_cotizacion = 1
        end
        precioSinDescuento = precioSinDescuento * monto_cotizacion
      end

      producto.promocion_aplicada = nil

      #vigentes generales con/sin cantidad con/sin descuento
      promociones_aplicables = Promocion.vigentes_no_exclusivas_no_tarjeta
      if ruc
        puts "Obteniendo categorias para Cliente con RUC: #{ruc}"
        cliente = Cliente.by_ciRuc(ruc).first
        if cliente and cliente.categoria_cliente
          cat = CategoriaCliente.by_categoria_vigentes(cliente.categoria_cliente_id).first
          promociones_aplicables += cat.nil? ? [] : cat.promociones
        end
      end

      if tarjeta_id
        promociones_aplicables += Promocion.by_tarjeta_id(tarjeta_id)
      end

      promociones_aplicables.uniq()

      precio_promo = evaluar_promociones(producto, promociones_aplicables, cantidad, monto_cotizacion, caliente)
      puts "if #{producto.precio} < #{precio_promo[0].to_f} and existe promo > #{(not precio_promo[1].nil?)}"
      if producto.precio > precio_promo[0] and (not precio_promo[1].nil?)
        producto.promocion_aplicada = precio_promo[1]
        producto.promocion_aplicada.tipo = Promocion.get_tipo(producto.promocion_aplicada)
        producto.descuento = producto.precio*cantidad - precio_promo[0].to_f * cantidad
        puts "Promoción aplicada: #{producto.promocion_aplicada.id} - #{producto.promocion_aplicada.descripcion} - Descuento: #{producto.descuento}"

      end
      producto
    end
  end #OK ENDS

  def self.evaluar_promociones(producto, promociones, cantidad, monto_cotizacion, caliente)
    puts "Evaluando promociones..."
    precioSinDescuento = producto.precio * cantidad
    precio_promo = 0
    precios_x_promocion = []

    for promo in promociones
      puts "PROMOCION ID: #{promo.id}"
      precios_promo = []
      #PROMOCION GENERAL SIN DETALLES
      if promo.promocion_productos.nil? or (not promo.promocion_productos.nil? and promo.promocion_productos.size == 0)
        if promo.porcentaje_descuento > 0 and promo.cantidad_general == 0
          precio_promo =  producto.precio - producto.precio * (promo.porcentaje_descuento / 100)
          puts "1 -> PROMO #{promo.id} ****** - Seteando precio_promo #{precio_promo}"
          precios_promo << precio_promo
        end
        if promo.porcentaje_descuento > 0 and promo.cantidad_general > 0
          if promo.cantidad_general <= cantidad #20% de descuento a partir de 2 unidades para todos los productos
            precio_promo = PromocionProducto.precio_x_cantidad_fija(cantidad, promo.cantidad_general, producto.precio, promo.precio_descuento_general(producto))
            precios_promo << precio_promo
          end
        end
        #PROMOCION CON DETALLES
      elsif not promo.promocion_productos.nil? and promo.promocion_productos.size > 0
        promo_productos = PromocionProducto.by_prod_promo_id(producto.id, promo.id)

        for promo_producto in promo_productos
          #PROMOCION CONTIENE A PRODUCTO
          if not promo_producto.nil?
            precio_promo = promo_producto.precio_con_descuento(cantidad, caliente, promo.a_partir_de, promo.por_unidad)
            puts "4 -> PROMO #{promo.id} ****** - Seteando precio_promo #{precio_promo}"
            precios_promo << precio_promo
          else
            #NO SE APLICA NINGUNA PROMOCION
            puts " -*-*-*-*-*-* No se aplica la promo #{promo.descripcion} (#{promo.id}) a  #{producto.descripcion}"
          end
        end
      else
        puts "La promocion #{promo.id} NO es general y tampoco incluye al producto #{producto.descripcion}"
      end

      precios_promo_cotizados = []
      if not monto_cotizacion.nil?
        for precio_promo in precios_promo
          precio_promo = precio_promo * monto_cotizacion
          precios_promo_cotizados << precio_promo
        end
      else
        precios_promo_cotizados = precios_promo
      end

      for precio_promo in precios_promo_cotizados
        if precio_promo > 0
          puts "===== --------- Se inserta en precios_x_promocion: [precio: #{precio_promo}, promo#{promo.id}] "
          precios_x_promocion << [precio_promo.to_f, promo]
        end
      end
    end #endFor Promo in promociones

    mejor_precio = [producto.precio, nil]

    precios_x_promocion.each do |pp|
      puts "----------- Evaluando #{mejor_precio[0]} > #{pp[0]} --------------"
      if pp[0] < mejor_precio[0]
        mejor_precio = [pp[0], pp[1]]
      end
    end

    puts "Original: #{producto.precio} Mejor precio: #{mejor_precio[0]} --- PROMO APLICADA #{mejor_precio[1]}"
    mejor_precio
  end
  private_class_method :evaluar_promociones

  # def self.evaluar_promociones_producto(producto, promocionesPorProducto, tipo, mayorDescuento, cantidad, monto_cotizacion)
  #   for promoProducto in promocionesPorProducto
  #       promo = promoProducto.promocion
  #       if promo and promo.isVigente
  #         if Settings.promociones.a_partir_de and promoProducto.cantidad <= cantidad
  #           sinDescuento = producto.precio * cantidad
  #           veces = cantidad
  #         else
  #           mod = cantidad % promoProducto.cantidad.to_i
  #           veces = cantidad.to_i / promoProducto.cantidad.to_i
  #           precioSobras = mod * producto.precio
  #           sinDescuento = producto.precio * veces * promoProducto.cantidad
  #         end

  #         if promoProducto.porcentaje
  #           descuento = sinDescuento * (promoProducto.precio_descuento / 100)
  #         else
  #           descuento = sinDescuento - (promoProducto.precio_descuento * veces)
  #         end

  #         # cuando la moneda de la venta es distinta a la del producto, cotizamos
  #         if not monto_cotizacion.nil?
  #           descuento = descuento * monto_cotizacion
  #         end

  #         if descuento > mayorDescuento
  #           mayorDescuento = descuento
  #           producto.promocion_aplicada = promo
  #           producto.promocion_aplicada.tipo
  #         end
  #       end
  #     end
  #     mayorDescuento
  # end
  # private_class_method :evaluar_promociones_producto

  #Suma la existencia actual con el parámetro cantidad.
  def self.actualizar_stock!(lote_id, deposito_id, cantidad)
    lote = Lote.find(lote_id)
    producto_padre = Producto.find_by(id: lote.producto_id)
    producto = nil
    cantidad_pack = 1
    if(producto_padre)
      if(producto_padre.pack) #Si es un pack descontar por unidad
        producto_contenido = Producto.find_by(id: producto_padre.producto)
        if(producto_contenido)
          producto = producto_contenido
          cantidad_pack = producto_padre.cantidad
        end
      else
        producto = producto_padre
      end
    end
    if(producto)
      @lote_deposito = LoteDeposito.where("lote_id = ? AND deposito_id = ?", lote.id, deposito_id).first
      if @lote_deposito.nil?
        @lote = Lote.find(lote.id)
        @producto = @lote.producto
        @deposito = Deposito.find(deposito_id)
        @lote_deposito = LoteDeposito.new(:lote => @lote, :producto => @producto, :deposito => @deposito, :cantidad =>0 )
      end
      @lote_deposito.cantidad = @lote_deposito.cantidad + (cantidad*cantidad_pack)
      @lote_deposito.save!
    end
  end

  def self.fijar_stock(lote, deposito_id, existencia)
    puts "LOTE: "
    puts lote.to_yaml

    producto_padre = Producto.find_by(id: lote.producto_id)
    producto = nil
    cantidad_pack = 1
    if(producto_padre)
      if(producto_padre.pack) #Si es un pack descontar por unidad
        producto_contenido = Producto.find_by(id: producto_padre.producto)
        if(producto_contenido)
          producto = producto_contenido
          cantidad_pack = producto_padre.cantidad
        end
      else
        producto = producto_padre
      end
    end
    if(producto)
      @lote_deposito = LoteDeposito.where("lote_id = ? AND deposito_id = ?", lote.id, deposito_id).first
      if @lote_deposito.nil?
        @lote = Lote.find(lote.id)
        @producto = Producto.find(producto)
        @deposito = Deposito.find(deposito_id)
        @lote_deposito = LoteDeposito.new(:lote => @lote, :producto => @producto, :deposito => @deposito, :cantidad =>0 )
      end
      @lote_deposito.cantidad = existencia * cantidad_pack
      @lote_deposito.save!
    end
  end

  def self.actualizar_stock_lote!(lote, deposito_id,cantidad,contenedor)
    puts 'entra actualizar_stock_lote'
    producto_padre = Producto.find_by(id: lote.producto_id)
    producto = nil
    cantidad_pack = 1
    if(producto_padre)
      if(producto_padre.pack) #Si es un pack descontar por unidad
        producto_contenido = Producto.find_by(id: producto_padre.producto)
        if(producto_contenido)
          producto = producto_contenido
          cantidad_pack = producto_padre.cantidad
        end
      else
        producto = producto_padre
      end
    end

    if(producto)
      @lote_deposito = LoteDeposito.where("lote_id = ? AND deposito_id = ?", lote.id, deposito_id).first
      puts @lote_deposito
      if @lote_deposito.nil?
        @lote = Lote.find(lote.id)
        @producto = Producto.find(producto)
        @deposito = Deposito.find(deposito_id)
        @lote_deposito = LoteDeposito.new(:lote => @lote, :producto => @producto, :deposito => @deposito, :cantidad =>0 )
      end
      if(not contenedor.nil?)
        @lote_deposito.contenedor = contenedor
      end
      @lote_deposito.cantidad = @lote_deposito.cantidad + (cantidad*cantidad_pack)
      @lote_deposito.save!
    end
  end


  def self.actualizarPrecio(compra_id, producto_id, precio_compra, precio_venta)
    @compra = Compra.find_by(id: compra_id)
    @producto = Producto.find_by(id: producto_id)
    @producto.obtener_existencia(false)

    if @producto.moneda_id == @compra.moneda_id
      @producto.precio_compra = precio_compra
      @producto.precio = precio_venta
    else
      @cotizacion = Cotizacion.ultima_cotizacion(@compra.moneda_id, @producto.moneda_id).first
      if @cotizacion
        @producto.precio_compra = precio_compra * @cotizacion.monto
        @producto.precio = precio_venta * @cotizacion.monto
      else
        @cotizacion = Cotizacion.ultima_cotizacion(@producto.moneda_id, @compra.moneda_id).first
        @producto.precio_compra = precio_compra / @cotizacion.monto
        @producto.precio = precio_venta / @cotizacion.monto
      end
    end

    Producto.actualizarPrecioPromedio(@producto.id)

    @producto.save!
  end

  def self.actualizarPrecioPromedio(producto_id)
    @producto = Producto.find_by(id: producto_id)
    @precios = Precio.by_producto(producto_id)
    monto_total = 0
    cantidad_total = 0
    @precios.each do |precio|
      cantidad_total = cantidad_total + precio.compra_detalle.cantidad
      puts   precio.compra_detalle.compra.to_yaml
      if precio.compra_detalle.compra.moneda_id == @producto.moneda_id
        monto_total = monto_total + precio.precio_compra * precio.compra_detalle.cantidad
      else
        @cotizacion = Cotizacion.ultima_cotizacion(precio.compra_detalle.compra.moneda_id, @producto.moneda_id).first
        if @cotizacion
          monto_total = monto_total + precio.precio_compra * precio.compra_detalle.cantidad * @cotizacion.monto
        else
          @cotizacion = Cotizacion.ultima_cotizacion(@producto.moneda_id, precio.compra_detalle.compra.moneda_id).first
          monto_total = monto_total + precio.precio_compra * precio.compra_detalle.cantidad / @cotizacion.monto
        end
      end
    end

    if cantidad_total > 0
      @producto.precio_promedio = monto_total / cantidad_total
    else
      @producto.precio_promedio = 0
    end
    @producto.save!
  end

  #def lotes
  #  return Lote.last_lotes(id)
  #end

  def self.migracion_op_sonrisa()
    todos = "psicologia,Test Raven Adultos;psicologia,Test Raven Infantil;psicologia,Test HTP;psicologia,Test Familia;psicologia,Test Bender Adultos ;psicologia,Test Bender Infantil;psicologia,Charla Orientativa;cirugia,Curación;cirugia,Consulta;cirugia,Control Post Operatorio;nutricion,Valoración Nutricional;nutricion,Diagnóstico Nutricional;nutricion,Lactancia Materna;nutricion,Fórmula;nutricion,Apoyo Lactancia Materna;nutricion,Recomendaciones Generales;nutricion,Recomendaciones Hipercalóricas;nutricion,Inicio Alimentación Complementaria;nutricion,Control;nutricion,Recomendaciones Previas a Cirugía;nutricion,Control Post Operatorio;odontologia,Exodoncia;odontologia,Obturaciones de caries;odontologia,Limpieza periodontal;odontologia,Impresión de placas;odontologia,Activación de placas;odontologia,Diagnóstico de fisuras;odontologia,Placas ortopédicas;odontologia,Instrucción de limpieza y alimentación ;odontologia,Endodoncia;odontologia,Control Post Operatorio"
    map = Hash["psicologia" => "PSI", "cirugia" => "CIR", "nutricion" => "NUT", "odontologia" => "ODO"]
    productos = todos.split(';')

    i = 0
    productos.each do |p|
      #puts "p = #{p}"
      prod = p.split(',')
      codigo = Producto.initials(prod[1])
      base = codigo
      @producto = Producto.new()

      i = 0
      while Producto.exists?(codigo_barra: codigo)
        i = i + 1
        codigo = base + i.to_s
      end

      @producto.codigo_barra = codigo

      @producto.descripcion = prod[1]
      @producto.unidad = 'UNIDAD'
      @producto.margen = 0
      @producto.iva = 10
      @producto.precio_compra = 0
      @producto.precio = 0
      @producto.precio_promedio = 0
      @producto.stock_minimo = 0
      @producto.activo = true
      @producto.pack = false
      @producto.servicio = false
      @producto.es_procedimiento =false
      @producto.moneda = Moneda.find_by(nombre: 'Guaraníes')
      if @producto.moneda.nil?
        puts "ERROR NO EXISTE LA MONEDA"
      end
      @producto.tipo_producto = TipoProducto.find_by(codigo: 'T')
      if @producto.tipo_producto.nil?
        puts "ERROR NO EXISTE EL TIPO PRODUCTO"
      end

      @producto.especialidad = Especialidad.find_by(map[codigo: prod[0]])
      if @producto.especialidad.nil?
        puts "ERROR NO EXISTE LA ESPECIALIDAD #{map[codigo: prod[0]]}"
      end
      puts "PRODUCTO: #{@producto.to_yaml}"
      @producto.save

    end
  end

  def self.initials(name)
    *rest = name.split
    (rest.map{|e| e[0]}).map(&:capitalize).join('')
  end


end
