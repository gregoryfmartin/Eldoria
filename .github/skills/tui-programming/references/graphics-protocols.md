# Sixel & Kitty Graphics Protocol

Terminal graphics protocols allow raster images to be rendered inline in a terminal emulator. Eldoria stores both **Sixel** and **Kitty Graphics Protocol (KGP)** variants of every profile image for cross-platform support. The **Sixel PowerShell Module** is the required tool for all image conversions — do not use external CLI tools (`img2sixel`, ImageMagick) directly.

> **Rule:** Every new graphics asset must ship with **both** a Sixel variant and a KGP variant. Terminal capability detection selects the correct variant at render time.

---

## Sixel Protocol

### What Is Sixel?

Sixel (SIX-pel) is a DEC bitmap graphics format transmitted as an escape sequence. Each sixel character encodes a 6-pixel-tall vertical strip. A full sixel image is self-contained: it carries palette data, raster dimensions, and pixel data in a single string.

### Sixel Escape Sequence Structure

```
\ePq
{parameter string}
"Pa;Pb;Pw;Ph    ← Raster attributes: aspect ratio + dimensions
#n;2;R;G;B      ← Palette entries (n = index, R/G/B = 0–100 percent)
{data rows}
\e\\            ← String Terminator (ST)
```

An example (abbreviated):
```
\eP0;1q"1;1;32;32#0;2;0;0;0#1;2;100;0;0~!31N\e\\
```

