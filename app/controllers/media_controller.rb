class MediaController < ApplicationController
  # GET /media/1
  # GET /media/1.xml
  def show
    @medium = MmsIntegration::Medium.find(params[:id])
    @categories = Category.find_all_by_medium_id(@medium.id)
    @object_title = "#{MmsIntegration::Medium.human_attribute_name(:id)}#{@medium.id}"
    @object_type = MmsIntegration::Medium.human_name(:count => :many).titleize
    @object_url = MmsIntegration::Medium.element_url(@medium.id, :format => 'html')
    respond_to do |format|
      format.html { render :template => 'categories/list' } # show.html.erb
    end
  end
end
