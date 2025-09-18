<# --- Day 16: Packet Decoder ---
As you leave the cave and reach open waters, you receive a transmission from the Elves back on the ship.

The transmission was sent using the Buoyancy Interchange Transmission System (BITS), 
a method of packing numeric expressions into a binary sequence. 

Part 1: Decode the structure of your hexadecimal-encoded BITS transmission; 
what do you get if you add up the version numbers in all packets?

Part 2: What do you get if you evaluate the expression represented by your hexadecimal-encoded BITS transmission?
#>

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

function decode_package ($package, $position = 0)
{
  Write-Debug "Decoding ${package} at position ${position}"
  $version = [convert]::ToInt16($package.Substring($position, 3), 2)
  $version_sum = $version
  Write-Debug "Version: $version"
  $type_ID = [convert]::ToInt16($package.Substring($position + 3, 3), 2)
  Write-Debug "Type ID: $type_ID"
  $current_pos = $position + 6
  
  if ($type_ID -eq 4)
  {
    # literal value
    $value = ''
    do
    {
      $group = $package.Substring($current_pos, 5)
      $continue_bit = $group.Substring(0, 1)
      $value += $group.Substring(1, 4)
      $current_pos += 5
    } while ($continue_bit -eq '1')
    
    $literal_value = [convert]::ToInt64($value, 2)
    Write-Debug "Literal value: $literal_value"
    return @{
      Version = $version
      TypeID = $type_ID
      Value = $literal_value
      VersionSum = $version_sum
      BitsConsumed = $current_pos - $position
    }
  }
  else
  {
    # operator
    $length_type_ID = $package.Substring($current_pos, 1)
    $current_pos += 1
    $sub_packets = @()
    
    if ($length_type_ID -eq '0')
    {
      # the next 15 bits are a number that represents the total length in bits of the sub-packets contained by this packet.
      $sub_packets_length = [convert]::ToInt16($package.Substring($current_pos, 15), 2)
      $current_pos += 15
      $sub_packets_end = $current_pos + $sub_packets_length
      
      Write-Debug "Operator with length type 0, sub-packets length: $sub_packets_length"
      
      while ($current_pos -lt $sub_packets_end)
      {
        $sub_packet = decode_package $package $current_pos
        $sub_packets += $sub_packet
        $version_sum += $sub_packet.VersionSum
        $current_pos += $sub_packet.BitsConsumed
      }
    }
    else
    {
      # the next 11 bits are a number that represents the number of sub-packets immediately contained by this packet.
      $num_sub_packets = [convert]::ToInt16($package.Substring($current_pos, 11), 2)
      $current_pos += 11
      
      Write-Debug "Operator with length type 1, number of sub-packets: $num_sub_packets"
      
      for ($i = 0; $i -lt $num_sub_packets; $i++)
      {
        $sub_packet = decode_package $package $current_pos
        $sub_packets += $sub_packet
        $version_sum += $sub_packet.VersionSum
        $current_pos += $sub_packet.BitsConsumed
      }
    }
    
    return @{
      Version = $version
      TypeID = $type_ID
      LengthTypeID = $length_type_ID
      SubPackets = $sub_packets
      VersionSum = $version_sum
      BitsConsumed = $current_pos - $position
    }
  }
}

function evaluate_packet ($packet)
{
  if ($packet.TypeID -eq 4)
  {
    # Literal value
    return $packet.Value
  }
  else
  {
    # Operator packet - evaluate sub-packets first
    $sub_values = $packet.SubPackets | ForEach-Object { evaluate_packet $_ }
    
    switch ($packet.TypeID)
    {
      0 { # sum
        return ($sub_values | Measure-Object -Sum).Sum
      }
      1 { # product
        $product = 1
        $sub_values | ForEach-Object { $product *= $_ }
        return $product
      }
      2 { # minimum
        return ($sub_values | Measure-Object -Minimum).Minimum
      }
      3 { # maximum
        return ($sub_values | Measure-Object -Maximum).Maximum
      }
      5 { # greater than
        return [int]($sub_values[0] -gt $sub_values[1])
      }
      6 { # less than
        return [int]($sub_values[0] -lt $sub_values[1])
      }
      7 { # equal to
        return [int]($sub_values[0] -eq $sub_values[1])
      }
      default {
        throw "Unknown type ID: $($packet.TypeID)"
      }
    }
  }
}

# Parse the packet and calculate version sum for Part 1
$packet = decode_package $binary
Write-Warning "Part 1 - Version sum: $($packet.VersionSum)"

# Evaluate the packet for Part 2
$result = evaluate_packet $packet
Write-Warning "Part 2 - Evaluated value: $result"