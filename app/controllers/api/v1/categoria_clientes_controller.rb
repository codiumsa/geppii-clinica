class API::V1::CategoriaClientesController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  has_scope :by_nombre
  has_scope :by_all_attributes, allow_blank: true
  PER_PAGE_RECORDS = 15
  before_filter :only => [:index] do |c| c.isAuthorized "BE_index_categoria_clientes" end
    
  def index
    if params[:ids]
      respond_with CategoriaCliente.find(params[:ids])
    else
      @categoriaClientes = apply_scopes(CategoriaCliente).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @categoriaClientes, each_serializer: CategoriaClienteSerializer, meta: {total: apply_scopes(CategoriaCliente).all.count, total_pages: @categoriaClientes.num_pages}
    end
  end

  def show
    respond_with CategoriaCliente.find(params[:id])
  end

  def new
    respond_with CategoriaCliente.new
  end

  def create
    puts "create"

    if params[:categoria_cliente][:id]
      puts "=========================== \n"
      puts "tiene id!!!!"
      puts params[:id]
    end

    @categoriaCliente = CategoriaCliente.new(categoriaCliente_inner_params)

    promociones = Array.new
    if(not params[:categoria_cliente][:promociones].nil?)
      params[:categoria_cliente][:promociones].each do |d|
            @clientePromocion = Promocion.find(d[:id])
            if @clientePromocion
              promociones.push(@clientePromocion)
            end
        end
    end

    @categoriaCliente.promociones = promociones
    @categoriaCliente.guardar
   
    respond_with @categoriaCliente, location: nil
  end

  def update
    @categoriaClientes = CategoriaCliente.find_by(id: params[:id])

    puts "update"

    if @categoriaClientes.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      CategoriaCliente.transaction do
        promociones = []
        if(not params[:categoria_cliente][:promociones].nil?)
          params[:categoria_cliente][:promociones].each do |d|
            if(d[:exclusiva])
              @clientePromocion = Promocion.find(d[:id])
              promociones.push(@clientePromocion)
            end
          end
        end
        @categoriaClientes.promociones = promociones

        @categoriaClientes.update_attributes(promociones: promociones)
        @categoriaClientes.update_attributes(categoriaCliente_inner_params)
        respond_with @categoriaClientes, location: nil
      end
    end
  end

  def destroy
    @categoriaClientes = CategoriaCliente.find_by(id: params[:id])
    if @categoriaClientes.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @categoriaClientes.destroy
      respond_with @categoriaClientes
    end
  end

  def categoriaCliente_params
    params.require(:categoria_cliente).permit(:nombre,:descripcion, promociones:[:id, 
                            :descripcion, 
                            :fecha_vigencia_desde, 
                            :fecha_vigencia_hasta, 
                            :permanente, 
                            :exclusiva, 
                            :porcentaje_descuento,])
  end

  def categoriaCliente_inner_params
    params.require(:categoria_cliente).permit(:nombre,:descripcion)
  end
end
