require 'test_helper'

class ConfigTest < MiniTest::Unit::TestCase

  def test_redis_setter_and_getter
    a_redis = MockRedis.new
    Absurdity::Config.instance.redis = a_redis

    assert_equal a_redis, Absurdity::Config.instance.redis
  end

end

