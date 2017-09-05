# encoding: utf-8
class API::V1::VinculoFamiliaresController < ApplicationController
  respond_to :json
  PER_PAGE_RECORDS = 15
  #before_filter :only => [:index] do |c| c.isAuthorized "BE_index_vinculo_familiares" end

  has_scope :unpaged, :type => :boolean
  has_scope :by_id

  def index
    if params[:unpaged]
      @vinculos_familiares = apply_scopes(VinculoFamiliar)
      render json: @vinculos_familiares, each_serializer: VinculoFamiliarSerializer, meta: {total: apply_scopes(VinculoFamiliar).all.count, total_pages: 0}
    else
      @vinculos_familiares = apply_scopes(VinculoFamiliar).page(params[:page]).per(PER_PAGE_RECORDS)
      render json: @vinculos_familiares, each_serializer: VinculoFamiliarSerializer, meta: {total: apply_scopes(VinculoFamiliar).all.count, total_pages: @vinculos_familiares.num_pages}
    end
  end

  def show
    respond_with VinculoFamiliar.find(params[:id])
  end
end
