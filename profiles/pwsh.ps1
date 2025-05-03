oh-my-posh init pwsh --config '~\AppData\Local\Programs\oh-my-posh\themes\m.minimal.omp.json' | Invoke-Expression
Set-Alias -Name v -Value neovide
Set-Alias -Name e -Value explorer
Set-Alias -Name pss -Value tasklist
$env:SHELL = "pwsh"

# ~/.config/powershell/Microsoft.PowerShell_profile.ps1
$env:CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

# winget install -e --id rsteube.Carapace
