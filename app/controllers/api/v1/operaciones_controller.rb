class API::V1::OperacionesController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_operaciones" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_operaciones" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_operaciones" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_operaciones" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_operaciones" end 

  has_scope :by_caja_id
  has_scope :by_cajas_id
  has_scope :by_operacion_id
  has_scope :ids
  has_scope :by_fecha_before
  has_scope :by_fecha_on
  has_scope :by_fecha_after
  has_scope :by_usuario
  has_scope :by_tipo_operacion
  has_scope :by_categoria_operacion

  PER_PAGE_RECORDS = 15
  def index
    content_type = params[:content_type]
    tipo = params[:tipo]
    if content_type.eql? "pdf"
      if tipo.eql? "reporte_operaciones"
        @operaciones  = apply_scopes(Operacion).order(:created_at)
        puts "Cantidad de operaciones: #{@operaciones.size}"
        pdf = OperacionesReportPdf.new(@operaciones)
        send_data pdf.render, filename: 'reporte_operaciones.pdf', type: 'application/pdf', disposition: 'attachment'  
      elsif tipo.eql? "reporte_final_caja"
        @operaciones  = apply_scopes(Operacion).order(:created_at)
        pdf = FinalCajaReportPdf.new(@operaciones,params[:by_caja_id])
        send_data pdf.render, filename: 'final_caja_report.pdf', type: 'application/pdf', disposition: 'attachment' 
      end 
    else
      puts "INDEX DE OPERACIONES"
      @operaciones = apply_scopes(Operacion).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @operaciones, each_serializer: OperacionSerializer
    end
  end

  def show
    respond_with Operacion.find(params[:id])
  end

  def new
    respond_with Operacion.new
  end

  def create
    puts "Creando operacion"
    @operacion = Operacion.generarOperacion(
      operaciones_params[:caja_id], 
      TipoOperacion.find(operaciones_params[:tipo_operacion_id]).codigo, 
      operaciones_params[:caja_destino_id], 
      operaciones_params[:referencia_id], 
      operaciones_params[:monto], 
      operaciones_params[:moneda_id], 
      current_sucursal,
      operaciones_params[:categoria_operacion_id]
      )
    respond_with @operacion, location: nil
  
  end

  def update
    @operacion = Operacion.find_by(id: params[:id])
    if @operacion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @operacion.update_attributes(params)
      respond_with @operacion
    end
  end

  def destroy
    @operacion = Operacion.find_by(id: params[:id])
    if @operacion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @operacion.reversarOperacion
      respond_with @operacion
    end
  end

	def operaciones_params
    params.require(:operacion).permit(:codigo_tipo_operacion, :monto,:caja_id, :caja_destino_id, :moneda_id, :fecha, :referencia_id, :tipo_operacion_id, :reversado, :categoria_operacion_id )
  end
end
