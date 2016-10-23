# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model
    module EssayShortcuts
      def features
        active_record.features
      end
    end
  end
end
