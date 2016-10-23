# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model
    module Polymorphism
      def polymorphic_type
        @polymorphic_type ||= active_record.base_class.name.to_sym
      end

      def to_hash
        super.merge!(polymorphic_type: polymorphic_type)
      end
    end
  end
end
