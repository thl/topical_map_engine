class MediaController < ApplicationController
  # GET /media/1
  # GET /media/1.xml
  def show
    @medium = Medium.find(params[:id])
    @categories = Category.find_all_by_medium_id(@medium.id)
    @title = "Topics Associated to Medium #{@medium.id}"
    respond_to do |format|
      format.html { render :template => 'categories/list' } # show.html.erb
    end
  end
end
