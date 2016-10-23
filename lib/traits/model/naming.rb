# encoding: utf-8
# frozen_string_literal: true

module Traits
  class Model
    module Naming
      # class User
      #   name              => user
      #   name(:underscore) => user
      #
      # class Assets::Photo
      #   name              => assets/photo
      #   name(:underscore) => assets_photo
      #
      def name(namecase = nil)
        # Rails 4.1 doesn't support nested acronyms.
        #
        # Suppose you have:
        #   ActiveSupport::Inflector.inflections(:en) do |inflect|
        #     inflect.acronym 'CI'
        #   end
        #
        # Rails 4.1 underscore behaviour:
        #  'Helpers::ViewHelper'             => 'helpers/view_helper'  - good
        #  'CIHelper'                        => 'ci_helper'            - good
        #  'Helpers::CIHelper'               => 'helpers/ci_helper'    - good
        #
        #  'Helpers::ViewHelper'             => 'helpers/view_helper'  - good
        #  'CIHelper'                        => 'cihelper'             - good
        #  'Helpers::CIHelper'               => 'helpers/ci_helper'    - bad
        #
        # Newer Rails underscore behaviour:
        #  'Helpers::ViewHelper'             => 'helpers/view_helper'  - good
        #  'CIHelper'                        => 'cihelper'             - good
        #  'Helpers::CIHelper'               => 'helpers/cihelper'     - good
        #
        @name ||= active_record.name.split('::').map(&:underscore).join('/')
        if namecase == :underscore
          @underscore_name ||= @name.tr('/', '_')
        else
          @name
        end
      end

      # class User
      #   plural_name              => users
      #   plural_name(:underscore) => users
      #
      # class Assets::Photo
      #   plural_name              => assets/photos
      #   plural_name(:underscore) => assets_photos
      #
      def plural_name(namecase = nil)
        @plural_name ||= name.pluralize
        if namecase == :underscore
          @plural_underscore_name ||= @plural_name.tr('/', '_')
        else
          @plural_name
        end
      end

      # class User
      #   class_name => User
      #
      # class Assets::Photo
      #   class_name => Assets::Photo
      #
      def class_name
        @class_name ||= active_record.name
      end

      # class User
      #   lookup_name              => User
      #   lookup_name(:underscore) => user
      #
      # class Assets::Photo
      #   lookup_name              => AssetsPhoto
      #   lookup_name(:underscore) => assets_photo
      #
      def lookup_name(namecase = nil)
        if namecase == :underscore
          name(namecase)
        else
          @lookup_name ||= class_name.tr('::', '')
        end
      end

      # TODO Deprecate?
      # class User
      #   resource_name => users
      #
      # class Assets::Photo
      #   resource_name => assets/photos
      #
      def resource_name
        @resource_name ||= plural_name
      end

      def to_hash
        super.merge!(
          name:          name,
          plural_name:   plural_name,
          class_name:    class_name,
          lookup_name:   lookup_name,
          resource_name: resource_name
        )
      end
    end
  end
end
