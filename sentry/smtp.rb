require 'net/smtp'

def send_message (msg,from,to)
  Net::SMTP.start('localhost') { |smtp| smtp.send_message msg, from, to }
end

def send_message_with_headers (msg,from,to,subj)
  send_message("From: #{from}\nTo: #{to}\nSubject: #{subj}\n\n"+msg,from,to)
end
