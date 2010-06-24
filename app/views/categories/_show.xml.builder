xml.category do
  xml.id(category.id, :type => 'id')
  xml.title(category.title, :type => 'string')
  if with_children
    categories = category.published_children
    if only_with_features || only_with_shapes
      xml.feature_count(category.feature_count, :type => 'integer')
      xml.shape_count(category.shape_count, :type => 'integer')
    end
    if only_with_features
      categories =  categories.find_all{|c| c.feature_count>0}
    elsif only_with_shapes
      categories =  categories.find_all{|c| c.shape_count>0}
    end
    xml << render(:partial => 'index.xml.builder', :locals => {:categories => categories, :only_with_features => only_with_features, :only_with_shapes => only_with_shapes}) if !categories.empty?
  end
end