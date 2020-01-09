using namespace System.Collections
using namespace System.Management.Automation
using namespace Microsoft.PowerShell

class JaArgumentCompleter : IArgumentCompleter {

  static $Completers = @{
    Counter = 0
    Cache   = [ArrayList]@()
  }


  static $Counter = 0

  $ErrorMessges = @(
    "JAERROR!!"
    "$($this.CommandName) is not registerd as JaArgumentCompleter!?"
    "Would you like to register!?"
  )


  $HomeDir = $(Get-Item "$home\.jaseisei\.posh\.argCompleters")

  $logFile = 'c:\temp\log'

  [string]$Noun
  [string]$Verb
  [String]$CommandName
  [String]$ParameterName
  [Language.CommandAst]$CommandAst
  hidden [string]$_CackeKey = @(
    $this | Add-Member -MemberType ScriptProperty -Name CacheKey -Value {
      return $this.Noun, $this.Verb, $this.Parameter -join '.'
    }
  )

  $Completer

  [Generic.IEnumerable[CompletionResult]]
  CompleteArgument(
    [String]$CommandName,
    [String]$ParameterName,
    [String]$WordToComplete,
    [Language.CommandAst]$CommandAst,
    [IDictionary]$FakeBoundParameters
  ) {

    $log = $this.logFile
    [JaArgumentCompleter]::Counter += 1
    $count = [JaArgumentCompleter]::Counter
    "Started Countz: $count" > $log

    "JaArgCounter: $([JaArgumentCompleter]::Counter)" | Out-File $log -Append



    $cmd = Get-Command $CommandName

    $this.Noun,
    $this.Verb,
    $this.CommandName,
    $this.ParameterName,
    $this.CommandAst = $cmd.Noun, $cmd.Verb, $CommandName, $ParameterName, $CommandAst



    if (![JaArgumentCompleter]::Completers[$this.Noun]) {
      $data = $this.GetData()
      if ($Data.ERROR) {

        $this.ErrorMessges | ForEach-Object { $Error.insert(0, $_) }
        (New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
        return $null
      }

      [JaArgumentCompleter]::Completers.Add($this.Noun, @{$this.Verb = $this.GetData() })

    } elseif (

      [JaArgumentCompleter]::Completers[$this.Noun] -and
      $this.Verb -notin [JaArgumentCompleter]::Completers[$this.Noun].keys) {

      [JaArgumentCompleter]::Completers[$this.Noun].Add($this.Verb, $this.GetData())
    }


    $this.Completer = [JaArgumentCompleter]::Completers[$this.Noun][$this.Verb][$this.ParameterName]
    $Type = $this.Completer.Type

    return $this.$Type(
      $CommandName,
      $ParameterName,
      $WordToComplete,
      $CommandAst,
      $FakeBoundParameters
    )
  }

  [boolean]
  InCache() { return $this.CacheKey -in [JaArgumentCompleter]::Completers.Cache }

  [hashtable]
  GetData() {
    $fileName = $this.Noun, $this.Verb, 'json' -join '.'
    $path = $this.HomeDir, $fileName -join [system.io.path]::DirectorySeparatorChar

    if (!(Test-Path  $path)) { return @{ERROR = $null } }

    $filePath = Join-Path $this.HomeDir $fileName
    "filePath: $filePath" | Out-File $this.logFile -Append
    return Get-Content $filePath | ConvertFrom-Json -AsHashtable
  }


  AddResults([Generic.List[CompletionResult]]$Results) {
    if ('Results' -in $this.Completer.keys) { $this.completer.results = $results }
    else {
      $this.completer.Add('Results', $Results)
      [JaArgumentCompleter]::Completers.Cache.Add($this.CacheKey)
    }

  }


  [Object[]]
  PreviousArgs() {
    return $this.CommandAst.CommandElements.Value |
      Select-Object -Skip 1
  }

  [Generic.List[CompletionResult]]
  GetResults() {
    $global:jaResults = $this.completer.results
    $results = [Generic.List[CompletionResult]]::new($this.Completer.Results)

    $this.PreviousArgs() |
      ForEach-Object {
        $preArg = $_
        $toRemove = $results | Where-Object { $_.CompletionText -like $preArg }
        $results.Remove($toRemove)
      }

    return $results
  }

  [Generic.IEnumerable[CompletionResult]]
  Basic ($c, $p, $w, $a, $f) {
    $log = $this.logFile

    if ($this.InCache()) {
      'Getting Data' | Out-File $log -Append
      $results = $this.GetResults()

    } else {
      $results = [Generic.List[CompletionResult]]::new()

      $myData = $this.completer.Values
      if ($myData -is [string]) { $myData = $myData.split(' ') }

      $myData |
        Where-Object { $_ -like "$w*" } |
        ForEach-Object { $null = $results.Add([CompletionResult]::new($_)) }

      # "Adding results: $($results | ConvertTo-json)" | Out-File $log -Append
      $this.AddResults($results)

      # "completerResults: $($this.completer | ConvertTo-Json)" | Out-File $log -Append

    }

    return $results
  }

}

