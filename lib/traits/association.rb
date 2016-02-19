module Traits
  class Association < Base
  end
end

require 'traits/concerns/association/intermediate'
require 'traits/concerns/association/join'
require 'traits/concerns/association/macro'
require 'traits/concerns/association/members'
require 'traits/concerns/association/naming'
require 'traits/concerns/association/polymorphism'
require 'traits/concerns/association/read_only'
require 'traits/concerns/association/through'
require 'traits/concerns/association/essay_shortcuts'

module Traits
  class Association
    include Members
    include Naming
    include Macro
    include Intermediate
    include Through
    include Join
    include ReadOnly
    include Polymorphism
    include EssayShortcuts

    attr_reader :reflection

    def initialize(model_class, reflection)
      @from_class = model_class
      @reflection = reflection
    end

    def to_s
      "#{from.class_name}##{name}"
    end

    def value_from(model)
      model.send(name)
    end

    def validators
      from_class.validators_on(name)
    end
  end
end