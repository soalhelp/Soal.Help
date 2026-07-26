# Soal.help — Codex CLI Installer for Windows (PowerShell)
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

# --- 1) Requirements ---
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Fail @"
Node.js مش موجود. ثبّته الأول:
   winget install OpenJS.NodeJS.LTS
أو نزّله من: https://nodejs.org
"@
}
Info "Node.js: $((node --version).Trim())"

# --- 2) Codex CLI ---
$codex = Get-Command codex -ErrorAction SilentlyContinue
if ($codex) {
    Ok "Codex مثبّت بالفعل"
} else {
    Info "بأثبّت @openai/codex (ممكن ياخد دقيقة)..."
    npm install -g @openai/codex 2>&1 | Out-Null
    if (-not (Get-Command codex -ErrorAction SilentlyContinue)) {
        Fail "فشل تثبيت codex"
    }
    Ok "اتثبّت Codex"
}

# --- 3) Config dir ---
$codexDir = Join-Path $env:USERPROFILE ".codex"
New-Item -Force -ItemType Directory $codexDir | Out-Null

# --- 4) API key ---
$envFile = Join-Path $codexDir ".env"
$existing = ""
if (Test-Path $envFile) {
    $match = Select-String -Path $envFile -Pattern 'sk-[A-Za-z0-9_-]{20,}' -AllMatches | Select-Object -First 1
    if ($match) { $existing = $match.Matches[0].Value }
}

if ($existing) {
    Ok "المفتاح موجود بالفعل ($($existing.Substring(0,8))...)"
    $ApiKey = $existing
} elseif (-not $ApiKey) {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  اطلع مفتاح API من: https://soal.help/app/keys" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
    for ($attempt = 1; $attempt -le 3; $attempt++) {
        $raw = Read-Host "الصق مفتاح API"
        $clean = $raw -replace '[\s\r\n\t]', ''
        if ($clean -match 'sk-[A-Za-z0-9_-]{20,}') {
            $ApiKey = $Matches[0]
            Ok "المفتاح اتقرا صح ✔"
            break
        }
        Warn "مفتاح غير صحيح ($attempt/3)"
    }
    if ($ApiKey -notmatch "^sk-") { Fail "مفتاح غير صحيح" }
}

if (-not $existing) {
    Set-Content -Path $envFile -Value "SOAL_API_KEY=$ApiKey" -Encoding UTF8
}
[Environment]::SetEnvironmentVariable("SOAL_API_KEY", $ApiKey, "User")
$env:SOAL_API_KEY = $ApiKey

# --- 5) Fetch config.toml + profiles + catalog ---
$repo = "https://raw.githubusercontent.com/soalhelp/Soal.Help/main/termux"

function Fetch($target, $remote) {
    try {
        Invoke-WebRequest -Uri "$repo/$remote" -OutFile $target -UseBasicParsing
    } catch {
        Fail "فشل تحميل: $remote"
    }
}

$configFile = Join-Path $codexDir "config.toml"
if (Test-Path $configFile) {
    Copy-Item $configFile "$configFile.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Warn "الـ config القديم اتنسخ backup"
}

Fetch $configFile "config.toml"

# Adjust Termux-specific trusted-project path to Windows home
$homeEscaped = ($env:USERPROFILE -replace '\\', '/')
(Get-Content $configFile) -replace '/data/data/com\.termux/files/home', $homeEscaped |
    Set-Content $configFile -Encoding UTF8

Fetch (Join-Path $codexDir "model_catalog.json") "model_catalog.json"
if (-not (Select-String -Path $configFile -Pattern 'model_catalog_json' -Quiet)) {
    $catalogPath = ($env:USERPROFILE + '\.codex\model_catalog.json') -replace '\\', '/'
    Add-Content $configFile "`nmodel_catalog_json = `"$catalogPath`""
}

$profiles = @(
    'claude-haiku','claude-sonnet','claude-sonnet-46','claude-opus','claude-opus-47','claude-fable',
    'gpt-mini','gpt5','gpt54','gpt-4o','gpt41-mini','o3','o4-mini',
    'gemini-pro','gemini-25-pro','gemini-flash','gemini-flash-3','gemini-25-flash'
)
foreach ($p in $profiles) {
    Fetch (Join-Path $codexDir "$p.config.toml") "profiles/$p.config.toml"
}
Ok "الإعدادات + $($profiles.Count) profile → $codexDir"

Write-Host ""
Ok "التثبيت اكتمل!"
Write-Host ""
Write-Host "جرّب دلوقتي (افتح PowerShell جديد الأول):" -ForegroundColor Cyan
Write-Host "  codex"                                    -ForegroundColor Green
Write-Host "  codex --profile claude-sonnet-46"         -ForegroundColor Green
Write-Host "  codex --profile gpt5"                     -ForegroundColor Green
Write-Host ""
Write-Host "الرصيد: https://soal.help/app/dashboard"    -ForegroundColor Cyan
