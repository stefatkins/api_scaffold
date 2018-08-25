module ApiScaffold
  module Generators
    module GeneratorHelpers

      def prefix
        "v#{options[:api_version]}"
      end

      def prefixed_class_name
        "Api::#{prefix.capitalize}::#{class_name}"
      end

      def prefixed_controller_class_name
        "Api::#{prefix.capitalize}::#{controller_class_name}"
      end

      def prefixed_url(resource)
        ['api', prefix, resource, 'url'].join('_')
      end

      def gem_available?(gem_name)
        Gem::Specification::find_all_by_name(gem_name).any?
      end

      def apipie_installed?
        File.exists? File.join(destination_root, "config/initializers/apipie.rb")
      end

      def error_serializer_created?
        File.exists? File.join(destination_root, "app/serializers/error_serializer.rb")
      end

      def test_framework
        Rails.application.config.generators.options[:rails][:test_framework]
      end

      def fixture_replacement
        Rails.application.config.generators.options[:rails][:fixture_replacement]
      end

      def fixture_name
        if mountable_engine?
          (namespace_dirs + [table_name]).join("_")
        else
          table_name
        end
      end

      def attributes_string
        attributes_hash.map { |k, v| "#{k}: #{v}" }.join(", ")
      end
      
      def attributes_hash
        return {} if attributes_names.empty?

        attributes_names.map do |name|
          if %w(password password_confirmation).include?(name) && attributes.any?(&:password_digest?)
            ["#{name}", "'secret'"]
          else
            ["#{name}", "@#{singular_table_name}.#{name}"]
          end
        end.sort.to_h
      end

      def apipie_param(attribute_name)
        "param :#{attribute_name}, String, 'TODO: #{attribute_name} descrption'"
      end
    end
  end
end
