module Traits
  class Attribute
    module EssayShortcuts
      def features
        model_class.attribute_roles[name]
      end
    end
  end
end