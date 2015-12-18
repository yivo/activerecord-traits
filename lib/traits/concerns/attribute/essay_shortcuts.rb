module Traits
  class Attribute
    module EssayShortcuts
      extend ActiveSupport::Concern

      def roles
        model_class.attribute_roles[name]
      end
    end
  end
end