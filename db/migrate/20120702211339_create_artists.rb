class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :reference
      t.string :activity
      t.string :database_activity
      t.boolean :obtained
      t.text :note

      t.timestamps
    end
  end
end
