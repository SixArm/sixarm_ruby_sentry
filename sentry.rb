#!/usr/bin/env ruby
#
# Sentry 3.0.0 - By Joel Parker Henderson - joelparkerhenderson@gmail.com
# Copyright 2006-2014 - Creative Commons NonCommercial-ShareAlike 2.5 License


#### REQS ####################################################################

module Sentry
end

## Options
require 'optparse'
require 'ostruct'

## Networking
require 'net/http'
require 'net/smtp'
require 'socket'
require 'resolv'
require 'resolv-replace'

## Sentry
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


#### OPTS ####################################################################

options = OpenStruct.new

optparse = OptionParser.new do |opts|

  opts.banner = "Usage: sentry [options]"

  ## Help

  opts.on('-h', '--help', 'Help') do
    help
    puts opts
    exit
  end

  ## Watchers

  opts.on('--dns [host name]', 'Test that the system can resolve a DNS host name') do |x|
    options.dns = x
  end

  opts.on('--uri [uri text]', 'Test that the system can fetch URI') do |x|
    p "x:#{x}"
    options.uri = x
    p "options.uri:#{options.uri}"
  end

  ## Diagnostics

  opts.on('-n', '--number [number of times to run]', 'Run the test _n_ times') do |x|
    options.n = x
  end

  opts.on('-s', '--speed [seconds]', 'Verify the test runs within _s_ seconds') do |x|
    options.speed = x
  end

  ## Text OK?

  opts.on('-i', '--include [text]', 'Verify the result must include text') do |x|
    options.include_text = x
  end

  opts.on('-e', '--exclude [text]', 'Verify the result must exclude text') do |x|
    options.exclude_text = x
  end

  ## Mail

  opts.on('--mail', 'Send alert via mail, using default settings') do
    options.mail_flag = true
  end

  opts.on('--mail-to [email address]', 'Send alert via mail, to a given email address') do |x|
    options.mail_to = x
  end

  opts.on('--mail-from [email address]', 'Send alert via mail, from a given email address') do |x|
    options.mail_from = x
  end

  opts.on('--mail-subject [text]', 'Send alert via mail, using a given email subject') do |x|
    options.mail_subject = x
  end

  ## System

  opts.on('--user [user name]', 'The local system user name') do |x|
    options.user_name = x
  end

  opts.on('--host [host name]', 'The local system host name') do |x|
    options.host_name = x
  end

end

optparse.parse!


#### MAIN ####################################################################

if !(options.dns || options.uri)
  help
  exit -1
end

watch = nil
p options
p ARGV

begin

puts "here"

  # Create
  watch = \
    if options.dns
      p "dns"
      Sentry::WatchDNS.new(options.dns)
    elsif options.uri
      x = options.uri
      p x
      x.index('://') or x = "http://#{x}"
      p x
      uri = URI.parse(x)
      p "uri:#{uri}"
      Sentry::WatchURI.new(uri)
    else
      raise
    end

  puts "here2"
  puts watch.name

  ## Run
  n = options.n || 1
  secs = speedtest { n.times { watch.run } } / n
  message = "Sentry #{watch.name} => speed:#{secs}s" + ((n==1) ? "" : " (avg, n=#{n})")

  ## Speed OK?
  x = options.speed; if secs > x then raise "Too slow: #{secs}>#{x}" end

  ## Text OK?
  x = options.include_text; if x && !watch.text.index(x) then raise "Failed include: #{x}" end
  x = options.exclude_text; if x &&  watch.text.index(x) then raise "Failed exclude: #{x}" end

  ## Results
  puts message

rescue
  puts vitals = [watch.name, $!, message, `date`, `uname -a`, `w`, `ps -ef`] * "\n\n"
  if mail_flag
    from     = options.mail_from     || mail_from_default
    to       = options.mail_to       || mail_to_default
    subject  = options.mail_subject  || mail_subject_default
    send_message_with_headers(vitals, from, to, subject)
  end
end
