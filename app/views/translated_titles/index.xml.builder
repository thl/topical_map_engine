xml.instruct!
xml.translated_titles do
  @translated_titles.each { |translated_title| xml << render(:partial => 'show', :locals => { :translated_title => translated_title }) }    
end