#!/usr/bin/env ruby
# Sentry 2.3.0 - By Joel Parker Henderson - joelparkerhenderson@gmail.com
# Copyright 2006-2014 - Creative Commons NonCommercial-ShareAlike 2.5 License

module Sentry
end

require_relative 'sentry/help'
require_relative 'sentry/helpers/array'
require_relative 'sentry/helpers/http'
require_relative 'sentry/helpers/smtp'
require_relative 'sentry/helpers/system'
require_relative 'sentry/helpers/time'
require_relative 'sentry/watch_abstract'
require_relative 'sentry/watch_uri'


#### ARGS ####################################################################

args = ARGV.to_h

uri          = args['--uri']

n            = (args['-n'] || args['--number'] || 1).to_i
slow         = (args['-s'] || args['--speed'] || 0.00).to_f

include      = args['-i'] || args['--include']
exclude      = args['-e'] || args['--exclude']

mail_flag    = args['--mail']         || mail_flag_default
mail_to      = args['--mail-to']      || mail_to_default
mail_from    = args['--mail-from']    || mail_from_default
mail_subject = args['--mail-subject'] || mail_subject_default

user_name    = args['-u'] || args['--user'] || user_name_default
host_name    = args['-h'] || args['--host'] || host_name_default


#### MAIN ####################################################################

if !uri
  help
  exit -1
end

begin
  watch = Sentry::WatchURI.new(URI.parse(uri))
  secs = speedtest { n.times { watch.run } } / n
  text = watch.text
  message = "#{secs} secs average for #{n} #{uri}"
  if slow > 0 and secs > slow then raise "Too slow: #{secs}>#{slow}" end
  if include and !text.index(include) then raise "Failed include: #{include}" end
  if exclude and  text.index(exclude) then raise "Failed exclude: #{exclude}" end
  puts message
rescue
  puts vitals = [uri,$!,message,`date`,`uname -a`,`w`,`ps -ef`] * "\n\n"
  if mail_flag
    send_message_with_headers(vitals, mail_from, mail_to, mail_subject)
  end
end


#### MAIL ####################################################################

def mail_flag_default
  false
end

def mail_to_default
  user_name_default
end

def mail_from_default
  'sentry'
end

def mail_subject_default
  'Sentry Alert'
end
