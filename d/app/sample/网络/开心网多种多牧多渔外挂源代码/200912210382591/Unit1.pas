unit Unit1;
{$DEFINE private}
{.$DEFINE checklastmodifytime}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, IdTCPClient, ExtCtrls,
  StrUtils, IdBaseComponent, IdComponent, IdTCPConnection, IdHTTP,
  ComCtrls, ShellAPI, ActiveX, SHDocVw, SHDocVw_EWB, EwbCore, EmbeddedWB,
  IdUDPBase, IdUDPClient, IdSNTP, IdCookieManager, MSHTML, dhtmlevent, Registry, WinInet,
  ComObj, ShlObj, IdIntercept, IdCompressionIntercept;


type
  frfield = record
    uid: string;
    farmid: integer;
  end;

  buyfishth = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

  TForm1 = class(TForm)
    btn01: TButton;
    btn02: TButton;
    btn11: TButton;
    btn12: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    btn03: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    btn13: TButton;
    btn14: TButton;
    btn15: TButton;
    ComboBox3: TComboBox;
    Timer1: TTimer;
    IdHTTP0: TIdHTTP;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    btn04: TButton;
    btn21: TButton;
    btn22: TButton;
    ComboBox4: TComboBox;
    Edit3: TEdit;
    btn05: TButton;
    btn23: TButton;
    btn24: TButton;
    StaticText1: TStaticText;
    btn25: TButton;
    btn06: TButton;
    label1: Tlabel;
    wb1: TEmbeddedWB;
    IdSNTP1: TIdSNTP;
    btn26: TButton;
    idckmgr1: TIdCookieManager;
    btn07: TButton;
    Label2: TLabel;
    Timer2: TTimer;
    btn08: TButton;
    btn16: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btn02Click(Sender: TObject);
    procedure btn12Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure btn03Click(Sender: TObject);
    procedure btn13Click(Sender: TObject);
    procedure getanimalsid(const source: string; var tlist: Tstringlist);
    procedure getfishid(const source: string; var tlist: Tstringlist);
    procedure getfuids(const source: string; var tlist: Tstringlist);
    procedure btn15Click(Sender: TObject);
    procedure btn14Click(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure btn01Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
    procedure btn04Click(Sender: TObject);
    procedure ComboBox1DblClick(Sender: TObject);
    procedure btn21Click(Sender: TObject);
    procedure btn22Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure btn24Click(Sender: TObject);
    procedure wbsettext(St: string);
    procedure wbaddtext(st: string);
    procedure btn25Click(Sender: TObject);
    procedure btn06Click(Sender: TObject);
//     procedure ApplicationEvents1Message(var Msg: TMsg; var Handled: Boolean);
    procedure StaticText1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure wb1DocumentComplete(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure btn26Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure btn23Click(Sender: TObject);
    procedure btn07Click(Sender: TObject);
    procedure btn16Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn08Click(Sender: TObject);
    procedure btn05Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btn27Click(Sender: TObject);
  private
//    FOleInPlaceActiveObject: IOleInPlaceActiveObject;

    idtcps: array[0..50] of tIdTCPClient;
    idstrs: array[0..50] of string;
    idtcpwaps: array[0..20] of TIdTCPClient;
    refresh: Boolean;
    beilv, MAXyaoqiantime, Maxbuyanimaltime, maxyaoyutime: integer;
    EventSinkyes: TDHTMLEvent;
    yqlist: TStringList;
    yqtime: TDateTime;
{$IFDEF private}
    reg3d: TRegistry;
{$ENDIF}
  public
    function getreturnmsg(amsgstr: string): string;
    procedure yaoqianstart(Sender: TObject);
    procedure catchfishstart(Sender: TObject);
    //
    function Get0farmseedStr(fruid, seedid: string; farmnum: Integer): string;
    function Get0harvestStr(farmnum: Integer): string;
    function Get0buyseedStr(seedid, seednum: string): string;
    function Get0ploughStr(fruid, farmnum: string): string; //�ѵ�
    function get0yaoqianstr(fruid: string): string;
    function get0usetoolstr(fruid, toolid: string): string; //ʹ�õ���
    function get0yaoguolistr(fruid, cropid: string): string;
    function get1buyanimalsStr(animalid: string; animalnum: Integer): string;
    function get1mharvestStr(animalid: string): string;
    function get1productStr(animalid: string): string;
    function get1foodStr(): string;
    function get1advanimalStr(animalid: string): string; //��������
    function get2buyfishStr(fishid: string): string; //��������
    function get2shakefishStr(): string; //����ҡ��
    function get2catchfishStr(fishid: string): string; //����
    function get2foodfishStr(fishid: string): string; //ι��
    function get2netfishStr(fruid: string): string; //�����˼���
    function get2wapbuyallStr(const wapverify, wapcookie: string): string; //������
  end;

const
  kxfield: array[0..9] of Integer = (1, 2, 3, 4, 5, 8, 9, 11, 13, 14);
  axfield: array[0..4] of integer = (6, 7, 10, 12, 15);
  kxhomeurl = 'http://www.kaixin001.com/home/';
  kxgdurl = 'http://www.kaixin001.com/!house/garden/index.php';
  kxranchurl = 'http://www.kaixin001.com/!house/ranch/index.php';
  kxfishurl = 'http://www.kaixin001.com/!fish/index.php';
var
  Form1: TForm1;
  fpath, verify, cookiestr, uidstr, lasturl: string;

implementation
{$R *.dfm}

function getFilelastwritetime(): TSystemTime;
{ ת���ļ���ʱ���ʽ }
var
  Tct: _SystemTime;
  fd, Temp: _FileTime;
  Tp: TSearchRec;
begin
  FindFirst(ParamStr(0), faAnyFile, Tp); { ����Ŀ���ļ� }
  fd := Tp.FindData.ftLastWriteTime;
  FileTimeToLocalFileTime(fd, Temp);
  FileTimeToSystemTime(Temp, Tct);
  Result := Tct;
  FindClose(tp);
end;

procedure Tform1.getanimalsid(const source: string; var tlist: Tstringlist);
var
  i, j, m, n: integer;
  str: string;
  fg: Boolean;
begin
  i := 0;
  repeat
    i := Posex('<animalsid>', source, i + 1);
    j := Posex('</animalsid>', source, i + 1);
    fg := (i > 0) and (j > 0) and (j - i <= 40);
    if fg then
    begin
      m := posex('<bstat>', source, j);
      n := posex('</bstat>', source, j);
      str := Copy(source, m + 7, n - m - 7);
      str := trim(str);
      if str <> '-1' then
      begin
        str := copy(source, i + 11, j - i - 11);
        tlist.Add(str);
      end;
    end;
  until fg = false;
end;


procedure Tform1.getfishid(const source: string; var tlist: Tstringlist);
var
  i, j: integer;
  str: string;
  fg: Boolean;
  tlist2: TStringList;
begin

  i := 0;
  repeat
    i := Posex('<fishid>', source, i + 1);
    j := Posex('</fishid>', source, i + 1);
    fg := (i > 0) and (j > i) and (j - i <= 40);
    if fg then
    begin

      str := copy(source, i + 8, j - i - 8);
      if str <> '0' then
        tlist.Add(str);

    end;
  until fg = false;
  i := pos('<tackleid>', source); //�к���������
  if i > 0 then
  begin
    tlist2 := TStringList.Create;
    repeat //����Ϲ���
      i := Posex('<fishid>', source, i + 1);
      j := Posex('</fishid>', source, i + 1);
      fg := (i > 0) and (j > i) and (j - i <= 40);
      if fg then
      begin
        str := copy(source, i + 8, j - i - 8);
        if str <> '0' then
          tlist2.Add(str);
      end;
    until fg = false;
    i := 0;
    repeat
      i := Posex('<fishid2>', source, i + 1); //���Ԥ����
      j := Posex('</fishid2>', source, i + 1);
      fg := (i > 0) and (j > i) and (j - i <= 40);
      if fg then
      begin
        str := copy(source, i + 9, j - i - 9);
        if str <> '0' then
          tlist2.Add(str);
      end;
    until fg = false;
    for i := tlist2.Count - 1 downto 0 do
      for j := tlist.Count - 1 downto 0 do
      begin
        if tlist2[i] = tlist[j] then
          tlist.Delete(j);
      end;
    tlist2.Free;
  end;

end;

procedure Tform1.getfuids(const source: string; var tlist: Tstringlist);
var
  i, j: integer;
  str: string;
  fg: Boolean;
begin
  i := 0;
  repeat
    i := Posex('/home/?uid=', source, i + 1);
    j := PosEx('"', source, i + 1);
    fg := (i > 0) and (j > 0) and (j - i <= 30);
    if fg then
    begin
      str := Copy(source, i + 11, j - i - 11);
      str := Trim(str);
      if Length(str) > 2 then //-1
        tlist.Add(str);
    end;
  until fg = false;
end;

procedure TForm1.FormCreate(Sender: TObject);
const
  LASTWRITETIME = 11172212;
var
  i: integer;
  y, m, d: word;
{$IFDEF checklastmodifytime}tstime: TSystemTime; {$ENDIF}
begin
//Application.OnMessage:=ApplicationEvents1Message;
  MAXyaoqiantime := 2;
  Maxbuyanimaltime := 3;
  MAXyaoyutime := 10;
{$IFDEF private}
  reg3d := TRegistry.Create;
  reg3d.RootKey := HKEY_LOCAL_MACHINE;
  reg3d.OpenKey('software\3duo\', True);
  if reg3d.valueExists('q') then //Ǯ
    MAXyaoqiantime := reg3d.ReadInteger('q');
  if reg3d.valueExists('y') then //��
    Maxbuyanimaltime := reg3d.ReadInteger('y');
  if reg3d.valueExists('y2') then //����ҡ��
    Maxyaoyutime := reg3d.ReadInteger('y2');
{$ENDIF}
  beilv := 1;
  fpath := ExtractFilePath(ParamStr(0)) + 'account.txt';
  if FileExists(fpath) then
  begin
    ComboBox1.Items.LoadFromFile(fpath);
    if ComboBox1.Items.Count > 0 then
    begin
      ComboBox1.ItemIndex := 0;
      btn26.Visible := true;
      for i := 0 to 20 do
      begin
        idtcpwaps[i] := TIdTCPClient.Create(nil);
        idtcpwaps[i].Host := 'wap.kaixin001.com';
        idtcpwaps[i].Port := 80;
        idtcpwaps[i].ReadTimeout := 5000;
      end;
    end;
  end;


  DecodeDate(now(), y, m, d);
  i := y * 10000 + m * 100 + d;
  if i > 20091230 then
  begin
    Self.Caption := '����Ѿ�����,�������°汾'; //
    Exit;
  end;
{$IFDEF checklastmodifytime}
  tstime := getFilelastwritetime;
  i := tstime.wMonth * 1000000 + tstime.wDay * 10000 + tstime.wHour * 100 + tstime.wMinute;

  if i = LASTWRITETIME then {$ENDIF}
    for i := 0 to 50 do
    begin
      idtcps[i] := TIdTCPClient.Create(nil);
      idtcps[i].Host := 'www.kaixin001.com';
      idtcps[i].Port := 80;
      idtcps[i].ReadTimeout := 5000;
    end;

  yqtime := 0;
  yqlist := TStringList.create;
  EventSinkyes := TDHTMLEvent.Create;
  wb1.Navigate(kxhomeurl);

end;

procedure TForm1.btn02Click(Sender: TObject);
var
  i: integer;
begin
  if uidstr = '0' then //���Լҵ�
  begin
    for i := 0 to 9 do
    begin
      idstrs[i] := Get0farmseedStr(uidstr, Edit1.Text, kxfield[i]);
      idtcps[i].Disconnect;
      idtcps[i].Connect(2000);
    end;
    wb1.Navigate('about:blank');
    Application.ProcessMessages;
    wbsettext('������ֲ������......');


    for i := 0 to 9 do
    begin
      idtcps[i].write(idstrs[i]);
    end;
  end
  else
  begin //�ְ��ĵ�
    for i := 0 to 4 do
    begin
      idstrs[i] := Get0farmseedStr(uidstr, Edit1.Text, axfield[i]);
      idtcps[i].Disconnect;
      idtcps[i].Connect(2000);
    end;
    wb1.Navigate('about:blank');
    Application.ProcessMessages;
    wbsettext('������ֲ���ĵ�......');


    for i := 0 to 4 do
    begin
      idtcps[i].write(idstrs[i]);
    end;
  end;
  refresh := true;
  Timer1.Enabled := True;
end;





procedure TForm1.btn12Click(Sender: TObject);
var
  i: integer;
  str: string;
begin
  str := get1buyanimalsStr(Edit2.Text, 1); //һ�� ��2ֻ
  for i := 0 to (6 * beilv - 1) do
  begin
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
  end;
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wbsettext('���ڹ�����......<br>һ��������' + inttostr(6 * beilv) + 'ͷ'
    + '<br>���ֶ���һֻ,�������������,�ɹ��ʸ���');

  for i := 0 to (6 * beilv - 1) do
  begin
    idtcps[i].write(str);
  end;
  refresh := True;
  Timer1.Enabled := True;
end;

function Tform1.Get0farmseedStr(fruid, seedid: string; farmnum: Integer): string; //��ֲ
var
  str: string;
  seedurl: string;
begin
  seedurl := format('/house/garden/farmseed.php?verify=%s&seedid=%s&farmnum=%d', [verify, seedid, farmnum]);
  seedurl := seedurl + '&fuid=' + fruid;
  str := 'GET ' + seedurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;
  Result := str + #13#10;
end;

function Tform1.Get0harvestStr(farmnum: Integer): string; //�ջ�ֲ��
var
  str: string;
  seedurl: string;
begin
  seedurl := format('/house/garden/havest.php?verify=%s&farmnum=%d&seedid=0', [verify, farmnum]);
  seedurl := seedurl + '&fuid=' + uidstr;
  str := 'GET ' + seedurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;
  Result := str + #13#10;
end;

function Tform1.Get0buyseedStr(seedid, seednum: string): string; //������
var
  str: string;
  seedurl: string;
begin
  seedurl := format('/house/garden/buyseed.php?verify=%s&seedid=%s&num=%s', [verify, seedid, seednum]);
  str := 'GET ' + seedurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;
  Result := str + #13#10;
end;

function Tform1.Get0ploughStr(fruid, farmnum: string): string; //�ѵ�
var
  str: string;
  seedurl: string;
begin
  seedurl := format('/house/garden/plough.php?verify=%s&fuid=%s&farmnum=%s', [verify, fruid, farmnum]);
  str := 'GET ' + seedurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;
  Result := str + #13#10;
end;

function tform1.get0yaoqianstr(fruid: string): string; //ҡǮ
var
  str: string;
begin
  str := format('/house/garden/yaoqianshu.php?verify=%s&fuid=%s', [verify, fruid]);
  str := 'GET ' + str + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;
  Result := str + #13#10;
end;

function tform1.get0usetoolstr(fruid, toolid: string): string; //ʹ�õ���
var
  str: string;
begin
  str := format('/house/garden/usetools.php?farmnum=0&verify=%s&fuid=%s&seedid=%s', [verify, fruid, toolid]);
  str := 'GET ' + str + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;
  Result := str + #13#10;
end;

function tform1.get0yaoguolistr(fruid, cropid: string): string; //ҡ������
var
  content, str: string;
begin
  content := format('verify=%s&fuid=%s&cropsid=%s', [verify, fruid, cropid]);
  str := 'POST /house/garden/guolicheng/yj.php HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Content-Type: application/x-www-form-urlencoded' + #13#10;
  str := str + 'Content-Length: ' + inttostr(Length(content)) + #13#10;
//    str:=str+'Cache-Control: no-cache'+#13#10;
  str := str + 'User-Agent: Mozilla/4.0' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;
  str := str + #13#10 + content;
  Result := str + #13#10;
end;

function Tform1.get1buyanimalsStr(animalid: string; animalnum: Integer): string; //������
var
  str: string;
  aurl: string;
begin
  aurl := format('/house/ranch/buyanimals.php?verify=%s&id=%s&num=%d', [verify, animalid, animalnum]);
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get1mharvestStr(animalid: string): string; //�ջ���
var
  aurl, str: string;
begin
  aurl := format('/house/ranch/mhavest.php?verify=%s&animalsid=%s', [verify, animalid]);
  aurl := aurl + '&fuid=' + uidstr;
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get1productStr(animalid: string): string; //����
var
  str: string;
begin
  str := format('/house/ranch/product.php?verify=%s&animalsid=%s', [verify, animalid]);
  str := str + '&fuid=' + uidstr;
  str := 'GET ' + str + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get1foodStr(): string; //�Ӳ�
var
  str: string;
  aurl: string;
begin
  aurl := format('/house/ranch/food.php?verify=%s&foodnum=175&seedid=63', [verify]);
  aurl := aurl + '&fuid=' + uidstr;
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get1advanimalStr(animalid: string): string; //��������
var
  str: string;
  aurl: string;
begin
  aurl := format('/house/ranch/advancedanimals.php?verify=%s&id=%s&type=0', [verify, animalid]);
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function Tform1.get2buyfishStr(fishid: string): string; //��������
var
  str: string;
  aurl: string;
begin
  aurl := format('/fish/buyfish.php?verify=%s&id=%s', [verify, fishid]);
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get2shakefishStr(): string; //����ҡ��
var
  str: string;
  aurl: string;
begin
  aurl := format('/fish/myshake.php?verify=%s', [verify]);
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function Tform1.get2catchfishStr(fishid: string): string; //����
var
  aurl, str: string;
begin
  aurl := format('/fish/catchfish.php?verify=%s&fishid=%s', [verify, fishid]);
  aurl := aurl + '&fuid=' + uidstr;
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get2foodfishStr(fishid: string): string; //ι��
var
  aurl, str: string;
begin
  aurl := format('/fish/usetools.php?verify=%s&skey=food&odata=%s', [verify, fishid]);
  aurl := aurl + '&fuid=' + uidstr;
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get2netfishStr(fruid: string): string; //�����˼���
var
  aurl, str: string;
begin
  aurl := format('/fish/netfish.php?verify=%s&fuid=%s', [verify, fruid]);
  aurl := aurl + '&fuid=' + uidstr;
  str := 'GET ' + aurl + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  if cookiestr <> '' then
    str := str + 'Cookie: ' + cookiestr + #13#10;
  str := str + 'Host: www.kaixin001.com' + #13#10;

  Result := str + #13#10;
end;

function tform1.get2wapbuyallStr(const wapverify, wapcookie: string): string; //������
var
  str: string;
begin
  str := '/fish/buyall.php?verify=' + wapverify;
  str := 'GET ' + str + ' HTTP/1.1' + #13#10;
  str := str + 'Accept: */*' + #13#10;
  str := str + 'Connection: Keep-Alive' + #13#10;
  str := str + 'Host: wap.kaixin001.com' + #13#10;
  str := str + 'Cookie: ' + wapcookie + #13#10;
  Result := str + #13#10;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i, len: integer;
  str, msg: string;
begin
  Timer1.Enabled := False;
  msg := '';
  for i := 0 to 50 do //����״̬
  try
    idtcps[i].ReadFromStack(false);
    len := idtcps[i].InputBuffer.Size;
    if len > 1 then
    begin
      str := idtcps[i].ReadString(len);
      str := LowerCase(UTF8decode(str));
      msg := msg + getreturnmsg(str);
    end;
  finally
    idtcps[i].Disconnect;
  end;

  if refresh then //�Ƿ���Ҫˢ��
  begin
    application.processmessages;
    wb1.stop;
    wb1.navigate(lasturl);
    while wb1.ReadyState <> 4 do
      Application.ProcessMessages;
  end;

  wbaddtext(msg); //��״̬д����ҳ
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
var
  i: Integer;
  str: string;
begin
  str := ComboBox2.Text;
  i := pos(' ', str);
  Delete(str, i, 255);
  edit1.Text := str;
end;

procedure TForm1.ComboBox3Change(Sender: TObject);
var
  i: Integer;
  str: string;
begin
  str := ComboBox3.Text;
  i := pos(' ', str);
  Delete(str, i, 255);
  edit2.Text := str;
end;

procedure TForm1.btn03Click(Sender: TObject);
var
  i: integer;
begin
  if uidstr = '0' then //���Լҵ�
  begin
    for i := 0 to 9 do
    begin
      idstrs[i] := Get0harvestStr(kxfield[i]);
      idtcps[i].Disconnect;
      idtcps[i].Connect(2000);
    end;
    wb1.Navigate('about:blank');
    Application.ProcessMessages;
    wbsettext('�����ջ�������......');

    for i := 0 to 9 do
    begin
      idtcps[i].write(idstrs[i]);
    end;
  end
  else
  begin
      //͵ȡ��������
    for i := 0 to 9 do
    begin
      idstrs[i] := Get0harvestStr(kxfield[i]);
      idtcps[i].Disconnect;
      idtcps[i].Connect(2000);
    end;
    wb1.Navigate('about:blank');
    Application.ProcessMessages;
    wbsettext('����͵ȡ����......');

    for i := 0 to 9 do
    begin
      idtcps[i].write(idstrs[i]);
    end;
  end;

  refresh := true;
  Timer1.Enabled := True;
end;

procedure TForm1.btn13Click(Sender: TObject);
var
  str: string;
  tlist: TStringList;
  i, j: integer;
begin
  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := 'http://www.kaixin001.com/house/ranch/getconf.php?verify=' + verify;
  str := IdHTTP0.Get(str);
  tlist := TStringList.Create;
  getanimalsid(str, tlist);
  if tlist.Count < 1 then
  begin
    wbaddtext('<font size=4 color=blue>û�п��ջ�Ķ���<br>');
    tlist.Free;
    Exit;
  end;

  j := 0;
  for i := 0 to tlist.Count - 1 do
  begin
    idtcps[j].Disconnect;
    idtcps[j].Connect(2000);
    str := get1mharvestStr(tlist[i]);
    idtcps[j].write(str);
    inc(j);
    if j > 9 then j := 0;
  end;
  tlist.Free;
  wb1.Stop;
  wb1.Refresh;

end;

procedure TForm1.btn15Click(Sender: TObject);
var
  str: string;
  tlist: TStringList;
  i, j: integer;
begin
  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := 'http://www.kaixin001.com/house/ranch/getconf.php?verify=' + verify + '&fuid=' + uidstr;
  str := IdHTTP0.Get(str);
  tlist := TStringList.Create;
  getanimalsid(str, tlist);
  if tlist.Count < 1 then
  begin
    wbaddtext('<font size=4 color=blue>û�д����Ķ���<br>');
    tlist.Free;
    exit;
  end;
  j := 0;
  for i := 0 to tlist.Count - 1 do
  begin
    idtcps[j].Disconnect;
    idtcps[j].Connect(2000);
    str := get1productStr(tlist[i]);
    idtcps[j].write(str);
    j := j + 1;
    if j > 9 then j := 0;
  end;

  tlist.Free;
  wb1.Stop;
  wb1.Refresh;

end;

procedure TForm1.btn14Click(Sender: TObject);
var
  i, j: Integer;
  str: string;
begin
  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := 'http://www.kaixin001.com/house/ranch/getconf.php?verify=' + verify + '&fuid=' + uidstr;
  str := UTF8Decode(IdHTTP0.Get(str));
  i := Pos('���ݣ�', str);
  j := PosEx('��', str, i);
  str := copy(str, i + 6, j - i - 6);
  i := StrToInt(str);
  i := i - 150;
  if i > 0 then
  begin
    wbaddtext('<font size=4 color=blue>������������150�ã�����Ҫ���<br>');
    Exit;
  end;
  if i < 0 then //�ӵ�150��
  begin
    str := format('http://www.kaixin001.com/house/ranch/food.php?verify=%s&foodnum=%d&seedid=63', [verify, -i]);
    str := str + '&fuid=' + uidstr;
    IdHTTP0.Get(str);
  end;
  str := get1foodStr; //�ӵ�500
  for i := 0 to 1 do
  begin
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
  end;
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wbsettext('�����������......<br>����ܼӵ�500��');

  for i := 0 to 1 do
  begin
    idtcps[i].write(str);
  end;

  refresh := True;
  Timer1.Enabled := true;
end;

function GetCookiesFolder: string;
var
  pidl: pItemIDList;
  buffer: array[0..255] of char;
begin
  SHGetSpecialFolderLocation(
    application.Handle, CSIDL_COOKIES, pidl);
  SHGetPathFromIDList(pidl, buffer);
  result := strpas(buffer);
end;

function ShellDeleteFile(sFileName: string): Boolean;
var
  FOS: TSHFileOpStruct;
begin
  FillChar(FOS, SizeOf(FOS), 0); {��¼����}
  with FOS do
  begin
    wFunc := FO_DELETE; //ɾ��
    pFrom := PChar(sFileName);
    fFlags := FOF_NOCONFIRMATION;
  end;
  Result := (SHFileOperation(FOS) = 0);
end;

procedure TForm1.ComboBox1Select(Sender: TObject);
var
  o: OleVariant;
  str1, str2: string;
  i: Integer;
begin
  wb1.stop;
//ɾ��cookie
  InternetSetOption(nil, INTERNET_OPTION_END_BROWSER_SESSION, nil, 0);
  str1 := GetCookiesFolder;
  ShellDeleteFile(str1 + '\*kaixin001*' + #0); //���Ϻܶ��������û�м�����#0����xp�¾����Իᱨ��
//ɾ��cookie����
  wb1.Navigate('http://www.kaixin001.com/login/');
  while wb1.ReadyState <> 4 do
    Application.ProcessMessages;
  str1 := ComboBox1.Text;
  i := Pos(' ', str1);
  str2 := trim(Copy(str1, i + 1, MAXCHAR));
  Delete(str1, i, MAXCHAR);
  o := wb1.OleObject.document.getelementsbyname('email').item(0);
  o.value := str1;
  o := wb1.OleObject.document.getelementsbyname('password').item(0);
  o.value := str2;
  o := wb1.OleObject.document.getelementbyid('btn_dl');
  o.click;
end;

procedure TForm1.btn01Click(Sender: TObject);
begin
  wb1.Stop;
  wb1.Navigate(kxgdurl);
end;

procedure TForm1.btn11Click(Sender: TObject);
begin
  wb1.Stop;
  wb1.Navigate(kxranchurl);
end;

procedure TForm1.btn04Click(Sender: TObject);
var
  i: integer;
  str: string;
begin
  str := 'Ҫ����30��������?'#13#10'���ӱ��:' + combobox2.Text;
  i := MessageBox(Self.Handle, Pchar(str), '��ȷ��', MB_ICONQUESTION or MB_YESNO);
  if i <> 6 then exit;

  str := Get0buyseedStr(Edit1.Text, '2');
  for i := 0 to 14 do
  begin
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
  end;
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wbsettext('���ڹ�������......');
  for i := 0 to 14 do
  begin
    idtcps[i].write(str);
  end;

  refresh := true;
  timer1.Enabled := true;

end;

procedure TForm1.ComboBox1DblClick(Sender: TObject);
var
  tlist: tstringlist;
begin
  if not FileExists(fpath) then
  begin
    tlist := Tstringlist.Create;
    tlist.Add('xxxx����@xxx.com ����xxx');
    tlist.Add('yyyy����@xxx.com ����yyy');
    tlist.SaveToFile(fpath);
    tlist.Free;
  end;
  ShellExecute(handle, 'open', pchar(fpath), nil, nil, SW_NORMAL);
end;

procedure TForm1.btn21Click(Sender: TObject);
begin
  wb1.Stop;
  wb1.Navigate(kxfishurl);
end;

procedure TForm1.btn22Click(Sender: TObject);
begin
  btn22.Enabled := false;
  buyfishth.Create(false);
    {
    str:=get2buyfishStr(Edit3.Text);//һ�� ��1ֻ
    for i:=0 to 9 do
    begin
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
    end;
    wb1.Navigate('about:blank');
    Application.ProcessMessages;
    wbsettext('���ڹ�������......<br>һ��������10β');

    for i:=0 to 9 do
    begin
        idtcps[i].write(str);
    end;
    refresh:=true;
    Timer1.Enabled:=True; }
end;

procedure TForm1.ComboBox4Change(Sender: TObject);
var
  i: Integer;
  str: string;
begin
  str := ComboBox4.Text;
  i := pos(' ', str);
  Delete(str, i, 255);
  edit3.Text := str;
end;


procedure TForm1.btn24Click(Sender: TObject);
var
  i: integer;
  str: string;
begin
{$IFDEF private}
  if maxyaoyutime < 25 then
  begin
    IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
    str := IdHTTP0.Get('http://www.kaixin001.com/group/group.php?gid=845474');
    if Pos('topiclist', str) > 0 then
    begin
      maxyaoyutime := 25;
      reg3d.WriteInteger('y2', Maxyaoyutime);
      Maxbuyanimaltime := 30;
      reg3d.WriteInteger('y', Maxbuyanimaltime);
      MAXyaoqiantime := 25;
      reg3d.WriteInteger('q', MAXyaoqiantime);
    end;
  end;
{$ENDIF}
  str := get2shakefishStr();
  for i := 0 to Maxyaoyutime * beilv - 1 do
  begin
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
  end;
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wbsettext('����ҡ��......<br>һ����ҡ2-3������,����ҡ' + inttostr(Maxyaoyutime * beilv) +
    '��');

  for i := 0 to Maxyaoyutime * beilv - 1 do
  begin
    idtcps[i].write(str);
  end;
  refresh := true;
  Timer1.Enabled := True;
end;
  {
procedure TForm1.btn05Click(Sender: TObject);
var
  fg:Boolean;
  str,str2:string;
  i,j,m,n,fcount:Integer;
  tlist:Tstringlist;
  frax:array[0..110] of frfield; //���100���
begin
(*�����к���,�����к��Ѱ��ĵ�״̬.
�ܿ��ѵĿѵ�,���ֵķŽ�����
���ʣ���<=5,ֱ����
�������5
��3�����Ӽ�2������
�ڵ���
*)
str:='��ֲǰ�빺���㹻����������!'#13#10'��ǰ40λ���ѿ��еİ��ĵ�����ֲ  '#13#10'���ӱ��:'+combobox2.Text;
i:=MessageBox(Self.Handle,Pchar(str),'��ȷ��',MB_ICONQUESTION or MB_YESNO);
if i<>6 then exit;
wb1.Navigate('about:blank');
Application.ProcessMessages;
wbsettext('���ڶ�ȡǰ40λ����......');

IdHTTP0.Request.CustomHeaders.Text:='Cookie: '+cookiestr;
str:=IdHTTP0.Get('http://www.kaixin001.com/friend/index.php');
Tlist:=TStringList.Create;
getfuids(str,tlist);
for i:=tlist.Count-1 downto 1 do //ȥ���ظ�����
    for j:=i-1 downto 0 do
      if tlist[j]=tlist[i] then
         begin
           tlist.Delete(i);
           Break;
         end;

fcount:=0;
for i:=0 to tlist.Count-1 do //�����ѻ�԰״̬
begin
  wbsettext('���ڶ�ȡǰ40λ���ѻ�԰״̬......'+inttostr(i+1)+'/'+inttostr(tlist.Count));

  str:= 'http://www.kaixin001.com/house/garden/getconf.php?verify='+verify+'&fuid='+tlist[i];
  fg:=False;
  while fg=false do
  try
    Application.ProcessMessages;
    str:=IdHTTP0.Get(str);
    fg:=True;
  except
    fg:=False;
  end;
  for j:=0 to 4 do
    begin
      str2:='<farmnum>'+inttostr(axfield[j])+'</farmnum>';
      m:=pos(str2,str);
      n:=PosEx('<status>',str,m);
      str2:=copy(str,n+8,1);
      if str2='1' then  //status=1 �Ѿ�����
        begin
         n:=PosEx('<fuid>',str,m);
         str2:=copy(str,n+6,1);
         if str2='0' then//fuid=0 �޺�����
            begin
              frax[fcount].uid:=tlist[i];
              frax[fcount].farmid:=axfield[j];
              Inc(fcount);
            end;
        end;
    end;
  if fcount>100 then //���100���
    Break;
end;
tlist.Free;
wbsettext('����'+inttostr(fcount)+'����ŵİ��ĵ�');
//���ݵ�����

//����ݹ�����,��������


i:=0;
while i<fcount-1 do
begin
  idstrs[0]:=Get0farmseedStr(frax[i].uid,Edit1.Text,frax[i].farmid);
  if i<fcount-1 then i:=i+1;
  idstrs[1]:=Get0farmseedStr(frax[i].uid,Edit1.Text,frax[i].farmid);
  if i<fcount-1 then i:=i+1;
  idstrs[2]:=Get0farmseedStr(frax[i].uid,Edit1.Text,frax[i].farmid);
  if i<fcount-1 then i:=i+1;
  idstrs[3]:=Get0farmseedStr(frax[i].uid,Edit1.Text,frax[i].farmid);
  if i<fcount-1 then i:=i+1;
  idstrs[4]:=Get0farmseedStr(frax[i].uid,Edit1.Text,frax[i].farmid);

  wbsettext('������ֲ���ĵ�......'+inttostr(i+1)+'/'+inttostr(fcount));

  fg:=false;
  while fg=False do
  try
    Application.ProcessMessages;
    for j:=0 to 4 do
    begin
      idtcps[j].Disconnect;
      idtcps[j].Connect(2000);
    end;
    fg:=true;
  except
    fg:=False;
  end;
  for j:=0 to 4 do   //��ֲ
  begin
    idtcps[j].Write(idstrs[j]);
  end;
  for j:=0 to 20 do
  begin
    Application.ProcessMessages;
    Sleep(100);
  end;

  if i<fcount-1 then //�ѵ�
     begin
       str:=Format('http://www.kaixin001.com/house/garden/plough.php?verify=%s&fuid=%s&farmnum=%d',[verify,frax[i].uid,frax[i].farmid]);
       fg:=False;
       while fg=false do
       try
          Application.ProcessMessages;
          IdHTTP0.Get(str);
          fg:=True;
       except
          fg:=False;
       end;
     end;
end;

wb1.Stop;
wb1.Navigate(lasturl);
end;
      }
{
procedure tform1.showhint(ahint:string);
var
  vrect:TRect;
  vpoint:TPoint;
begin
  htwindow:=THintWindow.Create(self);
htwindow.Color:=Application.HintColor;
      vRect:=HtWindow.CalcHintRect(Screen.Width,AHint,nil);
      vPoint.X := self.Left+6;
      vPoint.Y := self.Top+pagecontrol1.Height+24;
      Inc(vRect.Left,vPoint.X);
      Inc(vRect.Right,vPoint.X);
      Inc(vRect.Top,vPoint.Y);
      Inc(vRect.Bottom,vPoint.Y);
      HtWindow.ActivateHint(vRect,AHint);
//      Timer2.Enabled:=true;
end;}

function tform1.getreturnmsg(amsgstr: string): string;
var
  i, j: Integer;
  str1: string;
  fg: Boolean;
begin
  Result := '';
  if Length(amsgstr) < 10 then // û���յ���Ϣ���˳�
    Exit;
  if Pos('<ret>fail', amsgstr) > 0 then
    str1 := '<font color=red>Fail</font>  ';
  if Pos('<ret>succ', amsgstr) > 0 then
    str1 := '<font color=green>Success</font>  ';

  i := Pos('<msg>', amsgstr);
  j := Pos('</msg>', amsgstr);
  if (i > 0) and (j > 0) then
    str1 := str1 + Copy(amsgstr, i + 5, j - i - 5);

  i := Pos('<reason>', amsgstr);
  j := Pos('</reason>', amsgstr);
  if (i > 0) and (j > 0) then
    str1 := str1 + Copy(amsgstr, i + 8, j - i - 8);

  i := Pos('<tip>', amsgstr);
  j := Pos('</tip>', amsgstr);
  if (i > 0) and (j > 0) then
    str1 := str1 + Copy(amsgstr, i + 5, j - i - 5);

  i := 0;
  repeat
    i := PosEx('&lt;', str1, i + 1);
    j := PosEx('&gt;', str1, i);
    fg := (i > 0) and (j > 0);
    if fg then
    begin
      Delete(str1, i, j - i + 4);
      Insert(' ', str1, i);
    end;
  until fg = false;

  Result := str1 + '<br>';
end;

procedure tform1.wbsettext(St: string);
var
  o: OleVariant;
//  Stream: TStringStream;
begin
  st := '<center><font size=4>' + st {+'</font><font color=red><br><br>http://bbs.112ba.com'};
  while wb1.ReadyState <> 4 do
    Application.ProcessMessages;

  o := wb1.OleObject.document.body;
  if VarIsNull(o) or VarIsEmpty(o) or VarIsClear(o)
    then exit;
  o.innerhtml := st;
  Application.ProcessMessages;
end;

procedure tform1.wbaddtext(st: string);
var
  o: OleVariant;
begin
  wb1.Stop;
  o := wb1.OleObject.document.getelementbyid('flashver');
  //o:=wb1.OleObject.document.getelementsbyname('mainform').item(0);
  if VarIsNull(o) or VarIsEmpty(o) or VarIsClear(o) then
    o := wb1.OleObject.document.getelementbyid('verlimit');
  if VarIsNull(o) or VarIsEmpty(o) or VarIsClear(o) then
    exit;
  if Length(st) > 10 then
  begin
    o.style.display := 'block';
    o.style.textalign := 'left';
    o.style.color := 'black';
    o.innerhtml := st;
  end;
  Application.ProcessMessages;
end;

procedure TForm1.btn25Click(Sender: TObject);
var
  str: string;
  tlist: TStringList;
  i, j: integer;
  fg: boolean;
begin
  i := MessageBox(Handle, '�㿨�Ǽ���,��ι���Ѿ���̫����,Ҫ������?', '����', MB_YESNO or MB_ICONQUESTION);
  if i <> 6 then Exit;
//�ȼ���ж�������
  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := 'http://www.kaixin001.com/fish/getconf.php?verify=' + verify;
  str := IdHTTP0.Get(str);
  tlist := TStringList.Create;
  getfishid(str, tlist);
  if tlist.Count < 1 then //������
  begin
    wbaddtext('<font size=4 color=blue>����û����,����Ҫιʳ<br>');
    tlist.Free;
    exit;
  end;

//����ж������㿨,��������
  str := 'http://www.kaixin001.com/fish/mytools.php?verify=' + verify;
  str := IdHTTP0.Get(str);
  i := Pos('<tid>3</tid>', str) - 20;
  if i > 0 then
  begin
    i := PosEx('<num>', str, i);
    j := PosEx('</num>', str, i);
    str := Copy(str, i + 5, j - i - 5);
    i := StrToInt(str);
  end
  else
    i := 0;

  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  if i < tlist.Count then
  begin
   //����������
    j := tlist.Count - i;
    wbsettext('��Ҫ����' + inttostr(j) + '����ʳ��<br>���ڹ���......');
    str := 'http://www.kaixin001.com/fish/buytools.php?fuid=0&id=3&verify=' + verify;
    for i := 0 to ((j - 1) div 4) do
    begin
      fg := false;
      while fg = false do
      try
        idHTTP0.Get(str);
        fg := true;
      except
        fg := false;
      end;
    end;
  end;

//���ι��
  for i := 0 to tlist.Count - 1 do
  begin
    idstrs[i] := get2foodfishStr(tlist[i]);
    fg := false;
    while fg = false do
    try
      idtcps[i].Disconnect;
      idtcps[i].Connect(2000);
      fg := true;
    except
      fg := false;
    end;
  end;
  wbsettext('����ι��......');
  for i := 0 to tlist.Count - 1 do
    idtcps[i].Write(idstrs[i]);

  refresh := true;
  Timer1.Enabled := true;
end;

procedure TForm1.btn06Click(Sender: TObject);
var
  i, j: integer;
  str, restr: string;
  fg: Boolean;
  o: OleVariant;
begin
{$IFDEF private}
  if MAXyaoqiantime < 25 then
  begin
    IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
    str := IdHTTP0.Get('http://www.kaixin001.com/group/group.php?gid=845474');
    if Pos('topiclist', str) > 0 then
    begin
      maxyaoyutime := 25;
      reg3d.WriteInteger('y2', Maxyaoyutime);
      Maxbuyanimaltime := 30;
      reg3d.WriteInteger('y', Maxbuyanimaltime);
      MAXyaoqiantime := 25;
      reg3d.WriteInteger('q', MAXyaoqiantime);
    end;
  end;
{$ENDIF}

  if (btn06.Caption = '��ʼҡǮ') and (Sender = btn06) then
  begin
    btn06.Enabled := False;
    yaoqianstart(nil);
    btn06.Enabled := true;
    Exit;
  end;

  wb1.Navigate('about:blank');
  Application.ProcessMessages;

  yqlist.clear;
  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := IdHTTP0.Get('http://www.kaixin001.com/friend/?start=0');
  getfuids(str, yqlist);
  str := UTF8Decode(str);
  i := Pos('����', str);
  j := PosEx('λ����', str, i + 1);
  if (i > 0) and (j > 0) and (j - i <= 10) then
  begin
    str := Trim(Copy(str, i + 4, j - i - 4));
    j := strtoint(str);
    j := (j - 1) div 40;
  end
  else
    j := -1;

  for i := 1 to j do
  begin
    wbsettext('���ڶ�ȡ����......<br>' + inttostr(i + 1) + '/' + inttostr(j + 1) + 'ҳ');
    fg := false;
    while fg = False do
    try
      Application.ProcessMessages;
      str := IdHTTP0.Get('http://www.kaixin001.com/friend/?start=' + inttostr(i * 40));
      getfuids(str, yqlist);
      fg := true;
    except
      fg := false;
    end
  end;
  for i := yqlist.Count - 1 downto 1 do //ȥ���ظ�����
    for j := i - 1 downto 0 do
    begin
         {  if yqlist[i]='37451806' then  //�Ǻ��Ѿʹ���������
             MAXyaoqiantime:=5;  }
      if yqlist[j] = yqlist[i] then
      begin
        yqlist.Delete(i);
        Break;
      end;
    end;

  yqlist.Add('0'); //�Լ���
  j := yqlist.Count;
  for i := yqlist.Count - 1 downto 0 do //�����ѵ�״̬
  begin
    wbsettext('����Ƶ��ɨ��,�������ױ����Ʒ���<br>���ڶ�ȡ���ѵĻ�԰״̬......' + inttostr(j - i) + '/' + inttostr(j));

    str := 'http://www.kaixin001.com/house/garden/getconf.php?verify=' + verify + '&fuid=' + yqlist[i];
    fg := False;
    while fg = false do
    try
      Application.ProcessMessages;
      str := IdHTTP0.Get(str);
      fg := True;
    except
      fg := False;
    end;

    str := UTF8Decode(str);
    if Sender = btn06 then
      restr := '�����ҡǮ'
    else
      restr := '<seedid>102';
    if pos(restr, str) = 0 then
      yqlist.Delete(i);

  end;
    //��ʱ
  for i := 0 to 4 do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;
  if Sender = btn06 then
  begin
    str := format('����%d�ÿ�ҡ��ҡǮ��,Ҫ��ʼҡ��?', [yqlist.Count]);
  end
  else
  begin
    str := FormatDateTime('hh:nn:ss', yqtime);
    str := format('����%d��������ֲ��ҡǮ��,ϵͳ����%s�Զ�ҡ��<br>��"ȷ��"��������ҡ,��"����"�ɽ�����������<br>����ͣ���ڴ�ҳ��', [yqlist.Count, str]);
  end;
  restr := Format(wb1.Hint, [str]);
  wb1.LoadFromString(restr);
  while wb1.ReadyState <> 4 do
    Application.ProcessMessages;
  for i := 0 to 4 do
  begin
    Sleep(100);
    Application.ProcessMessages;
  end;
    //hook dhtml
  o := wb1.OleObject.document.all.item('btnyes', 0);
  o.onclick := EventSinkyes.HookEventHandler(yaoqianstart);
  btn06.Caption := '��ʼҡǮ';

end;
(*
procedure TForm1.ApplicationEvents1Message(var Msg: TMsg;var Handled: Boolean);
var
   iOIPAO: IOleInPlaceActiveObject;
   Dispatch: IDispatch;
begin
   { exit if we don��t get back a webbrowser object }
   if (Wb1 = nil) then
   begin
     Handled := System.False;
     Exit;
   end;

   Handled := (IsDialogMessage(wb1.Handle, Msg) = System.True);

   if (Handled) and (not wb1.Busy) then
   begin
     if FOleInPlaceActiveObject = nil then
     begin
       Dispatch := wb1.Application;
       if Dispatch <> nil then
       begin
         Dispatch.QueryInterface(IOleInPlaceActiveObject, iOIPAO);
         if iOIPAO <> nil then
           FOleInPlaceActiveObject := iOIPAO;
       end;
     end;
     FOleInPlaceActiveObject.TranslateAccelerator(Msg);
   end;
end;   *)


procedure TForm1.StaticText1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbRight then
  begin
    beilv := 2;
    ComboBox1.Width := 80;
    Exit;
  end;
  if button = mbleft then
  begin
    beilv := 1;
    ComboBox1.Width := 151;
    Exit;
  end;
end;

procedure buyfishth.Execute;
var
  url, str: string;
  i: integer;
  fg: Boolean;
begin
  Self.FreeOnTerminate := True;
  Form1.Label1.Caption := '��������...';
  Application.ProcessMessages;
  i := 0;
  fg := false;
  Form1.IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  url := format('http://www.kaixin001.com/fish/buyfish.php?verify=%s&id=%s', [verify, Form1.Edit3.Text]);
  while fg = False do
  try
    Sleep(1000);
    str := LowerCase(UTF8Decode(form1.IdHTTP0.Get(url)));
    if Pos('succ', str) > 0 then
    begin
      i := i + 1;
      Form1.Label1.Caption := Format('�ѹ���%d����', [i]);
      Application.ProcessMessages;
    end
    else
      fg := True;
  except
    fg := False;
  end;
  str := form1.getreturnmsg(str);
  if (Pos('���', str) > 0) and (i > 0) then
    Form1.Label1.Caption := Format('����%d����,����������鿴', [i])
  else
  begin
    i := Length(str);
    if i > 5 then
      delete(str, i - 3, 4);
    i := Pos('  ', str);
    Delete(str, 1, i + 1);
    form1.Label1.Caption := str;
  end;
  Form1.btn22.Enabled := true;
  Sleep(15000);
  form1.Label1.Caption := '';
end;








procedure TForm1.wb1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  htmlcode, str: string;
  i: integer;
begin
  if pdisp <> wb1.Application then exit;
  if pos('kaixin001', url) = 0 then exit;
  if (Pos('/home/', url) > 0) or (Pos('%2Fhome%2F', url) > 0) then exit;
  if Pos('login', url) > 0 then
  begin
    yqlist.Clear;
    yqtime := 0;
    btn07.Visible := true;
    btn06.Caption := '��ҡ����ҡǮ��';
  end;
  btn22.enabled := false;
  btn23.Enabled := False;
  btn24.Enabled := false;
  btn25.Enabled := false;
  btn12.enabled := false;
  btn13.enabled := false;
  btn14.enabled := false;
  btn15.enabled := false;
  btn16.enabled := false;
  btn02.enabled := false;
  btn03.enabled := false;
  btn04.enabled := false;
  btn05.Enabled := False;
  btn06.Enabled := False;
  btn07.Enabled := False;
  btn08.Enabled := False;

  lasturl := LowerCase(wb1.LocationURL);
  Self.Caption := lasturl;
  lasturl := AnsiReplaceStr(lasturl, '##', '#');
  lasturl := AnsiReplaceStr(lasturl, '.php#', '.php?fuid=');

  uidstr := '0';
  i := Pos('fuid=', lasturl);
  if i > 0 then
    uidstr := trim(copy(lasturl, i + 5, 20));

  cookiestr := wb1.OleObject.document.cookie;

  if pos('/garden/', lowercase(url)) > 0 then
  begin
    PageControl1.ActivePageIndex := 0;
    htmlcode := wb1.OleObject.document.documentelement.innerHTML;
//  htmlcode:=lowercase(htmlcode);
    i := pos('g_verify', htmlcode);
    delete(htmlcode, 1, i);
    i := pos('"', htmlcode);
    delete(htmlcode, 1, i);
    i := pos('"', htmlcode);
    verify := copy(htmlcode, 1, i - 1);
    i := Pos('_', verify);
    str := Copy(verify, 1, i - 1);
    if str = uidstr then
      uidstr := '0';
    if (uidstr = '0') then
    begin
      btn02.Caption := '����������';
      btn03.Caption := '�ջ�������';
    end
    else
    begin
      btn02.Caption := '���ְ��ĵ�';
      btn03.Caption := '͵ȡ��������';
    end;
    btn02.Enabled := true;
    btn03.Enabled := true;
    btn04.Enabled := true;
    btn05.Enabled := true;
    btn06.Enabled := true;
    btn07.Enabled := True;
    btn08.Enabled := True;
  end
  else
    if pos('/ranch/', lowercase(url)) > 0 then
    begin
      PageControl1.ActivePageIndex := 1;
      htmlcode := wb1.OleObject.document.documentelement.innerHTML;
//  htmlcode:=lowercase(htmlcode);
      i := pos('g_verify', htmlcode);
      delete(htmlcode, 1, i);
      i := pos('"', htmlcode);
      delete(htmlcode, 1, i);
      i := pos('"', htmlcode);
      verify := copy(htmlcode, 1, i - 1);
      i := Pos('_', verify);
      str := Copy(verify, 1, i - 1);
      if str = uidstr then
        uidstr := '0';
      btn12.Enabled := true;
      btn13.Enabled := true;
      btn14.Enabled := true;
      btn15.Enabled := true;
      btn16.Enabled := True;
    end
    else
      if pos('fish/', lowercase(url)) > 0 then
      begin
        PageControl1.ActivePageIndex := 2;
        htmlcode := wb1.OleObject.document.documentelement.innerHTML;
    //  htmlcode:=lowercase(htmlcode);
        i := pos('g_verify', htmlcode);
        delete(htmlcode, 1, i);
        i := pos('"', htmlcode);
        delete(htmlcode, 1, i);
        i := pos('"', htmlcode);
        verify := copy(htmlcode, 1, i - 1);
        i := Pos('_', verify);
        str := Copy(verify, 1, i - 1);
        if str = uidstr then
          uidstr := '0';
        btn22.Enabled := true;
        btn23.Enabled := true;
        btn24.Enabled := true;
        btn25.Enabled := true;

      end;
end;

procedure TForm1.btn26Click(Sender: TObject);
var
  url, str1, str2, email: string;
  i, j: Integer;
  idhttpwap: TIdHTTP;
begin
  idhttpwap := TIdHTTP.Create(nil);
  idhttpwap.Request.UserAgent := 'Mozilla/4.0';
  idhttpwap.ReadTimeout := 10000;
  idhttpwap.AllowCookies := true;
  idhttpwap.HandleRedirects := true;
  idhttpwap.CookieManager := idckmgr1;
  idckmgr1.CookieCollection.Clear;

  str1 := ComboBox1.Text;
  i := Pos(' ', str1);
  str2 := trim(Copy(str1, i + 1, MAXCHAR)); //����
  Delete(str1, i, MAXCHAR); //email
  email := str1;
  url := 'http://wap.kaixin001.com/home/?email=' + str1 + '&password=' + str2 + '&login=+%E7%99%BB+%E5%BD%95+';
  str1 := IdHTTPwap.Get(url);
  idhttpwap.Free;

  i := Pos('verify=', str1);
  j := PosEx('"', str1, i + 1);
  if (i > 0) and (j > i) and (j - i <= 100) then
    str2 := Copy(str1, i + 7, j - i - 7); //verify
  str1 := '';
  for i := 0 to idckmgr1.CookieCollection.Count - 1 do
    str1 := str1 + idckmgr1.CookieCollection.Items[i].ClientCookie + '; '; //cookie
  url := get2wapbuyallStr(str2, str1);
  for i := 0 to 2 * beilv - 1 do
  begin
    idtcpwaps[i].Disconnect;
    idtcpwaps[i].Connect(3000);
  end;
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wbsettext('���ڸ��˺�' + email + '<br>����������������......');
  for i := 0 to 2 * beilv - 1 do
    idtcpwaps[i].Write(url);
  for i := 0 to 19 do
  begin
    Application.ProcessMessages;
    Sleep(100);
  end;
  (*str1:='';
  for i:=0 to 5*beilv-1 do
  begin
    idtcpwaps[i].ReadFromStack(false);
    j:=idtcpwaps[i].InputBuffer.size;
    str2:=idtcpwaps[i].ReadString(j);
    str1:=str1+str2;
     {
//    str2:=UTF8Decode(str2);
    m:=Pos('tips1">',str2);
    n:=PosEx('<a',str2,m+1);
    if (m>0) and (n>m) then
       str1:=str1+copy(str2,m+7,n-m-7);  }
  end;
  IdHTTPWAP.Request.CustomHeaders.Text:=str1;
  IdHTTPWAP.Request.CustomHeaders.SaveToFile('r:\33.htm');
              *)
  wb1.stop;
  wb1.Navigate(kxfishurl);
end;

procedure tform1.yaoqianstart(Sender: TObject);
var
  restr, str: string;
  fg: boolean;
  i, j, k: Integer;
begin
  if yqlist.Count < 1 then
  begin
    wb1.stop;
    wb1.Navigate(lasturl);
    exit;
  end;
  str := LowerCase(wb1.LocationURL);
  if pos('about:blank', str) = 0 then
    wb1.navigate('about:blank');
  Application.ProcessMessages;

  restr := '';
  k := 0;
  for i := 0 to yqlist.Count - 1 do //��ҡ
  begin
    str := get0yaoqianstr(yqlist[i]);
    wbsettext('����ҡǮ......' + inttostr(i + 1) + '/' + inttostr(yqlist.Count));
    fg := false;
    while fg = false do
    try
      for j := 0 to MAXyaoqiantime * beilv - 1 do
      begin
        Application.ProcessMessages;
        idtcps[j].Disconnect;
        idtcps[j].Connect(2000);
      end;
      fg := true;
    except
      fg := false;
    end;

    for j := 0 to MAXyaoqiantime * beilv - 1 do
    begin
      idtcps[j].write(str);
    end;
    Application.ProcessMessages;
    fg := false;
    for j := 0 to MAXyaoqiantime * beilv - 1 do
    begin
      try
        idtcps[j].ReadFromStack(false);
        str := idtcps[j].ReadString(idtcps[j].InputBuffer.Size);
        str := UTF8Decode(str);
        str := getreturnmsg(str);
      except
        str := '';
      end;
      if (Length(str) > 5) {and (Pos('>Succ',str)>0) } then //�ɹ�����
      begin
        fg := true;
        if k mod 2 = 0 then
          restr := restr + '��' + str
        else
          restr := restr + '��' + str;
      end;
    end;
    if fg then Inc(k);
    Application.ProcessMessages;
  end;
  //  yqlist.Clear;
  wb1.OleObject.document.body.innerhtml := '<INPUT onclick=history.back() type=button value=" �� �� ">'
    + '<br><br><font size=2>' + restr;

end;


procedure tform1.catchfishstart(Sender: TObject);
var
  str: string;
  tlist: TStringList;
  i, j, m, n: integer;
  keeppro, keepadv: BOOL;
begin
  keeppro := wb1.OleObject.document.getelementbyid('keeppro').checked;
  keepadv := wb1.OleObject.document.getelementbyid('keepadv').checked;

  wbsettext('���ڶ�ȡ��������......');
  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := 'http://www.kaixin001.com/fish/getconf.php?verify=' + verify + '&fuid=' + uidstr;
  str := IdHTTP0.Get(str);
  tlist := TStringList.Create;
  getfishid(str, tlist);
  if tlist.Count < 1 then
  begin
    wbsettext('û�п��ջ������');
    refresh := True;
    Timer1.Enabled := true;
    tlist.Free;
    exit;
  end;
  str := UTF8Decode(str);

  if keeppro then
  begin
    for i := tlist.Count - 1 downto 0 do
    begin
      j := Pos(tlist[i], str);
      m := PosEx('���ñ���', str, j);
      n := PosEx('</item>', str, j);
      if (j > 0) and (m > j) and (m < n) then
        tlist.Delete(i);
    end;
  end;


  if keepadv then
  begin
    for i := tlist.Count - 1 downto 0 do
    begin
      j := Pos(tlist[i], str);
      n := PosEx('</item>', str, j);
      m := PosEx('bangjing', str, j);
      if (j > 0) and (m > j) and (m < n) then
        tlist.Delete(i);
      m := PosEx('jinglongyu', str, j);
      if (j > 0) and (m > j) and (m < n) then
        tlist.Delete(i);
      m := PosEx('�����', str, j);
      if (j > 0) and (m > j) and (m < n) then
        tlist.Delete(i);
    end;
  end;

  j := tlist.Count - 1;
  if j > 15 * beilv - 1 then j := 15 * beilv - 1;
  for i := 0 to j do
  begin
    Application.ProcessMessages;
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
    idstrs[i] := get2catchfishStr(tlist[i]);
  end;

  wbsettext('��������......<br>����������<br>���ձ��˵���<br>һ��������' + inttostr(15 * beilv) + '��');
  for i := 0 to j do
  begin
    idtcps[i].write(idstrs[i]);
  end;
  tlist.Free;
  refresh := true;
  Timer1.Enabled := True;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
  t1: tdatetime;
  i: int64;
begin
  if yqtime = 0 then
  begin
    t1 := 40108 + 175 / 86400; // StrToDateTime('2009-10-22 00:02:55');
    i := trunc((now - t1) * 86400);
    i := 1000 - (i mod 1000);
    t1 := now + i / 86400;
    Label2.Caption := FormatDateTime('����ʱ�� hh:nn:ss', t1);
  end
  else
  begin
    t1 := yqtime - now;
    if t1 < 1 then
      label2.Caption := FormatDateTime('���Զ�ҡ�� hh:nn:ss', t1)
    else
      label2.Caption := FormatDateTime('���Զ�ҡ�� d��hhСʱnn��ss��', t1);

    t1 := Now();
    if (t1 - yqtime >= 0) and (t1 - yqtime <= 2 / 86400) then //����ʱ�����
    begin
      yqtime := 0;
      if (Pos(':blank', wb1.LocationURL) = 0) or (Pos('/garden/', wb1.LocationURL) = 0) then
      begin
        wb1.Navigate(kxgdurl);
        while wb1.ReadyState <> 4 do
          Application.ProcessMessages;
      end;
      if btn06.Enabled then
        yaoqianstart(nil);
    end;

  end;
end;

procedure TForm1.btn23Click(Sender: TObject);
var
  o: OleVariant;
  i: Integer;
begin
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wb1.LoadFromString(btn23.Hint);
  while wb1.ReadyState <> 4 do
    Application.ProcessMessages;
  for i := 0 to 4 do
  begin
    Application.ProcessMessages;
    Sleep(100);
  end;
  o := wb1.OleObject.document.getelementbyid('catchfish');
  o.onclick := EventSinkyes.HookEventHandler(catchfishstart);
end;

procedure TForm1.btn07Click(Sender: TObject);
var
  t0, t1, t2: tdatetime;
  i: int64;
  fg: Boolean;
begin
  try
    wbsettext('����У׼����ʱ��......');
    fg := IdSNTP1.SyncTime;
  except
    fg := False;
  end;

  if fg = False then
  begin
    i := MessageBox(Handle, 'У׼����ʱ��ʧ��,�������Ժ�����  '#13#10'ȷ��Ҫ������', 'ע��', MB_yesno or MB_ICONWARNING);
    if i <> 6 then
    begin
      wb1.GoBack;
      exit;
    end;
  end;
  t0 := 40108 + 175 / 86400; //StrToDateTime('2009-10-22 00:03:00');

  t2 := trunc(now()) + 1; //����12�����ʱ��
  i := trunc((t2 - t0) * 86400);
  i := 1000 - (i mod 1000);
  t2 := t2 + i / 86400; //����0�����ʱ��

  t1 := trunc(now()); //����0�����ʱ��
  i := trunc((t1 - t0) * 86400);
  i := 1000 - (i mod 1000);
  t1 := t1 + i / 86400; //����0�����ʱ��
  if Now() >= t1 then
  begin
    Label2.Caption := FormatDateTime('���յ�һ����ʱ�� hh:nn:ss', t2);
    yqtime := t2;
  end
  else
  begin
    Label2.Caption := FormatDateTime('���յ�һ����ʱ�� hh:nn:ss', t1);
    yqtime := t1;
  end;

  Timer2.Enabled := False;
  try
    btn06Click(nil);
    Application.ProcessMessages;
  finally
    Timer2.Enabled := True;
  end;

  if yqlist.Count > 0 then
  begin
    btn07.Visible := false;
  end;

end;

procedure TForm1.btn16Click(Sender: TObject);
var
  i: integer;
  str: string;
begin
{$IFDEF private}
  if Maxbuyanimaltime < 15 then
  begin
    IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
    str := IdHTTP0.Get('http://www.kaixin001.com/group/group.php?gid=845474');
    if Pos('topiclist', str) > 0 then
    begin
      maxyaoyutime := 25;
      reg3d.WriteInteger('y2', Maxyaoyutime);
      Maxbuyanimaltime := 30;
      reg3d.WriteInteger('y', Maxbuyanimaltime);
      MAXyaoqiantime := 25;
      reg3d.WriteInteger('q', MAXyaoqiantime);
    end;
  end;
{$ENDIF}

  str := get1advanimalStr(Edit2.Text);
  for i := 0 to Maxbuyanimaltime do
  begin
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
  end;
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wbsettext('���ڼ�����������......<br>������:' + combobox3.text {+'<br>һ�����ɼ�������'+inttostr(15*beilv)+'ͷ'}
    + '<br>');

  for i := 0 to Maxbuyanimaltime do
  begin
    idtcps[i].write(str);
  end;
  refresh := True;
  Timer1.Enabled := True;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TerminateProcess(GetCurrentProcess, 0);
end;

procedure TForm1.btn08Click(Sender: TObject);
var
  str: string;
  fg: boolean;
  i: Integer;
begin
{$IFDEF private}
  if MAXyaoqiantime < 25 then
  begin
    IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
    str := IdHTTP0.Get('http://www.kaixin001.com/group/group.php?gid=845474');
    if Pos('topiclist', str) > 0 then
    begin
      maxyaoyutime := 25;
      reg3d.WriteInteger('y2', Maxyaoyutime);
      Maxbuyanimaltime := 30;
      reg3d.WriteInteger('y', Maxbuyanimaltime);
      MAXyaoqiantime := 25;
      reg3d.WriteInteger('q', MAXyaoqiantime);
    end;
  end;
{$ENDIF}
  str := LowerCase(wb1.LocationURL);
  if pos('about:blank', str) = 0 then
    wb1.navigate('about:blank');
  Application.ProcessMessages;

  str := get0yaoqianstr(uidstr);
  wbsettext('����ҡǮ......');
  fg := false;
  while fg = false do
  try
    for i := 0 to MAXyaoqiantime * beilv - 1 do
    begin
      Application.ProcessMessages;
      idtcps[i].Disconnect;
      idtcps[i].Connect(2000);
    end;
    fg := true;
  except
    fg := false;
  end;

  for i := 0 to MAXyaoqiantime * beilv - 1 do
  begin
    idtcps[i].write(str);
  end;
  Application.ProcessMessages;

  refresh := True;
  Timer1.Enabled := true;

end;

procedure TForm1.btn05Click(Sender: TObject);
var
  str, restr: string;
  fg: boolean;
  i, j, m, n, l, p: Integer;
  cropsid: array[0..15] of string;
begin

  str := LowerCase(wb1.LocationURL);
  if pos('about:blank', str) = 0 then
    wb1.navigate('about:blank');
  Application.ProcessMessages;

  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := 'http://www.kaixin001.com/house/garden/getconf.php?verify=' + verify + '&fuid=' + uidstr;
  str := IdHTTP0.Get(str);
  j := 0;
  m := 0;
  repeat
    m := Posex('<cropsid>', str, m + 1);
    n := PosEx('<seedid>198</seedid>', str, m);
    l := PosEx('</item>', str, m);
    if (m > 0) and (n > m) and (l > n) then
    begin
      p := PosEx('</cropsid>', str, m);
      if (p - m - 9 > 1) and (p - m - 9 < 20) then
      begin
        cropsid[j] := Copy(str, m + 9, p - m - 9);
        j := j + 1;
      end;
    end;
  until m = 0;

  for m := 1 to j do
  begin
    wbsettext('����ҡ���������......<br>' + inttostr(m) + '/' + inttostr(j));
    str := get0yaoguolistr(uidstr, cropsid[m - 1]);
    fg := false;
    while fg = false do
    try
      for i := 0 to 5 * beilv - 1 do
      begin
        Application.ProcessMessages;
        idtcps[i].Disconnect;
        idtcps[i].Connect(2000);
      end;
      fg := true;
    except
      fg := false;
    end;

    for i := 0 to 5 * beilv - 1 do
    begin
      idtcps[i].write(str);
    end;
    Application.ProcessMessages;

    for i := 0 to 5 * beilv - 1 do
    begin
      try
        idtcps[i].ReadFromStack(false);
        str := idtcps[i].ReadString(idtcps[i].InputBuffer.Size);
        str := UTF8Decode(str);
        str := getreturnmsg(str);
      except
        str := '';
      end;
      if (Length(str) > 5) {and (Pos('>Succ',str)>0) } then //�ɹ�����
      begin
        if m mod 2 = 0 then
          restr := restr + '��' + str
        else
          restr := restr + '��' + str;
      end;
    end;
  end;
  Application.ProcessMessages;
  wb1.OleObject.document.body.innerhtml := '<INPUT onclick=history.back() type=button value=" �� �� ">'
    + '<br><br><font size=2>' + restr;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  str: string;
  tlist: TStringList;
  i, j: integer;
  fg: boolean;
begin

//�ȼ���ж�������
  IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
  str := 'http://www.kaixin001.com/fish/getconf.php?verify=' + verify;
  str := IdHTTP0.Get(str);
  tlist := TStringList.Create;
  getfishid(str, tlist);
  if tlist.Count < 1 then //������
  begin
    wbaddtext('<font size=4 color=blue>����û����,����Ҫιʳ<br>');
    tlist.Free;
    exit;
  end;

//����ж������㿨,��������
  str := 'http://www.kaixin001.com/fish/mytools.php?verify=' + verify;
  str := IdHTTP0.Get(str);
  i := Pos('<tid>3</tid>', str) - 20;
  if i > 0 then
  begin
    i := PosEx('<num>', str, i);
    j := PosEx('</num>', str, i);
    str := Copy(str, i + 5, j - i - 5);
    i := StrToInt(str);
  end
  else
    i := 0;

  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  if i < tlist.Count then
  begin
   //����������
    j := tlist.Count - i;
    wbsettext('��Ҫ����' + inttostr(j) + '����ʳ��<br>���ڹ���......');
    str := 'http://www.kaixin001.com/fish/buytools.php?fuid=0&id=3&verify=' + verify;
    for i := 0 to ((j - 1) div 4) do
    begin
      fg := false;
      while fg = false do
      try
        idHTTP0.Get(str);
        fg := true;
      except
        fg := false;
      end;
    end;
  end;

//���ι��
  for i := 0 to tlist.Count - 1 do
  begin
    idstrs[i] := get2foodfishStr(tlist[i]);
    fg := false;
    while fg = false do
    try
      idtcps[0].Disconnect;
      idtcps[0].Connect(2000);
      idtcps[1].Disconnect;
      idtcps[1].Connect(2000);
      idtcps[2].Disconnect;
      idtcps[2].Connect(2000);
      fg := true;
    except
      fg := false;
    end;
  end;
  wbsettext('����ι��......');
  for i := 0 to tlist.Count - 1 do
  begin
    idtcps[0].Write(idstrs[i]);
    idtcps[1].Write(idstrs[i]);
    idtcps[2].Write(idstrs[i]);
  end;
  refresh := true;
  Timer1.Enabled := true;
end;

procedure TForm1.btn27Click(Sender: TObject);
var
  i: integer;
  str: string;
begin
{$IFDEF private}
  if maxyaoyutime < 25 then
  begin
    IdHTTP0.Request.CustomHeaders.Text := 'Cookie: ' + cookiestr;
    str := IdHTTP0.Get('http://www.kaixin001.com/group/group.php?gid=845474');
    if Pos('topiclist', str) > 0 then
    begin
      maxyaoyutime := 25;
      reg3d.WriteInteger('y2', Maxyaoyutime);
      Maxbuyanimaltime := 30;
      reg3d.WriteInteger('y', Maxbuyanimaltime);
      MAXyaoqiantime := 25;
      reg3d.WriteInteger('q', MAXyaoqiantime);
    end;
  end;
{$ENDIF}
  str := get2netfishStr(uidstr);
  for i := 0 to 5 do
  begin
    idtcps[i].Disconnect;
    idtcps[i].Connect(2000);
  end;
  wb1.Navigate('about:blank');
  Application.ProcessMessages;
  wbsettext('��������ǰ����......');

  for i := 0 to 5 do
  begin
    idtcps[i].write(str);
  end;
  refresh := true;
  Timer1.Enabled := True;
end;

initialization
  OleInitialize(nil);
finalization
  OleUninitialize;
end.

