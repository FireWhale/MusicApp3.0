class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.date :releasedate
      t.string :catalognumber
      t.string :genre
      t.string :classification
      t.boolean :obtained
      t.string :reference
      t.string :albumart
      t.text :note
      t.integer :publisher_id

      t.timestamps
    end
  end
end
