class CategorySweeper < ActionController::Caching::Sweeper
  observe Category
  FORMATS = ['xml', 'json']

  def before_update(category)
    return if !category.parent_id_changed?
    parent_id = category.parent_id_was
    return if parent_id.nil?
    parent = Category.find(parent_id)
    return if parent.nil?
    expire_ancestor_cache(category, parent.ancestors + [parent])
  end
    
  def after_save(category)
    expire_cache(category)
  end
  
  def before_destroy(category)
    expire_cache(category)
  end
  
  def expire_ancestor_cache(category, ancestors)
    paths = []
    options = {:skip_relative_url_root => true, :only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      ancestors.each{|root| paths += [category_children_url(root, options), all_category_url(root, options), list_category_url(root, options)]}
      ancestors.each{|root| paths += [all_with_features_category_url(root, options), list_with_features_category_url(root, options)]} if category.feature_count>0
      ancestors.each{|root| paths += [all_with_shapes_category_url(root, options), list_with_shapes_category_url(root, options)]} if category.shape_count>0
    end
    paths.each{|path| expire_page(path)}
  end
  
  def expire_cache(category)
    options = {:skip_relative_url_root => true, :only_path => true}
    expire_ancestor_cache(category, category.ancestors)
    FORMATS.each do |format|
      options[:format] = format
      paths = [category_url(category, options), detailed_category_url(category, options), all_categories_url(options), list_categories_url(options)]
      paths << categories_url(options) if category.parent.nil?
      paths += [list_with_features_categories_url(options), all_with_features_categories_url(options)] if category.feature_count>0
      paths += [list_with_shapes_categories_url(options), all_with_shapes_categories_url(options)] if category.shape_count>0
      paths.each{|path| expire_page(path)}
    end
  end
end