> Sixel strings are binary-safe but large. They are pre-encoded and stored as PowerShell string literals — **never generate them at runtime**. Use the **Sixel PowerShell Module** to perform conversions (see [Adding a New Image](#adding-a-new-image-sixel--kgp-pair) below).

### Eldoria's Sixel Storage

Pre-encoded sixel strings live in `Resources/Sixel/Profiles.ps1`, grouped into gender/race arrays:

```powershell
# Male profile images
[String[]]$Script:MaleImageData = @(
    $Script:ElfMaleImageDataA,
    $Script:ElfMaleImageDataB,
    $Script:ElfMaleImageDataC,
    $Script:HumanMaleImageDataA,
    $Script:HumanMaleImageDataB,
    $Script:HumanMaleImageDataC
)

# Female profile images
[String[]]$Script:FemaleImageData = @(
    $Script:ElfFemaleImageDataA,
    $Script:ElfFemaleImageDataB,
    $Script:ElfFemaleImageDataC,
    $Script:ElfFemaleImageDataD,
    $Script:ElfFemaleImageDataE,
    $Script:HumanFemaleImageDataA,
    $Script:HumanFemaleImageDataB,
    $Script:HumanFemaleImageDataC,
    $Script:HumanFemaleImageDataD,
    $Script:HumanFemaleImageDataE
)
```

### Sixel Rendering Pattern

Output is a coordinate positioning prefix concatenated with the raw sixel string:

```powershell
# Render the current profile image at the draw offset
Write-Host "$($this.DrawOffset.ToAnsiControlSequenceString())$($Script:MaleImageData[$this.ProfileImageProbe])"
```

The `DrawOffset` is an `[ATCoordinates]` instance that positions the cursor before the sixel output begins.

Note: Sixel images are **not** managed through the ATString layer — they are raw strings written directly. This is intentional: the sixel payload already includes its own escape sequence framing.

### Adding a New Image (Sixel + KGP Pair)

Every new image requires **both** a Sixel string and a KGP string. Use the **Sixel PowerShell Module** for all conversions.

1. **Prepare the source image** — resize to the desired terminal cell dimensions. A safe reference size is 8px × 16px per terminal cell (depends on emulator font size). Save as a standard PNG.

2. **Install / import the Sixel PowerShell Module** (if not already present):
   ```powershell
   Install-Module -Name Sixel -Scope CurrentUser
   Import-Module Sixel
   ```

3. **Convert to Sixel** using the module:
   ```powershell
   $SixelString = ConvertTo-Sixel -Path 'profile_elf_male_d.png' -Width 160 -Height 192
   ```

4. **Convert to KGP** using the module:
   ```powershell
   $KgpString = ConvertTo-KittyGraphics -Path 'profile_elf_male_d.png' -Width 160 -Height 192
   ```

5. **Add both variants to `Profiles.ps1`:**
   ```powershell
   # Sixel variant
   [String]$Script:ElfMaleImageDataD_Sixel = $SixelString

   # KGP variant
   [String]$Script:ElfMaleImageDataD_Kgp = $KgpString
   ```

6. **Add to both image arrays:**
   ```powershell
   [String[]]$Script:MaleImageData_Sixel = @(
       # ... existing entries ...
       $Script:ElfMaleImageDataD_Sixel
   )

   [String[]]$Script:MaleImageData_Kgp = @(
       # ... existing entries ...
       $Script:ElfMaleImageDataD_Kgp
   )
   ```

7. **Add a selection entry** in `PSProfileSelectWindow.ps1` so the new index is reachable in the profile carousel.

8. **Verify the render path** routes through terminal capability detection (see [Terminal Detection Pattern](#terminal-detection-pattern)) so the correct variant is chosen at runtime.

### Sixel Compatibility

| Terminal | Sixel Support |
|----------|-------------|
| Windows Terminal 1.21+ | ✅ |
| iTerm2 | ✅ |
| Kitty | ✅ |
| mlterm | ✅ |
| xterm (compiled with sixel) | ✅ |
| Alacritty | ❌ |
| GNOME Terminal | ❌ |
| macOS Terminal.app | ❌ |

> **Graceful fallback:** If a terminal does not support Sixel, the raw escape bytes are typically ignored or printed as garbage characters. Consider rendering an ASCII/ANSI art placeholder via the standard `ATString` path when Sixel is unavailable.

---

## Kitty Graphics Protocol

### What Is It?

The Kitty Graphics Protocol (KGP) is a modern alternative to Sixel designed by the Kitty terminal emulator. It supports:
- **Chunk transmission** — large images sent in multiple APC sequences
- **Placement IDs** — images can be positioned, moved, and deleted by ID
- **Pixel-perfect positioning** — subcharacter placement using Unicode placeholder characters
- **Animation frames** — multiple frames for animated images
- **Direct RGB/RGBA** — no palette limitations (unlike Sixel's typical 256-color cap)

### Protocol Structure

KGP uses APC (`\e_`) sequences:

```
\e_G{key=value,key=value,...};{base64-data}\e\\
```

Common keys:

| Key | Meaning |
|-----|---------|
| `a=T` | Action: transmit (send pixel data) |
| `a=p` | Action: put (display a previously transmitted image) |
| `a=d` | Action: delete |
| `f=32` | Format: 32-bit RGBA |
| `f=24` | Format: 24-bit RGB |
| `t=d` | Transmission: direct (inline base64) |
| `t=f` | Transmission: file path |
| `s=W` | Image width in pixels |
| `v=H` | Image height in pixels |
| `m=1` | More chunks follow |
| `m=0` | Last chunk |
| `i=N` | Image ID (integer) |

### Minimal KGP Output in PowerShell

```powershell
# Encode raw RGBA bytes as base64
$RgbaBytes   = [System.IO.File]::ReadAllBytes("sprite.raw")
$B64Chunk    = [Convert]::ToBase64String($RgbaBytes)

# Transmit in a single chunk
$KittySeq = "`e_Ga=T,f=32,s=32,v=32,m=0;$B64Chunk`e\\"
Write-Host $KittySeq

# If chunking is required (>4096 bytes per chunk):
$Chunks = [System.Linq.Enumerable]::Chunk($B64Chunk.ToCharArray(), 4096)
$Last   = $Chunks.Count - 1
For($i = 0; $i -LT $Chunks.Count; $i++) {
    $m   = If($i -EQ $Last) { 0 } Else { 1 }
    $Chunk = -join $Chunks[$i]
    Write-Host "`e_Ga=T,f=32,s=32,v=32,m=$m;$Chunk`e\\"
}
```

### KGP Compatibility

| Terminal | KGP Support |
|----------|------------|
| Kitty | ✅ (native) |
| WezTerm | ✅ |
| Ghostty | ✅ |
| iTerm2 | ❌ |
| Windows Terminal | ❌ |
| Alacritty | ❌ |
| xterm | ❌ |

---

## Choosing Between Sixel and KGP

| Factor | Sixel | Kitty GP |
|--------|-------|----------|
| Broadest terminal support | ✅ | ❌ |
| 24-bit color depth | Limited (palette) | ✅ (RGBA) |
| Large image chunking | Manual | Built-in |
| Frame animation | No | Yes |
| Already in Eldoria | ✅ | Not yet |

**Policy for Eldoria:** All new images must ship with **both** variants. The Sixel PowerShell Module produces both from the same PNG source. The terminal capability detection layer selects the output variant — consuming code never hard-codes a protocol choice.

---

## Terminal Detection Pattern

Before outputting a graphics protocol, detect terminal capabilities:

```powershell
# Check $TERM, $TERM_PROGRAM, and $KITTY_WINDOW_ID
Function Get-TerminalGraphicsCapability {
    If($Env:KITTY_WINDOW_ID) { Return 'KittyGP' }
    If($Env:TERM_PROGRAM -EQ 'iTerm.app') { Return 'Sixel' }
    If($Env:WT_SESSION) { Return 'Sixel' }   # Windows Terminal
    If($Env:TERM -Match 'xterm') { Return 'Sixel' }
    Return 'None'
}
```

Then branch rendering code:
```powershell
Switch(Get-TerminalGraphicsCapability) {
    'KittyGP' { Write-Host (Get-KGPString  $ImagePath) }
    'Sixel'   { Write-Host (Get-SixelString $ImagePath) }
    'None'    { Write-Host (Get-ASCIIFallback $ImagePath) }
}
```

---

## Quality Checklist

- [ ] **Both** a Sixel variant and a KGP variant created for every new image asset
- [ ] **Sixel PowerShell Module** (`ConvertTo-Sixel`, `ConvertTo-KittyGraphics`) used for all conversions — no external CLI tools
- [ ] Sixel and KGP strings stored as pre-encoded string literals in `Profiles.ps1` — never generated at runtime
- [ ] Parallel image arrays maintained (`$Script:*ImageData_Sixel` and `$Script:*ImageData_Kgp`)
- [ ] Sixel output positioned with `ATCoordinates` prefix before the raw sixel payload
- [ ] New image index accessible in profile selection window carousel
- [ ] KGP chunks ≤ 4096 base64 characters each; `m=1` on all but last
- [ ] Terminal capability detection gates protocol selection before image output — no hardcoded protocol in render code
- [ ] ASCII/ANSI art fallback provided for terminals that support neither Sixel nor KGP
