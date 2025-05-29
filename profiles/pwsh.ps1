oh-my-posh init pwsh --config '~\AppData\Local\Programs\oh-my-posh\themes\m.minimal.omp.json' | Invoke-Expression
Set-Alias -Name v -Value nvim
Set-Alias -Name e -Value explorer
Set-Alias -Name pss -Value tasklist
$env:SHELL = "pwsh"
$env:FZF_DEFAULT_OPTS = @"
--color=bg+:#1e2029,bg:#15161B,spinner:#FFEE99,hl:#FFEE99 `
--color=fg:#A6ACCD,header:#FF7733,info:#D2A6FF,pointer:#FFEE99 `
--color=marker:#95FB79,fg+:#FFFFFF,prompt:#82AAFF,hl+:#95FB79 `
--color=border:#25282E `
--height 40% --border=rounded --reverse --margin=1 --padding=1
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
