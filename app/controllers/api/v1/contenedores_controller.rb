class API::V1::ContenedoresController < ApplicationController
	respond_to :json

	PER_PAGE_RECORDS = 15

  has_scope :by_all_attributes, allow_blank: true
    has_scope :by_codigo

  def index
      @contenedores = apply_scopes(Contenedor).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @contenedores, meta: {total: apply_scopes(Contenedor).all.count, total_pages: @contenedores.num_pages}
	end

	def show
        respond_with Contenedor.find(params[:id])
	end

	def new
        respond_with Contenedor.new
	end

	def create
        @contenedor = Contenedor.new(contenedor_params)
        @contenedor.save
        respond_with @contenedor, location: nil
	end

  def update
      @contenedor = Contenedor.find_by(id: params[:id])
      if @contenedor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
          @contenedor.update_attributes(contenedor_params)
          respond_with @contenedor, location: nil
    end
  end
  
  def destroy
      @contenedor = Contenedor.unscoped.find_by(id: params[:id])
      if @contenedor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
          @contenedor.eliminar
          respond_with @contenedor
    end
  end

    def contenedor_params
        params.require(:contenedor).permit(:codigo, :nombre)
  end
end
