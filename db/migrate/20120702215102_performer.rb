class Performer < ActiveRecord::Migration
  def change
    create_table :albums_performers, :id => false do |t|
      t.integer :album_id
      t.integer :artist_id
    end
  end
end
