class CreateTranslatedSources < ActiveRecord::Migration
  def self.up
    create_table :translated_sources, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.text :title, :null => false
      t.integer :language_id, :null => false
      t.integer :source_id, :null => false
      t.integer :creator_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :translated_sources
  end
end
