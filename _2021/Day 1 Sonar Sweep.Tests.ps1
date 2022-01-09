BeforeAll {
    $DebugPreference = 'SilentlyContinue'
}
Describe 'Day 1 Sonar Sweep' {
    It 'Given no parameters, it solves both parts with Martin input' {
        Mock Write-Warning {}
        $result = & "$PSScriptRoot/Day 1 Sonar Sweep.ps1" 
        $result.Count | Should -Be 0
        Should -Invoke Write-Warning -Exactly 2 -Scope It
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq "1832" }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq "1858" }
    }
}