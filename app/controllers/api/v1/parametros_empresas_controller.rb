class API::V1::ParametrosEmpresasController < ApplicationController
	respond_to :json
	#before_filter :ensure_authenticated_user

	has_scope :unpaged, :type => :boolean
	has_scope :by_empresa
	has_scope :by_sucursal
    has_scope :by_soporta_caja_impresion
    has_scope :by_soporta_ajuste_inventario
    has_scope :by_soporta_sucursales
	has_scope :by_all_attributes, allow_blank: true
	has_scope :by_vendedor_en_venta
	has_scope :by_soporta_multimoneda
	has_scope :by_imei_en_venta_detalle
	has_scope :by_soporta_uso_interno
	has_scope :by_imprimir_remision
	has_scope :default_empresa


  def index
	  if (params[:default_empresa])
		render json: []<<@parametros_empresa, each_serializer: ParametrosEmpresaSerializer
	  elsif(params[:unpaged])
	    @parametros = apply_scopes(ParametrosEmpresa)
		render json: @parametros, each_serializer: ParametrosEmpresaSerializer, meta: {total: apply_scopes(ParametrosEmpresa).all.count, total_pages: 0}
	  end
  end

  def show
    if (params[:id] === 'default')
      respond_with ParametrosEmpresa.default_empresa().first()
    else
      respond_with ParametrosEmpresa.find(params[:id])
    end
  end
end
