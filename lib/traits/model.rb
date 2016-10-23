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

    attr_accessor :active_record

    def initialize(active_record)
      @active_record = active_record
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
      if active_record.abstract_class?
        Traits::AttributeList.new([])
      else
        columns = active_record.columns_hash.values

        if features.try(:translates_with_globalize?)
          globalize       = features.globalize
          tr_class        = globalize.model_class_for_translations
          tr_columns_hash = tr_class.columns_hash

          columns += globalize.translated_attribute_names.map do |el|
            tr_columns_hash[el.to_s]
          end
        end

        list = columns.map do |column|
          Traits::Attribute.new(active_record, column)
        end

        Traits::AttributeList.new(list)
      end
    end

    def inspect_associations
      if active_record.abstract_class?
        Traits::List.new([])
      else
        list = active_record.reflections.map do |pair|
          Traits::Association.new(active_record, pair.last)
        end
        Traits::List.new(list)
      end
    end
  end
end
