# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model
    module Querying
      def primary_key_name
        # Sometimes table doesn't have primary key.
        # This might be many-to-many tables (HABTM).
        @pk_name ||= begin
          pk = active_record.primary_key
          pk.kind_of?(String) ? pk.to_sym : pk
        end
      end

      def primary_key_attribute
        @pk_attr ||= attributes[primary_key_name]
      end

      def arel
        active_record.arel_table
      end

      def connection
        active_record.connection
      end

      def table_name
        @table_name ||= active_record.table_name
      end

      def quoted_table_name
        @quote_table_name ||= connection.quote_table_name(active_record.table_name)
      end

      def to_hash
        super.merge!(
          table_name:        table_name,
          quoted_table_name: quoted_table_name,
          polymorphic_type:  polymorphic_type,
          primary_key_name:  primary_key_name
        )
      end
    end
  end
end
