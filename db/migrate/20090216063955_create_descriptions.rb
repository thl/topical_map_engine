class CreateDescriptions < ActiveRecord::Migration
  def self.up
    create_table :descriptions, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.references :category, :null => false
      t.text :content, :null => false
      t.references :language, :null => false
      t.boolean :is_main, :null => false, :default => false
      t.references :creator, :null => false  # Creator is a User

      t.timestamps
    end
    language = ComplexScripts::Language.find_by_code('eng')
    Category.find(:all, :conditions => 'description IS NOT NULL').each {|c| c.descriptions.create(:content => c.description, :creator => c.creator, :language => language, :is_main => true) if !c.description.blank?}
    remove_column :categories, :description
     
  end

  def self.down
    add_column :categories, :description, :text
    Category.reset_column_information
    Category.find(:all).each do |c| 
      if !c.descriptions.empty?
        content = c.descriptions.first.content
        c.description = description if !content.blank?
      end
    end
    drop_table :descriptions
  end
end
