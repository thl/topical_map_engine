class CreateAuthorsDescriptions < ActiveRecord::Migration
  def self.up
    create_table :authors_descriptions, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.references :author, :null => false  # author is a Person
      t.references  :description, :null => false  
    end
    add_index :authors_descriptions, [:author_id, :description_id], :unique => true
    end

  def self.down
    drop_table :authors_descriptions
  end
end
