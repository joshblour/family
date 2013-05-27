module Family
  module InstanceMethods
    
    # alias_method :parents, :parent
    
    def children(include_adoptions=false)
      users = self.class.where(self.parent_column => self.id)
      users += self.user_adoptions.where(relationship_type: :child).map(&:adopted_user) if include_adoptions
      return users.flatten
    end
        
    def siblings(include_adoptions=false)
      users = self.class.where(self.parent_column => self.parent_id)
      users += self.user_adoptions.where(relationship_type: :sibling).map(&:adopted_user) if include_adoptions
      return users.flatten
    end

    def parent(include_adoptions=false)
      users = self.class.find(self.parent_id)
      users += self.user_adoptions.where(relationship_type: :parent).map(&:adopted_user) if include_adoptions
      return users.is_a?(Array) ? users.flatten : users
    end    
    
    def parent_id
      read_attribute(self.parent_column)
    end
    
    def find_related(*args)
      raise TypeError, "arguments can't be empty" if args == [] || args == [:include_adoptions]
      args = args.map {|a| a.to_s.singularize.to_sym} #TODO: find a better way to convert
      users = self.class.where(build_query_from_args(args))
      users += self.user_adoptions.where('relationship_type in (?)', args).map(&:adopted_user) if args.include?(:include_adoption) #singluar because of the singlarize method
      return users.flatten
    end
    
    def build_query_from_args(args)
      query = []
      query << "#{parent_column} = #{self.id}" if args.include?(:child)
      query << "#{parent_column} = #{self.parent_id}" if args.include?(:sibling) && !self.parent_id.nil?
      query << "id = #{self.parent_id}" if args.include?(:parent) && !self.parent_id.nil?
      return query.join(' OR ')
    end
    
    def is_the_blank_of(user, include_adoptions=false)
      #TODO: find a better way to do this. especially the last one
      return :self if self.id == user.id
      return :child if self.parent_id == user.id
      return :sibling if self.parent_id == user.parent_id
      return :parent if self.id == user.parent_id
      return self.user_adoptions.find_by_adopted_user_id(user.id).relationship_type.to_sym rescue nil if include_adoptions
    end
    
    def adopt_user(user, relationship)
      #TODO: raise correct types of errors
      raise TypeError, 'relationship is invalid' unless Family::RELATIONSHIP_TYPES.include?(relationship.to_sym)
      raise TypeError, 'adoptions are not enabled' unless $allow_adoptions
      raise TypeError, 'users are already related' unless self.is_the_blank_of(user).nil?
      self.user_adoptions.create(adopted_user_id: user.id, relationship_type: relationship)
    end
      
      
  end
end