<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>��DelphiдASP���ʵ�ֿ��ٶ��ļ�WEB�ϴ���ʾ</title>
</head>
<body>
<p align="center">��DelphiдASP���ʵ�ֿ��ٶ��ļ�WEB�ϴ���ʾ</p>
<%
dim ob
dim fsize
set ob=server.createobject("ASPComponent.CoIFileUpload")
path=server.mappath(".")
fsize=ob.savefile(path,true)
response.write "<br>�ı���ֵ��" & ob.request("text1")
response.write "<br>�ı���ֵ:" & ob.request("textarea1")
response.write "<br>�������ݴ�С: " & fsize 
response.write "<br>�ļ�����·��: " & path
response.write "<br>�ļ�1: �ļ�����" & ob.Request("file1")  & ",   �ļ����ͣ�" & ob.FileType("file1")  & ",   �ļ���С��" & ob.FileSize("file1") 
response.write "<br>�ļ�1: �ļ�����" & ob.Request("file2")  & ",   �ļ����ͣ�" & ob.FileType("file2")  & ",   �ļ���С��" & ob.FileSize("file2") 
%>

</body>
</html>
