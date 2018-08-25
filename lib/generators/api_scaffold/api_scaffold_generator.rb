
require 'generators/api_scaffold/generator_helpers'

module ApiScaffold
  module Generators
    class ApiScaffoldGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include ApiScaffold::Generators::GeneratorHelpers
      namespace "api_scaffold"
      argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
      attr_accessor :attributes
      class_option :orm
      class_option :api_version, type: :string, default: 1, desc: "api version"
      source_root File.expand_path('../templates', __FILE__)

      def initialize(args, *options) #:nodoc:
        @generator_args = args.first
        raise "Nested scaffolds are not yet supported." if @generator_args.split("/").size > 1
        super
      end

      hook_for :orm, in: :rails, required: true, as: :model do |model_generator|
        invoke model_generator
      end

      def create_controller_files
        if gem_available?('fast_jsonapi') || gem_available?('active_model_serializers')
          template "controllers/serializer_controller.rb", File.join("app/controllers/api/", prefix, "#{controller_file_name}_controller.rb")
        else
          template "controllers/controller.rb", File.join("app/controllers/api", prefix, "#{controller_file_name}_controller.rb")
        end
      end

      def create_controller_test_files
        if test_framework == :rspec
          template "tests/rspec/controller_spec.rb", File.join("spec/controllers/api", prefix, "#{controller_file_name}_controller_spec.rb")
        else
          template "tests/test_unit/controller_spec.rb", File.join("test/controllers/api", prefix, "#{controller_file_name}_controller_test.rb")
        end
      end

      def add_routes
        # Include tabs and line break for proper formatting
        routes_string = "      resources :#{controller_file_name}, except: [:new, :edit]\n"
        # Inject into file following the api scope and v1 namespace
        inject_into_file 'config/routes.rb', after: "  namespace :api, defaults: { format: :json } do\n    namespace :#{prefix} do\n" do
          routes_string
        end
      end

      def create_serializer_files
        if gem_available?('fast_jsonapi') || gem_available?('active_model_serializers')
          invoke "serializer"
          template "serializers/error_serializer.rb", File.join("app/serializers", "error_serializer.rb") unless error_serializer_created?
        end
      end

    end
  end
end
