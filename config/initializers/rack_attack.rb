Rack::Attack.throttle("logins/ip", limit: 10, period: 60) do |req|
  req.ip if req.path == "/users/sign_in" && req.post?
end

Rack::Attack.throttle("passwords/ip", limit: 5, period: 60) do |req|
  req.ip if req.path == "/users/password" && req.post?
end

Rack::Attack.throttle("registrations/ip", limit: 5, period: 60) do |req|
  req.ip if req.path == "/users" && req.post?
end

Rack::Attack.throttle("comments/ip", limit: 20, period: 60) do |req|
  req.ip if req.path.match?(%r{/projects/.+/comments}) && req.post?
end

Rack::Attack.throttle("invitations/accept/ip", limit: 5, period: 300) do |req|
  req.ip if req.path.match?(%r{/invitations/.+/accept}) && req.post?
end

Rack::Attack.throttled_responder = lambda do |_req|
  [429, { "Content-Type" => "text/plain" }, ["Rate limit exceeded. Please try again later.\n"]]
end
