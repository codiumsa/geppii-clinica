class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :set_locale

  after_filter :set_access_control_headers
  before_filter :get_parametros_empresa
  before_filter :fix_by_all_attributes

  def get_parametros_empresa
    if !@parametros_empresa
      @parametros_empresa = ParametrosEmpresa.default_empresa().first()
    end
    return @parametros_empresa
  end

  def handle_options_request
    head(:ok) if request.request_method == "OPTIONS"
  end

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
  end

  def is_true?(string)
    ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(string)
  end

  protected

  def is_report_request
    tipo = params[:content_type]
    retorno = false
    if tipo.eql? "pdf" or tipo.eql? "factura" or tipo.eql? "retencion" or tipo.eql? "uso_interno" or tipo.eql? "recibo_cuota"
      retorno = true
    end

    return retorno
  end
  # Renders a 401 status code if the current user is not authorized
  def ensure_authenticated_user
    puts "#{!is_report_request}"
    if !is_report_request
      head :unauthorized unless current_user
    end
    #head :unauthorized unless current_user
  end

  # Returns the active user associated with the access token if available
  def current_user
    api_key = APIKey.active.where(access_token: token).first
    if api_key
      return api_key.usuario
    else
      return nil
    end
  end

  def soporta_cajas_impresion
    empresa = current_sucursal.empresa
    params = ParametrosEmpresa.where(empresa: empresa).first
    return params.soporta_caja_impresion
  end

  def current_caja
    puts "Usuario #{current_user.id} Sucursal #{current_sucursal.id}"
    caja = Caja.where("usuario_id = ?", current_user.id).first
    puts "Caja encontrada: #{caja}"
    return caja
  end

  def current_sucursal
    api_key = APIKey.active.where(access_token: token).first
    if api_key
      if api_key.sucursal
        return api_key.sucursal
      else
        if !@sucursal
          @sucursal = Sucursal.by_empresa(get_parametros_empresa.default_empresa.id).first
          puts "Sucursal: #{@sucursal.to_yaml}"
        end
        return @sucursal
      end
    else
      return nil
    end
  end

  def current_caja_impresion
    api_key = APIKey.active.where(access_token: token).first
    if api_key
      return api_key.caja_impresion
    else
      return nil
    end
  end

  # Parses the access token from the header
  def token
    bearer = request.headers["HTTP_AUTHORIZATION"]

    # allows our tests to pass
    bearer ||= request.headers["rack.session"].try(:[], 'Authorization')

    if bearer.present?
      bearer.split.last
    else
      nil
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def isAuthorized (permiso)
    puts "Es un reporte: #{!is_report_request}"
    if !is_report_request
      head :unauthorized unless (current_user != nil && Usuario.where("id = ? ",current_user).first.isAuthorized(permiso))
    end
  end

  def isAuthorizedUserEdit (permiso)
    by_username = params[:by_username]
    u = Usuario.where("username = ? ",by_username).first
    id = u.nil? ? params[:id] : u.id
    user = current_user
    tiene_permiso = user != nil && Usuario.where("id = ? ",user.id).first.isAuthorized(permiso)
    self_edit = user != nil && user.id.to_s == id.to_s

    puts "\n\n\n\n\n\n\n\n\nTiene Permiso #{tiene_permiso} o Es el mismo user #{self_edit} (#{user.id} #{id})"
    if !is_report_request
      head :unauthorized unless (tiene_permiso or self_edit)
    end
  end

  def forbidden (msg)
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/403", :layout => false, :status => :forbidden }
      format.xml  { head :forbidden }
      format.any  { render :json => { :message => msg } }
    end
  end

  def fix_by_all_attributes
    return true
  end
end
