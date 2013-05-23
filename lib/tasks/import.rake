#require 'config/environment'
namespace :import do
  description = "Import topical map with hierarchies represented as tabs.\n" +
                "Syntax: rake import:categories ROOT_ID=? AUTHOR_ID=? FILENAME=?"
  desc description
  task :categories do
    root_id = ENV['ROOT_ID']
    filename = ENV['FILENAME']
    author_id = ENV['AUTHOR_ID']
    if root_id.blank? || filename.blank? || author_id.blank?
      puts description
    else
      Import.categories(root_id, author_id, filename)
    end
  end
end
