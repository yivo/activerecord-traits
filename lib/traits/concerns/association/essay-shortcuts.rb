module Traits
  class Association
    module EssayShortcuts
      extend ActiveSupport::Concern

      def roles
        model_class.association_roles[name]
      end
    end
  end
end