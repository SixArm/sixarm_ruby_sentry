require 'pathname'
require 'net/ftp'

def ftp_get_response_text (uri)
  ftp = Net::FTP.new(uri.host, uri.user, uri.password)
  path = Pathname.new(uri.path.sub(/^\//,''))
  ftp.chdir(path.dirname)
  text = ""; ftp.get(path.basename){|x| text << x}
  text
endend
