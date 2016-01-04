module Traits
  class Attribute
    module STI
      def sti_type?
        (model.sti_base? || model.sti_derived?) and name == model.sti_attribute_name
      end

      def to_hash
        super.merge!(
          sti_type: sti_type?
        )
      end
    end
  end
end