ActionController::Routing::Routes.draw do |map|
  #map.resources :descriptions  # map.resources :tasks, :collection => {:create_file => :post}, :new => {:file => :get}
  map.resources :pop_up_categories, :member => {:expand => :get, :contract => :get}
  map.resources :categories, :member => {:modify_title => :get, :update_primary_description => :put, :set_primary_description => :get, :all => :get, :all_with_features => :get, :all_with_shapes => :get, :list => :get, :list_with_features => :get, :list_with_features => :get, :list_with_shapes => :get}, :collection => {:add_curator => :get, :all => :get, :all_with_features => :get, :all_with_shapes => :get, :list => :get, :list_with_features => :get, :list_with_shapes => :get} do |category|
    category.resources :children, :controller => 'categories', :member => {:expand => :get, :contract => :get, :modify_title => :get}, :collection => {:add_curator => :get}
    # Mapping this with resources may be overkill, as only the show action is used.  Is there a cleaner approach?
    category.resources :iframe, :controller => 'categories', :member => {:expand => :get, :contract => :get, :modify_title => :get}, :collection => {:add_curator => :get}
    category.resources :translated_titles, :collection => {:add_author => :get}
    category.resources :descriptions, :collection => {:add_author => :get}, :member => {:expand => :get, :contract => :get} do |description|
      description.resources :sources, :member => {:expand => :get, :contract => :get} do |source|
        source.resources :translated_sources, :collection => {:add_author => :get}
      end
    end
    category.resources :sources, :member => {:expand => :get, :contract => :get} do |source|
      source.resources :translated_sources, :collection => {:add_author => :get }
    end
  end
  map.with_options :path_prefix => 'categories', :controller => 'categories' do |categories|
    categories.by_title 'by_title/:title.:format', :action => 'by_title'
  end
  map.root :controller => 'home', :action => 'index'
  map.resources :places, :only => 'show'
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'  
end
