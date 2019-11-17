require "logger"
require "pg"
require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(
  name: "pg",
  url: "postgresql://localhost:5432/rails_crystal_integration_development?initial_pool_size=20&max_pool_size=80&max_idle_pool_size=20"
)

require "./broolik-worker/services"

module Broolik::Worker
  VERSION = "0.1.0"
end

