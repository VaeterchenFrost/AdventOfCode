<# --- Day 16: Packet Decoder ---#>

$year, $day = 2021, 16

. "$PSScriptRoot/../scripts/LoadAocInput.ps1"
$inputfile = $PSScriptRoot + "/input$day" -replace '\\', '/'
$string = load_aoc_input $year $day $inputfile

# The first step of decoding the message is to convert the hexadecimal representation into binary. 
# Each character of hexadecimal corresponds to four bits of binary data:

$binary = $string.ToCharArray().foreach({ [Convert]::ToString([Convert]::ToByte($_, 16), 2).PadLeft(4, '0') }) -join ''

# The BITS transmission contains a single packet at its outermost layer which itself contains many other packets. 
# The hexadecimal representation of this packet might encode a few extra 0 bits at the end; 
# these are not part of the transmission and should be ignored

# Every packet begins with a standard header: the first three bits encode the packet version, and the next three bits encode the packet type ID. These two values are numbers; all numbers encoded in any packet are represented as binary with the most significant bit first. 
# For example, a version encoded as the binary sequence 100 represents the number 4.

function decode_package ($package)
{
  Write-Debug "Decoding ${package}"
  $version = [convert]::ToInt16($package.Substring(0, 3), 2)
  Write-Debug $version
  $type_ID = [convert]::ToInt16($package.Substring(3, 3), 2)
  Write-Debug $type_ID
  if ($type_ID -eq 4)
  {
    # literal value
    $pointer = 1
    $value = ''
    do
    {
      $pointer += 5
      $value += $package.Substring($pointer + 1, 4)
    } until ($package.Substring($pointer, 1) -eq '0')
    return [convert]::ToInt16($value, 2)
  }
  else
  {
    # operator
    if ($package.Substring($pointer, 1) -eq '0')
    {
      # the next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
    }
    else
    {
      # the next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
    }
    
  }
}

decode_package $binary