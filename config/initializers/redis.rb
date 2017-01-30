if Hanami.env?(:production)
  uri = URI.parse(ENV.fetch("REDISTOGO_URL"))
  redis_conn = proc do
    Redis.new(
      driver: :hiredis,
      host: uri.host,
      port: uri.port,
      password: uri.password
    )
  end

  REDIS_CLIENT = ConnectionPool.new(size: 10, timeout: 3, &redis_conn)
  REDIS_SERVER = ConnectionPool.new(size: 27, timeout: 3, &redis_conn)

elsif Hanami.env?(:test)
  REDIS = REDIS_CLIENT = REDIS_SERVER = ConnectionPool.new(size: 10, timeout: 3) do
    MockRedis.new
  end

else
  redis_conn = proc { Redis.new(host: 'redis', port: 6379) }

  REDIS_CLIENT = ConnectionPool.new(size: 5, timeout: 3, &redis_conn)
  REDIS_SERVER = ConnectionPool.new(size: 27, timeout: 3, &redis_conn)
end
