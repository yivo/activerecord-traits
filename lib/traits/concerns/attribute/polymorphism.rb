module Traits
  class Attribute
    module Polymorphism
      extend ActiveSupport::Concern

      def polymorphic_key?
        model.associations
          .first_where(
            polymorphic?:  true,
            from_key_name: name
          ).present?
      end

      def polymorphic_type?
        model.associations
          .first_where(
            polymorphic?:                        true,
            attribute_name_for_polymorphic_type: name
          ).present?
      end

      def to_hash
        super.merge!(
          polymorphic_key:  polymorphic_key?,
          polymorphic_type: polymorphic_type?
        )
      end
    end
  end
end