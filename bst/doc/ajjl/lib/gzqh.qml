[General]
SyntaxVersion=2
MacroID=ba34b6d9-30ae-43ee-b5ed-c59101e18ada
[Comment]

[Script]

Function _data_ccl_b(hHangQin, L, T)
	//�ֲ��� 52,258  00C0C0
	qx=52
	qy = 258
	num = 7
	txtColor = "00C0C0"
	txtHight = 10
	txtWidth = 6
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int_b(hHangQin, L, T)
	_data_ccl = numText

End Function


Function _data_ccl()
	//�ֲ��� 52,258  00C0C0
	qx=52
	qy = 258
	num = 7
	txtColor = "00C0C0"
	txtHight = 10
	txtWidth = 6
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	_data_ccl = numText

End Function


Function _data_cjl_b(hHangQin, L, T)
	//�ɽ��� 52,222  00C0C0
	qx=52
	qy = 222
	num = 7
	txtColor = "00C0C0"
	txtHight = 10
	txtWidth = 6
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int_b(hHangQin, L, T)
	_data_cjl = numText

End Function

Function _data_cjl()
	//�ɽ��� 52,222  00C0C0
	qx=52
	qy = 222
	num = 7
	txtColor = "00C0C0"
	txtHight = 10
	txtWidth = 6
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	_data_cjl = numText

End Function


Function _data_zf_b(hHangQin, L, T)
	//�ǵ��� 41 186 3232FF
	qx=41
	qy = 186
	num = 5
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 2
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3_b(hHangQin, L, T)
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3_b(hHangQin, L, T)
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3_b(hHangQin, L, T)
		End If
	End If
	
	_data_zf = numText

End Function


Function _data_zf()
	//�ǵ��� 41 186 3232FF
	qx=41
	qy = 186
	num = 5
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 2
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3()
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3()
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3()
		End If
	End If
	
	_data_zf = numText

End Function

Function _data_zd_b(hHangQin, L, T)
	//�ǵ� 52,150  3232FF
	qx=52
	qy = 150
	num = 6
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 1
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3_b(hHangQin, L, T)
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3_b(hHangQin, L, T)
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3_b(hHangQin, L, T)
		End If
	End If
	
	_data_zd = numText

End Function


Function _data_zd()
	//�ǵ� 52,150  3232FF
	qx=52
	qy = 150
	num = 6
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 1
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3()
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3()
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3()
		End If
	End If
	
	_data_zd = numText

End Function


Function _data_jj_b(hHangQin, L, T)
	//���� 52,114  3232FF
	qx=52
	qy = 114
	num = 6
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 1
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3_b(hHangQin, L, T)
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3_b(hHangQin, L, T)
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3_b(hHangQin, L, T)
		End If
	End If
	
	_data_jj = numText

End Function


Function _data_jj()
	//���� 52,114  3232FF
	qx=52
	qy = 114
	num = 6
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 1
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3()
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3()
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3()
		End If
	End If
	
	_data_jj = numText

End Function


Function _data_jw_b(hHangQin, L, T)
	//��λ 52,78  3232FF
	qx=52
	qy = 78
	num = 6
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 1
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3_b(hHangQin, L, T)
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3_b(hHangQin, L, T)
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3_b(hHangQin, L, T)
		End If
	End If
	
	_data_jw = numText

End Function

Function _data_jw()
	//��λ 52,78  3232FF
	qx=52
	qy = 78
	num = 6
	txtColor = "3232FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 1
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3()
	
	If numText = "" Then 
		txtColor = "00E600"
		Call _parser_int3()
		If numText = "" Then 
			txtColor = "FFFFFF"
			Call _parser_int3()
		End If
	End If
	
	_data_jw = numText

End Function


Function _data_sj_b(hHangQin, L, T)
	//ʱ�� 52,42  FFFFFF
	qx=52
	qy = 42
	num = 5
	txtColor = "FFFFFF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 2
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3_b(hHangQin, L, T)
	_data_sj = numText

