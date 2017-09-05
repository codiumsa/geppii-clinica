class API::V1::PromocionesController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_promociones" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_promociones" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_promociones" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_promociones" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_promociones" end 

  has_scope :vigentes, :type => :boolean
  has_scope :by_all_attributes, allow_blank: true
  has_scope :by_descripcion
  has_scope :by_exclusiva
  has_scope :ids, type: :array
  has_scope :by_activo, :type => :boolean

  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @promociones = apply_scopes(Promocion).page.per(params[:ids].length)
    else
      @promociones = apply_scopes(Promocion).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @promociones, each_serializer: PromocionSerializer, meta: {total: apply_scopes(Promocion).all.count, total_pages: @promociones.num_pages}
  end

  def show
    respond_with Promocion.find(params[:id])
  end

  def new
    respond_with Promocion.new
  end

  def create
    @promocion = Promocion.new(promocion_inner_params)
    detalles = []
    if(not params[:promocion][:detalle].nil?)
      params[:promocion][:detalle].each do |d|
            @detalle = PromocionProducto.new(producto_id: d[:producto_id],
                                                cantidad: d[:cantidad],
                                                precio_descuento: d[:precio_descuento],
                                                porcentaje: d[:porcentaje],
                                                moneda_id: d[:moneda_id],
                                                caliente: d[:caliente])
            detalles.push(@detalle)
        end
    end

    @promocion.detalles = detalles
    @promocion.save_with_details
    respond_with @promocion, location: nil
  end

  def update
    @promocion = Promocion.find_by(id: params[:id])
    if @promocion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      detalles = []
      if(not params[:promocion][:detalle].nil?)
        params[:promocion][:detalle].each do |d|
              if d[:id]
                @detalle = PromocionProducto.find( d[:id])
              else
                @detalle = PromocionProducto.new()
              end
              @detalle.update_attributes(
                                        producto_id: d[:producto_id],
                                        cantidad: d[:cantidad],
                                        precio_descuento: d[:precio_descuento],
                                        porcentaje: d[:porcentaje],
                                        moneda_id: d[:moneda_id],
                                        caliente: d[:caliente])
              detalles.push(@detalle)
          end
      end

      @promocion.detalles = detalles
      @promocion.update_attributes(promocion_inner_params)
      # @promocion.save_with_details
      respond_with @promocion, location: nil
    end
  end

  def destroy
    @promocion = Promocion.find_by(id: params[:id])
    if @promocion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      #@promocion.eliminar
      @promocion.activo = false
      @promocion.save
      respond_with @promocion
    end
    #@promocion = Promocion.find_by(id: params[:id])
    #if @promocion.nil?
    #  render json: {message: 'Resource not found'}, :status => :not_found
    #else
    #  @promocion.destroy
    #  respond_with @promocion
    #end
  end

  def promocion_params
    params.require(:promocion).permit(:descripcion, :fecha_vigencia_desde, 
      :fecha_vigencia_hasta, :cantidad_general, :porcentaje_descuento, :permanente, :exclusiva, :tipo, :a_partir_de, :por_unidad,
      detalle: [:id, :producto_id, :moneda_id, :cantidad, :precio_descuento, :porcentaje, :caliente])
  end

  def promocion_inner_params
    params.require(:promocion).permit(:descripcion, :fecha_vigencia_desde, 
      :fecha_vigencia_hasta, :cantidad_general, :porcentaje_descuento, :permanente, :exclusiva, :tipo, :a_partir_de, :por_unidad, 
      :con_tarjeta, :tarjeta_id)
  end

end