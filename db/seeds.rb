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

projects_data = [
  { title: "Spring Floral Sundress", tag_list: "cotton, dress, floral", published: true },
  { title: "Classic Linen Blouse", tag_list: "linen, blouse, simplicity", published: true },
  { title: "Winter Wool Coat WIP", tag_list: "wool, coat, advanced", published: false }
]

projects_data.each do |attrs|
  Project.find_or_create_by!(title: attrs[:title], user: creator) do |p|
    p.tag_list = attrs[:tag_list]
    p.body = "<p>A beautiful handmade project created with care.</p>"
    p.published = attrs[:published]
    p.published_at = attrs[:published] ? 1.week.ago : nil
  end
end

puts "Seeded: creator (#{creator.email}), audience (#{audience.email}), #{Project.count} projects"
