module SourcesHelper
  def javascript_files
    super + ['lightbox', 'treescroll']
  end
  
  def javascripts
    [super, include_tiny_mce_if_needed].join("\n")
  end  
  
  def formated_mms_pages(s) 
    str = "#{s.start_page}"
    if !s.start_line.nil?
      str += '.' + "#{s.start_line}"
    end
    if !s.end_page.nil? or !s.end_line.nil?
      str += '-'
      if !s.end_page.nil?
        str += "#{s.end_page}"
      end
      if !s.end_line.nil?
        str += '.' + "#{s.end_line}."
      end
    end
    return str
  end
end
