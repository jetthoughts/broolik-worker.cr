require "./spec_helper"

describe Broolik::Worker::CheckURLService do
  it "adds check result to db" do
    service = Broolik::Worker::CheckURLService.new("https://www.jetthoughts.com")
    service.store = Store.new(ch = Channel(Bool).new)
    service.perform

    ch.receive.should eq(true)

    URL.find_by(processed: false).should be_nil
    URL.find_by!(processed: true).should be_a(URL)
  end
end
