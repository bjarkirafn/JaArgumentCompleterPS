using namespace System.Collections
using namespace System.Management.Automation

function Set-JaArgumentCompleter {
  [Alias('jasetac')]
  [CmdletBinding()]
  [OutputType([Generic.List[CompletionResult]])]

  $log = @{
    FileName = "$env:temp\jalog"
    Append   = $true
  }

  "started" > $log.FileName

  $cmd, $param, $word, $ast, $fake, $opt = $args

  [string[]]$result = @()

  switch -regex ($opt.GetType().Name) {
    String { $result = $opt.split(' '); break }
    ScriptBlock { $result = & $opt; break }
    'Object|Array' { $result = $opt; break }
  }

  $results = [Generic.List[CompletionResult]]::new()
  $result | ForEach-Object { $null = $results.Add([CompletionResult]::new($_)) }
  return $results

}

