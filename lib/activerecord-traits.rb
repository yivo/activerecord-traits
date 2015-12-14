require 'active_support/all'
require 'active_record'

require 'activerecord-traits/base'
require 'activerecord-traits/attribute'
require 'activerecord-traits/association'
require 'activerecord-traits/model'
require 'activerecord-traits/list'

class ActiveRecord::Base
  def self.traits
    @traits ||= Traits::Model.new(self)
  end
end

module Traits
  def active_record_descendants
    raise NotImplementedError, '
      Please implement the way of requiring all ActiveRecord models.
      In common cases `Rails.application.eager_load!` will do the trick.
    '
  end
end