Rails.application.routes.draw do
  resources :blurbs
  resources :pop_up_categories do
    member do
      get :contract
      get :expand
    end
  end
  resources :categories do
    collection do
      get :list_with_features
      get :list_with_shapes
      get :list
      get :all
      get :add_curator
      get :all_with_features
      get :all_with_shapes
      match '/by_title/:title.:format' => 'categories#by_title'
    end
    member do
      get :list_with_features
      put :update_primary_description
      get :list_with_shapes
      get :detailed
      get :set_primary_description
      get :list
      get :all
      get :all_with_features
      get :all_with_shapes
      get :modify_title
    end
    resources :children, :controller => 'categories' do
      collection do
        get :add_curator
      end
      member do
        get :contract
        get :expand
        get :modify_title
      end
    end
    resources :iframe, :controller => 'categories' do
      collection do
        get :add_curator
      end
      member do
        get :contract
        get :expand
        get :modify_title
      end
    end
    resources :translated_titles do
      collection do
        get :add_author
      end    
    end
    resources :descriptions do
      collection do
        get :add_author
      end
      member do
        get :contract
        get :expand
      end
      resources :sources do
        member do
          get :contract
          get :expand
        end
        resources :translated_sources do
          collection do
            get :add_author
          end
        end
      end
    end
    resources :sources do
      member do
        get :contract
        get :expand
      end
      resources :translated_sources do
        collection do
          get :add_author
        end     
      end
    end
  end
  root :to => 'home#index'
  resources :places, :only => 'show'
  resources :media, :only => 'show', :path => 'media_objects'
  match '/:controller(/:action(/:id))'
end