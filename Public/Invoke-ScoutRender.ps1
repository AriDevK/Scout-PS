function Invoke-ScoutRender {
    [OutputType([string])]
    param(
        [string] $content,
        [hashtable] $ctx,
        [string] $layout = $null
    )

    if ($content.EndsWith(".html")) {
        $content = (Get-Content -Path $content -Raw).Trim().Replace("`n", " ")
    }

    $content = Remove-Comments $content


    Find-PrintDirectives $content | ForEach-Object {
        $directive = $_.Value
        $directive = $directive.Replace(' ', '').Replace('$=', '${ echo $').Replace('=$', ';}$')
        $content = $content.Replace($_.Value, (Invoke-Directive $directive $ctx))
    }

    Find-Directives $content | ForEach-Object {
        $directive = $_.Value
        $content = $content.Replace($directive, (Invoke-Directive $directive $ctx))
    }

    $content = Get-BindedContext $content $ctx

    if ($layout -ne $null) {

        if ($layout.EndsWith(".html")) {
            $layout = (Get-Content -Path $layout -Raw).Trim().Replace("`n", " ")
        }

        $layout = Remove-Comments $layout
        $layoutCtx = $ctx.Clone()
        $layoutCtx['content'] = $content

        Find-PrintDirectives $layout | ForEach-Object {
            $directive = $_.Value
            $directive = $directive.Replace(' ', '').Replace('$=', '${ echo $').Replace('=$', ';}$')
            $layout = $layout.Replace($_.Value, (Invoke-Directive $directive $layoutCtx))
        }

        Find-Directives $layout | ForEach-Object {
            $directive = $_.Value
            $layout = $layout.Replace($directive, (Invoke-Directive $directive $layoutCtx))
        }

        $c = Get-BindedContext $layout $layoutCtx $false

        $content = $c
    }

    return $content
}

New-Alias -Name "scRender" -Value Invoke-ScoutRender
Export-ModuleMember -Function Invoke-ScoutRender -Alias scRender