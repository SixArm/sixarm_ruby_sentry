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
