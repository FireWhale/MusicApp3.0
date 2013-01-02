class ObtainedDataTypeChange < ActiveRecord::Migration
  def up
    change_column :albums, :obtained, :string
  end

  def down
    change_colum :albums, :obtained, :boolean
  end
end
