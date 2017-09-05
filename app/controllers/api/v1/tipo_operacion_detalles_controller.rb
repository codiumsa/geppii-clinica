class API::V1::TipoOperacionDetallesController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15

  def index
    @detalles = TipoOperacionDetalle.page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @detalles, each_serializer: TipoOperacionDetalleSerializer
  end
  
  def show
    respond_with TipoOperacionDetalle.find(params[:id])
  end
end
