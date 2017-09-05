# encoding: utf-8
require 'digest/md5'

class API::V1::ProductosController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_productos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_productos" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_productos" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_productos" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_productos" end

  has_scope :codigo_barra
  has_scope :by_activo, :type => :boolean
  has_scope :by_set
  has_scope :by_codigo_barra
  has_scope :by_all_attributes, allow_blank: true
  has_scope :by_categoria
  has_scope :by_pack, :type => :boolean
  has_scope :by_admite_proceso
  has_scope :by_deposito
  has_scope :by_ultimo_modificado
  has_scope :by_id
  has_scope :by_fecha_vencimiento_on
  has_scope :by_fecha_vencimiento_before
  has_scope :by_fecha_vencimiento_after
  has_scope :by_tipo_producto
  has_scope :by_codigo_especialidad
  has_scope :by_descripcion
  has_scope :by_excluye_tipo_producto
  has_scope :by_stock

  #has_scope :aplicar_promocion, :using => [:cantidad, :codigo_barra], :type => :hash

  PER_PAGE_RECORDS = 15

  def index

    if Settings.autenticacion.logueo_con_sucursal
      #si se usa logueo con sucursal, se usa la sucursal_id donde está logueado
      sucursal_id = current_sucursal.id
    else
      sucursal_id = params[:sucursal_id]
      puts sucursal_id
    end
    tipo = params[:tipo]
    content_type = params[:content_type]

    if params[:aplicar_promocion]
      cantidad = params[:aplicar_promocion][:cantidad].to_i
      caliente = is_true?(params[:aplicar_promocion][:caliente])
      codigo_barra = params[:aplicar_promocion][:codigo]
      ruc = params[:aplicar_promocion][:ruc]
      moneda_id = nil
      tarjeta_id = nil
      monto_cotizacion = nil
      moneda_producto_id = nil
      sucursal_id = nil
      tipo_credito_id = nil
      medio_pago_id = nil
      cantidad_cuotas = 0

      if params[:aplicar_promocion][:moneda_id]
        moneda_id = params[:aplicar_promocion][:moneda_id]
      end

      if params[:aplicar_promocion][:tarjeta_id]
        tarjeta_id = params[:aplicar_promocion][:tarjeta_id]
      end

      if params[:aplicar_promocion][:monto_cotizacion]
        monto_cotizacion = params[:aplicar_promocion][:monto_cotizacion].to_f
      end

      if params[:aplicar_promocion][:moneda_producto_id]
        moneda_producto_id = params[:aplicar_promocion][:moneda_producto_id]
      end

      if params[:aplicar_promocion][:sucursal_id]
        sucursal_id = params[:aplicar_promocion][:sucursal_id]
      end

      if params[:aplicar_promocion][:tipo_credito_id]
        tipo_credito_id = params[:aplicar_promocion][:tipo_credito_id]
      end

      if params[:aplicar_promocion][:medio_pago_id]
        medio_pago_id = params[:aplicar_promocion][:medio_pago_id]
      end

      if params[:aplicar_promocion][:cantidad_cuotas]
        cantidad_cuotas = params[:aplicar_promocion][:cantidad_cuotas]
      end
      @producto = Producto.aplicar_promocion(ruc, cantidad.to_i, codigo_barra, moneda_id, moneda_producto_id, tarjeta_id, monto_cotizacion,
                                             sucursal_id, tipo_credito_id, medio_pago_id, cantidad_cuotas, caliente)
      @productos_filtrados = Array.new

      if @producto
        @producto.establecer_existencia(sucursal_id)
        #@producto.obtener_existencia
        @producto.foto_url
        puts "Existecia============="
        puts @producto.existencia
        @productos_filtrados.push(@producto)
      end

      render json: @productos_filtrados, each_serializer: ProductoSerializer, meta: {total: @productos_filtrados.count, total_pages: 1}
    elsif params[:by_deposito]
      @productos_filtrados = apply_scopes(Producto)
      #      filtered_indexes = (0...@productos_filtrados.length).to_a.shuffle.take(Settings.control_inventario.cantidad_productos)
      filtered_indexes = (0...@productos_filtrados.length).to_a.shuffle.take(ParametrosEmpresa.by_empresa_codigo(Settings.empresa).first.ctrl_inventario_cantidad)
      result = @productos_filtrados.values_at(* @productos_filtrados.each_index.select {|i| filtered_indexes.include? i})
      render json: result, each_serializer: ProductoSerializer
    else
      query = apply_scopes(Producto)

      if params[:unpaged]
        @productos_filtrados = query
      else
        @productos_filtrados = query.page(params[:page]).per(PER_PAGE_RECORDS)
      end
      puts "PRODUCTOS #{@productos_filtrados.size}"
      for prod in @productos_filtrados
        #producto.establecer_existencia(deposito_id)
        prod.obtener_existencia(params[:deposito_id])
        puts prod.foto_url
        prod.foto_url
      end

      if params[:unpaged]
        render json: @productos_filtrados, each_serializer: ProductoSerializer, meta: {total: @productos_filtrados.count, total_pages: 1}
      else
        render json: @productos_filtrados, each_serializer: ProductoSerializer, meta: {total: apply_scopes(Producto).all.count, total_pages: @productos_filtrados.num_pages}
      end
    end
  end

  def show
    @producto = Producto.find(params[:id])
    @producto.foto_url
    respond_with @producto
  end

  def foto
    producto = Producto.find(params[:id])
    #TODO delete foto si existe

    if params[:foto]
      producto.update(:foto => params[:foto])
      producto.save
      render json: {url: producto.foto.url(:small)}, :status => :ok
    else
      render json: {foto: 'No se paso archivo'}, status: :unprocessable_entity
    end
  end

  def new
    respond_with Producto.new
  end

  def create
    Producto.transaction do
      @producto = Producto.new(producto_inner_params)
      @producto.precio_promedio = @producto.precio_compra
      @producto.activo = true
      categorias = []

      if(params[:producto][:codigo_barra] == "" or
         params[:producto][:codigo_barra].nil? and
         not @producto.descripcion.nil?)
        codigo = "cod"

        descripcionTmp = @producto.descripcion + ""
        descripcionTmp.delete!("^\u{0000}-\u{007F}")
        descripcionTmp = descripcionTmp.gsub(/[[:space:]]/,'')
        descripcionTmp = descripcionTmp.gsub(/[^[:word:]\s]/, '')

        if (not descripcionTmp.nil?)
          if descripcionTmp.length > 4
            codigo += descripcionTmp[0, 4]
          else
            codigo += descripcionTmp
          end

          digest = Digest::MD5.hexdigest(codigo + DateTime.now.to_s)
          codigoTmp = codigo + digest[0, 4]
          codigoTmp.downcase!

          i = 1
          while not Producto.codigo_barra(codigoTmp).first.nil?
            puts "ya hay"
            digest = Digest::MD5.hexdigest(codigo + DateTime.now.to_s + i.to_s)
            puts digest
            codigoTmp = codigo + digest[0, 4]
            codigoTmp.downcase!
            i += 1
          end

          @producto.codigo_barra = codigoTmp
        end
      end

      if(not params[:producto][:categorias].nil?)
        params[:producto][:categorias].each do |c|
          if c[:id].nil?
            @categoria = Categoria.new(nombre: c[:nombre])
          else
            @categoria = Categoria.find(c[:id])
          end
          categorias.push(@categoria)
        end
      end

      if (not params[:producto][:producto_detalles].nil?)
        producto_detalles = []
        puts 'entraproductodetalles'
        puts params[:producto][:producto_detalles]
        params[:producto][:producto_detalles].each do |productoDetalle|
          puts " > > > > > DETALLE: #{productoDetalle[:producto_id]}"
          producto_detalle = ProductoDetalle.new(producto: Producto.find(productoDetalle[:producto_id]),
                                                 cantidad: productoDetalle[:cantidad])
          puts "PRODUCTO DETALLE CREADO: #{producto_detalle.to_yaml}"
          producto_detalles.push(producto_detalle)
        end
        @producto.producto_detalles = producto_detalles
      end
      @producto.save
      @producto.categorias = categorias
      @producto.update_attributes(categorias: categorias)
      #Verificación de moneda_id
      if (params[:producto][:moneda_id].nil? or @producto.moneda.nil?)
        parametro = ParametrosEmpresa.by_empresa_codigo(Settings.empresa).first
        if (parametro)
          @producto.update_attributes(moneda: parametro.moneda_base)
        else
          puts "Error la empresa #{Settings.empresa} no tiene parametros asingados en la base de datos."
        end
      end
      respond_with @producto
    end

  end

  def update
    @producto = Producto.find_by(id: params[:id])

    if @producto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      Producto.transaction do
        categorias = []
        if(not params[:producto][:categorias].nil?)
          params[:producto][:categorias].each do |c|
            if c[:id].nil?
              @categoria = Categoria.new(nombre: c[:nombre])
            else
              @categoria = Categoria.find(c[:id])
            end
            categorias.push(@categoria)
          end
        end
        @producto.categorias = categorias
        @producto.update_attributes(categorias: categorias)
        puts '=====precio de venta'
        puts @producto.precio.to_s
        puts params[:producto][:precio]

        if @producto.precio != params[:producto][:precio].to_f
          puts '=====cambio de precio de venta'
          observacion = "Producto: " + @producto.descripcion + " de " + @producto.precio.to_s + " a " + params[:producto][:precio].to_f.to_s
          Evento.cambio_precio(observacion, current_user.id)
        end

        if (not params[:producto][:producto_detalles].nil?)
          @producto_detalles = []
          puts 'entraproductodetalles'
          puts params[:producto][:producto_detalles]
          params[:producto][:producto_detalles].each do |productoDetalle|
            puts " > > > > > DETALLE: producto_id = #{productoDetalle[:producto_id]} --- #{productoDetalle}"
            @producto_detalle = ProductoDetalle.new(producto: Producto.find(productoDetalle[:producto_id]),
                                                    cantidad: productoDetalle[:cantidad])
            @producto_detalles.push(@producto_detalle)
          end

          lista_vieja = Producto.codigo_barra(params[:producto][:codigo_barra]).first
          puts lista_vieja.producto_detalles.to_yaml

          lista_vieja.producto_detalles.map do |elementoViejo|
            if !@producto_detalles.include?(elementoViejo)
              elementoViejo.destroy
            end
          end

          puts 'productodetalle nuevo'
          puts @producto_detalles.to_yaml

          @producto.producto_detalles = @producto_detalles
          puts 'detalles del producto al actualizar'
          puts @producto.producto_detalles.to_yaml
        end
        @producto.update_attributes(producto_inner_params)
        @producto.save

        respond_with @producto
      end
    end
  end

  def destroy
    @producto = Producto.find_by(id: params[:id])
    if @producto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @producto.activo = false
      @producto.save
      respond_with @producto
    end
  end

  def producto_params
    params.require(:producto).permit(:codigo_barra, :descripcion, :unidad,:nro_inventario,:nro_serie,:asignado,:responsable_mantenimiento,:anho_fabricacion,:fecha_adquisicion,:area,:modelo,:descontinuado,:nro_referencia,
                                     :margen, :precio_compra, :precio, :iva, :stock_minimo, :es_procedimiento, :necesita_consentimiento_firmado,:tipo_producto_id, :especialidad_id,:presentacion,
                                     :precio_promedio, :pack, :producto_id, :cantidad, :moneda_id, :marca, categorias: [:id, :nombre],
                                     producto_detalles: [:producto_id, :producto_padre_id,:cantidad])
  end

  def producto_inner_params
    params.require(:producto).permit(:codigo_barra, :descripcion, :unidad, :margen, :precio_compra,:presentacion, :necesita_consentimiento_firmado,:nro_inventario,:nro_serie,:asignado,:responsable_mantenimiento,:anho_fabricacion,:fecha_adquisicion,:area,:modelo,:descontinuado,:nro_referencia,
                                     :precio, :iva, :stock_minimo, :es_procedimiento, :especialidad_id, :precio_promedio, :pack,
                                     :producto_id, :cantidad, :moneda_id, :tipo_producto_id, :descripcion_externa, :descripcion_local,
                                     :codigo_local, :codigo_externo, :marca)
  end
end
