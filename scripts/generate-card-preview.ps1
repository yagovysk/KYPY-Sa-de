Add-Type -AssemblyName System.Drawing

$width = 1200
$height = 630
$bmp = New-Object System.Drawing.Bitmap $width, $height
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

$backgroundRect = New-Object System.Drawing.Rectangle 0, 0, $width, $height
$backgroundBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    $backgroundRect,
    [System.Drawing.Color]::FromArgb(0xFF, 0x17, 0x15, 0x16),
    [System.Drawing.Color]::FromArgb(0xFF, 0x24, 0x21, 0x22),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$graphics.FillRectangle($backgroundBrush, $backgroundRect)
$backgroundBrush.Dispose()

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

$cardRect = [System.Drawing.RectangleF]::new(200, 90, 800, 450)
$cardPath = New-RoundedRectPath $cardRect 45
$cardBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xE8, 0x21, 0x1E, 0x1F))
$graphics.FillPath($cardBrush, $cardPath)
$cardBrush.Dispose()
$cardPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0xAA, 0xD5, 0xD6, 0x89), 4)
$graphics.DrawPath($cardPen, $cardPath)
$cardPen.Dispose()

$innerRect = [System.Drawing.RectangleF]::new(220, 110, 760, 410)
$innerPath = New-RoundedRectPath $innerRect 35
$innerPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0x40, 0xD5, 0xD6, 0x89), 2)
$graphics.DrawPath($innerPen, $innerPath)
$innerPen.Dispose()

$titleFont = New-Object System.Drawing.Font("Segoe UI Semibold", 48, [System.Drawing.FontStyle]::Bold)
$subtitleFont = New-Object System.Drawing.Font("Segoe UI", 26, [System.Drawing.FontStyle]::Regular)
$bulletFont = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Regular)
$siteFont = New-Object System.Drawing.Font("Segoe UI Semibold", 26, [System.Drawing.FontStyle]::Regular)
$logoFont = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
$logoSubFont = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Regular)

$accentBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0xD5, 0xD6, 0x89))
$textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xCC, 0xF5, 0xF5, 0xF5))
$bulletBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0xCB, 0xB6, 0x8F))
$buttonBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0x40, 0x3F, 0xA7, 0x96))
$buttonPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0x60, 0xD5, 0xD6, 0x89), 2)
$buttonTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0xF5, 0xF5, 0xF5))
$logoBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(0xFF, 0x24, 0x21, 0x22))
$logoPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0x80, 0xD5, 0xD6, 0x89), 2)

$graphics.DrawString("Kypy Saúde", $titleFont, $accentBrush, 280, 150)
$graphics.DrawString("Cartão digital com acesso rápido aos canais de atendimento", $subtitleFont, $textBrush, 280, 210)
$graphics.DrawString("• WhatsApp e telefone para agendamentos", $bulletFont, $bulletBrush, 280, 270)
$graphics.DrawString("• Links diretos para site e Instagram", $bulletFont, $bulletBrush, 280, 310)
$graphics.DrawString("• Endereços de Brasília e Barreiras", $bulletFont, $bulletBrush, 280, 350)
$graphics.DrawString("• Salve o contato da clínica em um toque", $bulletFont, $bulletBrush, 280, 390)

$buttonRect = [System.Drawing.RectangleF]::new(300, 435, 540, 80)
$buttonPath = New-RoundedRectPath $buttonRect 22
$graphics.FillPath($buttonBrush, $buttonPath)
$graphics.DrawPath($buttonPen, $buttonPath)
$graphics.DrawString("kypysaude.com.br/cartaovisita", $siteFont, $buttonTextBrush, 330, 460)

$logoRect = [System.Drawing.RectangleF]::new(220, 140, 90, 90)
$logoPath = New-RoundedRectPath $logoRect 18
$graphics.FillPath($logoBrush, $logoPath)
$graphics.DrawPath($logoPen, $logoPath)
$graphics.DrawString("K", $logoFont, $accentBrush, 240, 158)
$graphics.DrawString("Saúde", $logoSubFont, $buttonTextBrush, 228, 202)

$accentBrush.Dispose()
$textBrush.Dispose()
$bulletBrush.Dispose()
$buttonBrush.Dispose()
$buttonPen.Dispose()
$buttonTextBrush.Dispose()
$logoBrush.Dispose()
$logoPen.Dispose()
$titleFont.Dispose()
$subtitleFont.Dispose()
$bulletFont.Dispose()
$siteFont.Dispose()
$logoFont.Dispose()
$logoSubFont.Dispose()

$graphics.Dispose()
$outputPath = Join-Path (Split-Path -Parent $PSScriptRoot) "assets"
$outputFile = Join-Path $outputPath "kypy-card-preview.png"
$bmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
