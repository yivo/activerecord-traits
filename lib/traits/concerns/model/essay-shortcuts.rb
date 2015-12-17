module Traits
  class Model
    module EssayShortcuts
      extend ActiveSupport::Concern

      def features
        model_class.features
      end
    end
  end
end