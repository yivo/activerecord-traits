# encoding: utf-8
# frozen_string_literal: true

module Traits
  class UnidentifiedModelReference < StandardError
  end

  module Utilities
    def retrieve_model_class(obj)
      if active_record_descendant?(obj)
        obj

      elsif active_record_instance?(obj)
        obj.class

      elsif active_record_collection?(obj)
        obj.model

      else
        case obj
          when String, Symbol
            s = obj.kind_of?(Symbol) ? obj.to_s : obj
            s.camelize.safe_constantize || s.tr('_', '/').camelize.safe_constantize

          when Traits::Model, Traits::Attribute
            obj.model_class

          when Traits::Association
            obj.from_class

        end || raise(UnidentifiedModelReference, obj)
      end
    end

    def active_record_descendant?(obj)
      obj.kind_of?(Class) && obj < ActiveRecord::Base
    end

    def active_record_collection?(obj)
      obj.kind_of?(ActiveRecord::Relation)
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
