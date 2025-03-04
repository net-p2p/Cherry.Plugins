@echo off
setlocal

set "highestVersion="
set "highestVersionFile="

for /f "delims=" %%a in ('dir /b /a-d "p2pInstall-v*.exe"') do (
    echo Processing file: %%a

    for /f "tokens=2 delims=-vx." %%b in ("%%a") do (
        set "versionString=%%b.%%c"
        echo Version String: %versionString%

        powershell -Command "$version = [version] '%versionString%'; if ($version -gt [version] '%highestVersion%') { Write-Host 'New highest version found: %versionString%' }"
        if ERRORLEVEL 1 (
          echo powershell error.
          exit /b
        )

        powershell -Command "$version = [version] '%versionString%'; if ($version -gt [version] '%highestVersion%') { $global:highestVersion = '%versionString%'; $global:highestVersionFile = '%%a' }"
        if ERRORLEVEL 1 (
          echo powershell error.
          exit /b
        )
    )
)

if defined highestVersionFile (
  echo 最高版本文件: "%highestVersionFile%"
  start "" "%highestVersionFile%" /silent 
) else (
  echo 没有找到 p2pInstall 开头的 .exe 文件
)

endlocal
pause
exit
