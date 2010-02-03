class CreateCategoriesCurators < ActiveRecord::Migration
  def self.up
    create_table :categories_curators, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.references :category, :null => false  
      t.references :curator, :null => false  # curator is a Person
    end
    add_index :categories_curators, [:category_id, :curator_id], :unique => true
    
    remove_column :categories, :curator_id    
  end

  def self.down
    drop_table :categories_curators
    add_colun :categories, :curator_id, :integer
  end
end
