class Artist < ActiveRecord::Base
  attr_accessible :activity, :database_activity, :name, :obtained, :reference, :note
  
  has_and_belongs_to_many :albumComposers, :class_name => "Album", :join_table => "albums_composers"
  has_and_belongs_to_many :albumArrangers, :class_name => "Album", :join_table => "albums_arrangers"
  has_and_belongs_to_many :albumPerformers, :class_name => "Album", :join_table => "albums_performers"
  has_many :aliases, :foreign_key => "parent_id", :dependent => :destroy
  has_many :alias, :through => :aliases, :source => :parent
  has_many :units, :foreign_key => "unit_id", :dependent => :destroy
  has_many :members, :through => :units, :source => :unit
  
  validates:name, :presence => true, :uniqueness => true
end
