module Traits
  class Association
    module Polymorphism
      # class Picture
      #   belongs_to :imageable, polymorphic: true
      #
      # class Toy
      #   has_one :picture, as: :imageable
      #
      # picture_traits.associations[:imageable].polymorphic?  => true
      # toy_traits.associations[:picture].polymorphic?        => false
      #
      def polymorphic?
        belongs_to? && reflection.options[:polymorphic] == true
      end

      alias accepts_various_classes? polymorphic?

      # Example 1:
      #   class Picture
      #     belongs_to :imageable, polymorphic: true
      #
      #   class Toy
      #     has_one :picture, as: :imageable
      #
      #   picture_traits.associations[:imageable].accepted_classes_through_polymorphism
      #     => [Toy]
      #
      #   toy_traits.associations[:picture].accepted_classes_through_polymorphism
      #     => nil
      #
      # Example 2:
      #   class Picture
      #     belongs_to :imageable, polymorphic: true
      #
      #   class Present
      #     has_one :picture, as: :imageable
      #
      #   class Toy < Present
      #   class VideoGame < Present
      #   class Car < Present
      #
      #   picture_traits.associations[:imageable].accepted_classes_through_polymorphism
      #     => [Car, Present, Toy, VideoGame]
      #
      # Note that items in list are sorted by class name
      #
      def accepted_classes_through_polymorphism
        if polymorphic?
          classes     = []
          attr_name   = attribute_name_for_polymorphic_type
          this_class  = from_class

          Traits.active_record_descendants.each do |model_class|
            # Skip current model and models which are STI derived
            next if model_class <= this_class # Means is or derived from current model

            model_class.traits.associations.each do |assoc|
              if assoc.attribute_name_for_polymorphic_type == attr_name
                classes << assoc.from_class
              end
            end
          end
          classes.uniq.sort! { |l, r| l.to_s <=> r.to_s  }
        end
      end

      # class Picture
      #   belongs_to :imageable, polymorphic: true
      #
      # class Toy
      #   has_one :picture, as: :imageable
      #
      # picture_traits.associations[:imageable].paired_through_polymorphism?  => false
      # toy_traits.associations[:picture].paired_through_polymorphism?        => true
      #
      def paired_through_polymorphism?
        reflection.type.present?
      end

      # class Picture
      #   belongs_to :imageable, polymorphic: true
      #
      # class Toy
      #   has_one :picture, as: :imageable
      #
      # picture_traits.associations[:imageable].polymorphic_type_attribute_name => :imageable_type
      # toy_traits.associations[:picture].polymorphic_type_attribute_name       => :imageable_type
      #
      def attribute_name_for_polymorphic_type
        if polymorphic?
          reflection.foreign_type.to_sym
        elsif paired_through_polymorphism?
          reflection.type.to_sym
        end
      end

      def attribute_for_polymorphic_type
        if polymorphic?
          from.attributes[attribute_for_polymorphic_type]
        elsif paired_through_polymorphism?
          to.attributes[reflection.foreign_type]
        end
      end

      def to_hash
        accepted_classes = accepted_classes_through_polymorphism
        super.merge!(
          polymorphic:                  polymorphic?,
          paired_through_polymorphism:  paired_through_polymorphism?,

          attribute_name_for_polymorphic_type:   attribute_name_for_polymorphic_type,
          accepted_classes_through_polymorphism: accepted_classes.try(:map) { |el| el.traits.name }
        )
      end
    end
  end
end