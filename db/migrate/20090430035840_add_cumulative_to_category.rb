class AddCumulativeToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :cumulative, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :categories, :cumulative
  end
end
