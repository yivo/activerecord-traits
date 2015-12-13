module Traits
  class Model
    module Naming
      extend ActiveSupport::Concern

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
        namecase == :underscore ? name.gsub('/', '_') : class_name.gsub('::', '')
      end
    end
  end
end