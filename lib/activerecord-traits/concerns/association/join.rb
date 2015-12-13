module Traits
  class Association
    module Join
      extend ActiveSupport::Concern

      def from_table
        from.arel
      end

      def from_table_name
        from_table.name.to_sym
      end

      def from_table_alias
        from_table.table_alias.try(:to_sym)
      end

      def from_key
        from_table[from_key_name]
      end

      def from_key_name
        if polymorphic?
          reflection.foreign_key.to_sym

        elsif through?
          through_association.from_key_name

        elsif translates?
          nil

        elsif belongs_to?
          reflection.foreign_key.to_sym

        end || reflection.active_record_primary_key.to_sym
      end

      def to_table
        unless polymorphic?
          table = to.arel.clone
          if self_to_self?
            table.table_alias = "#{plural_name}_#{from.table_name}"
          end
          table
        end
      end

      def to_table_name
        unless polymorphic?
          to_table.name.to_sym
        end
      end

      def to_table_alias
        unless polymorphic?
          to_table.table_alias.try(:to_sym)
        end
      end

      def to_key
        to_table.try(:[], to_key_name)
      end

      def to_key_name
        unless polymorphic?
          if through?
            source_association.to_key_name

          elsif belongs_to? || has_and_belongs_to_many?
            reflection.association_primary_key.to_sym

          else
            reflection.foreign_key.to_sym
          end
        end
      end
    end
  end
end