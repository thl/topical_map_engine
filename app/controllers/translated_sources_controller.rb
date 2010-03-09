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
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    @authors = Person.find(:all, :order => 'fullname')
    respond_to do |format|
      format.html {render :partial => 'new' if request.xhr?} # new.html.erb
      format.xml  { render :xml => @translated_source }
    end
  end

  # GET /translated_sources/1/edit
  def edit
    @translated_source = TranslatedSource.find(params[:id])
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    @authors = Person.find(:all, :order => 'fullname')    
    render :partial => 'edit' if request.xhr?
  end

  # POST /translated_sources
  # POST /translated_sources.xml
  def create
    #@translated_source = TranslatedSource.new(params[:translated_source])
    #source = Source.find(params[:source_id])
    @translated_source = @source.translated_sources.new(params[:translated_source])
    @translated_source.creator = current_user
    respond_to do |format|
      if @translated_source.save
        if request.xhr?
	        format.html do
		        if @category == @main_category 
		          render :partial => 'categories/main_show', :locals => {:category => @main_category}
		        else
              render :partial => 'categories/show'
		        end      	  		
		      end
      	else
	        flash[:notice] = 'TranslatedSource was successfully created.'
		      format.html do
			      if @category != @main_category 
			        redirect_to category_child_url(@main_category, @category)
			      else
			        redirect_to(@category)
			      end		  	
		      end		  	
        end
		    format.xml  { render :xml => @translated_source, :status => :created, :location => @translated_source }		
      else
        @languages = ComplexScripts::Language.find(:all, :order => 'title')
        @authors = Person.find(:all, :order => 'fullname')                
        format.html do
          if request.xhr?
            render :partial => 'new'
          else
            render :action => 'new'
          end
        end
        format.xml  { render :xml => @translated_source.errors, :status => :unprocessable_entity }
      end
    end    
  end

  # PUT /translated_sources/1
  # PUT /translated_sources/1.xml
  def update
    params[:translated_source][:author_ids] ||= []
    @translated_source = TranslatedSource.find(params[:id])
    @authors = Person.find(:all, :order => 'fullname')    
	  respond_to do |format|	
      if @translated_source.update_attributes(params[:translated_source])
	      if request.xhr?
		      format.html do
		        if @category == @main_category 
			        render :partial => 'categories/main_show', :locals => {:category => @main_category}
		        else
			        render :partial => 'categories/show'      	  		
		        end
	        end
		      format.xml  { head :ok }  	
  	    else
          flash[:notice] = 'TranslatedSource was successfully updated.'
	        format.html do
		        if @category != @main_category # if request.xhr?
		          redirect_to category_child_url(@main_category, @category)
		        else
		          redirect_to(@category)
		        end
		      end
		      format.xml  { head :ok }      	  	
        end
      else	
        @languages = ComplexScripts::Language.find(:all, :order => 'title')       
        format.html do
          if request.xhr?
            render :partial => 'edit'
          else
            render :action => 'edit'
          end
        end
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
        if request.xhr?
		      if @category == @main_category 
			      render :partial => 'categories/main_show', :locals => {:category => @main_category}
		      else
			      render :partial => 'categories/show'      	  		
		      end		  
        else
		      if @category != @main_category 
		        redirect_to category_child_url(@main_category, @category)
		      else
		        redirect_to(@category)
		      end          
        end
      end
      format.xml  { head :ok }
    end
  end
  
  def add_author
    @authors = Person.find(:all, :order => 'fullname')
    render :partial => 'authors_selector', :locals => {:selected => nil}
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
