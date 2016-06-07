module Traits
  class Association < Base
  end
end

require 'traits/association/intermediate'
require 'traits/association/join'
require 'traits/association/macro'
require 'traits/association/members'
require 'traits/association/naming'
require 'traits/association/polymorphism'
require 'traits/association/read_only'
require 'traits/association/through'
require 'traits/association/essay_shortcuts'

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
