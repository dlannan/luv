
set BASE_INCLUDE=/I. /Iutil
set LINK_FLAGS=/link /DLL

set DEFS=/DSOKOL_GLCORE /D_WIN32 /D_USRDLL /D_WINDLL /D_SLOG_WINDOWS

call cl.exe %BASE_INCLUDE% %DEFS% /Fe:bin\sokol_dll.dll lib\sokol-dll.c %LINK_FLAGS%

@REM <<<<<<<<<< DO NOT RE-ENABLE: FOR REFERENCE ONLY >>>>>>>>>>>>>>
@REM First build imgui and cimgui - DOnt use imgui. It is C++ without proper C bindings. Not worth the hassle (and its a mess too)
@REM call cl.exe /c /I. /Iutil /Ilib/imgui /DSOKOL_GLCORE /D_WIN32 /Fe:bin\imgui.obj lib\imgui_lib.cpp
@REM lib /nologo /out:imgui.lib imgui_lib.obj 
@REM call cl.exe /c /I. /Iutil /Ilib/cimgui /Ilib /Ilib/imgui /DSOKOL_GLCORE /D_WIN32 /Fe:bin\cimgui.obj lib\cimgui\cimgui.cpp lib\imgui_lib.cpp lib\cimgui_lib.cpp
@REM lib /nologo /out:cimgui.lib cimgui.obj 
@REM call cl.exe /Ilib /Ilib/cimgui %BASE_INCLUDE% %DEFS% /Fe:bin\sokol_imgui_dll.dll lib\sokol-imgui-dll.c %LINK_FLAGS% /LIBPATH:"." "imgui.lib" "cimgui.lib"

del *.obj
del *.lib
