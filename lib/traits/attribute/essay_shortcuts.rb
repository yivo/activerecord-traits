# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Attribute
    module EssayShortcuts
      def features
        active_record.attribute_features[name]
      end
    end
  end
end
