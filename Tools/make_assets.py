#!/usr/bin/env python3
"""Draw original branding and a bilingual, clearly labelled workflow animation.

Only the maintainer needs Pillow. The shipped app has no Python dependency.
"""
from __future__ import annotations

import argparse
import glob
from functools import lru_cache
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "Assets"
FONT = next(iter(glob.glob("/System/Library/AssetsV2/**/PingFang.ttc", recursive=True)), "/Library/Fonts/Arial Unicode.ttf")
W, H = 960, 540
NAVY, BLUE, MINT, WHITE, MUTED = "#09172F", "#235DEA", "#7DF2C8", "#F6FAFF", "#B2C8E5"

@lru_cache(maxsize=128)
def font(size: int, symbols=False):
    # PingFang has clearer Chinese text, but does not include the shortcut glyphs.
    path = "/Library/Fonts/Arial Unicode.ttf" if symbols else FONT
    return ImageFont.truetype(path, size, index=3 if "PingFang" in path else 0)

def face(value, size):
    return font(size, "⌘" in value or "⇧" in value)

def txt(d, x, y, value, size=18, fill=WHITE):
    d.text((x, y), value, font=face(value, size), fill=fill, anchor="lt")

def center(d, x, y, value, size=18, fill=WHITE):
    d.text((x, y), value, font=face(value, size), fill=fill, anchor="mt")

def rr(d, box, fill, radius=16, outline=None, width=1):
    d.rounded_rectangle(box, radius, fill=fill, outline=outline, width=width)

def check(d, x, y, color=MINT, scale=1):
    d.line([(x, y + 7 * scale), (x + 6 * scale, y + 13 * scale), (x + 19 * scale, y)], fill=color, width=max(2, int(3 * scale)))

def icon(size=1024):
    im = Image.new("RGBA", (1024, 1024))
    d = ImageDraw.Draw(im)
    rr(d, (48, 48, 976, 976), NAVY, 210)
    rr(d, (204, 225, 740, 700), BLUE, 72)
    rr(d, (332, 338, 830, 818), WHITE, 64)
    rr(d, (437, 293, 715, 401), "#D8E6FB", 32)
    for x, y, sx, sy in [(260, 280, 1, 1), (675, 280, -1, 1), (260, 625, 1, -1)]:
        d.line([(x, y + 64 * sy), (x, y), (x + 64 * sx, y)], fill=MINT, width=18)
    d.ellipse((422, 454, 748, 780), fill="#DDFBF1")
    check(d, 493, 572, color="#087E65", scale=8)
    return im.resize((size, size), Image.Resampling.LANCZOS)

def background():
    im = Image.new("RGB", (W, H), NAVY)
    d = ImageDraw.Draw(im)
    for y in range(H):
        f = y / H
        d.line((0, y, W, y), fill=(9, int(23 + 12 * f), int(47 + 22 * f)))
    d.ellipse((700, -240, 1180, 220), fill="#112E59")
    d.ellipse((-180, 390, 220, 790), fill="#0D3154")
    return im

BG = background()

def sample(d, box, small=False):
    x, y, w, h = box
    rr(d, (x, y, x + w, y + h), "#EAF1FF", 8)
    d.ellipse((x + w * .67, y + h * .12, x + w * .85, y + h * .42), fill="#F8CB6C")
    d.polygon([(x, y + h), (x + w * .32, y + h * .37), (x + w * .73, y + h), (x, y + h)], fill="#5D81EF")
    d.polygon([(x + w * .35, y + h), (x + w * .76, y + h * .47), (x + w, y + h), (x + w * .35, y + h)], fill="#28B99B")
    if not small:
        rr(d, (x + 12, y + 12, x + 130, y + 38), "#FFFFFF", 10)
        txt(d, x + 20, y + 15, "Demo project", 12, "#193252")

@lru_cache(maxsize=1)
def mac_screen():
    """One complete synthetic desktop, reused as the copied and pasted image."""
    im = Image.new("RGB", (480, 270), "#EAF1FF")
    d = ImageDraw.Draw(im)
    sample(d, (0, 0, 480, 270), small=True)
    d.rectangle((0, 0, 480, 22), fill="#D8E6FA")
    txt(d, 12, 5, "Finder     File     Edit     View", 12, "#284766")
    txt(d, 422, 5, "10:09", 12, "#284766")
    rr(d, (34, 53, 323, 210), "#FFFFFF", 10)
    rr(d, (35, 54, 322, 78), "#DCE5F1", 9)
    for i, c in enumerate(("#FA6259", "#F5BF4F", "#5BCB7A")):
        d.ellipse((46 + i * 16, 62, 53 + i * 16, 69), fill=c)
    txt(d, 51, 96, "My project", 20, "#193252")
    for row, length in enumerate((218, 178, 196, 130)):
        rr(d, (51, 130 + row * 16, 51 + length, 136 + row * 16), "#DEE8F7", 3)
    rr(d, (377, 65, 427, 100), "#5C9FE9", 6)
    rr(d, (377, 59, 401, 76), "#5C9FE9", 4)
    center(d, 403, 109, "截屏", 12, "#284766")
    rr(d, (139, 237, 341, 266), "#DDE7F4", 9)
    for i, color in enumerate((BLUE, "#27B99B", "#F8CB6C", "#A48BEF", "#52A6DA")):
        rr(d, (149 + i * 38, 243, 169 + i * 38, 261), color, 5)
    return im

