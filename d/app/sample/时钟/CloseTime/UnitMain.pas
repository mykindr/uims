unit UnitMain;
//Download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, WinSkinStore, WinSkinData, Spin, ExtCtrls, ShellApi,
  ComCtrls, IniFiles, CoolTrayIcon, Buttons, ActnList;

type
  TFormMain = class(TForm)
    YesBtn: TButton;
    GroupBox2: TGroupBox;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    ApplyFaceM: TMenuItem;
    ExitM: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    StopTaskM: TMenuItem;
    HnSE: TSpinEdit;
    MnSE: TSpinEdit;
    SnSE: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
    N8: TMenuItem;
    AlertCB: TCheckBox;
    PopupMenu1: TPopupMenu;
    StopTaskMP: TMenuItem;
    RestoreM: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    HideFormBtn: TButton;
    N13: TMenuItem;
    Timer3: TTimer;
    Timer4: TTimer;
    CoolTrayIcon1: TCoolTrayIcon;
    AboutP: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Image1: TImage;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    HelpP: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    TimeWayRG: TRadioGroup;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    ExplorB: TSpeedButton;
    CloseS: TRadioButton;
    RebootS: TRadioButton;
    DosthS: TRadioButton;
    DosthE: TEdit;
    OpenDialog1: TOpenDialog;
    SkinData1: TSkinData;
    ActionList1: TActionList;
    DosthAct: TAction;
    StopTaskAct: TAction;
    ExitAct: TAction;
    SetAct: TAction;
    AboutPHide: TAction;
    HelpPHide: TAction;
    procedure ApplyFaceMClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure YesBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure RestoreMClick(Sender: TObject);
    procedure HideFormBtnClick(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure ExplorBClick(Sender: TObject);
    procedure DosthActExecute(Sender: TObject);
    procedure StopTaskActExecute(Sender: TObject);
    procedure ExitActExecute(Sender: TObject);
    procedure SetActExecute(Sender: TObject);
    procedure AboutPHideExecute(Sender: TObject);
    procedure HelpPHideExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DoMySystem;
  end;

var
  FormMain: TFormMain;
  Hn,Mn,Sn: Integer;                   //ʱ���֡������
  MyIni: TIniFile;                     //Ini�����ļ�
  Ini: String;                         //Ini�ļ�����
  EndLimit: Int64;                     //����ʱʱ��
  EndAlert: Integer;                   //�����ѵ���ʱʱ��
  CurrentDir:String;                   //��ǰĿ¼
  Act: String;                         //ִ�ж���

const
  Title='<Ц����������  ʯ��ɽ>';

implementation

uses UnitAlert, UnitSet;

{$R *.dfm}

procedure TFormMain.DoMySystem;
var
  hToken: THandle;
  tkp: TOKEN_PRIVILEGES;
  ReturnLength: DWord;
begin
  if Act='�رգ�' then
  begin
    OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,hToken);
    LookupPrivilegeValue(nil,'SeShutdownPrivilege',tkp.Privileges[0].Luid);
    // �趨Ȩ��Ϊ1
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    // �õ�Ȩ��
    AdjustTokenPrivileges(hToken, FALSE, tkp, 0,nil,ReturnLength);
    // �رռ����
    ExitWindowsEx(EWX_SHUTDOWN or EWX_POWEROFF, 0);
    end;
  if Act='������' then
  begin
    OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,hToken);
    LookupPrivilegeValue(nil,'SeShutdownPrivilege',tkp.Privileges[0].Luid);
    // �趨Ȩ��Ϊ1
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    // �õ�Ȩ��
    AdjustTokenPrivileges(hToken, FALSE, tkp, 0,nil,ReturnLength);
    // ��������
    ExitWindowsEx(EWX_REBOOT OR EWX_POWEROFF, 0);
  end;
  if Act='ִ�У�' then
  begin
    Winexec(PChar(DosthE.Text),sw_Normal);
  end;
end;

