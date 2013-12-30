module Family
  module InstanceMethods
    
    # alias_method :parents, :parent
  
    def children(include_adoptions=false)
      adoptions = adopted_user_ids(:children) if include_adoptions
      self.class.where("#{parent_column} = ? OR id IN (?)", self.id, adoptions)
    end
        
    def siblings(include_adoptions=false, include_self = true)
      adoptions = adopted_user_ids(:siblings) if include_adoptions
      results = self.class.where("#{parent_column} = ? OR id IN (?)", self.parent_id, adoptions)
      results = results.where('id <> ?', self.id) unless include_self
      return results
    end

    def parent(include_adoptions=false)
      adoptions = adopted_user_ids(:parents) if include_adoptions
      self.class.where("id = ? OR id IN (?)", self.parent_id, adoptions)
    end    
    
    def parent_id
      read_attribute(self.parent_column)
    end
    
    def find_related(*args)
      raise TypeError, "arguments can't be empty" if args == [] || args == [:include_adoptions]
      args =  args.map {|a| a.to_s.singularize.to_sym} #TODO: find a better way to convert
      self.class.where(build_query_from_args(args))
    end
        
    def build_query_from_args(args)
      adoptions = adopted_user_ids(args) if args.include?(:include_adoption)
      query = []
      query << "#{parent_column} = #{self.id}" if args.include?(:child)
      query << "#{parent_column} = #{self.parent_id}" if args.include?(:sibling) && !self.parent_id.nil?
      query << "id = #{self.parent_id}" if args.include?(:parent) && !self.parent_id.nil?
      query << "id in (#{adoptions.join(', ')})"  if adoptions && !adoptions.empty?
      joined_query = query.join(' OR ')
      
      return args.include?(:include_self) ?  "#{joined_query} OR id = #{self.id}" : "(#{joined_query}) AND id <> #{self.id}"
    end
    
    def is_the_blank_of(user, include_adoptions=false)
      #TODO: find a better way to do this. case/when?
      
      # order is important here. Adopted relationships have precedence over organic relationships
      adopted_relationship = self.user_adoptions.find_by_adopted_user_id(user.id).relationship_type.to_sym rescue nil if include_adoptions
      return adopted_relationship if adopted_relationship

      return :self if self.id == user.id
      return :child if self.parent_id == user.id
      return :sibling if self.parent_id == user.parent_id
      return :parent if self.id == user.parent_id
    end

      
      
  end
end
