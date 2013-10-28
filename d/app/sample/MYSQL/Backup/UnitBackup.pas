unit UnitBackup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db,ADODB, ExtCtrls, ShellApi, Menus,
  ComCtrls, Registry, ScktComp , StdCtrls , Buttons,  Variants,IniFiles ,StrUtils,
  ImgList ;

 const
  WM_BARICON=WM_USER+200; //�Զ�����Ϣ
  ID_MAIN=100;//����ͼ���ID
type
  TFrmBackup = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CmbServerName: TComboBox;
    CmbDatabaseName: TComboBox;
    EdtUserName: TEdit;
    EdtPassword: TEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    cboAutoRun: TCheckBox;
    EdtPath: TEdit;
    btnPath: TButton;
    btnSetTime: TBitBtn;
    connAdo: TADOConnection;
    connQuery: TADOQuery;
    btnBackup: TBitBtn;
    Timer1: TTimer;
    cboShowMessage: TCheckBox;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ImageList1: TImageList;
    cboMin: TCheckBox;
    cboClose: TCheckBox;
    cboStart: TCheckBox;
    BitBtn1: TBitBtn;
    Button1: TButton;
    procedure btnSetTimeClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure btnPathClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FilePath:String;
    BackupIniFile:TIniFile;
    ServerName,DatabaseName,UserName,Password:String;

    Run,StartMin,Show,Min,CloseShow:integer;
    Conn:Boolean;  //�ж������Ƿ�ɹ�
    connString:String; //�����ַ���
    BackFileName:String; //�����ļ�������
    procedure AddIcon(hwnd:HWND);
    procedure RemoveIcon(hwnd: HWND); //��״̬����ȥͼ��

    procedure WMSysCommand(var Message: TMessage); message WM_SYSCOMMAND;
    procedure WMBarIcon(var Message:TMessage);message WM_BARICON;
    procedure WMMini(var Message:TMessage);message WM_SETFOCUS;
    procedure BackupBase(FileName:String); //���屸�ݹ���
    procedure ReadIni; //��ȡINI�ļ��е�����
  public
    { Public declarations }

    BackupType,EveryTime,EveryDay,EveryMonth,EveryWeek:integer;
    procedure ComBoboxValue(Cmb:TComBoBox;Str:string) ;
  end;


var
  FrmBackup: TFrmBackup;
implementation

uses UnitFrmSetupTime, UnitFilePath, UnitDirPath, UnitDlg, UnitChose;

{$R *.dfm}
procedure TFrmBackup.AddIcon(hwnd:HWND);
var
  lpData:PNotifyIconData;
begin
  lpData := new(PNotifyIconDataA);
  lpData.cbSize := 88;
  lpData.Wnd := FrmBackup.Handle;
  lpData.hIcon := FrmBackup.Icon.Handle;
  lpData.uCallbackMessage := WM_BARICON;
  lpData.uID :=0;
  lpData.szTip := '���ݿⱸ�ݹ���';
  lpData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  Shell_NotifyIcon(NIM_ADD,lpData);
  dispose(lpData);
  FrmBackup.Visible := False;
end;

procedure TFrmBackup.RemoveIcon(hwnd: HWND);//��״̬����ȥͼ��
var
  lpData:PNotifyIconData;
begin
  //����û����������ͼ����ͼ��ɾ�����ظ����ڡ�
  lpData := new(PNotifyIconDataA);
  lpData.cbSize := 88;//SizeOf(PNotifyIconDataA);
  lpData.Wnd := FrmBackup.Handle;
  lpData.hIcon := FrmBackup.Icon.Handle;
  lpData.uCallbackMessage := WM_BARICON;
  lpData.uID :=0;
  lpData.szTip := 'Samples';
  lpData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  Shell_NotifyIcon(NIM_DELETE,lpData);
  dispose(lpData);
end;

