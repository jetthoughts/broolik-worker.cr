require "sidekiq"

module Broolik::Worker
  class URLChecker
    include Sidekiq::Worker

    sidekiq_options do |job|
      job.queue = "worker.cr"
    end

    def perform(url_id : Int64)
      if url = URL.find(url_id)
        logger.debug "Checking #{url.id.to_s}, #{url.url.to_s}!"
        Broolik::Worker::CheckURLService.new(url).perform
        logger.debug "Done #{url.id} #{url.url} => [#{url.response_http_status}]!"
      else
        logger.warn "No Url with id: #{url_id}"
      end
    end
  end
end
