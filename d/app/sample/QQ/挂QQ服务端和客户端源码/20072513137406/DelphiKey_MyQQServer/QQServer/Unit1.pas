//��QQ����ˣ�����WEB���QQ�ģ��Լ������죬��������û�о���������
//����Ҫ�Ķ������Ѿ�ȡ����
//�ṩ�ó���ֻ������ѧϰĿ�ģ�ǧ��Ҫ���ڷǷ���;������Ը�
//�õ�RX�ؼ�����JCL�⣬������������
//������ܹ�QQ�Ļ����Ǿ��뿴LumqQQ�е����Э�飬�ĳ���Э�鼴��
//���и���ϣ����һ�ݸ��� QQ:709582502 Email:Touchboy@126.com 
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sockets,Class_QQTEA,Class_QQOUTPacket,Class_QQINPacket,
  Class_Record, Buttons, RXShell, ExtCtrls, Mask, ToolEdit,
  CurrEdit, OleCtrls, MSWinsockLib_TLB, ComCtrls, Class_RecvTCP,Class_QQOnLine,
  WinSkinData, ScktComp, DBISAMTb,Class_QQDB;

type
  TFrmMain = class(TForm)
    QQTCPServer: TWinsock;
    MinuteTime: TTimer;
    UpdateBtn: TBitBtn;
    OnLineLab: TLabel;
    BitBtn3: TBitBtn;
    OnLineTime: TTimer;
    RxTrayIcon1: TRxTrayIcon;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Label1: TLabel;
    RedScrollBar: TScrollBar;
    GreenScrollBar: TScrollBar;
    BlueScrollBar: TScrollBar;
    QQLb: TListBox;
    ServerSocket1: TServerSocket;
    QQDataBase: TDBISAMDatabase;
    StartBtn: TBitBtn;
    procedure RedScrollBarChange(Sender: TObject);
    procedure UpdateBtnClick(Sender: TObject);
    procedure MinuteTimeTimer(Sender: TObject);
    procedure OnLineTimeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QQTCPServerConnectionRequest(ASender: TObject;
      requestID: Integer);
    procedure BitBtn3Click(Sender: TObject);
    procedure RxTrayIcon1DblClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
  private
    QQRecvTCP: TQQRecvTCP;
    FFileName:String;


    procedure AddText(s:String);

    procedure SetUDPStatus(sValue:String);
    function GetAutoColor: TColor;
    function GetBlueValue: Byte;
    function GetGreenValue: Byte;
    function GetRedValue: Byte;

    procedure UpdateQQNum;
  public
    property   AutoColor  :TColor Read GetAutoColor;
    property   RedValue   :Byte Read GetRedValue;
    property   GreenValue :Byte Read GetGreenValue;
    property   BlueValue  :Byte Read GetBlueValue;
  end;

var
  FrmMain: TFrmMain;

implementation

uses JCLStrings,NWLog,NWSystem,NWIniFile;

{$R *.dfm}

procedure TFrmMain.AddText(s: String);

begin
  QQLB.Items.Add(S) ;
end;

procedure TFrmMain.SetUDPStatus(sValue: String);
begin
  StatusBar1.Panels[1].Text :=sValue;
end;

procedure TFrmMain.RedScrollBarChange(Sender: TObject);
begin
  Label1.Font.Color := AutoColor;
  if not assigned(QQOutPacket) then  Exit;
  QQOutPacket.RedValue :=RedScrollBar.Position;
  QQOutPacket.GreenValue :=GreenScrollBar.Position;
  QQOutPacket.BlueValue :=BlueScrollBar.Position;
end;

function TFrmMain.GetAutoColor: TColor;
begin
  Result:=RGB(RedScrollBar.Position,GreenScrollBar.Position,BlueScrollBar.Position);
end;

function TFrmMain.GetBlueValue: Byte;
begin
  Result := BlueScrollBar.Position
end;

function TFrmMain.GetGreenValue: Byte;
begin
  Result := GreenScrollBar.Position
end;

function TFrmMain.GetRedValue: Byte;
begin
  Result := RedScrollBar.Position
end;

procedure TFrmMain.UpdateBtnClick(Sender: TObject);
begin
  UpdateQQNum;
end;

procedure TFrmMain.MinuteTimeTimer(Sender: TObject);
begin
  Minute := Minute + 1;
end;

procedure TFrmMain.OnLineTimeTimer(Sender: TObject);
var
  i:integer;
  nCount:integer;