End Function


Function _data_sj()
	//ʱ�� 52,42  FFFFFF
	qx = 52
	qy = 42
	num = 5
	txtColor = "FFFFFF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 2
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int3()
	_data_sj = numText

End Function


Function ccj_sxf()
	//625,385  000000 ��ɽ� �ɽ�����
	qx=625
	qy = 385
	num = 7
	txtColor = "000000"
	txtHight = 10
	txtWidth = 5
	confFile = "D:\conf.ini"
	txtSplit = 1
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	ccj_sxf = numText

End Function

Function ccj_cjjg()
	//421,385  000000 ��ɽ� �ɽ�����
	qx=421
	qy = 385
	num = 7
	txtColor = "000000"
	txtHight = 10
	txtWidth = 5
	confFile = "D:\conf.ini"
	txtSplit = 1
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	ccj_cjjg = numText

End Function

Function ccj_hy()
	//272,385  000000 ��ɽ� ��Լ
	qx=272
	qy = 385
	num = 6
	txtColor = "000000"
	txtHight = 10
	txtWidth = 5
	confFile = "D:\conf.ini"
	txtSplit = 1
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	ccj_hy = numText

End Function

Function ccj_cjrq()
	//114,385  000000 ��ɽ� �ɽ�����
	qx=114
	qy = 385
	num = 8
	txtColor = "000000"
	txtHight = 10
	txtWidth = 5
	confFile = "D:\conf.ini"
	txtSplit = 1
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	ccj_cjrq = numText

End Function


Function _s_bo()
	'����-����
	Call _bo()
End Function

'����-����
Function _s_bo2()
	'����-����
	Call _bo2()
	'����ֹ����
	Call _bo2_guard_line()
End Function


'ִ��ֹ���߹ҵ� ����
Function _bo2_guard_line()
	Dim smsTxt
	Dim cjPrice
	Dim ycjPrice
	Dim newPrice
	
	
	'��ɽ���¼��ȡ�ɽ��۸�
	cjPrice = _getCJPrice()
	smsTxt = " ���ǿ��ּ۸�:" & cjPrice
	
	newPrice = cjPrice - 5
	TracePrint "����ֹ��۸�" & newPrice
	
	'�´�ֹ��ҵ�
	TracePrint "�´�ֹ��ҵ�"
	Call _sc0(newPrice)
		
	newPrice = cjPrice + 10
	TracePrint "����ֹӯ�۸�" & newPrice
	
	'�´�ֹӯ�ҵ�
	TracePrint "�´�ֹӯ�ҵ�"
	Call _sc0(newPrice)
	
	'��ѯԤ�µ��ɽ��۸�
	ycjPrice = _getYCJPrice()
	TracePrint "��ѯԤ�µ��ɽ��۸�:" & ycjPrice
	smsTxt = smsTxt & " ƽ�ּ۸�:" & ycjPrice
	
	'���㱾�β���ӯ��
	yk = cjPrice - ycjPrice
	If yk < 0 Then 
		'ֹӯ
		TracePrint "ӯ��:" & abs(yk) & "��"
		smsTxt = smsTxt & " ӯ��:" & abs(yk) & "��"
	Else 
		'ֹ��
		TracePrint "����:" & yk & "��"
		smsTxt = smsTxt & " ����:" & yk & "��"
	End If	
	
	'���Ͷ���
	TracePrint "���Ͷ���:" & smsTxt
	sendSMS(smsTxt)
	
End Function

'���ö��Žӿڷ��Ͷ���
Function sendSMS(smsTxt)
	Delay 2000
	
End Function
	

