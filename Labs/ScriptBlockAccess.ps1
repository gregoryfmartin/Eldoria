[String]$a1  = '|'
[Int]    $b1 = 10
$c1 = $(Invoke-Command -ScriptBlock {
    [String]$a2 = ''
    For($b = 0; $b -LE $b1; $b += 1) {
        $a2 += "$a1 "
    }
    
    $a2
})

$c1.gettype()

# Write-Host -Message $(Invoke-Command -ScriptBlock {
#     [String]$a2 = ''
#     For($b = 0; $b -LE $b1; $b += 1) {
#         $a2 += "$a1 "
#     }
    
#     $a2
# })