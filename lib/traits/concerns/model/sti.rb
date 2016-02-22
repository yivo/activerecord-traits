module Traits
  class Model
    module STI
      def uses_sti?
        sti_base? || sti_derived?
      end

      def sti_base?
        model_class.descends_from_active_record? && model_class.subclasses.any? do |subclass|
          subclass.superclass == model_class
        end
      end

      def sti_derived?
        !model_class.descends_from_active_record?
      end

      def sti_attribute_name
        model_class.inheritance_column.to_sym
      end

      def sti_chain
        model_class = self.model_class
        chain       = [model_class]
        until model_class.superclass == ActiveRecord::Base do
          model_class = model_class.superclass
          chain.unshift(model_class)
        end
        chain
      end

      alias inheritance_chain sti_chain

      def to_hash
        super.merge!(
          is_sti_base:        sti_base?,
          is_sti_derived:     sti_derived?,
          sti_attribute_name: sti_attribute_name,
          sti_chain:          sti_chain.map { |model_class| model_class.traits.name }
        )
      end
    end
  end
end