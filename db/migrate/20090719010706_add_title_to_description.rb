class AddTitleToDescription < ActiveRecord::Migration
  def self.up
    add_column :descriptions, :title, :string
  end

  def self.down
    remove_column :descriptions, :title
  end
end
