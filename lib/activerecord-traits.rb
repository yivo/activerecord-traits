require 'active_support/all'
require 'active_record'

require 'traits/engine'
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

  def self.to_hash
    each_with_object({}) do |traits, memo|
      memo[traits.name] = traits.to_hash
    end
  end
end