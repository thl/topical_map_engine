module CategoriesHelper
  def stylesheet_files
    super + ['lightbox']
  end
  #javascript_files & javascripts are loaded from sources helper 
end