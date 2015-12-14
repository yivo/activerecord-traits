module Traits
  class Association
    module Members
      extend ActiveSupport::Concern

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

      def to_hash
        super.merge!(from: from.name, to: to.try(:name))
      end
    end
  end
end