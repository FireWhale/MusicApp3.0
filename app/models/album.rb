class Album < ActiveRecord::Base
  attr_accessible :albumart, :catalognumber, :classification, :genre, :name, :note, :obtained, :reference, :releasedate, :publisher_id

  belongs_to :publisher
  has_and_belongs_to_many :sources
  has_and_belongs_to_many :composers, :class_name => "Artist", :join_table => "albums_composers"
  has_and_belongs_to_many :arrangers, :class_name => "Artist", :join_table => "albums_arrangers"
  has_and_belongs_to_many :performers, :class_name => "Artist", :join_table => "albums_performers"
  
  validates :name, :presence => true 
  validates_uniqueness_of :name, :scope => [:reference, :catalognumber]
end
