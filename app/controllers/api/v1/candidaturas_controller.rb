class API::V1::CandidaturasController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  has_scope :by_fecha_posible_before
  has_scope :by_fecha_posible_on
  has_scope :by_fecha_posible_after
  has_scope :by_excluye_campanhas
  has_scope :by_campanha_id
  def index

    tipo = params[:tipo]
    content_type = params[:content_type]
    if content_type.eql? "pdf"
      if tipo.eql? "reporte_candidaturas"
        @candidaturas = apply_scopes(Candidatura).order(:fecha_posible).reverse_order
        @by_fecha_posible_after = params[:by_fecha_posible_after]
        @by_fecha_posible_before = params[:by_fecha_posible_before]
        @by_fecha_posible_on = params[:by_fecha_posible_on]
        @by_campanha_id = params[:by_campanha_id]
        render xlsx: 'candidaturas',filename: "reporte_candidaturas.xlsx"
      end
    else
      if params[:ids]
        @candidaturas = apply_scopes(Candidatura).page.per(params[:ids].length)

      else
        @candidaturas = apply_scopes(Candidatura).page(params[:page]).per(PER_PAGE_RECORDS)
      end
      render json: @candidaturas, meta: {total: apply_scopes(Candidatura).all.count, total_pages: @candidaturas.num_pages}
    end
  end

  def show
    respond_with Candidatura.unscoped.find(params[:id])
  end

  def new
    respond_with Candidatura.new
  end
  def create

  end

  def update

  end

  def destroy

  end

end
