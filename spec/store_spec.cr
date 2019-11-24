require "./spec_helper"
require "../src/broolik-worker/store"

describe Store do
  it "aggregate messages to dump" do
    store = Store.new(ch = Channel(Bool).new)
    store.update(UrlAttrs{ :url => "https://www.jetthoughts.com", :processed => true, :processing_time => 12200_i64 })

    ch.receive.should eq(true)

    processed_url = URL.find_by!(url: "https://www.jetthoughts.com")

    processed_url.processed.should eq(true)
    processed_url.processing_time.should eq(12200_i64)
  end
end
