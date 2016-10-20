# frozen_string_literal: true
module Traits
  class Railtie < Rails::Railtie
    initializer do |app|
      unless app.config.cache_classes
        ActionDispatch::Reloader.to_prepare do
          Traits.invalidate_loaded_active_record_descendants!
        end
      end
    end
  end
end
