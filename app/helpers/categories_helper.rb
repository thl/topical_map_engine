module CategoriesHelper
  def stylesheet_files
    super + ['lightbox']
  end
  
  def javascript_files
    super + ['lightbox', 'treescroll']
  end
  
  def javascripts
    [super, include_tiny_mce_if_needed].join("\n")
  end  
end