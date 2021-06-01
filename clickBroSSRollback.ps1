#Author:地表上最強男人ü 2021-05-30
#Everyone is wellcome to contribute except those who abuse it

$softwareVersion = "0.1.6"

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
$garenaStart =   @( 480, 691, 1022, 718, "Garena", "Garena - 遊戲中心" )
$garenaClose =   @( 633, 407, 1022, 718, "Garena", "Garena - 遊戲中心" )

$queueStart =    @( 728, 841, 1600, 900, "LeagueClientUx", "League of Legends" )
$queueAccept =   @( 790, 700, 1600, 900, "LeagueClientUx", "League of Legends" )
$queueSkip =     @( 723, 450, 1600, 900, "LeagueClientUx", "League of Legends" )
$restartLobby =  @( 149, 51 , 1600, 900, "LeagueClientUx", "League of Legends" )
$restartMode =   @( 780, 274, 1600, 900, "LeagueClientUx", "League of Legends" )
#$restartNormal = @( 679, 620, 1600, 900, "LeagueClientUx", "League of Legends" )

$slot1 =         @( 570 , 1000, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$slot2 =         @( 784 , 1000, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$slot3 =         @( 982 , 1000, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$slot4 =         @( 1187, 1000, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$slot5 =         @( 1384, 1000, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$buttonConfig =  @( 1904, 886, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$buttonSurrend = @( 767 , 845, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$buttonConfirm = @( 835 , 485, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$buttonCancel =  @( 1289, 846, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$battlefield1 =  @( 1306, 651, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$battlefield2 =  @( 1304, 237, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$battlefield3 =  @( 598 , 240, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )
$battlefield4 =  @( 1306, 651, 1920, 1080, "League of Legends", "League of Legends (TM) Client" )

#don't know what this does but can't delete
[System.Reflection.Assembly]::LoadWithPartialName("system.windows.forms")

$targetClient = "LeagueClient"
$targetGame = "League of Legends"
$processClient = Get-Process | Where-Object {$_.ProcessName -eq $targetClient}
$processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}

$focusWindow = New-Object -ComObject wscript.shell
#$focusWindow.AppActivate($ProcessName)
function showWindowOld {
    param (
        [Parameter(Mandatory)]
        [string] $ProcessName
    )
    $focusProcess = Get-Process | Where-Object {$_.ProcessName -eq $ProcessName}
    if($focusProcess){$focusWindow.AppActivate($ProcessName)}
}
#use case:

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

function showWindow3000 {
    param(
        [Parameter(Mandatory)]
        $target3000
    )
    $ShowWindowCheck = Get-Process | Where-Object {$_.ProcessName -eq $target3000[4]}
    if($ShowWindowCheck){
        Show-Window $target3000[4]
    }else {
        "Show window failed and canceled"
    }
}

function moveCursorToSpot{
    param(
    [Parameter(Mandatory)]
    $target
  )

    $currWindow = getPosAndSize -windowName $target[4]
    #比例差
    $weightX = $currWindow[2]/$target[2]
    $weightY = $weightX
    $cordX = $target[0] * $weightX + $currWindow[0]
    $cordY = $target[1] * $weightY + $currWindow[1]

    for($i=20;$i -ge 1;$i--){
        $Position = [system.windows.forms.cursor]::Position
        $PositionChangeX = (($cordX - $Position.x)/$i)+ $Position.x
        $PositionChangeY = (($cordY - $Position.y)/$i)+ $Position.y

        [system.windows.forms.cursor]::Position = New-Object system.drawing.point($PositionChangeX, $PositionChangeY)

        if($i -ge 2){start-sleep -m 25}
    }
    start-sleep -m 20
}
#use case:
#moveCursorToSpot $target

function ClickMouseButtonLeft{
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
#ClickMouseButtonLeft

function ClickMouseButtonRight
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
#ClickMouseButtonRight

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
Get-Process $windowName | Set-WindowState -State RESTORE
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

function Set-WindowState {
	<#
	.LINK
	https://gist.github.com/Nora-Ballard/11240204
	#>

	[CmdletBinding(DefaultParameterSetName = 'InputObject')]
	param(
		[Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
		[Object[]] $InputObject,

		[Parameter(Position = 1)]
		[ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE',
					 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED',
					 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
		[string] $State = 'SHOW'
	)

	Begin {
		$WindowStates = @{
			'FORCEMINIMIZE'		= 11
			'HIDE'				= 0
			'MAXIMIZE'			= 3
			'MINIMIZE'			= 6
			'RESTORE'			= 9
			'SHOW'				= 5
			'SHOWDEFAULT'		= 10
			'SHOWMAXIMIZED'		= 3
			'SHOWMINIMIZED'		= 2
			'SHOWMINNOACTIVE'	= 7
			'SHOWNA'			= 8
			'SHOWNOACTIVATE'	= 4
			'SHOWNORMAL'		= 1
		}

		$Win32ShowWindowAsync = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@ -Name "Win32ShowWindowAsync" -Namespace Win32Functions -PassThru

		if (!$global:MainWindowHandles) {
			$global:MainWindowHandles = @{ }
		}
	}

	Process {
		foreach ($process in $InputObject) {
			if ($process.MainWindowHandle -eq 0) {
				if ($global:MainWindowHandles.ContainsKey($process.Id)) {
					$handle = $global:MainWindowHandles[$process.Id]
				} else {
					Write-Error "Main Window handle is '0'"
					continue
				}
			} else {
				$handle = $process.MainWindowHandle
				$global:MainWindowHandles[$process.Id] = $handle
			}

			$Win32ShowWindowAsync::ShowWindowAsync($handle, $WindowStates[$State]) | Out-Null
			Write-Verbose ("Set Window State '{1} on '{0}'" -f $MainWindowHandle, $State)
		}
	}
}
#use case:
#Get-Process notepad | Set-WindowState -State RESTORE
#Get-Process notepad | Set-WindowState -State MAXIMIZE
#Get-Process notepad | Set-WindowState -State MINIMIZE

#Main Script
"提醒使用者, 切勿從非官方網址下載, 以免中毒, 請支持'Click Bro 精神續作'"
"我們不會入侵你的電腦, 更不會竊取遊戲資料, 請安心使用"
"Click Bro 精神續作官方網址為 : https://github.com/nico12313/ClickBroSpiritualSuccessor"
"如果有任何非法、觸法行為, 請告知我們, 我們將立即改善."
"============================================================"
"本軟體版本:v$softwareVersion"
$inputTime = Read-Host -Prompt '輸入投降時間(分鐘，不輸入即預設為10分鐘):'
$inputRounds = Read-Host -Prompt '輸入重複回數(不輸入即預設為掛到上限50次):'
$inputRestartTime = Read-Host -Prompt '英雄聯盟客戶端重啟所需時間(秒，不輸入即預設為60秒，建議設定較長時間):'

if(($inputTime -eq 0) -or ($inputTime -eq "")){$inputTime = 10}
$timeout = new-timespan -Minutes $inputTime
if(($inputRounds -gt 50) -or ($inputRounds -eq "")){
$inputRounds = 50
"已更改為上限50回"}
if($inputRestartTime -eq ""){$inputRestartTime = 60}

$overQueueTime = new-timespan -Minutes 20
$skipOnce = $false
$roundCount = 1

:skipAll while ($roundCount -le $inputRounds){
    "Start loop $roundCount / $inputRounds, Looking for Client..."
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
                showWindow3000 $garenaStart
                start-sleep -s 5
                $currentWindow = getPosAndSize -windowName Garena
                $cWWeightX = $currentWindow[2]/$garenaStart[2]
                $cWWeightY = $currentWindow[3]/$garenaStart[3]
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($garenaStart[0] * $cWWeightX) +$currentWindow[0]), $(($garenaStart[1] * $cWWeightY)+$currentWindow[1]))
                ClickMouseButtonLeft
                start-sleep -s 2
                $currentWindow = getPosAndSize -windowName Garena
                $cWWeightX = $currentWindow[2]/$garenaClose[2]
                $cWWeightY = $currentWindow[3]/$garenaClose[3]
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($garenaClose[0] * $cWWeightX)+$currentWindow[0]), $(($garenaClose[1] * $cWWeightY)+$currentWindow[1]))
                ClickMouseButtonLeft

                start-sleep -s $inputRestartTime

                showWindow3000 $restartLobby
                $currentWindow = getPosAndSize -windowName LeagueClientUx
                $cWWeightX = $currentWindow[2]/$restartLobby[2]
                $cWWeightY = $currentWindow[3]/$restartLobby[3]
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($restartLobby[0] * $cWWeightX)+$currentWindow[0]), $(($restartLobby[1] * $cWWeightY)+$currentWindow[1]))
                ClickMouseButtonLeft
                start-sleep -s 3
                $currentWindow = getPosAndSize -windowName LeagueClientUx
                $cWWeightX = $currentWindow[2]/$restartMode[2]
                $cWWeightY = $currentWindow[3]/$restartMode[3]
                [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($restartMode[0] * $cWWeightX)+$currentWindow[0]), $(($restartMode[1] * $cWWeightX)+$currentWindow[1]))
                ClickMouseButtonLeft
                start-sleep -s 3
                $skipOnce = $true
                Break skipQueue
            }
            :skipConclution while($true){
                $processClient = Get-Process | Where-Object {$_.ProcessName -eq $targetClient}
                if($processClient){
                    showWindow3000 $queueSkip
                    Start-Sleep -Seconds 5
                    $currentWindow = getPosAndSize -windowName LeagueClientUx
                    $cWWeightX = $currentWindow[2]/$queueSkip[2]
                    $cWWeightY = $currentWindow[3]/$queueSkip[3]
                    [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($queueSkip[0] * $cWWeightX)+$currentWindow[0]), $(($queueSkip[1] * $cWWeightY)+$currentWindow[1]))
                    ClickMouseButtonLeft
                    start-sleep -s 5
                    showWindow3000 $restartLobby
                    $currentWindow = getPosAndSize -windowName LeagueClientUx
                    $cWWeightX = $currentWindow[2]/$restartLobby[2]
                    $cWWeightY = $currentWindow[3]/$restartLobby[3]
                    [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($restartLobby[0] * $cWWeightX)+$currentWindow[0]), $(($restartLobby[1] * $cWWeightY)+$currentWindow[1]))
                    ClickMouseButtonLeft
                    start-sleep -s 3
                    $currentWindow = getPosAndSize -windowName LeagueClientUx
                    $cWWeightX = $currentWindow[2]/$restartMode[2]
                    $cWWeightY = $currentWindow[3]/$restartMode[3]
                    [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($restartMode[0] * $cWWeightX)+$currentWindow[0]), $(($restartMode[1] * $cWWeightX)+$currentWindow[1]))
                    ClickMouseButtonLeft
                    start-sleep -s 3
                    Break skipConclution
                }
            }
            while($true){
                $processClient = Get-Process | Where-Object {$_.ProcessName -eq $targetClient}
                if($processClient){
                    $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
                    if($processGame){Break skipQueue}
                    showWindow3000 $queueStart
                    $currentWindow = getPosAndSize -windowName LeagueClientUx
                    $cWWeightX = $currentWindow[2]/$queueStart[2]
                    $cWWeightY = $currentWindow[3]/$queueStart[3]
                    [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($queueStart[0] * $cWWeightX)+$currentWindow[0]), $(($queueStart[1] * $cWWeightY)+$currentWindow[1]))
                    ClickMouseButtonLeft
                    start-sleep -s 1
                    $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
                    if($processGame){Break skipQueue}
                    showWindow3000 $queueAccept
                    $currentWindow = getPosAndSize -windowName LeagueClientUx
                    $cWWeightX = $currentWindow[2]/$queueAccept[2]
                    $cWWeightY = $currentWindow[3]/$queueAccept[3]
                    [system.windows.forms.cursor]::Position = New-Object system.drawing.point($(($queueAccept[0] * $cWWeightX)+$currentWindow[0]), $(($queueAccept[1] * $cWWeightY)+$currentWindow[1]))
                    ClickMouseButtonLeft
                    start-sleep -s 2
                }
            }
        }
        if($skipOnce -eq $false){
        "auto accept process finished, auto surrender process start!"
        $timesup = [diagnostics.stopwatch]::StartNew()
        start-sleep -s 10
        while($timesup.elapsed -lt $timeout){
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            #buy chessman
            moveCursorToSpot $slot1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $slot2
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $slot3
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -m 20
            ClickMouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $slot4
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -m 200
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $slot5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            #collect loot
            moveCursorToSpot $battlefield1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonRight
            start-sleep -s 5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $battlefield2
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonRight
            start-sleep -s 5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $battlefield3
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonRight
            start-sleep -s 5
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $battlefield4
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonRight
            start-sleep -s 1
        }
        while($true){
            #surrender
            moveCursorToSpot $buttonConfig
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $buttonSurrend
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $buttonConfirm
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            moveCursorToSpot $buttonCancel
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            ClickMouseButtonLeft
            start-sleep -s 1
            $processGame = Get-Process | Where-Object {$_.ProcessName -eq $targetGame}
            if(!($processGame)){Break}
            #will stop when game closed
        }
        }
	}
    if($skipOnce -eq $false){
    $roundCount++
    }elseif($skipOnce -eq $true){
    $skipOnce = $false
    }
}
Read-Host "輸入Enter鍵結束..."
exit