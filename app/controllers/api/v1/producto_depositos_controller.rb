class API::V1::ProductoDepositosController < ApplicationController
  respond_to :json

  has_scope :by_all_attributes, allow_blank: true
  has_scope :producto_activo
  has_scope :by_producto_id
  has_scope :by_deposito_id
  has_scope :by_excluye_fuera_de_stock, :type => :boolean
  has_scope :by_categoria_id

  PER_PAGE_RECORDS = 15
  def index
    content_type = params[:content_type]
    tipo = params[:tipo]

    if content_type.eql? "pdf"

        require 'producto_deposito_report.rb'
        parametros_empresa = ParametrosEmpresa.default_empresa().first()
        @productoDepositos = apply_scopes(ProductoDeposito).order(:deposito_id).reverse_order
        pdf = ProductoDepositoReportPdf.new(@productoDepositos, parametros_empresa)
        send_data pdf.render, filename: 'reporte_productos_depositos.pdf', type: 'application/pdf', disposition: 'attachment'
    else
      @productoDepositos = apply_scopes(ProductoDeposito).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @productoDepositos, each_serializer: ProductoDepositoSerializer, meta: {total: apply_scopes(ProductoDeposito).all.count, total_pages: @productoDepositos.num_pages}
    end
  end

  def producto_deposito_params
    params.require(:producto_deposito).permit(:deposito_id, :producto_id, :existencia)
  end

end
