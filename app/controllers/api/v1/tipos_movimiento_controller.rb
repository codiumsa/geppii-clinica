class API::V1::TiposMovimientoController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15

 def index
      @TipoMovimientos = TipoMovimiento.page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @TipoMovimientos, each_serializer: TipoMovimientoSerializer
 end

  def show
    respond_with TipoMovimiento.find(params[:id])
  end

end