Function _getCJPrice()
	'��ί��ҳ��ѭ���ȴ��ɽ�״̬
	Do While _getCJState()
		Delay 100
	Loop
	
	Delay 200
	
	'ȥ�ɽ�ҳ���ѯ�ɽ��۸�
	TracePrint "ȥ�ɽ�ҳ���ѯ�ɽ��۸�"
	MoveTo 193, 765
	Delay 10
	LeftClick 1
	Delay 10
	
	_getCJPrice = "2000.0"
	
	'��ȡ�ɽ��۸�
	TracePrint "��ȡ�ɽ��۸�" & _getCJPrice
	Delay 200
End Function


Function _getYCJPrice()
	'��ί��ҳ��ѭ���ȴ��ɽ�״̬
	Do While _getYCJState()
		Delay 100
	Loop
	
	Delay 200
	
	'ȥ�ɽ�ҳ���ѯ�ɽ��۸�
	TracePrint "ȥ�ɽ�ҳ���ѯ�ɽ��۸���"
	MoveTo 193, 765
	Delay 10
	LeftClick 1
	Delay 10
	
	_getYCJPrice = "2050.0"
	
	'��ȡ�ɽ��۸�
	TracePrint "��ȡ�ɽ��۸�" & _getYCJPrice
	Delay 200
End Function

'���״̬����ѳɣ�����false
Function _getCJState()
	TracePrint "��ȡ�ɽ�״̬�ɹ�"
	Delay 200
	
	_getCJState = 0	'false
End Function

'���״̬����ѳɣ�����false
'����Ҫ��ѯ�����ļ۸�
Function _getYCJState()
	TracePrint "��ȡԤ��ɽ�״̬�ɹ�"
	Delay 200
	
	_getCJState = 0	'false
End Function

'����-ƽ��
Function _bc()
	'����-ƽ��
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "1"		'����
	act_conf(2) = "2"		'ƽ��
	act_conf(3) = price_c - 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action()
End Function

'����-ƽ��
Function _bc2()
	'����-ƽ��
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "1"		'����
	act_conf(2) = "2"		'ƽ��
	act_conf(3) = price_c - 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action2()
End Function

'����-ƽ��
Function _bc0(newPrice)
	'����-ƽ��
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "1"		'����
	act_conf(2) = "2"		'ƽ��
	act_conf(3) = newPrice	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action2()
End Function



'����-����
Function _so()
	'����-����
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "2"		'����
	act_conf(2) = "1"		'����
	act_conf(3) = price_f + 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action()
End Function


'����-����
Function _s_so2()
	'����-����
	Call _so2()
	
	'����ֹ����
	Call _so2_guard_line()
End Function


'ִ��ֹ���߹ҵ� ����
Function _so2_guard_line()
	Dim smsTxt
	Dim cjPrice
	Dim ycjPrice
	Dim newPrice
	
	
	'��ɽ���¼��ȡ�ɽ��۸�
	cjPrice = _getCJPrice()
	smsTxt = " �������ּ۸�:" & cjPrice
	
	newPrice = cjPrice + 5
	TracePrint "����ֹ��۸�" & newPrice
	
	'�´�ֹ��ҵ�
	TracePrint "�´�ֹ��ҵ�"
	Call _bc0(newPrice)
		
	newPrice = cjPrice - 10
	TracePrint "����ֹӯ�۸�" & newPrice
	
	'�´�ֹӯ�ҵ�
	TracePrint "�´�ֹӯ�ҵ�"
	Call _bc0(newPrice)
	
	'��ѯԤ�µ��ɽ��۸�
	ycjPrice = _getYCJPrice()
	TracePrint "��ѯԤ�µ��ɽ��۸�:" & ycjPrice
	smsTxt = smsTxt & " ƽ�ּ۸�:" & ycjPrice
	
	'���㱾�β���ӯ��
	yk = cjPrice - ycjPrice
	If yk > 0 Then 
		'ֹӯ
		TracePrint "ӯ��:" & yk & "��"
		smsTxt = smsTxt & " ӯ��:" & abs(yk) & "��"
	Else 
		'ֹ��
		TracePrint "����:" & abs(yk) & "��"
		smsTxt = smsTxt & " ����:" & yk & "��"
	End If	
	
	'���Ͷ���
	TracePrint "���Ͷ���:" & smsTxt
	sendSMS(smsTxt)
	
