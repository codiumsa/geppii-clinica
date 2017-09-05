class API::V1::CategoriaOperacionesController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  #before_filter :only => [:index] do |c| c.isAuthorized "BE_index_categoria_operaciones" end
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_categoria_operaciones" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_categoria_operaciones" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_categoria_operaciones" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_categoria_operaciones" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_categoria_operaciones" end 

  has_scope :unpaged, :type => :boolean
  has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true 
  has_scope :by_activo
  has_scope :by_tipo_operacion
  has_scope :by_id
  has_scope :con_tipo_operacion, :type => :boolean

  def index
    if params[:unpaged]
      @categoria_operaciones = apply_scopes(CategoriaOperacion)
      render json: @categoria_operaciones, each_serializer: CategoriaOperacionSerializer, meta: {total: apply_scopes(CategoriaOperacion).all.count, total_pages: 0}
    else
      @categoria_operaciones = apply_scopes(CategoriaOperacion).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @categoria_operaciones, each_serializer: CategoriaOperacionSerializer, meta: {total: apply_scopes(CategoriaOperacion).all.count, total_pages: @categoria_operaciones.num_pages}
    end
  end
  
  def show
    respond_with CategoriaOperacion.find(params[:id])
  end

  def new
    respond_with CategoriaOperacion.new
  end

  def create
    @categoria_operacion = CategoriaOperacion.new(categoria_operacion_params)
    @categoria_operacion.activo = true
    @categoria_operacion.save
    respond_with @categoria_operacion, location: nil
  end

  def update
    @categoria_operacion = CategoriaOperacion.find_by(id: params[:id])
    if @categoria_operacion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria_operacion.update_attributes(categoria_operacion_params)
      respond_with @categoria_operacion, location: nil
    end
  end

  def destroy
    @categoria_operacion = CategoriaOperacion.find_by(id: params[:id])
    if @categoria_operacion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria_operacion.activo = false
      @categoria_operacion.save
      respond_with @categoria_operacion
    end
  end

  def categoria_operacion_params
    params.require(:categoria_operacion).permit(:id, :nombre, :descripcion, :activo, :tipo_operacion_id)
  end

end
