class Composer < ActiveRecord::Migration
  def change
    create_table :albums_composers, :id => false do |t|
      t.integer :album_id
      t.integer :artist_id
    end
  end
end
