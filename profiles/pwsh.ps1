oh-my-posh init pwsh --config '~\AppData\Local\Programs\oh-my-posh\themes\m.minimal.omp.json' | Invoke-Expression
Set-Alias -Name v -Value nvim
Set-Alias -Name e -Value explorer
Set-Alias -Name pss -Value tasklist
$env:SHELL = "pwsh"
$env:FZF_DEFAULT_OPTS = @"
--color=fg:#e5e5e5,hl:#95FB79
--color=fg+:#ffffff,bg+:#1E1F24,hl+:#95FB79
--color=info:#82AAFF,prompt:#82AAFF,pointer:#ffdb29
--color=marker:#D2A6FF,spinner:#FFEE99,header:#2e3339
--color=border:#1E1F24,label:#82AAFF,query:#FFFFFF
--color=disabled:#2e3339,preview-fg:#FFFFFF
--border=rounded
--height=40%
--layout=reverse
--info=inline
--margin=1
--padding=1
"@

# ~/.config/powershell/Microsoft.PowerShell_profile.ps1
$env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

function c {
  $startDir = Resolve-Path ~
  $dir = (& {
    fd --type d --hidden --exclude .git --exclude node_modules . $startDir 2>$null |
    fzf `
      --preview 'lsd --tree --color always --depth 2 {}' `
      --prompt 'Search dir: ' `
      --header 'Press Ctrl-R to refine search' `
      --height 40% --layout=reverse 2>$null
  }) 2>$null
  if ($dir) {
    Set-Location $dir
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
  }
}

Set-PSReadlineKeyHandler -Key 'Ctrl+o' -ScriptBlock {c}

. ~/.config/Powershell/completion/mcat.ps1
