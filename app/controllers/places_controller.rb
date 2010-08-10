class PlacesController < ApplicationController
  # GET /places
  # GET /places.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @places }
    end
  end

  # GET /places/1
  # GET /places/1.xml
  def show
    @feature = Feature.find(params[:id])
    @categories = Category.find_all_by_feature_id(@feature.fid)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @place }
    end
  end
end
