module Traits
  class Model < Base
  end
end

require 'traits/concerns/model/naming'
require 'traits/concerns/model/polymorphism'
require 'traits/concerns/model/sti'
require 'traits/concerns/model/querying'

module Traits
  class Model
    include Naming
    include STI
    include Polymorphism
    include Querying

    attr_reader :model_class

    alias active_record model_class
    alias klass         model_class

    def initialize(model_class)
      @model_class = model_class
    end

    def attributes
      @attributes ||= inspect_attributes
    end

    def associations
      @associations ||= inspect_associations
    end

    def to_s
      class_name
    end

    def to_hash
      super.merge!(
        attributes:   attributes.to_hash,
        associations: associations.to_hash
      )
    end

  protected

    # TODO Translated attributes
    # TODO Store, Storage, Virtual attributes
    def inspect_attributes
      columns = model_class.columns_hash.values

      list = columns.map do |column|
        Traits::Attribute.new(model_class, column)
      end

      Traits::List.new(list)
    end

    def inspect_associations
      list = model_class.reflections.map do |pair|
        Traits::Association.new(model_class, pair.last)
      end
      Traits::List.new(list)
    end
  end
end