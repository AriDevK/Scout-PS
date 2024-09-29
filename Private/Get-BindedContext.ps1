function Get-BindedContext {
    [OutputType([string])]
    param (
        [string] $content,
        [hashtable] $ctx,
        [bool] $escape = $true
    )

    if ($escape) {
        $ctx = Set-EscapeHtml $ctx
    }

    $ctx.GetEnumerator() | ForEach-Object {
        if ($_.Key -eq '$_') {
            continue;
        }

        $content = $content.Replace("$" + $_.Key, $_.Value)
    }

    return $content
}