unit Unit1;
{Download by http://www.codefans.net}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  dirname:pchar;
  FreeAvailable,TotalSpace:TLargeInteger;
  TotalFree: PLargeInteger;
begin
  dirname:=pchar(edit1.text);
  getmem(totalfree,100);
//Ϊtotalfreeָ�����ڴ�
try
  if GetDiskFreeSpaceEx(dirname,FreeAvailable,TotalSpace,totalfree)=true then
     edit2.text:=inttostr(FreeAvailable);
finally
  freemem(totalfree);
//�����Ƿ����쳣����Ҫ�ͷ��ڴ�
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  free:Int64;
begin
   free:=diskfree(strtoint(edit3.text));
   //�Ѿ���\\Night-stalker\mp3ӳ���G�̣�����edit3.textӦ��Ϊ7
   edit4.text:=inttostr(free);
end;

end.
