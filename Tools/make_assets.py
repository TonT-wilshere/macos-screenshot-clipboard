#!/usr/bin/env python3
"""Draw original branding and a bilingual, clearly labelled workflow animation.

Only the maintainer needs Pillow. The shipped app has no Python dependency.
"""
from __future__ import annotations

import math
from functools import lru_cache
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "Assets"
FONT = "/Library/Fonts/Arial Unicode.ttf"
W, H = 960, 540
NAVY, BLUE, MINT, WHITE, MUTED = "#09172F", "#235DEA", "#7DF2C8", "#F6FAFF", "#B2C8E5"

@lru_cache(maxsize=64)
def font(size: int):
    return ImageFont.truetype(FONT, size)

def txt(d, x, y, value, size=18, fill=WHITE):
    d.text((x, y), value, font=font(size), fill=fill)

def center(d, x, y, value, size=18, fill=WHITE):
    face = font(size)
    box = d.textbbox((0, 0), value, font=face)
    d.text((x - (box[2] - box[0]) / 2, y - box[1]), value, font=face, fill=fill)

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

def render(frame):
    im = BG.copy()
    d = ImageDraw.Draw(im)
    # Full functionality is visible on the first frame, before the animation begins.
    txt(d, 36, 20, "SnapKeep", 25)
    txt(d, 190, 28, "截屏即贴", 17, MINT)
    rr(d, (731, 20, 925, 52), "#17355A", 16)
    center(d, 828, 27, "macOS · Free & open source", 12, MUTED)
    center(d, W / 2, 73, "Screenshot once. Save + copy.", 33)
    center(d, W / 2, 120, "截一次，保存和复制一起完成。", 23, MINT)

    # Left: an illustrated macOS desktop using only synthetic imagery.
    rr(d, (36, 176, 542, 451), "#041022", 20)
    rr(d, (30, 168, 536, 443), "#EDF3FC", 18)
    rr(d, (31, 169, 535, 202), "#DDE7F4", 16)
    for i, c in enumerate(("#FA6259", "#F5BF4F", "#5BCB7A")):
        d.ellipse((46 + i * 17, 181, 54 + i * 17, 189), fill=c)
    txt(d, 126, 176, "Your Mac / 你的 Mac", 13, "#476079")
    sample(d, (62, 220, 252, 174))
    txt(d, 338, 235, "Desktop / 桌面", 14, "#34506C")
    rr(d, (353, 272, 406, 312), "#5C9FE9", 7)
    rr(d, (353, 265, 380, 283), "#5C9FE9", 5)
    txt(d, 417, 278, "截屏", 18, "#274766")

    progress = min(1, max(0, (frame - 12) / 18))
    if 12 <= frame < 34:
        x2, y2 = 70 + int(232 * progress), 228 + int(154 * progress)
        d.rectangle((70, 228, x2, y2), outline="#265DEA", width=3)
        d.line((x2 - 8, y2, x2 + 8, y2), fill=NAVY, width=2)
        d.line((x2, y2 - 8, x2, y2 + 8), fill=NAVY, width=2)
    if frame >= 34:
        sample(d, (359, 330, 93, 61), small=True)
        txt(d, 353, 397, "Screenshot.png", 11, "#4F6782")
    rr(d, (63, 406, 282, 435), "#D4E1F5", 12)
    center(d, 172, 410, "⌘ ⇧ 4  →  capture / 截取", 14, "#284766")

    # Right: visible outcomes, ending with a paste preview.
    rr(d, (571, 168, 929, 443), "#102A49", 20, "#315279")
    step1 = frame >= 34
    step2 = frame >= 47
    step3 = frame >= 66
    for n, yy, label, active in [(1, 188, "File saved / 图片已保存", step1), (2, 226, "Clipboard ready / 剪贴板就绪", step2)]:
        d.ellipse((591, yy + 4, 613, yy + 26), fill=MINT if active else "#294460")
        if active:
            check(d, 595, yy + 8, NAVY, .7)
        else:
            txt(d, 598, yy + 4, str(n), 12, MUTED)
        txt(d, 626, yy + 2, label, 17, WHITE if active else MUTED)
    if step2:
        rr(d, (586, 272, 914, 312), "#DBFAEF", 12)
        txt(d, 600, 281, "✓ 已复制到剪贴板 · Copied", 15, "#076B57")
    if step3:
        sample(d, (592, 325, 117, 91), small=True)
        txt(d, 728, 338, "⌘ V", 27, MINT)
        txt(d, 728, 380, "Paste / 直接粘贴", 15, WHITE)
    else:
        txt(d, 606, 348, "No extra shortcut.", 19)
        txt(d, 606, 384, "快捷键照旧，少一步操作。", 17, MUTED)

    if frame < 12:
        caption = "Keep the file. Paste it anywhere. / 保留文件，也能直接粘贴"
    elif frame < 34:
        caption = "1  Capture with your usual shortcut / 使用熟悉的截屏快捷键"
    elif frame < 47:
        caption = "2  Saved automatically to Desktop/截屏 / 自动保存到桌面截屏文件夹"
    elif frame < 66:
        caption = "3  Image copied + a quiet banner / 自动复制图片并轻提示"
    else:
        caption = "4  Paste into a chat or bug report / 粘贴到聊天、笔记或问题反馈"
    center(d, W / 2, 468, caption, 17)
    center(d, W / 2, 503, "Local only · Zero runtime dependencies · Illustrated workflow / 演示示意", 12, MUTED)
    return im

def main():
    ASSETS.mkdir(exist_ok=True)
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
