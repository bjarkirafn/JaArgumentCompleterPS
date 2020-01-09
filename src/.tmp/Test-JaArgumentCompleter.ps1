
function Test-JaArgumentCompleter {
  [Alias('jatest')]
  [cmdletbinding()]
  param(
    [Alias('n')]
    # [parameter(ValueFromRemainingArguments)]
    [ArgumentCompleter( [JaArgumentCompleter])]
    [string[]]$Name,
    [ArgumentCompleter( [JaArgumentCompleter])]
    [string[]]$LastName
  )

  $name = ($name.count -gt 0) ? $name : 'Hello'
  $LastName = ($LastName.count -gt 0) ? $LastName : 'World'

  return $name, $LastName
}



