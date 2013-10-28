unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  StdCtrls, ShellAPI, ComCtrls, DB, GridsEh, DBGridEh, ASGSQLite3, ExtCtrls,
  IniFiles, ExtDlgs, ImgList, WinSkinData, U_TDownFile, Menus, ToolWin,HTTPApp,
  dxGDIPlusClasses;

type
  TFrmMain = class(TForm)
    pgc1: TPageControl;
    tsGeneral: TTabSheet;
    ts2: TTabSheet;
    Btn2: TButton;
    ts3: TTabSheet;
    ASQLite3DB1: TASQLite3DB;
    ds1: TDataSource;
    ASQLite3Table1: TASQLite3Table;
    ASQLite3Table2: TASQLite3Table;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    EdtStopTime: TEdit;
    lbl3: TLabel;
    lbl4: TLabel;
    Edt2: TEdit;
    grp2: TGroupBox;
    Chk1: TCheckBox;
    Chk2: TCheckBox;
    rg2: TRadioGroup;
    grp3: TGroupBox;
    MemoXX1: TMemo;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    MemoXX2: TMemo;
    MemoXX3: TMemo;
    grp4: TGroupBox;
    grp5: TGroupBox;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    EdtHM1: TEdit;
    EdtHM2: TEdit;
    EdtHM3: TEdit;
    Btn3: TButton;
    grp6: TGroupBox;
    RbGetBuyer: TRadioButton;
    RbGetSeller: TRadioButton;
    Btn1: TButton;
    Btn4: TButton;
    MemoWangZhi: TMemo;
    grp7: TGroupBox;
    tv1: TTreeView;
    Btnadd: TButton;
    BtnDel: TButton;
    BtnTg: TButton;
    BtnOutTxt: TButton;
    BtnInTxT: TButton;
    Edt1: TEdit;
    lbl11: TLabel;
    lbl12: TLabel;
    grp8: TGroupBox;
    lbl13: TLabel;
    Btn5: TButton;
    Btn6: TButton;
    Btn7: TButton;
    Btn8: TButton;
    SaveDlgToText: TSaveTextFileDialog;
    OpenDlgFromText: TOpenTextFileDialog;
    stat1: TStatusBar;
    lvSendList: TListView;
    BtnClean: TButton;
    il1: TImageList;
    lbl14: TLabel;
    lbl15: TLabel;
    Chkverify: TCheckBox;
    lbl16: TLabel;
    ChkSFYZ: TCheckBox;
    lbl17: TLabel;
    lbl18: TLabel;
    EdtYZSJ: TEdit;
    lbl19: TLabel;
    lbl20: TLabel;
    lbl21: TLabel;
    lvRunList: TListView;
    SkinData1: TSkinData;
    pnl1: TPanel;
    grp9: TGroupBox;
    tmr1: TTimer;
    Dbgrd1: TDBGridEh;
    pm1: TPopupMenu;
    as1: TMenuItem;
    dfs1: TMenuItem;
    tlb1: TToolBar;
    btn9: TToolButton;
    tsAuto: TTabSheet;
    grp10: TGroupBox;
    lvAutoSend: TListView;
    Btn10: TButton;
    lbl23: TLabel;
    Edt3: TEdit;
    Btn11: TButton;
    lbl22: TLabel;
    EdtYZXX: TEdit;
    img1: TImage;
    lblGG: TLabel;
    Btn12: TButton;
    Btn13: TButton;
    Btn14: TButton;
    Btn15: TButton;
    grp11: TGroupBox;
    lbl24: TLabel;
    lbl25: TLabel;
    EdtHowMsg: TEdit;
    rg1: TRadioGroup;
    lbl26: TLabel;
    lbl27: TLabel;
    Edt4: TEdit;
    Chk5: TCheckBox;
    Chk4: TCheckBox;
    Chk3: TCheckBox;
    procedure Btn1Click(Sender: TObject);
    procedure Btn2Click(Sender: TObject);
    procedure Btn3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EdtStopTimeKeyPress(Sender: TObject; var Key: Char);
    procedure Edt2KeyPress(Sender: TObject; var Key: Char);
    procedure Btn4Click(Sender: TObject);
    procedure BtnaddClick(Sender: TObject);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure BtnDelClick(Sender: TObject);
    procedure ASQLite3Table2BeforeDelete(DataSet: TDataSet);
    procedure BtnTgClick(Sender: TObject);
    procedure Btn5Click(Sender: TObject);
    procedure ASQLite3Table3AfterPost(DataSet: TDataSet);
    procedure ASQLite3Table3AfterCancel(DataSet: TDataSet);
    procedure Btn6Click(Sender: TObject);
    procedure Btn7Click(Sender: TObject);
    procedure Btn8Click(Sender: TObject);
    procedure BtnOutTxtClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnInTxTClick(Sender: TObject);
    procedure ASQLite3Table1AfterOpen(DataSet: TDataSet);
    procedure BtnCleanClick(Sender: TObject);
    procedure EdtYZSJChange(Sender: TObject);
    procedure Edt2Change(Sender: TObject);
    procedure EdtStopTimeChange(Sender: TObject);
    procedure lvRunListColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormShow(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure lblGGMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lblGGMouseLeave(Sender: TObject);
    procedure dfs1Click(Sender: TObject);
    procedure as1Click(Sender: TObject);
    procedure EdtYZSJKeyPress(Sender: TObject; var Key: Char);
    procedure Btn10Click(Sender: TObject);
    procedure Btn11Click(Sender: TObject);
    procedure pgc1Change(Sender: TObject);
    procedure Btn12Click(Sender: TObject);
    procedure Btn15Click(Sender: TObject);
    procedure Btn13Click(Sender: TObject);
    procedure Btn14Click(Sender: TObject);
  private
    FDownFile : TDownFile;
    { Private declarations }
  public

    { Public declarations }
  end;


TThreadYHID = class(TThread) { �����߳��� }
  private

  protected
    procedure Execute; override;{ ִ���̵߳ķ��� }
  public
    id: Cardinal; //1: ������Ϣ  2: ��ȡ�������ID   3: ��ȡ��������ID
    procedure SendMsg();//������Ϣ
    procedure GetBuyer(); //��ȡ�������ID
    procedure GetSeller(); //��ȡ��������ID
    procedure SelfUpdate();//�Զ�����
  end;

const
  version = 'V1.2.2 ���԰�';
  Url='http://menghun932.dns36.ceshi6.com/download/update/seekwang/';
  VerFile='Ver.html';
  Bulletin='Bulletin.html';
  UpdateFile= 'seekwang.exe';
var
  FrmMain: TFrmMain;
  AppPath:String;//ϵͳ·��
  Ppp, PHwnd, PrHwnd, MenuBtnHwnd, memu: LongInt;
  IDEdtHwnd, SendBtnHwnd: LongInt;
  wndhwnd: HWND;
  ThreadSendMsg, ThreadGetBuyer, ThreadGetSeller, ThreadUpdate: TThreadYHID;

  MyInifile: TInifile;
  StWwHwnd: TStringList;//�Ѿ��򿪵��������
  StBulletin: TStringList;//��������Ϣ
  IdBulletin: Integer;//��������Ϣ˳���
  sSendWangWang: string;//ָ���ķ��ͺ�

  function EnumChildWndProc(AhWnd: LongInt;AlParam: lParam): boolean; stdcall; //ö���ҵ����촰�ڵ������ӿؼ����
  function EnumChildSendID(AhWnd: LongInt;AlParam: lParam): boolean; stdcall; //ö���ҵ������������ӿؼ����
  function EnumWndProc(hwnd:THandle;lparam:LPARAM):Boolean;stdcall;//ö���ҵ������Ѿ��򿪵�����
  function ToUTF8Encode(str: string): string;//����תUTF-8
  function WangWangOnLine(str: string): Boolean; //�����Ƿ�����;
  function DengDaiYanZhen(i: Integer):Boolean;//������֤��
  function JianHaoYou(i: Integer): Boolean;//���Ϊ����
  procedure FaXiaoXi();//������Ϣ
  function ZhiDingWangWang(i: Integer;var SendIDHWnd: LongInt):Boolean;//ָ�����ͺ�

implementation

uses UntAddDlg, UntRegFrm, UntReg, UntFrmGY, UntFrmAddAutoSend;

{$R *.dfm}


procedure TFrmMain.as1Click(Sender: TObject);
begin
  TFrmGY.Create(nil);
  FrmGY.Show;
end;

procedure TFrmMain.ASQLite3Table1AfterOpen(DataSet: TDataSet);
begin
  Dbgrd1.Columns[0].Width := MyInifile.ReadInteger('GridWidth2','Id',Dbgrd1.Columns[0].Width);
end;

procedure TFrmMain.ASQLite3Table2BeforeDelete(DataSet: TDataSet);
begin
  try
    ASQLite3Table1.DisableControls;
    ASQLite3Table1.First;
    while not ASQLite3Table1.Eof do
      ASQLite3Table1.Delete;
  finally
    ASQLite3Table1.EnableControls;
  end;

end;

procedure TFrmMain.ASQLite3Table3AfterCancel(DataSet: TDataSet);
begin
  Btn5.Enabled := True;
end;

procedure TFrmMain.ASQLite3Table3AfterPost(DataSet: TDataSet);
begin
  Btn5.Enabled := True;
end;

procedure TFrmMain.Btn10Click(Sender: TObject);
var
  AddAutoSend: TFrmAddAutoSend;
begin
  AddAutoSend := TFrmAddAutoSend.Create(nil);
  AddAutoSend.ShowModal;
  AddAutoSend.Free;
end;

procedure TFrmMain.Btn11Click(Sender: TObject);
begin
  OpenDlgFromText.Title := '����λ��';
  OpenDlgFromText.Filter := '����ִ���ļ�(*.exe)|*.exe';
  if OpenDlgFromText.Execute then
  begin
    edt3.Text := OpenDlgFromText.FileName;
  end;
end;

procedure TFrmMain.Btn12Click(Sender: TObject);
begin
  if lvAutoSend.Selected <> nil then
    lvAutoSend.Selected.Delete;
end;

procedure TFrmMain.Btn13Click(Sender: TObject);
var
  TxtFile: TextFile;
  ln:string;
  i:Integer;
begin
  SaveDlgToText.InitialDir := ExtractFilePath( Application.ExeName );
  SaveDlgToText.FileName := '�����ƹ��û���Ϣ.txt';
  SaveDlgToText.Title := '�����û���Ϣ';
  SaveDlgToText.Filter := '�ı��ļ�(*.txt)|*.txt';
  if lvAutoSend.Items.Count < 1 then
  begin
    Application.MessageBox('�б��ǿյģ�','��ʾ',MB_OK);
    exit;
  end;
  if SaveDlgToText.Execute then
  begin
    if FileExists(SaveDlgToText.FileName) then   //�ж��ļ��Ƿ��Ѿ�����
       if Application.MessageBox('�ļ��Ѿ����ڣ��Ƿ񸲸ǣ�','�ļ��Ѿ�����',MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) <> IDYES then
         Exit;
    AssignFile(TxtFile, SaveDlgToText.FileName);
    Rewrite(TxtFile);
    for i := 0 to lvAutoSend.Items.Count-1 do
    begin
      ln:=lvAutoSend.Items.Item[i].Caption + '|' + lvAutoSend.Items.Item[i].SubItems.Strings[0];
      writeln(TxtFile,ln);
    end;
    CloseFile(TxtFile);
    Application.MessageBox('�����ļ��ɹ���','��ʾ',MB_OK);
  end;
end;

procedure TFrmMain.Btn14Click(Sender: TObject);
var
  TxtFile: TextFile;
  ln:string;
  NewItem: TListItem;
begin
  OpenDlgFromText.InitialDir := ExtractFilePath(Application.ExeName );
  OpenDlgFromText.Title := '�����û���Ϣ';
  OpenDlgFromText.Filter := '�ı��ļ�(*.txt)|*.txt';
  if OpenDlgFromText.Execute then
  begin
    AssignFile(TxtFile, OpenDlgFromText.FileName);
    Reset(TxtFile);
    while not eof(TxtFile) do
    begin
      Readln(TxtFile,ln);
      NewItem := lvAutoSend.Items.Add;
      NewItem.Caption := Trim(Copy(ln,1,Pos('|',ln)-1));
      NewItem.SubItems.Add(Trim(Copy(ln,Pos('|',ln)+1,Length(ln))));
    end;
    CloseFile(TxtFile);
    Application.MessageBox('�����ļ��ɹ���','��ʾ',MB_OK);
  end;
end;

procedure TFrmMain.Btn15Click(Sender: TObject);
begin
  lvAutoSend.Clear;
end;

procedure TFrmMain.Btn1Click(Sender: TObject);
begin
  if FrmMain.MemoWangZhi.Text = '' then
  begin
    Application.MessageBox('����дһ�������ַ��','��ʾ',MB_OK);
    FrmMain.MemoWangZhi.SetFocus;
    exit;
  end;

  if (tv1.Selected = nil) or (tv1.Selected.Text = '�Ѷ�ȡ����ID') then
  begin
    Application.MessageBox('��ѡȡһ����,������Ų鵽��ID��','��ʾ',MB_OK);
    tv1.SetFocus;
    exit;
  end;

  if RbGetBuyer.Checked then
  begin
    ThreadGetBuyer := TThreadYHID.Create(True);
    ThreadGetBuyer.FreeOnTerminate := true;
    ThreadGetBuyer.id := 2;
    ThreadGetBuyer.Resume;
  end
  else begin
    ThreadGetSeller := TThreadYHID.Create(True);
    ThreadGetSeller.FreeOnTerminate := true;
    ThreadGetSeller.id := 3;
    ThreadGetSeller.Resume;
  end;
  Btn1.Enabled := not Btn1.Enabled;
  Btn4.Enabled := not Btn1.Enabled;
  RbGetBuyer.Enabled := False;
  RbGetSeller.Enabled := False;
end;

procedure TFrmMain.Btn4Click(Sender: TObject);
begin
  if RbGetBuyer.Checked then
  begin
    ThreadGetBuyer.Suspend;
    ThreadGetBuyer.Terminate;
  end
  else begin
    ThreadGetSeller.Suspend;
    ThreadGetSeller.Terminate;
  end;
  Btn1.Enabled := not Btn1.Enabled;
  Btn4.Enabled := not Btn1.Enabled;
  RbGetBuyer.Enabled := True;
  RbGetSeller.Enabled := True;
end;

procedure TFrmMain.Btn5Click(Sender: TObject);
var
  AddDlg: TFrmAddDlg;
begin
  AddDlg := TFrmAddDlg.Create(nil);
  AddDlg.ShowModal;
  AddDlg.Free;
end;

procedure TFrmMain.Btn6Click(Sender: TObject);
begin
  if lvSendList.Selected <> nil then
    lvSendList.Selected.Delete;
end;

procedure TFrmMain.Btn7Click(Sender: TObject);
begin
  if lvSendList.Selected <> nil then
  begin
    lvSendList.Selected.SubItems.Strings[0] := '����';
    lvSendList.Selected.SubItemImages[0] := 0;
  end;
end;

procedure TFrmMain.Btn8Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvSendList.Items.Count - 1 do
  begin
    lvSendList.Items.Item[i].SubItems.Strings[0] := '����';
    lvSendList.Items.Item[i].SubItemImages[0] := 0;
  end;
end;

procedure TFrmMain.BtnaddClick(Sender: TObject);
var
  TvChildItem: TTreeNode;
begin
  if Edt1.Text = '' then
  begin
    Application.MessageBox('����������Ϊ�գ�','��ʾ',MB_OK);
    Edt1.SetFocus;
    Abort;
  end;
  if not FrmMain.ASQLite3Table2.Active then
    FrmMain.ASQLite3Table2.Open;
  if ASQLite3Table2.Locate('GroupName',Edt1.Text,[]) then
  begin
    Application.MessageBox('�����Ѵ��ڣ��������룡','��ʾ',MB_OK);
    Edt1.Text := '';
    Edt1.SetFocus;
    Abort;
  end;
  TvChildItem := tv1.Items.AddChild(tv1.Items[0],Edt1.Text);
  TvChildItem.ImageIndex := 5;
  TvChildItem.SelectedIndex := 6;
  ASQLite3Table2.Append;
  ASQLite3Table2.FieldByName('GroupName').AsString := TvChildItem.Text;
  ASQLite3Table2.Post;
  ASQLite3Table2.Close;
  ASQLite3Table2.Open;
  Edt1.Text := '';
  tv1.SetFocus;
  tv1.Selected := TvChildItem;
end;

procedure TFrmMain.BtnCleanClick(Sender: TObject);
begin
  lvSendList.Clear;
end;

procedure TFrmMain.BtnDelClick(Sender: TObject);
begin
  if (tv1.Selected = nil) or (tv1.Selected.Text = '�Ѷ�ȡ����ID') then
  begin
    Application.MessageBox('��ѡ��Ҫɾ����ID�飡','��ʾ',mb_ok);
    tv1.SetFocus;
    abort;
  end;
  ASQLite3Table2.Locate('GroupName',tv1.Selected.Text,[]);
  ASQLite3Table2.Delete;
  tv1.Selected.Delete;
end;

procedure TFrmMain.BtnInTxTClick(Sender: TObject);
var
  TxtFile: TextFile;
  ln:string;
begin
  if (tv1.Selected = nil) or (tv1.Selected.Text = '�Ѷ�ȡ����ID') then
  begin
    Application.MessageBox('��ѡ��Ҫ�������ݵ������飡','��ʾ',mb_ok);
    tv1.SetFocus;
    abort;
  end;
  OpenDlgFromText.InitialDir := ExtractFilePath(Application.ExeName );
  OpenDlgFromText.Title := '��������ID����';
  OpenDlgFromText.Filter := '�ı��ļ�(*.txt)|*.txt';
  if OpenDlgFromText.Execute then
  begin
    AssignFile(TxtFile, OpenDlgFromText.FileName);
    Reset(TxtFile);
    while not eof(TxtFile) do
    begin
      Readln(TxtFile,ln);
      if not ASQLite3Table1.Active then ASQLite3Table1.Open;
      if not ASQLite3Table1.Locate('FL;WwName',VarArrayOf([ASQLite3Table2.FieldByName('AutoId').AsInteger,ln]),[]) then
      begin
        ASQLite3Table1.Append;
        ASQLite3Table1.FieldByName('WwName').AsString := ln;
        ASQLite3Table1.FieldByName('FL').AsInteger := ASQLite3Table2.FieldByName('AutoId').AsInteger;
        ASQLite3Table1.Post;
      end;
//        TxtFile.Next;
    end;
    CloseFile(TxtFile);
    Application.MessageBox('�����ļ��ɹ���','��ʾ',MB_OK);
  end;
end;

procedure TFrmMain.BtnOutTxtClick(Sender: TObject);
var
  TxtFile: TextFile;
  ln:string;
begin
  if (tv1.Selected = nil) or (tv1.Selected.Text = '�Ѷ�ȡ����ID') then
  begin
    Application.MessageBox('��ѡ��Ҫ������ID�飡','��ʾ',mb_ok);
    tv1.SetFocus;
    abort;
  end;
  SaveDlgToText.InitialDir := ExtractFilePath( Application.ExeName );
  SaveDlgToText.FileName := tv1.Selected.Text;
  SaveDlgToText.Filter := '�ı��ļ�(*.txt)|*.txt';
  SaveDlgToText.Title := '��������ID��TXT�ļ�';
  if SaveDlgToText.Execute then
  begin
    if FileExists(SaveDlgToText.FileName) then   //�ж��ļ��Ƿ��Ѿ�����
       if Application.MessageBox('�ļ��Ѿ����ڣ��Ƿ񸲸ǣ�','�ļ��Ѿ�����',MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) <> IDYES then
         Exit;
    AssignFile(TxtFile, SaveDlgToText.FileName);
    Rewrite(TxtFile);
    try
      ASQLite3Table1.First;
      ASQLite3Table1.DisableControls;
      while not ASQLite3Table1.Eof do
      begin
        ln:=ASQLite3Table1.FieldByName('WwName').AsString;
        writeln(TxtFile,ln);
        ASQLite3Table1.next;
      end;
      CloseFile(TxtFile);
      Application.MessageBox('�����ļ��ɹ���','��ʾ',MB_OK);
    finally
      ASQLite3Table1.First;
      ASQLite3Table1.EnableControls;
    end;
  end;

end;

procedure TFrmMain.BtnTgClick(Sender: TObject);
var
  NewItem: TListItem;
begin
  if (tv1.Selected = nil) or (tv1.Selected.Text = '�Ѷ�ȡ����ID') then
  begin
    Application.MessageBox('��ѡ��Ҫ�ƹ��ID�飡','��ʾ',mb_ok);
    tv1.SetFocus;
    abort;
  end;
  try
    ASQLite3Table1.DisableControls;
    ASQLite3Table1.First;
    while not ASQLite3Table1.Eof do
    begin
      //�������ظ����û���
      if lvSendList.FindCaption(0,ASQLite3Table1.FieldByName('WWName').AsString,False,True,False) = nil then
      begin
        NewItem := lvSendList.Items.Add;
        NewItem.Caption := ASQLite3Table1.FieldByName('WWName').AsString;
        NewItem.ImageIndex := -1;
        NewItem.SubItems.Add('����');
        NewItem.SubItemImages[0] := 0;
      end;
      ASQLite3Table1.Next;
    end;

    MessageBox(FrmMain.Handle,'�ɹ���ӵ��ƹ㣡','��ʾ',mb_ok);
    ASQLite3Table1.First;
  finally
    ASQLite3Table1.EnableControls;
  end;

end;

procedure TFrmMain.dfs1Click(Sender: TObject);
begin
  ShellExecute(0, 'open', Pchar(AppPath+'Help.chm'), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmMain.Btn3Click(Sender: TObject);
begin
  ThreadSendMsg.Suspend;
  ThreadSendMsg.Terminate;
  Btn2.Enabled := not Btn2.Enabled;
  Btn3.Enabled := not Btn2.Enabled;
end;

procedure TFrmMain.Btn2Click(Sender: TObject);
begin
  ThreadSendMsg := TThreadYHID.Create(True);
  ThreadSendMsg.FreeOnTerminate := true;
  ThreadSendMsg.id := 1;
  ThreadSendMsg.Resume;
  Btn2.Enabled := not Btn2.Enabled;
  Btn3.Enabled := not Btn2.Enabled;
end;

procedure TFrmMain.Edt2Change(Sender: TObject);
begin
  if Edt2.Text = '' then
    Edt2.Text := '0';
end;

procedure TFrmMain.Edt2KeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#13,#8]) then
    key := #0;
end;

procedure TFrmMain.EdtYZSJChange(Sender: TObject);
begin
  if EdtYZSJ.Text = '' then
    EdtYZSJ.Text := '0';
end;

procedure TFrmMain.EdtYZSJKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#13,#8]) then
    key := #0;
end;

procedure TFrmMain.EdtStopTimeChange(Sender: TObject);
begin
  if EdtStopTime.Text = '' then
    EdtStopTime.Text := '0';
end;

procedure TFrmMain.EdtStopTimeKeyPress(Sender: TObject; var Key: Char);
begin
  if not (key in ['0'..'9',#13,#8]) then
    key := #0;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  Filename: string;
  TvChildItem: TTreeNode;
begin
  stat1.Panels[0].Text := '�汾��' + version;//�汾��
  AppPath := ExtractFilePath(ParamStr(0)); //����·��
  StWwHwnd := TStringList.Create;
  StBulletin := TStringList.Create;
  IdBulletin := 0;

  ASQLite3DB1.DefaultDir := Utf8Encode( ExtractFilePath( Application.ExeName ) ); //��������Ŀ¼ʱ����
  ASQLite3DB1.DriverDLL := ExtractFilePath( Application.ExeName ) + 'Sqlite3.dll'; //�������û��ϵ
  ASQLite3DB1.Database := Utf8Encode( 'DBS.sqb' ); //���ȫ��Ӣ�ģ�����ת������Ҳ����
  ASQLite3DB1.CharacterEncoding := 'STANDARD'; //�����������ã���ѯ����������ȫ�����룬��������ó� UTF8 ����Ҳ���ԣ�ûȥ��ϸ�о�

  ASQLite3DB1.Open;

  ASQLite3Table2.Open;
  ASQLite3Table2.First;
  while not ASQLite3Table2.Eof do //��ȡ�Ѿ�������������б�
  begin
    TvChildItem := tv1.Items.AddChild(tv1.Items[0],ASQLite3Table2.FieldByName('GroupName').AsString);
    TvChildItem.ImageIndex := 5;
    TvChildItem.SelectedIndex := 6;
    ASQLite3Table2.Next;
  end;
  tv1.FullExpand;

  //��LoginSys.ini�ļ��洢��Ӧ�ó���ǰĿ¼��
  Filename := ExtractFilePath(paramstr(0))+'SysSet.ini';
  MyInifile:= TInifile.Create(Filename);
  Chk1.Checked := MyInifile.ReadBool('SendOptions','AddFriend',False);
  Chk2.Checked := MyInifile.ReadBool('SendOptions','OnlyOnline',True);
  ChkSFYZ.Checked := MyInifile.ReadBool('SendOptions','SFYZ',True);
  rg1.ItemIndex := MyInifile.ReadInteger('SendOptions','MessageNum',0);
  rg2.ItemIndex := MyInifile.ReadInteger('SendOptions','SendIdNum',0);
  EdtStopTime.Text := MyInifile.ReadString('ProgramOptions','StopTime','10');
  Edt2.Text := MyInifile.ReadString('ProgramOptions','DelayTime','4');
  EdtYZSJ.Text := MyInifile.ReadString('ProgramOptions','YzTime','15');
  Chkverify.Checked := MyInifile.ReadBool('ProgramOptions','Ddverify',True);
  lvSendList.Columns.Items[0].Width := MyInifile.ReadInteger('SendList','Id',150);
  lvSendList.Columns.Items[1].Width := MyInifile.ReadInteger('SendList','State',40);
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  MyInifile.WriteBool('SendOptions','AddFriend',Chk1.Checked);
  MyInifile.WriteBool('SendOptions','OnlyOnline',Chk2.Checked);
  MyInifile.WriteBool('SendOptions','SFYZ',ChkSFYZ.Checked);
  MyInifile.WriteInteger('SendOptions','MessageNum',rg1.ItemIndex);
  MyInifile.WriteInteger('SendOptions','SendIdNum',rg2.ItemIndex);
  MyInifile.WriteString('ProgramOptions','StopTime',EdtStopTime.Text);
  MyInifile.WriteString('ProgramOptions','DelayTime',Edt2.Text);
  MyInifile.WriteString('ProgramOptions','YzTime',EdtYZSJ.Text);
  MyInifile.WriteBool('ProgramOptions','Ddverify',Chkverify.Checked);
  MyInifile.WriteInteger('GridWidth2','Id',Dbgrd1.Columns[0].Width);
  MyInifile.WriteInteger('SendList','Id',lvSendList.Columns.Items[0].Width);
  MyInifile.WriteInteger('SendList','State',lvSendList.Columns.Items[1].Width);
  MyInifile.Destroy;
end;

procedure TFrmMain.FormShow(Sender: TObject);
var
  FrmZC: TFrmReg;
  i: Integer;
begin
  if not InitToRegTab then
  begin
    Application.MessageBox('��ʼ��ע����Ϣʧ��','��ʾ',MB_OK+MB_ICONWARNING);
    Close;
  end;
  if not VerifyRegInfo then
  begin
    FrmZC := TFrmReg.Create(nil);
    if FrmZC.ShowModal <> mrOk then
      Close;//Application.MessageBox('ע��ʧ��','��ʾ',MB_OK+MB_ICONWARNING);
  end;
  tmr1.Enabled := True;

  DeleteFile(AppPath+'old.bak');//ɾ�����ļ�
  ThreadUpdate := TThreadYHID.Create(True);//������
  ThreadUpdate.FreeOnTerminate := true;
  ThreadUpdate.id := 4;
  ThreadUpdate.Resume;
end;

procedure TFrmMain.lblGGMouseLeave(Sender: TObject);
begin
  tmr1.Enabled := true;
end;

procedure TFrmMain.lblGGMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  tmr1.Enabled := False;
end;

procedure TFrmMain.lvRunListColumnClick(Sender: TObject; Column: TListColumn);
var
  i: Integer;
  Li: TListItem;
begin
  StWwHwnd.Clear;
  lvRunList.Clear;
  EnumWindows(@EnumWndProc,0);
  for i := 0 to StWwHwnd.Count - 1 do
  begin
    Li := lvRunList.Items.Add;
    Li.Caption := Copy(StWwHwnd.Strings[i],1,Pos(',',StWwHwnd.Strings[i])-1);
  end;
end;

procedure TFrmMain.pgc1Change(Sender: TObject);
begin
  if pgc1.ActivePage = tsAuto then
  begin
    grp5.Parent := tsAuto;
    grp3.Parent := tsAuto;
  end;
  if pgc1.ActivePage = tsGeneral then
  begin
    grp5.Parent := tsGeneral;
    grp3.Parent := tsGeneral;
  end;

end;

procedure TFrmMain.tmr1Timer(Sender: TObject);
begin
  if StBulletin.Text <> '' then
  begin
    if IdBulletin = StBulletin.Count then
      IdBulletin := 0;
    lblGG.Caption := StBulletin.Strings[IdBulletin];
    Inc(IdBulletin);
  end;
//  else tmr1.Enabled := False;
end;

procedure TFrmMain.tv1Change(Sender: TObject; Node: TTreeNode);
begin
  lbl13.Caption := '��ǰ��Ϊ��' + Node.Text;
  if ASQLite3Table2.Locate('GroupName',Node.Text,[]) then
  begin
    ASQLite3Table1.Filtered := True;
    ASQLite3Table1.Filter := 'FL = '+ QuotedStr(ASQLite3Table2.FieldByName('AutoID').AsString);
    if not ASQLite3Table1.Active then ASQLite3Table1.Open;
  end
  else ASQLite3Table1.Close;
end;

function EnumChildWndProc(AhWnd: LongInt;
  AlParam: lParam): boolean; stdcall;
var
  WndClassName: array[0..254] of Char;
  WndCaption: array[0..254] of Char;
begin
  GetClassName(AhWnd, wndClassName, 254); //�ؼ�����
  GetWindowText(aHwnd, WndCaption, 254);  //�ؼ�����
  if string(WndClassName) = 'RichEditComponent' then
    Ppp := Ahwnd;  //��Ϣ�������
  if (string(WndClassName) = 'StandardButton') and (string(wndCaption) = '����') then
      PHwnd := AhWnd; //�����͡� ��ť���
  if string(WndClassName) = 'ToolBarPlus' then
    if GetParent(AhWnd)= wndhwnd then
      PrHwnd := AhWnd; //���������� ���     4
  result := true;
end;

function EnumChildSendID(AhWnd: LongInt;AlParam: lParam): boolean; stdcall;
var
  WndClassName: array[0..254] of Char;
  WndCaption: array[0..254] of Char;
  PWndClassName: array[0..254] of Char;  //��������
  PWndCaption: array[0..254] of Char;    //��������
  PHHwnd: HWND;
begin
  GetClassName(AhWnd, wndClassName, 254); //�ؼ�����
  GetWindowText(aHwnd, WndCaption, 254);  //�ؼ�����
  GetClassName(GetParent(AhWnd),PWndClassName,254);
  GetWindowText(GetParent(AhWnd),PWndCaption,254);
  if (string(WndClassName) = 'StandardButton') and (string(wndCaption) = '') and (string(PWndClassName)='StandardFrame')then
      MenuBtnHwnd := AhWnd; //�����͡� ��ť���
  if (string(WndClassName) = 'EditComponent') and (string(WndCaption) = '') then
    IDEdtHwnd := AhWnd;
  if (string(WndClassName) = 'StandardButton') and (string(WndCaption) = '�� ��') then
    SendBtnHwnd := AhWnd;
  if (string(WndClassName) = 'StandardButton') and (string(WndCaption) = 'ȷ  ��') then
    SendBtnHwnd := AhWnd;
  if (string(WndClassName) = 'StandardButton') and (string(WndCaption) = '������Ϣ') then
    SendBtnHwnd := AhWnd;
  result := true;
end;

function EnumWndProc(hwnd:THandle;lparam:LPARAM):Boolean;stdcall
var
  WndCaption: array[0..254] of Char;
  WndClassName: array[0..254] of Char;
  s:string;
begin
  GetClassName(hwnd,WndClassName,254);
  GetWindowText(hwnd,WndCaption,254);
  if string(WndClassName) = 'StandardFrame' then
  begin
    s:=WndCaption;
    Delete(s,Pos('-',s),Length(s));
    StWwHwnd.Add(s+','+ IntToStr(hwnd));
  end;
  Result := True;
end;

function ToUTF8Encode(str: string): string;//����תUTF-8
var
b: Byte;
begin
  for b in BytesOf(UTF8Encode(str)) do
  Result := Format('%s%s%.2x', [Result, '%', b]);
end;

function WangWangOnLine(str: string): Boolean;
var
//  Request: TStrings;
  Response: TStringStream;
  s,sURL:string;
  idhttp1: TIdHTTP;
begin
  Result := False;
  idhttp1 := TIdHTTP.Create(nil);
  idhttp1.HandleRedirects := true;
  idhttp1.ReadTimeout := 60000;
  idhttp1.ConnectTimeout := 60000;
  IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';
//  Request := TStringList.Create;
  Response := TStringStream.Create('');
  try
    sURL := 'http://amos1.taobao.com/muliuserstatus.aw?beginnum=0&site=cntaobao&uids='+ HTTPEncode(str);
    IdHTTP1.Get(surl, Response);

    s:=Response.DataString;
    Delete(s,1,Pos('online[',s)+6);
    Delete(s,1,Pos('=',s));
    s := Trim(s);
    Delete(s,2,Length(s));
    if StrToInt(s) <> 0 then
      Result := True
    else Result := False;
  except
//    MessageBox(FrmMain.handle,'��ȡ������״̬����ʱ���رպ�������ͣ�','��ʾ',MB_OK);
  end;
end;

function DengDaiYanZhen(i: Integer):Boolean;
var
  YanZheng: LongInt;
begin
  Result := True;
  YanZheng := FindWindow(nil, '�������� - ��ȫ��֤'); //��ȫ��֤�Ի���
  if YanZheng <> 0 then
  begin
    if FrmMain.Chkverify.Checked then
    begin
      Application.MessageBox('Ϊȷ����Ϣ�ɹ����ͣ���������ȷ��֤��'+#13#13+'ȷ�ϰ�ȫ��֤�򱻹رպ�'+#13+'�ٰ�ȷ�������򽫼���ִ�У�','��ʾ',MB_OK+MB_ICONWARNING);
      SendMessage(YanZheng,WM_CLOSE,0,0);
      Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
    end
    else begin
      SendMessage(YanZheng,WM_CLOSE,0,0);
      SendMessage(wndhwnd,WM_CLOSE,0,0);                    //�ر����촰��
      FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '�ų���Ϣ��֤';
      FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 0;
      Result := False;
    end;
  end;
end;

function JianHaoYou(i: Integer): Boolean;//���Ϊ����
var
  CGHwnd: LongInt;
begin
  Result := True;
  if FrmMain.Chk1.Checked then //�ӶԷ�Ϊ����
  begin
    sendmessage(PrHwnd, WM_LBUTTONDOWN , MK_LBUTTON, MAKELONG(265,15));
    SendMessage(PrHwnd, WM_LBUTTONUP , MK_LBUTTON, MAKELONG(265,15));
    sendmessage(PrHwnd, WM_LBUTTONDOWN , MK_LBUTTON, MAKELONG(265,15));
    SendMessage(PrHwnd, WM_LBUTTONUP , MK_LBUTTON, MAKELONG(265,15));

    Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
    Result := DengDaiYanZhen(i);//��֤�봰��
    if Result then
    begin
      CGHwnd := FindWindow(nil, '��Ӻ��ѳɹ�!');//�ҵ���ӳɹ�����ʾ��
      if CGHwnd <> 0 then
        SendMessage(CGHwnd,WM_CLOSE,0,0);
    end;
  end;
end;

procedure FaXiaoXi();//������Ϣ
var
  Rgindex: Integer;
begin
  if FrmMain.rg1.ItemIndex = 3 then //��ʼ������Ϣ
  begin
    Randomize;
    Rgindex := Random(3);
  end
  else Rgindex := FrmMain.rg1.ItemIndex;
  if Rgindex = 0 then
    sendmessage(Ppp,WM_SETTEXT,0,Integer(PChar(FrmMain.MemoXX1.Text))); //��д��Ϣһ
  if Rgindex = 1 then
    sendmessage(Ppp,WM_SETTEXT,0,Integer(PChar(FrmMain.MemoXX2.Text))); //��д��Ϣ��
  if Rgindex = 2 then
    sendmessage(Ppp,WM_SETTEXT,0,Integer(PChar(FrmMain.MemoXX3.Text))); //��д��Ϣ��
  SendMessage(Ppp,WM_IME_KEYDOWN,VK_RETURN,0);   //��ENTER��������Ϣ
//  SendMessage(PHwnd,BM_CLICK,0,0);                      //������Ϣ
end;

function ZhiDingWangWang(i: Integer; var SendIDHWnd: LongInt):Boolean;//ָ�����ͺ�
var
  Rgindex,ListIndex: Integer;
  s: string;
begin
  Result := True;
  if FrmMain.rg2.ItemIndex = 3 then  //���ID
  begin
    Randomize;
    Rgindex := Random(3);
  end
  else Rgindex := FrmMain.rg2.ItemIndex;
  case Rgindex of
    0: begin
         for ListIndex := 0 to StWwHwnd.Count - 1 do
         begin
           s := StWwHwnd.Strings[ListIndex];
           if FrmMain.EdtHM1.Text = copy(s,1,Pos(',',StWwHwnd.Strings[ListIndex])-1) then
           begin
             sSendWangWang := FrmMain.EdtHM1.Text;
             Delete(s,1,Pos(',',StWwHwnd.Strings[ListIndex]));
             SendIDHWnd := StrToInt(s); //�ҵ���һ���������ھ��
             Break;
           end
           else if (ListIndex = StWwHwnd.Count - 1) then
           begin
             FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '����һδ���� '+ FrmMain.EdtHM1.Text;
             FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
             Rgindex := -1; //ֻ����һ����� ,δ�ҵ�ָ������
             Break;
           end;
         end;
         if Rgindex < 0 then Result := False;
       end;
    1: begin
         for ListIndex := 0 to StWwHwnd.Count - 1 do
         begin
           s := StWwHwnd.Strings[ListIndex];
           if FrmMain.EdtHM2.Text = copy(s,1,Pos(',',StWwHwnd.Strings[ListIndex])-1) then
           begin
             sSendWangWang := FrmMain.EdtHM2.Text;
             Delete(s,1,Pos(',',StWwHwnd.Strings[ListIndex]));
             SendIDHWnd := StrToInt(s); //�ҵ��ڶ����������ھ��
             Break;
           end
           else if (ListIndex = StWwHwnd.Count - 1) then
           begin
             FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '�����δ���� '+ FrmMain.EdtHM2.Text;
             FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
             Rgindex := -1;
             Break;
           end;
         end;
         if Rgindex < 0 then Result := False;
       end;
    2: begin
         for ListIndex := 0 to StWwHwnd.Count - 1 do
         begin
           s := StWwHwnd.Strings[ListIndex];
           if FrmMain.EdtHM3.Text = copy(s,1,Pos(',',StWwHwnd.Strings[ListIndex])-1) then
           begin
             sSendWangWang := FrmMain.EdtHM3.Text;
             Delete(s,1,Pos(',',StWwHwnd.Strings[ListIndex]));
             SendIDHWnd := StrToInt(s); //�ҵ���һ���������ھ��
             Break;
           end
           else if (ListIndex = StWwHwnd.Count - 1) then
           begin
             FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '������δ���� '+ FrmMain.EdtHM3.Text;
             FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
             Rgindex := -1;
             Break;
           end;
         end;
         if Rgindex < 0 then Result := False;
       end;
  end;
end;




{ TThreadQuery }

procedure TThreadYHID.Execute;
begin
  case id of
    1: SendMsg;
    2: GetBuyer;
    3: GetSeller;
    4: SelfUpdate;
  end;
end;

procedure TThreadYHID.GetBuyer;
var
  Request: TStrings;
  Response: TStringStream;
  s, Id:string;
  i: Integer;
  idhttp1:TIdHTTP;
begin
  idhttp1 := TIdHTTP.Create(nil);
  idhttp1.HandleRedirects := true;
  idhttp1.ReadTimeout := 60000;
  idhttp1.ConnectTimeout := 60000;
  IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';

  request := TStringList.Create;
  Response := TStringStream.Create('');
  //request.Add('q=test');
  try
    IdHTTP1.Get(FrmMain.MemoWangZhi.Text, Response);
//    IdHTTP1.Post('...',
//    request, Response);
    s:=Response.DataString;
    try
      FrmMain.Dbgrd1.DataSource := nil;//�˴����Ͽ�DbGrd�Ļ����������ظ����Ǳ���ӽ�ȥ�����һ���BookMArkδ����֮��Ĵ�������ԭ��δ��
      i := 0;
      while Pos('<a href="http://jianghu.taobao.com/n/',s)>0 do
      begin
        Delete(s,1,Pos('<a href="http://jianghu.taobao.com/n/',s));
        Delete(s,1,Pos('>',s));
        Id := Copy(s,1,Pos('<',s)-1);
        if not FrmMain.ASQLite3Table1.Active then FrmMain.ASQLite3Table1.Open;
        if not FrmMain.ASQLite3Table1.Locate('FL;WwName',VarArrayOf([FrmMain.ASQLite3Table2.FieldByName('AutoId').AsInteger,Id]),[]) then
        begin
          FrmMain.ASQLite3Table1.Append;
          FrmMain.ASQLite3Table1.FieldByName('FL').AsInteger := FrmMain.ASQLite3Table2.FieldByName('AutoId').AsInteger;
          FrmMain.ASQLite3Table1.FieldByName('WwName').AsString := Id;
          FrmMain.ASQLite3Table1.Post;
          Inc(i);
        end;
      end;
    finally
      FrmMain.Dbgrd1.DataSource := FrmMain.ds1;
    end;
    Application.MessageBox(PWideChar('���ҽ��������ι��ҵ� '+inttostr(i)+' �����ţ�'),'���',mb_ok);
    FrmMain.Btn1.Enabled := not FrmMain.Btn1.Enabled;
    FrmMain.Btn4.Enabled := not FrmMain.Btn1.Enabled;
    FrmMain.RbGetBuyer.Enabled := True;
    FrmMain.RbGetSeller.Enabled := True;
  except
    on e: Exception do
    begin
      Application.MessageBox('����ʧ��','����',MB_OK);
      FrmMain.Btn1.Enabled := not FrmMain.Btn1.Enabled;
      FrmMain.Btn4.Enabled := not FrmMain.Btn1.Enabled;
      FrmMain.RbGetBuyer.Enabled := True;
      FrmMain.RbGetSeller.Enabled := True;
    end
  end;

end;

procedure TThreadYHID.GetSeller;
var
  Request: TStrings;
  Response: TStringStream;
  s, Id:string;
  i: Integer;
  idhttp1:TIdHTTP;
begin
  idhttp1 := TIdHTTP.Create(nil);
  idhttp1.HandleRedirects := true;
  idhttp1.ReadTimeout := 60000;
  idhttp1.ConnectTimeout := 60000;
  IdHTTP1.Request.ContentType := 'application/x-www-form-urlencoded';

  request := TStringList.Create;
  Response := TStringStream.Create('');
  try
    IdHTTP1.Get(FrmMain.MemoWangZhi.Text, Response);
    s:=Response.DataString;
    try
      FrmMain.Dbgrd1.DataSource := nil;//�˴����Ͽ�DbGrd�Ļ����������ظ����Ǳ���ӽ�ȥ�����һ���BookMArkδ����֮��Ĵ�������ԭ��δ��
      i := 0;
      while Pos('a href="http://store.taobao.com/shop/view_shop',s)>0 do
      begin
        Delete(s,1,Pos('a href="http://store.taobao.com/shop/view_shop',s));
        Delete(s,1,Pos('>',s));
        Id := Copy(s,1,Pos('<',s)-1);
        if not FrmMain.ASQLite3Table1.Active then FrmMain.ASQLite3Table1.Open;
        if not FrmMain.ASQLite3Table1.Locate('FL;WwName',VarArrayOf([FrmMain.ASQLite3Table2.FieldByName('AutoId').AsInteger,Id]),[]) then
        begin
          FrmMain.ASQLite3Table1.Append;
          FrmMain.ASQLite3Table1.FieldByName('FL').AsInteger := FrmMain.ASQLite3Table2.FieldByName('AutoId').AsInteger;
          FrmMain.ASQLite3Table1.FieldByName('WwName').AsString := Id;
          FrmMain.ASQLite3Table1.Post;
          Inc(i);
        end;
      end;
    finally
      FrmMain.Dbgrd1.DataSource := FrmMain.ds1;
    end;
      Application.MessageBox(PWideChar('���ҽ��������ι��ҵ� '+inttostr(i)+' �����ţ�'),'���',mb_ok);
      FrmMain.Btn1.Enabled := not FrmMain.Btn1.Enabled;
      FrmMain.Btn4.Enabled := not FrmMain.Btn1.Enabled;
      FrmMain.RbGetBuyer.Enabled := True;
      FrmMain.RbGetSeller.Enabled := True;

  except
    on e: Exception do
    begin
      Application.MessageBox('����ʧ��','����',MB_OK);
      FrmMain.Btn1.Enabled := not FrmMain.Btn1.Enabled;
      FrmMain.Btn4.Enabled := not FrmMain.Btn1.Enabled;
      FrmMain.RbGetBuyer.Enabled := True;
      FrmMain.RbGetSeller.Enabled := True;
    end
  end;

end;

procedure TThreadYHID.SelfUpdate;
var
  AppFile:string;
  IdhttpUpdate: TIdHTTP;
  Request: TStrings;
  Response: TStringStream;
  s:string;
  FDownFile: TDownFile;
  Attr:Integer;
  sMsg:Msg;
begin
  IdhttpUpdate := TIdHTTP.Create(nil);
  IdhttpUpdate.HandleRedirects := true;
  IdhttpUpdate.ReadTimeout := 60000;
  IdhttpUpdate.ConnectTimeout := 60000;
  IdhttpUpdate.Request.ContentType := 'application/x-www-form-urlencoded';

  request := TStringList.Create;
  Response := TStringStream.Create('');

  IdhttpUpdate.Get(Url + Bulletin, Response); //���¹�����Ϣ
  StBulletin.Text := Response.DataString;
  Response.Clear;

  try
    FrmMain.stat1.Panels[3].Text :='���£������...';
    IdhttpUpdate.Get(Url + VerFile, Response);
    s:=Response.DataString;
    if version = s then
    begin
      FrmMain.stat1.Panels[3].Text :='���£��������°�';
      Exit;
    end;
  except
    FrmMain.stat1.Panels[3].Text :='���£����ӳ�ʱ';
  end;

  AppFile := ExtractFileName(Application.ExeName);
  if not DirectoryExists(AppPath+'update') then //�ļ����Ƿ����
    forcedirectories(AppPath+'update');//�����ļ���
  Attr := FileGetAttr(AppPath+'update');//�ļ�������
  if not ((Attr and faHidden) = faHidden)then
    FileSetAttr(AppPath+'update',attr or faHidden); //��Ϊ����

  FrmMain.stat1.Panels[3].Text :='���£��������������ļ�...';

  if FDownFile.DownFile(Url + UpdateFile,AppPath+'update\'+Appfile) then //���ظ����ļ�
  begin
    if FileExists(AppPath+'update\'+Appfile) then
    begin
      RenameFile(AppPath+AppFile,AppPath+'old.bak'); //�������ɵ��ļ�
      MoveFile(PWideChar(AppPath+'update\'+Appfile),PWideChar(AppPath+Appfile));//�ƶ������ļ�������Ŀ¼
      FrmMain.stat1.Panels[3].Text :='���£����سɹ����ȴ�����';
      if Application.MessageBox('�����ļ��������'+#13+'���������ɸ��£�','��ʾ',MB_YesNo+MB_ICONQuestion)=mryes then
      begin
        ShellExecute(0, 'open', Pchar(AppPath+Appfile), nil, nil, SW_SHOWNORMAL);
        SendMessage(FrmMain.Handle,WM_CLOSE,0,0);
      end;
    end;
  end
  else
    FrmMain.stat1.Panels[3].Text :='���£�����ʧ��';
end;

procedure TThreadYHID.SendMsg;
var
 i: integer;
 SendIDHWnd, SendDLGHWnd: LongInt;
 s: string;
 hhhh:LongInt;
begin
  inherited;
  try
    for i := 0 to FrmMain.lvSendList.Items.Count - 1 do
    begin
      StWwHwnd.Clear;
      EnumWindows(@EnumWndProc,0);//ö�ٳ��򿪵��������

      if FrmMain.chk2.Checked then //�����͸����ߵ�����
        if not WangWangOnLine(FrmMain.lvSendList.Items.Item[i].Caption) then
        begin
          FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '����';
          FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 2;
          Continue;
        end;
      if FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] = '�ɹ�' then  continue;//����ʾΪ�⼸��״̬�Ķ����÷���

      if not ZhiDingWangWang(i, SendIDHWnd) then Continue;   //ָ�����ͺ��Ƿ��

      EnumChildWindows(SendIDHWnd, @EnumChildSendID, 0);//ö�ٷ��ͺ����пؼ�
      SendMessage(MenuBtnHwnd,BM_CLICK,0,0); //����˵���ť
      Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
      memu := FindWindow('coolmenu',nil);
      if memu <> 0 then
      begin
        SendMessage(memu,WM_LBUTTONDOWN , MK_LBUTTON, MAKELONG(70,145)); //ģ������ָ�����͡�
        PostMessage(memu,WM_LBUTTONUP , MK_LBUTTON, MAKELONG(70,145)); //������Post�������ִ����ȥ
      end;

      Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
      SendDLGHWnd := FindWindow(nil, PWideChar('ָ���û�����'));
      if SendDLGHWnd <> 0 then
      begin
        EnumChildWindows(SendDLGHWnd, @EnumChildSendID, 0);
        SendMessage(IDEdtHwnd,WM_SETTEXT,0,Integer(PChar(FrmMain.lvSendList.Items.Item[i].Caption)));  //��û�
        SendMessage(IDEdtHwnd,WM_IME_KEYDOWN,VK_RETURN,0);//����ENTER�����൱�ڡ����͡���ť
//        PostMessage(SendBtnHwnd,BM_CLICK,0,0); //������Ͱ�ť  ������POSTȫΪ�������������˳�����жϵ�
        Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
        if SendDLGHWnd <> 0 then
        begin
          sendMessage(SendDLGHWnd,WM_CLOSE,0,0);
          wndhwnd := FindWindow(nil, '��������');//û������û�
          if wndhwnd <> 0 then
          begin
            SendMessage(wndhwnd,WM_CLOSE,0,0);
            FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := 'û������û�';
            FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
            Continue;
          end;
        end;
      end
      else begin
        FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '��ָ�����ʹ���';
        FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
        Continue;
      end;

      wndhwnd := FindWindow(nil, '��������');//�ܾ���Ӵ���
      if wndhwnd <> 0 then
      begin
        SendMessage(wndhwnd,WM_CLOSE,0,0);
        FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '�Է��ܾ����';
        FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
        Continue;
      end;
      Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�

      wndhwnd := FindWindow(nil, '��Ӻ�����Ϣ');//�û���Ϣ����
      if wndhwnd <> 0 then
      begin
        if not FrmMain.ChkSFYZ.Checked then  //��Ҫ�����֤
        begin
          EnumChildWindows(wndhwnd, @EnumChildSendID, 0);
          SendMessage(IDEdtHwnd,WM_SETTEXT,0,Integer(PChar(FrmMain.EdtYZXX.Text)));//��д��֤��Ϣ
//          SendMessage(IDEdtHwnd,WM_IME_KEYDOWN,VK_RETURN,0);//����ENTER�����൱�ڵ����ȷ����ť��
          SendMessage(SendBtnHwnd,BM_CLICK,0,0); //���ȷ����ť
          Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
          if not DengDaiYanZhen(i) then Continue;//������֤��
          Sleep(StrToInt(FrmMain.EdtYZSJ.Text)*1000);//�ȴ��Է����
          wndhwnd := FindWindow(nil, '������󱻾ܾ�');//���󱻾ܾ�
          if wndhwnd <> 0 then
          begin
            SendMessage(wndhwnd,WM_CLOSE,0,0);
            FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '�Է��ܾ����';
            FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
            Continue;
          end;
          wndhwnd := FindWindow(nil, '��Ӻ��ѳɹ�!');//��ӳɹ�
          if wndhwnd <> 0 then
          begin
            EnumChildWindows(wndhwnd, @EnumChildSendID, 0);
            SendMessage(SendBtnHwnd,BM_CLICK,0,0); //���������Ϣ��ť
            Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
          end
          else begin
            FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '������ӳ�ʱ';
            FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
            Continue;
          end;
        end
        else begin
          SendMessage(wndhwnd,WM_CLOSE,0,0);
          FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '�ų���Ϣ��֤';
          FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 0;
          Continue;
        end;
      end;


      wndhwnd := FindWindow(nil, PWideChar(FrmMain.lvSendList.Items.Item[i].Caption + ' - ' +   sSendWangWang)); //�ҵ����촰�ھ��
      if wndhwnd <> 0 then
      begin
        EnumChildWindows(wndhwnd, @EnumChildWndProc, 0);
        if not JianHaoYou(i) then Continue; //��Ϊ����
        FaXiaoXi();//������Ϣ
        SendMessage(wndhwnd,WM_KEYDOWN,VK_RETURN,0);
        Sleep(StrToInt(FrmMain.Edt2.Text)*1000);//ϵͳ�ӳ�
        if not DengDaiYanZhen(i) then Continue;//������֤��

        SendMessage(wndhwnd,WM_CLOSE,0,0);                    //�ر����촰��
        FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := '�ɹ�';
        FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 1;
      end
      else begin
        FrmMain.lvSendList.Items.Item[i].SubItems.Strings[0] := 'ʧ��';
        FrmMain.lvSendList.Items.Item[i].SubItemImages[0] := 3;
      end;

      Sleep(StrToInt(FrmMain.EdtStopTime.Text)*1000);//�ȴ�������һ��
    end;
    FrmMain.Btn2.Enabled := not FrmMain.Btn2.Enabled;
    FrmMain.Btn3.Enabled := not FrmMain.Btn2.Enabled;
  except
    Application.MessageBox('�߳��쳣��ֹ!!','����',mb_ok); { �߳��쳣 }
    FrmMain.Btn2.Enabled := not FrmMain.Btn2.Enabled;
    FrmMain.Btn3.Enabled := not FrmMain.Btn2.Enabled;
  end;
end;

end.
