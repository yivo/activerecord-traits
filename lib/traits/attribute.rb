# frozen_string_literal: true
module Traits
  class Attribute < Base
  end
end

require 'traits/attribute/key'
require 'traits/attribute/naming'
require 'traits/attribute/polymorphism'
require 'traits/attribute/querying'
require 'traits/attribute/inheritance'
require 'traits/attribute/type'
require 'traits/attribute/essay_shortcuts'

module Traits
  class Attribute
    include Key
    include Naming
    include Type
    include Polymorphism
    include Querying
    include Inheritance
    include EssayShortcuts

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
      !(key? || sti_type? || polymorphic_type? || active_record_timestamp?)
    end

    def validators
      model_class.validators_on(name)
    end

    def value_from(model_instance)
      model_instance.send(name)
    end

    def to_s
      "#{model}##{name}"
    end

    def association
      model.associations.first_where(from_key_name: name)
    end

    def null?
      column_definition.null
    end
  end
end
