#-----------------------------------------------------------------------------------------------------------
# Eric Luangpakdy's Powershell Capstone Project
# This script will create folders for you and give the user all the syevent logs within the past 24 hours.
# The event logs will be in three different text files: Error, Information, and Warning
# This script can also be used in the Task Scheduler so the 24h does no overlap in the future
# THIS SCRIPT IS NOT PERFECT
# but I am :)
#-----------------------------------------------------------------------------------------------------------

cls

#This variable turns into the index's high value, which we will call later

$Event = Get-EventLog System -Newest 1

#We start by showing the user their system event logs... all of them

Write-Host "Hello and welcome to the System Event Log sorter"-BackgroundColor DarkBlue -ForegroundColor Green
Start-Sleep -s 3

Write-Host "Let's see how many system events are logged" -ForegroundColor Yellow -BackgroundColor black
Start-Sleep -s 2

Get-EventLog system | sort -Property Index

Write-host ""
Write-Host "Wow!" $Event.index " Logged items? Let's make that more readable..." -ForegroundColor Magenta
Start-Sleep -s 2
Write-host ""

Write-Host "We will only retrieve the System Event Logs logged within the past 24 hours"  -ForegroundColor DarkRed -BackgroundColor White
start-sleep -s 3

Write-Host ""



#Creating variables for the text files

$errorlog = "YourErrorLogs.txt"
$Warninglogs = "YourWarningLogs.txt"
$Informationlogs = "YourInformationLogs.txt"

$date = (Get-Date -format 'g')  #this turns get-date into a format where we can chop off the latter half of the text
                                #and turn it into the name of a folder


#Tests to see if the folder is already made. If it is already made, it will not give an error message
$LogsFolder = 'C:\EventLogsForYou\'
if(!(Test-Path -Path $LogsFolder )){
    New-Item -ItemType directory -Path $LogsFolder
} #End if


#Create a folder inside of the Eventlogs folder for the text files to go using the variable as the name
#Same method to see if the folder is already created as above
cd c:\EventLogsForYou

$DateFolder = "C:\EventLogsForYou\" + $date.substring(0,10)
if(!(Test-Path -Path $DateFolder )){
    md $date.substring(0,10)
} #End if

#Now we get to the fun stuff
#Change into the directory of today's date

cd $date.Substring(0,10)

#Now we start creating the text files
#First off, the Error logs
#Use redirection to points the output of the logs into the variable we created earlier
#also using the AddHours -24 to only output the logs within the past 24 hours of running this script

get-eventlog system -After (Get-Date).AddHours(-24) | where {$_.EntryType -eq "error"} > $errorlog
Write-host "Gathering Error information" -ForegroundColor cyan -BackgroundColor Black
Write-host ""

#Now rinse and repeat

get-eventlog system -After (Get-Date).AddHours(-24) | where {$_.EntryType -eq "warning"} > $Warninglogs
Write-host "Shuffling through Warning logs" -ForegroundColor DarkGreen -BackgroundColor Gray
Write-host ""

#One last time!

get-eventlog system -After (Get-Date).AddHours(-24) | where {$_.EntryType -eq "information"} > $Informationlogs
Write-host "Your Information logs are now made!" -ForegroundColor White -BackgroundColor Black
Write-host ""



###  ...progress bar counts down from ..5.sec...
###  Credit to Matthew for helping me with this
###====================================================

$count = 5*1
$length = $count / 5
while($count -gt 0) {
  $time = [int](([string]($count/1)).split('.')[0])
  $text = " " + $time + " seconds left" 
  Write-Progress "Finishing up the final touches" -status $text -perc ($count/$length)
  start-sleep -s 1
  $count--
}; #End While


Write-Host "I have gently put your system event logs in a folder" -ForegroundColor Yellow
Write-Host "I will now direct you to the folder where your logs are" -ForegroundColor Yellow #illusions

pwd
start-sleep -s 3

Write-Host "Finished!" -ForegroundColor DarkGreen -BackgroundColor White
pause

start . -WindowStyle Normal


#potentially use this 
#get-eventlog application -after ([datetime]'11/29/2017 12:06:00 pm')