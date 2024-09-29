function Remove-Comments {
    [OutputType([string])]
    param (
        [string] $text
    )

    $cleanText = $text -replace '\$#.*?#\$', ''
    $cleanText = $cleanText -replace '$#', ''
    $cleanText = $cleanText -replace '#$', ''
    return $cleanText
}