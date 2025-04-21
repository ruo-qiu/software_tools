@echo off
setlocal enabledelayedexpansion

:: ��ȡ�ű����ڵ�Ŀ¼
set "script_dir=%~dp0"

:: ��� game �ļ����Ƿ����
if not exist "%script_dir%game\" (
    echo The "game" folder does not exist in the current directory.
    pause
    exit /b
)

:: �����ʱ�ļ�
if exist "%script_dir%temp_list.txt" del "%script_dir%temp_list.txt"

:: ��ȡ game �ļ��������п�ִ���ļ���.url�ļ�������������
dir "%script_dir%game\*.exe" "%script_dir%game\*.url" "%script_dir%game\*.lnk" /b /a-d /o-n > "%script_dir%temp_list.txt"

:: ��ȡ�ļ��б���ʾ
set /a count=0
echo.
echo ######################��ѡ��Ҫ�򿪵���Ϸ######################
echo.
for /f "tokens=*" %%i in (%script_dir%temp_list.txt) do (
    set /a count+=1
    set "file_name=%%~ni"
    echo ----------------------!count!. !file_name!
)
echo.
:: ��ʾ�û��������
set /p choice="����Ҫ����Ϸ����ţ�"

:: ��������Ƿ���Ч
if "%choice%"=="" (
    echo Invalid input.
    del %script_dir%temp_list.txt
    pause
    exit /b
)

:: �����û���������������Ӧ�ĳ���
set /a line_num=0
for /f "tokens=*" %%i in (%script_dir%temp_list.txt) do (
    set /a line_num+=1
    if !line_num! equ %choice% (
        set "file_name=%script_dir%game\%%i"
        set "file_extension=%%~xi"
        start "" "!file_name!"
        
        :: ����ļ���׺Ϊ.url�����ٴ�wa.lnk
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

:: �����ų�����Χ
echo Invalid number.
del %script_dir%temp_list.txt
pause
exit /b