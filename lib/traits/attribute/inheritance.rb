# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Attribute
    module Inheritance
      def inheritance_type?
        (model.inheritance_base? || model.inheritance_derived?) and name == model.inheritance_attribute.name
      end

      def to_hash
        super.merge!(is_inheritance_type: inheritance_type?)
      end
    end
  end
end
