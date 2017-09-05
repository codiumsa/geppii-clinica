class API::V1::FichasFonoaudiologiaController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #  ActionController::Parameters.permit_all_parameters = true
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_fichas_fonoaudiologia" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_fichas_fonoaudiologia" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_fichas_fonoaudiologia" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_fichas_fonoaudiologia" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_fichas_fonoaudiologia" end

  has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  has_scope :paciente_id

  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @fichas_fonoaudiologia = apply_scopes(FichaFonoaudiologia).page.per(params[:ids].length)
      render json: @fichas_fonoaudiologia,
        each_serializer: FichaFonoaudiologiaSerializer,
        meta: {total: apply_scopes(FichaFonoaudiologia).all.count, total_pages: 0}
    elsif params[:unpaged]
      @fichas_fonoaudiologia = apply_scopes(FichaFonoaudiologia)
      render json: @fichas_fonoaudiologia,
        each_serializer: FichaFonoaudiologiaSerializer,
        meta: {total: apply_scopes(FichaFonoaudiologia).all.count, total_pages: 0}
    else
      @fichas_fonoaudiologia = apply_scopes(FichaFonoaudiologia)
      .page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @fichas_fonoaudiologia,
        each_serializer: FichaFonoaudiologiaSerializer,
        meta: {total: apply_scopes(FichaFonoaudiologia).all.count,
               total_pages: @fichas_fonoaudiologia.num_pages}
    end
  end

  def show
    respond_with FichaFonoaudiologia.find(params[:id])
  end

  def new
    respond_with FichaFonoaudiologia.new
  end

  def create
    @ficha_fonoaudiologia = FichaFonoaudiologia.new()
    fparams = params[:ficha_fonoaudiologia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    if @paciente != nil
      @ficha_fonoaudiologia.update_attribute(:comunicacion_lenguaje,
                                             fparams[:comunicacion_lenguaje].to_json)
      @ficha_fonoaudiologia.update_attribute(:estimulos,
                                             fparams[:estimulos].to_json)
      @ficha_fonoaudiologia.update_attribute(:alimentacion,
                                             fparams[:alimentacion].to_json)
      @ficha_fonoaudiologia.update_attribute(:fistula,
                                             fparams[:fistula].to_json)
      @ficha_fonoaudiologia.update_attribute(:estado, 'VIGENTE');

      @ficha_fonoaudiologia.update_attribute(:paciente_id,
                                             fparams[:paciente_id])
      @ficha_fonoaudiologia.update_attribute(:nro_ficha, Paciente.get_next_nro_ficha()[0]["nro_ficha"])
      @ficha_fonoaudiologia.save

      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_fonoaudiologia.nro_ficha
        @consulta.save
      end

      respond_with @ficha_fonoaudiologia
    else
      puts "responder con error"
    end
  end

  def update
    #@ficha_fonoaudiologia = FichaFonoaudiologia.find_by(id: params[:id])
    @ficha_fonoaudiologia = FichaFonoaudiologia.new()
    fparams = params[:ficha_fonoaudiologia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    puts fparams[:fistula].to_json
    @ficha_anterior = FichaFonoaudiologia.find(Integer(params[:id]))

    puts @paciente
    if @paciente != nil
      #@ficha_fonoaudiologia.update_attributes(ficha_fonoaudiologia_params)
      @ficha_fonoaudiologia.update_attribute(:comunicacion_lenguaje,
                                             fparams[:comunicacion_lenguaje].to_json)
      @ficha_fonoaudiologia.update_attribute(:estimulos,
                                             fparams[:estimulos].to_json)
      @ficha_fonoaudiologia.update_attribute(:alimentacion,
                                             fparams[:alimentacion].to_json)
      @ficha_fonoaudiologia.update_attribute(:fistula,
                                             fparams[:fistula].to_json)
      @ficha_fonoaudiologia.update_attribute(:paciente_id,
                                             fparams[:paciente_id])
      @ficha_fonoaudiologia.update_attribute(:nro_ficha, @ficha_anterior.nro_ficha)

      @ficha_fonoaudiologia.save
      @ficha_nueva = FichaFonoaudiologia.find(@ficha_fonoaudiologia.id)
      puts @ficha_nueva.comunicacion_lenguaje.hash == @ficha_anterior.comunicacion_lenguaje.hash
      puts @ficha_nueva.estimulos.hash == @ficha_anterior.estimulos.hash
      puts @ficha_nueva.alimentacion.hash == @ficha_anterior.alimentacion.hash
      puts @ficha_nueva.fistula.hash == @ficha_anterior.fistula.hash


      if(@ficha_nueva.comunicacion_lenguaje.hash == @ficha_anterior.comunicacion_lenguaje.hash && @ficha_nueva.estimulos.hash == @ficha_anterior.estimulos.hash && @ficha_nueva.alimentacion.hash == @ficha_anterior.alimentacion.hash && @ficha_nueva.fistula.hash == @ficha_anterior.fistula.hash)
        @ficha_nueva.destroy
      else
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

      #redireccionar a pacientes
      respond_with @ficha_fonoaudiologia
    end
  end

  def destroy
    @ficha_fonoaudiologia = FichaFonoaudiologia.find_by(id: params[:id])
    if @ficha_fonoaudiologia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ficha_fonoaudiologia.destroy
      respond_with @ficha_fonoaudiologia
    end
  end

  # def ficha_fonoaudiologia_params
  #   params
  #     .require(:ficha_fonoaudiologia)
  #     .permit(:id,
  #             :prioridad,
  #             :comunicacion_lenguaje,
  #             :estimulos,
  #             :alimentacion,
  #             :paciente_id)
  # end

end
