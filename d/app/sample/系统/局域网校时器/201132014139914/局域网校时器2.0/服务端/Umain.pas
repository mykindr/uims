unit Umain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer,StrUtils,
  IdTCPConnection, IdTCPClient, IdDayTime, IdSocks, SkinCaption,
  WinSkinData, ComCtrls, Buttons;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    EdtPort: TEdit;
    IdTCPServer: TIdTCPServer;
    IdSocksInfo1: TIdSocksInfo;
    IdDayTime1: TIdDayTime;
    LbLog: TMemo;
    Button1: TButton;
    SkinData1: TSkinData;
    SkinCaption1: TSkinCaption;
    StatusBar1: TStatusBar;
    WebHost: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    WebHostPort: TEdit;
    BitBtn1: TBitBtn;
    procedure IdTCPServerConnect(AThread: TIdPeerThread);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EdtPortChange(Sender: TObject);
    procedure WebHostChange(Sender: TObject);
    procedure WebHostPortChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure GetTimeSyncTime(THost,TPort:string);
   // procedure FormMin(var Msg: TWMSYSCOMMAND); message WM_SYSCOMMAND; //��ȡ�������ϽǵĹرհ�ť�¼�
  public
    { Public declarations }
  end;
TRWINI = function(RT:integer;INIPATH:string;Item,ItemDetail,Value:string):pchar; stdcall;
var
  Form2: TForm2;
  //s:='TER' : string;
  s : string;
  //s:='TER';
  TipTime:string;
implementation

uses Utip;

{$R *.dfm}
//���嶯̬����DLL��ȡ����INI�ļ���inifile����,ȡ��Զ��ini�ļ�·��
function ReadINI(Item,detail:string):string;
var DLLHandle: THandle;
    Func:TRWINI;
begin
  DLLHandle:= LoadLibrary('RWINI.dll');
  try
    @Func := GetProcAddress(DLLHandle, 'RWINI');
    if Assigned(@Func) then
       begin
         result:=Func(1,ExtractFilePath(Application.ExeName)+'config.ini',Item,detail,'');
       end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;
//���嶯̬����DLLд����INI�ļ���inifile����
function WriteINI(Item,detail:string;value:string):string;
var DLLHandle: THandle;
    Func:TRWINI;
begin
  DLLHandle:= LoadLibrary('RWINI.dll');
  try
    @Func := GetProcAddress(DLLHandle, 'RWINI');
    if Assigned(@Func) then
       begin
         result:=Func(2,ExtractFilePath(Application.ExeName)+'config.ini',Item,detail,value);
       end;
  finally
    FreeLibrary(DLLHandle);
  end;
end; 
//��ȡ�������ϽǵĹرհ�ť�¼�
{procedure TForm2.FormMin(var Msg: TWMSYSCOMMAND);
begin
  if (Msg.CmdType=SC_CLOSE) then
    Msg.CmdType:=SC_MINIMIZE;  //ʹ����С��
  Inherited;
end;  }

//ȡ�û�����ʱ�䲢ͬ���ͻ�ʱ�����
procedure Tform2.GetTimeSyncTime(THost,TPort:string);
var
//  s : string;
  dtime : TDatetime;
begin
  IdDayTime1 .Host := THost ;
  IdDayTime1 .Port :=strtoint(TPort);
  IdSocksInfo1.Version:=svNoSocks ;
  try
    s := IdDayTime1 .DayTimeStr ;
  except
     //s:='����˻�ȡ������ʱ�����!��������������������Уʱ�������Ƿ��ܷ���...';
     s:='TER';
     Exit;
  end;
  s := copy(s,7,17);
  dtime:= strtodatetime(s);
  s:= datetimetostr((dtime+8/24));
  //s:=DateToStr(now)+' '+TimeToStr(now);
  //SetSystemtime2 (dtime+8/24);
end;

procedure TForm2.IdTCPServerConnect(AThread: TIdPeerThread);
var T:string;
begin
  GetTimeSyncTime(ReadINI('������Уʱ������','��������ַ'),ReadINI('������Уʱ������','���Ӷ˿�'));
  T:=s;
  if T = 'TER' then
     begin
     LbLog.Lines.Add(datetimetostr(now)+' ��ȡ������ʱ�����!��������������������Уʱ�������Ƿ��ܷ���...');
     //exit;
     end
  else
    LbLog.Lines.Add(S);
  // AThread.Connection.WriteLn('OK');
  AThread.Connection.WriteLn(s);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
//IdTCPServer.DefaultPort := StrToInt(EdtPort.Text);
//IdTCPServer.Active := True;
EdtPort.Text :=trim(ReadINI('��������','���Ӷ˿�'));
WebHost.Text :=trim(ReadINI('������Уʱ������','��������ַ'));
WebHostPort.Text :=trim(ReadINI('������Уʱ������','���Ӷ˿�'));
Button1Click(sender);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
IdTCPServer.Active := false;
IdTCPServer.DefaultPort := StrToInt(EdtPort.Text);
IdTCPServer.Active := True;
lblog.Lines.Add(datetimetostr(now)+' ����������ɹ�!');
application.Title :='Уʱ������'+'   ������...';
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdTCPServer.Active := false;
 { if MessageBox(Handle, '�Ƿ��˳�Уʱ�����?', '��ʾ', MB_ICONQUESTION or MB_YESNO) = IDYES then
     begin
       IdTCPServer.Active := false;
       application.Terminate ;
     end
  else
    canclose:= false;  }
end;

procedure TForm2.EdtPortChange(Sender: TObject);
begin
  writeini('��������','���Ӷ˿�',trim(EdtPort.Text));
end;

procedure TForm2.WebHostChange(Sender: TObject);
begin
  writeini('������Уʱ������','��������ַ',trim(WebHost.Text));
end;

procedure TForm2.WebHostPortChange(Sender: TObject);
begin
  writeini('������Уʱ������','���Ӷ˿�',trim(WebHostPort.Text));
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
var T:string;
begin
  GetTimeSyncTime(ReadINI('������Уʱ������','��������ַ'),ReadINI('������Уʱ������','���Ӷ˿�'));
  T:=s;
  if T = 'TER' then
     begin
     LbLog.Lines.Add(datetimetostr(now)+' ��ȡ������ʱ�����!��������������������Уʱ�������Ƿ��ܷ���...');
     TipTime:=datetimetostr(now);
     exit;
     end
  else
    begin
    LbLog.Lines.Add(S);
    TipTime:=s;
   // showmessage(s);
    end;

 // showmessage(TipTime);
  tip:=Ttip.Create(self);
  tip.ShowModal;
  tip.Free;
end;

end.
