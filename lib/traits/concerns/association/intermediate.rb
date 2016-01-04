module Traits
  class Association
    module Intermediate
      # class Person
      #   has_and_belongs_to_many :groups
      #
      # person_traits.associations[:groups].intermediate? => true
      #
      def intermediate?
        has_and_belongs_to_many?
      end

      def intermediate_table
        if intermediate?
          Arel::Table.new(reflection.join_table)
        end
      end

      def intermediate_table_name
        if intermediate?
          reflection.join_table
        end
      end

      def intermediate_to_key
        intermediate_table.try(:[], intermediate_to_key_name)
      end

      def intermediate_to_key_name
        if intermediate?
          reflection.foreign_key.to_sym
        end
      end

      def intermediate_from_key
        intermediate_table.try(:[], intermediate_from_key_name)
      end

      def intermediate_from_key_name
        if intermediate?
          reflection.association_foreign_key.to_sym
        end
      end

      def to_hash
        super.merge!(
          intermediate:               intermediate?,
          intermediate_table_name:    intermediate_table_name,
          intermediate_to_key_name:   intermediate_to_key_name,
          intermediate_from_key_name: intermediate_from_key_name
        )
      end
    end
  end
end