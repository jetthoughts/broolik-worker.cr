require "sidekiq"
require "./services"

module Broolik::Worker
  class Sample
    include Sidekiq::Worker

    sidekiq_options do |job|
      job.queue = "worker.cr"
    end

    def perform(id : Int64, count : Int64)
      count.times do
        url = URL.find(id)
        if url
          logger.info "Checking #{url.id.to_s}, #{url.url.to_s}!"
          Broolik::Worker::CheckURLService.new(url).perform
          logger.info "Done #{url.id.to_s} #{url.url} => [#{url.last_response_status}]!"
        else
          logger.info "No Url with id: #{id.to_s}"
        end
      end
    end
  end
end
