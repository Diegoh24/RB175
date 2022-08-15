require "socket"

def parse_request(request_line)
  http_method, path, http = request_line.split
  path, params = path.split("?")

  params = (params || "").split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 8080)

loop do
  client = server.accept #waits for a request, accept accepts call and opens the connection to the client.

  request_line = client.gets #gets the first line of the request (text)
  puts request_line

  next unless request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK\r\n"
  client.puts "Content-Type: text/html"
  client.puts

  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"

  client.puts "<a href='?number=#{number + 1}'>Add One</a>"
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"


  client.puts "</body>"
  client.puts "</html>"
  client.close
end