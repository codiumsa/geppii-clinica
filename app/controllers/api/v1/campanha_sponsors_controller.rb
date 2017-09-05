class API::V1::CampanhaSponsorsController < ApplicationController
  respond_to :json

  has_scope :by_usuario
  PER_PAGE_RECORDS = 15

  def index
    @campanha_sponsors = apply_scopes(CampanhaSponsor).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @campanha_sponsors, each_serializer: CampanhaSponsorSerializer, meta: {total: apply_scopes(CampanhaSponsor).all.count, total_pages: @campanha_sponsors.num_pages}
  end

  def show
    respond_with CampanhaSponsor.find(params[:id])
  end

  def new
    respond_with CampanhaSponsor.new
  end

  def create
    @campanha_sponsor = CampanhaSponsor.new(campanha_sponsors_params)
    @campanha_sponsor.save
    respond_with @campanha_sponsor, location: nil
  end

  def update
    @campanha_sponsor = CampanhaSponsor.find_by(id: params[:id])
    if @campanha_sponsor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @campanha_sponsor.update_attributes(producto_params)
      respond_with @campanha_sponsor, location: nil
    end
  end

  def destroy
    @campanha_sponsor = CampanhaSponsor.find_by(id: params[:id])
    if @campanha_sponsor.nil?
      render json: {message: 'Resource not found'}, :status => :not_found
    else
      @campanha_sponsor.destroy
      respond_with @campanha_sponsor
    end
  end

  def campanha_sponsors_params
    params.require(:campanha_sponsor).permit(:id, :campanha_id, :sponsor_id)
  end
end
