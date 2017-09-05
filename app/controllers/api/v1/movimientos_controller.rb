class  API::V1::MovimientosController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15

  has_scope :by_caja_id
  has_scope :by_operacion_id
  has_scope :ids
  has_scope :by_fecha_before
  has_scope :by_fecha_on
  has_scope :by_fecha_after
  has_scope :by_usuario
  has_scope :by_tipo_operacion
  def index
    content_type = params[:content_type]
    tipo = params[:tipo]

    if content_type.eql? "pdf"
      if tipo.eql? "reporte_movimientos_caja"
        require 'movimiento_caja_report.rb'
        @movimientoCajas  = apply_scopes(Movimiento).order(:created_at)
        puts "Cantidad de movimientos: #{@movimientoCajas.size}"
        pdf = MovimientoCajaReportPdf.new(@movimientoCajas)
        send_data pdf.render, filename: 'reporte_movimiento_caja.pdf', type: 'application/pdf', disposition: 'attachment'  
      elsif tipo.eql? "reporte_caja_usuario" 
        require 'caja_usuario_report.rb'
        @movimientosCaja  = apply_scopes(Movimiento).order(:created_at)
        pdf = CajaUsuarioReportPdf.new(@movimientosCaja,params[:by_usuario])
        send_data pdf.render, filename: 'caja_usuario_report.pdf', type: 'application/pdf', disposition: 'attachment'  
      #elsif tipo.eql? "reporte_final_caja" 
      #  require 'final_caja_report.rb'
      #        @movimientosCaja  = Movimiento.by_tipo_operacion(apply_scopes(Movimiento).order(:created_at),'cierre')
      #  @movimientosCaja  = Operacion.by_fecha_before(params[:by_fecha_before]).by_fecha_on(params[:by_fecha_on]).by_fecha_after(params[:by_fecha_after]).by_caja_id(params[:by_caja_id]).order(:created_at)
      #  pdf = FinalCajaReportPdf.new(@movimientosCaja,params[:by_caja_id])
      #  send_data pdf.render, filename: 'final_caja_report.pdf', type: 'application/pdf', disposition: 'attachment'  
      elsif tipo.eql? "reporte_caja_medio_pago"
          require 'caja_medio_pago_report.rb'
          @movimientos = apply_scopes(Movimiento).order(:created_at)
          pdf = CajaMedioPagoReportPdf.new(@movimientos,params[:by_caja_id],params[:by_fecha_before],params[:by_fecha_on],params[:by_fecha_after])
          send_data pdf.render, filename: 'caja_medio_pago_report.pdf', type: 'application/pdf', disposition: 'attachment'  

      end

    else
      if current_user.isAuthorized("BE_index_movimientos_all")
        puts "Esta autorizado a BE_index_movimientos_all"
        @movimientos = apply_scopes(Movimiento).order(:created_at, :caja_id, :operacion_id).reverse_order.page(params[:page]).per(PER_PAGE_RECORDS)
        render json: @movimientos, each_serializer: MovimientoSerializer, meta: {total: apply_scopes(Movimiento).all.count, total_pages: @movimientos.num_pages}
      else
        puts "No tiene autorizacion, se filtra por caja id"
        caja = Caja.by_username(current_user.username).first()
        @movimientos = apply_scopes(Movimiento).by_caja_id(caja.id).order(:created_at, :caja_id, :operacion_id).reverse_order.page(params[:page]).per(PER_PAGE_RECORDS)
        render json: @movimientos, each_serializer: MovimientoSerializer, 
        meta: {total: apply_scopes(Movimiento).by_caja_id(caja.id).all.count, total_pages: @movimientos.num_pages}
      end
    end
  end
  
  def show
    respond_with Movimiento.find(params[:id])
  end

  def destroy
    @movimiento = Movimiento.find_by(id: params[:id])
    @operacion = Operacion.find_by(id: @movimiento.operacion.id)

    if @operacion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      Operacion.reversarOperacion(@operacion, current_sucursal)
      respond_with @operacion
    end
  end
end
