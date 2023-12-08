# PowerShell script to generate a CPU Affinity table for Windows environments.
# Can be run directly in a Powershell Shell. So no need to run it as .ps1, just copy and paste it.
# Utilizes Win32_Processor class to fetch CPU details and calculates thread affinity.

# Retrieve CPU information.
$cpuInfo = Get-WmiObject -Class Win32_Processor
$totalCores = $cpuInfo.NumberOfCores
$totalThreads = $cpuInfo.NumberOfLogicalProcessors

# Initialize StringBuilder for output formatting.
$outputBuilder = New-Object System.Text.StringBuilder
$outputBuilder.AppendLine(":: Affinity table for $($cpuInfo.Name) with Hyperthreading")

# Define a function to format affinity values into bitmasks.
Function Format-BitMask ($affinityValue) {
    $bitMask = [Convert]::ToString($affinityValue, 2).PadLeft(8, '0')
    return $bitMask.Length -gt 8 ? $bitMask.Insert($bitMask.Length - 8, ' ') : $bitMask
}

# Initialize variables for data collection and formatting.
$maxCoreThreadLength = $maxValueLength = $maxBitMaskLength = 0
$coreThreadInfo = @()
$valueInfo = @()
$bitMaskInfo = @()

# Determine the starting index for hyperthreaded cores.
$hyperthreadedStartIndex = $totalCores / 2

# Collect and format data for each thread.
for ($i = 0; $i -lt $totalThreads; $i++) {
    $affinityValue = 1 -shl $i
    $formattedBitMask = Format-BitMask -affinityValue $affinityValue
    $coreType = if ($i -lt $totalCores) { "P-Core" } else { "E-Core" }
    $threadID = if ($coreType -eq "P-Core" -and $i -ge $hyperthreadedStartIndex) { "$i`T" } else { "$i" }
    
    $coreThreadInfo += "$coreType $threadID"
    $valueInfo += $affinityValue.ToString()
    $bitMaskInfo += $formattedBitMask
}

# Compute maximum lengths for table formatting.
$maxCoreThreadLength = ($coreThreadInfo | Measure-Object -Property Length -Maximum).Maximum
$maxValueLength = ($valueInfo | Measure-Object -Property Length -Maximum).Maximum
$maxBitMaskLength = ($bitMaskInfo | Measure-Object -Property Length -Maximum).Maximum

# Construct the header for the affinity table.
$header = "Thread #".PadRight($maxCoreThreadLength) + " = " + "Value".PadRight($maxValueLength) + " = BitMask"
$outputBuilder.AppendLine(":: $header")

# Build the table with aligned data.
for ($i = 0; $i -lt $totalThreads; $i++) {
    $outputBuilder.AppendLine(":: $($coreThreadInfo[$i].PadRight($maxCoreThreadLength)) = $($valueInfo[$i].PadRight($maxValueLength)) = $($bitMaskInfo[$i].PadRight($maxBitMaskLength))")
}

# Output the formatted table.
$outputBuilder.ToString()
