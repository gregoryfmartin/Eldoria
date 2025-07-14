###############################################################################
#
# ELDORIA LOADER
#
# WRITTEN BY GREGORY F MARTIN (NOT GARY)
#
# LOADS THE ELDORIA GAME (NOW REQUIRED SINCE THE GAME TAKES A WHILE TO LOAD THE
# SYMBOLS).
#
###############################################################################
Set-StrictMode -Version Latest

Clear-Host

Write-Host "`e[?25l" -NoNewLine
Write-Host "`e[38;2;15;82;186mLoading Eldoria`e[m"
Write-Host "`e[38;2;155;17;30m`e[5mPlease wait...`e[m"

.\EldoriaAlpha.ps1
