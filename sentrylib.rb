# -*- coding: utf-8 -*-
#!/usr/bin/env ruby
# Sentry 2.1 - By Joel Parker Henderson - joelparkerhenderson@gmail.com
# Copyright 2006 - Creative Commons NonCommercial-ShareAlike 2.5 License

require 'net/http'
require 'net/smtp'


#### HTTP ####################################################################

def get_response (uri)
 res = Net::HTTP.get_response(uri)
 res.code=='200' or res.error!
 return res
end


#### TIME ####################################################################

def speedtest
  start = Time.now 
  yield
  stop = Time.now
  return stop-start
end


#### MAIL ####################################################################

def send_message (msg,from,to)
  Net::SMTP.start('localhost') { |smtp| smtp.send_message msg, from, to }
end

def send_message_with_headers (msg,from,to,subj)
  send_message("From: #{from}\nTo: #{to}\nSubject: #{subj}\n\n"+msg,from,to)  
end


#### HASH ####################################################################

class Array
  def to_h(hash={})
    a = to_a 
    0.step(a.size,2) { |i| hash[a[i]]=a[i+1] }
    hash
  end
end

