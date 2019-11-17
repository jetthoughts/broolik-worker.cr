require "sidekiq/cli"

require "./broolik-worker"
require "./broolik-worker/workers"


Granite.settings.logger = Logger.new(STDOUT, Logger::FATAL)

cli = Sidekiq::CLI.new

Granite.settings.logger = cli.logger

server = cli.configure do |config|
  # middleware would be added here
end

adapter = Granite::Connections["pg"]
if adapter
  adapter.open do
    cli.run(server)
  end
end
