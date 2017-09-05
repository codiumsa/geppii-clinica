# encoding: utf-8
class API::V1::DocumentosController < ApplicationController
  before_filter :ensure_authenticated_user
  respond_to :json

  has_scope :by_cliente

  PER_PAGE_RECORDS = 15

  def index
    @documentos = apply_scopes(Documento).page(params[:page]).per(PER_PAGE_RECORDS)

    for documento in @documentos
      documento.adjunto_url
    end

    render json: @documentos, each_serializer: DocumentoSerializer, meta: {total: apply_scopes(Documento).all.count, total_pages: @documentos.num_pages}
  end
  
  def adjunto
    documento = Documento.find(params[:id])

    if params[:adjunto]
      documento.update(:adjunto => params[:adjunto])
      documento.save
      render json: {url: documento.adjunto.url()}, :status => :ok
    else
      render json: {adjunto: 'No se paso archivo'}, status: :unprocessable_entity
    end
  end
end
