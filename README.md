# ApiScaffold

A useful Rails API generator for scaffolding. Compatible with :
- Fast JSON API/Active Model Serializers
- Rspec/TestUnit
- Fixtures/FactoryBot
- Api Pagination

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stefatkins/api_scaffold.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
