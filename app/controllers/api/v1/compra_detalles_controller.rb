class API::V1::CompraDetallesController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_compras" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_compras" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_compras" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_compras" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_compras" end

  has_scope :ids, type: :array
  has_scope :by_lote
  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @detalles = apply_scopes(CompraDetalle).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(CompraDetalle).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @detalles, each_serializer: CompraDetalleSerializer,
                meta: {total: apply_scopes(CompraDetalle).all.count, total_pages: @detalles.num_pages}
  end

  def show
    respond_with CompraDetalle.find(params[:id])
  end

  def new
    respond_with CompraDetalle.new
  end

  def create
    @detalle = CompraDetalle.new(compras_params)
    @detalle.save

    crearHistorialPrecio(params[:compra_detalle][:fecha_registro], @detalle)
    actualizarStock(@detalle.producto, current_sucursal.deposito_id, @detalle.cantidad)
    actualizarPrecioProducto(@detalle, params[:compra_detalle][:precio_venta], params[:compra_detalle][:precio_promedio])

    respond_with @detalle, location: nil
  end

  def update
    puts 'llamada a update de compra detalle'
    @detalle = CompraDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @detalle.update_attributes(compras_params)
      respond_with @detalle, location: nil
    end
  end

  def destroy
    @detalle = CompraDetalle.find_by(id: params[:id])
    if @detalle.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else

      borrarHistorialPrecio(@detalle)
      actualizarStock(@detalle.producto, current_sucursal.deposito_id, @detalle.cantidad * (-1))
      generarCreditoSesionCaja(@detalle, current_sucursal.id)

      @detalle.destroy

      respond_with @detalle
    end
  end


  def crearHistorialPrecio(fecha_registro, detalle)
    @precio = Precio.new(:fecha =>fecha_registro, :precio_compra => detalle.precio_compra, :compra_detalle => detalle)
    @precio.save
  end

  def borrarHistorialPrecio( detalle)
    @precio = Precio.where("compra_detalle_id = ?",detalle.id).first
    @precio.destroy
  end

  def actualizarStock(producto,deposito_id,cantidad)

    Producto.actualizar_stock!(producto,deposito_id,cantidad)

  end

  def generarCreditoSesionCaja(detalle, sucursal_id)

    @cajaChica = Caja.where("sucursal_id = ? AND tipo_caja = 'C'", sucursal_id).first
    @operacionCaja = OperacionCaja.where("tipo = 'Credito'").first

    observacion = 'BORRADO de Detalle #' + detalle.id.to_s + '#'
    monto = detalle.cantidad * detalle.precio_compra
    fecha_registro = Time.new
    @sesionCaja = SesionCaja.new(:fecha =>fecha_registro,
      :observacion => observacion, :monto => monto,
      :caja_id => @cajaChica.id, :operacion_caja_id => @operacionCaja.id)

    @sesionCaja.save
  end

  def actualizarPrecioProducto(detalle, precio_venta, precio_promedio)
    @producto = Producto.find_by(id: detalle.producto_id)
    @producto.precio_compra = detalle.precio_compra
    @producto.precio = precio_venta
    @producto.precio_promedio = precio_promedio
    @producto.save
  end


  def compras_params
    params.require(:compra_detalle).permit(:producto_id, :compra_id,
      :cantidad, :precio_compra,:contenedor_id)
  end
end
