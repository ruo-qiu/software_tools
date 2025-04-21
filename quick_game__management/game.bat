@echo off
setlocal enabledelayedexpansion

:: 获取脚本所在的目录
set "script_dir=%~dp0"

:: 检查 game 文件夹是否存在
if not exist "%script_dir%game\" (
    echo The "game" folder does not exist in the current directory.
    pause
    exit /b
)

:: 清空临时文件
if exist "%script_dir%temp_list.txt" del "%script_dir%temp_list.txt"

:: 获取 game 文件夹下所有可执行文件和.url文件并按名称排序
dir "%script_dir%game\*.exe" "%script_dir%game\*.url" "%script_dir%game\*.lnk" /b /a-d /o-n > "%script_dir%temp_list.txt"

:: 读取文件列表并显示
set /a count=0
echo.
echo ######################请选择要打开的游戏######################
echo.
for /f "tokens=*" %%i in (%script_dir%temp_list.txt) do (
    set /a count+=1
    set "file_name=%%~ni"
    echo ----------------------!count!. !file_name!
)
echo.
:: 提示用户输入序号
set /p choice="输入要打开游戏的序号："

:: 检查输入是否有效
if "%choice%"=="" (
    echo Invalid input.
    del %script_dir%temp_list.txt
    pause
    exit /b
)

:: 根据用户输入的序号启动对应的程序
set /a line_num=0
for /f "tokens=*" %%i in (%script_dir%temp_list.txt) do (
    set /a line_num+=1
    if !line_num! equ %choice% (
        set "file_name=%script_dir%game\%%i"
        set "file_extension=%%~xi"
        start "" "!file_name!"
        
        :: 如果文件后缀为.url，则再打开wa.lnk
        if "!file_extension!"==".url" (
            if exist "%script_dir%wa.lnk" (
                start "" "%script_dir%wa.lnk"
            ) else (
                echo wa.lnk does not exist in the current directory.
            )
        )
        del %script_dir%temp_list.txt
        exit /b
    )
)

:: 如果序号超出范围
echo Invalid number.
del %script_dir%temp_list.txt
pause
exit /b