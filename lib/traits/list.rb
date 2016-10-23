# encoding: utf-8
# frozen_string_literal: true

module Traits
  class List
    include Enumerable

    def initialize(list = [])
      @list = list
    end

    def filter(hash)
      select do |item|
        hash.all? { |method, expected| compare(item, method, expected) }
      end
    end

    def first_where(hash)
      find do |item|
        hash.all? { |method, expected| compare(item, method, expected) }
      end
    end

    def [](arg)
      by_name(arg)
    end

    def fetch(name)
      el = by_name(name)
      raise StandardError, "#{name.inspect} not found" unless el
      el
    end

    def each(&block)
      @list.each(&block)
    end

    def by_name(name)
      name = name.to_sym if name.kind_of?(String)
      find { |attr| attr.name == name }
    end

    def to_hash
      each_with_object({}) { |item, memo| memo[item.name] = item.to_hash }
    end

  protected
    def compare(item, method, expected)
      returned = item.send(method)
      case expected
        when Array  then expected.include?(returned)
        when Regexp then returned =~ expected
        else returned == expected
      end
    end
  end

  class AttributeList < List
    def primary_key
      first_where(primary_key?: true)
    end
  end
end
