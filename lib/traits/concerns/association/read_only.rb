module Traits
  class Association
    module ReadOnly
      extend ActiveSupport::Concern

      def mutable?
        !through? || source_association.macro == :belongs_to
      end

      def readonly?
        not mutable?
      end

      def to_hash
        super.merge!(mutable: mutable?)
      end
    end
  end
end