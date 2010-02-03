class CreateAuthorsTranslatedSources < ActiveRecord::Migration
  def self.up
    create_table :authors_translated_sources, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.references :author, :null => false  # author is a Person
      t.references  :translated_source, :null => false  
    end
    add_index :authors_translated_sources, [:author_id, :translated_source_id], :unique => true, :name => 'authors_translated_sources_index'    
  end

  def self.down
    drop_table :authors_translated_sources
  end
end
