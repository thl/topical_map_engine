class TranslatedSourcesController < AclController
  before_filter :find_category, :find_source
  helper :sources
  
  # GET /translated_sources
  # GET /translated_sources.xml
  def index
    @translated_sources = @category.translated_sources
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @translated_sources }
    end
  end

  # GET /translated_sources/1
  # GET /translated_sources/1.xml
  def show
    @translated_source = TranslatedSource.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @translated_source }
    end
  end

  # GET /translated_sources/new
  # GET /translated_sources/new.xml
  def new
    #@source = Source.find(params[:source_id])
    @translated_source = TranslatedSource.new(:language => ComplexScripts::Language.find_by_code('bod'))
    @languages = ComplexScripts::Language.order('title')
    @authors = Person.order('fullname')
    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
      format.xml  { render :xml => @translated_source }
    end
  end

  # GET /translated_sources/1/edit
  def edit
    @translated_source = TranslatedSource.find(params[:id])
    @languages = ComplexScripts::Language.order('title')
    @authors = Person.order('fullname')
  end # edit.html.erb & edit.js.erb

  # POST /translated_sources
  # POST /translated_sources.xml
  def create
    #@translated_source = TranslatedSource.new(params[:translated_source])
    #source = Source.find(params[:source_id])
    @translated_source = @source.translated_sources.new(params[:translated_source])
    @translated_source.creator = current_user
    respond_to do |format|
      if @translated_source.save
        flash[:notice] = 'TranslatedSource was successfully created.'
	      format.html do
		      if @category != @main_category 
		        redirect_to category_child_url(@main_category, @category)
		      else
		        redirect_to(@category)
		      end		  	
	      end		  	
        format.js   { render 'categories/show' }
		    format.xml  { render :xml => @translated_source, :status => :created, :location => @translated_source }		
      else
        @languages = ComplexScripts::Language.order('title')
        @authors = Person.order('fullname')                
        format.html { render 'new' }
        format.js   { render 'new' }
        format.xml  { render :xml => @translated_source.errors, :status => :unprocessable_entity }
      end
    end    
  end

  # PUT /translated_sources/1
  # PUT /translated_sources/1.xml
  def update
    params[:translated_source][:author_ids] ||= []
    @translated_source = TranslatedSource.find(params[:id])
    @authors = Person.order('fullname')    
	  respond_to do |format|	
      if @translated_source.update_attributes(params[:translated_source])
        flash[:notice] = 'TranslatedSource was successfully updated.'
        format.html do
	        if @category != @main_category # if request.xhr?
	          redirect_to category_child_url(@main_category, @category)
	        else
	          redirect_to(@category)
	        end
	      end
	      format.js   { render 'categories/show' }
	      format.xml  { head :ok }
      else	
        @languages = ComplexScripts::Language.order('title')       
        format.html { render 'edit' }
        format.js   { render 'edit' }        
        format.xml  { render :xml => @translated_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /translated_sources/1
  # DELETE /translated_sources/1.xml
  def destroy
    @translated_source = TranslatedSource.find(params[:id])
    @translated_source.destroy
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
    @authors = Person.order('fullname')
  end
  
  private
  # This is tied to categories, but once other titles are translated it can get disentangled through request.request_uri
  def find_category
    @category = Category.find(params[:category_id])
	  @main_category = @category.root
  end
  
  def find_source
    @source = Source.find(params[:source_id])
  end
end