End Function


'����-����
Function _so2()
	'����-����
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "2"		'����
	act_conf(2) = "1"		'����
	act_conf(3) = price_f + 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action2()
End Function


'����-ƽ��
Function _sc()
	'����-ƽ��
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "2"		'����
	act_conf(2) = "2"		'ƽ��
	act_conf(3) = price_f + 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action()
End Function

'����-ƽ��
Function _sc2()
	'����-ƽ��
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "2"		'����
	act_conf(2) = "2"		'ƽ��
	act_conf(3) = price_f + 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action2()
End Function

'����-ƽ��
Function _sc0(newPrice)
	'����-ƽ��
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "2"		'����
	act_conf(2) = "2"		'ƽ��
	act_conf(3) = newPrice	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action2()
End Function


'����-����
Function _bo()
	'����-����
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "1"		'����
	act_conf(2) = "1"		'����
	act_conf(3) = price_c - 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action()
End Function


'����-����
Function _bo2()
	'����-����
	act_conf(0) = "IF1207"	'��Լ
	act_conf(1) = "1"		'����
	act_conf(2) = "1"		'����
	act_conf(3) = price_c - 5	'�۸�
	act_conf(4) = "1"		'ί��
	
	'ִ�в���
	Call _action2()
End Function


Function _action2()
	'��λ�á��н��ǩҳ
	'MoveTo 256, 277
	'Delay 10
	'LeftDoubleClick 1
	'��λ�á�ί��F3
	'MoveTo 23, 299
	MoveTo 42, 765
	Delay 10
	LeftClick 1
	Delay 10
	'��λ�á���ƷĿ¼�ڶ���
	'MoveTo 44, 74
	'Delay 10
	'LeftDoubleClick 1
	'Delay 10
	'��λ�á���Լ����
	'MoveTo 1547, 331
	MoveTo 1280, 789
	Delay 10
	LeftClick 1
	Delay 10
	KeyPress "BackSpace", 1
	Delay 10
	'��Լ����
	SayString act_conf(0)
	Delay 10
	KeyPress "Tab", 1
	Delay 10
	'����
	SayString act_conf(1)
	Delay 10
	KeyPress "Tab", 1
	Delay 10
	'����
	SayString act_conf(2)
	Delay 10
	KeyPress "Tab", 1
	Delay 10
	'ί�м۸�
	'TracePrint act_conf(3)
	SayString act_conf(3)
	Delay 10
	KeyPress "Tab", 1
	Delay 10
	'ί��
	SayString act_conf(4)
	Delay 10
	'KeyPress "Tab", 1
	'Delay 10
	'MoveTo 1495, 456
	MoveTo 1346, 914
	Delay 10
	'ȷ���ύ
	LeftClick 1
	Delay 10
	KeyPress "BackSpace", 1
	Delay 10
End Function



Function _action()
	'��λ�á��н��ǩҳ
	MoveTo 256, 277
	Delay 10
	LeftDoubleClick 1
	'��λ�á�ί��F3
	MoveTo 23, 299
	Delay 10
	LeftClick 1
	Delay 10
	'��λ�á���ƷĿ¼�ڶ���
	MoveTo 44, 74
	Delay 10
	LeftDoubleClick 1
	Delay 10
	'��λ�á���Լ����
	MoveTo 1547, 331
	Delay 10
	LeftClick 1
	Delay 10
	'��Լ����
	SayString act_conf(0)
	Delay 10
	KeyDown "Tab", 1
	Delay 10
	KeyUp "Tab", 1
	Delay 10
	'����
	SayString act_conf(1)
	Delay 10
	KeyDown "Tab", 1
	Delay 10
	'����
	SayString act_conf(2)
	Delay 10
	KeyDown "Tab", 1
	Delay 10
	KeyUp "Tab", 1
	Delay 10
	'ί�м۸�
	'TracePrint act_conf(3)
	SayString act_conf(3)
	Delay 10
	KeyDown "Tab", 1
	Delay 10
	KeyUp "Tab", 1
	Delay 10
	'ί��
	SayString act_conf(4)
	Delay 10
	KeyDown "Tab", 1
	Delay 10
	KeyUp "Tab", 1
	Delay 10
	MoveTo 1495, 456
	Delay 10
	'ȷ���ύ
	LeftClick 1
	Delay 10
