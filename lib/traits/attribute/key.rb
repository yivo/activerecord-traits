# frozen_string_literal: true
module Traits
  class Attribute
    module Key
      def primary_key?
        column_definition.try(:primary) ||
          model_class.primary_key == column_definition.name ||
          type == :primary_key
      end

      def foreign_key?
        attr_name       = name
        attr_translates = model_class.attribute_features[attr_name].translates_with_globalize?

        model.associations.any? do |assoc|
          if assoc.belongs_to?
            if attr_translates && assoc.features.translates_with_globalize?
              assoc.features.globalize_translatable.translation_from_key_name == attr_name
            else
              assoc.from_key_name == attr_name
            end
          end
        end
      end

      def key?
        primary_key? || foreign_key? || polymorphic_key?
      end

      def to_hash
        super.merge!(
          key:         key?,
          primary_key: primary_key?,
          foreign_key: foreign_key?
        )
      end
    end
  end
end