procedure TFrmBackup.WMSysCommand(var Message:TMessage);
begin
  if Message.WParam = SC_ICON then
  begin
     //����û���С�������򽫴���
     //���ز��������������ͼ��
     AddIcon(handle);
  end
  else if (Message.WParam= SC_Close) and (Min=1)then begin
      Application.Minimize;
      AddIcon(handle);
  end
  else if (Message.WParam=WM_CREATE) and (Min=1)then begin
      Application.Minimize;
      AddIcon(handle);
  end
  else
     //�����������SystemCommand
     //��Ϣ�����ϵͳȱʡ����������֮��
     DefWindowProc(FrmBackup.Handle,Message.Msg,Message.WParam,Message.LParam);
end;

procedure TFrmBackup.WMBarIcon(var Message:TMessage);
var
   lpData:PNotifyIconData;
   Pt:TPoint;
begin
  if (Message.LParam = WM_LBUTTONDOWN) then
   begin
     RemoveIcon(handle);
     FrmBackup.Visible := True;
   end
   else if (Message.LParam=WM_RBUTTONDOWN) then
   begin
     SetForeGroundWindow(lpData.Wnd);
     GetCursorPos(Pt);
     Popupmenu.Popup(Pt.X,pt.y);
   end;
end;

procedure TFrmBackup.WMMini(var Message:TMessage);
begin
  if (Message.Msg=WM_CREATE) then begin
      Application.Minimize;
      AddIcon(handle);
  end
end;

