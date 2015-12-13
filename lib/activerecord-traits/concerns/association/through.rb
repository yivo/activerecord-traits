module Traits
  class Association
    module Through
      extend ActiveSupport::Concern

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
    end
  end
end