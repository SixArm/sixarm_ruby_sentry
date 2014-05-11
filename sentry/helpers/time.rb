def speedtest
  start = Time.now
  yield
  stop = Time.now
  return stop-start
end
