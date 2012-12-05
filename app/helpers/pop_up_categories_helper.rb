module PopUpCategoriesHelper
  def category_selector(instance_variable_name, field_name)
    selected_category = instance_variable_get("@#{instance_variable_name.to_s}").send(field_name)
    return_str = '<span id="category_name">'
    if selected_category.nil?
      return_str << '<i>None selected</i>'
      category_selector = pop_up_categories_path
    else
      return_str << selected_category.title
      category_selector = pop_up_categories_path(:selected_category_id => selected_category.id)
    end
    return_str << "</span>\n("
    return_str << link_to('select parent', category_selector, :id => 'category_selector', :remote => true)
    return_str << ")\n"
    return_str << hidden_field(instance_variable_name, "#{field_name}_id")
    return_str << "\n<input type=\"hidden\" id=\"current_category_id\" name=\"current_category_id\" value=\"#{selected_category.id if !selected_category.nil?}\" />\n"
    return_str << "\n<input type=\"hidden\" id=\"current_category_title\" name=\"current_category_title\" value=\"#{selected_category.title if !selected_category.nil?}\" />\n"
    return_str << "\n<input type=\"hidden\" id=\"current_category_selector\" name=\"current_category_selector\" value=\"#{category_selector}\" />\n"
    return_str << "\n<input type=\"hidden\" id=\"selected_category_id\" name=\"selected_category_id\" value=\"#{selected_category.id if !selected_category.nil?}\" />\n"
    return_str << "\n<input type=\"hidden\" id=\"selected_category_title\" name=\"selected_category_title\" value=\"#{selected_category.title if !selected_category.nil?}\" />\n"
    return_str << "<div id=\"parent_popup_dialog\" title=\"Select a subject\"></div>"
    return_str << javascript_include_tag('kmaps_engine/jquery-ui-1.8.24.custom.min')
    return_str << javascript_include_tag('kmaps_engine/parent-popup-ui-handler')
    return_str << stylesheet_link_tag('kmaps_engine/jquery-ui-1.8.24.custom')
    return_str.html_safe
  end
end