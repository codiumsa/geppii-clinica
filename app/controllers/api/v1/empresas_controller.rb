class API::V1::EmpresasController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
=begin
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_productos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_productos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_productos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_productos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_productos" end 
=end

  has_scope :by_activo, :type => :boolean
  has_scope :unpaged, :type => :boolean
  #has_scope :by_all_attributes, allow_blank: true
  has_scope :by_nombre
  has_scope :by_codigo

  PER_PAGE_RECORDS = 15

  def index
    if (params[:unpaged])
      @empresas = apply_scopes(Empresa)
      render json: @empresas, each_serializer: EmpresaSerializer, 
                meta: {total: apply_scopes(Empresa).all.count, total_pages: 1}
    else 
      @empresas = apply_scopes(Empresa).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @empresas, each_serializer: EmpresaSerializer, 
                meta: {total: apply_scopes(Empresa).all.count, total_pages: @empresas.num_pages}
    end
  end

  def show
    respond_with Empresa.find(params[:id])
  end

  def new
    respond_with Empresa.new
  end

  def create
    @empresa = Empresa.new(empresa_params)
    @empresa.save
    respond_with @empresa
  end

  def update
    @empresa = Empresa.find_by(id: params[:id])
    if @empresa.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @empresa.update_attributes(empresa_params)
      respond_with @empresa
    end
  end

  def destroy
    @empresa = Empresa.find_by(id: params[:id])
    if @empresa.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @empresa.destroy
      respond_with @empresa
    end
  end

  def empresa_params
    params.require(:empresa).permit(:nombre, :activo, :ruc, :codigo)
  end
end
