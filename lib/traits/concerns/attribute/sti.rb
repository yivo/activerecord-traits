module Traits
  class Attribute
    module STI
      # Deprecated
      def sti_type?
        inheritance_type?
      end

      def inheritance_type?
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