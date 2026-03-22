creator = User.find_or_create_by!(email: "creator@sewtwirly.com") do |user|
  user.name = "Demo Creator"
  user.password = "password123"
  user.role = :creator
end

audience = User.find_or_create_by!(email: "user@sewtwirly.com") do |user|
  user.name = "Demo User"
  user.password = "password123"
  user.role = :audience
end

puts "Seeded: creator (#{creator.email}), audience (#{audience.email})"
