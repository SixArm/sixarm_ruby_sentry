# -*- coding: utf-8 -*-
#!/usr/bin/env ruby
# Sentry 2.3.0 - By Joel Parker Henderson - joelparkerhenderson@gmail.com
# Copyright 2006-2014 - Creative Commons NonCommercial-ShareAlike 2.5 License


#### TIME ####################################################################

def speedtest
  start = Time.now
  yield
  stop = Time.now
  return stop-start
end


#### MAIL ####################################################################

require 'net/smtp'

def send_message (msg,from,to)
  Net::SMTP.start('localhost') { |smtp| smtp.send_message msg, from, to }
end

def send_message_with_headers (msg,from,to,subj)
  send_message("From: #{from}\nTo: #{to}\nSubject: #{subj}\n\n"+msg,from,to)
end
