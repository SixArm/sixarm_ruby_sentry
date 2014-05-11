# -*- coding: utf-8 -*-
#!/usr/bin/env ruby
# Sentry 2.3.0 - By Joel Parker Henderson - joelparkerhenderson@gmail.com
# Copyright 2006-2014 - Creative Commons NonCommercial-ShareAlike 2.5 License

require 'sentrylib'


#### ARGS ####################################################################

args = ARGV.to_h

uri          = args['--uri'] || 'http://localhost/'
n            = args['-n'].to_i | 1
slow         = args['-s'].to_f
mail_to      = args['--mail-to'] || ENV['USER'] || ENV['USERNAME']
mail_from    = args['--mail-from'] || 'sentry'
mail_subject = args['--mail-subject'] || 'Sentry Alert'
include      = args['--include']
exclude      = args['--exclude']


#### MAIN ####################################################################

begin
  uri = URI.parse(uri)
  res = nil
  secs = speedtest { n.times { res = get_response(uri) } } / n
  message = "#{secs} secs average for #{n} #{uri}"
  if slow > 0 and secs > slow then raise "Too slow: #{secs}>#{slow}" end
  if include and !res.body.index(include) then raise "Failed include: #{include}" end
  if exclude and  res.body.index(exclude) then raise "Failed exclude: #{exclude}" end
  puts message
rescue
  puts vitals = [uri,$!,message,`date`,`uname -a`,`w`,`ps -ef`] * "\n\n"
  if to then send_message_with_headers(vitals, mail_from, mail_to, mail_subject) end
end
