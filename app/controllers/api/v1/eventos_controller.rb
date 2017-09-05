class API::V1::EventosController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  #before_filter :only => [:index] do |c| c.isAuthorized "BE_index_eventos" end
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_eventos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_eventos" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_eventos" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_eventos" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_eventos" end 

  has_scope :unpaged, :type => :boolean
  has_scope :by_fecha_registro_before
  has_scope :by_fecha_registro_after
  has_scope :by_fecha_registro_on
  has_scope :by_usuario_id

  has_scope :by_tipo
  has_scope :by_all_attributes, allow_blank: true 
  has_scope :by_id

  def index
    puts "[EVENTO_CONTROLLER.RB][INDEX]: ingresando #{params}"
    tipo = params[:tipo]
    content_type = params[:content_type]
    if content_type.eql? "pdf"
      if tipo.eql? "eventos"
        @eventos = apply_scopes(Evento).order(:fecha)
        pdf = EventoReportPdf.new(@eventos, params[:by_fecha_registro_after], params[:by_fecha_registro_on], params[:by_fecha_registro_before]) 
        send_data pdf.render, filename: 'reporte_eventos.pdf', type: 'application/pdf', disposition: 'attachment'
      end
    else
      if params[:unpaged]
        @eventos = apply_scopes(Evento)
        render json: @eventos, each_serializer: EventoSerializer, meta: {total: apply_scopes(Evento).all.count, total_pages: 0}
      else
        @eventos = apply_scopes(Evento).page(params[:page]).per(PER_PAGE_RECORDS)
        render json: @eventos, each_serializer: EventoSerializer, meta: {total: apply_scopes(Evento).all.count, total_pages: @eventos.num_pages}
      end
    end
  end
  
  def show
    respond_with Evento.find(params[:id])
  end

  def new
    respond_with Evento.new
  end

  def create
    @evento = Evento.new(evento_params)
    @evento.activo = true
    @evento.save
    respond_with @evento, location: nil
  end

  def update
    @evento = Evento.find_by(id: params[:id])
    if @evento.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @evento.update_attributes(evento_params)
      respond_with @evento, location: nil
    end
  end

  def evento_params
    params.require(:evento).permit(:id, :tipo, :observacion, :fecha, :usuario_id)
  end
end
