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

$sampleDict = @{
    'wee' = {Write-Host 'Wee function called'};
    'oof' = {Write-Host 'Oof function called'};
}

# $sampleDict['Wee'] = {Write-Host 'Wee function'}
# $sampleDict['Oof'] = {Write-Host 'Oof function'}

foreach($a in $sampleDict.GetEnumerator()) {
    Invoke-Command $a.Value
}

$found    = $sampleDict.GetEnumerator() | Where-Object {$_.Name -IEQ 'oof'}
$notFound = $sampleDict.GetEnumerator() | Where-Object {$_.Name -IEQ 'wee'}

If($null -EQ $notFound) {
    Write-Error -Message 'Failed to find key in dictionary'
} Else {
    #$sampleDict[$notFound]
    Invoke-Command $notFound.Value
}

$sampleList = New-Object System.Collections.Generic.List[String]
$sampleList.Add('Get rekt') | Out-Null
$sampleList.Add('Get pumpd') | Out-Null
$sampleList.Add('Git gud') | Out-Null

Try {
    $sampleList.GetRange(0, 10)
} Catch {
    $sampleList.GetRange(0, $sampleList.Count)
}
