class Arranger < ActiveRecord::Migration
  def change
    create_table :albums_arrangers, :id => false do |t|
      t.integer :album_id
      t.integer :artist_id
    end
  end
end
