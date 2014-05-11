require 'net/http'

def http_get_response (uri)
 res = Net::HTTP.get_response(uri)
 res.code=='200' or res.error!
 return res
end

def http_get_response_body (uri)
 http_get_response(uri).body
end
