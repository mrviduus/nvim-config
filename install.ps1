# Bootstrap this Neovim config on a clean Windows 10/11 machine (PowerShell):
#   irm https://raw.githubusercontent.com/mrviduus/nvim-config/main/install.ps1 | iex
# Safe to re-run: installed tools are skipped, an existing clone is pulled.
$ErrorActionPreference = "Stop"

$Repo = "https://github.com/mrviduus/nvim-config.git"
$Dest = Join-Path $env:LOCALAPPDATA "nvim"
$Data = Join-Path $env:LOCALAPPDATA "nvim-data"

function Say($msg) { Write-Host "`n==> $msg" -ForegroundColor Blue }
function Refresh-Path {
    $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [Environment]::GetEnvironmentVariable("Path", "User")
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found. Install 'App Installer' from the Microsoft Store, then re-run."
}

Say "Tools"
# Each package maps to a check for "already present". Tools installed outside winget (a per-user
# Git, Node from nodejs.org, ...) make `winget install` fail, so present tools are skipped.
$fontDirs = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts", "$env:WINDIR\Fonts"
$packages = [ordered]@{
    "Neovim.Neovim"                = { Get-Command nvim -ErrorAction SilentlyContinue }
    "Git.Git"                      = { Get-Command git -ErrorAction SilentlyContinue }
    "BurntSushi.ripgrep.MSVC"      = { Get-Command rg -ErrorAction SilentlyContinue }
    "sharkdp.fd"                   = { Get-Command fd -ErrorAction SilentlyContinue }
    "JesseDuffield.lazygit"        = { Get-Command lazygit -ErrorAction SilentlyContinue }
    "junegunn.fzf"                 = { Get-Command fzf -ErrorAction SilentlyContinue }
    "OpenJS.NodeJS.LTS"            = { Get-Command node -ErrorAction SilentlyContinue }
    "zig.zig"                      = { Get-Command zig -ErrorAction SilentlyContinue }  # C compiler for treesitter parsers
    "DEVCOM.JetBrainsMonoNerdFont" = { Get-ChildItem $fontDirs -Filter "JetBrainsMonoNerdFont*" -ErrorAction SilentlyContinue }
    "Microsoft.DotNet.SDK.10"      = { (Get-Command dotnet -ErrorAction SilentlyContinue) -and (dotnet --list-sdks | Select-String '^10\.') }
}
$failed = @()
foreach ($p in $packages.Keys) {
    if (& $packages[$p]) { Write-Host "$p already present, skipping"; continue }
    winget install --id $p -e --silent --accept-package-agreements --accept-source-agreements
    # -1978335189 = no newer version, -1978335135 = already installed; anything else is a real failure
    if ($LASTEXITCODE -notin 0, -1978335189, -1978335135) {
        Write-Warning "winget failed on $p ($LASTEXITCODE), continuing"
        $failed += $p
    }
}
Refresh-Path
npm install -g tree-sitter-cli

Say "Config"
$origin = if (Test-Path "$Dest\.git") { git -C $Dest remote get-url origin } else { "" }
if ($origin -like "*nvim-config*") {
    git -C $Dest pull --ff-only
} else {
    # Someone else's config (or plugin state from it) would clash: move it aside, never delete.
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    foreach ($d in @($Dest, $Data)) {
        if (Test-Path $d) {
            Move-Item $d "$d.bak.$stamp"
            Write-Host "moved $d -> $d.bak.$stamp"
        }
    }
    git clone $Repo $Dest
}

Say "Plugins (first run takes a minute)"
# On a fresh clone lazy.nvim installs missing plugins at startup at their latest commit and rewrites
# lazy-lock.json before `restore` runs, so restore has nothing to do. Put the lockfile back and restore again.
nvim --headless "+Lazy! restore" +qa
git -C $Dest checkout -- lazy-lock.json
nvim --headless "+Lazy! restore" +qa
Write-Host "(Messages about mason/treesitter installs being aborted are fine: they finish on first launch.)"

Say "Done"
if ($failed) { Write-Warning "Not installed: $($failed -join ', '). Install them manually or re-run this script." }
Write-Host "Open a new terminal, then run: nvim"
Write-Host "Set the terminal font to 'JetBrainsMono Nerd Font' (Windows Terminal: Settings > Profiles > Defaults > Appearance)"
Write-Host "Language servers finish installing on the first launch; check with :Mason"
