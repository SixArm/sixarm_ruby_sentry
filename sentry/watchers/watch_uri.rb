class Sentry::WatchURI < Sentry::WatchAbstract

  attr_accessor :uri

  def initialize(uri)
    @uri = uri
  end

  def name
    "Watch URI #{uri}"
  end

  def run
    text = http_get_response_body(uri)
  end

end
