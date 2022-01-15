# for examples:
# -split "\n" |%{"'$_',"} | Set-Clipboard

BeforeAll {
    $DebugPreference = 'SilentlyContinue'
}
Describe 'Day 1 Sonar Sweep' {
    BeforeEach { Remove-Item "$PSScriptRoot/input1" -ErrorAction 'SilentlyContinue' }

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
    BeforeEach { Remove-Item "$PSScriptRoot/input2" -ErrorAction 'SilentlyContinue' }

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

Describe 'Day 3 Binary Diagnostic' {
    BeforeEach { Remove-Item "$PSScriptRoot/input3" -ErrorAction 'SilentlyContinue' }

    It 'Given no parameters, it solves both parts with example input' {
        Out-File -InputObject ('00100', '11110', '10110', '10111', '10101', '01111', '00111', '11100', '10000', '11001', '00010', '01010') "$PSScriptRoot/input3"
        Mock Write-Warning { Write-Output $message }
        $result = & "$PSScriptRoot/Day 3 Binary Diagnostic.ps1" 
        $result.Count | Should -Be 2
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '198' }
        Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq '230' }
    }
}

Describe 'Day 4 Giant Squid' {
    Describe 'Example part1=<part1>' -ForEach @(
        @{ Part1 = $true; Expected = '4512' }
        @{ Part1 = $false; Expected = '1924' }
    ) {
        BeforeEach { Remove-Item "$PSScriptRoot/input4" -ErrorAction 'SilentlyContinue' }
    
        It 'Given part1 <part1>, it solves it correctly with example input' {
            $example = ('7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1',
                '',
                '22 13 17 11  0',
                ' 8  2 23  4 24',
                '21  9 14 16  7',
                ' 6 10  3 18  5',
                ' 1 12 20 15 19',
                '',
                ' 3 15  0  2 22',
                ' 9 18 13 17  5',
                '19  8  7 25 23',
                '20 11 10 24  4',
                '14 21 16 12  6',
                '',
                '14 21 17 24  4',
                '10 16 15  9 19',
                '18  8 23 26 20',
                '22 11 13  6  5',
                ' 2  0 12  3  7')  
            Out-File -InputObject $example "$PSScriptRoot/input4" 
            Mock Write-Warning { Write-Output $message }
            $result = & "$PSScriptRoot/Day 4 Giant Squid.ps1" 
            $result.Count | Should -Be 1
            Should -Invoke Write-Warning -Exactly 1 -Scope It -ParameterFilter { $message -eq $expected }
        }
    }
}
