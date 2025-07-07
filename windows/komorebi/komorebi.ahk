; ^ CTRL ! Alt # Windows

#Requires AutoHotkey v2.0.2
#SingleInstance Force

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

!V::Komorebic("close")

; !h::Komorebic("focus left")
; !j::Komorebic("focus down")
; !k::Komorebic("focus up")
; !l::Komorebic("focus right")

!k::Komorebic("cycle-focus previous")
!j::Komorebic("cycle-focus next")

; Move windows
!+h::Komorebic("move left")
!+j::Komorebic("move down")
!+k::Komorebic("move up")
!+l::Komorebic("move right")

; Stack windows
!Left::Komorebic("stack left")
!Down::Komorebic("stack down")
!Up::Komorebic("stack up")
!Right::Komorebic("stack right")
!;::Komorebic("unstack")
; ![::Komorebic("cycle-stack previous")
; !]::Komorebic("cycle-stack next")

; Resize
!-::Komorebic("resize-axis horizontal increase")
!+::Komorebic("resize-axis horizontal decrease")
!+=::Komorebic("resize-axis vertical increase")
!+_::Komorebic("resize-axis vertical decrease")

; Manipulate windows
!+Space::Komorebic("toggle-float")
!m::Komorebic("toggle-monocle")
!t::Komorebic("toggle-monocle")

; Window manager options
!+r::Komorebic("retile")
!p::Komorebic("toggle-pause")

; Layouts

; Workspaces
!1::Komorebic("focus-workspace 0")
!2::Komorebic("focus-workspace 1")
!3::Komorebic("focus-workspace 2")
!4::Komorebic("focus-workspace 3")
!5::Komorebic("focus-workspace 4")
!6::Komorebic("focus-workspace 5")
!7::Komorebic("focus-workspace 6")
!8::Komorebic("focus-workspace 7")

; Move windows across workspaces
!+1::Komorebic("move-to-workspace 0")
!+2::Komorebic("move-to-workspace 1")
!+3::Komorebic("move-to-workspace 2")
!+4::Komorebic("move-to-workspace 3")
!+5::Komorebic("move-to-workspace 4")
!+6::Komorebic("move-to-workspace 5")
!+7::Komorebic("move-to-workspace 6")
!+8::Komorebic("move-to-workspace 7")
!+9::Komorebic("move-to-workspace 8")

; last workspace
!Esc::Komorebic("focus-last-workspace")

!Enter::Komorebic("promote")

#Z::Run "WindowsTerminal.exe"
#X::Run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

#C::Run "D:\software\Libreoffice\program\soffice.exe"
#A::Run "D:\Program Files\Tencent\WeChat\WeChat.exe"
#Q::Run "D:\software\QQ\QQ.exe"
#P::Run "Keepass.exe"

SetCapsLockState "AlwaysOff" 
CapsLock::Return
CapsLock & h::Send "{Left}"
CapsLock & j::Send "{Down}"
CapsLock & k::Send "{Up}"
CapsLock & l::Send "{Right}"
CapsLock & i::Send "{Backspace}"

; 将 Ctrl+Space 映射为 Alt+Shift
^Space::Send "{CTRL up}{ALT down}{SHIFT down}{SHIFT up}{ALT up}"

RShift::\
\::|
; swap ~ and `
`::~
~::Send("``")
; !V::Send("!{F4}")

