require "sidekiq"

module Broolik::Worker
  class URLChecker
    include Sidekiq::Worker

    sidekiq_options do |job|
      job.queue = "worker.cr"
    end

    def perform(url : String)
      Broolik::Worker::CheckURLService.new(url).perform
    end
  end
end
