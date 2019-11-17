require "./spec_helper"

describe Broolik::Worker::CheckURLService do
  it "adds check result to db" do
    url = URL.create!(url: "test")
    Broolik::Worker::CheckURLService.new(url).perform
    URL.find_by(processed: false).should be_nil
    URL.find_by(processed: true).should be_a(URL)
  end

  it "fixtures correct" do
    url = URL.create!(url: "test")
    URL.find_by(processed: true).should be_nil

    Broolik::Worker::CheckURLService.new(url).perform
    URL.find_by(processed: false).should be_nil
    URL.find_by(processed: true).should be_a(URL)
  end

  Spec.after_each { URL.clear }
end
