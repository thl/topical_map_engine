class TranslatedTitleSweeper < ActionController::Caching::Sweeper
  observe TranslatedTitle
  FORMATS = ['xml', 'json']
    
  def after_save(translated_title)
    expire_cache(translated_title.category)
  end
  
  def before_destroy(translated_title)
    expire_cache(translated_title.category)
  end
    
  def expire_cache(category)
    options = {:skip_relative_url_root => true, :only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      expire_page(detailed_category_url(category, options))
    end
  end
end