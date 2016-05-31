module Traits
  class Association
    module Naming
      delegate :name, to: :reflection

      def plural_name
        @plural_name ||= reflection.plural_name.to_sym
      end

      def to_hash
        super.merge!(name: name, plural_name: plural_name)
      end
    end
  end
end
