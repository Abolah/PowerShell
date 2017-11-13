param($i = $Global:i)
if ($i -eq $null){$i = 8080}
$i++

$Colors = @{
    BackgroundColor = "#FF252525"
    FontColor = "#FFFFFFFF"
}

$NavBarLinks = @((New-UDLink -Text "<i class='material-icons' style='display:inline;padding-right:5px'>favorite_border</i> PowerShell Pro Tools" -Url "https://poshtools.com/buy-powershell-pro-tools/"),
                 (New-UDLink -Text "<i class='material-icons' style='display:inline;padding-right:5px'>description</i> Documentation" -Url "https://adamdriscoll.gitbooks.io/powershell-tools-documentation/content/powershell-pro-tools-documentation/universal-dashboard.html"))

Start-UDDashboard -port $i -Content { 
    New-UDDashboard -NavbarLinks $NavBarLinks -Title "FoxDeploy Space Management Dashboard - Photos" -NavBarColor '#FF1c1c1c' -NavBarFontColor "#FF55b3ff" -BackgroundColor "#FF333333" -FontColor "#FFFFFFF" -Content { 
        New-UDRow {

            New-UDColumn -size 4 {
                New-UDImage -Url http://localhost/Foxdeploy_DEPLOY_large.png 
            }
            
            New-UDColumn -Size 4 {
                New-UDCounter -Title "Total Bytes Saved" -AutoRefresh -RefreshInterval 3 -Format "0.00b" -Icon cloud_download @Colors -Endpoint {
                    get-content c:\temp\picSpace.txt 
                } 
            }

            New-UDColumn -Size 4 {
                New-UDCounter -Title "Total Files Moved" -Icon file @colors -Endpoint {
                    get-content C:\temp\totalmoved.txt
                } 
            }
            
        }
        New-UDRow {
            
            New-UDColumn -size 6 {
                New-UDGrid -Title "$((import-csv C:\temp\movelog.csv)[-1].Files) Files Moved Today" @Colors -Headers @("BaseName", "Directory", "Extension", "FileSize") -Properties @("BaseName", "Directory", "Extension", "FileSize") -AutoRefresh -RefreshInterval 20 -Endpoint {
                    dir g:\backups\file*.csv | sort LastWriteTime -Descending | select -First 1 -ExpandProperty FullName | import-csv | Out-UDGridData
                }
            }

            New-UDColumn -Size 6 {
                New-UDChart -Title "Files moved by Day" -Type Line -AutoRefresh -RefreshInterval 7 @Colors -Endpoint {
                    
                    import-csv C:\temp\movelog.csv | Out-UDChartData -LabelProperty "Day" -DataProperty "Files" -Dataset @(
                        New-UDChartDataset -DataProperty "Jpg" -Label "Photos" -BackgroundColor "rgb(134,342,122)"
                        New-UDChartDataset -DataProperty "MP4" -Label "Movies" -BackgroundColor "rgb(234,33,43)"
                    
                    )
                        
                }
            }
        }
    
    }
    }


Start-Process http://localhost:$i
 