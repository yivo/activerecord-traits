# encoding: utf-8
# frozen_string_literal: true

require 'active_support/all'
require 'active_record'

require 'essay'
require 'essay-globalize'   if defined?(Globalize)
require 'essay-carrierwave' if defined?(CarrierWave)

require 'traits/railtie'
require 'traits/utilities'
require 'traits/descendants_listing'
require 'traits/base'
require 'traits/attribute'
require 'traits/association'
require 'traits/model'
require 'traits/list'

class ActiveRecord::Base
  class << self
    def traits
      @traits ||= Traits::Model.new(self)
    end
  end
end

module Traits
  extend Enumerable

  class << self
    def for(obj)
      retrieve_active_record!(obj).traits
    end

    def each
      active_record_descendants.each { |ar| yield(ar.traits) }
    end

    def all
      each_with_object({}) do |traits, memo|
        memo[traits.name] = traits
      end
    end

    def each_attribute(&block)
      each { |traits| traits.attributes.each(&block) }
    end

    def to_hash
      each_with_object({}) do |traits, memo|
        memo[traits.name] = traits.to_hash
      end
    end
  end
end
