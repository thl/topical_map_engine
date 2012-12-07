class CategoriesController < AclController
  before_filter :find_main_category
  helper :pop_up_categories
  caches_page :index, :show, :detailed, :all, :all_with_features, :all_with_shapes, :list, :list_with_features, :list_with_shapes, :if => Proc.new { |c| c.request.format.json? || c.request.format.xml? }
  cache_sweeper :category_sweeper, :only => [:create, :update, :destroy]
  helper :sources
  
  def initialize
    super
    @guest_perms += [ 'categories/all', 'categories/all_with_features', 'categories/all_with_shapes', 'categories/by_title', 'categories/contract', 'categories/expand', 'categories/contracted', 'categories/expanded', 'categories/iframe', 'categories/list', 'categories/list_with_features', 'categories/list_with_shapes', 'categories/detailed']
  end
  
  
  # GET /categories
  # GET /categories.xml
  def index
    if @main_category.nil?
      @categories = logged_in? ? Category.application_roots : Category.published_roots
      @tab_options ||= {}
      @tab_options[:entity] = Category.find(session[:current_category_id]) unless session[:current_category_id].blank?
    else
      @tab_options ||= {}
      @tab_options[:entity] = @main_category
      session[:current_category_id] = @main_category.id
      @categories = logged_in? ? @main_category.children : @main_category.published_children
    end
    respond_to do |format|
      format.html do # index.html.erb
        if @main_category.nil?
          render :action => 'main_index'
        else
          @current_tab_id = :topics
          render :action => 'index', :layout => 'multi_column'
        end
      end
      format.xml do 
  		  @categories.each do |cat|
  		    cat['parent_id'] = nil if ApplicationSettings.application_root_id==cat.parent_id
  		    cat['children_count'] = cat.children.length
		    end
      	render :xml => @categories
      end
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
    @current_tab_id = :topics
    @tab_options ||= {}
    @tab_options[:entity] = @category
    session[:current_category_id] = @category.id
    respond_to do |format|
      format.html do
        pu = params[:parent_url]
        if @main_category.nil?
          #render :action => 'main_show'
          redirect_to category_child_url(@category.application_root, @category) << ( pu.nil? ? '' : "?parent_url=" << pu )
        else # show.html.erb
          if @category == @main_category
            redirect_to category_children_url(@main_category) << ( pu.nil? ? '' : "?parent_url=" << pu )
          else
            @ancestors_for_current = @category.ancestors.collect{|c| c.id}
            @ancestors_for_current << @category.id
            @categories = logged_in? ? @main_category.children : @main_category.published_children
            # This isn't terribly clean. See routes.rb for a comment about iframe routing.
            if request.fullpath =~ /\/iframe\//
              render :action => 'iframe', :layout => 'iframe'
            else
              render :action => 'show', :layout => 'multi_column'
            end
          end
        end
      end
      format.js { render 'show' }
      format.xml do
        @category['parent_id'] = nil if ApplicationSettings.application_root_id==@category.parent_id
        @category['children_count'] = @category.children.size
      	render :xml => @category
      end
      format.json  { render :json => @category.to_json }
    end
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    @curators = AuthenticatedSystem::Person.order('fullname')
    if @main_category.nil?
      @category.parent_id = ApplicationSettings.application_root_id
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
          @ancestors_for_current = @category.ancestors.collect{|c| c.id}
          @ancestors_for_current << @category.id
          @categories = @main_category.children
          render :action => 'new', :layout => 'multi-column'
        end
        format.js # render new.js.erb
        format.xml  { render :xml => @category }
      end      
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
    @curators = AuthenticatedSystem::Person.order('fullname')
    respond_to do |format|
      format.html do
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
      format.js # edit.js.erb
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
      category_title = @main_category.nil? ? Category.model_name.human.capitalize : @main_category.title.titleize      
      respond_to do |format|
        format.js do
          if @main_category.nil?
            @categories = []
            @ancestors_for_current = nil
          else
            @categories = @main_category.children
            @ancestors_for_current = @category.ancestors.collect{|c| c.id}
            @ancestors_for_current << @category.id
          end
        end # render 'create'
        format.html do 
        	flash[:notice] = ts 'new.successful', :what => category_title
          if @main_category.nil?
            redirect_to category_children_url(@category)
          else
            redirect_to category_child_url(@main_category, @category)
          end
        end
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      end
    else
      @curators = AuthenticatedSystem::Person.order('fullname')
      respond_to do |format|
        format.js { render 'new' }
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

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    params_category = params[:category]
    params_category[:curator_ids] ||= [] if !params_category.nil?
    @category = Category.find(params[:id])
    if !params[:primary].nil?
      @primary = Category.find(params[:primary])
      @category.descriptions.update_all("is_main = 0")
      @category.descriptions.update_all("is_main = 1","id=#{@primary.id}")
    end
    @curators = AuthenticatedSystem::Person.order('fullname')
    parent = @category.parent
    if @category.update_attributes(params_category)
	    @category.reload
      @new_parent = @category.application_root
      category_title = @main_category.nil? ? Category.model_name.human.capitalize : @main_category.title.titleize
      flash[:notice] = ts 'edit.successful', :what => category_title
      respond_to do |format|
        format.html do
          @main_category = @new_parent if @main_category.nil? && !@new_parent.nil?
          if @main_category.nil?
            redirect_to category_url(@category)
          else
            redirect_to category_child_url(@main_category, @category)
          end
        end
        format.js do
          if @main_category.nil?
            @categories = []
            @ancestors_for_current = nil
          else
            @categories = @main_category.children
            @ancestors_for_current = @category.ancestors.collect{|c| c.id}
            @ancestors_for_current << @category.id
          end
        end   # update.js.erb
        format.xml  { head :ok }
      end    	
    else
      respond_to do |format|
        format.html do
          if @main_category.nil?
            render 'main_edit'
          else
            render 'edit', :layout => 'multi_column'
          end
        end
        format.js   { render 'edit' }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end      
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @title = @category.title
    @parent = @category.parent
    @category.destroy
    respond_to do |format|
      format.html do
        if @main_category.nil?
          redirect_to root_url
        else
          redirect_to category_children_url(@main_category)
        end
      end
      format.js # destroy.js.erb
      format.xml  { head :ok }
    end
  end

  def expand
    @category = Category.find(params[:id])
    #margin_depth = params[:margin_depth].to_i
    @categories = logged_in? ? @main_category.children : @main_category.published_children
	  @ancestors_for_current = @category.ancestors.collect{|c| c.id}
	  @ancestors_for_current << @category.id
  end # expand.js.erb

  def contract
    @category = Category.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
  end # contract.js.erb

  def expanded
    @node = Category.find(params[:id])
    @category = Category.find(params[:category_id])
    @main_category = Category.find(params[:main_category_id])
  end # renders expanded.js.erb

  def contracted
    @node = Category.find(params[:id])
    @category = Category.find(params[:category_id])
    @main_category = Category.find(params[:main_category_id])
  end # renders contracted.js.erb

  def detailed
    api_extended_render :with_descriptions => true, :with_translated_titles => true
  end
  
  def all
    api_extended_render :with_children => true, :only_with_features => false
  end
  
  def all_with_features
    api_extended_render :with_children => true, :only_with_features => true
  end

  def all_with_shapes
    api_extended_render :with_children => true, :only_with_shapes => true
  end

  def list
    api_simple_render
  end

  def list_with_features
    api_simple_render :only_with_features => true
  end

  def list_with_shapes
    api_simple_render :only_with_shapes => true
  end
  
  def by_title
    title = params[:title]
    if title.nil?
      @categories = logged_in? ? Category.application_roots : Category.published_roots
    else
      # first get exact match
      @categories = Category.where(:title => title, :published => true).order('title')
      # then try variations
      @categories = Category.where(['title like ? AND published = ?', "%#{title}%", true]).order('title') if @categories.empty?
    end
    respond_to do |format|
      format.html { render :action => 'main_index' }
      format.xml  { render :xml => @categories }
      format.json { render :json => @categories.to_json }
    end    
  end
    
  def add_curator
    @curators = AuthenticatedSystem::Person.order('fullname')
  end # renders add_curator.js.erb
  
  def modify_title
    @category = Category.find(params[:id])
  end # modify_title.js.erb
  
  def set_primary_description
    @category = Category.find(params[:id])
  end # renders set_primary_description.js.erb

  def iframe
    @category = Category.find(params[:id])
    @categories = Category.application_roots
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
  
  def api_extended_render(locals)
    param_id = params[:id]
    locals[:only_with_features] ||= false
    locals[:only_with_shapes] ||= false
    locals[:with_children] ||= false
    locals[:with_descriptions] ||= false
    locals[:with_translated_titles] ||= false
    if param_id.nil?
      categories = Category.published_roots
      if locals[:only_with_features]
        locals[:categories] = categories.find_all{|c| c.feature_count>0}
      elsif locals[:only_with_shapes]
        locals[:categories] = categories.find_all{|c| c.shape_count>0}
      else
        locals[:categories] = categories
      end
      options = {:template => 'categories/index.xml.builder'}
    else
      locals[:category] = Category.find(params[:id])
      options = {:template => 'categories/show.xml.builder'}
    end
    options[:locals] = locals
    respond_to do |format|
      format.xml { render options }
      format.json  { render :json => Hash.from_xml(render_to_string(options)).to_json }
    end    
  end
  
  def api_simple_render(options={})
    param_id = params[:id]
    if param_id.nil?
      categories = Category.published_roots_and_descendants.flatten
    else
      category = Category.find(params[:id])
      categories = category.self_and_descendants.flatten
      # Remove the parent category
      categories.shift
    end
    options[:only_with_features] ||= false
    options[:only_with_shapes] ||= false
    # If ?count=1, include counts of features
    if options[:only_with_features]
      categories.collect!{|c| { :id => c.id, :name => c.title, :count => c.feature_count.to_i } }
      categories.reject!{|c| c[:count].to_i <= 0 }
    elsif options[:only_with_shapes]
      categories.collect!{|c| { :id => c.id, :name => c.title, :count => c.shape_count.to_i } }
      categories.reject!{|c| c[:count].to_i <= 0 }
    else
      categories.collect!{|c| { :id => c.id, :name => c.title } }
    end
    categories.sort!{|a,b| a[:name].casecmp(b[:name]) }
    # deal with duplicates
    previous_name = nil
    previous_handled = false
    previous = nil
    for category in categories
      if !previous.nil? && previous_name.casecmp(category[:name])==0
        handle_duplicate(previous) if !previous_handled
        handle_duplicate(category)
        previous_handled = true
      else
        previous = category
        previous_name = category[:name].dup
        previous_handled = false
      end
    end
    categories.sort!{|a,b| a[:name].casecmp(b[:name]) }
    # duplicate_name_indices = duplicate_indices_by_key(categories, 'name')
    # duplicate_name_indices.each do |index|
    #  parent_category = Category.find(categories[index]['id']).parent
    #  categories[index]['name'] += " (#{parent_category.title})" unless parent_category.nil?
    #end
    respond_to do |format|
      format.xml { render :xml => categories.to_xml }
      format.json { render :json => categories.to_json }
    end   
  end
  
#  def duplicate_indices_by_key(array, key)
#    indices = []
#    size = array.size
#    (0...size).to_a.each do |i|
#      (i+1...size).to_a.each do |j|
#        indices.push(i, j) if array[i][key] == (array[j][key])
#      end
#    end
#    indices.uniq
#  end
  
  def handle_duplicate(category_hash)
    category = Category.find(category_hash[:id])
    parent = category.parent
    root = category.application_root
    disambiguation = ''
    disambiguation << root.title if !root.nil?
    disambiguation << " > #{parent.title}" if !parent.nil? && parent != root
    category_hash[:name] << " (#{disambiguation})" if !disambiguation.blank?
  end
end