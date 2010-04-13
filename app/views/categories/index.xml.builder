xml.instruct!
xml << render(:partial => 'index.xml.builder', :locals => {:categories => categories, :only_with_features => only_with_features})