End Function


'���-�����б�
'qx
'qy
'num
'txtWidth
'txtHight
'txtColor
'dotIndex
'dotWidth
'section
'confFile
'txtSplit
Function _create_conf2()
    
    //��ʼֵ
    i=0
    While i < num
    
    	If i <> dotIndex Then 
    		realWidth = txtWidth
    		
    		Else 
    		realWidth = dotWidth
    		
    	End If    	
    
    	qx = qx - realWidth
        //��ʼֵ
        Name = qx & "|" & qy
        key=""
        //ɨ��������ɫ������
        y = 0
        While y < txtHight
            x = 0
            While x < realWidth
                IfColor qx + x,qy + y,txtColor,2
                    //����������
                    key = key & 1
                Else                 
                    key = key & 0
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend

	Call Plugin.File.WriteINI(section,key,Name,confFile) 

    qx = qx - txtSplit
    i = i + 1

   Wend
   Rem ����
    
End Function


'���-�����б�
'qx
'qy
'num
'txtWidth
'txtHight
'txtColor
'section
'confFile
'txtSplit
Function _create_conf()
    
    //��ʼֵ
    i=0
    While i < num
    
    
    	qx = qx - txtWidth
        //��ʼֵ
        Name = qx & "|" & qy
        key=""
        //ɨ��������ɫ������
        y = 0
        While y < txtHight
            x=0
            While x < txtWidth
                IfColor qx + x,qy + y,txtColor,2
                    //����������
                    key = key & 1
                Else                 
                    key = key & 0
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend

		Call Plugin.File.WriteINI(section,key,Name,confFile) 
	
    	qx = qx - txtSplit
    	i = i + 1

   Wend
   Rem ����
    
End Function


'���-�����б�
'qx
'qy
'num
'txtWidth
'txtHight
'txtColor
'section
'confFile
'txtSplit
Function _create_conf3()

	Dim x(6)
	x(0)=0
	x(1)=0
	x(2)=4
	x(3)=0
	x(4)=2
	x(5)=3
	x(6)=1
	Dim y(6)
	y(0)=2
	y(1)=3
	y(2)=3
	y(3)=4
	y(4)=5
	y(5)=5
	y(6)=6
	
	section = "m:f|color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
    
    //��ʼֵ
    i=0
    While i < num
    
    
    	qx = qx - txtWidth
        //��ʼֵ
        Name = qx & "|" & qy
        key = ""
        
        j = 0
        For UBound(x) + 1
        	TracePrint qx + x(j) & ":" & qy + y(j) & ":" & txtColor
        	IfColor qx + x(j), qy + y(j), txtColor, 2
                //����������
                key = key & 1
            Else                 
                key = key & 0
            End If
            j = j + 1
        Next
		TracePrint key
		Call Plugin.File.WriteINI(section,Name,key,confFile) 

    	qx = qx - txtSplit
    	i = i + 1

   Wend
   Rem ����
    
End Function




