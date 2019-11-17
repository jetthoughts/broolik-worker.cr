require "sidekiq/cli"

cli = Sidekiq::CLI.new
ENV["WORKER_CR_CONCURRENCY"] ||= cli.@concurrency.to_s

require "./broolik-worker"

# Setup logging
Granite.settings.logger = cli.logger

server = cli.configure { |config| }

# Use shared conenction pool and preload connections
if adapter = Granite::Connections["pg"]
  adapter.open do
    cli.run(server)
  end
end
