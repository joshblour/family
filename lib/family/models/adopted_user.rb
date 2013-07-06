class UserAdoption < ActiveRecord::Base
  attr_accessible :adopted_user_id, :relationship_type, :user_id, :locked, :reciprocal, :reference_id
  belongs_to :adopted_user, class_name: 'User' #$base_class.to_s.downcase
  belongs_to :user  #$base_class.to_s.downcase.to_sym
  
  validates_uniqueness_of :user_id, scope: [:adopted_user_id], message: 'only one adoption per user pair'
  validates_uniqueness_of :adopted_user_id, scope: [:user_id], message: 'only one adoption per user pair'
  
  validates :user_id, :adopted_user_id, :relationship_type, presence: true

  validate :relationship_doesnt_exist, :on => :create
  before_destroy :validate_not_locked
  
  

  private
  
  def validate_not_locked
    !locked?
  end
  
  def relationship_doesnt_exist
    if user && adopted_user && relationship_type && adopted_user.is_the_blank_of(user, true) == relationship_type.to_sym    
      errors[:relationship_type] << "users are already related in this way"
    end
  end      
end
