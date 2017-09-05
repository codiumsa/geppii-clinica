# encoding: utf-8
class API::V1::ConyuguesController < ApplicationController
  respond_to :json

  PER_PAGE_RECORDS = 15

  has_scope :by_id

  def index
    @conyugues = apply_scopes(Conyugue).page(params[:page]).per(PER_PAGE_RECORDS)
    render json: @conyugues, each_serializer: ConyugueSerializer, meta: {total: apply_scopes(Conyugue).all.count, total_pages: @conyugues.num_pages}
  end

  def show
    respond_with Conyugue.find(params[:id])
  end
end
