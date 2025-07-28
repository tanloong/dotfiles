#Requires AutoHotkey v2.0.2
#SingleInstance Force

#Z::Run "WindowsTerminal.exe"
#X::Run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

#C::Run "D:\software\Libreoffice\program\soffice.exe"
#A::Run "D:\Program Files\Tencent\WeChat\WeChat.exe"
#Q::Run "D:\software\QQ\QQ.exe"
#P::Run "Keepass.exe"
#F::Run "D:\software\飞书\Feishu\Feishu.exe"

SetNumLockState "AlwaysOff"
SetCapsLockState "AlwaysOff"
CapsLock::Return
CapsLock & h::Left
CapsLock & j::Down
CapsLock & k::Up
CapsLock & l::Right
CapsLock & i::Backspace

; `::~
; ~::``

RShift::\
\::|
!V::Send("!{F4}")

; 将 Ctrl+Space 映射为 Alt+Shift
getIMEMode(hWnd) {
DetectHiddenWindows True
ret := SendMessage(
    0x283,  ; Message : WM_IME_CONTROL
    0x001,  ; wParam  : IMC_GETCONVERSIONMODE
    0,      ; lParam  ： (NoArgs)
    ,       ; Control ： (Window)
    ; 获取当前输入法的模式
    "ahk_id " DllCall("imm32\ImmGetDefaultIMEWnd", "Uint", hWnd, "Uint")
    )
DetectHiddenWindows False
return ret
}
^Space::
{
    try {
        hWnd := WinGetID("A")
    } catch Error {
        ; ^Esc 开始菜单弹窗，卡死在找不到当前窗口
        return
    }
    ; 微软五笔 1025-0
    ; 英文键盘 1
    if (getIMEMode(hWnd) == 1) {
      Send "{CTRL up}{ALT down}{SHIFT down}{SHIFT up}{ALT up}"
      Sleep 50
      if (getIMEMode(hWnd) != 1025) {
        Send "{CTRL up}{SHIFT}"
      }
    } else {
      Send "{CTRL up}{SHIFT}"
    }
}

F11::Run "D:\software\controlmymonitor\ControlMyMonitor.exe /ChangeValue Primary 10 -5"
F12::Run "D:\software\controlmymonitor\ControlMyMonitor.exe /ChangeValue Primary 10 5"
F9::Run "D:\software\controlmymonitor\ControlMyMonitor.exe /ChangeValue Secondary 10 -5"
F10::Run "D:\software\controlmymonitor\ControlMyMonitor.exe /ChangeValue Secondary 10 5"

RAlt::Left
RWin::Down
RCtrl::Right

; For 61 keyboard
^$SC01A::Send("``") ; CTRL+[ `
^SC01A::~ ; CTRL+SHIFT+[ ~

Shift & Space::Return
