require "logger"
require "pg"
require "granite/adapter/pg"

max_pool_size  = ENV.fetch("WORKER_CR_CONCURRENCY") { "5" }.to_i
initial_pool_size = [max_pool_size * 0.3, 1].max.to_i
puts "postgresql://localhost:5432/rails_crystal_integration_development?initial_pool_size=#{initial_pool_size}&max_pool_size=#{max_pool_size}&max_idle_pool_size=#{initial_pool_size}"
Granite::Connections << Granite::Adapter::Pg.new(
  name: "pg",
  url: "postgresql://localhost:5432/rails_crystal_integration_development?initial_pool_size=#{initial_pool_size}&max_pool_size=#{max_pool_size}&max_idle_pool_size=#{initial_pool_size}"
)

module Broolik::Worker
  VERSION = "0.1.0"
end

require "./broolik-worker/models"
require "./broolik-worker/services"
require "./broolik-worker/workers"

