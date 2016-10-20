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
  def self.traits
    @traits ||= Traits::Model.new(self)
  end
end

module Traits
  extend Enumerable

  def self.for(obj)
    retrieve_model_class(obj).traits
  end

  def self.each(&block)
    active_record_descendants.each { |ar| block.call(ar.traits) }
  end

  def self.all
    each_with_object({}) do |traits, memo|
      memo[traits.name] = traits
    end
  end

  def self.each_attribute(&block)
    each { |traits| traits.attributes.each(&block) }
  end

  def self.to_hash
    each_with_object({}) do |traits, memo|
      memo[traits.name] = traits.to_hash
    end
  end
end
