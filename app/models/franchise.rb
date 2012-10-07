class Franchise < ActiveRecord::Base
  attr_accessible :franchise_id, :instance_id
  
  belongs_to :franchise, :class_name => "Source"
  belongs_to :instance, :class_name => "Source"
end
