param (
    [string]$BaseNavigation = ".",
    [string]$outputFileName = "output.txt",
    [string]$SQRsPath       = ".",
    [string]$CustSQRsPath   = ".",
    [string]$SQRName        = "1.sqr"
 )

#This Powershell process will read through a single SQR process to get process flow. It will read all the SQCs involved in the process flow. 
#Output is procedure names, with hierarchy and indentation
#If a procedure is already covered, it is not going to be repeated.
#

$global:AllProcesses1 = ""
$global:SQRsPath =      $SQRsPath
$global:CustSQRsPath =  $CustSQRsPath

cd $BaseNavigation

$OutputFile = ($BaseNavigation + "\" + $outputFileName)
Clear-Content $OutputFile

Add-Content $OutputFile ("SQR: " + $SQRName)

$StartTime = Get-Date
write-host Start Time: (Get-Date)
Add-Content $OutputFile ("Start Time" + $StartTime)

$AllProcesses = ""
$global:AllProcesses1 = ""    #to store procedure names. so that an individual procedure is not repeated. 
$InSelect = "N"
$FirstFrom = "N"
$True = "Y"

$sqrFile = Get-Content ($CustSQRsPath + "\" + $SQRName)

Add-Content $OutputFile ""
Add-Content $OutputFile "Field Names: "

foreach ($Line in $sqrFile)     # Loop through each line in SQR
{
    $EachLine = $Line.trim()
    if($Line.trim().Substring(0,1) -eq "!")
    {
        $EachLine = ""
    }

    If($EachLine -match "^begin-select")     #check if begin-select is being called.
    {
        $InSelect = "Y"
    }else
    {
        If($EachLine -match "^end-select")     #check if end-select is being called.
        {
            $InSelect = "N"
            write-host $EachLine
            #Add-Content $OutputFile $EachLine
            Add-Content $OutputFile "***********************************************************************"
            Add-Content $OutputFile ""
            Add-Content $OutputFile ""
            $FirstFrom = "N"
        }
    }

    if($InSelect -match "Y")
    {
        write-host $EachLine
        #Add-Content $OutputFile $EachLine

        $FirstWordWithoutSpace = (($EachLine -split '\(')[0].trim() -split '\s+')[0]     #Extract procedure name from line
        

        if($FirstWordWithoutSpace -match "from")
        {
            if($FirstFrom -match "N")
            {
                $FirstFrom = "Y"
                Add-Content $OutputFile ""
                Add-Content $OutputFile "Table Names"
            }
        }

        

        if($FirstFrom -match "N")
        {
            if ($EachLine.trim() -eq "")
            {
                #Add-Content $OutputFile $EachLine
            }
            else
            {
                if($FirstWordWithoutSpace -notmatch "let|move")
                {
                    #Add-Content $OutputFile $FieldName.trim()
                    Add-Content $OutputFile $FirstWordWithoutSpace
                }
            }
        }
        else
        {
            Add-Content $OutputFile $EachLine
        }
    }

}


    

write-host all processes: $global:AllProcesses1
Add-Content $OutputFile ("All processes: " + $global:AllProcesses1)

$EndTime = Get-Date
write-host End Time: (Get-Date)
Add-Content $OutputFile ("End Time" + $EndTime)
$elapsedTime = $EndTime - $StartTime
write-host Elapsed Time: ($EndTime - $StartTime)
Add-Content $OutputFile ("Elapsed Time: " +$elapsedTime)