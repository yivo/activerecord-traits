module Traits
  class Attribute
    module Naming
      extend ActiveSupport::Concern

      def name
        column.name.to_sym
      end

      def quoted_name
        model.klass.connection.quote_column_name(name)
      end

      def to_hash
        super.merge!(
          name:        name,
          quoted_name: quoted_name
        )
      end
    end
  end
end