module Traits
  class Association < Base
  end
end

require 'activerecord-traits/concerns/association/intermediate'
require 'activerecord-traits/concerns/association/join'
require 'activerecord-traits/concerns/association/macro'
require 'activerecord-traits/concerns/association/members'
require 'activerecord-traits/concerns/association/naming'
require 'activerecord-traits/concerns/association/polymorphism'
require 'activerecord-traits/concerns/association/read_only'
require 'activerecord-traits/concerns/association/through'

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