module Traits
  class Model
    module Querying
      extend ActiveSupport::Concern

      def primary_key_name
        model_class.primary_key.to_sym
      end

      def arel
        model_class.arel_table
      end

      def connection
        model_class.connection
      end

      def table_name
        model_class.table_name
      end

      def quoted_table_name
        connection.quote_table_name(model_class.table_name)
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