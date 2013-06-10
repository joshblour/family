class UserAdoption < ActiveRecord::Base
  attr_accessible :adopted_user_id, :relationship_type, :user_id
  belongs_to :adopted_user, class_name: 'User' #$base_class.to_s.downcase
  belongs_to :user  #$base_class.to_s.downcase.to_sym
  
  validates_uniqueness_of :user_id, scope: [:adopted_user_id]
    
end
