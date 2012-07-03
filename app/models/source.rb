class Source < ActiveRecord::Base
  attr_accessible :activity, :database_activity, :name, :obtained, :reference
  
  has_and_belongs_to_many :albums
  
  validates :name, :presence => true, :uniqueness => true
end
