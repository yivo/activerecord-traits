# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Association
    module Members
      def from
        @from_active_record.traits
      end

      # Returns the actual association establisher class
      def from_active_record
        @from_active_record
      end

      # Returns the actual associated class
      def to
        reflection.klass.traits unless polymorphic?
      end

      def to_active_record
        reflection.klass unless polymorphic?
      end

      def self_to_self?
        from_active_record == to_active_record
      end

      def to_hash
        super.merge!(
          from:         from.name,
          to:           to.try(:name),
          self_to_self: self_to_self?
        )
      end
    end
  end
end
