class Sourceship < ActiveRecord::Migration
  def change
    create_table :albums_sources, :id => false do |t|
      t.integer :album_id
      t.integer :source_id
    end
  end
end
