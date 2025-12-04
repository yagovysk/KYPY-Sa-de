Add-Type -AssemblyName System.Drawing

function New-StringFromCodes {
    param ([int[]] $codes)

    $builder = New-Object System.Text.StringBuilder
    foreach ($code in $codes) {
        $null = $builder.Append([char]$code)
    }

    $builder.ToString()
}

function New-RoundedRectPath {
    param (
        [System.Drawing.RectangleF] $rect,
        [double] $radius
    )

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diameter = $radius * 2
    $arc = New-Object System.Drawing.RectangleF $rect.X, $rect.Y, $diameter, $diameter

    $path.AddArc($arc, 180, 90)
    $arc.X = $rect.Right - $diameter
    $path.AddArc($arc, 270, 90)
    $arc.Y = $rect.Bottom - $diameter
    $path.AddArc($arc, 0, 90)
    $arc.X = $rect.X
    $path.AddArc($arc, 90, 90)
    $path.CloseFigure()
    return $path
}

$width = 1200
$height = 630
$bmp = New-Object System.Drawing.Bitmap $width, $height
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$backgroundRect = New-Object System.Drawing.Rectangle 0, 0, $width, $height
$backgroundBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $backgroundRect,
    [System.Drawing.Color]::FromArgb(0xFF, 0x13, 0x12, 0x16),
    [System.Drawing.Color]::FromArgb(0xFF, 0x21, 0x1E, 0x24),
    [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
)
$graphics.FillRectangle($backgroundBrush, $backgroundRect)
$backgroundBrush.Dispose()

$glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$glowPath.AddEllipse(60, -80, 1080, 620)
$glowBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath)
$glowBrush.CenterPoint = New-Object System.Drawing.PointF(600, 220)
$glowBrush.CenterColor = [System.Drawing.Color]::FromArgb(90, 213, 214, 137)
$glowBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 19, 18, 24))
$graphics.FillPath($glowBrush, $glowPath)
$glowBrush.Dispose()
$glowPath.Dispose()

$shadowRect = [System.Drawing.RectangleF]::new(170, 130, 860, 380)
$shadowPath = New-RoundedRectPath $shadowRect 44
$shadowMatrix = New-Object System.Drawing.Drawing2D.Matrix
$shadowMatrix.Translate(14, 20)
$shadowPath.Transform($shadowMatrix)
$shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(110, 12, 12, 16))
$graphics.FillPath($shadowBrush, $shadowPath)
$shadowBrush.Dispose()
$shadowMatrix.Dispose()
$shadowPath.Dispose()

$cardRect = [System.Drawing.RectangleF]::new(160, 120, 880, 400)
$cardPath = New-RoundedRectPath $cardRect 40
$cardBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $cardRect,
    [System.Drawing.Color]::FromArgb(242, 36, 34, 42),
    [System.Drawing.Color]::FromArgb(242, 24, 22, 31),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$graphics.FillPath($cardBrush, $cardPath)
$cardBrush.Dispose()
$cardPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(180, 213, 214, 137), 2)
$cardPen.Alignment = [System.Drawing.Drawing2D.PenAlignment]::Inset
$graphics.DrawPath($cardPen, $cardPath)
$cardPen.Dispose()

$accentGlowRect = [System.Drawing.RectangleF]::new(750, 100, 260, 260)
$accentGlowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70, 213, 214, 137))
$graphics.FillEllipse($accentGlowBrush, $accentGlowRect)
$accentGlowBrush.Dispose()

$accentStripeBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(90, 213, 214, 137))
$graphics.FillRectangle($accentStripeBrush, 650, 140, 2, 340)
$accentStripeBrush.Dispose()

$brandText = New-StringFromCodes @(75, 121, 112, 121, 32, 83, 97, 250, 100, 101)
$heroTitle = New-StringFromCodes @(67, 97, 114, 116, 227, 111, 32, 100, 105, 103, 105, 116, 97, 108, 32, 100, 97, 32, 99, 108, 237, 110, 105, 99, 97)
$heroSubtitle = New-StringFromCodes @(67, 111, 110, 101, 99, 116, 101, 45, 115, 101, 32, 99, 111, 109, 32, 97, 32, 101, 113, 117, 105, 112, 101, 32, 112, 111, 114, 32, 111, 110, 100, 101, 32, 118, 111, 99, 234, 32, 101, 115, 116, 105, 118, 101, 114)
$badgeText = New-StringFromCodes @(67, 97, 114, 116, 227, 111, 32, 105, 110, 116, 101, 114, 97, 116, 105, 118, 111)
$bulletTexts = @(
    "WhatsApp e telefone para agendamentos",
    "Site, Instagram e contatos atualizados",
    (New-StringFromCodes @(69, 110, 100, 101, 114, 101, 231, 111, 115, 32, 100, 101, 32, 66, 114, 97, 115, 237, 108, 105, 97, 32, 101, 32, 66, 97, 114, 114, 101, 105, 114, 97, 115)),
    (New-StringFromCodes @(83, 97, 108, 118, 101, 32, 97, 32, 99, 108, 237, 110, 105, 99, 97, 32, 110, 111, 32, 115, 101, 117, 32, 99, 101, 108, 117, 108, 97, 114))
)
$ctaText = "kypysaude.com.br/cartaovisita"
$footerText = "Compartilhe com a sua rede"

