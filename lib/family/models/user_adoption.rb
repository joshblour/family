class UserAdoption < ActiveRecord::Base
  attr_accessible :adopted_user_id, :relationship, :user_id
    
end
