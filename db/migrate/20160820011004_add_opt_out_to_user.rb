class AddOptOutToUser < ActiveRecord::Migration
  def change
	add_column :users, :opt_out_at, :datetime
  end
end
