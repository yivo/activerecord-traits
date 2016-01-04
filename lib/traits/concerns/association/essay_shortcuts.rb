module Traits
  class Association
    module EssayShortcuts
      def features
        from_class.association_features[name]
      end
    end
  end
end