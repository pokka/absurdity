require 'minitest/autorun'
require 'mock_redis'
require 'absurdity'
require 'redis'
require 'mocha'
require 'turn'

class MiniTest::Unit::TestCase

  def teardown
    config = Absurdity::Config.instance
    config.redis && config.redis.flushdb
    config.instance_variable_set(:@redis, nil)
  end

end
