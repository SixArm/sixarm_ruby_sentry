#!/usr/bin/env ruby
# Sentry 2.3.0 - By Joel Parker Henderson - joelparkerhenderson@gmail.com
# Copyright 2006-2014 - Creative Commons NonCommercial-ShareAlike 2.5 License

module Sentry
end

require_relative 'sentry/helpers'
require_relative 'sentry/array'
require_relative 'sentry/watch_abstract'
require_relative 'sentry/watch_uri'


#### ARGS ####################################################################

args = ARGV.to_h

uri          = args['--uri']
n            = args['-n'].to_i | 1
slow         = args['-s'].to_f
mail_to      = args['--mail-to'] || ENV['USER'] || ENV['USERNAME']
mail_from    = args['--mail-from'] || 'sentry'
mail_subject = args['--mail-subject'] || 'Sentry Alert'
include      = args['--include']
exclude      = args['--exclude']


#### HELP ###################################################################

def help
  puts "Sentry"
  puts ""
  puts "Please specify something to watch."
  puts ""
  puts "Example:"
  puts ""
  puts "   sentry --uri http://www.example.com"
  puts ""
end


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
  if to then send_message_with_headers(vitals, mail_from, mail_to, mail_subject) end
end
