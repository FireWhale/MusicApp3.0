class Unit < ActiveRecord::Base
  attr_accessible :member_id, :unit_id
  
  belongs_to :member, :class_name => "Artist"
  belongs_to :unit, :class_name => "Artist"
end
