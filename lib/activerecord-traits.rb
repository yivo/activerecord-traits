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
  def self.for(obj)
    retrieve_model_class(obj).traits
  end

  def self.to_hash
    active_record_descendants.each_with_object({}) do |ar, memo|
      memo[ar.traits.name] = ar.traits.to_hash
    end
  end
end