class CategoriesController < AclController
  before_filter :find_main_category
  helper :pop_up_categories
  caches_page :index, :show, :all, :all_with_features, :list, :list_with_features, :if => :api_response?.to_proc
  cache_sweeper :category_sweeper, :only => [:create, :update, :destroy]
  
  def initialize
    super
    @guest_perms += [ 'categories/all', 'categories/all_with_features', 'categories/by_title', 'categories/contract', 'categories/expand', 'categories/iframe', 'categories/list', 'categories/list_with_features']
  end
  
  
  # GET /categories
  # GET /categories.xml
  def index
    if @main_category.nil?
      @categories = logged_in? ? Category.roots : Category.published_roots
    else
      @categories = logged_in? ? @main_category.children : @main_category.published_children
    end
    respond_to do |format|
      format.html do # index.html.erb
        if @main_category.nil?
          render :action => 'main_index'
        else
          render :action => 'index', :layout => 'multi_column'
        end
      end
      format.xml  { render :xml => @categories }
      format.json { render :json => @categories.to_json }
      format.csv do
        if @main_category.nil?
          descendant_ids = @categories.collect(&:id)
        else
          descendant_ids = @main_category.descendants
        end
        @languages = ComplexScripts::Language.find_by_sql(['SELECT DISTINCT languages.* FROM languages, translated_titles WHERE translated_titles.language_id = languages.id AND translated_titles.category_id IN (?) ORDER BY languages.title', descendant_ids])
      end
    end
  end

  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])
    if request.xhr?
      if @main_category.nil?
        #render :partial => 'show'
        render(:update) {|page| page.replace_html 'info', :partial => 'main_show', :locals => {:category => @category}}
      else
        render_tree do |page|
		      if @category == @main_category
            page.replace_html 'info', :partial => 'main_show', :locals => {:category => @main_category}
		      else
			      page.replace_html 'info', :partial => 'show'
		      end
        end 
      end
    else
      respond_to do |format|
        format.html do
          if @main_category.nil?
            #render :action => 'main_show'
          	redirect_to category_children_url(@category)
          else # show.html.erb
            if @category == @main_category
              redirect_to category_children_url(@main_category)
            else
              @ancestors_for_current = @category.ancestors.collect{|c| c.id}
              @ancestors_for_current << @category.id
              @categories = logged_in? ? @main_category.children : @main_category.published_children
              render :action => 'show', :layout => 'multi_column'
            end
          end
        end
        format.xml { render(:template => 'categories/show', :locals => {:category => @category, :with_children => false, :only_with_features => false})}
        format.json  { render :json => @category.to_json }
      end
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new(:creator => current_user)
    @curators = Person.find(:all, :order => 'fullname')
    if @main_category.nil?
      @category.published = false
      if session[:default_curator_id].nil?
        person = current_user.person
        session[:default_curator_id] = person.id if !person.nil?
      end
      respond_to do |format|
        format.html { render :action => 'main_new' }
        format.xml  { render :xml => @category }
      end      
    else
      @category.published = true
      parent_id = params[:parent_id]
      if !parent_id.blank?
        parent = Category.find(parent_id)
      else
        parent = @main_category
      end
      @category.parent = parent
      respond_to do |format|
        format.html do
          if request.xhr?
            render :partial => 'new'
          else # new.html.erb
            @ancestors_for_current = @category.ancestors.collect{|c| c.id}
            @ancestors_for_current << @category.id
            @categories = @main_category.children
            render :action => 'new', :layout => 'multi-column'
          end
        end
        format.xml  { render :xml => @category }
      end      
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @curators = Person.find(:all, :order => 'fullname')
    if request.xhr?
		  if @main_category.nil? # _main_edit.html.erb
		    render :partial => 'main_edit'
		  else # _edit.html.erb
		    render :partial => 'edit'
		  end
    else
      if @main_category.nil?
		    @main_category = @category
        @ancestors_for_current = @category.ancestors.collect{|c| c.id}
        @ancestors_for_current << @category.id
        @categories = @main_category.children
      	render :action => 'main_edit', :layout => 'multi_column'
		    # render :action => 'main_edit'
      else # edit.html.erb
        @ancestors_for_current = @category.ancestors.collect{|c| c.id}
        @ancestors_for_current << @category.id
        @categories = @main_category.children
        render :action => 'edit', :layout => 'multi_column'
      end
    end
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    @category.creator = current_user
    if @category.save
      curators = @category.curators
      session[:default_curator_id] = curators.first.id if curators.size==1
      category_title = @main_category.nil? ? Category.human_name.capitalize : @main_category.title.titleize      
      if request.xhr?
        #categories = @main_category.children
        #@ancestors_for_current = @category.ancestors.collect{|c| c.id}
        #@ancestors_for_current << @category.id
        #render :update do |page|
        #  page.replace_html 'info', :partial => 'show'
        #  page.replace_html 'navigation', :partial => 'index', :locals => {:margin_depth => 0, :categories => categories}
        #end
        render_tree {|page| page.replace_html 'info', :partial => 'show'}
      else
      	flash[:notice] = ts 'new.successful', :what => category_title
        respond_to do |format|
          format.html do 
            if @main_category.nil?
              redirect_to category_children_url(@category)
            else
              redirect_to category_child_url(@main_category, @category)
            end
          end
          format.xml  { render :xml => @category, :status => :created, :location => @category }
        end
      end
    else
      @curators = Person.find(:all, :order => 'fullname')
      if request.xhr?
        render(:update) {|page| page.replace_html 'container-left-5050', :partial => 'new'}
      else      
        respond_to do |format|
          format.html do
            if @main_category.nil?
              render :action => 'main_new'
            else
              render :action => 'new', :layout => 'multi-column'
            end
          end
          format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    params[:category][:curator_ids] ||= []
    @category = Category.find(params[:id])
    if !params[:primary].nil? 
      @primary = Category.find(params[:primary])
      @category.descriptions.update_all("is_main = 0")
      @category.descriptions.update_all("is_main = 1","id=#{@primary.id}")
    end
    @curators = Person.find(:all, :order => 'fullname')
    parent = @category.parent
    if @category.update_attributes(params[:category])
	    @category.reload
      new_parent = @category.root
      category_title = @main_category.nil? ? Category.human_name.capitalize : @main_category.title.titleize
      if request.xhr?
        if new_parent==@main_category
          render_tree {|page| page.replace_html 'info', :partial => 'show'}        			  				
        else
          render(:update) do |page|
            if new_parent==@category
            	if @main_category.nil?   #parent!=@category.parent
            	  page.replace_html 'info', :partial => 'main_show', :locals => {:category => @category}
            	else
            	  page.redirect_to category_children_url(@category)
            	end
            else
		  	     page.redirect_to category_child_url(new_parent, @category)
            end
          end
      	end
      else
        debugger
      	flash[:notice] = ts 'edit.successful', :what => category_title
        respond_to do |format|
          format.html do
            @main_category = new_parent if @main_category.nil? && !new_parent.nil?
            if @main_category.nil?
              redirect_to category_url(@category)
            else
              redirect_to category_child_url(@main_category, @category)
            end
          end
          format.xml  { head :ok }
        end
      end
    else
      if request.xhr?
        render :partial => 'edit'
      else
        respond_to do |format|
          format.html do
            if @main_category.nil?
              render :action => 'main_edit'
            else
              render :action => 'edit', :layout => 'multi_column'
            end
          end
          format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    title = @category.title
    parent = @category.parent
    @category.destroy
    if request.xhr?
      render :update do |page|
        page.replace_html 'info', ('%s deleted succesfully.'/title).s
        if parent.nil? || parent == @main_category
          categories = @main_category.children
          page.replace_html 'navigation', :partial => 'index', :locals => {:margin_depth => 0, :categories => categories}
        else
          @category = parent
          margin_depth = @category.ancestors.size
          page.replace_html "#{@category.id}_div", :partial => 'expanded', :object => @category, :locals => {:margin_depth => margin_depth}
        end
      end          
    else
      respond_to do |format|
        format.html do
          if @main_category.nil?
            redirect_to root_url
          else
            redirect_to category_children_url(@main_category)
          end
        end
        format.xml  { head :ok }
      end
    end
  end

  def expand
    @category = Category.find(params[:id])
    #margin_depth = params[:margin_depth].to_i
    #render :partial => 'expanded', :object => category, :locals => {:margin_depth => margin_depth}
    render_tree
  end

  def contract
    category = Category.find(params[:id])
    margin_depth = params[:margin_depth].to_i
    render :partial => 'contracted', :object => category, :locals => {:margin_depth => margin_depth}
  end
  
  def all
    @category = Category.find(params[:id])
    api_extended_render :category => @category, :with_children => true, :only_with_features => false
  end
  
  def all_with_features
    @category = Category.find(params[:id])
    api_extended_render :category => @category, :with_children => true, :only_with_features => true
  end

  def list
    @category = Category.find(params[:id])
    api_simple_render(@category)
  end

  def list_with_features
    @category = Category.find(params[:id])
    api_simple_render(@category, :only_with_features => true)
  end
  
  def by_title
    title = params[:title]
    if title.nil?
      @categories = logged_in? ? Category.roots : Category.published_roots
    else
      @categories = Category.find(:all, :conditions => {:title => title, :published => true}, :order => 'title')
    end
    respond_to do |format|
      format.html { render :action => 'main_index' }
      format.xml  { render :xml => @categories }
      format.json { render :json => @categories.to_json }
    end    
  end
    
  def add_curator
    @curators = Person.find(:all, :order => 'fullname')
    render :partial => 'curators_selector', :locals => {:selected => nil}
  end  
  
  def modify_title
    @category = Category.find(params[:id])
	  render :partial => 'title'
  end 
   
  def set_primary_description
    @category = Category.find(params[:id])
    render :partial => 'primary_selector'
  end

  def iframe
    @category = Category.find(params[:id])
    @categories = Category.roots
    @ancestors_for_current = @category.ancestors.collect{|c| c.id}
    @ancestors_for_current << @category.id
    @main_category = Category.find((@ancestors_for_current & @categories.collect{|c| c.id}).first)
    render :action => 'iframe', :layout => 'iframe'
  end


  private
  
  def find_main_category
	  category_id = params[:category_id] || params[:parent_id]
    if category_id.blank?
      @main_category = nil
    else
      @main_category = Category.find(category_id)
    end
  end  
  
  def render_tree
    categories = logged_in? ? @main_category.children : @main_category.published_children
	  @ancestors_for_current = @category.ancestors.collect{|c| c.id}
	  @ancestors_for_current << @category.id
	  render :update do |page|
	    yield(page) if block_given?
	    page.replace_html 'navigation', :partial => 'index', :locals => {:margin_depth => 0, :categories => categories}
	  end
  end
  
  def api_extended_render(locals)
    options = {:template => 'categories/show.xml.builder', :locals => locals}
    respond_to do |format|
      format.xml { render options }
      format.json  { render :json => Hash.from_xml(render_to_string(options)).to_json }
    end    
  end
  
  def api_simple_render(category, options={})
    categories = Category.find(category.self_and_descendants, :select => "id, title", :order => "title")
    # Remove the parent category
    categories.shift
    # If ?count=1, include counts of features
    if(options[:only_with_features])
      categories.collect!{|c| { "id" => c.id, "name" => c.title, "count" => c.feature_count.to_i } }
      categories.reject!{|c| c["count"].to_i <= 0 }
    else
      categories.collect!{|c| { "id" => c.id, "name" => c.title } }
    end
    categories.sort!{|a,b| a["name"] <=> b["name"] }
    respond_to do |format|
      format.xml { render :xml => categories.to_xml }
      format.json { render :json => categories.to_json }
    end   
  end
  
  def api_response?
    request.format.json? || request.format.xml?
  end
end