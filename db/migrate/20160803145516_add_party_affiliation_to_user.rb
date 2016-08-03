class AddPartyAffiliationToUser < ActiveRecord::Migration
  def change
	add_column :users, :party_affiliation, :string
  end
end