def screen(im, box):
    x, y, w, h = box
    im.paste(mac_screen().resize((w, h), Image.Resampling.LANCZOS), (x, y))

def render(frame):
    im = BG.copy()
    d = ImageDraw.Draw(im)
    captured, copied, pasted = frame >= 25, frame >= 43, frame >= 65
    txt(d, 30, 22, "SnapKeep · 截屏即贴", 21)
    txt(d, 661, 28, "Mac / macOS 12+ · Free & open source", 13, MUTED)
    # Literal benefit and platform remain visible even before the GIF plays.
    center(d, W / 2, 69, "Mac 截图，截完直接粘贴。", 37)
    center(d, W / 2, 120, "Mac screenshot → automatically copied → paste", 22, MINT)

    for bounds, active in [((30, 165, 304, 443), frame >= 12), ((348, 165, 612, 443), copied), ((656, 165, 930, 443), pasted)]:
        rr(d, bounds, "#102A49", 20, MINT if active else "#315279", 2)
    for x in (325, 634):
        d.line((x - 10, 307, x + 10, 307), fill=MINT, width=3)
        d.line([(x + 3, 300), (x + 10, 307), (x + 3, 314)], fill=MINT, width=3)

    center(d, 167, 184, "1 · Mac 原生全屏截屏", 18)
    rr(d, (71, 217, 263, 255), BLUE if 12 <= frame < 25 else "#203E63", 11)
    center(d, 167, 223, "⌘ ⇧ 3", 27)
    screen(im, (46, 275, 242, 136))
    # A full-screen flash, never a region-selection rectangle or crosshair.
    if 22 <= frame <= 25:
        flash = Image.new("RGB", (242, 136), "white")
        original = im.crop((46, 275, 288, 411))
        im.paste(Image.blend(original, flash, .65), (46, 275))
    center(d, 167, 420, "Command + Shift + 3 · Full screen", 12, MUTED)

    center(d, 480, 184, "2 · 自动复制图片", 18)
    center(d, 480, 222, "SnapKeep · after saving", 14, MUTED)
    rr(d, (429, 271, 531, 360), "#E8F1FF", 13)
    rr(d, (452, 263, 508, 281), "#B7CDEA", 7)
    if copied:
        screen(im, (438, 289, 84, 47))
        rr(d, (366, 373, 594, 406), "#DDFBF1", 10)
        center(d, 480, 382, "已复制到剪贴板 · Copied", 14, "#087E65")
    else:
        center(d, 480, 309, "IMAGE", 16, "#476079")
        center(d, 480, 382, "保存后，自动复制图片本身", 14, MUTED)
    center(d, 480, 420, "No opening files. No manual copy.", 12, MUTED)

    center(d, 793, 184, "3 · 粘贴到聊天或文档", 18)
    rr(d, (734, 217, 852, 255), BLUE if 62 <= frame < 72 else "#203E63", 11)
    center(d, 793, 223, "⌘ V", 27)
    rr(d, (674, 272, 912, 411), "#E8F1FF", 12)
    txt(d, 688, 283, "Chat / 聊天", 12, "#476079")
    if pasted:
        screen(im, (704, 300, 192, 108))
    else:
        center(d, 793, 337, "Paste here / 粘贴到这里", 14, "#6B82A0")
    center(d, 793, 420, "Command + V · Paste the image", 12, MUTED)

    if frame < 12:
        caption = "苹果负责截屏，SnapKeep 负责自动复制。"
    elif frame < 25:
        caption = "按 ⌘⇧3：使用 Mac 系统全屏截屏，不用框选。"
    elif not copied:
        caption = "系统先保存截图文件，再触发图片复制。"
    elif not pasted:
        caption = "图片已自动复制到剪贴板，不打开查看器。"
    else:
        caption = "按 ⌘V 粘贴图片；原图仍保留在 桌面/截屏。"
    center(d, W / 2, 467, caption, 19)
    center(d, W / 2, 507, "File kept in Desktop/截屏 · Copy starts after saving · Illustrated workflow / 流程示意，非录屏", 12, MUTED)
    return im

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--demo-only", action="store_true", help="Keep existing app icons; regenerate only the workflow assets")
    args = parser.parse_args()
    ASSETS.mkdir(exist_ok=True)
    if not args.demo_only:
        large_icon = icon()
        large_icon.save(ASSETS / "AppIcon.png")
        large_icon.save(ASSETS / "AppIcon.icns", sizes=[(16,16), (32,32), (64,64), (128,128), (256,256), (512,512), (1024,1024)])
    frames = [render(i) for i in range(100)]
    atlas = Image.new("RGB", (240 * 10, 135))
    for i in range(10):
        atlas.paste(frames[i * 10].resize((240,135)), (i * 240,0))
    palette = atlas.quantize(colors=128, method=Image.Quantize.MEDIANCUT)
    quantized = [f.quantize(palette=palette, dither=Image.Dither.NONE) for f in frames]
    quantized[0].save(ASSETS / "demo.gif", save_all=True, append_images=quantized[1:], duration=100, loop=0, optimize=True, disposal=2)
    frames[82].save(ASSETS / "demo-poster.png")
    social = Image.new("RGB", (1280,640), NAVY)
    social.paste(frames[82].resize((1120,630)), (80,5))
    social.save(ASSETS / "social-preview.png")
    print(f"Demo: {ASSETS / 'demo.gif'} ({(ASSETS / 'demo.gif').stat().st_size / 1024:.0f} KiB)")

if __name__ == "__main__":
    main()
