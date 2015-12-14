module Traits
  class Attribute < Base
  end
end

require 'activerecord-traits/concerns/attribute/key'
require 'activerecord-traits/concerns/attribute/naming'
require 'activerecord-traits/concerns/attribute/polymorphism'
require 'activerecord-traits/concerns/attribute/querying'
require 'activerecord-traits/concerns/attribute/sti'
require 'activerecord-traits/concerns/attribute/type'

module Traits
  class Attribute
    include Key
    include Naming
    include Type
    include Polymorphism
    include Querying
    include STI

    attr_reader :model_class, :column_definition

    def initialize(model_class, column_definition)
      @model_class       = model_class
      @column_definition = column_definition
    end

    def model
      model_class.traits
    end

    # TODO Remove this
    def regular?
      !(key? || sti_type? || polymorphic_type? || active_record_timestamp? || has_uploader?)
    end

    def validators
      model_class.validators_on(name)
    end

    def to_s
      "#{model}##{name}"
    end
  end
end