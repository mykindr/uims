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
MacroID=ea1c5c57-3c20-40fa-a05b-ea938d76e40d
Description=���̿���
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
h_MLMain = Plugin.Window.Find(0, "��̩����ģ�⽻��(V3.0.8.1017)--��5070083��")
TracePrint "��ô��ھ��:" & h_MLMain

Call Plugin.Window.Hide(h_MLMain)
TracePrint "���ص�ǰ����"

Delay 200

Rect = Plugin.Window.GetClientRect(h_MLMain)
TracePrint "�õ����ھ���Ŀͻ�����СΪ��" & Rect

Delay 200

//����������ڷָ��ַ���,���������������ֳ������ַ���
MyArray = Split(Rect, "|")
//������佫�ַ���ת������ֵ
L = Clng(MyArray(0)) : T = Clng(MyArray(1))
R = Clng(MyArray(2)) : B = Clng(MyArray(3))
TracePrint "X:" & L & " Y:" & T

Delay 200


'==========�����ǰ�������¼�Ƶ�����==========
'�۸�����
price_o = Lib.gzqh.kpj(h_MLMain, L, T)
TracePrint "���̼�:" & price_o


TracePrint "��ʾ��ǰ����"
Delay 3000
Call Plugin.Window.Show(h_MLMain)

EndScript

price_s = Lib.gzqh.zjs(h_MLMain, L, T)
TracePrint "�����:" & price_s
price_f = Lib.gzqh.dtj()
TracePrint "��ͣ��:" & price_f
price_c = Lib.gzqh.ztj() 
TracePrint "��ͣ��:" & price_c


If price_o > price_s Then 
	jc = price_o - price_s
	TracePrint "�߿�:" & jc
Else 
	jc = price_s - price_o
	TracePrint "�׿�:" & jc
End If

'�ҵ�����
Dim act_conf(5)

'����ƽ��
Call lib.gzqh._sc()

'==========�����ǰ�������¼�Ƶ�����==========
