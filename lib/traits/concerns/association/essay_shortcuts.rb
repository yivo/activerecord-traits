module Traits
  class Association
    module EssayShortcuts
      def features
        from_class.association_roles[name]
      end
    end
  end
end