BeforeAll {
    $DebugPreference = 'SilentlyContinue'
}
Describe 'Day 1 Sonar Sweep' {
    AfterEach { Remove-Item "$PSScriptRoot/input1" }

    It 'Given no parameters, it solves both parts with example input' {
        Out-File -InputObject (199, 200, 208, 210, 200, 207, 240, 269, 260, 263) "$PSScriptRoot/input1"
        Mock Write-Warning { Write-Output $message }
        $result = & "$PSScriptRoot/Day 1 Sonar Sweep.ps1" 
        $result.Count | Should -Be 2
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '7' }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '5' }
    }
    It 'Given no parameters, it solves both parts with Martin input' {
        Mock Write-Warning { Write-Output $message }
        $result = & "$PSScriptRoot/Day 1 Sonar Sweep.ps1" 
        $result.Count | Should -Be 2
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1832' }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1858' }
    }
}

Describe 'Day 2 Dive' {
    AfterEach { Remove-Item "$PSScriptRoot/input2" }

    It 'Given no parameters, it solves both parts with example input' {
        Out-File -InputObject ('forward 5', 'down 5', 'forward 8', 'up 3', 'down 8', 'forward 2') "$PSScriptRoot/input2"
        Mock Write-Warning { Write-Output $message }
        $result = & "$PSScriptRoot/Day 2 Dive.ps1" 
        $result.Count | Should -Be 2
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '150' }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '900' }
    }

    It 'Given no parameters, it solves both parts with Martin input' {
        Mock Write-Warning { Write-Output $message }
        $result = & "$PSScriptRoot/Day 2 Dive.ps1" 
        $result.Count | Should -Be 2
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1484118' }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '1463827010' }
    }
}