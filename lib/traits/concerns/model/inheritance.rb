module Traits
  class Model
    module Inheritance
      def uses_inheritance?
        inheritance_base? || inheritance_derived?
      end
      alias uses_sti? uses_inheritance?

      def inheritance_base?
        model_class.descends_from_active_record? && model_class.subclasses.any? do |subclass|
          subclass.superclass == model_class
        end
      end
      alias sti_base? inheritance_base?

      def inheritance_derived?
        !model_class.descends_from_active_record?
      end
      alias sti_derived? inheritance_derived?

      def inheritance_attribute
        attributes[model_class.inheritance_column]
      end
      alias sti_attribute inheritance_attribute

      def inheritance_attribute_name
        inheritance_attribute.name if uses_inheritance?
      end
      alias sti_attribute_name inheritance_attribute_name

      # class File < ActiveRecord::Base
      # end
      #
      # class Photo < File
      # end
      #
      # class Video < File
      # end
      #
      # class Portrait < Photo
      # end
      #
      # File.traits.inheritance_chain     => [File]
      # Photo.traits.inheritance_chain    => [File, Photo]
      # Video.traits.inheritance_chain    => [File, Video]
      # Portrait.traits.inheritance_chain => [File, Photo, Portrait]
      def inheritance_chain
        Traits.load_active_record_descendants!
        model_class = self.model_class
        chain       = [model_class]
        until model_class.superclass == ActiveRecord::Base do
          model_class = model_class.superclass
          chain.unshift(model_class)
        end
        chain
      end
      alias sti_chain inheritance_chain

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
