[General]
SyntaxVersion=2
BeginHotkey=49
BeginHotkeyMod=2
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=ba0cc98b-a1d5-428d-b8e1-bcfb8fc64bf6
Description=myֹ��ҵ�
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
Dim wt(8)
'wt (0) ί�к�
'wt (1) ״̬
'wt (2) ��Լ
'wt (3) ����
'wt (4) ��ƽ
'wt (5) ί�м۸�
'wt (6) ί��
'wt (7) ����

Dim ccj(12)
'ccj (0) //�ʲ��ʺ�
'ccj (1) //�ɽ�����
'ccj (2) //�ɽ����
'ccj (3) //ί�к�
'ccj (4) //��Լ
'ccj (5) //����
'ccj (6) //��ƽ
'ccj (7) //�ɽ��۸�
'ccj (8) //����
'ccj (9) //�ɽ�ʱ��
'ccj (10) //���ױ���
'ccj (11) //������

Dim ccj_conf(7)
'ccj_conf(0) //qx
'ccj_conf(1) //qy
'ccj_conf(2) //num
'ccj_conf(3) //txtColor
'ccj_conf(4) //txtHight
'ccj_conf(5) //txtWidth
'ccj_conf(6) //confFile


'ֹ��ҵ�
'F3����ί��ҳ��
Call ����ί��ҳ���ѯ�ɽ�״̬()


'F6����ɽ�ҳ��
Call ����ɽ�ҳ���ѯ�ɽ��۸� ()

'F3����ί��ҳ��
Call ����ί��ҳ���´�ֹ��()	


Function  ����ί��ҳ���ѯ�ɽ�״̬()
	'�ȴ�ί�е��ɽ�
		'��ȡί�кţ�״̬����Լ����������ƽ��ί�м۸񣬳���
	wt(0) = 0 'ί�к�
	wt (2) =IF1206 '��Լ
	wt (3) ="����" '����
	wt (4) ="����" '��ƽ
End Function

Function ����ɽ�ҳ���ѯ�ɽ��۸�()
	'����ί�кţ���Լ����������ƽ��ѯ�ɽ��۸�����
	'��ȡ��һ���ɽ���¼ͨ���Ƚ��ж��Ƿ�ƥ�䣬���ؽ��
	ccj(2) = ccj2() '�ɽ����
	MessageBox ccj(2)
End Function

Function ����ί��ҳ���´�ֹ��()
	'���ݺ�Լ����������ƽ���ɽ��۸���������Ӧ��ֹ�𵥡�
End Function

Function ccj2()
	Rem �ű���ʼ
//1117,135
//�������
qx=165
qy = 392
num = 4
txtColor = "000000"
txtHight = 10
txtWidth = 5
confFile="D:\conf.ini"

ccj2 = ocrtext()

End Function


Function ocrtext()
	
//1117,135
//�������
qx=ccj_conf(0)
qy = ccj_conf(1)
num = ccj_conf(2)
txtColor = ccj_conf(3)
txtHight = ccj_conf(4)
txtWidth = ccj_conf(5)
confFile=ccj_conf(6)
numText = - 1 
ocrtext = ""

section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth
    
    //��ʼֵ
    i=0
    While i < num
    	qx = qx - txtWidth
        //��ʼֵ
        Name = qx & "|" & qy
        key=""
        //ɨ��������ɫ������
        y=0
        While y<txtHight
            x=0
            While x<5
                IfColor qx+x,qy+y,txtColor,1
                    //����������
                    key = key & 1
                Else                 
                    key = key & 0
                End If
                x=x+1
            Wend
            y=y+1
        Wend
    
    MessageBox key
	numText = Plugin.File.ReadINI(section, key, confFile)


	ocrtext = ocrtext & numText


        qx = qx - 1
        i = i + 1

   Wend

End Function
