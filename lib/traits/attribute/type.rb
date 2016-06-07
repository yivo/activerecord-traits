# frozen_string_literal: true
module Traits
  class Attribute
    module Type
      def type
        @type ||= column_definition.type.to_sym
      end

      def string?
        type == :string
      end

      def text?
        type == :text
      end

      def binary?
        type == :binary
      end

      def big?
        text? || binary?
      end

      def integer?
        type == :integer
      end

      def float?
        type == :float
      end

      def decimal?
        type == :decimal
      end

      def real?
        float? || decimal?
      end

      def number?
        integer? || float? || decimal?
      end

      def datetime?
        type == :datetime
      end

      def active_record_timestamp?
        datetime? && (name == :created_at || name == :updated_at || name == :deleted_at)
      end

      def to_hash
        super.merge!(
          type: type
        )
      end
    end
  end
end
