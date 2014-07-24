class Sentry::WatchURI < Sentry::WatchAbstract

  attr_accessor :uri

  def initialize(uri)
    @uri = uri
  end

  def name
    "Sentry: Watch URI #{uri}"
  end

  def run
    case uri.scheme
    when "http", "https"
      text = http_get_response_body(uri)
    when "ftp"
      text = ftp_get_response_text(uri)
    else
      raise "URI scheme unknown: #{uri.scheme}"
    end
  end

end
