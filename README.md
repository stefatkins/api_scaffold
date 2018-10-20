# ApiScaffold

A useful Rails API generator for scaffolding that follows the jsonapi.org specification (http://jsonapi.org/). Works with : 
- Fast JSON API/Active Model Serializers
- Rspec/TestUnit
- Fixtures/FactoryBot
- Api Pagination

For example if you have : 
- Fast JSON API/AMS in your gemfile ? the scaffold will create a serializer and generate a controller using the scaffolded serializer.
- Rspec as your configured test framework ? the scaffold will generate rspec working controller tests
- Apipie installed ? the scaffold will generate api documentation
- api-pagination in your gemfile ? the scaffold will paginate the index method of scaffolded controller 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_scaffold'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_scaffold

## Usage

Add this code to config/routes.rb if you want your routes to be inserted under the v1 namespace.

```ruby
namespace :api, defaults: { format: :json } do
  namespace :v1 do
  end
end
```

Execute this line in your terminal from your rails directory:

    $ rails g api_scaffold Book title description:text

If you wish to specify the api version:

    $ rails g api_scaffold Book title description:text --api-version=2

## TODO
- Nested resources 
- GraphQL

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stefatkins/api_scaffold.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
