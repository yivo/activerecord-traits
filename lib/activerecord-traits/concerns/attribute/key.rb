module Traits
  class Attribute
    module Key
      extend ActiveSupport::Concern

      def primary_key?
        column_definition.try(:primary) ||
          model_class.primary_key == column_definition.name ||
          type == :primary_key
      end

      # TODO Use essay features
      def foreign_key?
        attr_name       = name
        attr_translates = translates?

        model.associations.any? do |assoc|
          if assoc.belongs_to?
            if attr_translates
              assoc.translation_from_key_name == attr_name
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