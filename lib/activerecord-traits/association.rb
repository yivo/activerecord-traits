module Traits
  class Association
    include Members
    include Naming
    include Macro
    include Intermediate
    include Through
    include Join
    include ReadOnly

    attr_reader :reflection

    def initialize(model_class, reflection)
      @from_class = model_class
      @reflection = reflection
    end

    def to_s
      "#{from.class_name}##{name}"
    end
  end
end