class AddIndexToUsersByState < ActiveRecord::Migration
  def change
	add_index :users, :state_abbreviation
	add_index :users, :party_affiliation
	add_index :users, :zipcode
  end
end
