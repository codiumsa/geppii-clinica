class API::V1::InventarioLotesController < ApplicationController
	respond_to :json
	before_filter :ensure_authenticated_user
  
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_inventario_lotes" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_inventario_lotes" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_inventario_lotes" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_inventario_lotes" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_inventario_lotes" end 

  PER_PAGE_RECORDS = 15
  has_scope :ids, type: :array

  def index
    if params[:ids]
      @detalles = apply_scopes(InventarioLote).page.per(params[:ids].length)
    else
      @detalles = apply_scopes(InventarioLote).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @detalles, each_serializer: InventarioLoteSerializer, 
                meta: {total: apply_scopes(InventarioLote).all.count, total_pages: @detalles.num_pages}
  end

  def show
    respond_with InventarioLote.find(params[:id])
  end

  # def new
  #   respond_with InventarioLote.valid?
  # end

  def new
    respond_with InventarioLote.new
  end

  def create
    @inventario_lote = InventarioLote.new(inventario_lote_params)
    @inventario_lote.save
    respond_with @inventario_lote, location: nil
  end

  def update
    @inventario_lote = InventarioLote.find_by(id: params[:id])
    if @inventario_lote.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @inventario_lote.update_attributes(inventario_lote_params)
      respond_with @inventario_lote, location: nil
    end
  end

  def destroy
    @inventario_lote = InventarioLote.find_by(id: params[:id])
    if @inventario_lote.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @inventario_lote.destroy
      respond_with @inventario_lote
    end
  end

  def inventario_lote_params
    params.require(:inventario_lote).permit(:lote_id, :existencia, :inventario_id)
  end
end
