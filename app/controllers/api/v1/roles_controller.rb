class API::V1::RolesController < ApplicationController
  respond_to :json
  has_scope :by_codigo
  has_scope :by_descripcion
  has_scope :by_username
  has_scope :ids, type: :array

  PER_PAGE_RECORDS = 15

  def index
    
    if params[:ids]
      @roles = apply_scopes(Rol).page.per(params[:ids].length)
    else
      @roles = apply_scopes(Rol).page(params[:page]).per(PER_PAGE_RECORDS)
    end

    render json: @roles, meta: {total: apply_scopes(Rol).all.count, total_pages: @roles.num_pages}      
  end
    
end
