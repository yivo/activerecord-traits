module Traits
  class List
    include Enumerable

    def initialize(list = [])
      @list = list
    end

    def filter(hash)
      select do |attr|
        hash.all? do |method, expected|
          returned = attr.send(method)
          if expected.is_a?(Array)
            expected.include?(returned)
          else
            returned == expected
          end
        end
      end
    end

    def first_where(hash)
      find do |attr|
        hash.all? do |method, expected|
          returned = attr.send(method)
          if expected.is_a?(Array)
            expected.include?(returned)
          else
            returned == expected
          end
        end
      end
    end

    def [](arg)
      by_name(arg)
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
  end

  class AttributeList < List
    def primary_key
      first_where(primary_key?: true)
    end
  end
end
