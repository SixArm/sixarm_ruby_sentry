#!/usr/bin/env ruby
#
# Sentry 3.0.0 - By Joel Parker Henderson - joelparkerhenderson@gmail.com
# Copyright 2006-2014 - Creative Commons NonCommercial-ShareAlike 2.5 License


#### REQS ####################################################################

module Sentry
end

require 'net/http'
require 'net/smtp'
require 'socket'
require 'resolv'
require 'resolv-replace'

require_relative 'sentry/extensions/array'
require_relative 'sentry/help'
require_relative 'sentry/helpers/http'
require_relative 'sentry/helpers/mail'
require_relative 'sentry/helpers/smtp'
require_relative 'sentry/helpers/system'
require_relative 'sentry/helpers/time'
require_relative 'sentry/watchers/watch_abstract'
require_relative 'sentry/watchers/watch_dns'
require_relative 'sentry/watchers/watch_uri'


#### ARGS ####################################################################

args = ARGV.to_h

dns          = args['--dns']
uri          = args['--uri']

n            = (args['-n'] || args['--number'] || 1).to_i
speed        = (args['-s'] || args['--speed'] || 0.00).to_f

include_text = args['-i'] || args['--include']
exclude_text = args['-e'] || args['--exclude']

mail_flag    = args['--mail']         || args['--mail-to'] || args['--mail-to'] || args['--mail-to']
mail_to      = args['--mail-to']      || mail_to_default
mail_from    = args['--mail-from']    || mail_from_default
mail_subject = args['--mail-subject'] || mail_subject_default

user_name    = args['-u'] || args['--user'] || user_name_default
host_name    = args['-h'] || args['--host'] || host_name_default


#### MAIN ####################################################################

if !(dns || uri)
  help
  exit -1
end

begin
  watch = \
    if dns
      Sentry::WatchDNS.new(dns)
    elsif uri
      Sentry::WatchURI.new(URI.parse(uri))
    else
      raise
    end
  secs = speedtest { n.times { watch.run } } / n
  message = "#{secs} secs average, #{n} number of times, #{uri}"
  if speed > 0 and secs > speed then raise "Too slow: #{secs}>#{speed}" end
  text = watch.text
  if include_text && !text.index(include_text) then raise "Failed include: #{include_text}" end
  if exclude_text &&  text.index(exclude_text) then raise "Failed exclude: #{exclude_text}" end
  puts message
rescue
  puts vitals = [uri,$!,message,`date`,`uname -a`,`w`,`ps -ef`] * "\n\n"
  if mail_flag
    send_message_with_headers(vitals, mail_from, mail_to, mail_subject)
  end
end
