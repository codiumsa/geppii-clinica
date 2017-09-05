# encoding: utf-8
class API::V1::SessionController < ApplicationController
  def create
    user = Usuario.where("username = ? OR email = ?", params[:username], params[:username]).first
    check_only = params[:check_only] == "1"

    if user
      apiTemp  = APIKey.active().user(user.id)
      #        puts apiTemp.to_yaml
      #        if apiTemp.empty?
      verificarPassword = user.authenticate(params[:password])
      id_sucursal = check_only ? current_sucursal.id : params[:sucursal].to_i
      #        else
      #            render json: {:errors =>"El usuario esta activo"}, status: 401
      #            return
      #        end

      #verificarSucursal = user.permitidoEnSucursal(id_sucursal)
      verificarSucursal = true

      if params.has_key? :cajaImpresion
        id_caja_impresion = check_only ? current_caja_impresion.id : params[:cajaImpresion].to_i
        caja_impresion = CajaImpresion.find(id_caja_impresion)
      end

      if verificarPassword && verificarSucursal
        puts "password ok sucursal ok #{check_only}"
        permisos = user.getPermisos
        sucursal = Sucursal.find(id_sucursal)

        if check_only
          if params.has_key? :cajaImpresion
            render json: {:username =>  params[:username], :nombre => user.nombre_completo, :sucursal => sucursal.descripcion, :caja_impresion => caja_impresion.nombre, :permisos => permisos }, status: 201
          else
            puts "respondiendo"
            render json: {:username =>  params[:username], :nombre => user.nombre_completo, :sucursal => sucursal.descripcion, :permisos => permisos }, status: 201
          end

        else
          if params.has_key? :cajaImpresion
            session = user.session_api_key(params[:sucursal], params[:cajaImpresion])
          else
            session = user.session_api_key(params[:sucursal], nil)
          end


          if params.has_key? :cajaImpresion
            render json: {:access_token => session.access_token, :token_type => 'bearer',
                          :username =>  params[:username], :nombre => user.nombre_completo, :sucursal => sucursal.descripcion, :caja_impresion => caja_impresion.nombre, :permisos => permisos }, status: 201
          else
            render json: {:access_token => session.access_token, :token_type => 'bearer',
                          :username =>  params[:username], :nombre => user.nombre_completo, :sucursal => sucursal.descripcion, :permisos => permisos }, status: 201
          end
        end
      else
        if not verificarSucursal
          render json: {:errors =>"Sin acceso a sucursal"}, status: 401
        else
          render json: {:errors =>"Credenciales no válidas"}, status: 401
        end
      end
    else
      render json: {:errors =>"Credenciales no válidas"}, status: 401
    end
  end
end
