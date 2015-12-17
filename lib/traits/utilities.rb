module Traits
  class UnidentifiedModelReference < StandardError
  end

  module Utilities
    def retrieve_model_class(obj)
      if active_record_descendant?(obj)
        obj

      elsif active_record_instance?(obj)
        obj.class

      else
        case obj
          when Symbol then obj.to_s.camelize.constantize
          when String then obj.camelize.constantize
          when Model  then obj.model_class
          else raise UnidentifiedModelReference, obj
        end
      end
    end

    def active_record_descendant?(obj)
      obj.kind_of?(Class) && obj < ActiveRecord::Base
    end

    def active_record_instance?(obj)
      obj.kind_of?(ActiveRecord::Base)
    end

    def valid_active_record_identifier?(id)
      id.kind_of?(String) || id.kind_of?(Numeric)
    end
  end

  extend Utilities
end