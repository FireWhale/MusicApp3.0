class CreateFranchises < ActiveRecord::Migration
  def change
    create_table :franchises do |t|
      t.integer :franchise_id
      t.integer :instance_id

      t.timestamps
    end
  end
end
