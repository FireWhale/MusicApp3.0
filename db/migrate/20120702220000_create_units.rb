class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :unit_id
      t.integer :member_id

      t.timestamps
    end
  end
end
