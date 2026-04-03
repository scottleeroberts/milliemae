require "open-uri"

puts "\n== Sew Twirly Seeds ==\n\n"

# ---------------------------------------------------------------------------
# Helper: download a seed image from a URL into a Tempfile.
# Picsum Photos (picsum.photos) provides stable, beautiful free photographs.
# ---------------------------------------------------------------------------
def seed_image(url, filename)
  local_path = Rails.root.join("db/seeds/images", filename)
  if local_path.exist?
    file = local_path.open("rb")
    # Detect content type from actual file bytes
    return file
  end

  tmpfile = Tempfile.new([File.basename(filename, ".*"), ".jpg"])
  tmpfile.binmode
  URI.open(url, "rb") { |io| tmpfile.write(io.read) }  # rubocop:disable Security/Open
  tmpfile.rewind
  tmpfile
rescue => e
  puts "  [WARN] Could not load image #{filename}: #{e.message}"
  nil
end

# ---------------------------------------------------------------------------
# Admin
# ---------------------------------------------------------------------------
admin = User.find_or_create_by!(email: "admin@sewtwirly.com") do |u|
  u.name     = "Sew Twirly Admin"
  u.password = "password123"
  u.role     = :admin
end
puts "Admin: #{admin.email}"

# ---------------------------------------------------------------------------
# Creators
# ---------------------------------------------------------------------------
emma = User.find_or_create_by!(email: "emma@sewtwirly.com") do |u|
  u.name      = "Emma Hartwell"
  u.password  = "password123"
  u.role      = :creator
  u.bio       = "Slow fashion enthusiast making one-of-a-kind garments from natural fabrics. " \
                "Based in Portland, OR — I believe every seam tells a story."
  u.instagram = "https://www.instagram.com/emmahartwell"
  u.etsy      = "https://www.etsy.com/shop/EmmaHartwellSews"
  u.website   = "https://emmahartwell.com"
end
puts "Creator: #{emma.email}"

sofia = User.find_or_create_by!(email: "sofia@sewtwirly.com") do |u|
  u.name      = "Sofia Reyes"
  u.password  = "password123"
  u.role      = :creator
  u.bio       = "Sewing vintage patterns and sustainable fabrics since 2015. " \
                "LA-based maker obsessed with 1950s silhouettes and responsible sourcing."
  u.instagram = "https://www.instagram.com/sofiasews"
  u.pinterest = "https://www.pinterest.com/sofiareyes"
end
puts "Creator: #{sofia.email}"

# Keep the original demo creator from the old seeds, also keep audience user
demo_creator = User.find_or_create_by!(email: "creator@sewtwirly.com") do |u|
  u.name     = "Demo Creator"
  u.password = "password123"
  u.role     = :creator
end

User.find_or_create_by!(email: "user@sewtwirly.com") do |u|
  u.name     = "Demo User"
  u.password = "password123"
  u.role     = :audience
end

# ---------------------------------------------------------------------------
# Audience users
# ---------------------------------------------------------------------------
audience_attrs = [
  { name: "Maya Chen",   email: "maya@example.com"  },
  { name: "Lily Parker", email: "lily@example.com"  },
  { name: "Priya Nair",  email: "priya@example.com" },
]

audience = audience_attrs.map do |attrs|
  User.find_or_create_by!(email: attrs[:email]) do |u|
    u.name     = attrs[:name]
    u.password = "password123"
    u.role     = :audience
  end
end
puts "Audience: #{audience.map(&:email).join(', ')}"

