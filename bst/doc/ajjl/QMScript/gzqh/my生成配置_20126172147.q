[General]
SyntaxVersion=2
BeginHotkey=50
BeginHotkeyMod=2
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=8c28ab4e-7818-4fb4-82ba-e34f5e637d3d
Description=my��������
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
Rem �ű���ʼ
'LogStart "D:\log.txt"



//������� 
//ʱ�� 52,42  FFFFFF
//��λ 52,78  3232FF
//���� 52,114  3232FF
//�ǵ� 52,150  3232FF
//�ǵ��� 41 186 3232FF
//�ɽ��� 52,222  00C0C0
//�ֲ��� 52,258  00C0C0
//���̼� 890,49  00FFFF
//�����	825,49  FFFFFF
//���̼� 890,67  00FFFF
//�����	825,67  FFFFFF
//���̼� 890,139  00FFFF
//�����	825,139  FFFFFF
//558,85  000000
//558,139  000000

qx = 558
qy = 139

num = 4
txtColor = "00FFFF"
txtHight = 10
txtWidth = 6
txtSplit = 2
dotIndex = 1
dotWidth = 2

confFile="D:\tmp.ini"
numText = - 1 

section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit

Call Lib.gzqh._create_conf()
'LogStop

EndScript


