require 'uber_config'
require 'iron_worker_ng'

@config = UberConfig.load

# Create the worker payload which has all our image manipulation functions
payload = {
  url: "http://rest-test.iron.io"

}

client = IronWorkerNG::Client.new(@config)
client.tasks.create(
    'pdf', payload.merge(@config)
)
