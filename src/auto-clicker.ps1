$signature = @'
[DllImport("user32.dll")]
public static extern int SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

[DllImport("user32.dll")]
public static extern bool SetCursorPos(int X, int Y);

public struct INPUT
{
  public int type;
  public MOUSEINPUT mi;
}

public struct MOUSEINPUT
{
  public int dx;
  public int dy;
  public uint mouseData;
  public uint dwFlags;
  public uint time;
  public IntPtr dwExtraInfo;
}
'@

Add-Type -MemberDefinition $signature -Name "Win32API" -Namespace Win32Functions

# Constants
$INPUT_MOUSE = 0
$MOUSEEVENTF_LEFTDOWN = 0x0002
$MOUSEEVENTF_LEFTUP = 0x0004

# Coordinates (adjust these as needed)
$x = 450
$y = 420

Start-Sleep -Seconds 1

# Main loop
while ($true) {
  # Move cursor
  $null = [Win32Functions.Win32API]::SetCursorPos($x, $y)

  # Create INPUT structure for mouse down
  $inputDown = New-Object Win32Functions.Win32API+INPUT
  $inputDown.type = $INPUT_MOUSE
  $inputDown.mi = New-Object Win32Functions.Win32API+MOUSEINPUT
  $inputDown.mi = @{
    dwFlags = $MOUSEEVENTF_LEFTDOWN 
  }

  # Create INPUT structure for mouse up
  $inputUp = New-Object Win32Functions.Win32API+INPUT
  $inputUp.type = $INPUT_MOUSE
  $inputUp.mi = New-Object Win32Functions.Win32API+MOUSEINPUT
  $inputUp.mi = @{
    dwFlags = $MOUSEEVENTF_LEFTUP 
  }

  # Perform left click down
  $inputSize = [System.Runtime.InteropServices.Marshal]::SizeOf([Type]$inputDown.GetType())
  $null = [Win32Functions.Win32API]::SendInput(1, @($inputDown), $inputSize)

  # Hold for 1 second
  Start-Sleep -Seconds 1

  # Perform left click up
  $null = [Win32Functions.Win32API]::SendInput(1, @($inputUp), $inputSize)

  # Wait before next click (adjust as needed)
  Start-Sleep -Milliseconds 100
}