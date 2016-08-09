class AddRecommendersTable < ActiveRecord::Migration
  def change
    create_table :recommenders do |t|
      t.integer :user_id,    null: false
      t.string :email,    null: false, default: ""

	  t.datetime :originally_sent
      t.string   :response_token

	  t.integer :nag_count
	  t.datetime :last_nagged_at

	  t.string :response
	  t.datetime :responded_at

	  t.timestamps null: false

	end
	add_index :recommenders, :user_id,              unique: false
	add_index :recommenders, :email,                unique: true
	add_index :recommenders, :response_token,		unique: true
  end
end
