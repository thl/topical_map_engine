class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title, :null => false
      t.text :description
      t.integer :parent_id
      t.integer :creator_id, :null => false
      t.integer :curator_id
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end