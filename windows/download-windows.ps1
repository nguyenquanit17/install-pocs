# GamiQ - Yu-Gi-Oh! Power of Chaos mod: tai + giai nen tu dong (Windows 10+)
#
# Cach chay:
#   1) Double-click download-windows.bat (cung thu muc voi file nay)
#   2) Hoac mo PowerShell, dan 1 dong:
#        irm https://raw.githubusercontent.com/nguyenquanit17/install-pocs/master/windows/download-windows.ps1 | iex
#   3) Tuy chon:  .\download-windows.ps1 -Dest D:\GamiQ -Games 3,5   (-Games all = tai het, -Force = giai nen lai)
#
# Moi ban game -> 1 thu muc rieng trong <Dest>. Zip co mat khau gamiQ (05/06 ma hoa AES
# nen phai dung 7-Zip: may co san thi dung, khong co thi tu tai ban portable 7za.exe).
# Duong dan KHONG duoc co dau tieng Viet (game se man hinh den roi tu tat).

param(
    [string]$Dest = "",
    [string]$Games = "",
    [switch]$Force,
    [switch]$NoPause
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ZipPass = @('gamiQ', 'GamiQ')

# So | ten thu muc | Google Drive file id | dung luong zip (MB, de kiem cho trong)
$GameList = @(
    @{ No = 3; Name = '03 - 3 in 1 (Yugi + Kaiba + Joey)'; Id = '1Um-IlqCfpNjCbq_rsgoAakIWmkqIARub'; MB = 820;  Note = 'ban cho nguoi moi choi' },
    @{ No = 4; Name = '04 - Joey the Passion 2 (Zaza)';    Id = '1_YpVomAbkA6-csdLiFCJqTekN6UjeDoE'; MB = 649;  Note = '' },
    @{ No = 5; Name = '05 - Battle City Finals (Mortis)';  Id = '1ZM7A-3Jd_b8KMcbnt2odHJUQfautKkkP'; MB = 1512; Note = '' },
    @{ No = 6; Name = '06 - Atem the Destiny (Mortis)';    Id = '1x48mGxsxYh4Nf7skJVhDKyxuxv8Y5D-F'; MB = 478;  Note = '' },
    @{ No = 7; Name = '07 - Bakura the Dark Spirit';       Id = '1heRROGNieaemcvz42VnDME7rkDnXMY8r'; MB = 341;  Note = '' }
)

function Say($msg, $color = 'Gray') { Write-Host $msg -ForegroundColor $color }
function Test-Ascii($s) { return -not ($s -match '[^\x20-\x7E]') }

function Pause-Exit($code) {
    if (-not $NoPause) { Say ''; Read-Host 'Nhan Enter de dong' | Out-Null }
    exit $code
}

# ---------- thu muc dich ----------
function Resolve-Dest {
    if ($Dest) { return $Dest }
    $default = Join-Path $env:SystemDrive 'GamiQ'
    Say "Thu muc luu game (Enter = $default):" 'Cyan'
    $ans = (Read-Host '>').Trim().Trim('"')
    if ($ans) { return $ans }
    return $default
}

# ---------- tai file ----------
function Get-Url($id) { "https://drive.usercontent.google.com/download?id=$id&export=download&confirm=t" }

function Test-ZipHeader($path) {
    if (-not (Test-Path $path)) { return $false }
    $fs = [IO.File]::OpenRead($path)
    try { $b = New-Object byte[] 2; [void]$fs.Read($b, 0, 2) } finally { $fs.Close() }
    return ($b[0] -eq 0x50 -and $b[1] -eq 0x4B)   # "PK"
}

function Get-RemoteSize($url) {
    try {
        $req = [Net.HttpWebRequest]::Create($url)
        $req.AddRange(0, 0)
        $req.AllowAutoRedirect = $true
        $resp = $req.GetResponse()
        $cr = $resp.Headers['Content-Range']; $resp.Close()
        if ($cr -match '/(\d+)$') { return [int64]$Matches[1] }
    } catch { }
    return [int64]-1
}

function Download-File($url, $out, $label) {
    $curl = Join-Path $env:SystemRoot 'System32\curl.exe'
    $expected = Get-RemoteSize $url
    for ($try = 1; $try -le 5; $try++) {
        if (Test-Path $curl) {
            # -C - : tai tiep phan dang do neu lan truoc bi ngat
            & $curl -L --fail --retry 3 --retry-delay 5 -C - -o $out $url
        } else {
            Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
        }
        $have = if (Test-Path $out) { (Get-Item $out).Length } else { 0 }
        if ((Test-ZipHeader $out) -and ($expected -le 0 -or $have -eq $expected)) { return }
        if (-not (Test-ZipHeader $out)) { Remove-Item $out -Force -ErrorAction SilentlyContinue }
        Say "  Tai chua xong ($have / $expected byte), thu lai lan $($try + 1)..." 'Yellow'
        Start-Sleep -Seconds 5
    }
    throw "Tai that bai: $label"
}

# ---------- 7-Zip ----------
function Find-7z($toolDir) {
    $cands = @()
    foreach ($k in 'HKLM:\SOFTWARE\7-Zip', 'HKCU:\SOFTWARE\7-Zip', 'HKLM:\SOFTWARE\WOW6432Node\7-Zip') {
        try { $p = (Get-ItemProperty $k -ErrorAction Stop).Path; if ($p) { $cands += (Join-Path $p '7z.exe') } } catch { }
    }
    $cands += "$env:ProgramFiles\7-Zip\7z.exe", "${env:ProgramFiles(x86)}\7-Zip\7z.exe", (Join-Path $toolDir '7za.exe')
    foreach ($c in $cands) { if ($c -and (Test-Path $c)) { return $c } }
    $cmd = Get-Command 7z.exe -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}

function Get-7z($toolDir) {
    $exe = Find-7z $toolDir
    if ($exe) { Say "7-Zip: $exe"; return $exe }

    New-Item -ItemType Directory -Force -Path $toolDir | Out-Null
    $exe = Join-Path $toolDir '7za.exe'

    # 1) ban 7za.exe 25.01 x86 (chay ca Win 32/64-bit) de san trong repo install-pocs:
    #    cung cho voi script -> tai duoc script la tai duoc 7za. Kiem SHA256 cho chac.
    $repoSha = '26817725650583D99CA3E617A618DD75C0F71BD316B5761780B7361F5F824CAD'
    $local = if ($PSScriptRoot) { Join-Path $PSScriptRoot '7zip\7za.exe' } else { '' }
    try {
        if ($local -and (Test-Path $local)) {
            Copy-Item $local $exe -Force
        } else {
            Say 'May chua co 7-Zip -> tai 7za.exe (~0.8 MB)...' 'Cyan'
            Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/nguyenquanit17/install-pocs/master/windows/7zip/7za.exe' -OutFile $exe -UseBasicParsing
        }
        if ((Get-FileHash $exe -Algorithm SHA256).Hash -eq $repoSha) { Say "7-Zip: $exe"; return $exe }
        Say '  7za.exe tai ve bi sai noi dung -> thu nguon khac.' 'Yellow'
    } catch { Say "  Khong lay duoc 7za.exe tu GitHub: $($_.Exception.Message)" 'Yellow' }
    Remove-Item $exe -Force -ErrorAction SilentlyContinue

    # 2) du phong: tai goi extra chinh thuc cua 7-Zip roi lay 7za.exe ra
    Say 'Thu tai 7-Zip tu 7-zip.org / GitHub 7-Zip...' 'Cyan'
    $sources = @(
        @{ R = 'https://www.7-zip.org/a/7zr.exe'; X = 'https://www.7-zip.org/a/7z2501-extra.7z' },
        @{ R = 'https://github.com/ip7z/7zip/releases/download/24.09/7zr.exe'; X = 'https://github.com/ip7z/7zip/releases/download/24.09/7z2409-extra.7z' }
    )
    $zr = Join-Path $toolDir '7zr.exe'
    $extra = Join-Path $toolDir 'extra.7z'
    foreach ($s in $sources) {
        try {
            Invoke-WebRequest -Uri $s.R -OutFile $zr -UseBasicParsing
            Invoke-WebRequest -Uri $s.X -OutFile $extra -UseBasicParsing
            $sub = if ([Environment]::Is64BitOperatingSystem) { 'x64\7za.exe' } else { '7za.exe' }
            & $zr e $extra "-o$toolDir" $sub -y | Out-Null
            if (Test-Path (Join-Path $toolDir '7za.exe')) { break }
        } catch { Say "  Nguon $($s.R) loi: $($_.Exception.Message)" 'Yellow' }
    }
    Remove-Item $extra -Force -ErrorAction SilentlyContinue
    if (-not (Test-Path $exe)) { throw 'Khong tai duoc 7-Zip. Cai 7-Zip (https://www.7-zip.org) roi chay lai.' }
    return $exe
}

# ---------- giai nen 1 zip vao 1 thu muc rieng ----------
function Expand-Game($sevenZip, $zip, $target, $workDir) {
    $tmp = Join-Path $workDir ('_extract_' + [IO.Path]::GetFileNameWithoutExtension($zip))
    $ok = $false
    foreach ($pw in $ZipPass) {
        if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
        & $sevenZip x $zip "-p$pw" "-o$tmp" -y -bso0 -bsp1
        if ($LASTEXITCODE -eq 0) { $ok = $true; break }
        Say "  Mat khau '$pw' khong dung / zip loi (ma $LASTEXITCODE)." 'Yellow'
    }
    if (-not $ok) { throw "Giai nen that bai: $zip" }

    # zip co dung 1 thu muc goc -> doi ten thanh $target; khong thi dung $tmp lam $target
    $items = @(Get-ChildItem -LiteralPath $tmp -Force)
    $src = if ($items.Count -eq 1 -and $items[0].PSIsContainer) { $items[0].FullName } else { $tmp }
    if (Test-Path -LiteralPath $target) { Remove-Item -LiteralPath $target -Recurse -Force }
    Move-Item -LiteralPath $src -Destination $target
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    Get-ChildItem -LiteralPath $target -Recurse -File | Unblock-File -ErrorAction SilentlyContinue
}

# ================== MAIN ==================
Say '======================================' 'Cyan'
Say '  GAMIQ - YU-GI-OH! POC (Windows 10+)' 'Cyan'
Say '======================================' 'Cyan'

$Dest = Resolve-Dest
$Dest = [IO.Path]::GetFullPath($Dest)
if (-not (Test-Ascii $Dest)) {
    Say "Duong dan '$Dest' co dau / ky tu dac biet -> game se bi man hinh den." 'Red'
    Say 'Hay chon thu muc khong dau, vi du C:\GamiQ' 'Red'
    Pause-Exit 1
}
New-Item -ItemType Directory -Force -Path $Dest | Out-Null
$dlDir = Join-Path $Dest '_downloads'
$toolDir = Join-Path $Dest '_tools\7zip'
New-Item -ItemType Directory -Force -Path $dlDir | Out-Null

# chon game
Say ''
foreach ($g in $GameList) {
    $mark = if (Test-Path -LiteralPath (Join-Path $Dest $g.Name)) { '  [da co]' } else { '' }
    $note = if ($g.Note) { "  <- $($g.Note)" } else { '' }
    Say ("  {0}. {1}  ({2} MB){3}{4}" -f $g.No, $g.Name, $g.MB, $note, $mark)
}
if (-not $Games) {
    Say ''
    Say 'Chon so game can tai, cach nhau dau phay (vd: 3,5). Enter = tai het:' 'Cyan'
    $Games = (Read-Host '>').Trim()
}
if (-not $Games -or $Games -eq 'all') {
    $selected = $GameList
} else {
    $nums = $Games -split '[,; ]+' | Where-Object { $_ } | ForEach-Object { [int]$_ }
    $selected = @($GameList | Where-Object { $nums -contains $_.No })
}
if ($selected.Count -eq 0) { Say 'Khong chon game nao.' 'Yellow'; Pause-Exit 1 }

$sevenZip = Get-7z $toolDir
$drive = (Get-Item $Dest).PSDrive

$results = @()
$i = 0
foreach ($g in $selected) {
    $i++
    $target = Join-Path $Dest $g.Name
    Say ''
    Say "[$i/$($selected.Count)] $($g.Name)" 'Cyan'
    if ((Test-Path -LiteralPath $target) -and -not $Force) {
        Say '  Da co thu muc nay -> bo qua (chay voi -Force de tai lai).' 'Green'
        $results += "SKIP  $($g.Name)"; continue
    }
    try {
        $needMB = [int]($g.MB * 2.3)
        $freeMB = [int]((Get-PSDrive $drive.Name).Free / 1MB)
        if ($freeMB -lt $needMB) { throw "O dia $($drive.Name): con $freeMB MB, can khoang $needMB MB." }

        $zip = Join-Path $dlDir ("{0:D2}.zip" -f $g.No)
        Say '  Dang tai...'
        Download-File (Get-Url $g.Id) $zip $g.Name
        Say '  Dang giai nen...'
        Expand-Game $sevenZip $zip $target $dlDir
        Remove-Item $zip -Force
        Say "  OK -> $target" 'Green'
        $results += "OK    $($g.Name)"
    } catch {
        Say "  LOI: $($_.Exception.Message)" 'Red'
        $results += "FAIL  $($g.Name)  ($($_.Exception.Message))"
    }
}

if (-not (Get-ChildItem $dlDir -Force -ErrorAction SilentlyContinue)) { Remove-Item $dlDir -Force -ErrorAction SilentlyContinue }

Say ''
Say '============== KET QUA ==============' 'Cyan'
$results | ForEach-Object { $c = if ($_ -like 'FAIL*') { 'Red' } elseif ($_ -like 'OK*') { 'Green' } else { 'Gray' }; Say $_ $c }
Say "Thu muc game: $Dest" 'Cyan'
Say 'Loi tai giua chung: chay lai script, phan da tai se tai tiep.' 'Gray'
if (-not $NoPause) { try { Start-Process explorer.exe $Dest } catch { } }
$failed = @($results | Where-Object { $_ -like 'FAIL*' }).Count
Pause-Exit ([int]($failed -gt 0))
