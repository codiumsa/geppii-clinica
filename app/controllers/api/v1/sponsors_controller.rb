# encoding: utf-8
require 'rubygems'
require 'zip'
require 'fileutils'

class API::V1::SponsorsController  < ApplicationController
  respond_to :json

  has_scope :by_activo
  has_scope :by_all_attributes
  has_scope :by_ciRuc
  has_scope :by_campanha_id
  has_scope :ignorar_sponsor_default
  has_scope :by_persona_id
  has_scope :by_persona
  has_scope :by_contacto_campanha
  has_scope :by_tipo_persona
  has_scope :by_tipo_patrocinador

  PER_PAGE_RECORDS = 15


  def index
    tipo = params[:content_type]

    if tipo.eql? "pdf"
      tipo_reporte = params[:report_type]

      if tipo_reporte.eql("reporte_sponsors")
        @sponsors = apply_scopes(Sponsor)
        pdf = SponsorsReportPdf.new(@sponsors)
        send_data pdf.render, filename: 'reporte_sponsors.pdf', type: 'application/pdf', disposition: 'attachment'
      end
    elsif tipo.eql? "xls"
      tipo_reporte = params[:tipo]
      if tipo_reporte.eql?("reporte_patrocinadores")
        @patrocinadores = apply_scopes(Sponsor).all
        render xlsx: 'patrocinadores', filename: "patrocinadores.xlsx"
      end
    else
      @sponsors = apply_scopes(Sponsor).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @sponsors, each_serializer: SponsorSerializer, meta: {total: apply_scopes(Sponsor).all.count, total_pages: @sponsors.num_pages}
    end
  end


  def show
    #respond_with Sponsor.unscoped.find(params[:id])
    @sponsor = Sponsor.find(params[:id])

    tipo = params[:content_type]

    if tipo.eql? "pdf"
      tipo_reporte = params[:report_type]

      case tipo_reporte
      when "reporte_legajo_sponsor"
        pdf = LegajoSponsorReportPdf.new(@sponsor)
        # cookie que indica a $.fileDownload que el archivo se descargó correctamente
        cookies[:fileDownload] = {
          value: "true",
          path: "/"
        }
        send_data pdf.render, filename: 'legajo_sponsor.pdf', type: 'application/pdf', disposition: 'attachment'
      end
    else
      respond_with @sponsor
    end
  end

  def new
    respond_with Sponsor.new
  end

  def create
    @sponsor = Sponsor.new(sponsor_inner_params)
    @sponsor.activo = true
    @sponsor.guardar
    persona_param = params[:sponsor][:persona]
    if(params[:sponsor][:id_persona].nil?)
      @persona = Persona.create(persona_param)
    else
      @persona = Persona.update(sponsor_inner_params[:id_persona], persona_param)
    end
    @persona.save!
    @sponsor.persona = @persona
    @sponsor.save!
    respond_with @sponsor
  end

  def update
    @sponsor = Sponsor.find_by(id: params[:id])
    @persona = Persona.find_by(id: @sponsor.persona_id)
    pparams = params[:sponsor][:persona]
    cparams = params[:sponsor]

    if @sponsor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      Persona.transaction do
        @sponsor.update_attributes(sponsor_inner_params)
        Persona.update(@sponsor.persona_id, pparams)
      end
      respond_with @sponsor
    end
  end

  def destroy
    @sponsor = Sponsor.find_by(id: params[:id])
    if @sponsor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @sponsor.activo = false
      @sponsor.save
      respond_with @sponsor
    end
  end

  def sponsor_params
    params.require(:sponsor).permit(:activo, :segmento, :id_persona, :contacto_nombre, :contacto_apellido, :contacto_celular, :contacto_email, :contacto_cargo, :tipo_sponsor, 
                                    persona: [:id, :tipo_persona, :ci_ruc, :razon_social, :nombre, :apellido, :direccion, :barrio, :telefono,
                                              :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id, :sexo, :numero_hijos,
                                              :estudios_realizados, :tipo_domicilio, :antiguedad_domicilio, :nacionalidad, :conyugue_id])
  end

  def sponsor_inner_params
    params.require(:sponsor).permit(:activo, :segmento, :persona_id, :empresa_id,:id_persona,:contacto_nombre, :contacto_apellido, :contacto_celular, :contacto_email, :contacto_cargo, :tipo_sponsor)
  end

  def persona_params
    params.require(:sponsor).require(:persona).permit(:id, :tipo_persona, :ci_ruc, :razon_social, :nombre, :apellido, :direccion, :barrio, :telefono,
                                                      :celular, :estado_civil, :fecha_nacimiento, :correo, :ciudad_id, :sexo, :numero_hijos,
                                                      :estudios_realizados, :tipo_domicilio, :antiguedad_domicilio, :nacionalidad, :conyugue_id,
                                                      conyugue: [:id, :nombre, :apellido, :nacionalidad, :cedula,
                                                                 :fecha_nacimiento, :lugar_nacimiento, :empleador, :actividad_empleador,
                                                                 :cargo, :profesion, :ingreso_mensual, :concepto_otros_ingresos, :otros_ingresos])
  end

  def conyugue_params
    params.require(:sponsor).require(:persona).require(:conyugue).permit(:id, :nombre, :apellido, :nacionalidad, :cedula,
                                                                         :fecha_nacimiento, :lugar_nacimiento, :empleador, :actividad_empleador,
                                                                         :cargo, :profesion, :ingreso_mensual, :concepto_otros_ingresos, :otros_ingresos)
  end
end
