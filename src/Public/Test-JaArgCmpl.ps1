function Test-JaArgCmpl {
  param(
    # [ArgumentCompleter( { & { jasetac @($args, 'get set add remove' ) } })]
    [ArgumentCompleter( { Get-JaNouns  })]
    $name
  )
}

