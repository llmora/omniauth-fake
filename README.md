# Omniauth Fake

**! ! !**

**Under development, this is what it WILL work like!**

**! ! !**

An [OmniAuth](https://github.com/intridea/omniauth)-Strategy for development and/or testing.

The idea behind this strategy is that you define one or more identities in a local dotfile (eg. `~/.omniauth-fake` or `/path/to/app/.omniauth-fake`). During the OmniAuth authentication process, you can select one of your identities to use.

You can define as many or as few attributes as you like (as long as you define the ones required by OmniAuth, see the [OmniAuth Auth Hash Schema][auth-schema]). All defined attributes will then be passed to OmniAuth.

## Before starting

It should be clear from this documentation, but for clarity: Please note that this gem was developed **only** for testing! Don't blame anyone else if you enabled this on a production app.

## Installation and Usage

Add this line to your application's Gemfile:

    gem 'omniauth-fake'

Use the strategy as a Middleware in your application:

```ruby
use OmniAuth::Strategies::Fake,
  dotfiles: ["~/.omniauth-fake"]
```

For Rails I suggest something along the following lines:

```ruby
# Gemfile
gem 'omniauth-fake', group: :development

# config/initializers/omniauth.rb
unless Rails.env.production?
  Rails.application.config.middleware.use OmniAuth::Strategies::Fake,
    dotfiles: [File.join(Rails.root, "config", "omniauth-fake.yml")]
end
```

The available options are:

* **`:dotfiles`** - an Array of possible dotfile locations. (Strings are okay too) - _Default value:_ `File.join(ENV['HOME'], '.omniauth-fake')`


### Defining Identities

Create a dotfiles containing 1-n identities:

```yaml
user1:
  name: John Doe
  email: user1@example.com
  credentials:
    token: my_app_token
    secret: super-secret-token
  raw_info:
    sAMAccountName: user1
    attribute_x: Value
user2:
  name: Jane Doe
```

See the [official OmniAuth Auth Hash Schema documentation][auth-schema] for info on the individual fields. (Quick Tip: `uid` and `name` fields are required, thus in our YAML-File, everything except `name` is optional)

The resulting `env['omniauth.auth']`-Hash for `user1`:

```ruby
{
  :provider => "fake",
  :uid => "user1",
  :info => {
    :name => "John Doe",
    :email => "user1@example.com"
  },
  :credentials => {
    :token => "my_app_token",
    :secret => "super-secret-token"
  },
  :extra => {
    :raw_info => {
      :uid => "user1",
      :name => "John Doe",
      :email => "user1@example.com",
      :credentials => {
        :token => "my_app_token",
        :secret => "super-secret-token"
      },
      :sAMAccountName => "user1",
      :attribute_x => "Value"
    }
  }
}
```
And for `user2`:

```ruby
{
  :provider => "fake",
  :uid => "user2",
  :info => {
    :name => "Jane Doe"
  },
  :extra => {
    :raw_info => {
      :uid => "user2",
      :name => "Jane Doe"
    }
  }
}
```

## Contributing

1. Fork it ( https://github.com/mhutter/omniauth-fake/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[auth-schema]: https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
