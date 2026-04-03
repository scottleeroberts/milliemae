# Sew Twirly — Seed Image Generation Prompts

Use these prompts with Midjourney, DALL-E 3, Stable Diffusion, or Adobe Firefly.
Target: **portrait orientation, 800×1000px (4:5 ratio)**, natural/studio lighting.

Replace the Picsum placeholder photos in `db/seeds.rb` with the generated images by:
1. Saving them to `db/seeds/images/`
2. Changing the `url:` entries to use `file: Rails.root.join("db/seeds/images/FILENAME")`
   and updating `io: File.open(...)` in the seed helper.

---

## Emma Hartwell's Projects

### 1. Spring Floral Sundress — Main Shot
**Use for:** `floral_sundress_main.jpg`

```
Flat lay photograph of a handmade floral cotton sundress on a white linen surface.
Fitted bodice with gathered A-line skirt, small pink and coral flowers on cream cotton,
French seam construction visible, fabric has a Liberty of London Tana Lawn quality.
Soft diffused natural light from window, fresh flower petals and sewing thread scattered nearby.
Professional sewing blog photography, overhead shot, clean composition.
--ar 4:5 --style raw
```

### 2. Spring Floral Sundress — Fabric Detail
**Use for:** `floral_sundress_detail.jpg`

```
Close-up macro photograph of a floral cotton sundress skirt hem detail.
Liberty-style Tana Lawn print fabric with delicate pink and coral flowers,
visible French seam finish on inside edge, soft natural light, shallow depth of field.
Fabric draped on a wooden surface, sewing blog aesthetic.
--ar 4:5 --style raw
```

---

### 3. Classic Linen Blouse — Main Shot
**Use for:** `linen_blouse_main.jpg`

```
Flat lay of a handmade relaxed linen blouse in dusty sage green on a neutral linen surface.
Boxy silhouette with dropped shoulders and placket front, medium-weight Irish linen,
minimal Scandi aesthetic, natural light, subtle shadow play.
Shot from slightly above, sewing notions and linen scraps in background.
Professional maker photography, muted color palette.
--ar 4:5 --style raw
```

### 4. Classic Linen Blouse — Collar Detail
**Use for:** `linen_blouse_collar.jpg`

```
Close-up of a handmade linen shirt collar and hand-sewn buttonholes.
Dusty sage Irish linen fabric, small cream shell buttons, clean hand-finished buttonholes,
soft natural side lighting to show fabric texture and hand stitching detail.
Shallow depth of field, wooden surface background.
--ar 4:5 --style raw
```

---

### 5. Quilted Market Tote — Main Shot
**Use for:** `quilted_tote_main.jpg`

```
Flat lay photograph of a handmade quilted tote bag on a wooden surface.
Outer fabric is charcoal Essex linen-cotton blend with a simple diagonal quilting grid,
bag is filled with a few groceries (baguette, greenery) to show scale and use.
Natural warm window light, artisan/handmade aesthetic, clean composition.
--ar 4:5 --style raw
```

### 6. Quilted Market Tote — Interior
**Use for:** `quilted_tote_inside.jpg`

```
Open handmade tote bag photographed from above showing colorful printed interior lining.
Ruby Star Society-style abstract painterly print in warm tones, contrasting with charcoal exterior,
bag pinned open to show lining and internal structure, clean machine-stitched seams visible.
Flat lay on wooden floor, natural light.
--ar 4:5 --style raw
```

---

### 7. Oversized Wool Coat — WIP
**Use for:** `wool_coat_wip.jpg`

```
Work-in-progress photo of a handmade wool coat muslin on a dressmaker mannequin.
Unfinished camel-colored double-face wool fabric with chalk markings and fitting pins,
seam allowances visible, some basting stitches, pattern pieces and a tape measure nearby.
Natural home sewing studio light, behind-the-scenes maker photography.
--ar 4:5 --style raw
```

---

## Sofia Reyes's Projects

### 8. 1950s Circle Skirt — Main Shot
**Use for:** `circle_skirt_main.jpg`

```
Flat lay of a handmade 1950s-style circle skirt on a soft pink surface.
Black and white houndstooth cotton fabric, full circle silhouette, high waist with concealed zipper,
crinoline petticoat layer peeking underneath hem, retro vintage styling.
Overhead shot, soft studio light, vintage fashion photography aesthetic.
--ar 4:5 --style raw
```

### 9. 1950s Circle Skirt — Waistband Detail
**Use for:** `circle_skirt_waistband.jpg`

```
Close-up of a houndstooth circle skirt waistband and invisible zipper detail.
Black and white cotton houndstooth, clean pressed waistband with hook-and-bar closure,
invisible zipper perfectly flush with fabric, vintage aesthetic, natural light.
Shallow depth of field, white surface background.
--ar 4:5 --style raw
```

---

### 10. Embroidered Denim Jacket — Back Shot
**Use for:** `denim_jacket_back.jpg`

```
Flat lay photograph of the back of a hand-embroidered denim jacket.
Classic medium-wash denim with dense floral hand embroidery covering the yoke.
Mix of satin stitch flowers in pink, coral, and yellow with French knot centers,
DMC embroidery floss, intricate and detailed, overhead flat lay on white surface.
Artisan craft photography, natural light.
--ar 4:5 --style raw
```

### 11. Embroidered Denim Jacket — Embroidery Detail
**Use for:** `denim_jacket_detail.jpg`

```
Macro close-up of hand embroidery on denim fabric.
Satin stitch floral motifs, French knots, and lazy daisy petals in DMC floss,
pink coral and yellow thread on medium-wash denim, sharp focus on individual stitches,
soft bokeh background, natural side lighting to highlight thread texture.
--ar 4:5 --style raw
```

---

### 12. Silk Slip Dress — WIP
**Use for:** `silk_slip_wip.jpg`

```
Work-in-progress photo of a handmade bias-cut silk slip dress on a dressmaker form.
Dusty mauve silk charmeuse fabric, bias-cut drape with visible hand basting stitches,
pins marking fitting adjustments, measuring tape draped nearby.
Soft diffused natural light, intimate home studio atmosphere, romantic mood.
Shallow depth of field, warm neutral background.
--ar 4:5 --style raw
```

---

## Tips for Best Results

- **Midjourney:** Add `--v 6 --style raw` for photorealistic results
- **DALL-E 3:** Prefix with "realistic photograph, DSLR quality, " for better photo results
- **Stable Diffusion:** Use a photorealistic checkpoint like `Realistic Vision` or `DreamShaper`
- **Lighting:** All prompts assume soft natural window light — this looks most authentic for sewing blogs
- **File format:** Export as JPEG, 800×1000px, quality 85+. PNG also accepted.

After generating, drop files into `db/seeds/images/` and update the URLs in `db/seeds.rb`.
