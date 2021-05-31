#Author:地表上最強男人ü 2021-05-30
#Everyone is wellcome to contribute except those who abuse it

#Process Name:
#Garena
#LeagueClient
#LeagueClientUx
#League of Legends

#Window Name:
#Garena - 遊戲中心
#League of Legends
#League of Legends (TM) Client

#coordinates:
#Example = @( windowAxisX, windowAxisY, windowSizeX, windowSizeY, "ProcessName")
$garenaStart =   @( 480, 691, 1022, 718, "Garena" )
$garenaClose =   @( 633, 407, 1022, 718, "Garena" )

$queueStart =    @( 728, 841, 1600, 900, "LeagueClientUx" )
$queueAccept =   @( 790, 700, 1600, 900, "LeagueClientUx" )
$restartLobby =  @( 149, 51 , 1600, 900, "LeagueClientUx" )
$restartMode =   @( 780, 274, 1600, 900, "LeagueClientUx" )
$restartNormal = @( 679, 620, 1600, 900, "LeagueClientUx" )

$slot1 =         @( 570 , 1000, 1920, 1080, "League of Legends" )
$slot2 =         @( 784 , 1000, 1920, 1080, "League of Legends" )
$slot3 =         @( 982 , 1000, 1920, 1080, "League of Legends" )
$slot4 =         @( 1187, 1000, 1920, 1080, "League of Legends" )
$slot5 =         @( 1384, 1000, 1920, 1080, "League of Legends" )
$buttonConfig =  @( 1904, 886, 1920, 1080, "League of Legends" )
$buttonSurrend = @( 767 , 845, 1920, 1080, "League of Legends" )
$buttonConfirm = @( 835 , 485, 1920, 1080, "League of Legends" )
$buttonCancel =  @( 1289, 846, 1920, 1080, "League of Legends" )
$battlefield1 =  @( 1306, 651, 1920, 1080, "League of Legends" )
$battlefield2 =  @( 1304, 237, 1920, 1080, "League of Legends" )
$battlefield3 =  @( 598 , 240, 1920, 1080, "League of Legends" )
$battlefield4 =  @( 1306, 651, 1920, 1080, "League of Legends" )

#don't know what this does but can't delete
[System.Reflection.Assembly]::LoadWithPartialName("system.windows.forms")

$targetClient = "LeagueClient"
$targetGame = "League of Legends"
$processClient = Get-Process | Where-Object {$_.ProcessName -eq $targetClient}
$processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}

#$focusWindow = New-Object -ComObject wscript.shell
#use case:
#$focusWindow.AppActivate('League of Legends')

function Show-Window {
  param(
    [Parameter(Mandatory)]
    [string] $ProcessName
  )

  # As a courtesy, strip '.exe' from the name, if present.
  $ProcessName = $ProcessName -replace '\.exe$'

  # Get the ID of the first instance of a process with the given name
  # that has a non-empty window title.
  # NOTE: If multiple instances have visible windows, it is undefined
  #       which one is returned.
  $procId = (Get-Process -ErrorAction Ignore $ProcessName).Where({ $_.MainWindowTitle }, 'First').Id

  if (-not $procId) { Throw "No $ProcessName process with a non-empty window title found." }

  # Note: 
  #  * This can still fail, because the window could have been closed since
  #    the title was obtained.
  #  * If the target window is currently minimized, it gets the *focus*, but is
  #    *not restored*.
  #  * The return value is $true only if the window still existed and was *not
  #    minimized*; this means that returning $false can mean EITHER that the
  #    window doesn't exist OR that it just happened to be minimized.
  $null = (New-Object -ComObject WScript.Shell).AppActivate($procId)

}
#use case:
#Show-Window "LeagueClientUx"

function moveCursorToSpot{
param($target)

$currWindow = getPosAndSize -windowName $target[4]
$weightX = $currWindow[2]/$target[2]
$weightY = $currWindow[3]/$target[3]

Show-Window $target[4]

for($i=20;$i -ge 1;$i--){
    $Position = [system.windows.forms.cursor]::Position
    $PositionChangeX = (($target[0] * $weightX) - $Position.x)/$i
    $PositionChangeY = (($target[1] * $weightY) - $Position.y)/$i

    [system.windows.forms.cursor]::Position = New-Object system.drawing.point(($Position.x + $PositionChangeX + $currWindow[0]), ($Position.y + $PositionChangeY + $currWindow[1]))

    if($i -ge 2){start-sleep -m 25}
}
start-sleep -m 20
}
#use case:
#moveCursorToSpot -targetX 960 -targetY 540

function Click-MouseButtonLeft{
    $signature=@' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 

    $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru 

        $SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0);
        start-sleep -m 20
        $SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0);
}

#use case:
#Click-MouseButtonLeft

function Click-MouseButtonRight
{
    $signature=@' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 

    $SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru 

        $SendMouseClick::mouse_event(0x00000008, 0, 0, 0, 0);
        start-sleep -m 20
        $SendMouseClick::mouse_event(0x00000010, 0, 0, 0, 0);
}

#use case:
#Click-MouseButtonRight

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Window {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool GetClientRect(IntPtr hWnd, out RECT lpRect);
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ClientToScreen(IntPtr hWnd, ref POINT lpPoint);
}
public struct RECT
{
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}
public struct POINT
{
    public int x;
    public int y;
}
"@

