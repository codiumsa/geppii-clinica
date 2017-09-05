class API::V1::ProcesosController <
 ApplicationController
  respond_to :json

  before_filter :ensure_authenticated_user
  before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_procesos" end
  before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_procesos" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_procesos" end
  before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_procesos" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_procesos" end 

  
  has_scope :by_producto_id
  has_scope :by_descripcion  
  has_scope :by_estado
  has_scope :by_producible
  has_scope :by_cantidad
  has_scope :by_all_attributes, allow_blank: true
  has_scope :vigentes

  PER_PAGE_RECORDS = 15
  
  def proceso_params
    params.require(:proceso).permit(:producto_id, :descripcion, :estado, :cantidad)
  end

  def index
      tipo = params[:content_type]
      by_producible = params[:by_producible]

      if tipo.eql? "pdf"
        require 'procesos_report.rb'
        @procesos = apply_scopes(Proceso).order(:descripcion)
        pdf = ReportProcesoPdf.new(@procesos)
        send_data pdf.render, filename: 'reporte_procesos.pdf', type: 'application/pdf', disposition: 'attachment'    
      else
        if not by_producible.eql? "VIGENTE"
          @procesos = apply_scopes(Proceso).page(params[:page]).per(PER_PAGE_RECORDS)
        else
          @procesos = apply_scopes(Proceso)
        end

        if @procesos.count > 0
          if not by_producible.eql? "VIGENTE"
            render json: @procesos, each_serializer: ProcesoSerializer, meta: {total: apply_scopes(Proceso).all.count, total_pages: @procesos.num_pages}
          else
            render json: @procesos, each_serializer: ProcesoSerializer, meta: {total: apply_scopes(Proceso).all.count}
          end  
        else
          render json: @procesos, each_serializer: ProcesoSerializer
        end
      end
  end

  def show
    respond_with Proceso.find(params[:id])
  end

  def new
    respond_with Proceso.new
  end

  def create
    @proceso = Proceso.new(proceso_params)
    @proceso.estado = 'VIGENTE'
    @proceso.save
    respond_with @proceso
  end

  def update
    @proceso = Proceso.unscoped.find_by(id: params[:id])
    if @proceso.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @proceso.update_attributes(proceso_params)
      respond_with @proceso
    end
  end

  def destroy
    @proceso = Proceso.find_by(id: params[:id])
    if @proceso.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      if @proceso.estado === 'CANCELADO'
        @proceso.destroy
        respond_with @proceso
      else
        @proceso.estado = 'CANCELADO'
        @proceso.save
        respond_with @proceso
      end
    end
  end
end
