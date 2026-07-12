"""Generate app icons and store graphics from the source icon.png.

Source: icon.png (611x579, full-bleed blue-gradient design, opaque).

Outputs:
  assets/icon/app_icon.png              1024x1024 square master, no alpha
                                        (flutter_launcher_icons source for
                                        legacy Android / iOS / web)
  assets/icon/app_icon_foreground.png   1024x1024 adaptive foreground: the
                                        white glyph keyed onto transparency,
                                        scaled into the adaptive safe zone
  assets/icon/app_icon_background.png    1024x1024 blue gradient (adaptive bg)
  store-listing/assets/app-icon-1024.png            App Store icon / master
  store-listing/assets/play-store-icon-512.png      Play Console listing icon
  store-listing/assets/play-feature-graphic-1024x500.png  Play feature graphic
"""

from PIL import Image, ImageDraw, ImageFont
import numpy as np

SRC = "icon.png"

# Gradient corner colours sampled from the source (RGB).
TL = (19, 126, 206)
TR = (20, 116, 200)
BL = (10, 86, 164)
BR = (16, 67, 148)


def bilinear_gradient(w, h, tl, tr, bl, br):
    """Full-bleed bilinear gradient across a w x h canvas."""
    tl = np.array(tl, float); tr = np.array(tr, float)
    bl = np.array(bl, float); br = np.array(br, float)
    fx = np.linspace(0, 1, w)[None, :, None]   # (1,w,1)
    fy = np.linspace(0, 1, h)[:, None, None]   # (h,1,1)
    top = tl * (1 - fx) + tr * fx              # (1,w,3)
    bot = bl * (1 - fx) + br * fx
    grad = top * (1 - fy) + bot * fy           # (h,w,3)
    return Image.fromarray(np.clip(grad, 0, 255).astype("uint8"), "RGB")


def square_master(size=1024):
    """Crop the source to a centred square (removes only background) then
    resize. No distortion, no alpha."""
    im = Image.open(SRC).convert("RGB")
    w, h = im.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    im = im.crop((left, top, left + side, top + side))
    return im.resize((size, size), Image.LANCZOS)


def smoothstep(x, lo, hi):
    t = np.clip((x - lo) / (hi - lo), 0.0, 1.0)
    return t * t * (3 - 2 * t)


def rounded_mask(size, radius):
    m = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(m)
    d.rounded_rectangle([0, 0, size - 1, size - 1], radius=radius, fill=255)
    return m


# ---------------------------------------------------------------------------
# 1. Square master (legacy Android / iOS / web / App Store / master)
# ---------------------------------------------------------------------------
master = square_master(1024)
master.save("assets/icon/app_icon.png")
master.save("store-listing/assets/app-icon-1024.png")
print("master 1024 -> assets/icon/app_icon.png, store-listing/assets/app-icon-1024.png")

# ---------------------------------------------------------------------------
# 2. Play Console listing icon: 512x512, 32-bit with alpha
# ---------------------------------------------------------------------------
master.resize((512, 512), Image.LANCZOS).convert("RGBA").save(
    "store-listing/assets/play-store-icon-512.png")
print("play icon 512 -> store-listing/assets/play-store-icon-512.png")

# ---------------------------------------------------------------------------
# 3. Adaptive icon background: full-bleed blue gradient
# ---------------------------------------------------------------------------
bg = bilinear_gradient(1024, 1024, TL, TR, BL, BR)
bg.save("assets/icon/app_icon_background.png")
print("adaptive background -> assets/icon/app_icon_background.png")

# ---------------------------------------------------------------------------
# 4. Adaptive icon foreground: white glyph keyed onto transparency,
#    scaled into the adaptive safe zone (~62% of the 108dp layer).
# ---------------------------------------------------------------------------
arr = np.asarray(master.convert("RGB"), float)
luma = 0.299 * arr[..., 0] + 0.587 * arr[..., 1] + 0.114 * arr[..., 2]
# background blue luma < ~110 everywhere; glyph luma > ~200. Ramp between.
alpha = (smoothstep(luma, 120.0, 175.0) * 255).astype("uint8")
glyph = np.dstack([arr.astype("uint8"), alpha])
glyph_img = Image.fromarray(glyph, "RGBA")

# autocrop to the glyph's opaque bbox, scale to the safe zone, centre.
bbox = glyph_img.getbbox()
glyph_c = glyph_img.crop(bbox)
gw, gh = glyph_c.size
# flutter_launcher_icons wraps this foreground in a further android:inset="16%"
# (drawable scaled to 68% of the layer), so fill ~90% here => ~0.90*0.68 ≈ 0.61
# of the final adaptive icon, landing inside the ~66% safe zone.
target = int(1024 * 0.90)
scale = target / max(gw, gh)
glyph_c = glyph_c.resize((max(1, int(gw * scale)), max(1, int(gh * scale))), Image.LANCZOS)
fg = Image.new("RGBA", (1024, 1024), (0, 0, 0, 0))
fg.paste(glyph_c, ((1024 - glyph_c.width) // 2, (1024 - glyph_c.height) // 2), glyph_c)
fg.save("assets/icon/app_icon_foreground.png")
print("adaptive foreground -> assets/icon/app_icon_foreground.png")

# ---------------------------------------------------------------------------
# 5. Play feature graphic: 1024x500, icon + name + tagline on gradient
# ---------------------------------------------------------------------------
FW, FH = 1024, 500
feat = bilinear_gradient(FW, FH, TL, TR, BL, BR)
draw = ImageDraw.Draw(feat)

# rounded app icon on the left (render large, round, downscale for smoothness)
icon_disp = 300
hi = master.resize((600, 600), Image.LANCZOS).convert("RGBA")
hi.putalpha(rounded_mask(600, 108))
icon_small = hi.resize((icon_disp, icon_disp), Image.LANCZOS)
icon_x = 70
icon_y = (FH - icon_disp) // 2
feat.paste(icon_small, (icon_x, icon_y), icon_small)

# text block to the right of the icon
bold = ImageFont.truetype("assets/fonts/NotoSans-Bold.ttf", 74)
reg = ImageFont.truetype("assets/fonts/NotoSans-Regular.ttf", 30)
tx = icon_x + icon_disp + 56
avail = FW - tx - 56                    # available text width to right margin


def wrap(text, font, max_w):
    words, lines, cur = text.split(), [], ""
    for wd in words:
        trial = (cur + " " + wd).strip()
        if draw.textlength(trial, font=font) <= max_w:
            cur = trial
        else:
            if cur:
                lines.append(cur)
            cur = wd
    if cur:
        lines.append(cur)
    return lines


title_lines = ["Congregation", "Scheduler"]
tagline_lines = wrap("Self-hosted scheduling for your congregation", reg, avail)

title_lh = 86
tag_lh = 42
gap = 22
block_h = len(title_lines) * title_lh + gap + len(tagline_lines) * tag_lh
ty = (FH - block_h) // 2
for ln in title_lines:
    draw.text((tx, ty), ln, font=bold, fill=(255, 255, 255))
    ty += title_lh
ty += gap
for ln in tagline_lines:
    draw.text((tx, ty), ln, font=reg, fill=(214, 231, 247))
    ty += tag_lh

feat.convert("RGB").save("store-listing/assets/play-feature-graphic-1024x500.png")
print("feature graphic -> store-listing/assets/play-feature-graphic-1024x500.png")
print("done")
