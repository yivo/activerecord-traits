# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Association
    module Through
      def through?
        reflection.through_reflection.present?
      end

      def through
        if through?
          reflection.through_reflection.klass.traits
        end
      end

      def through_class
        if through?
          through.active_record
        end
      end

      def through_association
        if through?
          from.associations[reflection.through_reflection.name]
        end
      end

      def source_association
        if through?
          through.associations[reflection.source_reflection.name]
        end
      end

      def source_association_name
        source_association.try(:name)
      end

      def through_association_name
        if through?
          through_association.name
        end
      end

      def through_table_name
        if through?
          through_association.to_table_name
        end
      end

      def through_to_key_name
        if through?
          through_association.to_key_name
        end
      end

      def through_from_key_name
        if through?
          source_association.from_key_name
        end
      end

      def to_hash
        super.merge!(
          through:               through.try(:name),
          through_association:   through_association_name,
          source_association:    source_association_name,
          through_table_name:    through_table_name,
          through_to_key_name:   through_to_key_name,
          through_from_key_name: through_from_key_name
        )
      end
    end
  end
end