Function _parser_int3()
    
	Dim x(6)
	x(0)=0
	x(1)=0
	x(2)=4
	x(3)=0
	x(4)=2
	x(5)=3
	x(6)=1
	Dim y(6)
	y(0)=2
	y(1)=3
	y(2)=3
	y(3)=4
	y(4)=5
	y(5)=5
	y(6) = 6
	
	
    f_qx = qx
    f_qy = qy
    
    
	section = "m:f|color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
    numText = ""
    //��ʼֵ
    i = 0
    While i < num
    
    
    	If i <> dotIndex Then 
    		realWidth = txtWidth
    		f_qx = f_qx - realWidth
    		
        	//��ʼֵ
        	Name = f_qx & "|" & f_qy
        	key = ""
        	
    		j = 0
        	For UBound(x) + 1
        		'TracePrint f_qx + x(j) & ":" & f_qy + y(j) & ":" & txtColor
        		IfColor f_qx + x(j), f_qy + y(j), txtColor, 2
                	//����������
                	key = key & 1
            	Else                 
                	key = key & 0
            	End If
            	j = j + 1
        	Next
    	Else 
    		realWidth = dotWidth    	
    
    		f_qx = f_qx - realWidth
    		
        	//��ʼֵ
        	Name = f_qx & "|" & f_qy
        	key = ""
        	
        	//ɨ��������ɫ������
        	yy = 0
        	While yy < txtHight
            	xx = 0
            	While xx < realWidth
                	IfColor f_qx + xx, f_qy + yy, txtColor,2
                    	//����������
                    	key = key & 1
                	Else                 
                    	key = key & 0
                	End If
                	xx = xx + 1
            	Wend
            	yy = yy + 1
        	Wend
    	End If
        
    'TracePrint key
    
	numText = Plugin.File.ReadINI(section, key, confFile) & numText
    'TracePrint "section:" & section & "key:" & key 
    f_qx = f_qx - txtSplit
    i = i + 1

   Wend
   Rem ����
   
   '����
   'TracePrint _parser_int2
End Function


Function _parser_int3_b(hHangQin, L, T)
    
	Dim x(6)
	x(0)=0
	x(1)=0
	x(2)=4
	x(3)=0
	x(4)=2
	x(5)=3
	x(6)=1
	Dim y(6)
	y(0)=2
	y(1)=3
	y(2)=3
	y(3)=4
	y(4)=5
	y(5)=5
	y(6) = 6
	
	
    f_qx = qx
    f_qy = qy
    
    
	section = "m:f|color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
    numText = ""
    //��ʼֵ
    i = 0
    While i < num
    
    
    	If i <> dotIndex Then 
    		realWidth = txtWidth
    		f_qx = f_qx - realWidth
    		
        	//��ʼֵ
        	Name = f_qx & "|" & f_qy
        	key = ""
        	
    		j = 0
        	For UBound(x) + 1
        		'TracePrint f_qx + x(j) & ":" & f_qy + y(j) & ":" & txtColor
        		pColor = Plugin.BkgndColor.GetPixelColor(hHangQin, f_qx + x(j) - L, f_qy + y(j) - T)
        		If hex(pColor) = txtColor Then
        		'IfColor f_qx + x(j), f_qy + y(j), txtColor, 2
                	//����������
                	key = key & 1
            	Else                 
                	key = key & 0
            	End If
            	j = j + 1
        	Next
    	Else 
    		realWidth = dotWidth    	
    
    		f_qx = f_qx - realWidth
    		
        	//��ʼֵ
        	Name = f_qx & "|" & f_qy
        	key = ""
        	
        	//ɨ��������ɫ������
        	yy = 0
        	While yy < txtHight
            	xx = 0
            	While xx < realWidth
        			pColor = Plugin.BkgndColor.GetPixelColor(hHangQin, f_qx + xx - L, f_qy + yy - T)
        			If hex(pColor) = txtColor Then
                	'IfColor f_qx + xx, f_qy + yy, txtColor,2
                    	//����������
                    	key = key & 1
                	Else                 
                    	key = key & 0
                	End If
                	xx = xx + 1
            	Wend
            	yy = yy + 1
        	Wend
    	End If
        
    'TracePrint key
    
	numText = Plugin.File.ReadINI(section, key, confFile) & numText
    'TracePrint "section:" & section & "key:" & key 
    f_qx = f_qx - txtSplit
    i = i + 1

   Wend
   Rem ����
   
   '����
   'TracePrint _parser_int2
