class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
	  t.string :name
	  t.integer :chart_type

      t.timestamps null: false
    end
    add_attachment :charts, :static_image
  end
end
