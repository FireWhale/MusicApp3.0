class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.integer :parent_id
      t.integer :alias_id

      t.timestamps
    end
  end
end
