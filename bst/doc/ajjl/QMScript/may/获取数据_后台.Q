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
MacroID=25fc3ed6-8adc-44a2-8788-254342a1aaaf
Description=��ȡ����_��̨
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



'==========�����ǰ�������¼�Ƶ�����==========
Dim sj

'hHangQin = Plugin.Window.Find(0, "��̩�������ǰ�V9.08 - [���ͼ-����1207]")
hHangQin = Plugin.Window.Find(0, "����1207(IF1207) 2012��05��21�� ����һ PageUp/Down:ǰ���� ͨ����(R)")
TracePrint "���ھ��" & hHangQin

'Call Plugin.Window.Min(hHangQin)
'TracePrint "��С����ǰ����"

'Call Plugin.Window.Hide(hHangQin)
'TracePrint "��ǰ���ش���"

Call Plugin.Window.Move(hHangQin, 0, 0)
TracePrint "�ƶ����ڵ�ԭ��"

Rect = Plugin.Window.GetClientRect(hHangQin)
TracePrint "�õ����ھ���Ŀͻ�����СΪ��" & Rect
//����������ڷָ��ַ���,���������������ֳ������ַ���
MyArray = Split(Rect, "|")
//������佫�ַ���ת������ֵ
L = Clng(MyArray(0)): T = Clng(MyArray(1))
R = Clng(MyArray(2)) : B = Clng(MyArray(3))
	
'Call Plugin.Bkgnd.LeftDoubleClick(hHangQin, 213, 167)
'Call Plugin.Bkgnd.LeftDoubleClick(hHangQin, 213 - L, 167 - T)
'Delay 2000

/*
MoveTo 213, 167
LeftDoubleClick 1
Delay 2000

MoveTo 1100, 215
Delay 20
LeftClick 1
Delay 200
*/

Call Plugin.Bkgnd.LeftClick(hHangQin, 59 - L, 265 - T)
TracePrint "�����ʼλ��"
'MoveTo 59, 265
Delay 10
'LeftClick 1
	
'���ڼ��������
'Call Plugin.Bkgnd.KeyPress(hHangQin, "34")
'TracePrint "���ڼ��������"


'KeyPress "PageDown", 1

'Call Plugin.Office.OpenXls("D:\sj.xls")
'TracePrint "��Excel"

'Call save_head()
'TracePrint "�������"

row = 2

For 2

Call save_tian(hHangQin, L, T)
TracePrint "���浱������"

'�л�����һҳ
Call Plugin.Bkgnd.KeyPress(hHangQin, "34")
TracePrint "�л�����һҳ"
'KeyPress "PageDown", 1
Delay 10

Next
	
'Call Plugin.Office.CloseXls()
'TracePrint "�ر�Excel"

EndScript


Function save_tian(hHangQin, L, T)
	'��ʼ��һ��
	While sj <> "15:14"
		Call Plugin.Bkgnd.KeyPress(hHangQin, "39")
		TracePrint "�л���һʱ��"
		'KeyPress "Right", 1
		Delay 10
		Call save_fen(hHangQin, L, T)
		TracePrint "���浱ǰʱ����Ϣ"
		row = row + 1
	Wend
	sj=""
End Function


'==========�����ǰ�������¼�Ƶ�����==========


Function save_head()
	
	Call Plugin.Office.WriteXls(1, 1, 2, "ʱ��")
	Call Plugin.Office.WriteXls(1, 1, 3, "��λ")
	Call Plugin.Office.WriteXls(1, 1, 4, "����")
	Call Plugin.Office.WriteXls(1, 1, 5, "�ǵ�")
	Call Plugin.Office.WriteXls(1, 1, 6, "�Ƿ�")
	Call Plugin.Office.WriteXls(1, 1, 7, "�ɽ���")
	Call Plugin.Office.WriteXls(1, 1, 8, "�ֲ���")
	
End Function


Function save_fen(hHangQin, L, T)

	sj = Lib.gzqh._data_sj(hHangQin, L, T)
	jw = Lib.gzqh._data_jw(hHangQin, L, T)
	jj =  Lib.gzqh._data_jj(hHangQin, L, T)
	zd = Lib.gzqh._data_zd(hHangQin, L, T)
	zf = Lib.gzqh._data_zf(hHangQin, L, T)
	cjl = Lib.gzqh._data_cjl(hHangQin, L, T)
	ccl = Lib.gzqh._data_ccl(hHangQin, L, T)
	
	TracePrint "�������:" & sj & "|" & jw & "|" & jj & "|" & zd & "|" & zf & "|" & cjl & "|" & ccl
	
	'Call Plugin.Office.WriteXls(1, row, 2, sj)
	'Call Plugin.Office.WriteXls(1, row, 3, jw)
	'Call Plugin.Office.WriteXls(1, row, 4, jj)
	'Call Plugin.Office.WriteXls(1, row, 5, zd)
	'Call Plugin.Office.WriteXls(1, row, 6, zf)
	'Call Plugin.Office.WriteXls(1, row, 7, cjl)
	'Call Plugin.Office.WriteXls(1, row, 8, ccl)
	
End Function

