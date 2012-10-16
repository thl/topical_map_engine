class DescriptionsController < AclController
  before_filter :find_category
  cache_sweeper :description_sweeper, :only => [:create, :update, :destroy]
  respond_to :html, :xml, :js
   
  def initialize
     super
     @guest_perms += ['descriptions/expand', 'descriptions/contract']
   end  
  
  # GET /descriptions
  # GET /descriptions.xml
  def index
    redirect_to category_child_url(@main_category,@category)
    #@descriptions = @category.descriptions
    #respond_to do |format|
    #  format.xml
    #end
  end

  # GET /descriptions/1
  # GET /descriptions/1.xml
  def show
    redirect_to category_child_url(@main_category,@category)
    #@description = Description.find(params[:id])
    #respond_to do |format|
    #  format.xml # { render :xml => @description }
    #end
  end

  # GET /descriptions/new
  # GET /descriptions/new.xml
  def new
    default_language_id = session[:default_language_id]  || ComplexScripts::Language.find_by_locale(I18n.locale).id
    @description = @category.descriptions.new(:language_id => default_language_id)
    @languages = ComplexScripts::Language.order('title')
    @authors = AuthenticatedSystem::Person.order('fullname')
    respond_with @description
  end
  
  # GET /descriptions/1/edit
  def edit
    @description = Description.find(params[:id])
    @languages = ComplexScripts::Language.order('title')
    @authors = AuthenticatedSystem::Person.order('fullname')
  end

  # POST /descriptions
  # POST /descriptions.xml
  def create
    if @category.descriptions.empty?
      params[:description][:is_main] = "true"
    end
    @description = Description.new(params[:description])
    @description.creator = current_user
    respond_to do |format|
      if @description.save
        authors = @description.authors
        session[:default_author_id] = authors.first.id if authors.size==1
        session[:default_language_id] = @description.language.id
        format.html do
          flash[:notice] = 'Description was successfully created.'
		      if @category != @main_category
		        redirect_to category_child_url(@main_category, @category)
		      else
		        redirect_to(@category)
		      end
        end
        format.js { render 'categories/show' }
        format.xml  { render :xml => @description, :status => :created, :location => @description }
      else
        @languages = ComplexScripts::Language.order('title')
        @authors = AuthenticatedSystem::Person.order('fullname')
        format.html {render 'new'}
        format.js   {render 'new'}
        format.xml  { render :xml => @description.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /descriptions/1
  # PUT /descriptions/1.xml
  def update
    params[:description][:author_ids] ||= []
    @description = Description.find(params[:id])
    @authors = AuthenticatedSystem::Person.order('fullname')
    respond_to do |format|
      if @description.update_attributes(params[:description])
        flash[:notice] = 'Description was successfully updated.'
        format.html do
	        if @category != @main_category # if request.xhr?
	          redirect_to category_child_url(@main_category, @category)
	        else
	          redirect_to(@category)
	        end
	      end
	      format.js { render 'categories/show' }
	      format.xml  { head :ok }
      else
        @languages = ComplexScripts::Language.order('title')
        @authors = AuthenticatedSystem::Person.order('fullname')
        format.html { render 'edit' }
        format.js   { render 'edit' } #.js.erb
        format.xml  { render :xml => @description.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /descriptions/1
  # DELETE /descriptions/1.xml
  def destroy
    @description = Description.find(params[:id])
    @description.destroy
    respond_to do |format|
      format.html do
	      if @category != @main_category 
	        redirect_to category_child_url(@main_category, @category)
	      else
	        redirect_to(@category)
	      end          
      end      
      format.js   { render 'categories/show' }
      format.xml  { head :ok }
    end
  end
   
  def add_author
    @authors = AuthenticatedSystem::Person.order('fullname')
  end     
  
  def contract
    @d = Description.find(params[:id])
    @description =  nil
  end # contract.js.erb
  
  def expand
    @d = Description.find(params[:id])
    @description =  Description.find(params[:id])
  end # expand.js.erb
  
  private
  # This is tied to categories
  def find_category
    @category = Category.find(params[:category_id])
	  @main_category = @category.root
  end
    
  def description_url(description)
    category_description_url(@category, description)
  end    
end
