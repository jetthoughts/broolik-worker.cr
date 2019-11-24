require "http/client"
require "./store"

module Broolik::Worker
  class CheckURLService
    def initialize(url : String)
      @url = url
      @store = Store.instance
    end

    def store=(new_store)
      @store = new_store
    end

    def perform
      response, response_time = instrument { HTTP::Client.get @url }

      @store.update(UrlAttrs{
          :url => @url,
          :processed => true,
          :response_http_status => response.status_code.to_s,
          :success => validate(response),
          :processing_time => response_time
      })
    rescue e
      @store.update(UrlAttrs{ :url => @url, :processed => true, :success => false })
    end

    private def instrument(&block)
      started_at = Time.utc
      result = yield
      finished_at = Time.utc

      return result,
        (finished_at.to_unix - started_at.to_unix) * Time::NANOSECONDS_PER_SECOND +
          (finished_at.nanosecond - started_at.nanosecond)
    end

    private def validate(response)
      response.status_code // 100 == 2 || response.status_code // 100 == 3
    end
  end
end

