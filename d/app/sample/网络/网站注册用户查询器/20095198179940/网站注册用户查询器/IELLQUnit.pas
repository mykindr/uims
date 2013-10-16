unit IELLQUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, RzPanel, RzSplit, ComCtrls, RzTreeVw, RzTabs,
  StdCtrls, RzCmboBx, OleCtrls, SHDocVw, RzButton, RzLstBox, IniFiles,RzLabel,
  RzStatus, ImgList,ActiveX, RzTray, AppEvnts,Menus;

type
  TTabs=class(TRzTabSheet)
  private
    FMIE:TWebBrowser;
    FWName:string;
    procedure wbProgressChange(Sender: TObject; Progress,
      ProgressMax: Integer);
    procedure WBDownloadBegin(Sender: TObject);
    procedure wbDownloadComplete(Sender: TObject);
    procedure wbNewWindow2(Sender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
  public
    Constructor Create(AOwner:TComponent;FURL:string;NowTabIndex:Integer);reintroduce;
    Destructor Destroy;override;
    procedure SetFMIE(TypeIntex:Integer;var GetStr:string);
end;

type
  TMenuNotifyEvent=procedure(SEnder:TMenuItem)of object;
  TIELLQForm = class(TForm)
    RzPanel1: TRzPanel;
    Image1: TImage;
    RzStatusBar1: TRzStatusBar;
    panKJLL: TRzPanel;
    RzPanel3: TRzPanel;
    Splitter1: TSplitter;
    TreeView1: TRzTreeView;
    RzToolbar1: TRzToolbar;
    btnHT: TRzToolButton;
    Ptxt: TRzStatusPane;
    RKS: TRzKeyStatus;
    pb: TProgressBar;
    RClockS: TRzClockStatus;
    ImageList1: TImageList;
    btnQJ: TRzToolButton;
    btnTZ: TRzToolButton;
    btnSX: TRzToolButton;
    btnZY: TRzToolButton;
    btnSS: TRzToolButton;
    btnSC: TRzToolButton;
    ApplicationEvents1: TApplicationEvents;
    RzTrayIcon1: TRzTrayIcon;
    pmz: TPopupMenu;
    btnXS: TMenuItem;
    N7: TMenuItem;
    btnTC: TMenuItem;
    pm: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    pmPrt: TPopupMenu;
    N3: TMenuItem;
    N5: TMenuItem;
    N9: TMenuItem;
    PCT: TRzPageControl;
    RzTabSheet1: TRzTabSheet;
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TRzLabel;
    lstAutoUrl: TRzListBox;
    RzPanel4: TRzPanel;
    RzLabel1: TRzLabel;
    RCbbURL: TRzComboBox;
    btnKJLL: TRzToolButton;
    ImageList2: TImageList;
    procedure btnHTClick(Sender: TObject);
    procedure btnQJClick(Sender: TObject);
    procedure btnTZClick(Sender: TObject);
    procedure btnSXClick(Sender: TObject);
    procedure btnZYClick(Sender: TObject);
    procedure btnSSClick(Sender: TObject);
    procedure btnSCClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ClickPop(sender:TMenuItem);
    procedure lstAutoUrlDblClick(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure RCbbURLKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PCTChange(Sender: TObject);
    procedure PCTDblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure btnKJLLClick(Sender: TObject);
    procedure btnXSClick(Sender: TObject);
    procedure btnTCClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);

  private
    { Private declarations }
    NewPageIndex:Integer;
    NowMTabName:string;
    StrName:string;
    ALLURL:TStrings;
    FTab:TTabs;
    procedure wbNavigateComplete2(Sender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure URLlst;

    procedure SetTWebBrowser(ATypeIndex:Integer); //���ݿؼ�����,���������������ÿؼ�
  public
    { Public declarations }
    FOIE:TWebBrowser;
    procedure GoURL(FURL:String);
    function GetExePath:String;
    procedure AutoPop(str:string);
  end;

var
  IELLQForm: TIELLQForm;
  node1,node2,treenode: ttreenode;  //����ڵ�
implementation

uses dmUnit, mainUnit, WZBJUnit, ADDRULUnit;

{$R *.dfm}



procedure TIELLQForm.btnHTClick(Sender: TObject);
begin
//���˰�ť
SetTWebBrowser(0);
end;

procedure TIELLQForm.btnQJClick(Sender: TObject);
begin
//ǰ����ť
SetTWebBrowser(1);
end;

procedure TIELLQForm.btnTZClick(Sender: TObject);
begin
//ֹͣ��ť
SetTWebBrowser(5);
end;

procedure TIELLQForm.btnSXClick(Sender: TObject);
begin
//ˢ�°�ť
SetTWebBrowser(4);
end;

procedure TIELLQForm.btnZYClick(Sender: TObject);
begin
//��ҳ��ť
SetTWebBrowser(2);
end;

procedure TIELLQForm.btnSSClick(Sender: TObject);
begin
//������ť
SetTWebBrowser(3);
end;

procedure TIELLQForm.btnSCClick(Sender: TObject);
begin
//�ղذ�ť
//��ӵ��ղؼв˵���ť
N1Click(Sender);
end;

{ TTabs }

constructor TTabs.Create(AOwner: TComponent; FURL: string;
  NowTabIndex: Integer);
begin
  inherited Create(AOwner);
  FWName:='MIETab'+IntTostr(NowTabIndex);
  Name:=FWName;
  Caption:='���Ժ�...';


  FMIE:=TWebBrowser.Create(Self);
  TWinControl(FMIE).Parent:=Self;
  FMIE.Align:=alClient;
  FMIE.Navigate(FURL);
  FMIE.OnDownloadBegin:=WBDownloadBegin;
  FMIE.OnDownloadComplete:=wbDownloadComplete;
  FMIE.OnProgressChange:=wbProgressChange;
  FMIE.OnNewWindow2:=wbNewWindow2;
end;

destructor TTabs.Destroy;
begin
  FMIE.Free;
  inherited;
end;

procedure TTabs.SetFMIE(TypeIntex: Integer; var GetStr: string);
begin
 GetStr:='';
  try
    case TypeIntex of
      0: FMIE.GoBack;     //����
      1: FMIE.GoForward;  //ǰ��
      2: FMIE.GoHome;     //������ҳ
      3: FMIE.GoSearch;   //����Ĭ�ϵ�����ҳ��
      4: FMIE.Refresh;    //ˢ�µ�ǰҳ��
      5: FMIE.Stop;       //ֹͣ���û�򿪵�ǰҳ��
      6: GetStr:=FMIE.LocationName;//��ǰλ�õ�����
      7: GetStr:=FMIE.LocationURL; //��ǰλ�õ�URL
      8: GetStr:=IntToStr(FMIE.Handle) ;//���ؾ��
      9: FMIE.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_DODEFAULT, EmptyParam, EmptyParam);  //��ӡ
      10:if FMIE.QueryStatusWB(OLECMDID_PRINTPREVIEW)=3 then
            FMIE.ExecWB(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DODEFAULT, EmptyParam,EmptyParam); //Ԥ��
      11:FMIE.ExecWB(OLECMDID_PAGESETUP, OLECMDEXECOPT_DODEFAULT, EmptyParam, EmptyParam);  //ҳ������
    end;
  except

  end;
end;

procedure TTabs.WBDownloadBegin(Sender: TObject);
begin
iellqform.Ptxt.Caption:='������...';
end;

procedure TTabs.wbDownloadComplete(Sender: TObject);
begin
  iellqform.Ptxt.Caption:='���';
  if Length(FMIE.LocationName)>30 then
  Self.Caption:=Copy(FMIE.LocationName,0,10)+'...'
  else
  Self.Caption:=FMIE.LocationName;
  iellqform.RCbbURL.Text:=FMIE.LocationURL;
end;

procedure TTabs.wbNewWindow2(Sender: TObject; var ppDisp: IDispatch;
  var Cancel: WordBool);
begin
  //ת�Ƶ���һ������
  ppDisp:=iellqform.FOIE.Application;
end;

procedure TTabs.wbProgressChange(Sender: TObject; Progress,
  ProgressMax: Integer);
begin
  iellqform.pb.Max:=ProgressMax;
  iellqform.pb.Position:=Progress;
end;

procedure TIELLQForm.SetTWebBrowser(ATypeIndex: Integer);
begin
  if NowMTabName='' then Exit;
    TTabs(FindComponent(NowMTabName)).SetFMIE(ATypeIndex,StrName);
end;

procedure TIELLQForm.URLlst;
var
  i,x:Integer;
  Temini:TIniFile;
  lst,lstpop,AUTOLST:TStrings;
  str_URL,str_name:string;
begin
  //��ini�ж�ȡ��ʷ���ʼ�¼
  Temini:=TIniFile.Create(GetExePath+'NEConfig.ini');
  lst:=TStringList.Create;
  lst.Clear;
  lstpop:=TStringList.Create;
  lstpop.Clear;
  AUTOLST:=TStringList.Create;
  AUTOLST.Clear;
  try
    Temini.ReadSection('URLlst',lst);
    for i:=0 to lst.Count-1 do
    begin
      str_URL:=Temini.ReadString('URLlst',lst[i],'');
      RCbbURL.Items.Add(str_URL);
    end;


    Temini.ReadSection('URL',lstpop);
    for x:=0 to lstpop.Count-1 do
    begin
      str_name:=lstpop[x];
      AutoPop(lstpop[x]);
    end;

    Temini.ReadSection('AUTOURL',AUTOLST);

    lstAutoUrl.Clear;
    lbl2.Visible:=AUTOLST.Count>0;
    for x:=0 to AUTOLST.Count-1 do
    begin
      str_name:=AUTOLST[x];

      lstAutoUrl.Add(str_name);
      ALLURL.Add(Temini.ReadString('AUTOURL',str_name,'about:blank'));
    end;  
    
  finally
    Temini.Free;
    lst.Free;
    lstpop.Free;
    AUTOLST.Free;
  end;
end;

procedure TIELLQForm.wbNavigateComplete2(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  //��ת����һ��ҳ��
  if (Pos('http://',URL)>0) and (URL<>RCbbURL.Text) then
    GoURL(URL);
end;

procedure TIELLQForm.AutoPop(str: string);
var
  EventName:TmenuNotifyEvent;
  NewItem: TMenuItem;
begin
  NewItem:=TMenuItem.Create(Self);
  NewItem.Caption:=str;
  EventName:=ClickPop;
  NewItem.OnClick:=TnotifyEvent(EventName);
  iellqform.pm.Items.Add(NewItem);
end;

function TIELLQForm.GetExePath: String;
begin
    Result:=ExtractFilePath(ParamStr(0));
    if Result[Length(Result)]<>'\' then
       Result:=Result+'\';
end;

procedure TIELLQForm.GoURL(FURL: String);
begin
  //���ӷ�ҳ
  Inc(NewPageIndex);
  FTab:=TTabs.Create(iellqform,FURL,NewPageIndex);
  FTab.PageControl:=iellqform.PCT;
  PCT.TabIndex:=FTab.GetPageIndex;
end;

procedure TIELLQForm.FormCreate(Sender: TObject);
begin
  //����һ��TWB
  ALLURL:=TStringList.Create;
  ALLURL.Clear;
  FOIE:=TWebBrowser.Create(Self);
  FOIE.Visible:=False;
  FOIE.OnNavigateComplete2:=wbNavigateComplete2;
  URLlst;
  NewPageIndex:=0;
end;

procedure TIELLQForm.FormDestroy(Sender: TObject);
var
  i:Integer;
  strn,stru:string;
  temini:TIniFile;
begin
  //�˳�
  Temini:=TIniFile.Create(GetExePath+'NEConfig.ini');
  try
    temini.EraseSection('AUTOURL');
    for i:=1 to PCT.PageCount-1 do
    begin
      NowMTabName:=PCT.PageForTab(i).Name;
      SetTWebBrowser(6);
      strn:=StrName;
      SetTWebBrowser(7);
      stru:=StrName;
      temini.WriteString('AUTOURL',strn,stru);
    end;
  finally
    temini.Free;
  end;
end;

procedure TIELLQForm.lstAutoUrlDblClick(Sender: TObject);
var
  temStr:string;
begin
if lstAutoUrl.Selected[lstAutoUrl.ItemIndex] then
  begin
    temStr:=ALLURL[lstAutoUrl.ItemIndex];
    if temStr<>'' then GoURL(temStr)
else
    begin
      Application.MessageBox('��ȡ��ַ����','��ʾ',MB_OK);
    end;
  end;
end;

procedure TIELLQForm.ClickPop(sender: TMenuItem);
var
  tem:TIniFile;
  str_URL:String;
begin
  tem:=TIniFile.Create(iellqform.GetExePath+'NEConfig.ini');
  str_URL:=tem.ReadString('URL',sender.caption,'');
  iellqform.GoURL(str_URL);
  tem.Free;
end;

procedure TIELLQForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
  const   
    StdKeys   =   [VK_TAB,   VK_RETURN];   {   standard   keys   }
    ExtKeys   =   [VK_DELETE,   VK_BACK,   VK_LEFT,   VK_RIGHT];   {   extended   keys   }
    fExtended   =   $01000000;   {   extended   key   flag   }
var MIEHD:HWND;
begin
Handled   :=   False;
    with   Msg   do
    if   ((Message   >=   WM_KEYFIRST)   and   (Message   <=   WM_KEYLAST))   and
        ((wParam   in   StdKeys)   or   {$IFDEF   VER120}(GetKeyState(VK_CONTROL)   <   0)   or   {$ENDIF}
        (wParam   in   ExtKeys)   and   ((lParam   and   fExtended)   =   fExtended))   then
    try
      SetTWebBrowser(8);
      MIEHD:=StrToInt(StrName);
        if IsChild(MIEHD,hWnd) then
        {   handles   all   browser   related   messages   }
        begin
          with TWebBrowser(FindControl(MIEHD)).Application as IOleInPlaceActiveObject do
              Handled := TranslateAccelerator(Msg) = S_OK;
          if   not   Handled   then
          begin
              Handled   :=   True;
              TranslateMessage(Msg);
              DispatchMessage(Msg);
          end;
        end;
    except
    end;
end;

procedure TIELLQForm.RCbbURLKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var
  I:Integer;
  BLLst:Boolean;
  Temini:TIniFile;
begin
if Key=13 then
  begin
    if RCbbURL.Text<>'' then
    GoURL(RCbbURL.Text);
    //��ӵ������б���
    BLLst:=False;

    for I:=0 to RCbbURL.Items.Count-1 do
    begin
      if RCbbURL.Items[i]=RCbbURL.Text then
      begin
        BLLst:=True;
        Break;
      end;
    end;

    if not BLLst then
    begin
      Temini:=TIniFile.Create(GetExePath+'NEConfig.ini');
      try
        Temini.WriteString('URLlst','U'+intTostr(RCbbURL.Items.Count+1),RCbbURL.Text);
        RCbbURL.Items.Add(RCbbURL.Text);
      finally
        Temini.Free;
      end;
    end;
  end;
end;

procedure TIELLQForm.PCTChange(Sender: TObject);
begin
if PCT.TabIndex=0 then
  begin
    RCbbURL.Text:='';
    Exit;
  end;
  NowMTabName:=PCT.PageForTab(PCT.TabIndex).Name;

  SetTWebBrowser(6);
  if StrName<>'' then
    iellqform.Caption:='IE�����  '+strName;
    PCT.ActivePage.Caption:=strName;
  SetTWebBrowser(7);
  if StrName<>'' then
    RCbbURL.Text:=StrName;
end;

procedure TIELLQForm.PCTDblClick(Sender: TObject);
begin
if PCT.TabIndex=0 then Exit;
  PCT.ActivePage.Free;
  RCbbURL.Text:='';
  PCT.SelectNextPage(True);
end;

procedure TIELLQForm.N1Click(Sender: TObject);
begin
//��ӵ��ղؼв˵���ť
if RCbbURL.Text='' then Exit;
  addurlform.REDTURL.Text:=RCbbURL.Text;
  addurlform.REDTName.Text:=PCT.ActivePage.Caption;
  addurlform.ShowModal;
end;

procedure TIELLQForm.N2Click(Sender: TObject);
begin
//�����ղؼв˵���ť
end;

procedure TIELLQForm.btnKJLLClick(Sender: TObject);
begin
//�������˵���ť
if(btnkjll.Hint='����������') then
  begin
    panKJLL.Visible:=false;
    btnkjll.Hint:='�������ر�';
  end
else if(btnkjll.Hint='�������ر�') then
  begin
    panKJLL.Visible:=true;
    btnkjll.Hint:='����������';
  end;
end;

procedure TIELLQForm.btnXSClick(Sender: TObject);
begin
//��ʾ�˵���ť
RzTrayIcon1.RestoreApp;
end;

procedure TIELLQForm.btnTCClick(Sender: TObject);
begin
//�˳��˵���ť
application.Terminate;
end;

procedure TIELLQForm.FormShow(Sender: TObject);
begin
//��TREEVIEW���г���Ϣ
treeview1.Items.Clear;
with dm.ADOZJWZQuery1  do
  begin
    Close;
    SQl.Clear;
    SQL.Add('select distinct ��վ����,��ַ from ��վע���û������');
    Open;
  end;
//---------------------------------------------------------------------------
dm.ADOZJWZQuery.First;//�ӵ�һ����¼��ʼ
while not dm.ADOZJWZQuery1.Eof do
    begin
      //��Ӹ��ڵ�
      node2:= TreeView1.Items.Add(node1,dm.ADOZJWZQuery1.FieldValues['��վ����']);
      with dm.ADOZJWZQuery2 do
        begin
          Close;
          SQl.Clear;
          SQL.Add('select ��վ����,��ַ from ��վע���û������  where ��վ���� =:wzmc');
          Parameters.ParamByName('wzmc').Value:= dm.ADOZJWZQuery1.FieldByName('��վ����').AsString;
          Open;
        end;
        dm.ADOZJWZQuery.First;//�ӵ�һ����¼��ʼ
        while not dm.ADOZJWZQuery2.Eof do
          begin
            //����ӽڵ�
            TreeView1.Items.AddChild(node2,dm.ADOZJWZQuery2.fieldbyname('��ַ').asstring);
            node2.ImageIndex:=1;
            node2.SelectedIndex:=1;
            dm.ADOZJWZQuery2.next;//��һ����¼
          end;
        dm.ADOZJWZQuery1.Next;//��һ����¼
    end;
end;

procedure TIELLQForm.TreeView1DblClick(Sender: TObject);
begin
//˫�����еĽڵ�,�����Ӧ����վ
if TreeView1.Selected.Level=1 then
  begin
    with dm.ADOZJWZQuery1  do
      begin
        Close;
        SQl.Clear;
        SQL.Add('select ��վ����,��ַ from ��վע���û������  where ��ַ =:wz');
        Parameters.ParamByName('wz').Value:= treeview1.Selected.Text;
        Open;
      end;
    iellqform.RCbbURL.Text:=dm.ADOZJWZQuery1.FieldValues['��ַ'];
    GoURL(RCbbURL.Text);
  end;
end;

initialization
    OleInitialize(nil);
  finalization
  try
    OleUninitialize;
  except
  end;
end.
