
class API::V1::ViajesController < ApplicationController
  respond_to :json


  has_scope :by_id
  has_scope :by_colaborador_id
  has_scope :by_fecha_before
  has_scope :by_fecha_after
  has_scope :by_fecha_on
  has_scope :by_lugar

  PER_PAGE_RECORDS = 15

  def index
    content_type = params[:content_type]
    tipo = params[:tipo]
    if content_type.eql? "pdf"
      puts "PDF"
      if tipo.eql? "reporte_viajes"
        puts "TIPO"
        @viajes = apply_scopes(Viaje).order(:fecha_inicio).reverse_order
        render xlsx: 'viajes', filename: "viajes.xlsx"
      end
    else
      if params[:ids]
        @viajes = apply_scopes(Viaje).page.per(params[:ids].length)
      else
        @viajes = apply_scopes(Viaje).page(params[:page]).per(PER_PAGE_RECORDS)
      end

      render json: @viajes, meta: {total: apply_scopes(Viaje).all.count, total_pages: @viajes.num_pages}
    end
  end

  def show
    respond_with Viaje.unscoped.find(params[:id])
  end

  def new
    respond_with Viaje.new
  end
  def create
    @viaje = Viaje.new(viaje_params)
    if (not params[:viaje][:viaje_colaboradores].nil?)
      viaje_colaboradores = []
      params[:viaje][:viaje_colaboradores].each do |viajeColaborador|
        viaje_colaborador = ViajeColaborador.new(colaborador_id: viajeColaborador[:colaborador_id],observacion: viajeColaborador[:observacion],costo_ticket:viajeColaborador[:costo_ticket],costo_estadia:viajeColaborador[:costo_estadia],companhia:viajeColaborador[:companhia])
        viaje_colaboradores.push(viaje_colaborador)
      end
      @viaje.viaje_colaboradores = viaje_colaboradores
    end
    @viaje.save
    respond_with @viaje, location: nil
  end

  def update
    @viaje = Viaje.find_by(id: params[:id])
    if @viaje.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @viaje.update_attributes(viaje_params)

      if (not params[:viaje][:viaje_colaboradores].nil?)
        @viaje_colaboradores = []
        params[:viaje][:viaje_colaboradores].each do |viajeColaborador|
          @viaje_colaborador = ViajeColaborador.new(colaborador_id: viajeColaborador[:colaborador_id],observacion: viajeColaborador[:observacion],costo_ticket:viajeColaborador[:costo_ticket],costo_estadia:viajeColaborador[:costo_estadia],companhia:viajeColaborador[:companhia])
          @viaje_colaboradores.push(@viaje_colaborador)
        end

        lista_vieja = Viaje.find(params[:id])

         lista_vieja.viaje_colaboradores.map do |elementoViejo|
           if !@viaje_colaboradores.include?(elementoViejo)
             elementoViejo.destroy
           end
         end
        @viaje.viaje_colaboradores = @viaje_colaboradores
      else
        @viaje.viaje_colaboradores = []
      end
    end
    respond_with @viaje, location: nil
  end

	def destroy
    @viaje = Viaje.find_by(id: params[:id])
    if @viaje.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @viaje.destroy
			respond_with @viaje
  	end
  end

  def viaje_inner_params
    params.require(:viaje).permit(:descripcion,:fecha_inicio,:fecha_fin,:origen,:destino,viaje_colaboradores:[:viaje_id,:colaborador_id,:companhia,:observacion,:costo_estadia,:costo_ticket])
  end
  def viaje_params
    params.require(:viaje).permit(:descripcion,:fecha_inicio,:fecha_fin,:origen,:destino,:ids => [])
  end
end
