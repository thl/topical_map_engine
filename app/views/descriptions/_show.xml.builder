xml.description(:id => description.id, :is_main => description.is_main, :title => description.title, :language => description.language.label) do
  xml.content(description.content)
  xml.authors do
    description.authors.each { |person| xml << render(:partial => 'people/show.xml.builder', :locals => { :person => person }) }
  end
end