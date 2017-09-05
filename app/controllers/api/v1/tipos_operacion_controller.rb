class API::V1::TiposOperacionController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15

  has_scope :by_manual, :type => :boolean
  has_scope :by_codigo
  has_scope :by_manual_permitido
  has_scope :by_categorizable, :type => :boolean
  has_scope :unpaged, :type => :boolean


  def index
    puts "BY MANUAL PERMITIDO: #{params[:by_manual_permitido]} ----------> #{current_user.isAuthorized('BE_new_operacion_all_tipos')}"
    if !params[:by_manual_permitido].nil?
      @tipoOperacion = TipoOperacion.by_manual_permitido(current_user.isAuthorized('BE_new_operacion_all_tipos'))
      render json: @tipoOperacion, each_serializer: TipoOperacionSerializer    
    elsif params[:unpaged]
      @tipoOperacion = apply_scopes(TipoOperacion)
      render json: @tipoOperacion, each_serializer: TipoOperacionSerializer, meta: {total: apply_scopes(TipoOperacion).all.count, total_pages: 0}
    else
      @tipoOperacion = apply_scopes(TipoOperacion).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @tipoOperacion, each_serializer: TipoOperacionSerializer, meta: {total: apply_scopes(TipoOperacion).all.count, total_pages: @tipoOperacion.num_pages}      
    end
    
  end

  
  def show
    respond_with TipoOperacion.find(params[:id])
  end
end
