class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :city
      t.string :state
      t.integer :start_year
      t.integer :end_year
      t.boolean :graduated, default: false
      t.timestamps
    end
  end
end
