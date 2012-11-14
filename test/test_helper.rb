ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
end

# Pandas
require 'fixtures/migrations/create_pandas'
require 'fixtures/models/panda'

# Veterinarians
require 'fixtures/migrations/create_veterinarians'
require 'fixtures/models/veterinarian'

# Zookeepers and ZookeeperReviews
require 'fixtures/migrations/create_zookeepers'
require 'fixtures/models/zookeeper'

# Layouts
ActionController::Base.append_view_path 'test/fixtures/views'
