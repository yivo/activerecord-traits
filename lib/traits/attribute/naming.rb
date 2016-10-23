# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Attribute
    module Naming
      def name
        @name ||= column_definition.name.to_sym
      end

      def quoted_name
        @quoted_name ||= active_record.connection.quote_column_name(name)
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
