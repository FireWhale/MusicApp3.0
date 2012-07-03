class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :name
      t.string :reference
      t.string :activity
      t.string :database_activity
      t.boolean :obtained
      t.string :note

      t.timestamps
    end
  end
end
