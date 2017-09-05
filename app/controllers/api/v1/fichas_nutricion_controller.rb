class API::V1::FichasNutricionController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_fichas_nutricion" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_fichas_nutricion" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_fichas_nutricion" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_fichas_nutricion" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_fichas_nutricion" end

  has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  has_scope :paciente_id

  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @fichas_nutricion = apply_scopes(FichaNutricion).page.per(params[:ids].length)
      render json: @fichas_nutricion,
        each_serializer: FichaNutricionSerializer,
        meta: {total: apply_scopes(FichaNutricion).all.count, total_pages: 0}
    elsif params[:unpaged]
      @fichas_nutricion = apply_scopes(FichaNutricion)
      render json: @fichas_nutricion,
        each_serializer: FichaNutricionSerializer,
        meta: {total: apply_scopes(FichaNutricion).all.count, total_pages: 0}
    else
      @fichas_nutricion = apply_scopes(FichaNutricion)
      .page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @fichas_nutricion,
        each_serializer: FichaNutricionSerializer,
        meta: {total: apply_scopes(FichaNutricion).all.count,
               total_pages: @fichas_nutricion.num_pages}
        end
  end

  def show
    respond_with FichaNutricion.find(params[:id])
  end

  def new
    respond_with FichaNutricion.new
  end

  def create
    @ficha_nutricion = FichaNutricion.new()
    fparams = params[:ficha_nutricion]
    @paciente = Paciente.find_by(id: params[:ficha_nutricion][:paciente_id])
    if @paciente != nil
      puts "Creando nueva ficha!"
      @ficha_nutricion.update_attribute(:datos, fparams[:datos].to_json)
      @ficha_nutricion.update_attribute(:paciente, @paciente)
      @ficha_nutricion.update_attribute(:nro_ficha, Paciente.get_next_nro_ficha()[0]["nro_ficha"])
      @ficha_nutricion.update_attribute(:estado, 'VIGENTE');
      @ficha_nutricion.save

      puts "Actualizando el nro. de ficha <#{@ficha_nutricion.nro_ficha}> utilizada en la consulta"
      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_nutricion.nro_ficha
        @consulta.save
      end

      respond_with @ficha_nutricion
    else
      puts "RESPONDER CON ERROR  / EL PACIENTE NO EXISTE"
    end
  end

  def update
    @ficha_nutricion = FichaNutricion.new()
    fparams = params[:ficha_nutricion]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])

    @ficha_anterior = FichaNutricion.find_by(id: params[:id])
    puts "Actualizando Nro. Ficha: #{@ficha_anterior.nro_ficha}"

    if @paciente != nil
      puts "Creando nueva versión de ficha #{@ficha_anterior.nro_ficha}"
      @ficha_nutricion.update_attribute(:datos, fparams[:datos].to_json)
      @ficha_nutricion.update_attribute(:paciente, @paciente)
      @ficha_nutricion.update_attribute(:nro_ficha, @ficha_anterior.nro_ficha)
      @ficha_nutricion.update_attribute(:estado, 'VIGENTE');
      @ficha_nutricion.save
      @ficha_nueva = FichaNutricion.find(@ficha_nutricion.id)

      if (@ficha_anterior.datos.hash == @ficha_nueva.datos.hash)
        @ficha_nueva.destroy
      else
        puts "Actualizando ficha #{@ficha_anterior.nro_ficha} a HISTORICO"

        @ficha_anterior.update_attribute(:estado, 'HISTORICO');
        @ficha_anterior.save

        @ficha_nueva.update_attribute(:estado, 'VIGENTE');
        @ficha_nueva.save
      end

      puts "Actualizando el nro. de ficha <#{@ficha_anterior.nro_ficha}> utilizada en la consulta"
      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_anterior.nro_ficha
        @consulta.save
      end

      respond_with @ficha_nutricion
    else
      puts "RESPONDER CON ERROR  / EL PACIENTE NO EXISTE"
    end
  end

  def destroy
    @ficha_nutricion = FichaNutricion.find_by(id: params[:id])
    if @ficha_nutricion.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ficha_nutricion.destroy
      respond_with @ficha_nutricion
    end
  end

end
