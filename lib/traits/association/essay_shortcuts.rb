# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Association
    module EssayShortcuts
      def features
        from_active_record.association_features[name]
      end
    end
  end
end
