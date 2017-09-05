# encoding: utf-8
class API::V1::TipoDocumentosController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  #before_filter :only => [:index] do |c| c.isAuthorized "BE_index_tipo_documentos" end

  has_scope :unpaged, :type => :boolean
  has_scope :by_id

  def index
    if params[:unpaged]
      @tipo_documentos = apply_scopes(TipoDocumento)
      render json: @tipo_documentos, each_serializer: TipoDocumentoSerializer, meta: {total: apply_scopes(TipoDocumento).all.count, total_pages: 0}
    else
      @tipo_documentos = apply_scopes(TipoDocumento).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @tipo_documentos, each_serializer: TipoDocumentoSerializer, meta: {total: apply_scopes(TipoDocumento).all.count, total_pages: @tipo_documentos.num_pages}
    end
  end

  def show
    respond_with TipoDocumento.find(params[:id])
  end
end
