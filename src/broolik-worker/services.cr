require "http/client"

module Broolik::Worker
  class CheckURLService
    def initialize(url : URL)
      @url = url
    end

    def perform
      response = HTTP::Client.get @url.url
      @url.update!(processed: true, last_response_status: response.status_code.to_s)
    end
  end
end

