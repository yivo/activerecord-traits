# encoding: utf-8
# frozen_string_literal: true

module Traits
  module Utilities
    def retrieve_active_record(obj)
      if active_record_descendant?(obj)
        obj

      elsif active_record_instance?(obj)
        obj.class

      elsif active_record_collection?(obj)
        obj.model

      else
        case obj
          when String, Symbol
            s = (obj.kind_of?(Symbol) ? obj.to_s : obj).underscore
            s.camelize.safe_constantize || s.tr('_', '/').camelize.safe_constantize

          when Traits::Model, Traits::Attribute
            obj.active_record

          when Traits::Association
            obj.from_active_record
        end
      end
    end

    def retrieve_active_record!(obj)
      retrieve_active_record(obj) || begin
        raise ActiveRecordRetrieveError, "#{obj.inspect} is not a valid ActiveRecord reference"
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
  end

  extend Utilities

  # TODO Better name
  class ActiveRecordRetrieveError < StandardError
  end
end
