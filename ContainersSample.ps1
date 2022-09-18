$sampleStack = New-Object System.Collections.Generic.Stack[String]
$sampleStack.Push("You've entered a new territory")
$sampleStack.Push("This is definitely foreign land to you")
$sampleStack.Push("What do you want to do?")

foreach($a in $sampleStack) {
    Write-Host $a
}

Write-Host ' '

$sampleQueue = New-Object System.Collections.Generic.Queue[String]
$sampleQueue.Enqueue("You've entered a new territory")
$sampleQueue.Enqueue("This is definitely foreign land to you")
$sampleQueue.Enqueue("What do you want to do?")

foreach($a in $sampleQueue) {
    Write-Host $a
}

