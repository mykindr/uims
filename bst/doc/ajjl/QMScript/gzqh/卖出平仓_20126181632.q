[General]
SyntaxVersion=2
BeginHotkey=39
BeginHotkeyMod=10
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=7e5a72b5-d515-41b7-847a-5625e8433840
Description=����ƽ��
Enable=1
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
'�۸�����
UserVar price_o = "2579.0"	"���̼�"
price_f = Lib.gzqh.dtj() 
price_c = Lib.gzqh.ztj() 

'�ҵ�����
Dim act_conf(5)

'����ƽ��
Call lib.gzqh._sc()

'==========�����ǰ�������¼�Ƶ�����==========
