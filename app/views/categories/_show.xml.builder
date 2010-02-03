xml.category do
  xml.id(category.id, :type => 'id')
  xml.parent_id(category.parent_id, :type => 'integer')
  xml.title(category.title, :type => 'string')
  xml.cumulative(category.cumulative, :type => 'boolean')
  xml.creator_id(category.creator_id, :type => 'integer')
  xml.created_at(category.created_at, :type => 'datetime')
  xml.updated_at(category.updated_at, :type => 'datetime')
  if with_children
    categories = category.published_children
    if only_with_features
      xml.feature_count(category.feature_count, :type => 'integer')
      categories =  categories.find_all{|c| c.feature_count>0}
    end
    xml << render(:partial => 'index.xml.builder', :locals => {:categories => categories, :only_with_features => only_with_features})
  end
end