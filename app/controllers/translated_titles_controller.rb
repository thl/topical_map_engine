class TranslatedTitlesController < AclController
  before_filter :find_category
  
  # GET /translated_titles
  # GET /translated_titles.xml
  def index
    @translated_titles = @category.translated_titles
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @translated_titles }
    end
  end

  # GET /translated_titles/1
  # GET /translated_titles/1.xml
  def show
    @translated_title = TranslatedTitle.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @translated_title }
    end
  end

  # GET /translated_titles/new
  # GET /translated_titles/new.xml
  def new
    # TODO: for now default to tibetan, in the future make this more complicated!
    @translated_title = TranslatedTitle.new(:language => ComplexScripts::Language.find_by_code('bod'))
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    @authors = Person.find(:all, :order => 'fullname')
    respond_to do |format|
      format.html {render :partial => 'new' if request.xhr?} # new.html.erb
      format.xml  { render :xml => @translated_title }
    end
  end

  # GET /translated_titles/1/edit
  def edit
    @translated_title = TranslatedTitle.find(params[:id])
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    @authors = Person.find(:all, :order => 'fullname')    
    render :partial => 'edit' if request.xhr?
  end

  # POST /translated_titles
  # POST /translated_titles.xml
  def create
    @translated_title = @category.translated_titles.new(params[:translated_title])
    @translated_title.creator = current_user
    respond_to do |format|
      if @translated_title.save
        if request.xhr?
	        format.html do
		        if @category == @main_category 
		          render :partial => 'categories/main_show', :locals => {:category => @main_category}
		        else
              render :partial => 'categories/show'
		        end      	  		
		      end
      	else
	        flash[:notice] = 'TranslatedTitle was successfully created.'
		      format.html do
			      if @category != @main_category 
			        redirect_to category_child_url(@main_category, @category)
			      else
			        redirect_to(@category)
			      end		  	
		      end		  	
        end
		    format.xml  { render :xml => @translated_title, :status => :created, :location => @translated_title }		
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
        format.xml  { render :xml => @translated_title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /translated_titles/1
  # PUT /translated_titles/1.xml
  def update
    params[:translated_title][:author_ids] ||= []
    @translated_title = TranslatedTitle.find(params[:id])
    @authors = Person.find(:all, :order => 'fullname')    
	  respond_to do |format|	
      if @translated_title.update_attributes(params[:translated_title])
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
          flash[:notice] = 'TranslatedTitle was successfully updated.'
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
        format.xml  { render :xml => @translated_title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /translated_titles/1
  # DELETE /translated_titles/1.xml
  def destroy
    @translated_title = TranslatedTitle.find(params[:id])
    @translated_title.destroy
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
  
  def translated_title_url(title)
    category_translated_title_url(@category, title)
  end
  
 
end