procedure TFormMain.ApplyFaceMClick(Sender: TObject);
begin
  if SkinData1.Active=true then
  begin
    SkinData1.Active:= False;
    ApplyFaceM.Checked:= False;
  end
  else
  begin
    SkinData1.Active:= True;
    ApplyFaceM.Checked:= True;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Self.Left:= Screen.WorkAreaWidth-Self.Width-8;
  Self.Top:= Screen.WorkAreaHeight-Self.Height-12;
  CurrentDir:= ExtractFileDir(Application.ExeName);
  Ini:= ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
  MyIni:= TIniFile.Create(CurrentDir+'\'+Ini);
  CoolTrayIcon1.IconVisible:= False;
  EndLimit:= 0;
  StatusBar1.SimpleText:= Application.Title+Title;
//  if FileExists(CurrentDir+'\'+Ini) then
//  begin
    HnSE.Value:= MyIni.ReadInteger('��ʱ����','ʱ',0);
    MnSE.Value:= MyIni.ReadInteger('��ʱ����','��',0);
    SnSE.Value:= MyIni.ReadInteger('��ʱ����','��',30);
    TimeWayRG.ItemIndex:= MyIni.ReadInteger('��ʱ����','��ʱ��ʽ',0);
    AlertCB.Checked:= MyIni.ReadBool('��ʱ����','�ػ�����',True);
    SkinData1.Active:= MyIni.ReadBool('Ƥ������','����Ƥ��',True);
    Timer4.Enabled:= MyIni.ReadBool('��������','����ʱִ�ж�ʱ����',False);
//  end;
  ApplyFaceM.Checked:= SkinData1.Active;
  Timer3.Enabled:= not Timer4.Enabled;
end;

procedure TFormMain.YesBtnClick(Sender: TObject);
var
  TempDT: TDateTime;
begin
  if TimeWayRG.ItemIndex=0 then
  begin
    EndLimit:= HnSE.Value*3600+MnSE.Value*60+SnSE.Value;
  end;
  if TimeWayRG.ItemIndex=1 then
  begin
    Hn:= HnSE.Value;
    Mn:= MnSE.Value;
    Sn:= SnSE.Value;
    TempDT:= StrToDateTime(FormatDateTime('yyyy-mm-dd ', now)+IntToStr(Hn)+':'+IntToStr(Mn)+':'+IntToStr(Sn))-now;
    if TempDT<0 then TempDT:= TempDT+1;
    EndLimit:= Round((TempDT)*86400);
////    Timer2.Enabled:= True;             //ʱ����Ϸ�ʽ
  end;
  if AlertCB.Checked then
    EndAlert:= EndLimit-UnitAlert.Limit
  else
    EndAlert:= EndLimit;
  if CloseS.Checked or RebootS.Checked or DosthS.Checked then
  begin
    if DosthS.Checked then
    begin
      if DosthE.Text='' then
      begin
        ShowMessage('��ѡ��ʱִ�г���');
        Exit;
      end;
      Act:= 'ִ�У�';
    end;
    if CloseS.Checked  then Act:= '�رգ�';
    if RebootS.Checked then Act:= '������';
    CoolTrayIcon1.HideMainForm;
    CoolTrayIcon1.IconVisible:= True;
    Timer1.Enabled:= True;             //����ʱ��ʽ
    StopTaskAct.Enabled:= True;
    YesBtn.Enabled:= False;
    HnSE.Enabled:= False;
    MnSE.Enabled:= False;
    SnSE.Enabled:= False;
    CloseS.Enabled:= False;
    RebootS.Enabled:= False;
    DosthS.Enabled:= False;
  end
  else
    ShowMessage('��ѡ��Ҫִ�еĲ�����');
end;

//����ʱ��ʽ
procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  if EndAlert<=0 then
  begin
    Timer1.Enabled:= False;
    if AlertCB.Checked then
    begin
      CoolTrayIcon1.ShowMainForm;
      FormAlert.AlertTime.Enabled:= True;
      FormAlert.Show;
      FormMain.Visible:= False;
      HideFormBtn.Enabled:= False;
      RestoreM.Enabled:= False;
    end
    else
    begin
      DoMySystem;
    end;
    EndAlert:= 0;
    EndLimit:= 0;
  end;
  Dec(EndAlert);
  Dec(EndLimit);
  CoolTrayIcon1.Hint:= Application.Title+Title
                       +#13#10
                       +Act+FormatDateTime('hh"ʱ"nn"��"ss"��"',now()+EndLimit/86400)
                       +'('+FormatDateTime('hh:nn:ss',EndLimit/86400)+')';
  StatusBar1.SimpleText:= Act+FormatDateTime('hh:nn:ss',now()+EndLimit/86400)
                          +'(����ʱ��'+FormatDateTime('hh:nn:ss',EndLimit/86400)+')';
end;
//Timer Match��ʽ��������
procedure TFormMain.Timer2Timer(Sender: TObject);
var
  Hour,Min,Sec,MSec: Word;
begin
  DecodeTime(now,Hour,Min,Sec,MSec);
  if (Hn=Hour)and(Mn=Min)and(Sn=Sec) then
  begin
    Timer2.Enabled:= False;
    if AlertCB.Checked then
    begin
      CoolTrayIcon1.ShowMainForm;
      FormAlert.AlertTime.Enabled:= True;
      FormAlert.Show;
      FormMain.Visible:= False;
      HideFormBtn.Enabled:= False;
      RestoreM.Enabled:= False;
    end
    else
    begin
      DoMySystem;
    end;
  end;
end;

procedure TFormMain.N7Click(Sender: TObject);
begin
  HelpP.Visible:= False;
  AboutP.Visible:= True;
  AboutP.Align:= alclient;
end;

procedure TFormMain.N6Click(Sender: TObject);
begin
  AboutP.Visible:= False;
  HelpP.Visible:= True;
  HelpP.Align:= alClient;
end;

procedure TFormMain.RestoreMClick(Sender: TObject);
begin
//  FormMain.Visible:= True;
  CoolTrayIcon1.ShowMainForm;
  CoolTrayIcon1.IconVisible:= False;
end;

procedure TFormMain.HideFormBtnClick(Sender: TObject);
begin
  CoolTrayIcon1.IconVisible:= True;
  CoolTrayIcon1.HideMainForm;
  CoolTrayIcon1.Hint:= Application.Title+Title;
end;

procedure TFormMain.TrayIcon1Click(Sender: TObject);
begin
  if RestoreM.Enabled then
  begin
    CoolTrayIcon1.ShowMainForm;
    CoolTrayIcon1.iconVisible:= False;
    FormMain.Visible:= True;
  end;
end;

//����������
procedure TFormMain.Timer3Timer(Sender: TObject);
begin
  HideFormBtn.Click;
  Timer3.Enabled:= False;
end;
//��ʱ,��ʼ
procedure TFormMain.Timer4Timer(Sender: TObject);
begin
  YesBtn.Click;
  Timer4.Enabled:= False;
end;

procedure TFormMain.CoolTrayIcon1Click(Sender: TObject);
begin
  if Timer1.Enabled or Timer2.Enabled then
  begin
    CoolTrayIcon1.ShowMainForm;
    CoolTrayIcon1.IconVisible:=false;
    YesBtn.Enabled:=false;
  end
  else
  begin
    if FormAlert.AlertTime.Enabled=false then
    begin
      CoolTrayIcon1.ShowMainForm;
      CoolTrayIcon1.IconVisible:=false;
    end;
  end;
end;

procedure TFormMain.ExplorBClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    DosthE.Text:= OpenDialog1.FileName;
  end;
end;

procedure TFormMain.DosthActExecute(Sender: TObject);
begin
  ExplorB.Enabled:= DosthS.Checked;
  DosthE.Enabled:= DosthS.Checked;
end;

procedure TFormMain.StopTaskActExecute(Sender: TObject);
begin
  Timer1.Enabled:= False;
////  Timer2.Enabled:= False;
  FormAlert.AlertTime.Enabled:= False;
  UnitAlert.Limit:= 30;
  FormAlert.ProgressBar1.Position:=0;
  FormAlert.Close;
  StatusBar1.SimpleText:= Application.Title+Title;
  CoolTrayIcon1.Hint:= Application.Title+Title;
  YesBtn.Enabled:= True;
  StopTaskAct.Enabled:= False;
  HnSE.Enabled:= True;
  MnSE.Enabled:= True;
  SnSE.Enabled:= True;
  CloseS.Enabled:= True;
  RebootS.Enabled:= True;
  DosthS.Enabled:= True;
  HideFormBtn.Enabled:= True;
  RestoreM.Enabled:= True;
end;

procedure TFormMain.ExitActExecute(Sender: TObject);
begin
  if FormSet.SaveTimeCB.Checked then
  begin
    UnitMain.MyIni.Writebool('ϵͳ����','���涨ʱ����', True);
    UnitMain.MyIni.WriteInteger('��ʱ����','ʱ',FormMain.HnSE.Value);
    UnitMain.MyIni.WriteInteger('��ʱ����','��',FormMain.MnSE.Value);
    UnitMain.MyIni.WriteInteger('��ʱ����','��',FormMain.SnSE.Value);
    UnitMain.MyIni.WriteInteger('��ʱ����','��ʱ��ʽ',FormMain.TimeWayRG.ItemIndex);
    UnitMain.MyIni.WriteBool('��ʱ����','�ػ�����',FormMain.AlertCB.Checked);
  end;
  Application.Terminate;
end;

procedure TFormMain.SetActExecute(Sender: TObject);
begin
  FormSet.ShowModal;
end;

procedure TFormMain.AboutPHideExecute(Sender: TObject);
begin
  AboutP.Visible:= False;
end;

procedure TFormMain.HelpPHideExecute(Sender: TObject);
begin
  HelpP.Visible:= False;
end;

end.
