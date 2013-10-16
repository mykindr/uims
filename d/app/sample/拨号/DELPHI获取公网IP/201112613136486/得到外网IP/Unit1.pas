unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,UrlMon ,ComObj ;

type
  TForm1 = class(TForm)
    edt1: TEdit;
    btn1: TButton;
    btn2: TButton;
    edt2: TEdit;
    procedure btn2Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function DownloadFile(SourceFile, DestFile: string): Boolean; //���غ���
begin //����������ҳ,ͼƬ���κ��ļ�,�� �Ϻ��Ž�ϵͳ
try
    result := UrlDownloadToFile(nil,PChar(SourceFile),PChar(DestFile), 0, nil) = 0;
   except
    result := False;
   end;
end;

function Fenli(Src: string; Before, After: string): string; //�ַ������뺯��
var
Pos1, Pos2: Word;
Temp: string;
begin //ʹ�÷���:Fenli('www.zhuanhou.cn','www.','.cn') �õ��Ľ��Ϊ:zhuanhou
Temp := Src;
Pos1 := Pos(Before, Temp);
Delete(Temp, 1, Pos1 + Length(Before));
Pos2 := Pos(After, Temp);
if (Pos1 = 0) or (Pos2 = 0) then
begin
result := '';
Exit;
end;
Pos1 := Pos1 + Length(Before);
result := Copy(Src, Pos1, Pos2);
end;





procedure TForm1.btn2Click(Sender: TObject);
var
   i:Integer;
   LadTxt:TstringList;
begin
//�����ļ�,����Ϊ���ַ������ص��ļ���ʵ���൱��webbrowser���������ַ
//IP.txt Ϊ������ļ�
DownloadFile('http://www.ip138.com/ip2city.asp','IP.txt');
LadTxt:=TStringList.Create;
LadTxt.LoadFromFile('IP.txt');
//ѭ����ȡ IP.txt �ļ�
for i:=0 to LadTxt.Count -1 do
   begin
     //�����ǰ�а��� ����IP��ַ�ǣ����Ұ��� ]
     if (Pos('����IP��ַ�ǣ�',LadTxt[i])>0) and (Pos(']',LadTxt[i])>0) then
      begin
       edt2.Text:=Fenli(LadTxt[i],'[',']');    //��ֵ ����õ���ǰIP��ַ
       Text:='��ȡ����IP��ַ�ɹ�! www.akux.cn';//���ı���
       Exit;                                   //�˳�ѭ��
      end;
   end;

end;


function GetIP: string; //��ȡ����IP
var
xml : OleVariant;
r:string;
p1,p2 : Integer;
begin
xml := CreateOleObject('Microsoft.XMLHTTP');
xml.Open('GET',' http://www.ip138.com/ip2city.asp', False);
xml.Send;
r := xml.responseText;
p1:=Pos('[',r);
p2:=Pos(']',r);
Result := Copy(r, p1+1, p2-p1-1);
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  edt1.Text:= GetIP;
end;

end.
