def user_name_default
  ENV['USER'] || ENV['USERNAME]' || `whoami`.chomp
end

def host_name_default
  ENV['HOST'] || ENV['HOSTNAME'] || Socket.gethostbyname(Socket.gethostname).first
end
