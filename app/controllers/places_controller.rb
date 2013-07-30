class PlacesController < ApplicationController
  # GET /places/1
  # GET /places/1.xml
  def show
    @feature = PlacesIntegration::Feature.find(params[:id])
    @categories = Category.find_all_by_feature_id(@feature.fid)
    @object_title = "#{@feature.header}"
    @object_type = "Place"
    @object_url = PlacesIntegration::Feature.element_url(@feature.fid, :format => 'html')
    respond_to do |format|
      format.html { render :template => 'categories/list' } # show.html.erb
    end
  end
end
