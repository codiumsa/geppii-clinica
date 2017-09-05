class API::V1::MotivosInventariosController < ApplicationController
  respond_to :json

   PER_PAGE_RECORDS = 15

  def index

  if params[:ids]
    @motivos_inventarios = apply_scopes(MotivosInventario).page.per(params[:ids].length)
  else
    @motivos_inventarios = apply_scopes(MotivosInventario).page(params[:page]).per(PER_PAGE_RECORDS)
  end

  render json: @motivos_inventarios, meta: {total: apply_scopes(MotivosInventario).all.count, total_pages: @motivos_inventarios.num_pages}
end

def show
  respond_with MotivosInventario.unscoped.find(params[:id])
end

  def new
      respond_with MotivosInventario.new
end
  def create
      @motivo_inventario = MotivosInventario.new(motivos_inventario_params)
      @motivo_inventario.save
      respond_with @motivo_inventario, location: nil
  end

  def update
      @motivo_inventario = MotivosInventario.find_by(id: params[:id])
      if @motivo_inventario.nil?
        render json: {message: 'Resource not found'}, :status => :not_found
      else
          @motivo_inventario.update_attributes(motivos_inventario_params)
          respond_with @motivo_inventario, location: nil
      end
  end

  def destroy
    @motivo_inventario = MotivosInventario.find_by(id: params[:id])
    if @motivo_inventario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @motivo_inventario.destroy
      respond_with @motivo_inventario
    end
  end

  def motivos_inventario_params
    params.require(:motivos_inventario).permit(:codigo,:descripcion,:especialidad_id)
  end

end
