
  {*****************************************************************************}
  {���ߣ�����Ǭ��QQ:415270083, ��E-mail:CxLing03@163.com��qian0303@sohu.com             }
  {�����������,���ǳ���Ҫ�õ������ı�ʶ���������ߵľ��飬�ں�Щ���������޷�ȡ  }
  {��Ӳ�����кš��ر�������Щʹ���˲��д洢���������˾����Ӳ�̡�����Ҳ���׸��� }
  {��������߽���ʹ��CPU���кš�����������ṩ�˻��CPU���кź�����Mac��ַ�ķ�}
  {����1.Delphi�п�����ؼ��������̬�⡣�ؼ��ṩ���������ԣ�MacAddress��       }
  {CPUSerialNumber��2.Delphi������ԣ���ʹ�������̬�⡣��̬���ṩ������������  }
  {GetCPUSerialNumber��GetMacAddress����Щ�����Ϳؼ�����win2000��winXP�в���ͨ��}
  {���ڶ�CPU����Ӳ�̡�ʹ���˲��д洢�����Ĵ��ͷ������ϣ�Ҳ����ͨ����            }
  {*****************************************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Editid: TEdit;
    Editcode: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Decrypt(const s: string; key: word): string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function TForm1.Decrypt(const s: string; key: word): string;
var
  i:byte;
  R:String;
const
  C1=50;
  C2=50;
begin
  SetLength(R,Length(s));
  for i:=1 to Length(s) do
  begin
    R[i]:=char(byte(s[i]) xor (key shr 8));
    key:=(byte(s[i])+key)+C1+C2
  end;
  Result:=R;
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
  if Trim(Editid.Text)='' then
  begin
    MessageBox(Handle,pchar('�Բ��𣬻�����ʶ����Ϊ��'),pchar('ϵͳ��ʾ'),mb_ok or mb_iconwarning);
    Editid.SetFocus;
    Exit;
  end;
  Editcode.Text:=Decrypt(Trim(Editid.Text),100);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
 