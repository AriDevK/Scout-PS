function Find-PrintDirectives {
    # [OutputType([string])]
    param (
        [string] $text
    )
    
    return [regex]::Matches($text, '\$+?\=.*?\=\$')
}
