[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=e8d8af74-bdd9-45bd-8993-112bbaf04f8b
Description=��̨����
Enable=0
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
'Call RunApp("C:\Program Files\China Mobile\Fetion\Fetion.exe")
Delay 1000
//=================================================================================
//�һ�ͼ�����
Hwnd=Plugin.Window.Find(0,"����2012")
TracePrint "����2012=" & Hwnd
//=================================================================================
//��������Ǽ����
Call Plugin.Window.Active(Hwnd)
TracePrint "��ǰ�����"
//��������ǵõ���ǰ��ǰ��Ĵ��ھ��
Hwnd = Plugin.Window.Foreground()
TracePrint "�õ���ǰ��ǰ��Ĵ��ھ��Ϊ��" & Hwnd
//������������ش���
Call Plugin.Window.Hide(Hwnd)
TracePrint "��ǰ���ش���"

Rect = Plugin.Window.GetClientRect(Hwnd)
TracePrint "�õ����ھ���Ŀͻ�����СΪ��" & Rect
//����������ڷָ��ַ���,���������������ֳ������ַ���
XYArray = Split(Rect, "|", -1, 1)
//������佫�ַ���ת������ֵ
dx = XYArray(0)
dy = XYarray(1)
TracePrint dx & ":" & dy

//1259,503  CBB79D

'Call Plugin.Bkgnd.LeftClick(Hwnd, 1259 - dx, 503 - dy)


Call Plugin.Bkgnd.LeftClick(Hwnd, 68, 471)
TracePrint "�򿪷����Ŵ���"

Hwnd_fdx=Plugin.Window.Find(0,"������")
TracePrint "������=" & Hwnd_fdx

Call Plugin.Window.Hide(Hwnd_fdx)
TracePrint "��ǰ���ش���"


Call Plugin.Bkgnd.LeftClick(Hwnd_fdx, 41, 44)
TracePrint "�򿪷����Ŵ���"




'Call Plugin.Bkgnd.LeftClick(Hwnd, 96, 470)
'TracePrint "����ϵ�˴���"


EndScript


//�����������ʾ����
'Call Plugin.Window.Show(Hwnd)
'MessageBox "��ǰ��ʾ����"


//�һ�ͼ�����
'fdx_Hwnd = Plugin.Window.Find(0, "������")
'TracePrint "������=" & fdx_Hwnd
fdx_Hwnd = Plugin.Window.FindEx(Hwnd, fdx_Hwnd, "FxWnd", "������")
TracePrint "������=" & fdx_Hwnd

Call Plugin.Window.Hide(fdx_Hwnd)
TracePrint "��ǰ���ش���"

MessageBox ""

fdx_Rect = Plugin.Window.GetClientRect(fdx_Hwnd)
TracePrint "�õ����ھ���Ŀͻ�����СΪ��" & fdx_Rect
//����������ڷָ��ַ���,���������������ֳ������ַ���
fdx_XYArray = Split(fdx_Rect, "|", -1, 1)
//������佫�ַ���ת������ֵ
fdx_dx = fdx_XYArray(0)
fdx_dy = fdx_XYArray(1)
TracePrint fdx_dx & ":" & fdx_dy

//682,371  808080
Call Plugin.Bkgnd.LeftClick(fdx_Hwnd, 685 - fdx_dx, 371 - fdx_dy)

Call Plugin.Bkgnd.SendString(fdx_Hwnd, "13611913741")

'Call Plugin.Bkgnd.KeyPress(fdx_Hwnd, "Enter")

//610,399  FFFFFF
Call Plugin.Bkgnd.LeftClick(fdx_Hwnd, 615 - fdx_dx, 399 - fdx_dy)

Call Plugin.Bkgnd.SendString(fdx_Hwnd, "�һ�ͼ�����")


//933,522  E5E3DF
'Call Plugin.Bkgnd.LeftClick(Hwnd, 933 - fdx_dx, 522 - fdx_dy)

Call Plugin.Window.Show(fdx_Hwnd)

Call Plugin.Window.Show(Hwnd)

EndScript
