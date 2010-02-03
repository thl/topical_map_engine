xml.categories do
  for category in categories
    xml << render(:partial => 'show.xml.builder', :locals => {:category => category, :with_children => true, :only_with_features => only_with_features})
  end
end
