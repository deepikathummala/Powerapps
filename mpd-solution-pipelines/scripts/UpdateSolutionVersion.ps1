param(
    [parameter(Mandatory=$true,Position=1)]
     [String]$SolutionName,
    [parameter(Mandatory=$true,Position=2)]
    [Alias("ConnString","CS")]
    [String]$ConnectionString,
    [Parameter(Mandatory)]
    [bool]$BuildVersionChange
)
$Module = Get-InstalledModule -Name "Microsoft.Xrm.Data.Powershell" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
      if($Module -ne $null)
      {
          Write-host "Module is already installed!!!!, `nModule details:";
          $Module | Format-Table -Wrap 
       }
      else
      {
          Write-host "Module is not installed,`nInstalling Module('Microsoft.Xrm.Data.Powershell')...";
          Install-Module -Name Microsoft.Xrm.Data.Powershell -Force -Scope CurrentUser -Verbose
          Write-host "Module('Microsoft.Xrm.Data.Powershell') is installed successfully....";
      }
      
      ## Create the service connection to Dynamics 365
      $ServiceConn =  Get-CrmConnection -ConnectionString $ConnectionString
      Write-host "Service Conenction is : "$ServiceConn;
      if($ServiceConn){
      Write-host "Conenction is established successfully : "$ServiceConn.ConnectedOrgFriendlyName;
      Write-host "Build Version Change is : "$BuildVersionChange;
          Write-Host "`n##############################--------------Update Solution Version Task--------------##############################`n";
          $SolutionQuery = New-Object  Microsoft.Xrm.Sdk.Query.QueryExpression("solution");
          $SolutionQuery.ColumnSet = New-Object Microsoft.Xrm.Sdk.Query.ColumnSet($true);
          $SolutionQuery.Criteria.AddCondition("uniquename",[Microsoft.Xrm.Sdk.Query.ConditionOperator]::Equal,"$SolutionName");
          $SolutionCollection = $ServiceConn.RetrieveMultiple($SolutionQuery);
      
          if($SolutionCollection.Entities.Count -gt 0){
              $OldVersion = $SolutionCollection.Entities[0].Attributes["version"];
              [int []]$OldVersionArray = $OldVersion.Split('.');
              write-host "Current solution version is "$OldVersion;
              if($OldVersionArray.Count -gt 3){
                  $RevisionVersion = $OldVersionArray[3];
                  $BuildVersion = $OldVersionArray[2];
                  $MinorVersion = $OldVersionArray[1];
                  $MajorVersion = $OldVersionArray[0];
                  if($BuildVersionChange){
                       $RevisionVersion = $OldVersionArray[3] + 1;
                       $BuildVersion = $OldVersionArray[2];
                       $MinorVersion = $OldVersionArray[1];
                       $MajorVersion = $OldVersionArray[0];
                       Write-host "Updating Build number from " $OldVersionArray[3] to $RevisionVersion;
      
                  }
          
              #$newVersionNumber =  "{0}.{1}.{2}.{3}" -f $OldVersionArray[0], $MinorVersion , $BuildVersion, $RevisionVersion 
              $newVersionNumber =  "{0}.{1}.{2}.{3}" -f $MajorVersion, $MinorVersion , $BuildVersion, $RevisionVersion
        
              }
              $Solution = $SolutionCollection.Entities[0];
              $Solution["version"] = $newVersionNumber;
              write-host "Solution version is updating to "$newVersionNumber;
              try{
              ## Updating the Solution version using update request
              $ServiceConn.Update($Solution);
              #$SolutionQuery.update($Solution);
              write-host "Solution version is updated successfully...";
              # Output the new version number to a file
              $outputFilePath = "version.txt"
              Write-Output $newVersionNumber | Out-File -FilePath $outputFilePath
              return $newVersionNumber;
              }
              catch{
              write-warning "Connection is thrown error while updating solution version. Error details:`n";
              write-warning $_.Exception.Message
              }
          }
          else
          {
              write-warning "No solution is found with name ($SolutionName)";
          }
          Write-Host "`n##############################----------------------Task Completed -------------------##############################";
      }
      else
      {
      Write-Error "Connection is not established...";
      }
