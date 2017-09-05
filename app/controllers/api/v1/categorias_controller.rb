class API::V1::CategoriasController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_categorias" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_categorias" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_categorias" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_categorias" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_categorias" end

  has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  #has_scope :by_activo

  PER_PAGE_RECORDS = 15

  def index

    if params[:ids]
      @categorias = apply_scopes(Categoria).page.per(params[:ids].length)
      render json: @categorias, each_serializer: CategoriaSerializer, meta: {total: apply_scopes(Categoria).all.count, total_pages: 0}
    elsif params[:unpaged]
      @categorias = apply_scopes(Categoria)
      render json: @categorias, each_serializer: CategoriaSerializer, meta: {total: apply_scopes(Categoria).all.count, total_pages: 0}
    else
      @categorias = apply_scopes(Categoria).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @categorias, each_serializer: CategoriaSerializer, meta: {total: apply_scopes(Categoria).all.count, total_pages: @categorias.num_pages}
    end

  end

  def show
    respond_with Categoria.find(params[:id])
  end

  def new
    respond_with Categoria.new
  end

  def create
    @categoria = Categoria.new(categoria_params)
    @categoria.save
    respond_with @categoria, location: nil
  end

  def update
    @categoria = Categoria.find_by(id: params[:id])
    if @categoria.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria.update_attributes(categoria_params)
      respond_with @categoria, location: nil
    end
  end

  def destroy
    @categoria = Categoria.find_by(id: params[:id])
    if @categoria.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoria.destroy
      respond_with @categoria
    end
  end

  def categoria_params
    params.require(:categoria).permit(:nombre, :comision)
  end

end
