module Family
  class FamilyException < RuntimeError
  end

  class FamilyIntegrityException < FamilyException
  end
end