# encoding: utf-8
# frozen_string_literal: true

module Traits
  module DescendantsListing
    def active_record_descendants_loaded?
      !!@active_record_descendants_loaded
    end

    def load_active_record_descendants!
      @active_record_descendants_loaded ||= begin
        # Railties are not necessary here
        # Source: http://stackoverflow.com/questions/6497834/differences-between-railties-and-engines-in-ruby-on-rails-3
        Rails::Engine.subclasses.map(&:instance).each { |i| i.eager_load! }
        Rails.application.eager_load!
        true
      end
    end

    def invalidate_loaded_active_record_descendants!
      @active_record_descendants_loaded = false
    end

    def active_record_descendants(filter = true)
      load_active_record_descendants!
      ary = ActiveRecord::Base.descendants
      ary.reject! { |ar| filter_active_record_descendant(ar) } if filter
      ary
    end

    def filter_active_record_descendant(active_record)
      active_record_filters.any? do |filter|
        case filter
          when Regexp then active_record.name =~ filter
          when String then active_record.name == filter
          when Class  then active_record == filter
          else false
        end
      end
    end
  end

  extend DescendantsListing

  mattr_accessor :active_record_filters

  self.active_record_filters = [
    'Globalize::ActiveRecord::Translation',
    'ActiveRecord::SchemaMigration',
    /\AHABTM/,
    /::Translation\Z/
  ]
end
