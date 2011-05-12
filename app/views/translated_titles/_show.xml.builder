xml.translated_title(:id => translated_title.id, :lang => translated_title.language.label) do
  xml.title(translated_title.title)
  xml.authors do
    translated_title.authors.each { |person| xml << render(:partial => 'people/show.xml.builder', :locals => { :person => person }) }
  end
end