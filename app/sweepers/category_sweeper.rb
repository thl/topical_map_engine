class CategorySweeper < ActionController::Caching::Sweeper
  observe Category
  FORMATS = ['xml', 'json']
  
  def after_save(category)
    expire_cache(category)
  end
  
  def after_destroy(category)
    expire_cache(category)
  end
  
  def expire_cache(category)
    FORMATS.each{ |format| expire_page :controller => 'categories', :action => ['index', 'all', 'all_with_features', 'list', 'list_with_features'], :format => format }
    FORMATS.each{ |format| expire_page :controller => 'categories', :action => ['show', 'all', 'with_features', 'list_all', 'list_with_features'], :id => category.id, :format => format }
  end
end