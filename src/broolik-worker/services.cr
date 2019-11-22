require "http/client"

module Broolik::Worker
  class CheckURLService
    def initialize(url : URL)
      @url = url
    end

    def perform
      started_at = Time.utc
      response = HTTP::Client.get @url.url
      finished_at = Time.utc

      response_time = (finished_at.to_unix - started_at.to_unix) * Time::NANOSECONDS_PER_SECOND +
        (finished_at.nanosecond - started_at.nanosecond)
      response_success = response.status_code / 100 == 2 || response.status_code / 100 == 3

      @url.update!(
        processed: true,
        response_http_status: response.status_code.to_s,
        success: response_success,
        processing_time: response_time
      )
    rescue e
      @url.update!(processed: true, success: false) # the simplest skip failed cases
    end
  end
end

