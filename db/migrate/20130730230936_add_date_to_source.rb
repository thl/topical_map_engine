class AddDateToSource < ActiveRecord::Migration
  def change
    add_column :sources, :taken_on, :datetime
  end
end