End Function


Function _parser_int1(h_MLMain, L, T)
    
    f_qx = qx
    f_qy = qy
    
    
	'section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
    numText = ""
    //��ʼֵ
    i = 0
    While i < num
    
    
    	realWidth = txtWidth
    
    	f_qx = f_qx - realWidth
    	
        //��ʼֵ
        Name = f_qx & "|" & f_qy
        key=""
        //ɨ��������ɫ������
        y = 0
        While y < txtHight
            x = 0
            While x < realWidth
            	'pColor = Plugin.BkgndColor.GetPixelColor(h_MLMain, f_qx + x - L, f_qy + y - T)
            	pColor =  Plugin.Bkgnd.GetPixelColor(h_MLMain, f_qx + x - L, f_qy + y - T)
        		If pColor = txtColor Then
                'IfColor f_qx + x, f_qy + y, txtColor,2
                    //����������
                    key = key & 1
                Else                 
                    key = key & 0
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend
        
	numText = Plugin.File.ReadINI(section, key, confFile) & numText
    TracePrint "color:" & pColor & " section:" & section & " key:" & key & " f_qx:" & f_qx & " f_qy:" & f_qy
    f_qx = f_qx - txtSplit
    i = i + 1

   Wend
   Rem ����
   
   '����
   'TracePrint _parser_int2
End Function


Function _parser_int2()
    
    f_qx = qx
    f_qy = qy
    
    
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
    numText = ""
    //��ʼֵ
    i = 0
    While i < num
    
    
    	If i <> dotIndex Then 
    		realWidth = txtWidth
    		
    		Else 
    		realWidth = dotWidth
    		
    	End If    	
    
    	f_qx = f_qx - realWidth
    	
        //��ʼֵ
        Name = f_qx & "|" & f_qy
        key=""
        //ɨ��������ɫ������
        y = 0
        While y < txtHight
            x = 0
            While x < realWidth
                IfColor f_qx + x, f_qy + y, txtColor,2
                    //����������
                    key = key & 1
                Else                 
                    key = key & 0
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend
        
	numText = Plugin.File.ReadINI(section, key, confFile) & numText
    'TracePrint "section:" & section & "key:" & key 
    f_qx = f_qx - txtSplit
    i = i + 1

   Wend
   Rem ����
   
   '����
   'TracePrint _parser_int2
End Function



Function _parser_int()
    
	Dim x(6)
	x(0)=0
	x(1)=0
	x(2)=4
	x(3)=0
	x(4)=2
	x(5)=3
	x(6)=1
	Dim y(6)
	y(0)=2
	y(1)=3
	y(2)=3
	y(3)=4
	y(4)=5
	y(5)=5
	y(6) = 6
	
	section = "m:f|color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
    
    //��ʼֵ
    i = 0
    While i < num
    	qx = qx - txtWidth
        //��ʼֵ
        Name = qx & "|" & qy
        key = ""
        
        j = 0
        For UBound(x) + 1
        	'TracePrint qx + x(j) & ":" & qy + y(j) & ":" & txtColor
        	IfColor qx + x(j), qy + y(j), txtColor, 2
                //����������
                key = key & 1
            Else                 
                key = key & 0
            End If
            j = j + 1
        Next
        
        /*
        //ɨ��������ɫ������
        y = 0
        While y < txtHight
            x = 0
            While x < txtWidth
                IfColor qx + x,qy + y,txtColor,2
                    //����������
                    key = key & 1
                Else                 
                    key = key & 0
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend
        */
	numText = Plugin.File.ReadINI(section, key, confFile) & numText

    qx = qx - txtSplit
    i = i + 1

   Wend
   Rem ����
   
   '����
   'MsgBox numText
    
End Function

