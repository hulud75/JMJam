param(
	[string]$name = "shaman",
	[string]$lovePath
)
if (!$lovePath) { $lovePath = where.exe love }
$files = Get-ChildItem -Path .
Compress-Archive $files "$name.zip"
Rename-Item "$name.zip" "$name.love"
cmd /c copy /b "$lovePath+$name.love" "$name.exe"
Remove-Item "$name.love"
$loveDir = (Get-Item $LovePath).Directory.FullName

$compressArgs = @{
	Path = "$name.exe",
		(Join-Path $loveDir "SDL2.dll"),
		(Join-Path $loveDir "OpenAL32.dll"),
		(Join-Path $loveDir "license.txt"),
		(Join-Path $loveDir "love.dll"),
		(Join-Path $loveDir "lua51.dll"),
		(Join-Path $loveDir "mpg123.dll"),
		(Join-Path $loveDir "msvcp120.dll"),
		(Join-Path $loveDir "msvcr120.dll")
	DestinationPath = "$name.zip"
}
Compress-Archive @compressArgs
Remove-Item "$name.exe"
