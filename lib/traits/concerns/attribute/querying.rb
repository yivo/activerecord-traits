module Traits
  class Attribute
    module Querying
      extend ActiveSupport::Concern

      # TODO Use essay for feature tests
      def arel
        table = translates? ? model.translation_model_class.arel_table : model.arel
        table[name]
      end
    end
  end
end