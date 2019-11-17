require "sidekiq/cli"

cli = Sidekiq::CLI.new
ENV["WORKER_CR_CONCURRENCY"] ||= cli.@concurrency.to_s

require "./broolik-worker"
require "./broolik-worker/workers"

# Setup logging
Granite.settings.logger = cli.logger

# Use shared conenction pool and preload connections
if adapter = Granite::Connections["pg"]
  adapter.open do
    cli.run(server)
  end
end
