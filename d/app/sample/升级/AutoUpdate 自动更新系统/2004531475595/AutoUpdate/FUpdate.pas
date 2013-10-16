unit FUpdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, XPMan, ExtCtrls, WinSkinData, IniFiles,
  AppInfo, Transfer, IdComponent;


{$R Res\Res.res}

const  MAX_PAGES = 3;
const  BMP_START = 101;

type
  TfrmAutoUpdate = class(TForm)
    Image1: TImage;
    XPManifest1: TXPManifest;
    PcWizard: TPageControl;
    tbsWellCome: TTabSheet;
    tbsGetUpdate: TTabSheet;
    Label1: TLabel;
    cmdPrev: TButton;
    cmdNext: TButton;
    Button3: TButton;
    Button4: TButton;
    lbAppList: TListBox;
    Button5: TButton;
    Label2: TLabel;
    Label3: TLabel;
    lblTotalSize: TLabel;
    ProgressBar1: TProgressBar;
    lbUpdateList: TListBox;
    tbsDownload: TTabSheet;
    Memo1: TMemo;
    tbsFilsh: TTabSheet;
    Label4: TLabel;
    pbDetail: TProgressBar;
    pbMaster: TProgressBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    tbNoUpdate: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lblStatuse: TLabel;
    procedure cmdNextClick(Sender: TObject);
    procedure cmdPrevClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PcWizardChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tbsGetUpdateShow(Sender: TObject);
    procedure tbsWellComeShow(Sender: TObject);
    procedure tbsDownloadShow(Sender: TObject);
  private
    { Private declarations }
    AppInfo : TAppInfo;
    strCurrentFile: String;
    strTempPath: String;
    strLocalPath: String;
    TransferFactory: TTransferFactory;
    STime: TDateTime;
    AbortTransfer: Boolean;
    procedure OnAnalyse(Sender: TObject; Count, Current: Integer);
    procedure DownloadBegin(Sender: TObject; const AWorkCountMax: Integer);
    procedure OnDownload(Sender: TObject; const AWorkCount: Integer);
    procedure DownloadEnd(Sender: TObject);
    //procedure AnalyseDownloadBegin(Sender: TObject; const AWorkCountMax: Integer);
    //procedure OnAnalyseDownload(Sender: TObject; const AWorkCount: Integer);
    //procedure AnalyseDownloadEnd(Sender: TObject);
    procedure GetTempPath;
    Procedure GetLocalPath;
    procedure OnStatuse(ASender: TObject; const AStatus: TIdStatus; const AStatusText: string);
  public
    { Public declarations }
  end;


var
  frmAutoUpdate: TfrmAutoUpdate;

implementation

uses FSeting, Analyse, Update;

Var
  AverageSpeed: Double = 0;

{$R *.dfm}

procedure TfrmAutoUpdate.cmdNextClick(Sender: TObject);
begin
  if (PcWizard.ActivePageIndex < MAX_PAGES - 1) then
  begin
    Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START + PcWizard.ActivePageIndex + 1);
    Image1.Update;
    Application.ProcessMessages;
    PcWizard.ActivePageIndex := PcWizard.ActivePageIndex + 1;
  end;
end;

procedure TfrmAutoUpdate.cmdPrevClick(Sender: TObject);
begin
  if (PcWizard.ActivePageIndex > 0) then
  begin
    Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START + PcWizard.ActivePageIndex - 1);
    Image1.Update;
    Application.ProcessMessages;
    PcWizard.ActivePageIndex := PcWizard.ActivePageIndex - 1;
  end;
end;

procedure TfrmAutoUpdate.Button3Click(Sender: TObject);
begin
  Close();
end;

procedure TfrmAutoUpdate.PcWizardChange(Sender: TObject);
begin
  if PcWizard.ActivePageIndex = 0 then
  begin
    cmdPrev.Enabled := false;
    cmdNext.Enabled := true;
  end
  else if PcWizard.ActivePageIndex = MAX_PAGES - 1 then
  begin
    cmdPrev.Enabled := true;
    cmdNext.Enabled := true;
  end
  else
  begin
    cmdPrev.Enabled := true;
    cmdNext.Enabled := false;
  end;
end;

procedure TfrmAutoUpdate.Button5Click(Sender: TObject);
begin
  if (lbAppList.ItemIndex = -1) then
  begin
    Application.MessageBox('��ѡ��һ����Ʒ', 'ϵͳ��ʾ');
    exit;
  end;
  frmSeting.AppName := lbAppList.Items[lbAppList.ItemIndex];
  frmSeting.ShowModal;
end;

procedure TfrmAutoUpdate.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
  Sessions: TStringList;
