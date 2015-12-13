module Traits
  class Association
    module Naming
      extend ActiveSupport::Concern

      delegate :name, to: :reflection

      def plural_name
        reflection.plural_name.to_sym
      end
    end
  end
end