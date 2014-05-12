class Sentry::WatchDNS < Sentry::WatchAbstract

  attr_accessor :host

  def initialize(host)
    @host = host
  end

  def name
    "Watch DNS #{host}"
  end

  def run
    Resolv.getaddress(host)
  end

end