begin
  //���ó������۽���
  IniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.Ini'));
  //SkinData1.SkinFile := IniFile.ReadString('Application', 'Skins', '');
  //if (SkinData1.SkinFile <> '') then
  //  SkinData1.Active := true;
  FreeAndNil(IniFile);

  TransferFactory := TTransferFactory.Create;
  PcWizard.ActivePageIndex := 0;
  Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START);
  Sessions := TStringList.Create;
  Inifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'UpdateApps.ini');
  IniFile.ReadSections(Sessions);
  lbAppList.Items.Assign(Sessions);
  lbApplist.ItemIndex := 0;
  FreeAndNil(Sessions);
end;

procedure TfrmAutoUpdate.tbsGetUpdateShow(Sender: TObject);
var
  Analyse: TAnalyse;
  //i:        Integer;
  Strs: TStrings;
begin
  tbsGetUpdate.Update;
  Application.ProcessMessages;
  ProgressBar1.Position := 0;
  self.cmdPrev.Enabled := false;
  self.cmdNext.Enabled := false;
  Analyse := TXMLAnalyse.Create;
  if lbAppList.Items.Count > 0 then
  begin
    if (Assigned(AppInfo)) then AppInfo.Free;
    AppInfo := TIniAppInfo.Create(ExtractFilePath(Application.ExeName) + 'UpdateApps.ini',
                  lbAppList.Items[lbAppList.ItemIndex]);

    Label3.Caption := '�������ȡ���¶����ļ�������������';
    Label3.Update;
    //for i := 0 to lbAppList.Items.Count - 1 do
    //begin
    AppInfo.AppName := lbAppList.Items[lbAppList.ItemIndex];
    Analyse.UpdateList := AppInfo.UpdateServer  + AppInfo.ListDefFile;
    Analyse.Transfer := TransferFactory.CreateTransfer(Analyse.UpdateList);
    //Analyse.Transfer.OnTransferStart := AnalyseDownloadBegin;
    //Analyse.Transfer.OnTransfer := OnAnalyseDownload;
    Analyse.OnAnalyse := OnAnalyse;
    try
      Strs := Analyse.GetUpdateList;
      //end;
      lbUpdateList.Items.Assign(Strs);
      FreeAndNil(Strs);
      if (lbUpdateList.Items.Count > 0) then
      begin
        Label3.Font.Color := clRed;
        Label3.Caption := Format('���� %d �����ø���', [lbUpdateList.Items.Count]);
        self.cmdPrev.Enabled := true;
        self.cmdNext.Enabled := true;
      end
      else
      begin
        Label3.Font.Color := clGreen;
        Label3.Caption := '���������������µİ汾������Ҫ����';
        self.cmdPrev.Enabled := true;
        self.cmdNext.Enabled := false;
      end;
    except
      Label3.Font.Color := clRed;
      Label3.Caption := '�������ȡ�����ļ������������������Ƿ���ͨ!';
      Label3.Update;
      self.cmdPrev.Enabled := true;
      self.cmdNext.Enabled := false;
    end;
  end;
  FreeAndNil(Analyse);
  //Analyse.UpdateList :=
end;

procedure TfrmAutoUpdate.OnAnalyse(Sender: TObject; Count,
  Current: Integer);
begin
  ProgressBar1.Max := Count;
  ProgressBar1.Position := Current + 1;
  ProgressBar1.Update;
  Application.ProcessMessages;
end;

procedure TfrmAutoUpdate.tbsWellComeShow(Sender: TObject);
begin
  if lbAppList.Items.Count > 0 then
  begin
    self.cmdPrev.Enabled := false;
    self.cmdNext.Enabled := true;
  end
  else
    self.cmdPrev.Enabled := false;
    self.cmdNext.Enabled := true;
end;

procedure TfrmAutoUpdate.tbsDownloadShow(Sender: TObject);
var
  TransferObj: TTransfer;
  UpdateObj: TUpdate;
  i: Integer;
