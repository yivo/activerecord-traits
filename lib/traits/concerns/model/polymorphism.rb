module Traits
  class Model
    module Polymorphism
      extend ActiveSupport::Concern

      def polymorphic_type
        model_class.base_class.name.to_sym
      end

      def to_hash
        super.merge!(
          polymorphic_type: polymorphic_type
        )
      end
    end
  end
end