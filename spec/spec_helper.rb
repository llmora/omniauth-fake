require "rspec"
require "rack/test"
require "omniauth"
require "omniauth-fake"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
end
