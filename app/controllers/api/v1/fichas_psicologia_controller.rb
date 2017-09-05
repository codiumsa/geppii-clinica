# encoding: utf-8
class API::V1::FichasPsicologiaController < ApplicationController
  respond_to :json
  #before_filter :ensure_authenticated_user
  #  ActionController::Parameters.permit_all_parameters = true
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_fichas_psicologia" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_fichas_psicologia" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_fichas_psicologia" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_fichas_psicologia" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_fichas_psicologia" end

  # has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  has_scope :paciente_id

  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @fichas_psicologia = apply_scopes(FichaPsicologia).page.per(params[:ids].length)
      render json: @fichas_psicologia,
        each_serializer: FichaPsicologiaSerializer,
        meta: {total: apply_scopes(FichaPsicologia).all.count, total_pages: 0}
    elsif params[:unpaged]
      @fichas_psicologia = apply_scopes(FichaPsicologia)
      render json: @fichas_psicologia,
        each_serializer: FichaPsicologiaSerializer,
        meta: {total: apply_scopes(FichaPsicologia).all.count, total_pages: 0}
    else
      @fichas_psicologia = apply_scopes(FichaPsicologia)
      .page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @fichas_psicologia,
        each_serializer: FichaPsicologiaSerializer,
        meta: {total: apply_scopes(FichaPsicologia).all.count,
               total_pages: @fichas_psicologia.num_pages}
        end
  end

  def show
    respond_with FichaPsicologia.find(params[:id])
  end

  def new
    respond_with FichaPsicologia.new
  end

  def create
    @ficha_psicologia = FichaPsicologia.new()
    fparams = params[:ficha_psicologia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    # puts fparams[:fistula].to_json

    puts @paciente
    if @paciente != nil
      @ficha_psicologia.update_attribute(:paciente_id,fparams[:paciente_id])
      @ficha_psicologia.update_attribute(:comentarios,fparams[:comentarios])
      @ficha_psicologia.update_attribute(:confidencial,fparams[:confidencial])
      @ficha_psicologia.update_attribute(:estado, 'VIGENTE');
      @ficha_psicologia.update_attribute(:nro_ficha, Paciente.get_next_nro_ficha()[0]["nro_ficha"])
      @ficha_psicologia.save

      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_psicologia.nro_ficha
        @consulta.save
      end

      #redireccionar a pacientes
      respond_with @ficha_psicologia
    end
  end

  def update
    @ficha_psicologia = FichaPsicologia.new()
    fparams = params[:ficha_psicologia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    @ficha_anterior = FichaPsicologia.find(Integer(params[:id]))
    puts "Actualizando Nro. Ficha: #{@ficha_anterior.nro_ficha}"

    if @paciente != nil
      puts "Creando nueva versión de ficha #{@ficha_anterior.nro_ficha}"

      # @ficha_psicologia.assign_attributes({:id => params[:id]})
      @ficha_psicologia.assign_attributes({:paciente_id => fparams[:paciente_id]})
      @ficha_psicologia.assign_attributes({:comentarios => fparams[:comentarios]})
      @ficha_psicologia.assign_attributes({:confidencial => fparams[:confidencial]})
      @ficha_psicologia.assign_attributes({:nro_ficha => @ficha_anterior.nro_ficha})

      @ficha_psicologia.assign_attributes({:id => nil})
      @ficha_psicologia.save
      @ficha_nueva = FichaPsicologia.find(@ficha_psicologia.id)

      if (@ficha_anterior.comentarios.hash == @ficha_nueva.comentarios.hash) and
        (@ficha_anterior.confidencial.hash == @ficha_nueva.confidencial.hash)
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
      respond_with @ficha_psicologia
    end
  end

  def destroy
    @ficha_psicologia = FichaPsicologia.find_by(id: params[:id])
    if @ficha_psicologia.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @ficha_psicologia.destroy
      respond_with @ficha_psicologia
    end
  end

  # def fichas_psicologia_params
  #   params
  #     .require(:ficha_psicologia)
  #     .permit(:id,
  #             :colaborador_id,
  #             :fecha_consulta_inicial,
  #             :diagnostico_inicial,
  #             :tratamientos_realizados,
  #             :necesita_cirugia,
  #             :comentarios_adicionales,
  #             :paciente_id)
  # end

end
