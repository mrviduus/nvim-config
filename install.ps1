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
$packages = @(
    "Neovim.Neovim", "Git.Git", "BurntSushi.ripgrep.MSVC", "sharkdp.fd",
    "JesseDuffield.lazygit", "junegunn.fzf", "OpenJS.NodeJS.LTS",
    "zig.zig",                      # C compiler for treesitter parsers
    "DEVCOM.JetBrainsMonoNerdFont",
    "Microsoft.DotNet.SDK.10"
)
foreach ($p in $packages) {
    winget install --id $p -e --silent --accept-package-agreements --accept-source-agreements
    # -1978335189 = already installed; anything else non-zero is a real failure
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) { throw "winget failed on $p ($LASTEXITCODE)" }
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
nvim --headless "+Lazy! restore" +qa
Write-Host "(Messages about mason/treesitter installs being aborted are fine: they finish on first launch.)"

Say "Done"
Write-Host "Open a new terminal, then run: nvim"
Write-Host "Set the terminal font to 'JetBrainsMono Nerd Font' (Windows Terminal: Settings > Profiles > Defaults > Appearance)"
Write-Host "Language servers finish installing on the first launch; check with :Mason"
