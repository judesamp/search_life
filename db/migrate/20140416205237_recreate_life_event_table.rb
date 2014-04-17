class RecreateLifeEventTable < ActiveRecord::Migration
  def change
    create_table :life_events do |t|
      t.string :name
      t.string :description
      t.string :city
      t.string :state
      t.integer :impact_rating
      t.integer :year
      t.timestamps
    end
  end
end
