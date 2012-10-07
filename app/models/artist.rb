class Artist < ActiveRecord::Base
  attr_accessible :activity, :database_activity, :name, :obtained, :reference, :note
  
  has_and_belongs_to_many :albumbycomposers, :class_name => "Album", :join_table => "albums_composers"
  has_and_belongs_to_many :albumbyarrangers, :class_name => "Album", :join_table => "albums_arrangers"
  has_and_belongs_to_many :albumbyperformers, :class_name => "Album", :join_table => "albums_performers"
  
  has_many :aliases, :foreign_key => "parent_id", :dependent => :destroy
  has_many :alias, :through => :aliases, :source => :parent, :dependent => :destroy
  has_many :inverse_aliases, :class_name => "Alias", :foreign_key => "alias_id" 
  has_many :inverse_alias, :through => :inverse_aliases, :source => :artist
  
  has_many :units, :foreign_key => "unit_id", :dependent => :destroy
  has_many :members, :through => :units, :source => :unit, :dependent => :destroy
  has_many :inverse_units, :class_name => "Unit", :foreign_key => "member_id"
  has_many :inverse_members, :through => :inverse_units, :source => :member
  
  validates:name, :presence => true
end
