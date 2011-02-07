xml.description do
  xml.id(description.id, :type => 'integer')
  xml.content(description.content)
  xml.is_main(description.is_main, :type => 'boolean')
  xml.title(description.title)
  xml << render(:partial => 'languages/show', :locals => { :language => description.language })
  xml.authors do
    description.authors.each { |person| xml << render(:partial => 'people/show', :locals => { :person => person }) }
  end
end