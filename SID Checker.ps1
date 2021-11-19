# SID Checker for Users/Computers
# USAGE: Run/F5
# TO DO: SID duplicate finder (option 5)


function Show-Menu
{
    param (
        [string]$Title = 'SID Checker'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    Write-Host "1: Press '1' in order to search AD for a SID by computer name."  
    Write-Host "2: Press '2' in order to search AD for a SID by username."
    Write-Host "3: Press '3' for a list of AD SIDs (computers). Report will be sent to C:\Temp\SidReports\compsid.csv."
    Write-Host "4: Press '4' for a list of AD SIDs (users). Report will be sent to C:\Temp\SidReports\usersid.csv."
    <#
    Write-Host "5: Press '5' to find SID duplicates (users & computers). An inline response will be generated."
    #>
    Write-Host "Q: Press 'Q' to quit."
}
function New-Folder
{
    $folderName = 'SidReports'
    $Path="C:\Temp\"+$folderName

    if (!(Test-Path $Path))
    {
    New-Item -itemType Directory -Path C:\Temp\ -Name $folderName | Out-Null
    }
}

do {
    Show-Menu -Title 'SID Checker'
    New-Folder
    $selection = Read-Host "Please make a selection"
    switch ($selection) {
            '1' {
            $cName = Read-Host("Input hostname")
            $cName = Get-ADComputer -Identity $cName | Select-Object Name, SID 
            Write-Output($cName)
            exit
        }   '2' {
            $uName = Read-Host("Input username")
            $uName = Get-ADUser -Identity $uName | Select-Object Name, SID 
            Write-Output($uName)
            exit
        }   '3' {
            Get-ADComputer -Filter * -prop sid | Select-Object Name, SID | Sort-Object Name | Export-Csv -path 'C:\Temp\SidReports\compsid.csv' -NoTypeInformation
            exit
        }   '4' {
            Get-ADUser -Filter * -prop sid | Select-Object Name, SID | Sort-Object Name | Export-Csv -path 'C:\Temp\SidReports\usersid.csv' -NoTypeInformation
            exit
        <#    
        }   '5' {
            Get-ADComputer -Filter * -prop sid | Select-Object Name, SID | Sort-Object Name | Export-Csv -path 'C:\Temp\SidReports\compsid.csv' -NoTypeInformation
            Get-ADUser -Filter * -prop sid | Select-Object Name, SID | Sort-Object Name | Export-Csv -path 'C:\Temp\SidReports\usersid.csv' -NoTypeInformation
            exit
        #>    
        }   'q' {
            return
        }
    }
} until ($selection -eq 'q')












