class AddOralToSource < ActiveRecord::Migration
  def change
    add_column :sources, :oral, :string
  end
end
