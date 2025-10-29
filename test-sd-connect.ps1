# test sd-connect ports, powershell version, Jopa, 20251029
# usage examples:
# "PS C:\> .\test-sd-connect.ps1"
# "PS C:\> powershell.exe -executionpolicy bypass -File .\test-sd-connect.ps1"

$names = @("pouta.csc.fi","pouta.csc.fi","a3s.fi","sd-connect.csc.fi") 
$ports = @("5001","443","443","443") 
 
for( $i = 0; $i -lt $names.Count; $i++ ){ 
  $name = $($names[$i])
  $port = $($ports[$i])
  $target = $name,$port -join ':'
  Write-Output "---------------"
  Write-Output "$target"

  $id = Start-Job {
    Test-NetConnection -Port $using:port -ComputerName $using:name -InformationLevel Quiet
  } | Wait-Job -Timeout 5

  if ([string]::IsNullOrEmpty($id)) {
     Write-Warning "Connection Timeout"
     Write-Output "False"
   } else {
     Receive-Job -Job $id
   }
}

