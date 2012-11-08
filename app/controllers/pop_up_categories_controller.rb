class PopUpCategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.application_roots.order('title')
    selected_category_id = params[:selected_category_id]
    if selected_category_id.blank?
      @ancestors_for_current = Array.new
    else
      @pop_up_category = Category.find(selected_category_id)
      @ancestors_for_current = @pop_up_category.ancestors.collect{|c| c.id} + [@pop_up_category.id]
    end
    respond_to do |format|
      format.js
      format.html
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @pop_up_category = Category.find(params[:id])
    @categories = Category.application_roots.order('title')
    @ancestors_for_current = @pop_up_category.ancestors.collect{|c| c.id} + [@pop_up_category.id]
    respond_to do |format|
      format.html # show.html.erb
      format.js   # show.js.erb
      format.xml  { render :xml => @pop_up_category }
    end
  end
  
  def expand
    @category = Category.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
  end # expand.js.erb

  def contract
    @category = Category.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
  end  
end