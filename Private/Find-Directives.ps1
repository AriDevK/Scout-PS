function Find-Directives {
    # [OutputType([MatchCollection])]
    param (
        [string] $text
    )
    
    return [regex]::Matches($text, '\$+?\{.*?\}\$')
}