$brandFont = New-Object System.Drawing.Font("Segoe UI Semibold", 60, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$heroTitleFont = New-Object System.Drawing.Font("Segoe UI Semibold", 32, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$subtitleFont = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$bulletFont = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$badgeFont = New-Object System.Drawing.Font("Segoe UI Semibold", 15, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$ctaFont = New-Object System.Drawing.Font("Segoe UI Semibold", 24, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$footerFont = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$logoLetterFont = New-Object System.Drawing.Font("Segoe UI Semibold", 48, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)

$accentBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0xD5, 0xD6, 0x89))
$primaryTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xF2, 0xF6, 0xF6, 0xF6))
$mutedTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xCC, 0xF6, 0xF6, 0xF6))
$bulletAccentBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0xD5, 0xD6, 0x89))
$ctaTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0x23, 0x20, 0x24))
$logoLetterBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0x22, 0x1F, 0x24))
$footerBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xB3, 0xF6, 0xF6, 0xF6))

$leftFormat = New-Object System.Drawing.StringFormat
$leftFormat.Alignment = [System.Drawing.StringAlignment]::Near
$leftFormat.LineAlignment = [System.Drawing.StringAlignment]::Near
$leftFormat.Trimming = [System.Drawing.StringTrimming]::Word

$centerFormat = New-Object System.Drawing.StringFormat
$centerFormat.Alignment = [System.Drawing.StringAlignment]::Center
$centerFormat.LineAlignment = [System.Drawing.StringAlignment]::Center

$badgeFormat = New-Object System.Drawing.StringFormat
$badgeFormat.Alignment = [System.Drawing.StringAlignment]::Center
$badgeFormat.LineAlignment = [System.Drawing.StringAlignment]::Center

$badgeRect = [System.Drawing.RectangleF]::new(320, 138, 210, 34)
$badgePath = New-RoundedRectPath $badgeRect 17
$badgeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $badgeRect,
    [System.Drawing.Color]::FromArgb(70, 213, 214, 137),
    [System.Drawing.Color]::FromArgb(70, 63, 167, 150),
    [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
)
$graphics.FillPath($badgeBrush, $badgePath)
$badgePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(110, 213, 214, 137), 1.2)
$graphics.DrawPath($badgePen, $badgePath)
$graphics.DrawString($badgeText, $badgeFont, $accentBrush, $badgeRect, $badgeFormat)
$badgeBrush.Dispose()
$badgePen.Dispose()
$badgePath.Dispose()

$logoCircleRect = [System.Drawing.RectangleF]::new(190, 170, 110, 110)
$logoCirclePath = New-Object System.Drawing.Drawing2D.GraphicsPath
$logoCirclePath.AddEllipse($logoCircleRect)
$logoCircleBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($logoCirclePath)
$logoCenterX = [float]($logoCircleRect.X + ($logoCircleRect.Width / 2))
$logoCenterY = [float]($logoCircleRect.Y + ($logoCircleRect.Height / 2))
$logoCircleBrush.CenterPoint = New-Object System.Drawing.PointF($logoCenterX, $logoCenterY)
$logoCircleBrush.CenterColor = [System.Drawing.Color]::FromArgb(255, 213, 214, 137)
$logoCircleBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 63, 167, 150))
$graphics.FillEllipse($logoCircleBrush, $logoCircleRect)
$logoCircleBrush.Dispose()
$logoCirclePath.Dispose()
$graphics.DrawString("K", $logoLetterFont, $logoLetterBrush, $logoCircleRect.X + 30, $logoCircleRect.Y + 18)

$graphics.DrawString($brandText, $brandFont, $accentBrush, 320, 170)
$graphics.DrawString($heroTitle, $heroTitleFont, $primaryTextBrush, 320, 238)

$subtitleRect = [System.Drawing.RectangleF]::new(320, 284, 600, 72)
$graphics.DrawString($heroSubtitle, $subtitleFont, $mutedTextBrush, $subtitleRect, $leftFormat)

$bulletStartX = 320
$bulletStartY = 360
$bulletSpacing = 48

for ($i = 0; $i -lt $bulletTexts.Count; $i++) {
    $y = $bulletStartY + ($i * $bulletSpacing)
    $graphics.FillEllipse($bulletAccentBrush, $bulletStartX, $y, 16, 16)
    $graphics.DrawString($bulletTexts[$i], $bulletFont, $primaryTextBrush, $bulletStartX + 28, $y - 4)
}

$buttonRect = [System.Drawing.RectangleF]::new(320, 478, 540, 68)
$buttonPath = New-RoundedRectPath $buttonRect 22
$buttonBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $buttonRect,
    [System.Drawing.Color]::FromArgb(255, 213, 214, 137),
    [System.Drawing.Color]::FromArgb(255, 63, 167, 150),
    [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal
)
$graphics.FillPath($buttonBrush, $buttonPath)
$buttonBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(180, 33, 32, 38), 1.5)
$graphics.DrawPath($buttonBorder, $buttonPath)
$graphics.DrawString($ctaText, $ctaFont, $ctaTextBrush, $buttonRect, $centerFormat)
$buttonBrush.Dispose()
$buttonBorder.Dispose()
$buttonPath.Dispose()

$graphics.DrawString($footerText, $footerFont, $footerBrush, 320, 560)

$accentBrush.Dispose()
$primaryTextBrush.Dispose()
$mutedTextBrush.Dispose()
$bulletAccentBrush.Dispose()
$ctaTextBrush.Dispose()
$logoLetterBrush.Dispose()
$footerBrush.Dispose()

$brandFont.Dispose()
$heroTitleFont.Dispose()
$subtitleFont.Dispose()
$bulletFont.Dispose()
$badgeFont.Dispose()
$ctaFont.Dispose()
$footerFont.Dispose()
$logoLetterFont.Dispose()

$leftFormat.Dispose()
$centerFormat.Dispose()
$badgeFormat.Dispose()

$graphics.Dispose()
$outputPath = Join-Path (Split-Path -Parent $PSScriptRoot) "assets"
$outputFile = Join-Path $outputPath "kypy-card-preview.png"
$bmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
