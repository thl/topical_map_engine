module SourcesHelper
  def javascript_files
    super + ['treescroll']
  end
  
  def javascripts
    [super, include_tiny_mce_if_needed].join("\n")
  end  
end
