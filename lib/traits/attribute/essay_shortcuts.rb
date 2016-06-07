# frozen_string_literal: true
module Traits
  class Attribute
    module EssayShortcuts
      def features
        model_class.attribute_features[name]
      end
    end
  end
end
