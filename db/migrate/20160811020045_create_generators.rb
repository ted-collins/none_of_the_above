class CreateGenerators < ActiveRecord::Migration
  def change
    create_table :generators do |t|

      t.timestamps null: false
    end
  end
end
