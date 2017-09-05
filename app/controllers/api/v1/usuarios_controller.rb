class API::V1::UsuariosController < ApplicationController
  respond_to :json
  before_filter :ensure_authenticated_user
  #before_filter :only => [:index]   do |c| c.isAuthorized "BE_index_usuarios" end
  before_filter :only => [:show]    do |c| c.isAuthorizedUserEdit "BE_show_usuarios" end
  before_filter :only => [:create]  do |c| c.isAuthorized "BE_post_usuarios" end
  before_filter :only => [:update]  do |c| c.isAuthorizedUserEdit "BE_put_usuarios" end
  before_filter :only => [:destroy] do |c| c.isAuthorized "BE_delete_usuarios" end

  has_scope :username

  has_scope :by_username
  has_scope :by_nombre
  has_scope :by_apellido
  has_scope :by_email
  has_scope :by_all_attributes, allow_blank: true
  has_scope :by_tiene_caja_asignada

  PER_PAGE_RECORDS = 15


  def index
    @usuarios = apply_scopes(Usuario).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @usuarios, each_serializer: UsuarioSerializer, meta: {total: apply_scopes(Usuario).all.count, total_pages: @usuarios.num_pages}

    #respond_with :usuario => @usuarios, :total_pages => @usuarios.num_pages, :total => Usuario.count

  end

  def show
    respond_with Usuario.find(params[:id])
  end

  def new
    respond_with Usuario.new
  end

  def create

    @usuario = Usuario.new(usuario_inner_params)
    @usuario.save!
    updateRelations @usuario
    respond_with @usuario
  end

  def update
    @usuario = Usuario.find_by(id: params[:id])
    if @usuario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      Usuario.transaction do
        updateRelations @usuario
      end
      respond_with @usuario
    end
  end


  def updateRelations usuario
    roles = []
    if(not params[:usuario][:roles].nil?)
      params[:usuario][:roles].each do |rol|
        rolObject = Rol.find(rol[:id])
        roles.push(rolObject)
      end
    end
    usuario.roles = roles

    sucursales = []
    if(not params[:usuario][:sucursales].nil?)
      params[:usuario][:sucursales].each do |sucursal|
        sucursalObject = Sucursal.find(sucursal[:id])
        sucursales.push(sucursalObject)
      end
    end
    usuario.sucursales = sucursales
    if(usuario.sucursales.nil? or usuario.sucursales.empty?)
      #Si el usuario no tiene ninguna sucursal, se le corresponde la sucursal
      #donde el user se encuentra logueado
      sucursales.push(current_sucursal)
      puts current_sucursal
      usuario.sucursales = sucursales
    end

    usuario.sucursales.each do |s|
      #Si no existe una caja para el user en la sucursal, se crea
      if(Caja.where("usuario_id = ? and sucursal_id = ?", usuario.id, s.id).first.nil?)
        caja_user = Caja.new
        caja_user.codigo = "caja_user_" + usuario.username
        caja_user.descripcion = "Caja Personal " + usuario.username
        caja_user.tipo_caja = "U"
        caja_user.sucursal_id = s.id
        puts "CREACION DE USUARIO ID #{usuario.id}"
        caja_user.usuario_id = usuario.id
        empresa = current_sucursal.empresa
        params = ParametrosEmpresa.where(empresa: empresa).first
        caja_user.moneda = params.moneda
        caja_user.save
      end
    end


    usuario.update_attributes(roles: roles, sucursales: sucursales)
    usuario.update_attributes(usuario_inner_params)
  end

  def destroy
    @usuario = Usuario.find_by(id: params[:id])
    if @usuario.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @usuario.destroy
      respond_with @usuario
    end
  end

  def usuario_params
    params.require(:usuario).permit(:nombre, :apellido, :email, :username, :password_digest, :password, :password_confirmation, sucursales: [:id, :codigo, :descripcion], roles: [:id, :codigo, :descripcion])
  end

  def usuario_inner_params
    params.require(:usuario).permit(:nombre, :apellido, :email, :username, :password_digest, :password, :password_confirmation)
  end
end
