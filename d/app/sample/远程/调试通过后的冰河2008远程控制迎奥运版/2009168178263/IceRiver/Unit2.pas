unit Unit2;
{����BLOG ALALMN JACK     http://hi.baidu.com/alalmn  
Զ�̿��ƺ�ľ���дȺ30096995   }
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdFTP,   shellapi,IniFiles,winsock;

type
  Tftp = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button1: TButton;
    Label9: TLabel;
    Edit7: TEdit;
    Button2: TButton;
    IdFTP1: TIdFTP;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ftp: Tftp;
    myinifile:Tinifile;      //��������INI

implementation

{$R *.dfm}
procedure GetLocalIP;
type
  TaPInAddr = array[0..255] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array[0..63] of char;
  i: integer;
  GInitData: TWSADATA;
  Temp: string;
begin
  wsastartup($101, GInitData);
  Temp := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(buffer);
  if not assigned(phe) then
    exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  i := 0;
  while pptr^[I] <> nil do begin
    Temp := Temp + StrPas(inet_ntoa(pptr^[I]^)) + ',';
    inc(i);
  end;
  Delete(Temp, Length(Temp), 1);
  try
    ftp.ComboBox1.Text:=Temp;
    ftp.ComboBox1.Items.Add(Temp);     //���IP
  except
  end;
  wsacleanup;      //���
end;


procedure Tftp.Button2Click(Sender: TObject);
begin
ShellExecute(0,nil,PChar(Edit7.Text), nil, nil, SW_NORMAL);
end;

procedure Tftp.FormCreate(Sender: TObject);
var
  filename:string;
begin
  filename:=ExtractFilePath(paramstr(0))+'alalmn.ini';                                 //��myini.ini�ļ��洢��Ӧ�ó���ǰĿ¼��
  myinifile:=TInifile.Create(filename);                                              //��myini.ini�ļ��洢��Ӧ�ó���ǰĿ¼��
  edit1.Text:= myinifile.readstring('FTP����','FTP������','222.189.228.184');
  edit2.Text:= myinifile.readstring('FTP����','�˿�','21');
  edit3.Text:= myinifile.readstring('FTP����','�û���','alalmn');
  edit4.Text:= myinifile.readstring('FTP����','��½����','123456');
  edit5.Text:= myinifile.readstring('FTP����','ȷ������','654321');
  edit6.Text:= myinifile.readstring('FTP����','���IP�ļ�','wwwroot\\ip.txt');
  edit7.Text:= myinifile.readstring('FTP����','HTTP��ַ','http://www.e1058.com/ip.txt');
end;

procedure Tftp.FormDestroy(Sender: TObject);
begin
  myinifile.writestring('FTP����','FTP������',edit1.Text);
  myinifile.writestring('FTP����','�˿�',edit2.Text);
  myinifile.writestring('FTP����','�û���',edit3.Text);
  myinifile.writestring('FTP����','��½����',edit4.Text);
  myinifile.writestring('FTP����','ȷ������',edit5.Text);
  myinifile.writestring('FTP����','���IP�ļ�',edit6.Text);
  myinifile.writestring('FTP����','HTTP��ַ',edit7.Text);
  myinifile.Destroy;
end;

procedure Tftp.Button1Click(Sender: TObject);
var
F:TextFile;
begin
if Edit1.Text='' then
  begin
    Label7.Caption :='������FTP��������ַ!';
    Exit;
  end;
if Edit3.Text='' then
  begin
    Label7.Caption :='������FTP�û���!';
    Exit;
  end;
if Edit4.Text<>Edit5.Text then
  begin
    Label7.Caption :='�����������벻һ��!';
    Edit4.Text:='';
    Edit5.Text:='';
    Exit;
  end;

Label7.caption:='���ڸ���FTP!';
IdFTP1.Host:= Edit1.Text;
IdFTP1.Port:= strtoint(Edit2.Text);
IdFTP1.Username:=Edit3.Text;
IdFTP1.Password:=Edit4.Text;
IdFTP1.Connect();   //����
    if IdFTP1.Connected then    //������Ӧ����
    begin
    AssignFile(F,ExtractFilePath(Paramstr(0))+'test.htm');
    ReWrite(F);
    Writeln(F,'{window.location = "http://'+ComboBox1.text+'";;}');
    CloseFile(F);
    IdFTP1.Put(ExtractFilePath(Paramstr(0))+'test.htm',Edit6.Text,false);
    IdFTP1.Disconnect;
    Label7.caption:='����FTP�ɹ�����ʹ��'+Edit7.Text+'����!';
    end  else
    begin
     Label7.caption:='����IP����!��������!';
    end;
    if FileExists(ExtractFilePath(Paramstr(0))+'test.htm') then
     DeleteFile(ExtractFilePath(Paramstr(0))+'test.htm');
  end;

procedure Tftp.FormShow(Sender: TObject);
begin
GetLocalIP;
end;

end.
