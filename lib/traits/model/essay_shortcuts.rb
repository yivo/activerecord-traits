# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model
    module EssayShortcuts
      def features
        model_class.features
      end
    end
  end
end
