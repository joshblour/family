class << ActiveRecord::Base
  def has_family options = {}
    
    # Check options
    raise Family::FamilyException.new("Options for has_family must be in a hash.") unless options.is_a? Hash
    options.each do |key, value|
      unless [:parent_column, :use_adoptions].include? key
        raise Family::FamilyException.new("Unknown option for has_family: #{key.inspect} => #{value.inspect}.")
      end
    end
    
    
    if options[:use_adoptions]
      # if ActiveRecord::Base.connection.table_exists? 'user_adoptions'
        @use_adoptions = true
      # else
      #   raise Family::FamilyException.new("user_adoptions table doesn't exist. Please run rails g family:install then rake db:migrate")
      # end
    end
    
      
      
    # Include instance methods
    include Family::InstanceMethods

    # Include dynamic class methods
    extend Family::ClassMethods
    
    # Create family column accessor and set to option or default
    cattr_accessor :parent_column
    self.parent_column = options[:parent_column] || :parent_id
    
  end
end
    