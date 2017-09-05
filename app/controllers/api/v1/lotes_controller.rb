class API::V1::LotesController < ApplicationController
	respond_to :json

	PER_PAGE_RECORDS = 15

  has_scope :by_all_attributes, allow_blank: true
  has_scope :by_codigo
    has_scope :by_fecha_vencimiento_on
    has_scope :by_fecha_vencimiento_before
    has_scope :by_fecha_vencimiento_after
    has_scope :by_producto

  def index
        tipo = params[:tipo]
        content_type = params[:content_type]
      if content_type.eql? "pdf"
        if tipo.eql? "reporte_producto_lotes"
            @lotes = apply_scopes(Lote).order(:producto_id, :fecha_vencimiento)
						render xlsx: 'lote_productos',filename: "lote_productos.xlsx"
					end
      else
          @lotes = apply_scopes(Lote).page(params[:page]).per(PER_PAGE_RECORDS)
          render json: @lotes, meta: {total: apply_scopes(Lote).all.count, total_pages: @lotes.num_pages}
      end
	end

	def show
        respond_with Lote.find(params[:id])
	end

	def new
        respond_with Lote.new
	end

	def create
        @lote = Lote.new(lote_params)
        @lote.save
        respond_with @lote, location: nil
	end

  def update
      @lote = Lote.find_by(id: params[:id])
      if @lote.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
          @lote.update_attributes(lote_params)
          respond_with @lote, location: nil
    end
  end

  def destroy
      @lote = Lote.unscoped.find_by(id: params[:id])
      if @lote.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
          @lote.eliminar
          respond_with @lote
    end
  end

    def lote_parms
        params.require(:lote).permit(:producto_id, :codigo_lote, :fecha_vencimiento)
  end
end
