class Publisher < ActiveRecord::Base
  attr_accessible :name, :reference
  
  has_many :albums
  
  validates :name, :presence => true, :uniqueness => true
end