Function _parser_int_b(hHangQin, L, T)
    
	Dim x(6)
	x(0)=0
	x(1)=0
	x(2)=4
	x(3)=0
	x(4)=2
	x(5)=3
	x(6)=1
	Dim y(6)
	y(0)=2
	y(1)=3
	y(2)=3
	y(3)=4
	y(4)=5
	y(5)=5
	y(6) = 6
	
	Dim pColor
	
	section = "m:f|color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
    
    //��ʼֵ
    i = 0
    While i < num
    	qx = qx - txtWidth
        //��ʼֵ
        Name = qx & "|" & qy
        key = ""
        
        j = 0
        For UBound(x) + 1
        	'TracePrint qx + x(j) & ":" & qy + y(j) & ":" & txtColor
        	pColor = Plugin.BkgndColor.GetPixelColor(hHangQin, qx + x(j) - L, qy + y(j) - T)
        	If hex(pColor) = txtColor Then
        	'IfColor qx + x(j), qy + y(j), txtColor, 2
                //����������
                key = key & 1
            Else                 
                key = key & 0
            End If
            j = j + 1
        Next
        
        /*
        //ɨ��������ɫ������
        y = 0
        While y < txtHight
            x = 0
            While x < txtWidth
                IfColor qx + x,qy + y,txtColor,2
                    //����������
                    key = key & 1
                Else                 
                    key = key & 0
                End If
                x = x + 1
            Wend
            y = y + 1
        Wend
        */
	numText = Plugin.File.ReadINI(section, key, confFile) & numText

    qx = qx - txtSplit
    i = i + 1

   Wend
   Rem ����
   
   '����
   'MsgBox numText
    
End Function


Function ztj()
	//1449,397 0000FF ��ͣ��
	qx=1449
	qy = 397
	num = 7
	txtColor = "0000FF"
	txtHight = 10
	txtWidth = 6
	dotIndex = 2
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int2()
	ztj = numText

End Function


Function zjs(h_MLMain, L, T)
	//884, 49 �����
	qx = 884
	qy = 49
	num = 6
	txtColor = "FFFFFF"
	txtHight = 10
	txtWidth = 6
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit &  "|f:1"
	
	Call _parser_int1(h_MLMain, L, T)
	zjs = numText

End Function



Function kpj(h_MLMain, L, T)
	//949, 49 ���̼�
	//953, 53
	qx=953
	qy = 53
	num = 4
	txtColor = "00FFFF"
	txtHight = 10
	txtWidth = 6
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit &  "|f:1"
	
	Call _parser_int1(h_MLMain, L, T)
	kpj = numText

End Function


Function dtj()
	//1449,374 008000 ��ͣ��
	qx=1449
	qy = 374
	num = 7
	txtColor = "008000"
	txtHight = 10
	txtWidth = 6
	dotIndex = 2
	dotWidth = 2
	confFile = "D:\conf.ini"
	txtSplit = 2
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	'TracePrint section
	
	Call _parser_int2()
	dtj = numText

End Function



Function hy()
	//42,472   000000 ��Լ
	qx=42
	qy = 472
	num = 6
	txtColor = "000000"
	txtHight = 10
	txtWidth = 5
	confFile = "D:\conf.ini"
	txtSplit = 1
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	hy = numText

End Function


Function mm()
	//73,470   008000 ���� 11
	qx=73
	qy = 470
	num = 2
	txtColor = "008000"
	txtHight = 11
	txtWidth = 11
	confFile = "D:\conf.ini"
	txtSplit = 1
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	mm = numText

End Function



Function kcjj()
	//384,472  000000 ���־���
	qx=384
	qy = 472
	num = 8
	txtColor = "000000"
	txtHight = 10
	txtWidth = 5
	confFile = "D:\conf.ini"
	txtSplit = 1
	numText = ""
	
	section = "color:" & txtColor & "|h:" & txtHight & "|w:" & txtWidth & "|s:" & txtSplit
	
	Call _parser_int()
	kcjj = numText

End Function