function getPosAndSize{
param($windowName)
$Handle = (Get-Process -Name $windowName).MainWindowHandle
$ClientRect = New-Object RECT
$Position = New-Object POINT
$Size = New-Object POINT

[Window]::GetClientRect($Handle, [ref]$ClientRect) | out-null
$Position.x = 0 # $ClientRect.Left is always 0
$Position.y = 0 # $ClientRect.Top
$Size.x = $ClientRect.Right
$Size.y = $ClientRect.Bottom
[Window]::ClientToScreen($Handle, [ref]$Position) | out-null

$PosAndSize = @($Position.x, $Position.y, $Size.x, $Size.y)
return $PosAndSize
}
#use case:
#getPosAndSize -windowName LeagueClientUx


#Main Script
$inputTime = Read-Host -Prompt '輸入投降時間(分鐘，不輸入為掛到10分鐘):'
$inputRounds = Read-Host -Prompt '輸入重複回數(不輸入為掛到上限50次):'
$inputRestartTime = Read-Host -Prompt '你英雄聯盟客戶端的開啟時間(秒，不輸入即設置為60秒，建議設定較長時間):'

if(($inputTime -eq 0) -or ($inputTime -eq "")){
$inputTime = 10}else{
$timeout = new-timespan -Minutes $inputTime}
if(($inputRounds -gt 50) -or ($inputRounds -eq "")){
$inputRounds = 50
"已更改為上限50回"}
if($inputRestartTime -eq ""){$inputRestartTime = 60}

$overQueueTime = new-timespan -Minutes 20
$skipOnce = $false
$roundCount = 1

:skipAll while ($roundCount -le $inputRounds){
    "Start loop $inputRounds, Looking for Client..."
    if (!($processClient)){
		$processClient = Get-Process | Where-Object {$_.ProcessName -eq $targetClient}
        "Client not found, please open Client and ready in lobby first!"
        Break skipAll
    }
    "Client found"
	if ($processClient){
		"auto accept process start!"
        $overqueue = [diagnostics.stopwatch]::StartNew()
        :skipQueue while(!($processGame)){
            $processClient = Get-Process | Where-Object {$_.ProcessName -eq $targetClient}
            if($overqueue.elapsed -gt $overQueueTime){
                $processClient | Stop-Process -Force
                Show-Window "Garena"
                start-sleep -s 5
                $currentWindow = getPosAndSize -windowName Garena
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($($garenaStart[0]+$currentWindow[0]), $($garenaStart[1]+$currentWindow[1]))
                Click-MouseButtonLeft
                start-sleep -s 2
                $currentWindow = getPosAndSize -windowName Garena
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($($garenaClose[0]+$currentWindow[0]), $($garenaClose[1]+$currentWindow[1]))
                Click-MouseButtonLeft
                start-sleep -s $inputRestartTime

                Show-Window "LeagueClientUx"
                $currentWindow = getPosAndSize -windowName LeagueClientUx
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($($restartLobby[0]+$currentWindow[0]), $($restartLobby[1]+$currentWindow[1]))
                Click-MouseButtonLeft
                start-sleep -s 5
                $currentWindow = getPosAndSize -windowName LeagueClientUx
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($($restartMode[0]+$currentWindow[0]), $($restartMode[1]+$currentWindow[1]))
                Click-MouseButtonLeft
                start-sleep -s 5
                $currentWindow = getPosAndSize -windowName LeagueClientUx
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($($restartNormal[0]+$currentWindow[0]), $($restartNormal[1]+$currentWindow[1]))
                Click-MouseButtonLeft
                start-sleep -s 5
                $skipOnce = $true
                Break skipQueue
            }

            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if($processGame){Break}
            Show-Window "LeagueClientUx"
            $currentWindow = getPosAndSize -windowName LeagueClientUx
            [system.windows.forms.cursor]::Position = New-Object system.drawing.point($($queueStart[0]+$currentWindow[0]), $($queueStart[1]+$currentWindow[1]))
            Show-Window "LeagueClientUx"
            Click-MouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if($processGame){Break}
            Show-Window "LeagueClientUx"
            $currentWindow = getPosAndSize -windowName LeagueClientUx
            [system.windows.forms.cursor]::Position = New-Object system.drawing.point($($queueAccept[0]+$currentWindow[0]), $($queueAccept[1]+$currentWindow[1]))
            Show-Window "LeagueClientUx"
            Click-MouseButtonLeft
            start-sleep -s 2
        }
        if($skipOnce -eq $false){
        "auto accept process finished, auto surrender process start!"
        $timesup = [diagnostics.stopwatch]::StartNew()
        start-sleep -s 10
        while($timesup.elapsed -lt $timeout){
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            #buy chessman
            moveCursorToSpot -target $slot1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $slot2
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $slot3
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $slot4
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $slot5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            #collect loot
            moveCursorToSpot -target $battlefield1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonRight
            start-sleep -s 5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $battlefield2
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonRight
            start-sleep -s 5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $battlefield3
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonRight
            start-sleep -s 5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $battlefield4
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonRight
            start-sleep -s 1
        }
        while($true){
            #surrender
            moveCursorToSpot -target $buttonConfig
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $buttonSurrend
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $buttonConfirm
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot -target $buttonCancel
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            Click-MouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            #will stop when game closed
        }}
	}
    if($skipOnce -eq $false){
    $roundCount++
    }elseif($skipOnce -eq $true){
    $skipOnce = $false
    }
}
Read-Host "Press Enter to exit..."
exit