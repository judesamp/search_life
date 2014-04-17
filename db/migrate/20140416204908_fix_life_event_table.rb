class FixLifeEventTable < ActiveRecord::Migration
  def change
    drop_table :life_events
  end
end
