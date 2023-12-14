$rui = $(Get-Host).UI.RawUI

# Attempt to set the window title
# This works under Windows and works under Mac and Linux
$rui.WindowTitle = 'Greg Window'

# Print the window size to the console
# This works under Windows
Write-Host "Current window size is $($rui.WindowSize.Width)x$($rui.WindowSize.Height)"

# Attempt to set the window size
# This didn't work under Mac or Linux
# This doesn't do what I thought it would. It appears to create a virtual buffer window inside a larger window, but isn't subject to scrolling? It's strange.
# $a = $rui.WindowSize
# $a.Width = 80
# $a.Height = 24
# $rui.Set_WindowSize($a)
# Write-Host "Current window size is $($rui.WindowSize.Width)x$($rui.WindowSize.Height)"

# Set the window position
$b = $rui.WindowPosition
$b.X = 1
$b.Y = 1
$rui.Set_WindowPosition($([System.Management.Automation.Host.Coordinates]::new(10, 1)))