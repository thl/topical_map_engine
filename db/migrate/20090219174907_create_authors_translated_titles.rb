class CreateAuthorsTranslatedTitles < ActiveRecord::Migration
  def self.up
    create_table :authors_translated_titles, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.references :author, :null => false  # author is a Person
      t.references  :translated_title, :null => false  
    end
    add_index :authors_translated_titles, [:author_id, :translated_title_id], :unique => true, :name => 'authors_translated_titles_index'
  end

  def self.down
    drop_table :authors_translated_titles
  end
end
