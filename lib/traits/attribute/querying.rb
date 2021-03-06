# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Attribute
    module Querying
      def arel
        table = if features.try(:translates_with_globalize?)
          active_record.features.globalize.translation_model_class.arel_table
        else
          model.arel
        end
        table[name]
      end
    end
  end
end
