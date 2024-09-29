function Invoke-Directive {
    param (
        [string] $directive,
        [hashtable] $ctx
    )

    $rawDirective = Get-BindedContext $directive $ctx
    $directiveCommand = $rawDirective.Substring(1, $rawDirective.Length - 2)
    return (Invoke-Expression -Command ("($directiveCommand).invoke()"))
}