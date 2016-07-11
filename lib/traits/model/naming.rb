# frozen_string_literal: true
module Traits
  class Model
    module Naming
      # class User
      #   name => user
      #
      # class Assets::Photo
      #   name => assets/photo
      #
      def name
        # Rails 4.1 doesn't support nested acronyms
        #
        # Rails 4.1 behaviour:
        # 'Helpers::ViewHelper'.underscore  => 'helpers/view_helper'  - good
        # 'CIHelper'.underscore             => 'ci_helper'            - good
        # 'Helpers::CIHelper'               => 'helpers/ci_helper'    - good
        #
        # 'Helpers::ViewHelper'             => 'helpers/view_helper'  - good
        # 'CIHelper'                        => 'cihelper'             - good
        # 'Helpers::CIHelper'               => 'helpers/ci_helper'    - bad!
        #
        # Newer Rails behaviour:
        # 'Helpers::ViewHelper'             => 'helpers/view_helper'  - good
        # 'CIHelper'                        => 'cihelper'             - good
        # 'Helpers::CIHelper'               => 'helpers/cihelper'     - good
        #
        @name ||= model_class.name.split('::').map(&:underscore).join('/')
      end

      # class User
      #   plural_name => users
      #
      # class Assets::Photo
      #   plural_name => assets/photos
      #
      def plural_name
        @plural_name ||= name.pluralize
      end

      # class User
      #   resource_name => users
      #
      # class Assets::Photo
      #   resource_name => assets/photos
      #
      def resource_name
        @resource_name ||= plural_name
      end

      # class User
      #   class_name => User
      #
      # class Assets::Photo
      #   class_name => Assets::Photo
      #
      def class_name
        @class_name ||= model_class.name
      end

      # class User
      #   lookup_name => User
      #   lookup_name(:underscore) => user
      #
      # class Assets::Photo
      #   lookup_name => AssetsPhoto
      #   lookup_name(:underscore) => assets_photo
      #
      def lookup_name(namecase = :class)
        namecase == :underscore ?
            @lookup_name_underscore_case ||= name.gsub('/', '_') :
            @lookup_name_class_case      ||= class_name.gsub('::', '')
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