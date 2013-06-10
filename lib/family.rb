require "family/version"
require "family/exceptions"
require "family/class_methods"
require "family/instance_methods"
require "family/adoption_methods"
require "family/has_family"
require "family/models/adopted_user"

module Family
  RELATIONSHIP_TYPES = [:parent, :child, :sibling]
  
  Symbol.class_eval do
    def reciprocal
      case self
      when :parent
        return :child
      when :child
        return :parent
      when :sibling
        return :sibling
      else
        return nil
      end
    end
  end
  

end
