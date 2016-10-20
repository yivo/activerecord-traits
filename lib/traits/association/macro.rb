# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Association
    module Macro
      delegate :macro, to: :reflection

      def short_macro
        habtm? ? :habtm : macro
      end

      def has_and_belongs_to_many?
        macro == :has_and_belongs_to_many
      end

      alias habtm? has_and_belongs_to_many?

      def has_many?
        macro == :has_many
      end

      def has_one?
        macro == :has_one
      end

      def belongs_to?
        macro == :belongs_to
      end

      def to_many?
        has_and_belongs_to_many? || has_many?
      end

      alias collection? to_many?

      def to_one?
        belongs_to? || has_one?
      end

      def to_hash
        super.merge!(macro: macro, collection: collection?)
      end
    end
  end
end
