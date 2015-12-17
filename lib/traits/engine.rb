module Traits
  class Engine < Rails::Engine
    isolate_namespace Traits

    config.before_initialize do |app|
      unless app.config.cache_classes
        ActionDispatch::Reloader.to_prepare do
          Traits.invalidate_loaded_active_record_descendants!
        end
      end
    end
  end
end