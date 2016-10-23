# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model
    module Inheritance
      def uses_inheritance?
        inheritance_base? || inheritance_derived?
      end

      def inheritance_base?
        active_record.descends_from_active_record? &&
          !active_record.abstract_class? &&
            active_record.subclasses.any? { |subclass| subclass.superclass == active_record }
      end

      def inheritance_derived?
        !active_record.descends_from_active_record?
      end

      def inheritance_attribute
        attributes[active_record.inheritance_column]
      end

      def inheritance_attribute_name
        inheritance_attribute.name if uses_inheritance?
      end

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
        active_record = self.active_record
        chain        = [active_record]
        until active_record.superclass == ActiveRecord::Base do
          active_record = active_record.superclass
          chain.unshift(active_record)
        end
        chain
      end

      def inheritance_base
        inheritance_chain[0]
      end

      def to_hash
        super.merge!(
          is_inheritance_base:        inheritance_base?,
          is_inheritance_derived:     inheritance_derived?,
          inheritance_attribute_name: inheritance_attribute.try(:name),
          inheritance_chain:          inheritance_chain.map { |active_record| active_record.traits.name }
        )
      end
    end
  end
end
