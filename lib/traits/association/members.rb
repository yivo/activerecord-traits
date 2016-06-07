# frozen_string_literal: true
module Traits
  class Association
    module Members
      def from
        @from_class.traits
      end

      # Returns the actual association establisher class
      def from_class
        @from_class
      end

      # Returns the actual associated class
      def to
        reflection.klass.traits unless polymorphic?
      end

      def to_class
        reflection.klass unless polymorphic?
      end

      def self_to_self?
        from_class == to_class
      end

      def to_hash
        super.merge!(
          from:         from.name,
          to:           to.try(:name),
          self_to_self: self_to_self?
        )
      end
    end
  end
end
