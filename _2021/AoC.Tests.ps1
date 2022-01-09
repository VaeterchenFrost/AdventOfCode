BeforeAll {
    $DebugPreference = 'SilentlyContinue'
}
Describe 'Day 1 Sonar Sweep' {
    It 'Given no parameters, it solves both parts with Martin input' {
        Mock Write-Warning { Write-Output $message }
        $result = & "$PSScriptRoot/Day 1 Sonar Sweep.ps1" 
        $result.Count | Should -Be 2
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1832' }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1858' }
    }
}

Describe 'Day 2 Dive' {
    It 'Given no parameters, it solves both parts with Martin input' {
        Mock Write-Warning { Write-Output $message }
        $result = & "$PSScriptRoot/Day 2 Dive.ps1" 
        $result.Count | Should -Be 2
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1484118' }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1463827010' }
    }
}