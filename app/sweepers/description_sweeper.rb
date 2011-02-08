class DescriptionSweeper < ActionController::Caching::Sweeper
  observe Description
  FORMATS = ['xml', 'json']
    
  def after_save(description)
    expire_cache(description.category)
  end
  
  def before_destroy(description)
    expire_cache(description.category)
  end
    
  def expire_cache(category)
    options = {:skip_relative_url_root => true, :only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      expire_page(detailed_category_url(category, options))
    end
  end
end