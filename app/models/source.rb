class Source < ActiveRecord::Base
  attr_accessible :activity, :database_activity, :name, :obtained, :reference
  
  has_and_belongs_to_many :albums
  has_many :franchises, :foreign_key => "franchise_id", :dependent => :destroy
  has_many :instances, :through => :franchises, :source => :franchise, :dependent => :destroy
  
  validates :name, :presence => true, :uniqueness => true
end
