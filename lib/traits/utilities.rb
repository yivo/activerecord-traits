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
            str = (Symbol === obj ? obj.to_s : obj).underscore.singularize
            kls = complex_constantize(str)
            kls if active_record_descendant?(kls)

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
      Class === obj && obj < ActiveRecord::Base
    end

    def active_record_collection?(obj)
      ActiveRecord::Relation === obj
    end

    def active_record_instance?(obj)
      ActiveRecord::Base === obj
    end

  private
    # 0 : a

    # 0 : a_b
    # 1 : a/b

    # 0 0 : a_b_c
    # 0 1 : a_b/c
    # 1 0 : a/b_c
    # 1 1 : a/b/c

    # 0 0 0 : a_b_c_d
    # 0 0 1 : a_b_c/d
    # 0 1 0 : a_b/c_d
    # 0 1 1 : a_b/c/d
    # 1 0 0 : a/b_c_d
    # 1 0 1 : a/b_c/d
    # 1 1 0 : a/b/c_d
    # 1 1 1 : a/b/c/d
    def complex_constantize(str)
      occurrences = str.count('_')
      tokens      = str.split('_')
      matrix      = (2**occurrences).times.map { |n| ("%0#{occurrences}b" % n).chars }

      matrix.find do |row|
        chars = []
        tokens.each_with_index do |char, i|
          chars << char
          chars << ( row[i] == '0' ? '_' : '/' ) if i < row.size
        end

        active_record = chars.join('').camelize.safe_constantize
        break active_record if active_record
      end
    end
  end

  extend Utilities

  # TODO Better name
  class ActiveRecordRetrieveError < StandardError
  end
end


