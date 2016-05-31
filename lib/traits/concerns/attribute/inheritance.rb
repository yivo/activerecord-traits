module Traits
  class Attribute
    module Inheritance
      def inheritance_type?
        (model.inheritance_base? || model.inheritance_derived?) and name == model.inheritance_attribute.name
      end
      alias sti_type? inheritance_type?

      def to_hash
        super.merge!(is_sti_type: sti_type?)
      end
    end
  end
end
