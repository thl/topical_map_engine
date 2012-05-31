# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # overrides link_to_remote in vendor/rails/action_pack/lib/action_view/prototype_helper.rb
  # THIS NEEDS TO BE RADICALLY FIXED!  
  #def link_to_remote(name, options = {}, html_options = {})
  #  html_options.merge!({:href => url_for(options[:url])}) if ( html_options[:href].nil? || html_options[:href].blank? ) && !options[:url].blank?
  #  link_to_function(name, remote_function(options), html_options || options.delete(:html))
  #end

  def side_column_links
    str = "<h3 class=\"head\">#{link_to 'Knowledge Maps', '#nogo', {:hreflang => 'Manage hierarchical controlled vocabulary to be used by other applications.'}}</h3>\n<ul>\n"
    str += "<li>#{link_to 'Home', root_path, {:hreflang => 'Lists all categories.'}}</li>\n"
	  str += "<li>#{link_to 'Intro', '#wiki=/access/wiki/site/c06fa8cf-c49c-4ebc-007f-482de5382105/knowledge%20maps%20|amp|%20controlled%20vocabulary.html', {:hreflang => 'General Introduction to kmaps.'}}</li>\n"
	  str += "<li>#{link_to 'Help', '#wiki=/access/wiki/site/c06fa8cf-c49c-4ebc-007f-482de5382105/knowledge%20maps%20|amp|%20controlled%20vocabulary%20user%20manual.html', {:hreflang => 'User Manual.'}}</li>\n"
	  str += "<li>#{link_to 'Editing Help', '#wiki=/access/wiki/site/c06fa8cf-c49c-4ebc-007f-482de5382105/knowledge%20maps%20|amp|%20controlled%20vocabulary%20editorial%20manual.html', {:hreflang => 'Editorial Manual.'}}</li>\n" if logged_in?
  	authorized_only(hash_for_languages_path) { str += "<li>#{link_to 'Languages', languages_path, {:hreflang => 'Manage languages used for translation of titles and interface.'}}</li>\n" }
    authorized_only(hash_for_people_path) { str += "<li>#{link_to 'People', people_path, {:hreflang => 'Manage people.'}}</li>\n" }
    authorized_only(hash_for_roles_path) { str += "<li>#{link_to 'Roles', roles_path, {:hreflang => 'Manage roles and their permissions.'}}</li>\n" }
    authorized_only(hash_for_permissions_path) { str += "<li>#{link_to 'Permissions', permissions_path, {:hreflang => 'Manage permissions and their descriptions.'}}</li>\n" }
    authorized_only(hash_for_blurbs_path) { str += "<li>#{link_to 'Blurbs', blurbs_path, {:hreflang => 'Manage blurbs.'}}</li>\n" }
    str += "</ul>"
    return str
  end
    
  def stylesheet_files
    super + ['tmb', 'jquery-ui-tabs']
  end
  
  def javascript_files
    super + ['jquery-ui-tabs']
  end
  
  def join_with_and(list)
    size = list.size
    case size
    when 0 then nil
    when 1 then list.first
    when 2 then list.join(' and ')
    when 3 then [list[0..size-2].join(', '), list[size-1]].join(', and ')
    end
  end
  
  def formated_mms_pages(s)
    str = "#{Source.human_attribute_name(:mms_id).s} \##{s.mms_id}" 
    pages_str = s.start_page.to_s
    if !s.start_line.nil?
      pages_str << ".#{s.start_line}"
    end
    if !s.end_page.nil? or !s.end_line.nil?
      pages_str << '-'
      if !s.end_page.nil?
        pages_str << s.end_page.to_s
      end
      if !s.end_line.nil?
        pages_str << ".#{s.end_line}."
      end
    end
    str << ", #{pages_str}" if !pages_str.blank?
    return str
  end
  
  def custom_secondary_tabs_list
    # The :index values are necessary for this hash's elements to be sorted properly
    {
      :topics => {:index => 1, :title => ts('topical_map.abbreviation'), :url => "#{ActionController::Base.relative_url_root.to_s}/"}
    }
  end
  
  def custom_secondary_tabs(current_tab_id=:topics)

    @tab_options ||= {}
    
    tabs = custom_secondary_tabs_list
    
    current_tab_id = :topics unless [:home, :topics].include? current_tab_id
    
    # If the current tab is :topics, save the current path in session, so that the :topics tab
    # can continue to link to this page from other tabs
    session[:topics_tab_path] = request.fullpath if current_tab_id == :topics
    
    # Set the :topics tab's URL to the saved path, or remove the tab if this path isn't present
    if !session[:topics_tab_path].blank?
      tabs[:topics][:url] = session[:topics_tab_path]
    elsif current_tab_id != :topics
      tabs.delete(:topics)
    end
    
    tabs = tabs.sort{|a,b| a[1][:index] <=> b[1][:index]}.collect{|tab_id, tab| 
      [tab_id, tab[:title], tab[:url]]
    }
    
    tabs
  end
end