begin
  self.cmdPrev.Enabled := false;
  self.cmdNext.Enabled := false;
  pbMaster.Max := lbUpdateList.Items.Count * 3;
  pbMaster.Position := 0;
  pbDetail.Position := 0;
  memo1.Perform(EM_SCROLLCARET, 0, 0 );
  Memo1.Lines.Add('��ʼ��ָ���ķ����������ظ����ļ���������');
  GetTempPath;
  GetLocalPath;
  for i := 0 to lbUpdateList.Items.Count - 1 do
  begin
    pbMaster.StepIt;
    UpdateObj := lbUpdateList.Items.objects[0] as TUpdate;
    UpdateObj.TempPath := strTempPath + UpdateObj.FileName;
    UpdateObj.LocalFile := strLocalpath + UpdateObj.LocalFile;
    strCurrentFile := UpdateObj.FileName;
    TransferObj := TransferFactory.CreateTransfer(AppInfo.UpdateServer + Updateobj.UpdateURL);
    TransferObj.OnTransferStart := DownloadBegin;
    TransferObj.OnTransferEnd := DownloadEnd;
    TransferObj.OnTransfer := OnDownload;
    TransferObj.OnStatus := OnStatuse;
    UpdateObj.TransferObj := TransferObj;
    UpdateObj.Download(UpdateObj.TempPath);
  end;

  lblStatuse.Caption := '';
  Memo1.Lines.Add('');
  Memo1.Lines.Add('�����ļ�������������');
  for i := 0 to lbUpdateList.Items.Count - 1 do
  begin
    pbMaster.StepIt;
    UpdateObj := lbUpdateList.Items.objects[0] as TUpdate;
    if (UpdateObj.UpdateType = upExecute) then
      Memo1.Lines.Add(Format('����ִ�� %s �ļ�', [UpdateObj.FileName]))
    else
      Memo1.Lines.Add(Format('���ڸ���%s�ļ�', [UpdateObj.FileName]));
    if UpdateObj.UpdateIt then
      Memo1.Lines.Add(Format('�ļ� %s �������!', [UpdateObj.FileName]))
    else
      Memo1.Lines.Add(Format('�ļ� %s ����ʧ��!!', [UpdateObj.FileName]));
  end;

  Memo1.Lines.Add('');
  Memo1.Lines.Add('ɾ����ʱ�ļ�������������');
  for i := 0 to lbUpdateList.Items.Count - 1 do
  begin
    pbMaster.StepIt;
    UpdateObj := lbUpdateList.Items.objects[0] as TUpdate;
    DeleteFile(UpdateObj.TempPath);
  end;
  Memo1.Lines.Add('��ʱ�ļ���ɾ��');

  Memo1.Lines.Add('');
  Memo1.Lines.Add('�����Ѿ���ɣ�����ر��˳�����');
  self.cmdPrev.Enabled := false;
  self.cmdNext.Enabled := false;
  Image1.Picture.Bitmap.LoadFromResourceID(HInstance, BMP_START + 3);
end;

procedure TfrmAutoUpdate.DownloadBegin(Sender: TObject;
  const AWorkCountMax: Integer);
begin
  STime := Now;
  Memo1.Lines.Add(Format('��ʼ���� %s �ļ�', [strCurrentFile]));
  pbDetail.Max := AWorkCountMax;
end;

procedure TfrmAutoUpdate.DownloadEnd(Sender: TObject);
begin
  Memo1.Lines.Add(Format('%s �ļ�������ɣ�', [strCurrentFile]));
end;

procedure TfrmAutoUpdate.OnDownload(Sender: TObject;
  const AWorkCount: Integer);
var
  S: String;
  TotalTime: TDateTime;
//  RemainingTime: TDateTime;
  H, M, Sec, MS: Word;
  DLTime: Double;
begin
  TotalTime :=  Now - STime;
  DecodeTime(TotalTime, H, M, Sec, MS);
  Sec := Sec + M * 60 + H * 3600;
  DLTime := Sec + MS / 1000;
  if DLTime > 0 then
    AverageSpeed := {(AverageSpeed + }(AWorkCount / 1024) / DLTime{) / 2};

  if AverageSpeed > 0 then begin
    Sec := Trunc(((pbDetail.Max - AWorkCount) / 1024) / AverageSpeed);

    S := Format('%2d:%2d:%2d', [Sec div 3600, (Sec div 60) mod 60, Sec mod 60]);

    S := 'ʣ��ʱ�䣺 ' + S;
  end
  else S := '';

  S := FormatFloat('0.00 KB/s', AverageSpeed) + '; ' + S;
  lblStatuse.Caption := '�����ٶ�Ϊ��' + S;

  //if AbortTransfer then IdFTP1.Abort;

  pbDetail.Position := AWorkCount;
  pbDetail.Update;
  AbortTransfer := false;
end;
{
procedure TfrmAutoUpdate.AnalyseDownloadBegin(Sender: TObject;
  const AWorkCountMax: Integer);
begin
  ProgressBar1.Max := AWorkCountMax;
  ProgressBar1.Position := 0;
end;

procedure TfrmAutoUpdate.AnalyseDownloadEnd(Sender: TObject);
begin

end;

procedure TfrmAutoUpdate.OnAnalyseDownload(Sender: TObject;
  const AWorkCount: Integer);
begin
  ProgressBar1.Position := AWorkCount;
  ProgressBar1.Update;
end;
}
procedure TfrmAutoUpdate.GetTempPath;
var
  tmpPath: array[0..1024] of char;
begin
  Windows.GetTempPath(1024,tmpPath);
  strTemppath := tmpPath;
end;

procedure TfrmAutoUpdate.GetLocalPath;
begin
  if (AppInfo.LocalPath = '') then
    strLocalPath := ExtractFilePath(Application.ExeName)
  else
    strLocalPath := AppInfo.LocalPath;
end;

procedure TfrmAutoUpdate.OnStatuse(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
  Memo1.Lines.Add(AStatusText);
end;

end.
