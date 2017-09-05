class API::V1::AjusteInventariosController < ApplicationController
	respond_to :json

  	before_filter :ensure_authenticated_user
    before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_ajuste_inventarios" end
    before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_ajuste_inventarios" end
    before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_ajuste_inventarios" end
    before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_ajuste_inventarios" end
    before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_ajuste_inventarios" end

  	PER_PAGE_RECORDS = 15

    has_scope :by_all_attributes, allow_blank: true
    has_scope :by_deposito_id
  	has_scope :by_fecha_before
  	has_scope :by_fecha_after
  	has_scope :by_fecha_on

  	def index
		# DEJO COMENTADA ESTA PARTE PORQUE ASUMO QUE VAMOS A TENER QUE HACER UN REPORTE DE AJUSTES
	    content_type = params[:content_type]
			tipo = params[:tipo]
	    if content_type.eql? "pdf"
				if tipo.eql? "reporte_ajuste_inventarios"
				 @ajustes = apply_scopes(AjusteInventario).order(:fecha).reverse_order
				 render xlsx: 'ajuste_inventarios',filename: "ajuste_inventarios.xlsx"
				end
	    else
	    @ajustes = apply_scopes(AjusteInventario).page(params[:page]).per(PER_PAGE_RECORDS)
	    render json: @ajustes, meta: {total: apply_scopes(AjusteInventario).all.count, total_pages: @ajustes.num_pages}
	    end
  	end

  	def show
		respond_with AjusteInventario.find(params[:id])
  	end

  	def new
    	respond_with AjusteInventario.new
  	end

  	def create

      puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nPARAMS\n"
      puts params

	    @ajuste_inventario = AjusteInventario.new(ajuste_inventario_inner_params)

	    detalles = []
	    if(not params[:ajuste_inventario][:detalle].nil?)
	      	params[:ajuste_inventario][:detalle].each do |d|
							if(d[:lote_id])
								@detalle = AjusteInventarioDetalle.new(producto_id: d[:producto_id],
		                                                cantidad: d[:cantidad],
																										lote_id: d[:lote_id],
																										motivos_inventario_id: d[:motivos_inventario_id])
		            detalles.push(@detalle)
	              puts "\n\n\n\n\n\n\n\n\n\nEN EN BUCLE DE DETALLES EN EL CONTROLLER\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
							else
								@detalle = AjusteInventarioDetalle.new(producto_id: d[:producto_id],
																										cantidad: d[:cantidad],
																										motivos_inventario_id: d[:motivos_inventario_id])
								detalles.push(@detalle)
								puts "\n\n\n\n\n\n\n\n\n\nEN EN BUCLE DE DETALLES EN EL CONTROLLER\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
							end

	        end
	    end

	    @ajuste_inventario.detalles = detalles
	    @ajuste_inventario.usuario_id = current_user.id
	    @ajuste_inventario.save_with_details
	    respond_with @ajuste_inventario, location: nil
  	end

  def update
    @ajuste_inventario = AjusteInventario.find_by(id: params[:id])
    if @ajuste_inventario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ajuste_inventario.update_attributes(ajuste_inventario_inner_params)
      respond_with @ajuste_inventario, location: nil
    end
  end

  #No tiene destroy, un ajuste de inventario se cancela con otro igual pero con cantidades negadas

  def ajuste_inventario_params
    params.require(:ajuste_inventario).permit(:fecha, :usuario_id, :deposito_id, :observacion, detalle: [:producto_id, :cantidad])
  end

  def ajuste_inventario_inner_params
    params.require(:ajuste_inventario).permit(:fecha, :usuario_id, :deposito_id, :observacion)
  end
end
