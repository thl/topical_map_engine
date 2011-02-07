xml.translated_title do
  xml.id(translated_title.id, :type => 'id')
  xml.title(translated_title.title, :type => 'string')
  xml << render(:partial => 'languages/show', :locals => { :language => translated_title.language })
  xml.authors do
    translated_title.authors.each { |person| xml << render(:partial => 'people/show', :locals => { :person => person }) }
  end
end