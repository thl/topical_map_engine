class SourcesController < AclController
  before_filter :find_category
   
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
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    if !params[:description_id].nil?
      @description = Description.find(params[:description_id])
    end
    @source = Source.new(:creator => current_user, :language => ComplexScripts::Language.find_by_code('eng'))
    respond_to do |format|
      if params[:description_id].nil?
        @source.resource = @category
        #format.html {render :partial => 'descnew' if request.xhr?} # new.html.erb
        format.html {render :partial => 'new' if request.xhr?} # new.html.erb
      else
        @source.resource = @description
        #format.html {render :partial => 'new' if request.xhr?} # new.html.erb
        format.html {render :partial => 'new', :locals => {:description => @description} if request.xhr?}
      end
      
      format.xml  { render :xml => @source }
    end
  end

  # GET /sources/1/edit
  def edit
      @languages = ComplexScripts::Language.find(:all, :order => 'title')
    
    if !params[:description_id].nil?
      @description = Description.find(params[:description_id])
    end
    @source = Source.find(params[:id])
    respond_to do |format|
      if params[:description_id].nil?
        #@source.resource = @category
        format.html {render :partial => 'edit' if request.xhr?} # edit.html.erb
      else
        #@source.resource = @description
        format.html {render :partial => 'edit', :locals => {:description => @description} if request.xhr?}
      end
    end
  end

  # POST /sources
  # POST /sources.xml
  def create
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    
    if !params[:description_id].nil?
        @description = Description.find(params[:description_id])
    end
    @source = Source.new(params[:source])
    if params[:description_id].nil?
      @source.resource = @category
    else
      @source.resource = @description
    end

    respond_to do |format|
      if @source.save
        if request.xhr?
	        format.html do
		        if @category == @main_category 
		          render :partial => 'categories/main_show', :locals => {:category => @main_category}
		        else
              render :partial => 'categories/show'
		        end      	  		
		      end          
        else
          flash[:notice] = 'Source was successfully created.'
          format.html do
  			    if @category != @main_category 
  			      redirect_to category_child_url(@main_category, @category)
  			    else
  			      redirect_to(@category)
  			    end		
          end              
        end
        format.xml  { render :xml => @source, :status => :created, :location => @source }
      else
        format.html do
          if request.xhr?
            if params[:description_id].nil?
              render :partial => 'new'
            else
              render :partial => 'new', :locals => {:description => @description}
            end
          else
            render :action => 'new'
          end
        end        
        format.xml  { render :xml => @source.errors, :status => :unprocessable_entity }        
      end
    end
  end

  # PUT /sources/1
  # PUT /sources/1.xml
  def update
    @source = Source.find(params[:id])
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    if !params[:description_id].nil?
        @description = Description.find(params[:description_id])
    end
    if params[:description_id].nil?
      @source.resource = @category
    else
      @source.resource = @description
    end    

    respond_to do |format|
      if @source.update_attributes(params[:source])
        if request.xhr?
	        format.html do
		        if @category == @main_category 
		          render :partial => 'categories/main_show', :locals => {:category => @main_category}
		        else
              render :partial => 'categories/show'
		        end      	  		
		      end          
        else
          flash[:notice] = 'Source was successfully updated.'
          #format.html { redirect_to(@source) }
          format.html do
  			    if @category != @main_category 
  			      redirect_to category_child_url(@main_category, @category)
  			    else
  			      redirect_to(@category)
  			    end		
          end
        end
        format.xml  { head :ok }
      else
        format.html do
          if request.xhr?
            if params[:description_id].nil?
              render :partial => 'edit'
            else
              render :partial => 'edit', :locals => {:description => @description}
            end
          else
            render :action => 'edit'
          end
        end
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

 def contract
    @source =  nil
    s = Source.find(params[:id])
    if !params[:description_id].nil?
      resource = Description.find(params[:description_id])
    else
      resource = @category
    end
    render :partial => 'contracted', :locals => {:resource => resource, :s => s}
  end
  
  def expand
    
    @source = Source.find(params[:id])
    #if !params[:description_id].nil?
    if @source.resource_type == 'Category'
      @resource = @category
    else #'Description'
      @resource = Description.find(@source.resource_id)
    end
    render_sources
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
    
  def render_sources
    
    render :update do |page|
	    yield(page) if block_given?
	    if params[:description_id].nil?
        page.replace_html 'catsources_div', :partial => 'sources/index', :locals => { :resource => @resource}
      else
        page.replace_html 'descsources_div', :partial => 'sources/index', :locals => { :resource => @resource}
      end
	  end
  end        
end

