# Scout PS - Template engine for PowerShell

Scout PS is a template engine for PowerShell. It allows you to dynamic text generation based on text or HTML templates.



<br>

## Features
- Parameterized templates
- Parameter escaping
- Layout/Master templates
- Template Directives
- All PowerSehll features available in templates (loops, conditions, cmdlets, etc.)


<br>

## Installation
```powershell
Install-Module -Name Scout
```


<br>

## Usage

Scout exposes a single function `Invoke-ScoutRender` that takes a template file, a context object, and an optional layout file. The function returns the rendered template as a string.

Method signature:
```powershell
Invoke-ScoutRender [[-content] <string>] [[-ctx] <hashtable>] [[-layout] <string>]
```



<br>


## Template Directives Syntax

- `$varName`: Interpolate the variable value at the template content. **Only works with primitive context values hash tables, objects or arrays might be acceded using other directives.**

- `${ ... }$`: Code block directive. Allows to execute PowerShell code inside the template. The code block must be enclosed by `${` and `}$`

- `$= ... =$`: Print directive. Allows to print the result of a PowerShell expression inside the template. The expression must be enclosed by `$=` and `=$` and should not contain the $ character

- `$# ... #$`: Comment directive. Allows to add comments inside the template. The comment must be enclosed by `$#` and `#$`


<br>


## Example

The main use case is to render a template with a context object; the context object is a hashtable that contains the variables that will be interpolated in the template.
```powershell main.ps1
Import-Module Scout -Force

$context = @{
    "title" = "Home";
    "user" = "Ari"; 
    "wHtml" = "<h1>hello world >:3</h1>"; 
    "users" = @{
        "data" = @(
            @{"name" = "Ari"; "age"=23},
            @{"name" = "Ayken"; "age"=22}
        )
    }
}

$page = "$(Get-Location)/index.html"
$layout = "$(Get-Location)/layout.html"

$result = Invoke-ScoutRender $page $context $layout
```



```html index.html
<section id="greetings">
    $# this variable is interpolated from the context object #$
    $# RESULT: Hello Ari #$
    Hello $user 

    $# this variable is not defined at context object so the engine ignore it #$
    $# RESULT: Hello $asd #$
    Hello $asd 
<section/>

<section id="html-excape">
  $# this variable has been escaped to be safety binded #$
  $# RESULT: <h1>hello world >:3</h1> #$
  $wHtml  
<section/>

<section id="print-directive">
  $# accessing to second user's name #$
  $# RESULT: Ayken #$
  $= ctx.users.data[1].name =$
<section/>

<section id="code-block">
  ${
      <# conditionals #>
      if ('$user' -eq 'admin') {
          echo `<h1>Admin</h1>`
      } else {
          echo `<h1>Normal User</h1>`
      }
  

      <# pipes and loops #>
      $ctx.t.data | ForEach-Object { 
          echo ($_.name + "<br>") 
      };

      <# HTML prints #>
      echo "<hr>";

      <# loops using ForEach alias '%' #>
      $ctx.t.data | % { echo ($_.name + "<br>") };
  
  
     
      <# using http web request native method #>
      $waifu = Invoke-WebRequest -Uri "https://api.waifu.pics/many/sfw/wink" -Method Post -Body @{ "exclude" = @() };
      $waifuFiles = ($waifu.Content | ConvertFrom-Json).files;
      $waifuFiles | ForEach-Object { 
          echo "<img src='$($_)' alt='waifu' width='200px'>"
      };
  
      <# dynamic list of CPU process list #>
      echo "<ul>";
      Get-Process | % { 
          if($_.ProcessName.Length -gt 0){ 
              echo "<li>" $_.ProcessName "</li>" 
          } 
      };
      echo "</ul>";
  }$
<section/>
```

```html layout.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scout - $title</title>
</head>
<body>
    $content
</body>
</html>
```
