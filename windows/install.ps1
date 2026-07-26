# Soal.help — Windows Installer (PowerShell)
# Set-ExecutionPolicy -Scope Process Bypass -Force
# iwr -useb https://raw.githubusercontent.com/soalhelp/Soal.Help/main/windows/install.ps1 | iex

param(
    [string]$ApiKey = $env:SOAL_API_KEY
)

$ErrorActionPreference = "Stop"

function Info($msg)  { Write-Host "[i] $msg" -ForegroundColor Cyan }
function Ok($msg)    { Write-Host "[✔] $msg" -ForegroundColor Green }
function Warn($msg)  { Write-Host "[!] $msg" -ForegroundColor Yellow }
function Fail($msg)  { Write-Host "[✗] $msg" -ForegroundColor Red; exit 1 }

# --- 1) aichat ---
$aichat = Get-Command aichat -ErrorAction SilentlyContinue
if (-not $aichat) {
    Info "aichat مش مثبّت. بحاول أثبّته..."
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    $scoop  = Get-Command scoop  -ErrorAction SilentlyContinue
    $cargo  = Get-Command cargo  -ErrorAction SilentlyContinue
    if ($winget)   { winget install --id sigoden.aichat --accept-source-agreements --accept-package-agreements | Out-Null }
    elseif ($scoop) { scoop install aichat | Out-Null }
    elseif ($cargo) { cargo install aichat | Out-Null }
    else {
        Warn "مفيش winget/scoop/cargo — هحمل الثنائي مباشرة."
        $tmp = Join-Path $env:TEMP "aichat.zip"
        $bin = Join-Path $env:LOCALAPPDATA "aichat"
        New-Item -Force -ItemType Directory $bin | Out-Null
        $api = "https://api.github.com/repos/sigoden/aichat/releases/latest"
        $target = if ([System.Environment]::Is64BitOperatingSystem) { "x86_64-pc-windows-msvc.zip" } else { "i686-pc-windows-msvc.zip" }
        $release = Invoke-RestMethod -Uri $api -UseBasicParsing
        $asset = $release.assets | Where-Object { $_.name -like "*$target" } | Select-Object -First 1
        if (-not $asset) { Fail "معرفتش ألاقي binary لـ Windows" }
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $tmp -UseBasicParsing
        Expand-Archive -Path $tmp -DestinationPath $bin -Force
        $env:PATH = "$bin;$env:PATH"
        [Environment]::SetEnvironmentVariable("PATH", "$bin;" + [Environment]::GetEnvironmentVariable("PATH", "User"), "User")
    }
    Ok "اتثبّت aichat"
} else {
    Ok "aichat مثبّت بالفعل"
}

# --- 2) API key ---
if (-not $ApiKey) {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  اطلع مفتاح API من: https://soal.help/app/keys" -ForegroundColor Cyan
    Write-Host "  المفتاح شكله: sk-ac6f999..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    for ($attempt = 1; $attempt -le 3; $attempt++) {
        $raw = Read-Host "الصق مفتاح API"
        $clean = $raw -replace '[\s\r\n\t]', ''
        if ($clean -match 'sk-[A-Fa-f0-9]{40,64}') {
            $ApiKey = $Matches[0]; Ok "المفتاح اتقرا صح ✔"; break
        }
        elseif ($clean -match 'sk-[A-Za-z0-9_-]{20,}') {
            $ApiKey = $Matches[0]; Ok "المفتاح اتقرا صح ✔"; break
        }
        Warn "معرفتش ألاقي مفتاح صحيح — لازم يبدأ بـ sk-. حاول تاني ($attempt/3)"
    }
}
if ($ApiKey -notmatch "^sk-") { Fail "مفتاح غير صحيح — لما تجيبه شغّل الـ installer تاني." }

# --- 3) Write config ---
$cfgDir = Join-Path $env:APPDATA "aichat"
New-Item -Force -ItemType Directory $cfgDir | Out-Null
$cfgFile = Join-Path $cfgDir "config.yaml"

$cfg = @"
model: soal:claude-haiku-4-5-20251001
temperature: 0.7
save: true

clients:
  - type: openai-compatible
    name: soal
    api_base: https://soal.help/api/v1
    api_key: $ApiKey
    models:
      - name: claude-haiku-4-5-20251001
        max_input_tokens: 200000
      - name: claude-sonnet-4-5-20250929
        max_input_tokens: 200000
      - name: claude-sonnet-4-6
        max_input_tokens: 1000000
      - name: claude-opus-4-7
        max_input_tokens: 1000000
      - name: claude-opus-4-8
        max_input_tokens: 1000000
      - name: gpt-5-mini
        max_input_tokens: 400000
      - name: gpt-5.5
        max_input_tokens: 1000000
      - name: gpt-5.4
        max_input_tokens: 1000000
      - name: gpt-4o
        max_input_tokens: 128000
      - name: gpt-4.1-mini
        max_input_tokens: 1047576
      - name: o3
        max_input_tokens: 200000
      - name: o4-mini
        max_input_tokens: 200000
      - name: gemini-2.5-pro
        max_input_tokens: 1048576
      - name: gemini-3.1-pro-preview
        max_input_tokens: 1048576
      - name: gemini-3.5-flash
        max_input_tokens: 1048576
      - name: gemini-2.5-flash
        max_input_tokens: 1048576
"@
Set-Content -Path $cfgFile -Value $cfg -Encoding UTF8
Ok "config.yaml → $cfgFile"

Write-Host ""
Ok "التثبيت اكتمل!"
Write-Host ""
Write-Host "جرّب دلوقتي (افتح PowerShell جديد الأول):" -ForegroundColor Cyan
Write-Host "  aichat 'hello!'"            -ForegroundColor Green
Write-Host "  aichat -m claude-opus-4-8"  -ForegroundColor Green
Write-Host "  aichat"                     -ForegroundColor Green