# ---------------------------------------------------------------------------
# Project definitions
# Each image entry:
#   url:      Picsum Photos URL  (stable, ~800×1000 portrait photos)
#   filename: suggested filename
#   links:    product hotspots — x/y in 0.0–1.0 normalized coordinates
# ---------------------------------------------------------------------------
project_defs = {
  emma => [
    {
      title:     "Spring Floral Sundress",
      published: true,
      offset:    45,
      tags:      "cotton, dress, floral, beginner-friendly",
      body:      "<p>This project has been years in the making — I finally tracked down the perfect Liberty " \
                 "Tana Lawn fabric at a market in Seattle. The pattern is Simplicity 1803, a classic A-line " \
                 "sundress with gathered skirt. I used a French seam finish throughout to keep everything " \
                 "clean inside.</p><p>The fabric is absolutely dreamy to work with — lightweight, colorful, " \
                 "and the print hides my imperfect topstitching beautifully.</p>",
      images: [
        {
          url:      "https://picsum.photos/id/11/800/1000",
          filename: "floral_sundress_main.jpg",
          links: [
            { x: 0.28, y: 0.35, label: "Liberty Tana Lawn Fabric",  url: "https://www.libertylondon.com/us/fabrics/tana-lawn-c-fabrics-tana-lawn" },
            { x: 0.55, y: 0.72, label: "Simplicity 1803 Pattern",   url: "https://www.simplicity.com/simplicity-pattern-1803" }
          ]
        },
        {
          url:      "https://picsum.photos/id/26/800/1000",
          filename: "floral_sundress_detail.jpg",
          links: [
            { x: 0.4, y: 0.45, label: "French Seam Tutorial",       url: "https://www.sewguide.com/french-seam" }
          ]
        }
      ]
    },
    {
      title:     "Classic Linen Blouse",
      published: true,
      offset:    30,
      tags:      "linen, blouse, button-up, intermediate",
      body:      "<p>Linen is my all-time favorite fabric — it gets better with every wash and practically " \
                 "irons itself in a humid Portland summer. This blouse uses the Merchant & Mills Camber " \
                 "pattern, which has a beautifully relaxed fit.</p><p>I used medium-weight Irish linen in " \
                 "dusty sage. The buttonholes were the biggest challenge; I ended up doing them by hand " \
                 "to get the clean finish I wanted.</p>",
      images: [
        {
          url:      "https://picsum.photos/id/42/800/1000",
          filename: "linen_blouse_main.jpg",
          links: [
            { x: 0.3,  y: 0.3,  label: "Irish Linen — Dusty Sage",       url: "https://www.merchantandmills.com/collections/fabric/linen" },
            { x: 0.6,  y: 0.55, label: "Merchant & Mills Camber Pattern", url: "https://www.merchantandmills.com/collections/patterns/products/camber" }
          ]
        },
        {
          url:      "https://picsum.photos/id/64/800/1000",
          filename: "linen_blouse_collar.jpg",
          links: [
            { x: 0.5, y: 0.25, label: "Shell Buttons — 12mm", url: "https://www.etsy.com/search?q=shell+buttons+sewing+12mm" }
          ]
        }
      ]
    },
    {
      title:     "Quilted Market Tote",
      published: true,
      offset:    14,
      tags:      "bag, quilted, cotton, beginner-friendly, accessories",
      body:      "<p>Everyone needs a solid tote bag pattern in their arsenal. I used Essex linen/cotton " \
                 "blend in charcoal paired with a fun painterly lining from Ruby Star Society. The quilting " \
                 "is just a simple diagonal grid — achievable even on a budget machine.</p>" \
                 "<p>Finished dimensions: 14\" wide × 16\" tall × 4\" gusset. It holds a surprising amount " \
                 "of groceries.</p>",
      images: [
        {
          url:      "https://picsum.photos/id/82/800/1000",
          filename: "quilted_tote_main.jpg",
          links: [
            { x: 0.35, y: 0.4,  label: "Essex Linen/Cotton — Charcoal", url: "https://www.robertkaufman.com/fabrics/essex" },
            { x: 0.65, y: 0.65, label: "Ruby Star Society Fabric",      url: "https://rubystarsociety.com/collections/fabric" }
          ]
        },
        {
          url:      "https://picsum.photos/id/102/800/1000",
          filename: "quilted_tote_inside.jpg",
          links: [
            { x: 0.5, y: 0.5, label: "Pellon 987F Fusible Fleece", url: "https://www.pellon.com/products/987f-fusible-fleece" }
          ]
        }
      ]
    },
    {
      title:     "Oversized Wool Coat — WIP",
      published: false,
      offset:    0,
      tags:      "wool, coat, advanced, outerwear",
      body:      "<p>My most ambitious project yet. I've been collecting the courage — and the fabric " \
                 "budget — for this for three years. Using double-face wool from Mood Fabrics in deep camel " \
                 "and Vogue 9282 as the base pattern, heavily modified.</p>" \
                 "<p>Currently at the muslin stage. Fitting the shoulders has been a two-week ordeal. " \
                 "More updates soon.</p>",
      images: [
        {
          url:      "https://picsum.photos/id/120/800/1000",
          filename: "wool_coat_wip.jpg",
          links: [
            { x: 0.4, y: 0.3,  label: "Double Face Wool — Mood Fabrics", url: "https://www.moodfabrics.com/double-face-wool" },
            { x: 0.7, y: 0.55, label: "Vogue 9282 Pattern",              url: "https://voguepatterns.mccall.com/v9282" }
          ]
        }
      ]
    }
  ],

  sofia => [
    {
      title:     "1950s Houndstooth Circle Skirt",
      published: true,
      offset:    60,
      tags:      "vintage, skirt, cotton, intermediate, 1950s",
      body:      "<p>The circle skirt is the quintessential 1950s silhouette and I am here for it. I found " \
                 "this amazing black and white houndstooth cotton at a thrift store — about 4 yards — and " \
                 "it was absolutely destined to become a skirt.</p>" \
                 "<p>I self-drafted the pattern using the circle skirt radius formula. Added a vintage-style " \
                 "crinoline petticoat underneath for maximum twirl factor.</p>",
      images: [
        {
          url:      "https://picsum.photos/id/140/800/1000",
          filename: "circle_skirt_main.jpg",
          links: [
            { x: 0.4,  y: 0.55, label: "Houndstooth Cotton Fabric",    url: "https://www.fabric.com/buy/houndstooth-cotton" },
            { x: 0.65, y: 0.8,  label: "Crinoline Petticoat — Vintage", url: "https://www.etsy.com/search?q=crinoline+petticoat+vintage+1950s" }
          ]
        },
        {
          url:      "https://picsum.photos/id/165/800/1000",
          filename: "circle_skirt_waistband.jpg",
          links: [
            { x: 0.45, y: 0.3, label: "Invisible Zipper — Black 7\"", url: "https://www.joann.com/invisible-zipper-black" }
          ]
        }
      ]
    },
    {
      title:     "Embroidered Denim Jacket",
      published: true,
      offset:    22,
      tags:      "denim, jacket, embroidery, advanced, upcycle",
      body:      "<p>Started with a thrifted Gap denim jacket ($4!) and turned it into a wearable art piece. " \
                 "The embroidery is a mix of satin stitch, French knots, and lazy daisy flowers across the " \
                 "back yoke and both chest pockets.</p>" \
                 "<p>About 40 hours of hand embroidery over three months of TV-watching evenings. " \
                 "Totally worth it.</p>",
      images: [
        {
          url:      "https://picsum.photos/id/188/800/1000",
          filename: "denim_jacket_back.jpg",
          links: [
            { x: 0.5,  y: 0.4,  label: "DMC Embroidery Floss — Colour Pack", url: "https://www.dmc.com/us/6-strand-embroidery-floss" },
            { x: 0.3,  y: 0.65, label: "Embroidery Needle Set",              url: "https://www.clover-usa.com/needle-sets" }
          ]
        },
        {
          url:      "https://picsum.photos/id/210/800/1000",
          filename: "denim_jacket_detail.jpg",
          links: [
            { x: 0.5, y: 0.5, label: "Sulky Solvy Water Soluble Stabilizer", url: "https://www.sulky.com/solvy-water-soluble-topping" }
          ]
        }
      ]
    },
    {
      title:     "Silk Charmeuse Bias Slip Dress — WIP",
      published: false,
      offset:    0,
      tags:      "silk, dress, bias-cut, advanced",
      body:      "<p>Bias cut silk is notoriously difficult and I am a masochist, apparently. Using 3m of " \
                 "silk charmeuse in dusty mauve from Mood Fabrics. The pattern is loosely based on " \
                 "Vogue 1604 but I've draped and redraped the bodice three times now.</p>" \
                 "<p>Silk charmeuse slides everywhere. My tip: use pattern weights, cut on a hard surface, " \
                 "and have a glass of wine nearby.</p>",
      images: [
        {
          url:      "https://picsum.photos/id/230/800/1000",
          filename: "silk_slip_wip.jpg",
          links: [
            { x: 0.5,  y: 0.35, label: "Silk Charmeuse — Dusty Mauve", url: "https://www.moodfabrics.com/silk-charmeuse" },
            { x: 0.3,  y: 0.65, label: "Vogue 1604 Pattern",           url: "https://voguepatterns.mccall.com/v1604" }
          ]
        }
      ]
    }
  ]
}

