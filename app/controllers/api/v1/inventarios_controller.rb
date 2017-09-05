class API::V1::InventariosController < ApplicationController
	respond_to :json

  	before_filter :ensure_authenticated_user
    before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_inventarios" end
    before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_inventarios" end
    before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_inventarios" end
    before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_inventarios" end
    before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_inventarios" end

  	PER_PAGE_RECORDS = 15

    has_scope :by_all_attributes, allow_blank: true
    has_scope :by_deposito_id
  	has_scope :by_fecha_inicio_before
  	has_scope :by_fecha_inicio_after
  	has_scope :by_fecha_inicio_on

  	has_scope :by_fecha_fin_before
  	has_scope :by_fecha_fin_after
    has_scope :by_fecha_fin_on
    has_scope :control
    has_scope :by_id
		has_scope :by_descripcion
	  #has_scope :by_usuario_id

	  #has_scope :by_descripcion

	def index
      tipo = params[:content_type]
      if tipo.eql? "pdf"
        #require 'inventarios_report.rb'
        @inventarios = apply_scopes(Inventario).order(:fecha_inicio).reverse_order
        pdf = ReportInventarioPdf.new(@inventarios)
        send_data pdf.render, filename: 'reporte_inventarios.pdf', type: 'application/pdf', disposition: 'attachment'
      elsif(params[:unpaged])
    	  @inventarios = apply_scopes(Inventario)
        render json: @inventarios, meta: {total: apply_scopes(Inventario).all.count, total_pages: 0}
      else
        @inventarios = apply_scopes(Inventario).page(params[:page]).per(PER_PAGE_RECORDS)
        render json: @inventarios, meta: {total: apply_scopes(Inventario).all.count, total_pages: @inventarios.num_pages}
      end

  end

	def show
		respond_with Inventario.find(params[:id])
	end

  def new
    respond_with Inventario.new
  end

  def create
    @inventario = Inventario.new(inventario_inner_params)

    detalles = []
    if(not params[:inventario][:inventario_lote].nil?)
      params[:inventario][:inventario_lote].each do |d|
            @detalle = InventarioLote.new(lote_id: d[:lote_id],
                                          existencia: d[:existencia])
            #AGREGAR LOTE
            detalles.push(@detalle)
        end
    end

    @inventario.inventario_lotes = detalles
    @inventario.usuario_id = current_user.id
    @inventario.save_with_details(@inventario.procesado)
    respond_with @inventario, location: nil
  end

  def update
    @inventario = Inventario.find_by(id: params[:id])

    if @inventario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      detalles = []
      if(not params[:inventario][:inventario_lote].nil?)
        params[:inventario][:inventario_lote].each do |d|
              @detalle = InventarioLote.new(lote_id: d[:lote_id],
                                                  existencia: d[:existencia])
              detalles.push(@detalle)
          end
      end
      procesar = @inventario.procesado==false and params[:inventario][:procesado]==true
      puts "[INVENTARIO][UPDATE]: Persistir existencias: #{procesar}"
      @inventario.inventario_lotes = detalles
      @inventario.usuario_id = current_user.id
      #@inventario.update_attributes(inventario_inner_params)
      @inventario.update_with_details(inventario_inner_params, detalles, procesar)
      respond_with @inventario, location: nil
    end
  end

  def destroy
    @inventario = Inventario.find_by(id: params[:id])
    if @inventario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @inventario.destroy_with_details
      respond_with @inventario
    end
  end

  def inventario_params
    params.require(:inventario).permit(:fecha_inicio, :fecha_fin, :usuario_id, :deposito_id, :descripcion, :control, :procesado,
      inventario_lote: [:lote_id, :existencia])
  end

  def inventario_inner_params
    params.require(:inventario).permit(:fecha_inicio, :fecha_fin, :usuario_id, :deposito_id, :descripcion, :control, :procesado)
  end

end
