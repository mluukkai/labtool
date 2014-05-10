class Scoretype < ActiveRecord::Base
  attr_accessible :name, :varname, :initial, :min, :max
end