# ---------------------------------------------------------------------------
# Create projects, images, product links
# ---------------------------------------------------------------------------
puts "\nCreating projects...\n"

project_defs.each do |creator, projects|
  projects.each do |attrs|
    project = Project.find_or_create_by!(title: attrs[:title], user: creator) do |p|
      p.tag_list    = attrs[:tags]
      p.body        = attrs[:body]
      p.published   = attrs[:published]
      p.published_at = attrs[:published] ? attrs[:offset].days.ago : nil
    end

    print "  #{attrs[:title]}"

    if project.project_images.any?
      puts " (images already present, skipping)"
      next
    end

    attrs[:images].each_with_index do |img_def, idx|
      local = Rails.root.join("db/seeds/images", img_def[:filename]).exist?
      print " → #{local ? 'loading local' : 'downloading'} image #{idx + 1}..."
      tmpfile = seed_image(img_def[:url], img_def[:filename])

      unless tmpfile
        puts " FAILED"
        next
      end

      ext = File.extname(img_def[:filename]).downcase
      content_type = ext == ".png" ? "image/png" : "image/jpeg"

      project_image = ProjectImage.new(project: project, position: idx)
      project_image.image.attach(
        io:           tmpfile,
        filename:     img_def[:filename],
        content_type: content_type
      )
      project_image.save!
      project_image.analyze_image_dimensions

      img_def[:links].each do |link|
        project_image.product_links.create!(
          label: link[:label],
          url:   link[:url],
          x:     link[:x],
          y:     link[:y]
        )
      end
    ensure
      tmpfile&.close
      tmpfile.unlink if tmpfile.is_a?(Tempfile)
    end

    puts " done"
  end
