class AddPlacenameToUser < ActiveRecord::Migration
  def change
    add_column :users, :place_name, :string
    add_column :users, :state_abbreviation, :string
  end
end
