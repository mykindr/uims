
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
  Dialogs, StdCtrls,Registry,GetCPUSerialNumberp;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button888888: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button33333: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button33333Click(Sender: TObject);
    procedure Button888888Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    RegisterCode:String;
    HasReg:boolean;
    function Decrypt(const s: string; key: word): string;
    procedure CheckReg;
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

//������ʶ���ܣ��õ�ע����
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


procedure TForm1.FormCreate(Sender: TObject);
var
 ARegistry:TRegistry;
begin
  ARegistry := TRegistry.Create;
  with ARegistry do
  begin
    RootKey:=HKEY_LOCAL_MACHINE;
    if OpenKey('Software\RegisterExample',false ) then
      RegisterCode:=ReadString('RegisterCode');
    ARegistry.Free;
  end;
  //���ݻ�����ʶ���ע���룬���ѱ����ע����Ƚϣ����Ƿ���ע��
  HasReg:=RegisterCode=Decrypt(GetCPUSerialNumber,100);
  CheckReg;
end;

//ע��
procedure TForm1.Button33333Click(Sender: TObject);
var
 ARegistry:TRegistry;
begin
  with TForm2.Create(self) do
  begin
    Editid.Text:=GetCPUSerialNumber;
    if showmodal=mrOk then  //�������ע������ȷ�����ע���뱣�浽ע���
    begin
      ARegistry := TRegistry.Create;
      with ARegistry do
      begin
        RootKey:=HKEY_LOCAL_MACHINE;
        if OpenKey('Software\RegisterExample',True) then
          WriteString('RegisterCode',Editcode.text);
        Free;
      end;
      HasReg:=True;
      CheckReg;
    end;
    Free;
  end;
end;

procedure TForm1.Button888888Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.CheckReg;
begin
  Button33333.Visible:=not HasReg;
  Button1.Enabled:=HasReg;
  Edit1.Enabled:=HasReg;
  Edit2.Enabled:=HasReg;
  Label3.Visible:=not HasReg;
end;

end.
