# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model
    module I18n
      def i18n_path
        @i18n_path ||= "activerecord.models.#{name(:underscore)}"
      end
    end
  end
end
