# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model < Base
  end
end

require 'traits/model/naming'
require 'traits/model/polymorphism'
require 'traits/model/inheritance'
require 'traits/model/querying'
require 'traits/model/essay_shortcuts'
require 'traits/model/i18n'

module Traits
  class Model
    include Naming
    include Inheritance
    include Polymorphism
    include Querying
    include EssayShortcuts
    include I18n

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

    def descendants
      Traits.load_active_record_descendants!
      active_record.descendants
    end

  protected

    # TODO Store, Storage, Virtual attributes
    def inspect_attributes
      if model_class.abstract_class?
        Traits::AttributeList.new([])
      else
        columns = model_class.columns_hash.values

        if features.try(:translates_with_globalize?)
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
    end

    def inspect_associations
      if model_class.abstract_class?
        Traits::List.new([])
      else
        list = model_class.reflections.map do |pair|
          Traits::Association.new(model_class, pair.last)
        end
        Traits::List.new(list)
      end
    end
  end
end
