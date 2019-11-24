# connect to DB
# open connection (up to 5)
# create buffered channel to accept data to flush
# process buffered channel

alias UrlAttrs = Hash(Symbol, String | Bool | Int64 | ::Nil)

class Store
  def self.instance
    @@store ||= Store.new
  end

  def initialize(feedback_channel : Channel(Bool)? = nil)
    @buffer_size = 1_000
    @channel = Channel(UrlAttrs | ::Nil).new
    @feedback_channel = feedback_channel

    # Tick each 5 secs in order to flush changes even if there is no new attrs to process
    # NOTE: As idea to make it more explicit wihtout hacks with `nil`.
    # We could use 2 channels one for data, another for timeout ticker.
    # In receiver we should select the frist receive
    # and if it is from timer tickers we should flush
    # and if it is from channel and buffer has been reached we should flush too
    spawn do
      loop do
        sleep 5
        @channel.send(nil)
      end
    end

    spawn do
      # buffer
      urls_attrs_buffer = Array(UrlAttrs | ::Nil).new
      # To track is it time to flush buffer
      last_flush_at = Time.utc

      loop do
          urls_attrs_buffer << @channel.receive

          buffer_age_in_secs = (Time.utc - last_flush_at).to_i
          buffer_is_full = urls_attrs_buffer.size >= @buffer_size

          if buffer_is_full || buffer_age_in_secs > 30
            begin
              import_new_urls(urls_attrs_buffer)

              urls_attrs_buffer.clear
              last_flush_at = Time.utc

              @feedback_channel.not_nil!.send(true) if @feedback_channel
            rescue e
              puts e.message
              @feedback_channel.not_nil!.send(false) if @feedback_channel
            end
          end
      end
    end
  end

  def update(args : UrlAttrs)
    @channel.send(args)
  end

  def import_new_urls(urls : Array(UrlAttrs | ::Nil))
    URL.import(
      urls
       .reject { |url| url.nil? || url.empty? }
       .map { |url| URL.new(url.not_nil!) }
    )
  end
end
