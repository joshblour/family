module Family
  module AdoptionMethods
    
    def adopted_user_ids(*args)
      args =  args.flatten.map {|a| a.to_s.singularize.to_sym} #TODO: find a better way to convert
      self.user_adoptions.where('relationship_type in (?)', args).pluck(:adopted_user_id)
    end
    
    def adopt_as_a_blank(user, relationship)
      #TODO: raise correct types of errors
      raise TypeError, 'relationship is invalid' unless Family::RELATIONSHIP_TYPES.include?(relationship)
      raise TypeError, 'adoptions are not enabled' unless $allow_adoptions
      self.create_adoption(user, relationship)
    end
    
    def create_adoption(user, relationship)
      #Dont't build relationship if users are already related in the same way
      unless self.is_the_blank_of(user, true) == relationship
        self.user_adoptions.create(adopted_user_id: user.id, relationship_type: relationship)
      else
        logger.info "user #{self.id} is already the #{relationship} of user #{user.id}"
      end
    end
    
    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^adopt_as_a_(.+)$/
        build_adoption_from_method_name($1, *args, &block)
      else
        super
      end
    end

    def build_adoption_from_method_name(relationship_type, *args, &block)
      user = args.first
      adopt_as_a_blank(user, relationship_type.to_sym) if user.class == User
    end
    
  end
end

