class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :resource_id 
      t.string  :resource_type
      t.integer :mms_id
      t.integer :volume_number
      t.integer :start_page
      t.integer :start_line
      t.integer :end_page
      t.integer :end_line
      t.text    :passage
      t.integer :language_id, :null => false
      t.text    :note
      t.references :creator, :null => false  # Creator is a User 

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
