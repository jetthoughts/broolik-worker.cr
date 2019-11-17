class URL < Granite::Base
  connection pg

  table urls
  column id : Int64, primary: true
  column url : String
  column last_response_status : String?
  column processed : Bool = false
  column processed : Bool = false
  timestamps
end

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

