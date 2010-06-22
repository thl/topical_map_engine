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
    root = category.root
    FORMATS.each do |format|
      options = {:skip_relative_url_root => true, :only_path => true, :format => format}
      [category_url(category, options), categories_url(options), all_categories_url(options), all_with_features_categories_url(options), list_categories_url(options), list_with_features_categories_url(options),
       category_children_url(root, options), all_category_url(root, options), all_with_features_category_url(root, options), list_category_url(root, options), list_with_features_category_url(root, options)].each{|path| expire_page(path)}
    end
  end
end