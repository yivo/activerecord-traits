module Traits
  class Attribute
    module Querying
      extend ActiveSupport::Concern

      def arel
        table = if roles.translates_with_globalize?
          model_class.features.globalize.translation_model_class.arel_table
        else
          model.arel
        end
        table[name]
      end
    end
  end
end