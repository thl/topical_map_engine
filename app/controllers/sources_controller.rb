class SourcesController < AclController
  before_filter :find_category
  respond_to :html, :xml, :js
   
  def initialize
     super
     @guest_perms += [ 'sources/expand', 'sources/contract']
   end  
  
  # GET /sources
  # GET /sources.xml
  def index
    redirect_to category_child_url(@main_category,@category)
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    redirect_to category_child_url(@main_category,@category)
  end

  # GET /sources/new
  # GET /sources/new.xml
  def new
    @languages = ComplexScripts::Language.order('title')
    @source = Source.new(:language_id => ComplexScripts::Language.find_by_code('eng').id)
    if params[:description_id].nil?
      @description = nil
      @source.resource = @category
    else
      @description = Description.find(params[:description_id])
      @source.resource = @description
    end
    respond_with @source
  end

  # GET /sources/1/edit
  def edit
    @languages = ComplexScripts::Language.order('title')
    if params[:description_id].nil?
      @description = nil
    else
      @description = Description.find(params[:description_id])
    end
    @source = Source.find(params[:id])
    respond_with(@source)
  end

  # POST /sources
  # POST /sources.xml
  def create
    @source = Source.new(params[:source])
    @languages = ComplexScripts::Language.order('title')
    if params[:description_id].nil?
      @description = nil
      @source.resource = @category
    else
      @description = Description.find(params[:description_id])
      @source.resource = @description
    end
    @source.creator = current_user
    respond_to do |format|
      if @source.save
        format.html do
          flash[:notice] = 'Source was successfully created.'
			    if @category != @main_category 
			      redirect_to category_child_url(@main_category, @category)
			    else
			      redirect_to(@category)
			    end		
        end
        format.js   { render 'categories/show' }
        format.xml  { render :xml => @source, :status => :created, :location => @source }
      else
        format.html { render 'new' }
        format.js   { render 'new' }
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }        
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.xml
  def update
    @source = Source.find(params[:id])
    @languages = ComplexScripts::Language.order('title')
    if params[:description_id].nil?
      @description = nil
      @source.resource = @category
    else
      @description = Description.find(params[:description_id])
      @source.resource = @description
    end
    respond_to do |format|
      if @source.update_attributes(params[:source])
        format.html do
          flash[:notice] = 'Source was successfully updated.'
			    if @category != @main_category 
			      redirect_to category_child_url(@main_category, @category)
			    else
			      redirect_to(@category)
			    end		
        end
        format.js   { render 'categories/show' }
        format.xml  { head :ok }
      else
        format.html { render 'edit' }
        format.js   { render 'edit' }
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1
  # DELETE /sources/1.xml
  def destroy
    @source = Source.find(params[:id])
    @source.destroy

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

  def contract
     @source = Source.find(params[:id])
     if !params[:description_id].nil?
       @resource = Description.find(params[:description_id])
     else
       @resource = @category
     end
  end # renders contract.js.erb
  
  def expand
    @source = Source.find(params[:id])
    #if !params[:description_id].nil?
    if @source.resource_type == 'Category'
      @resource = @category
    else #'Description'
      @resource = Description.find(@source.resource_id)
    end
    render 'index' # .js.erb
  end
  
  private
  # This is tied to categories
  def find_category
    @category = Category.find(params[:category_id])
	  @main_category = @category.root
  end
    
  def source_url(source)
    category_source_url(@category, source)
  end    
end