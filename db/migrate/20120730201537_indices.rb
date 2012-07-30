class Indices < ActiveRecord::Migration
  def up
    add_index :albums, :id
    add_index :albums, :name
    add_index :albums, :releasedate
    add_index :albums, :created_at
    add_index :albums, :updated_at
    add_index :artists, :id
    add_index :artists, :name
    add_index :artists, :database_activity
    add_index :sources, :id
    add_index :sources, :name
    add_index :sources, :database_activity
    add_index :publishers, :id
    add_index :publishers, :name
  end

  def down
  end
end
