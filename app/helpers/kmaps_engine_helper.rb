# Methods added to this helper will be available to all templates in the application.
module KmapsEngineHelper
  def side_column_links
    str = "<h3 class=\"head\">#{link_to 'Knowledge Maps', '#nogo', {:hreflang => 'Manage hierarchical controlled vocabulary to be used by other applications.'}}</h3>\n<ul>\n"
    str += "<li>#{link_to 'Home', root_path, {:hreflang => 'Lists all categories.'}}</li>\n"
	str += "<li>#{link_to 'Intro', '#wiki=/access/wiki/site/c06fa8cf-c49c-4ebc-007f-482de5382105/knowledge%20maps%20|amp|%20controlled%20vocabulary.html', {:hreflang => 'General Introduction to kmaps.'}}</li>\n"
	str += "<li>#{link_to 'Help', '#wiki=/access/wiki/site/c06fa8cf-c49c-4ebc-007f-482de5382105/knowledge%20maps%20|amp|%20controlled%20vocabulary%20user%20manual.html', {:hreflang => 'User Manual.'}}</li>\n"
	if logged_in?
		str += "<li>#{link_to 'Editing Help', '#wiki=/access/wiki/site/c06fa8cf-c49c-4ebc-007f-482de5382105/knowledge%20maps%20|amp|%20controlled%20vocabulary%20editorial%20manual.html', {:hreflang => 'Editorial Manual.'}}</li>\n"
	end
	authorized_only(hash_for_languages_path) { str += "<li>#{link_to 'Languages', languages_path, {:hreflang => 'Manage languages used for translation of titles and interface.'}}</li>\n" }
    authorized_only(hash_for_people_path) { str += "<li>#{link_to 'People', people_path, {:hreflang => 'Manage people.'}}</li>\n" }
    authorized_only(hash_for_roles_path) { str += "<li>#{link_to 'Roles', roles_path, {:hreflang => 'Manage roles and their permissions.'}}</li>\n" }
    authorized_only(hash_for_permissions_path) { str += "<li>#{link_to 'Permissions', permissions_path, {:hreflang => 'Manage permissions and their descriptions.'}}</li>\n" }
    str += "</ul>"
    return str
  end
    
  def stylesheet_files
    super + ['tmb']
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