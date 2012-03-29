
# ----------------------------------------------------- 
function WaitKey 
{ 
    param( [String] $strPrompt = "Press any key to continue ... ") 
    Write-Host 
    Write-Host $strPrompt -NoNewline 
    $key = [Console]::ReadKey($true) 
    Write-Host 
} 
 
function Create-7zip([String] $aDirectory, [String] $aZipfile){
    [string]$pathToZipExe = "C:\Program Files (x86)\7-zip\7z.exe";
    [Array]$arguments = "a", "-t7Z", "$aZipfile", "$aDirectory", "-r","-mx=9";
    & $pathToZipExe $arguments;
}

function Create-BackUp([String] $strSourceFolder, [String]  $strDestinationFolder) {     
cd $strSourceFolder
 
$iCopyCount = 0 
$iDestDeletedCount = 0 

Write-Host 
Write-Host "Iniciando BackUp " -NoNewline -ForegroundColor "White" 
Write-Host $strSourceFolder -ForegroundColor "Cyan" -NoNewline 
Write-Host " Para " -NoNewline -ForegroundColor "White" 
Write-Host $strDestinationFolder -ForegroundColor "Cyan" 
Write-Host 
 
$FSO = New-Object -COM Scripting.FileSystemObject 
 
if( -not $FSO.FolderExists($strSourceFolder) ) 
{ 
    Write-Host "Error: source folder does not exist!" -ForegroundColor "Red" 
    Write-Host 
    Write-Host "Exiting script" 
    WaitKey "Press any key to exit ... " 
    exit 
} 
 
if( -not $FSO.FolderExists($strDestinationFolder) ) 
{ 
    Write-Host "Warning: destination folder does not exist" 
    $p = Read-Host "Create folder and continue? " 
    Write-Host 
    if( $p.Substring(0, 1).ToUpper() -eq "Y" ) 
    { 
        $FSO.CreateFolder($strDestinationFolder) 
    } 
    else 
    { 
        Write-Host "Exiting script" 
        WaitKey "Press any key to exit ... " 
        exit 
    } 
} 

$strFileName = $FSO.GetBaseName($strSourceFolder)

$strDateCreate = [DateTime]::Now.ToString("yyyyMMdd_HHmmss")

$strFileName = $strFileName + "_" + $strDateCreate +".7z"

Create-7zip $strSourceFolder $strFileName
Write-Host "Fim da compressão dos arquivos"
Write-Host "Movendo arquivo para:" -NoNewline -ForegroundColor "White"
Write-Host $strDestinationFolder -ForegroundColor "Cyan"  
Move-Item  $strFileName $strDestinationFolder

WaitKey "BackUp Efetuado com sucesso ... "
} 

 