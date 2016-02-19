module Traits
  class Model < Base
  end
end

require 'traits/concerns/model/naming'
require 'traits/concerns/model/polymorphism'
require 'traits/concerns/model/sti'
require 'traits/concerns/model/querying'
require 'traits/concerns/model/essay_shortcuts'

module Traits
  class Model
    include Naming
    include STI
    include Polymorphism
    include Querying
    include EssayShortcuts

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

    # TODO Store, Storage, Virtual attributes
    def inspect_attributes
      columns = model_class.columns_hash.values

      if features.translates_with_globalize?
        globalize       = features.globalize
        tr_class        = globalize.model_class_for_translations
        tr_columns_hash = tr_class.columns_hash

        columns += globalize.translated_attribute_names.map do |el|
          tr_columns_hash[el.to_s]
        end
      end

      list = columns.map do |column|
        Traits::Attribute.new(model_class, column)
      end

      Traits::AttributeList.new(list)
    end

    def inspect_associations
      list = model_class.reflections.map do |pair|
        Traits::Association.new(model_class, pair.last)
      end
      Traits::List.new(list)
    end
  end
end