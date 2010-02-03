class AddPublishedToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :published, :boolean, :default => false, :null => false
    Category.reset_column_information
    Category.update_all("published = true")   
    #Category.update_all("published = true", "parent_id is null")
    #Category.update_all("published = true", "parent_id is not null")
    
  end

  def self.down
    remove_column :categories, :published
  end
end
