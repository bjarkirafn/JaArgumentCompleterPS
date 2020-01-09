function Search-JaArgumentCompleter {
  [Alias('jasearch')]
  [cmdletbinding()]
  param(
    [Alias('n')]
    # [parameter(ValueFromRemainingArguments)]
    [ArgumentCompleter( [JaArgumentCompleter])]
    [string[]]$Name
  )

  if ($Error[1] -match "JAERROR") {
    Clear-Host
    Write-Host $error[1] -ForegroundColor Red
    Write-Host $error[0] -ForegroundColor Yellow -NoNewline

    $action = Read-Host " [no/Yes]>"
    if ([string]::IsNullOrEmpty($action) -or $action.StartsWith('y')) {
      Write-Host "Brilliant!" -ForegroundColor Green
    } else {
      Write-Host "Crap!" -ForegroundColor Red
    }
    return
  }

  $name = ($name.count -gt 0) ? $name : 'Hello'
  $LastName = ($LastName.count -gt 0) ? $LastName : 'World'

  return $name, $LastName
}

