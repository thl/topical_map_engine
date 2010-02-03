class PopUpCategoriesController < ApplicationController
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.find(:all, :conditions => {:parent_id => nil}, :order => 'title')
    selected_category_id = params[:selected_category_id]
    if selected_category_id.blank?
      @ancestors_for_current = Array.new
    else
      @pop_up_category = Category.find(selected_category_id)
      @ancestors_for_current = @pop_up_category.ancestors.collect{|c| c.id} + [@pop_up_category.id]
    end
    respond_to do |format|
      format.html { render :partial => 'select_index', :locals => {:categories => @categories} if request.xhr? }
      format.xml  { render :xml => @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @pop_up_category = Category.find(params[:id])
    @categories = Category.find(:all, :conditions => {:parent_id => nil}, :order => 'title')
    @ancestors_for_current = @pop_up_category.ancestors.collect{|c| c.id} + [@pop_up_category.id]
    if request.xhr?
      render :update do |page|
        page.replace_html 'pop_up_navigation', :partial => 'index', :locals => {:categories => @categories, :margin_depth => 0}
        page['current_category_id'].value = @pop_up_category.id
        page['current_category_title'].value = h(@pop_up_category.title)
        page['current_category_selector'].value = pop_up_categories_path(:selected_category_id => @pop_up_category)
      end
    else
      @categories = @pop_up_category.children
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @pop_up_category }
      end
    end
  end
  
  def expand
    category = Category.find(params[:id])
    margin_depth = params[:margin_depth].to_i
    render :partial => 'expanded', :object => category, :locals => {:margin_depth => margin_depth}
  end

  def contract
    category = Category.find(params[:id])
    margin_depth = params[:margin_depth].to_i
    render :partial => 'contracted', :object => category, :locals => {:margin_depth => margin_depth}
  end  
end