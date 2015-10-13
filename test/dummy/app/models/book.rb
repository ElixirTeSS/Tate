class Book < ActiveRecord::Base
  acts_as_annotatable :name_field => :name
end
