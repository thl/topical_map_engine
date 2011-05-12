xml.categories do
  for category in categories
    xml << render(:partial => 'show.xml.builder', :locals => {:category => category, :with_children => true, :with_descriptions => with_descriptions, :with_translated_titles => with_translated_titles, :only_with_features => only_with_features, :only_with_shapes => only_with_shapes})
  end
end
