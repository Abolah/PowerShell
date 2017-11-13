cls
#$datefile = Get-Date -UFormat "%Y-%d-%m"
#Get-WmiObject -Query "select * from win32_service"| Where-Object{$_.State -eq "Running"} | Select Name, Pathname | Export-CSV C:\temp\$datefile.csv -notype -UseCulture



#import csv et check if path exist ou pas

#Import-Csv C:\temp\2017-24-10.csv -UseCulture 
Get-WmiObject -Query "select * from win32_service"| Where-Object{$_.State -eq "Running"} | Select Name, Pathname |ForEach-Object {
    $pathname = $_.Pathname
    $pathname = $pathname.Split('')[0]
    Write-host $pathname

    If (Test-Path -Path $pathname)
    {
        Write-Host $_.Name OK -ForegroundColor Green
    }Else
    {
        Write-Host $_.Name KO -ForegroundColor Red
    }
}
