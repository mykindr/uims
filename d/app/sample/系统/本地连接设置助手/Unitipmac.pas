// what��IP/MAC
// use�����ñ������ӣ���̬���أ���ѯMAC
// who��xiedingan
// time:20120803

//Download by http://www.codefans.net

unit Unitipmac;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,WinSock,IniFiles;

type
  Tformarp = class(TForm)
    setip: TGroupBox;
    editmyip: TLabeledEdit;
    btnsetip: TButton;
    editgateip: TLabeledEdit;
    editdns: TLabeledEdit;
    editsubnet: TLabeledEdit;
    gatemac: TGroupBox;
    btnsetmac: TButton;
    arp: TGroupBox;
    btnARP: TButton;
    findmac: TGroupBox;
    btnfindmac: TButton;
    editfindmac: TEdit;
    editgatemac: TEdit;
    TrayIconarp: TTrayIcon;
    procedure TrayIconarpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnsetipClick(Sender: TObject);
    procedure btnfindmacClick(Sender: TObject);
    procedure btnsetmacClick(Sender: TObject);
    procedure btnARPClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private

  procedure WMSysCommand( var Message: TMessage); message WM_SYSCOMMAND;  //ϵͳ����
    { Private declarations }
  public
    { Public declarations }
  end;


var
  formarp: Tformarp;
  ipcmd,dnscmd,maccmd: string;
  h: THandle;
  id: DWORD;
  btn: boolean;
  ini: tinifile;


implementation

{$R *.dfm}



//�����ʼ��
procedure Tformarp.FormCreate(Sender: TObject);
begin
  trayiconarp.Icon := application.Icon;
  id := 0;
  btn := true;
  ini := Tinifile.Create('arptmp.ini');             //�������ļ�
  editmyip.Text := ini.ReadString('IP','myip','192.168.1.100');
  editsubnet.Text := ini.ReadString('IP','subnet','255.255.255.0');
  editgateip.Text := ini.ReadString('IP','gateip','192.168.1.1');
  editdns.Text := ini.ReadString('IP','dns','8.8.8.8');
  editgatemac.Text := ini.ReadString('mac','gatemac','ff-ff-ff-ff-ff-ff');
end;



//ϵͳ�����¼�
procedure Tformarp.WMSysCommand(var Message:TMessage);
begin
   if Message.WParam = SC_MINIMIZE then
     begin
      Formarp.Visible := False;
     end
   else
     begin
     DefWindowProc(Formarp.Handle,Message.Msg,Message.WParam,Message.LParam);
   end;
end;

procedure Tformarp.TrayIconarpClick(Sender: TObject);
begin
  Formarp.Visible := True;
end;



//��ȡMAC����
Function sendarp(ipaddr:ulong; temp:dword; ulmacaddr:pointer; ulmacaddrleng:pointer) : DWord; StdCall; External 'Iphlpapi.dll' Name 'SendARP';



//��ip
procedure Tformarp.btnsetipClick(Sender: TObject);
var
  Aip: ulong;
  Amac: array[0..5] of byte;
  Amaclength: ulong;
  Ai: dword;
begin
  ipcmd := 'netsh interface ip set address name="��������"   source=static addr="' + editmyip.Text + '"  mask="' + editsubnet.Text + '"  gateway="' + editgateip.Text + '"  gwmetric=1';
  dnscmd := 'netsh interface ip set dns name="��������" source=static addr="' + editdns.Text + '" register=PRIMARY';
  winexec(PAnsiChar(AnsiString(ipcmd)),sw_hide);            //����cmd������ɣ�
  winexec(PAnsiChar(AnsiString(dnscmd)),sw_hide);
  Aip := inet_addr(PAnsiChar(AnsiString(editgateip.Text)));  //ͬʱ��ȡ����mac
  Amaclength := length(Amac);
  Ai := sendarp(Aip,0,@Amac,@Amaclength);
  if Ai = NO_ERROR then
    begin
      editgatemac.Text := format('%2.2x-%2.2x-%2.2x-%2.2x-%2.2x-%2.2x', [Amac[0],Amac[1],Amac[2],Amac[3],Amac[4],Amac[5]]);
    end
  else
    begin
      editgatemac.Text := '����IP����ȷ��';
  end;
  ini.writestring('ip','myip',editmyip.Text);               //����ɣ�����
  ini.writestring('ip','subnet',editsubnet.Text);
  ini.writestring('ip','gateip',editgateip.Text);
  ini.writestring('ip','dns',editdns.Text);
  ini.writestring('mac','gatemac',editgatemac.Text);
end;



//��MAC
procedure Tformarp.btnfindmacClick(Sender: TObject);
var
  Aip: ulong;
  Amac: array[0..5] of byte;
  Amaclength: ulong;
  Ai: dword;
begin
  Aip := inet_addr(PAnsiChar(AnsiString(editfindmac.Text)));
  Amaclength := length(Amac);
  Ai := sendarp(Aip,0,@Amac,@Amaclength);
  if Ai = NO_ERROR then
    begin
      editfindmac.Text := format('%2.2x-%2.2x-%2.2x-%2.2x-%2.2x-%2.2x', [Amac[0],Amac[1],Amac[2],Amac[3],Amac[4],Amac[5]]);
    end
    else
      begin
      editfindmac.Text := '�����������ߣ�';
  end;
end;


//��MAC
procedure Tformarp.btnsetmacClick(Sender: TObject);
begin
  maccmd := 'arp -s  ' + Editgateip.Text + ' ' + Editgatemac.Text;
  winexec('arp -d',sw_hide);
  winexec(PAnsiChar(AnsiString(maccmd)),sw_hide);
end;


//arp����
function Fun(p: Pointer): Integer; stdcall;
begin
  maccmd := 'arp -s  ' + formarp.Editgateip.Text + ' ' + formarp.Editgatemac.Text;
  while true do
    begin
      winexec('arp -d',sw_hide);
      winexec(PAnsiChar(AnsiString(maccmd)),sw_hide);
      sleep(3000);
    end;
end;


//��ARP
procedure Tformarp.btnARPClick(Sender: TObject); //һ����ť��������ͣ
begin
  if  btn = true then//�����߳�
    begin
      if id = 0 then                //���û���߳̾ʹ�����
        begin
          h := CreateThread(nil, 0, @Fun, nil, 0, id);
          btnarp.Caption:='��ͣ';
          btn := false;
          editgatemac.Color := cllime;
        end
      else                         //����Ѵ����߳̾ͻ�����
        begin
          ResumeThread(h);
          btnarp.Caption:='��ͣ';
          btn := false;
          editgatemac.Color := cllime;
        end;
    end
  else              //��ͣ�߳�
    begin
      SuspendThread(h);
      btnarp.Caption := '����';
      btn := true;
      editgatemac.Color := clWindow
  end;
end;

//�رճ���
procedure Tformarp.FormDestroy(Sender: TObject);
begin
  ini.free;
end;

end.
