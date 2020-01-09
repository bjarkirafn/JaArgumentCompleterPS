@{
    Path = "JaArgumentCompleterPS.psd1"
    OutputDirectory = "..\bin\JaArgumentCompleterPS"
    Prefix = '.\_PrefixCode.ps1'
    SourceDirectories = 'Classes','Private','Public'
    Symlinks = @{
        Classes = ''
        Private = ''
        Public  = ''
    }
    PublicFilter = 'Public\*.ps1'
    CopyDirectories = @()
    VersionedOutputDirectory = $true
}


