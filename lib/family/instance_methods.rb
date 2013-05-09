module Family
  module InstanceMethods
    
    def children
      self.class.where(self.parent_column => self.id)
    end
        
    def siblings
      self.class.where(self.parent_column => self.parent_id)
    end

    def parent
      self.class.find(self.parent_id)
    end    
    
    def parent_id
      read_attribute(self.parent_column)
    end
    
    def find_related(*args)
      raise TypeError, "arguments can't be empty" if args == []
      query = []
      query << "#{parent_column} = #{self.id}" unless (args & [:children, :child]).empty?
      query << "#{parent_column} = #{self.parent_id}" unless (args & [:siblings, :sibling]).empty?
      query << "id = #{self.parent_id}" unless (args & [:parent, :parents]).empty?
      self.class.where(query.join(' OR '))
    end
    
    def is_the_blank_of(user)
      return 'child' if self.parent_id == user.id
      return 'sibling' if self.parent_id == user.parent_id
      return 'parent' if self.id == user.parent_id
    end   
    
    def adopt_parent(user)
    end 

  end
end