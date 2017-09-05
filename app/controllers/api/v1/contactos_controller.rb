# encoding: utf-8
class API::V1::ContactosController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_contactos" end
  #before_filter :only => [:show]    do |c| c.isAuthorized "BE_show_contactos" end
  #before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_contactos" end
  #before_filter :only => [:update]  do |c| c.isAuthorized "BE_put_contactos" end
  #before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_contactos" end

  has_scope :ids, type: :array
  has_scope :by_campanha
  has_scope :by_all_attributes
  PER_PAGE_RECORDS = 15

  def index
    if params[:ids]
      @contactos = apply_scopes(Contacto).page.per(params[:ids].length).order(:created_at).reverse_order
    else
      @contactos = apply_scopes(Contacto).page(params[:page]).per(PER_PAGE_RECORDS).order(:created_at).reverse_order
    end

    render json: @contactos, each_serializer: ContactoSerializer,
      meta: {total: apply_scopes(Contacto).all.count, total_pages: @contactos.num_pages}
  end

  def show
    respond_with Contacto.find(params[:id])
  end

  def new
    respond_with Contacto.new
  end

  def create
    @contacto = Contacto.new(contacto_params)
    if (not params[:contacto][:contacto_detalles].nil?)
      contacto_detalles = []
      params[:contacto][:contacto_detalles].each do |contactoDetalle|
        contacto_detalle = ContactoDetalle.new(fecha: contactoDetalle[:fecha],fecha_siguiente: contactoDetalle[:fecha_siguiente],observacion: contactoDetalle[:observacion],comentario: contactoDetalle[:comentario],compromiso: contactoDetalle[:compromiso],estado: contactoDetalle[:estado],moneda_id: contactoDetalle[:moneda_id])
        contacto_detalles.push(contacto_detalle)
      end
      @contacto.contacto_detalles = contacto_detalles
    end
    @contacto.save
    respond_with @contacto, location: nil
  end

  def update
    @contacto = Contacto.find_by(id: params[:id])
    if @contacto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @contacto.update_attributes(contacto_params)
      @contacto.update_attribute(:campanha_id, params[:contacto][:campanha_id])


      if (not params[:contacto][:contacto_detalles].nil?)
        @contacto_detalles = []
        params[:contacto][:contacto_detalles].each do |contactoDetalle|
          @contacto_detalle = ContactoDetalle.new(fecha: contactoDetalle[:fecha],fecha_siguiente: contactoDetalle[:fecha_siguiente],observacion: contactoDetalle[:observacion],comentario: contactoDetalle[:comentario],compromiso: contactoDetalle[:compromiso],estado: contactoDetalle[:estado],moneda_id: contactoDetalle[:moneda_id])
          @contacto_detalles.push(@contacto_detalle)
        end

        lista_vieja = Contacto.find(params[:id])

         lista_vieja.contacto_detalles.map do |elementoViejo|
           if !@contacto_detalles.include?(elementoViejo)
             elementoViejo.destroy
           end
         end
        @contacto.contacto_detalles = @contacto_detalles
      else
        @contacto.contacto_detalles = []
      end
      respond_with @contacto, location: nil
    end
  end

  def destroy
    @contacto = Contacto.find_by(id: params[:id])
    if @contacto.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @contacto.destroy
      respond_with @contacto
    end
  end

  def contacto_params
    params.require(:contacto).permit(:id, :observacion, :fecha,
                                     :sponsor_id, :campanha_id, :tipo_contacto_id,:contacto_nombre,
                                     :contacto_apellido, :contacto_celular, :contacto_cargo,
                                     :ids => [])
  end

  def contacto_inner_params
    params.require(:contacto).permit(:id, :observacion, :fecha,
                                     :sponsor_id, :campanha_id, :tipo_contacto_id,:contacto_nombre,
                                     :contacto_apellido, :contacto_celular, :contacto_cargo,
                                     contacto_detalles: [:fecha, :fecha_siguiente, :observacion,:comentario,:compromiso,:estado,:moneda_id])
  end
end