//���屸�ݹ���
procedure TFrmBackup.BackupBase(FileName:String);
begin
  try
    screen.Cursor:=crSqlWait;
    with connQuery do
    begin
      close;
      Sql.Text:='Backup Database '+Trim(CmbDatabaseName.Text)+' to Disk='''+FileName+''' ';
      ExecSQL;
    end;
    screen.Cursor:=crDefault;
  except
    MessageBox(handle,'����ʧ�ܣ�','��ʾ',MB_IconWarning+mb_Ok);
    screen.Cursor:=crDefault;
    Exit;
  end;
end;

//��ȡINI�ļ��е�����
procedure TFrmBackup.ReadIni;
begin
  FilePath:=ExtractFilePath(Application.ExeName)+'System.ini';
  BackupIniFile:=TIniFile.Create(FilePath);
  ServerName:=BackupIniFile.ReadString('Database','ServerName','');
  DatabaseName:=BackupIniFile.ReadString('Database','DatabaseName','');
  UserName:=BackupIniFile.ReadString('Database','UserName','');
  Password:=BackupIniFile.ReadString('Database','Password','');
  Run:=BackupIniFile.ReadInteger('AutoRun','Run',0);
  StartMin:=BackupIniFile.ReadInteger('AutoRun','StartMin',0); 
  Show:=BackupIniFile.ReadInteger('AutoRun','Show',0);
  Min:=BackupIniFile.ReadInteger('AutoRun','Min',0);
  CloseShow:=BackupIniFile.ReadInteger('AutoRun','CloseShow',0);

  BackupType:=BackupIniFile.ReadInteger('Backup','BackupType',0);
  EveryTime:=BackupIniFile.ReadInteger('Backup','EveryTime',0);
  EveryDay:=BackupIniFile.ReadInteger('Backup','EveryDay',0);
  EveryWeek:=BackupIniFile.ReadInteger('Backup','EveryWeek',0);
  EveryMonth:=BackupIniFile.ReadInteger('Backup','EveryMonth',0);

  CmbServerName.Text:=ServerName;
  //CmbDatabaseName.Text:=DatabaseName;

  ComBoboxValue(cmbDatabaseName,DatabaseName);

  EdtUserName.Text:=UserName;
  EdtPassword.Text:=Password;
  EdtPath.Text:=BackupIniFile.ReadString('FilePath','Path','');
  
  if Run=1 then  //��ʼ��<�濪������>
    cboAutoRun.Checked:=True
  else
    cboAutoRun.Checked:=False;
  if StartMin=1 then //��ʼ��<��������С��>
    cboStart.Checked:=True
  else
    cboStart.Checked:=False;
  if Show=1 then //��ʼ��<����ʱ��ʾ��ʾ��Ϣ>
    cboShowMessage.Checked:=True
  else
    cboShowMessage.Checked:=False;
  if Min=1 then  //��ʼ��<�ر�ʱ��С��>
    cboMin.Checked:=True
  else
    cboMin.Checked:=False;
  if CloseShow=1 then  //��ʼ��<����ʾ�ر���Ϣ>
    cboClose.Checked:=True
  else
    cboClose.Checked:=False;
end;

procedure TFrmBackup.btnSetTimeClick(Sender: TObject);
begin
  Application.CreateForm(TFrmSetupTime,FrmSetupTime); 
  FrmSetupTime.ShowModal;
  FrmSetupTime.Free;
end;

procedure TFrmBackup.btnSaveClick(Sender: TObject);
var
  reg:TRegistry;
  S_RegTree:String;
begin
  if not conn then //�ж����ݿ������Ƿ�ɹ���ֻ�гɹ�֮����ܱ���
  begin
    MessageBox(handle,'���ݿ�����û�гɹ������Բ��ܱ��棡','����',mb_IconWarning+mb_Ok);
    CmbServerName.SetFocus;
    Exit;
  end;
  //�����ݿ����Ӳ������浽Ini�ļ���
  BackupIniFile.WriteString('Database','ServerName',Trim(CmbServername.Text));
  BackupIniFile.WriteString('Database','DatabaseName',DatabaseName);
  BackupIniFile.WriteString('Database','UserName',Trim(EdtUserName.Text));
  BackupIniFile.WriteString('Database','Password',Trim(EdtPassword.Text));
  BackupIniFile.WriteString('FilePath','Path',Trim(EdtPath.Text));
  //�ж��Ƿ񿪻�ʱ��ϵͳ
  reg:=tregistry.Create;
  Reg.RootKey:=HKEY_LOCAL_MACHINE;
  S_RegTree:='\Software\Microsoft\Windows\CurrentVersion\Run';
  if Reg.OpenKey(S_RegTree,False)=false then
    Reg.CreateKey(S_RegTree);
  Reg.OpenKey(S_RegTree,True);
  FilePath:=ExtractFilePath(Application.ExeName)+'Backup.exe';

  if cboAutoRun.Checked then
  begin
    Reg.WriteString('BackupDatabase',FilePath);
    BackupIniFile.WriteInteger('AutoRun','Run',1);
  end
  else begin
    Reg.DeleteValue('BackupDatabase');
    BackupIniFile.WriteInteger('AutoRun','Run',0);
  end;
  //��������С��
  if cboStart.Checked then
    BackupIniFile.WriteInteger('AutoRun','StartMin',1)
  else
    BackupIniFile.WriteInteger('AutoRun','StartMin',0);
  //<����ʱ��ʾ��ʾ��Ϣ>
  if cboShowMessage.Checked then
    BackupIniFile.WriteInteger('AutoRun','Show',1)
  else
    BackupIniFile.WriteInteger('AutoRun','Show',0);
  //<�ر�ʱ��С��>
  if cboMin.Checked then
    BackupIniFile.WriteInteger('AutoRun','Min',1)
  else
    BackupIniFile.WriteInteger('AutoRun','Min',0);
  //<��ʾ�ر���Ϣ>
  if cboClose.Checked then
    BackupIniFile.WriteInteger('AutoRun','CloseShow',1)
  else
    BackupIniFile.WriteInteger('AutoRun','CloseShow',0);
  Reg.Free;
  ReadIni();
end;

procedure TFrmBackup.btnBackupClick(Sender: TObject);
var
  FilePath:String;
  i:integer;
  str:String;
begin
  try
    if Show=1 then begin
      application.CreateForm(tfrmDlg,frmDlg);
      frmDlg.Show;
    end;

    for i:=0 to cmbDatabaseName.Items.Count-1 do
    begin
      //�ļ�������<������ʱ����>
      BackFileName:=Trim(CmbDatabaseName.Items[i])+FormatDateTime('yyyymmddhhmmss',Now); //ȡ�ñ����ļ���

      //ȡ�õ�ַ���еĵ�ַ
      if RightStr(EdtPath.text,1)='\' then
         FilePath:=EdtPath.Text
      else
         FilePath:=EdtPath.Text+'\';

      FilePath:=FilePath+BackFileName;
      screen.Cursor:=crSqlWait;

      //      BackupBase(FilePath); //���ñ��ݹ��̱����ļ�
      screen.Cursor:=crSqlWait;

      str:='Backup Database '+Trim(CmbDatabaseName.Items[i])+' to Disk='''+FilePath+''' ';

      with connQuery do
      begin
        close;
        Sql.Text:=str;
        ExecSQL;
      end;
    end;

    screen.Cursor:=crDefault;

    if Show=1 then
    begin
      frmDlg.Close;
      frmDlg.Free;
    end;
    
  except
    MessageBox(handle,'����ʧ�ܣ�','��ʾ',MB_IconWarning+mb_Ok);
    screen.Cursor:=crDefault;
    frmDlg.Close;
    frmDlg.Free;
    Exit;
  end;
end;


procedure TFrmBackup.btnPathClick(Sender: TObject);
begin
  Application.CreateForm(TFrmDirPath,FrmDirPath); 
  if FrmDirPath.ShowModal=mrOk then
    EdtPath.Text:=FrmDirPath.DirectoryListBox1.Directory;
end;

procedure TFrmBackup.Timer1Timer(Sender: TObject);
var
  Year,Month,Day,Hour,Min,Sec,MSec:Word;
begin
  DecodeDate(Now,Year,Month,Day);
  DecodeTime(Now, Hour, Min, Sec, MSec);

  case BackupType of
  0:begin//������
      //
    end;
  1:begin//ÿСʱ
      if (Min=EveryTime) and (Sec=0) then
        btnBackupClick(btnBackup);
    end;
  2:begin//ÿ��
      if (Hour=EveryDay) and (Min=EveryTime) and (Sec=0) then
        btnBackupClick(btnBackup);
    end;
  3:begin//ÿ��
      if ((DayOfWeek(Date)-1)=EveryWeek) and (Hour=EveryDay) and (Min=EveryTime) and (Sec=0) then
        btnBackupClick(btnBackup);
    end;
  4:begin//ÿ��
      if (Day=EveryMonth) and (Hour=EveryDay) and (Min=EveryTime) and (Sec=0) then
        btnBackupClick(btnBackup);
    end;
  end;

end;

procedure TFrmBackup.FormCreate(Sender: TObject);
begin
  ReadIni();
  connString:='Driver={SQL server};server='+Trim(CmbServerName.Text)+';database='+Trim(CmbDatabaseName.Text)+
              ';uid='+Trim(EdtUserName.Text)+';pwd='+Trim(EdtPassword.Text);
  try
    connAdo.ConnectionString:=connString;
    connAdo.LoginPrompt:=False;
    connAdo.Connected:=True;
    conn:=True;
  except
    MessageBox(handle,'�������ݿ����','����',mb_IconWarning+mb_Ok);
    Exit;
  end;


  //�ж�����ʱ�Ƿ���С������
 { if StartMin=1 then
  begin
    //Application.Minimize;
    AddIcon(handle);
  end;  }
end;

procedure TFrmBackup.btnCancelClick(Sender: TObject);
begin
  //ȡ���������޸�
  ReadIni();
end;

procedure TFrmBackup.N2Click(Sender: TObject);
begin
  close;
end;

procedure TFrmBackup.N1Click(Sender: TObject);
begin
  FrmBackup.Visible := True;
end;

procedure TFrmBackup.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if CloseShow=1 then
  begin
    if MessageBox(Handle,'ȷʵҪ�ر�ϵͳ��','��ʾ',MB_YESNO+MB_ICONINFORMATION)=IDNO then
    begin
      canClose:=False;
    end
    else
    begin
      RemoveIcon(handle);
      Application.Terminate ;
    end;
  end
  else begin
    RemoveIcon(handle);
    Application.Terminate ;
  end;
end;

procedure TFrmBackup.BitBtn1Click(Sender: TObject);
begin
  if Trim(CmbServerName.Text)='' then
  begin
    MessageBox(handle,'���ݿ���������Ʋ���Ϊ�գ�','����',mb_IconWarning+mb_Ok);
    CmbServerName.SetFocus;
    Exit;
  end;
  if Trim(CmbDatabaseName.Text)='' then
  begin
    MessageBox(handle,'���ݿ����Ʋ���Ϊ�գ�','����',mb_IconWarning+mb_Ok);
    CmbDatabaseName.SetFocus;
    Exit;
  end;
  if Trim(EdtUserName.Text)='' then
  begin
    MessageBox(handle,'�û�������Ϊ�գ�','����',mb_IconWarning+mb_Ok);
    EdtUserName.SetFocus;
    Exit;
  end;
  connString:='Driver={SQL server};server='+Trim(CmbServerName.Text)+';database='+Trim(CmbDatabaseName.Text)+
              ';uid='+Trim(EdtUserName.Text)+';pwd='+Trim(EdtPassword.Text);
  try
    screen.Cursor:=crSqlwait;
    with connAdo do
    begin
      if Connected then
         Connected:=False;
      ConnectionString:=connString;
      LoginPrompt:=False;
      Connected:=True;
    end;
    MessageBox(handle,'���ӳɹ���','��ʾ',MB_ICONINFORMATION+mb_Ok);
    conn:=True;
    screen.Cursor:=crdefault;
  except
    MessageBox(handle,'����ʧ�ܣ�','��ʾ',mb_IconWarning+mb_Ok);
    screen.Cursor:=crdefault;
    conn:=False;
    Exit;
  end;
end;

procedure TFrmBackup.Button1Click(Sender: TObject);
var
  i,j:integer;
begin
  Application.CreateForm(TfrmChoose,frmChoose);
  //ȡ�÷��������������ݿ���
  with connQuery do
  begin
    Close;
    Sql.Text:='select * from master.dbo.sysdatabases';
    open;
    while not Eof do
    begin
      frmChoose.list.Items.Add(Fields[0].Value);
      next;
    end;
  end;

  //�б����ȡ��Ҫ���ݵ����ݿ�����
  for i:=0 to cmbDatabaseName.Items.Count-1 do
  begin
    for j:=0 to frmChoose.list.Count-1 do
    begin
      if frmChoose.list.Items[j]=cmbDatabaseName.Items[i] then
        frmChoose.list.Checked[j]:=True;  
    end;
  end;

  if frmChoose.ShowModal=mrok then
  begin
    cmbDatabaseName.Clear;
    DatabaseName:='';
    for i:=0 to frmChoose.list.Count-1 do
    begin
      if frmChoose.list.Checked[i] then
      begin
        DatabaseName:=DatabaseName+frmChoose.list.Items[i]+'|';
        cmbDatabaseName.Items.Add(frmChoose.list.Items[i]);
      end;
    end;

    cmbDatabaseName.ItemIndex:=0;
  end;
end;


procedure TFrmBackup.ComBoboxValue(Cmb:TComBoBox;Str:string) ;
var i,j,k,n:integer ;
    s:string;
begin
  K:=0 ; n:=1;
  Cmb.Clear;
  For i:=1 to Length(Str) do
    if copy(Str,i,1)='|' then
      begin
        s:=copy(Str,n,i-n) ;
        Cmb.Items.Add(s);
        n:=i+1;
        k:=K+1 ;
      end ;
     Cmb.ItemIndex:=0; 
end;

end.
