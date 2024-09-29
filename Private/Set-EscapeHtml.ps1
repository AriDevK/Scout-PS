function Set-EscapeHtml {
    [OutputType([hashtable])]
    param (
        [hashtable] $ctx
    )

    $cleanCtx = @{}

    $ctx.GetEnumerator() | ForEach-Object {
        $cleanCtx[$_.Key] = [HttpUtility]::HtmlEncode($_.Value)
    }

    return $cleanCtx
}

Export-ModuleMember -Function Invoke-ScoutRender