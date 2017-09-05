# coding: utf-8
class API::V1::FichasOdontologiaController < ApplicationController
  respond_to :json

  has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  has_scope :ids, type: :array
  has_scope :unpaged, :type => :boolean
  has_scope :paciente_id

  PER_PAGE_RECORDS = 15

  def index
    puts "CONTROLLER FICHA"
    if params[:ids]
      @fichas_odontologia = apply_scopes(FichaOdontologia).page.per(params[:ids].length)
      render json: @fichas_odontologia, each_serializer: FichaOdontologiaSerializer,
        meta: {total: apply_scopes(FichaOdontologia).all.count, total_pages: 0}
    elsif params[:unpaged]
      @fichas_odontologia = apply_scopes(FichaOdontologia)
      puts "respondiendo a con la fiha odontologia"
      puts @fichas_odontologia
      render json: @fichas_odontologia, each_serializer: FichaOdontologiaSerializer,
        meta: {total: apply_scopes(FichaOdontologia).all.count, total_pages: 0}
    elsif params[:paciente_id]
      @fichas_odontologia = apply_scopes(FichaOdontologia)
      render json: @fichas_odontologia, each_serializer: FichaOdontologiaSerializer, meta: {total: apply_scopes(FichaOdontologia).all.count, total_pages: 1}
    else
      @fichas_odontologia = apply_scopes(FichaOdontologia)
      .page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @fichas_odontologia, each_serializer: FichaOdontologiaSerializer, meta: {total: apply_scopes(FichaOdontologia).all.count, total_pages: @fichas_odontologia.num_pages}
    end
  end

  def show
    puts "respondiendo a con la fiha odontologia"
    puts FichaOdontologia.find(params[:id])
    respond_with FichaOdontologia.find(params[:id])
  end

  def new
    respond_with FichaOdontologia.new
  end

  def create
    @ficha_odontologia = FichaOdontologia.new()
    fparams = params[:ficha_odontologia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    if @paciente != nil
      @ficha_odontologia.update_attribute(:paciente_id, fparams[:paciente_id])
      @ficha_odontologia.update_attribute(:recien_nacido, fparams[:recien_nacido].to_json)
      @ficha_odontologia.update_attribute(:examen_clinico, fparams[:examen_clinico].to_json)
      @ficha_odontologia.update_attribute(:odontograma, fparams[:odontograma].to_json)
      @ficha_odontologia.update_attribute(:preescolar_adolescente, fparams[:preescolar_adolescente].to_json)
      @ficha_odontologia.update_attribute(:estado, 'VIGENTE');
      @ficha_odontologia.update_attribute(:paciente_id, fparams[:paciente_id]);

      @ficha_odontologia.update_attribute(:nro_ficha, Paciente.get_next_nro_ficha()[0]["nro_ficha"])

      @ficha_odontologia.save

      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_odontologia.nro_ficha
        @consulta.save
      end

      if !fparams[:consulta_detalles].nil?
        fparams[:consulta_detalles].each do |det|
          detalle = ConsultaDetalle.new()
          detalle.update_attribute(:cantidad, 1)
          detalle.update_attribute(:referencia_id, det[:referencia_id])
          detalle.update_attribute(:referencia_nombre, det[:referencia_nombre])
          detalle.update_attribute(:estado, det[:estado])
          detalle.update_attribute(:id_ficha, @ficha_odontologia.id)
          detalle.update_attribute(:fecha_inicio, det[:fecha_inicio])
          detalle.update_attribute(:fecha_fin, det[:fecha_fin])
          detalle.update_attribute(:producto_id, det[:producto_id])
          detalle.save()
        end
      end
      respond_with @ficha_odontologia
    else
      puts "responder con error"
    end
  end

  def update
    @ficha_odontologia = FichaOdontologia.new()
    fparams = params[:ficha_odontologia]
    @paciente = Paciente.find_by(id: fparams[:paciente_id])
    @ficha_anterior = FichaOdontologia.find(Integer(params[:id]))
    puts "Actualizando Nro. Ficha: #{@ficha_anterior.nro_ficha}"

    if @paciente != nil
      puts "Creando nueva versión de ficha #{@ficha_anterior.nro_ficha}"

      @ficha_odontologia.update_attribute(:paciente_id, fparams[:paciente_id])
      @ficha_odontologia.update_attribute(:recien_nacido, fparams[:recien_nacido].to_json)
      @ficha_odontologia.update_attribute(:examen_clinico, fparams[:examen_clinico].to_json)
      @ficha_odontologia.update_attribute(:odontograma, fparams[:odontograma].to_json)
      @ficha_odontologia.update_attribute(:preescolar_adolescente, fparams[:preescolar_adolescente].to_json)
      @ficha_odontologia.update_attribute(:paciente_id, fparams[:paciente_id]);

      @ficha_odontologia.assign_attributes({:nro_ficha => @ficha_anterior.nro_ficha})
      @ficha_odontologia.save

      @detalle_anterior = ConsultaDetalle.find_by(id_ficha: @ficha_anterior.id)
      if !fparams[:consulta_detalles].nil?
        fparams[:consulta_detalles].each do |det|
          detalle = ConsultaDetalle.new()
          detalle.update_attribute(:cantidad, 1)
          detalle.update_attribute(:referencia_id, det[:referencia_id])
          detalle.update_attribute(:referencia_nombre, det[:referencia_nombre])
          detalle.update_attribute(:estado, det[:estado])
          detalle.update_attribute(:id_ficha, @ficha_odontologia.id)
          detalle.update_attribute(:fecha_inicio, det[:fecha_inicio])
          detalle.update_attribute(:fecha_fin, det[:fecha_fin])
          detalle.update_attribute(:producto_id, det[:producto_id])
          if (detalle.hash != @detalle_anterior.hash)
            detalle.save()
          end
        end
      end


      @ficha_nueva = FichaOdontologia.find(@ficha_odontologia.id)
      #comento momentaneamente ya que los detalles pueden variar pero el resto de la ficha no

      # if (@ficha_anterior.recien_nacido.hash == @ficha_nueva.recien_nacido.hash &&
      #     @ficha_anterior.examen_clinico.hash == @ficha_nueva.examen_clinico.hash &&
      #     @ficha_anterior.odontograma.hash == @ficha_nueva.odontograma.hash &&
      #     @ficha_anterior.preescolar_adolescente.hash == @ficha_nueva.preescolar_adolescente.hash)
      #   @ficha_nueva.destroy
      # else
        @ficha_anterior.update_attribute(:estado, 'HISTORICO');
        @ficha_anterior.save

        @ficha_nueva.update_attribute(:estado, 'VIGENTE');
        @ficha_nueva.save
#      end
      puts "Actualizando el nro. de ficha <#{@ficha_anterior.nro_ficha}> utilizada en la consulta"
      if(fparams[:consulta_id])
        @consulta =  Consulta.find_by(id: fparams[:consulta_id])
        @consulta.nro_ficha =  @ficha_anterior.nro_ficha
        @consulta.save
      end
      respond_with @ficha_odontologia
    end
  end
end
