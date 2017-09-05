class API::V1::LoteDepositosController < ApplicationController
  respond_to :json

  PER_PAGE_RECORDS = 15


  has_scope :by_all_attributes, allow_blank: true
  has_scope :producto_activo
  has_scope :by_producto_id
  has_scope :by_lote_id
  has_scope :by_deposito_id
  has_scope :by_excluye_fuera_de_stock, :type => :boolean
  has_scope :by_categoria_id
  has_scope :obtener_lotes_by_deposito_producto
  has_scope :obtener_lotes_by_deposito_producto_existente
  has_scope :by_deposito
  has_scope :by_lote

  # PER_PAGE_RECORDS = 15
  def index
    content_type = params[:content_type]
    tipo = params[:tipo]

    if content_type.eql? "pdf"
      if tipo.eql? "vencimiento"
        @loteDepositos = apply_scopes(LoteDeposito).order(:fecha_vencimiento)
        render xlsx: 'producto_vencimiento',filename: "reporte_productos_vencimiento.xlsx"
      elsif tipo.eql? "lote_deposito"
        require 'lote_deposito_report.rb'
        @lote_depositos = apply_scopes(LoteDeposito).order(:deposito_id).reverse_order
        pdf = LoteDepositoReportPdf.new(@lote_depositos)
        send_data pdf.render, filename: 'reporte_productos_depositos.pdf', type: 'application/pdf', disposition: 'attachment'
      elsif tipo.eql? "reporte_valoracion_inventario"
        @lote_depositos = apply_scopes(LoteDeposito).by_excluye_fuera_de_stock().order(:lote_id)
        render xlsx: 'valoracion_inventario',filename: "reporte_valoracion_inventario.xlsx"
      elsif tipo.eql? "reporte_existencia_inventario"
        @lote_depositos = apply_scopes(LoteDeposito).by_excluye_fuera_de_stock().order(:lote_id)
        render xlsx: 'existencia_inventario',filename: "reporte_existencia_inventario.xlsx"
      end


    elsif params[:unpaged]
      @lote_depositos = apply_scopes(LoteDeposito)
      render json: @lote_depositos, each_serializer: LoteDepositoSerializer, meta: {total: apply_scopes(LoteDeposito).all.count, total_pages: 0}
    else
      if params[:by_all_attributes].nil? or params[:by_all_attributes] == ""
        params.delete :by_all_attributes
      end
      @lote_depositos = apply_scopes(LoteDeposito).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @lote_depositos, each_serializer: LoteDepositoSerializer, meta: {total: apply_scopes(LoteDeposito).all.count, total_pages: @lote_depositos.num_pages}
    end
  end

  def lote_deposito_params
    params.require(:lote_deposito).permit(:deposito_id, :lote_id, :producto_id, :existencia,:contenedor_id)
  end

end
