class DescriptionsController < AclController
  before_filter :find_category
   
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
    default_language_id = session[:default_language_id]  || ComplexScripts::Language.find_by_locale(I18n.locale)
    @description = @category.descriptions.new(:creator => current_user, :language_id => default_language_id)
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    @authors = Person.find(:all, :order => 'fullname')
    respond_to do |format|
      format.html {render :partial => 'new' if request.xhr?} # new.html.erb
      format.xml  { render :xml => @description }
    end
  end

  # GET /descriptions/1/edit
  def edit
    @description = Description.find(params[:id])
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    @authors = Person.find(:all, :order => 'fullname')    
    render :partial => 'edit' if request.xhr?
  end

  # POST /descriptions
  # POST /descriptions.xml
  def create
    if @category.descriptions.empty?
      params[:description][:is_main] = "true"
    end
    @description = Description.new(params[:description])
    respond_to do |format|
      if @description.save
        authors = @description.authors
        session[:default_author_id] = authors.first.id if authors.size==1
        session[:default_language_id] = @description.language.id
        if request.xhr?
	        format.html do
		        if @category == @main_category 
		          render :partial => 'categories/main_show', :locals => {:category => @main_category}
		        else
              render :partial => 'categories/show'
		        end      	  		
		      end          
        else
          flash[:notice] = 'Description was successfully created.'
          format.html do
			      if @category != @main_category 
			        redirect_to category_child_url(@main_category, @category)
			      else
			        redirect_to(@category)
			      end		
          end              
        end
        format.xml  { render :xml => @description, :status => :created, :location => @description }
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
        format.xml  { render :xml => @description.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /descriptions/1
  # PUT /descriptions/1.xml
  def update
    params[:description][:author_ids] ||= []
    @description = Description.find(params[:id])
    @authors = Person.find(:all, :order => 'fullname')
    respond_to do |format|
      if @description.update_attributes(params[:description])
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
          flash[:notice] = 'Description was successfully updated.'
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
        @authors = Person.find(:all, :order => 'fullname')
        format.html do
          if request.xhr?
            render :partial => 'edit'
          else
            render :action => 'edit'
          end
        end        
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
  
  def contract
    @d = Description.find(params[:id])
    @description =  nil
    render :partial => 'contracted', :locals => {:category => @category, :d => @d}
  end
  
  def expand
    @d = Description.find(params[:id])
    @description =  Description.find(params[:id])
    #render :partial => 'expanded'
    render_descriptions
  end  
  
  private
  # This is tied to categories
  def find_category
    @category = Category.find(params[:category_id])
	  @main_category = @category.root
  end
    
  def description_url(description)
    category_description_url(@category, description)
  end
    
  def render_descriptions
    #find a way to save selected expanded description
    render :update do |page|
	    yield(page) if block_given?
	    page.replace_html 'descriptions_div', :partial => 'descriptions/index', :locals => { :category => @category, :d => @d}
	  end
  end        
end
