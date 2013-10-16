//=========================================================================//
//                                                                         //
//                              ������Դ����                               //
//                               ����:���                                 //
//                               2003-03-21                                //
//                ʵ����ADSL�������Ӽ�ʱ,����ʵ����������û�����          //
//                    ϣ����Ҳ�Ҫɾ����������������ע�����               //
//=========================================================================//

unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, wininet, WinSock, XPMenu,
  ADSLStringRes, INIFiles, ImgList, SetupFrm, DateUtils, RzTray, Registry,
  ShellAPI;

type
  OSType = (osUnknown, osWin95, osWin98, osWin98se, osWinme, osWinnt4, osWin2k,
    osWinxp);

type
  TFrmADSLMain = class(TForm)
    MainMenu1: TMainMenu;
    Panel1: TPanel;
    MenuSetup: TMenuItem;
    MenuView: TMenuItem;
    MenuDropFrm: TMenuItem;
    MenuFrmTrans: TMenuItem;
    DateTimePicker1: TDateTimePicker;
    PanDate: TPanel;
    PanDateSelect: TPanel;
    TreeView1: TTreeView;
    StatusBar1: TStatusBar;
    panMain: TPanel;
    ListView1: TListView;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Memo1: TMemo;
    XPMenu1: TXPMenu;
    ilstTree: TImageList;
    tmrChecker: TTimer;
    tmrTime: TTimer;
    lblMonthStr: TLabel;
    lblCurStr: TLabel;
    lblStartStr: TLabel;
    RzTrayIcon1: TRzTrayIcon;
    pMenuMain: TPopupMenu;
    MenuShowDrop: TMenuItem;
    MenuShowMain: TMenuItem;
    MenuDropTran: TMenuItem;
    MenuN1: TMenuItem;
    MenuN2: TMenuItem;
    MenuClose: TMenuItem;
    MenuHelp: TMenuItem;
    MenuHelpTopic: TMenuItem;
    MenuAbout: TMenuItem;
    MenuN3: TMenuItem;
    MMenuDropSetup: TMenuItem;
    N1: TMenuItem;
    E1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MenuDropFrmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuFrmTransClick(Sender: TObject);
    procedure MenuOptionClick(Sender: TObject);
    procedure tmrCheckerTimer(Sender: TObject);
    procedure tmrTimeTimer(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuShowMainClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MMenuDropSetupClick(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure MenuHelpTopicClick(Sender: TObject);
  private
    { Private declarations }
    XSTimeMonth, XSTimeDay, JSDay: Byte; //ÿ����ʱ��ʱ��

    MonthDate: string; //������ʱ,���Ӧ����һ���ۼӵ��ַ�����������Ϊ
    //Delphi�����ʱ�������Сʱ���޷�����24.ֻ�����ַ���������
    CurrentDate, EndTime: TTime;

    MonthStart: TDateTime; //���¿�ʼ��ʱ�������

    szCallSound: string; //����������·��
    IsCallSound: Boolean; //�Ƿ񱨾�
    IsDefaultSound: Boolean; //�Ƿ�ʹ��Ĭ����������
    IsSetupDay: Boolean; //ÿ�������¼�ʱ�����Ƿ��Ѿ����¼�ʱ
  public
    { Public declarations }
    procedure ShowDropFrm;
    procedure InitDateProc; //��������л���ʼ���˳������ڵ�Ŀ¼��ַ
    procedure AddNameToTreeNode; //����û��������ͽڵ�
    procedure AddIPToListView;
    procedure WriteTimeToFile(FileName: string; SumTime: string);
    procedure ReadFileToListView(FileName: string = '');
    procedure WM_MyAppendMenu(var msg: TWMSysCommand); message WM_SYSCOMMAND;
    function CheckOffline: boolean;
    function CountStrToDateTime(const str: string; DateTime: TDateTime): string;
  end;

var
  FrmADSLMain: TFrmADSLMain;
  hnd: THandle;

implementation

uses
  DropFrm, AboutFrm, DropSetupFrm, MMSystem;
{$R *.dfm}

function GetOSVersion: OSType;
var
  osVerInfo: TOSVersionInfo;
  majorVer, minorVer: Integer;
begin
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if (GetVersionEx(osVerInfo)) then
  begin
    majorVer := osVerInfo.dwMajorVersion;
    minorVer := osVerInfo.dwMinorVersion;
    case (osVerInfo.dwPlatformId) of
      VER_PLATFORM_WIN32_NT: { Windows NT/2000 }
        begin
          if (majorVer <= 4) then
            Result := osWinnt4
          else if ((majorVer = 5) and (minorVer = 0)) then
            Result := osWin2k
          else if ((majorVer = 5) and (minorVer = 1)) then
            Result := osWinxp
          else
            Result := OsUnknown;
        end;
      VER_PLATFORM_WIN32_WINDOWS: { Windows 9x/ME }
        begin
          if ((majorVer = 4) and (minorVer = 0)) then
            Result := osWin95
          else if ((majorVer = 4) and (minorVer = 10)) then
          begin
            if (osVerInfo.szCSDVersion[1] = 'A') then
              Result := osWin98se
            else
              Result := osWin98;
          end
          else if ((majorVer = 4) and (minorVer = 90)) then
            Result := OsWinME
          else
            Result := OsUnknown;
        end;
    else
      Result := OsUnknown;
    end; //end of case
  end
  else
    Result := OsUnknown;
end;

//��ñ���IP��ַ(��̬�����IP)

function LocalIP: string;
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array[0..63] of char;
  I: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(buffer);
  if phe = nil then
    Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  result := StrPas(inet_ntoa(pptr^[i]^));
  WSACleanup;
end;

function HostName: string;
var
  Buffer: array[0..127] of char;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  result := '';
  GetHostName(Buffer, Sizeof(Buffer));
  result := StrPas(Buffer);
  WSACleanup;
end;

procedure TFrmADSLMain.InitDateProc;
var
  INI: TINIFile;
  Reg: TRegistry;
begin
  Path := ExtractFilePath(ParamStr(0));

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', False) then
      if Reg.ReadString('ADSL') = '' then
        Reg.WriteString('ADSL', Application.ExeName);
  finally
    FreeAndNil(Reg);
  end;

  INI := TINIFile.Create(Path + 'ADSL.ini');
  try
      IsSetupDay := INI.ReadBool('Setup', 'SetupBool', False);
      XSTimeMonth := StrToInt(INI.ReadString('Setup', 'MonthDate', '120'));
      //ÿ�µ���ʱСʱ
      XSTimeDay := StrToInt(INI.ReadString('Setup', 'Date', '5'));
      //ÿ�����ʱСʱ
      JSDay := StrToInt(INI.ReadString('Setup', 'Start', '21')); //��ʱ��ʼ����

      //�Ƿ�ʹ����������
      IsCallSound := INI.ReadBool('Setup', 'Sound', False);
      IsDefaultSound := INI.ReadBool('Setup', 'DefaultSound', True);

      if (JSDay = DayOf(Now)) and (IsSetupDay = False) then
        //�������ÿ���µļ�ʱ����
      begin
        MonthDate := '00:00:00';
        INI.WriteBool('Setup', 'SetupBool', IsSetupDay);
      end
      else
      begin
        MonthDate := INI.ReadString('Date', 'SumTime', '00:00:00');
        INI.WriteBool('Setup', 'SetupBool', IsSetupDay);
      end;

      MonthStart := INI.ReadDateTime('Date', 'Start', Now);

      szCallSound := INI.ReadString('Setup', 'SoundPath', '');
  finally
    INI.Free;
  end;
  ReadFileToListView(Path + 'ADSL.trv');
  DateTimePicker1.Date := Now;
  AddNameToTreeNode;
  AddIPToListView;
end;

procedure TFrmADSLMain.FormCreate(Sender: TObject);
begin
  InitDateProc;

  lblMonthStr.Caption := Str1 + MonthDate;
  lblCurStr.Caption := Str2 + FormatDateTime('hh:mm:ss', CurrentDate);
  lblStartStr.Caption := Str3 + DateTimeToStr(MonthStart);
  case GetOSVersion of //
    osUnknown..osWinme:
      begin
        MenuFrmTrans.Enabled := False;
        MenuFrmTrans.Checked := False;
      end;
  end; // case
end;

procedure TFrmADSLMain.ShowDropFrm;
begin
  if FrmDrop.Showing = False then
  begin
    if MenuDropFrm.Checked then
    begin
      FrmDrop := TFrmDrop.Create(Self);
      FrmDrop.Visible := True;
      FrmADSLMain.Visible := True;
    end;
    if MenuFrmTrans.Checked then
    begin
      FrmDrop.AlphaBlend := True;
      FrmDrop.AlphaBlendValue := 150;
    end;
  end;
  FrmDrop.Label1.Caption := MonthDate;
  ListView1.SetFocus;
end;

procedure TFrmADSLMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  FreeAndNil(tmrChecker);
  FreeAndNil(tmrTime);
  EndTime := CurrentDate;
  //������ʱ������Ҫ��MonthDate�ַ�����ֵ�µ�ʱ��
  MonthDate := CountStrToDateTime(MonthDate, EndTime);
  if (CurrentDate <> 0) or (EndTime <> 0) then
  begin
    MonthDate := CountStrToDateTime(MonthDate, EndTime);
    WriteTimeToFile(Path + 'ADSL.ini', MonthDate);
  end;

  SendMessage(FrmDrop.Handle, WM_CLOSE, 0, 0);
end;

procedure TFrmADSLMain.MenuDropFrmClick(Sender: TObject);
begin
  MenuDropFrm.Checked := not MenuDropFrm.Checked;
  MenuShowDrop.Checked := not MenuShowDrop.Checked;
  if MenuDropFrm.Checked then
  begin
    FrmDrop.Visible := True;
    FrmDrop.pelMain.Visible := True;
  end
  else
  begin
    FrmDrop.Hide;
  end;
end;

procedure TFrmADSLMain.FormShow(Sender: TObject);
begin
  ShowDropFrm;
end;

procedure TFrmADSLMain.MenuFrmTransClick(Sender: TObject);
begin
  MenuFrmTrans.Checked := not MenuFrmTrans.Checked;
  MenuDropTran.Checked := not MenuDropTran.Checked;
  if MenuFrmTrans.Checked then
  begin
    FrmDrop.AlphaBlend := True;
    FrmDrop.AlphaBlendValue := 150;
  end
  else
    FrmDrop.AlphaBlend := False;
end;

procedure TFrmADSLMain.AddNameToTreeNode;
var
  Node: TTreeNode;
begin
  Node := TTreeNode.Create(TreeView1.Items);
  TreeView1.Items.Add(Node, HostName);
end;

procedure TFrmADSLMain.AddIPToListView;
var
  Item: TListItem;
begin
  //ListView1.Clear;
  Item := ListView1.Items.Add;
  Item.Caption := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
  Item.SubItems.Add('');
  Item.SubItems.Add('');
  Item.SubItems.Add(HostName);
  Item.SubItems.Add('ADSL');
  Item.SubItems.Add(LocalIP);
end;

procedure TFrmADSLMain.MenuOptionClick(Sender: TObject);
begin
  Application.CreateForm(TFrmSetup, FrmSetup);
  FrmSetup.ShowModal;
end;

//�����������Ƿ���������

procedure TFrmADSLMain.tmrCheckerTimer(Sender: TObject);
begin
  if CheckOffline then
    tmrTime.Enabled := True
  else
  begin
    FrmDrop.Label1.Caption := MonthDate;
    tmrTime.Enabled := False;
    EndTime := CurrentDate; //������ʱ���EndTime��ֵ
  end;
end;

procedure TFrmADSLMain.tmrTimeTimer(Sender: TObject);
begin //�ⲿ�ּ��������Ϊд�ķǳ����ã�ϣ�����(�����������˿��ԸĽ���)
  try
    CurrentDate := IncSecond(CurrentDate);
    EndTime := CurrentDate;
  except
    CurrentDate := 0;
    DateTimePicker1.Date := Now;
    MonthDate := CountStrToDateTime(MonthDate, EndTime);
    WriteTimeToFile(Path + 'ADSL.ini', MonthDate);
  end;

  if HourOf(CurrentDate) = XSTimeDay then
    //�����ж��Ƿ�ʹ������
    if IsCallSound = False then
    begin
      MessageBox(Handle, '����������ʱ���Ѿ�����!', '��ʾ', MB_OK);
      Sleep(100);
      tmrChecker.Enabled := False;
      tmrTime.Enabled := False;
    end
    else
    begin
      //�����ʹ��������������ô�ȿ��Ƿ���ʹ��Ĭ������
      if IsDefaultSound then
      begin
        MessageBeep(0);
        Sleep(100);
        tmrChecker.Enabled := False;
        tmrTime.Enabled := False;
      end
      else
      begin
        PlaySound(PChar(szCallSound), 0, SND_ASYNC);
        Sleep(100);
        tmrChecker.Enabled := False;
        tmrTime.Enabled := False;
      end;
    end;

  if StrToInt(Copy(MonthDate, 1, Pos(':', MonthDate) - 1)) = XSTimeMonth then
    if IsCallSound = False then
    begin
      MessageBox(Handle, '��������ʱ���Ѿ�����!', '��ʾ', MB_OK);
      Sleep(100);
      tmrChecker.Enabled := False;
      tmrTime.Enabled := False;
    end
    else
    begin
      //�����ʹ��������������ô�ȿ��Ƿ���ʹ��Ĭ������
      if IsDefaultSound then
      begin
        MessageBeep(0);
        Sleep(100);
        tmrChecker.Enabled := False;
        tmrTime.Enabled := False;
      end
      else
      begin
        PlaySound(PChar(szCallSound), 0, SND_ASYNC);
        Sleep(100);
        tmrChecker.Enabled := False;
        tmrTime.Enabled := False;
      end;
    end;

  FrmDrop.Label1.Caption := MonthDate;
  lblMonthStr.Caption := Str1 + MonthDate;

  FrmDrop.Label2.Caption := FormatDateTime('hh:mm:ss', CurrentDate);
  lblCurStr.Caption := Str2 + FormatDateTime('hh:mm:ss', CurrentDate);
end;

procedure TFrmADSLMain.WriteTimeToFile(FileName: string; SumTime: string);
var
  fINI: TINIFile;
  fText: TextFile;
  i: integer;
  tmp: string;
begin
  if FileExists(FileName) = False then
    FileName := Path + 'ADSL.ini';

  //==============�رճ����ʱ����Ҫ����Ķ���=============//
  ListView1.Items[ListView1.Items.Count - 1].SubItems[0] :=
    FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
  ListView1.Items[ListView1.Items.Count - 1].SubItems[1] :=
    FormatDateTime('hh:mm:ss', EndTime);
  //=======================================================//

  AssignFile(fText, ExtractFilePath(FileName) + 'ADSL.trv');
  Rewrite(fText);
  try
    for i := 0 to ListView1.Items.Count - 1 do // Iterate
    begin
      try
        tmp := ListView1.Items[i].Caption + #7 +
          ListView1.Items[i].SubItems[0] + #7 +
          ListView1.Items[i].SubItems[1] + #7 +
          ListView1.Items[i].SubItems[2] + #7 +
          ListView1.Items[i].SubItems[3] + #7 +
          ListView1.Items[i].SubItems[4];
        Writeln(fText, tmp);
      except
        CloseFile(fText);
      end;
    end; // for
  finally
    CloseFile(fText);
  end;

  fINI := TINIFile.Create(FileName);
  fINI.WriteString('Date', 'SumTime', SumTime);
  if fINI.ReadDateTime('Date', 'Start', 0) = 0 then
    fINI.WriteDateTime('Date', 'Start', MonthStart);
  FreeAndNil(fINI);
end;

procedure TFrmADSLMain.WM_MyAppendMenu(var msg: TWMSysCommand);
begin
  if msg.CmdType = SC_CLOSE then
  begin
    Application.Minimize;
    MenuShowMain.Checked := False;
  end
  else
    inherited;
end;

procedure TFrmADSLMain.MenuCloseClick(Sender: TObject);
begin
  Close;
end;

function TFrmADSLMain.CheckOffline: boolean;
const
  //����Ĵ�����Ǽ���Ƿ����ߵĵ���InternetGetConnectedState
 //���API�������ǲ�ǿ������û��ھ������У����������Ч��2003-04-25
  INTERNET_CONNECTION_MODEM = 1;

  INTERNET_CONNECTION_LAN = 2;

  INTERNET_CONNECTION_PROXY = 4;

  INTERNET_CONNECTION_MODEM_BUSY = 8;
var
  dwConnectionTypes: DWORD;
begin
  dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN
    + INTERNET_CONNECTION_PROXY + INTERNET_CONNECTION_MODEM_BUSY;

  Result := InternetGetConnectedState(@dwConnectionTypes, 0);
end;

procedure TFrmADSLMain.MenuShowMainClick(Sender: TObject);
begin
  MenuShowMain.Checked := not MenuShowMain.Checked;

  if MenuShowMain.Checked = False then
    ShowWindow(FrmADSLMain.Handle, SW_HIDE)
  else
    ShowWindow(FrmADSLMain.Handle, SW_SHOW);
end;

procedure TFrmADSLMain.MenuAboutClick(Sender: TObject);
begin
  Application.CreateForm(TAboutBox, AboutBox);
  AboutBox.ShowModal;
end;

procedure TFrmADSLMain.MMenuDropSetupClick(Sender: TObject);
begin
  FrmDropSetup := TFrmDropSetup.Create(Self);
  FrmDropSetup.Visible := True;
end;

procedure TFrmADSLMain.ReadFileToListView(FileName: string);
var
  Item: TListItem;
  tmp, tmp1: string;
  Str: TStrings;
  fText: TextFile;
  i: integer;
begin
  Str := TStringList.Create;
  if FileExists(FileName) then
  begin
    AssignFile(fText, FileName);
    Reset(fText);
    try
      while not EOF(fText) do
      begin
        Readln(fText, tmp);
        while Pos(#7, tmp) <> 0 do
        begin
          tmp1 := Copy(tmp, 1, Pos(#7, tmp) - 1);
          tmp := Copy(tmp, Pos(#7, tmp) + 1, Length(tmp));
          Str.Add(tmp1);
        end; //while
        if tmp <> '' then
          Str.Add(tmp);
        if Str.Count <> 0 then
        begin
          //��ʼ��ListView1����װ���ļ��ж�ȡ�����Ķ���
          Item := ListView1.Items.Add;
          Item.Caption := Str.Strings[0];
          for i := 1 to Str.Count - 1 do // Iterate
          begin
            Item.SubItems.Add(Str.Strings[i]);
          end; // for
          Str.Clear;
        end;
      end; // while
    finally
      CloseFile(fText);
    end;
  end;
end;

procedure TFrmADSLMain.E1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'MailTo:jackyshenno1@163.com', nil, nil,
    SW_SHOW); //�벻Ҫ��������Ĵ��룬�����Ҫ�����԰������޸�Ϊ��������
  //���û�ѡ�����λ���߷���E-Mail
end;

function TFrmADSLMain.CountStrToDateTime(const str: string;
  DateTime: TDateTime): string;
var
  strs: TStrings;
  tmp: string;
  i: integer;
begin
  strs := TStringList.Create;
  tmp := str;
  while Pos(':', tmp) <> 0 do
  begin
    strs.Add(Copy(tmp, 1, Pos(':', tmp) - 1));
    tmp := Copy(tmp, Pos(':', tmp) + 1, Length(tmp));
  end; // while
  if tmp <> '' then
    strs.Add(tmp);
  tmp := '';
  //strs���ֻ�ܴ���3��Items
  if strs.Count - 1 > 3 then
    result := DateTimeToStr(Now)
  else
  begin
    strs.Strings[0] := IntToStr(Hourof(DateTime) + StrToInt(strs.Strings[0]));
    strs.Strings[1] := IntToStr(MinuteOf(DateTime) + StrToInt(strs.Strings[1]));
    if StrToInt(strs.Strings[1]) > 60 then
    begin
      i := StrToInt(strs.Strings[1]) div 60;
      strs.Strings[0] := IntToStr(StrToInt(strs.Strings[0]) + i);
      strs.Strings[1] := IntToStr(StrToInt(strs.Strings[1]) - i * 60);
    end;

    strs.Strings[2] := IntToStr(SecondOf(DateTime) + StrToInt(strs.Strings[2]));
    if StrToInt(strs.Strings[2]) > 60 then
    begin
      i := StrToInt(strs.Strings[2]) div 60;
      strs.Strings[1] := IntToStr(StrToInt(strs.Strings[1]) + i);
      strs.Strings[2] := IntToStr(StrToInt(strs.Strings[2]) - i * 60);
    end;

    tmp := tmp + strs.Strings[0] + ':' + strs.Strings[1] + ':' +
      strs.Strings[2];
  end;
  result := tmp;
end;

procedure TFrmADSLMain.MenuHelpTopicClick(Sender: TObject);
begin
  ShowMessage('����������ѳ���,û���Դ�����,���������Ȥ����дһ���������' +
    '�İ����ļ�,д���һ��Ҫ������һ��Ŷ!');
  //ϣ����ι������Դ���룬��������ʿ����дһ���Ƚ����Ƶİ�������Ȼ���Ƶİ���
  //����Ҫ���������Ƶĳ����ϵġ�
end;

initialization
  //����һ��������󣬷�ֹӦ�ó����ظ�����
  hnd := CreateMutex(nil, True, 'ShenJie ADSL');
  if GetLastError = ERROR_ALREADY_EXISTS then
    Halt;
finalization
  if hnd <> 0 then
    CloseHandle(hnd);
end.

