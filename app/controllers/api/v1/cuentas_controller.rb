class API::V1::CuentasController < ApplicationController
  respond_to :json

  def new
      respond_with Cuenta.new
  end

  def cuenta_params
      params.require(:cuenta).permit(:banco,:nro_cuenta,:moneda_id, :ids => [])
  end
end
