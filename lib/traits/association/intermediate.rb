# encoding: utf-8
# frozen_string_literal: true

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
        Arel::Table.new(reflection.join_table) if intermediate?
      end

      def intermediate_table_name
        return unless intermediate?
        unless @im_table_name
          name           = reflection.join_table
          @im_table_name = name.kind_of?(String) ? name.to_sym : name
        end
        @im_table_name
      end

      def intermediate_to_key
        if intermediate?
          intermediate_table[intermediate_to_key_name]
        end
      end

      def intermediate_to_key_name
        if intermediate?
          @im_to_key_name ||= reflection.foreign_key.to_sym
        end
      end

      def intermediate_from_key
        if intermediate?
          intermediate_table[intermediate_from_key_name]
        end
      end

      def intermediate_from_key_name
        if intermediate?
          @im_from_key_name ||= reflection.association_foreign_key.to_sym
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
