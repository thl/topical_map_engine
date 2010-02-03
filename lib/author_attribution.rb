module AuthorAttribution
  def self.recursive_associate_descriptions(author, category = nil)
    if category.nil?
      categories = Category.roots
    else
      self.associate_descriptions(author, category)
      categories = category.children
    end
    categories.each{ |c| self.recursive_associate_descriptions(author, c) }
  end
  
  def self.associate_descriptions(author, category)
    category.descriptions.each do |description|
      authors = description.authors
      authors << author if authors.empty?
    end
  end
end