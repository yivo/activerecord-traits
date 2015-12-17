module Traits
  module DescendantsListing
    def active_record_descendants_loaded?
      !!@ar_descendants
    end

    def load_active_record_descendants!
      Rails::Engine.subclasses.map(&:instance).each { |i| i.eager_load! }
      Rails.application.eager_load!
    end

    def invalidate_loaded_active_record_descendants!
      @ar_descendants = nil
    end

    def active_record_descendants
      @ar_descendants ||= begin
        load_active_record_descendants!
        descendants = ActiveRecord::Base.descendants

        descendants.reject! { |ar| excluded_active_record_descendant?(ar) }
        descendants
      end
    end

    def excluded_active_record_descendant?(model_class)
      rules_for_excluding_active_records.any? do |rule|
        case rule
          when Regexp then model_class.name =~ rule
          when String then model_class.name == rule
          when Class  then model_class == rule
          else false
        end
      end
    end
  end

  extend DescendantsListing

  # TODO Give a better name
  mattr_accessor :rules_for_excluding_active_records

  self.rules_for_excluding_active_records = [
    'Globalize::ActiveRecord::Translation',
    'ActiveRecord::SchemaMigration',
    /\AHABTM/,
    /::Translation\Z/
  ]
end