begin
  nCount :=0;
  For i:=1 to MAXUDPOnLineNum do
  begin
    If (QQInfo[i].QQNumber<>0) and (QQInfo[i].QQPassword<>'')
      and (QQInfo[i].State=QsLoginSucess) Then
    begin
      nCount:=nCount+1;
    end;
  end;
  OnLineLab.Caption :='��������:'+intToStr(nCount);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  App      :String;
  s:String;
begin
  App:=Sysutils.ExtractFilePath(Application.ExeName);
  if App[Length(App)]<>'\' then App :=App+'\';
  FFileName :=App+'IP.ini';

  InitSockQQ;

  //ShowMessage('Create');

  //QQTCPServer.LocalPort :=5500;
  QQTCPServer.LocalPort   :=ReadIniInteger(FFileName,'IP','port',17999);

  RedScrollBar.Position   :=ReadIniInteger(FFileName,'IP','RedValue',0);
  GreenScrollBar.Position :=ReadIniInteger(FFileName,'IP','GreenValue',0);
  BlueScrollBar.Position  :=ReadIniInteger(FFileName,'IP','BlueValue',0);

  S := ReadIniString(FFileName,'IP','AutoReplay','�����ڹһ����������');

  Memo1.Lines.Text        :=s;
  //ServerSocket1.Port      :=ReadIniInteger(FFileName,'IP','port',17999);
  //ServerSocket1.Active :=true;

  //AddText('Create');
  QQTCPServer.Listen;
  //AddText('Listen');

  QQRecvTCP:=TQQRecvTCP.Create(300,1000,Self);
  QQOnLine :=TQQOnLine.Create(20000,5000,45000,Self);
  QQTEA      :=TQQTEA.Create;
  QQOutPacket:=TQQOutPacket.Create;
  QQInPacket :=TQQInPacket.Create;
  QQUserDB   :=TQQUserDB.Create('QQUSER','UserQQ');

  QQOutPacket.RedValue  :=RedScrollBar.Position;
  QQOutPacket.GreenValue :=GreenScrollBar.Position;
  QQOutPacket.BlueValue :=BlueScrollBar.Position;
  QQRecvTCP.AutoReplay  :=Trim(Memo1.Lines.Text);

  OnLineTime.Enabled :=True;
  MinuteTime.Enabled :=True;
  //AddText('Start');
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteIniInteger(FFileName,'IP','RedValue',RedScrollBar.Position );
  WriteIniInteger(FFileName,'IP','GreenValue',GreenScrollBar.Position );
  WriteIniInteger(FFileName,'IP','BlueValue',BlueScrollBar.Position);

  WriteIniString(FFileName,'IP','AutoReplay',Memo1.Lines.Text);


  FreeAndNil(QQRecvTCP);
  FreeAndNil(QQOnLine);
  FreeAndNil(QQTEA);
  FreeAndNil(QQOutPacket);
  FreeAndNil(QQInPacket);
  FreeAndNil(QQUserDB);
end;

procedure TFrmMain.QQTCPServerConnectionRequest(ASender: TObject;
  requestID: Integer);
begin
  //AddText('Connect ReQuest');
  QQRecvTCP.Accept(requestID);
end;

procedure TFrmMain.BitBtn3Click(Sender: TObject);
var
  nQQNum:integer;
  i:integer;
begin
   if QQLB.ItemIndex=-1 then Exit;
   nQQNum :=StrToint(QQLB.Items[QQLB.itemIndex]);
   for i :=1  to MAXUDPOnLineNum do
   begin
     if QQInfo[i].QQNumber=nQQNum then
     begin
       QQONLine.LogOut(i);
       break;
     end;
   end;
end;

procedure TFrmMain.RxTrayIcon1DblClick(Sender: TObject);
begin
  Self.Show;
end;

procedure TFrmMain.Memo1Change(Sender: TObject);
begin
   if not Assigned(QQRecvTCP) then exit;
   QQRecvTCP.AutoReplay :=Memo1.Lines.Text;
end;

procedure TFrmMain.StartBtnClick(Sender: TObject);
begin
   QQRecvTCP.ResetQQServer;
   UpdateQQNum;
end;

procedure TFrmMain.UpdateQQNum;
var
  i:integer;
begin
  QQLB.Items.Clear;
  For i:=1 to MAXUDPOnLineNum do
  begin
    if (QQInfo[i].QQNumber<>0) and (QQInfo[i].QQPassword<>'') and (QQInfo[i].State=QsLoginSucess) then
      QQLB.Items.Add(IntToStr(QQInfo[i].QQNumber));
  end;
end;

end.

