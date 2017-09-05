class API::V1::DepositosController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_depositos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_depositos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_depositos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_depositos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_depositos" end

  PER_PAGE_RECORDS = 15

  has_scope :by_nombre
  has_scope :by_id
  has_scope :by_descripcion
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  #has_scope :by_activo

  def index

    if params[:ids]
      @depositos = apply_scopes(Deposito).page.per(params[:ids].length)
      render json: @depositos, each_serializer: DepositoSerializer, meta: {total: apply_scopes(Deposito).all.count, total_pages: 0}
    elsif params[:unpaged]
      @depositos = apply_scopes(Deposito)
      render json: @depositos, each_serializer: DepositoSerializer, meta: {total: apply_scopes(Deposito).all.count, total_pages: 0}
    else
      @depositos = apply_scopes(Deposito).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @depositos, each_serializer: DepositoSerializer, meta: {total: apply_scopes(Deposito).all.count, total_pages: @depositos.num_pages}
    end

  end

  def show
    respond_with Deposito.find(params[:id])
  end

  def new
    respond_with Deposito.new
  end

  def create
    @deposito = Deposito.new(deposito_params)
    @deposito.save
    respond_with @deposito
  end

  def update
    @deposito = Deposito.find_by(id: params[:id])
    if @deposito.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @deposito.update_attributes(deposito_params)
      respond_with @deposito
    end
  end

  def destroy
    @deposito = Deposito.find_by(id: params[:id])
    if @deposito.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @deposito.destroy
      respond_with @deposito
    end
  end

  def deposito_params
    params.require(:deposito).permit(:nombre, :descripcion)
  end

end
