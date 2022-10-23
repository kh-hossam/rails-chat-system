# rabbitmq needs backend queue like sneaker, and sneakers depends on redis, 
# and we use bunny as rabbitmq client to connect to rabbitmq

# $redis = Redis::Namespace.new("chat_system",:redis => Redis.new(host: :redis))
$redis = Redis.new(host: "redis")

$bunny = Bunny.new(:host => "rabbitmq",
                    :port =>  '5672',
                    :vhost => '/',
                    :user =>  'guest',
                    :pass =>  'guest')

Sneakers.configure(:amqp => "amqp://guest:guest@rabbitmq:5672")