# require 'config/environment'
namespace :author_attribution do
  desc_str =  "Use to change default attribution of descriptions of topical map to a specific user.\n" +
              "Valid arguments:\n" +
              "- AUTHOR_ID: required; refers to person id. \n" +
              "- CATEGORY_ID: optional; applies to all topical map if not specified."
  desc desc_str
  task :description do
    author_id = ENV['AUTHOR_ID']
    category_id = ENV['CATEGORY_ID']
    if author_id.blank?
      puts desc_str
    else
      author = AuthenticatedSystem::Person.find(author_id)
      valid = true
      if author.nil?
        valid = false
        puts 'Author ID not found in DB.'
        puts desc_str
      end
      category = nil
      if !category_id.nil?
        category = Category.find(category_id)
        if category.nil?
          valid = false
          puts 'Category ID not found in DB.'
          puts desc_str
        end
      end
      AuthorAttribution.recursive_associate_descriptions(author, category) if valid
    end
  end
end