end

# ---------------------------------------------------------------------------
# Social: follows
# ---------------------------------------------------------------------------
puts "\nCreating follows..."
audience.each do |user|
  Follow.find_or_create_by!(follower: user, following: emma)
  Follow.find_or_create_by!(follower: user, following: sofia)
end
Follow.find_or_create_by!(follower: audience[0], following: audience[1])
Follow.find_or_create_by!(follower: emma, following: sofia)

# ---------------------------------------------------------------------------
# Social: likes
# ---------------------------------------------------------------------------
puts "Creating likes..."
Project.published.each do |project|
  audience.first(2).each do |user|
    Like.find_or_create_by!(user: user, project: project)
  end
end

# ---------------------------------------------------------------------------
# Social: comments
# ---------------------------------------------------------------------------
puts "Creating comments..."
comment_bodies = [
  "This is absolutely stunning! The fabric choice is perfect.",
  "I've been wanting to try this pattern — your version is so inspiring!",
  "The construction looks incredibly clean. What thread did you use?",
  "This color is everything. You're making me want to start a new project immediately.",
  "I made something similar last year and yours blows mine out of the water!",
  "Love the fabric combination here. Where did you source the lining?",
  "The hotspot links are so helpful — just ordered the same pattern!",
]

Project.published.each_with_index do |project, i|
  user = audience[i % audience.length]
  unless Comment.exists?(user: user, project: project)
    Comment.create!(
      user:    user,
      project: project,
      body:    comment_bodies[i % comment_bodies.length]
    )
  end
end

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
puts "\n== Done ==\n\n"
puts "  Users:          #{User.count} total — #{User.where(role: :admin).count} admin, " \
     "#{User.where(role: :creator).count} creators, #{User.where(role: :audience).count} audience"
puts "  Projects:       #{Project.count} total — #{Project.published.count} published, #{Project.draft.count} drafts"
puts "  Project Images: #{ProjectImage.count}"
puts "  Product Links:  #{ProductLink.count}"
puts "  Likes:          #{Like.count}"
puts "  Comments:       #{Comment.count}"
puts "  Follows:        #{Follow.count}"
puts "\n  Accounts (password: password123):"
puts "    admin@sewtwirly.com   — admin"
puts "    emma@sewtwirly.com    — creator (Emma Hartwell, 4 projects)"
puts "    sofia@sewtwirly.com   — creator (Sofia Reyes, 3 projects)"
puts "    maya@example.com      — audience"
puts "    lily@example.com      — audience"
puts "    priya@example.com     — audience"
puts "    creator@sewtwirly.com — creator (original demo)"
puts "    user@sewtwirly.com    — audience (original demo)"
puts ""
