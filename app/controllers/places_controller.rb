class PlacesController < ApplicationController
  # GET /places/1
  # GET /places/1.xml
  def show
    @feature = Feature.find(params[:id])
    @categories = Category.find_all_by_feature_id(@feature.fid)
    @title = "Feature Types Associated to #{@feature.header}"
    respond_to do |format|
      format.html { render :template => 'categories/list' } # show.html.erb
    end
  end
end
