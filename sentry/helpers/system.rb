def user_name_default
  ENV['USER'] || ENV['USERNAME'] || (`whoami` || '').chomp
end

def host_name_default
  ENV['HOST'] || ENV['HOSTNAME'] || (x = Socket.gethostbyname(Socket.gethostname) ? x.first : 'localhost')
end
