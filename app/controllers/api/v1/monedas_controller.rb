class API::V1::MonedasController < ApplicationController
  respond_to :json

  before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_monedas" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_monedas" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_monedas" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_monedas" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_monedas" end

  PER_PAGE_RECORDS = 15

  has_scope :by_activo, :type => :boolean
  has_scope :by_all_attributes, allow_blank: true

  def index
    @monedas = apply_scopes(Moneda).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @monedas, meta: {total: apply_scopes(Moneda).all.count, total_pages: @monedas.num_pages}
  end

  def show
    respond_with Moneda.find(params[:id])
  end

  def new
    respond_with Moneda.new
  end

  def create
    @moneda = Moneda.new(moneda_params)
    @moneda.save
    respond_with @moneda, location: nil
  end

  def update
    @moneda = Moneda.find_by(id: params[:id])
    if @moneda.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @moneda.update_attributes(moneda_params)
      respond_with @moneda, location: nil
    end
  end

  def destroy
    @moneda = Moneda.unscoped.find_by(id: params[:id])
    if @moneda.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @moneda.eliminar
      respond_with @moneda
    end
  end

  def moneda_params
    params.require(:moneda).permit(:nombre, :simbolo, :anulado, :redondeo)
  end
end
