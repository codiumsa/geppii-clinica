class API::V1::SucursalUsuariosController < ApplicationController
  respond_to :json
    
  has_scope :by_usuario
  PER_PAGE_RECORDS = 15
    
  def index
    @sucursal_usuarios = apply_scopes(SucursalUsuario).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @sucursal_usuarios, each_serializer: SucursalUsuarioSerializer, meta: {total: apply_scopes(SucursalUsuario).all.count, total_pages: @sucursal_usuarios.num_pages}
  end

  def show
    respond_with SucursalUsuario.find(params[:id])
  end

  def new
    respond_with SucursalUsuario.new
  end

  def create
    @sucursal_usuario = SucursalUsuario.new(sucursal_usuarios_params)
    @sucursal_usuario.save
    respond_with @sucursal_usuario, location: nil
  end

  def update
    @sucursal_usuario = SucursalUsuario.find_by(id: params[:id])
    if @sucursal_usuario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @sucursal_usuario.update_attributes(producto_params)
      respond_with @sucursal_usuario, location: nil
    end
  end

  def destroy
    @sucursal_usuario = SucursalUsuario.find_by(id: params[:id])
    if @sucursal_usuario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @sucursal_usuario.destroy
      respond_with @sucursal_usuario
    end
  end

  def sucursal_usuarios_params
    params.require(:sucursal_usuario).permit(:id, :sucursal_id, :usuario_id)
  end
end
