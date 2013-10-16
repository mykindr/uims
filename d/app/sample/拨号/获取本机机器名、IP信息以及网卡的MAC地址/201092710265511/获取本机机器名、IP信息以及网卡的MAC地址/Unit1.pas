// ͨ������Api����gethostname,gethostbyname,wsastartup
//uses�м�winsock
//����wsadata,phostent msdn
//����gethostaddress,
unit Unit1;
  {Download by http://www.codefans.net}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,winsock, ExtCtrls,nb30;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Panel1: TPanel;
    Edit4: TEdit;
    Button2: TButton;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    Edit5: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Function NBGetAdapterAddress(a:integer):String;

implementation

{$R *.DFM}

function NBGetAdapterAddress(a: integer): String;
//aָ����������������е���һ��0��1��2...
Var
  NCB:TNCB; // Netbios control block file://NetBios���ƿ�
  ADAPTER : TADAPTERSTATUS; // Netbios adapter status//ȡ����״̬
  LANAENUM : TLANAENUM; // Netbios lana
  intIdx : Integer; // Temporary work value//��ʱ����
  cRC : Char; // Netbios return code//NetBios����ֵ
  strTemp : String; // Temporary string//��ʱ����

Begin
  // Initialize
  Result := '';

  Try
    // Zero control blocl
    ZeroMemory(@NCB, SizeOf(NCB));

    // Issue enum command
    NCB.ncb_command:=Chr(NCBENUM);
    cRC := NetBios(@NCB);

    // Reissue enum command
    NCB.ncb_buffer := @LANAENUM;
    NCB.ncb_length := SizeOf(LANAENUM);
    cRC := NetBios(@NCB);
    If Ord(cRC)<>0 Then
      exit;

    // Reset adapter
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBRESET);
    NCB.ncb_lana_num := LANAENUM.lana[a];
    cRC := NetBios(@NCB);
    If Ord(cRC)<>0 Then
      exit;

    // Get adapter address
    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[a];
    StrPCopy(NCB.ncb_callname, '*');
    NCB.ncb_buffer := @ADAPTER;
    NCB.ncb_length := SizeOf(ADAPTER);
    cRC := NetBios(@NCB);

    // Convert it to string
    strTemp := '';
    For intIdx := 0 To 5 Do
      strTemp := strTemp + InttoHex(Integer(ADAPTER.adapter_address[intIdx]),2);
    Result := strTemp;
  Finally
  End;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
 Ip:string;
 Ipstr:string;
 buffer:array[1..32] of char;
 i:integer;
 WSData:TWSAData;
 Host:PHostEnt;
begin
if WSAstartup(2,WSData)<>0 then  //Ϊ����ʹ��WS2_32.DLL��ʼ��
  begin
    showmessage('WS2_32.DLL��ʼ��ʧ��!');
    halt;
  end;
try
if gethostname(@buffer[1],32)<>0 then
  begin
    showmessage('û�еõ���������');
    halt;
  end;

except
  showmessage('û�гɹ�����������');
  halt;
end;
  Host:=gethostbyname(@buffer[1]);
  if Host=nil then
   begin
    showmessage('IP��ַΪ�գ�');
    halt;
   end
    else
      begin
        edit2.text:=host.h_name;
        edit3.text:=chr(host.h_addrtype+64);
        for i:=1 to 4 do
          begin
           Ip:=inttostr(Ord(Host.h_addr^[i-1]));
           showmessage('�ֶ�Ip��ַΪ:'+Ip);
           Ipstr:=Ipstr+Ip;
           if i<4 then
             Ipstr:=Ipstr+'.'
             else
               edit1.text:=Ipstr;
          end;
      end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Edit4.Text:='��'+edit5.text+'����������MAC��ַΪ'+NBGetAdapterAddress(StrtoInt(Edit5.Text));
end;

end.
//WSAstartup��ʹ��gethostname,gethostbynameǰ
//һ����Ҫ���˳�ʼ��WS2_32.DLL
