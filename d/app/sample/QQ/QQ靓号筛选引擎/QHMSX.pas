unit QHMSX;

interface

uses
  inifiles,nb30,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, ExtCtrls, StdCtrls, Buttons,
  SHDocVw_EWB, EmbeddedWB, jpeg,mshtml,StrUtils, ComCtrls,
  Registry, XPMan, IdBaseComponent, IdThreadComponent, Spin, Mask;

type
  TForm1 = class(TForm)
    Image1: TImage;
    QQ: TListBox;
    Strat: TSpeedButton;
    Save: TSpeedButton;
    regqq: TSpeedButton;
    Clear: TSpeedButton;
    no4: TCheckBox;
    AA: TCheckBox;
    AAA: TCheckBox;
    AAAA: TCheckBox;
    AAAAA: TCheckBox;
    zdy: TEdit;
    zdyc: TCheckBox;
    h: TRadioGroup;
    Ztl: TPanel;
    mainpanel: TPanel;
    web: TPanel;
    Shape1: TShape;
    Panel2: TPanel;
    yzmEdit: TEdit;
    p1: TPanel;
    auto: TTimer;
    w: TEmbeddedWB;
    img: TPanel;
    Image2: TImage;
    Label1: TLabel;
    XPManifest1: TXPManifest;
    z: TMemo;
    Panel1: TPanel;
    p3: TPanel;
    mac: TEdit;
    Label2: TLabel;
    procedure StratClick(Sender: TObject);
    Function InputQQtoList(Input:TStrings):String;
    procedure zdycClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure regqqClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure hClick(Sender: TObject);
    procedure yzmEditClick(Sender: TObject);
    procedure autoTimer(Sender: TObject);
    procedure yzmEditChange(Sender: TObject);
    Procedure Work(Sender:TEmbeddedwb;text:Tmemo);
    procedure wDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure TimerTimer(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
  Var
   qqurl:String;
{$R *.dfm}
   m,t:longint;
   yzm,run:boolean;
function GetNetBIOSAddress : string;
var   ncb   : TNCB;
   status   : TAdapterStatus;
   lanenum : TLanaEnum;
     procedure ResetAdapter (num : char);
     begin
       fillchar(ncb,sizeof(ncb),0);
       ncb.ncb_command:=char(NCBRESET);
       ncb.ncb_lana_num:=num;
       Netbios(@ncb);
     end;
var
   i:integer;
   lanNum   : char;
   address : record
              part1 : Longint;
              part2 : Word;
             end absolute status;
begin
   Result:='';
   fillchar(ncb,sizeof(ncb),0);
     ncb.ncb_command:=char(NCBENUM);
     ncb.ncb_buffer:=@lanenum;
     ncb.ncb_length:=sizeof(lanenum);
   Netbios(@ncb);
   if lanenum.length=#0 then exit;
   lanNum:=lanenum.lana[0];
   ResetAdapter(lanNum);
   fillchar(ncb,sizeof(ncb),0);
     ncb.ncb_command:=char(NCBASTAT);
     ncb.ncb_lana_num:=lanNum;
     ncb.ncb_callname[0]:='*';
     ncb.ncb_buffer:=@status;
     ncb.ncb_length:=sizeof(status);
   Netbios(@ncb);
   ResetAdapter(lanNum);
   for i:=0 to 5 do
   begin
     result:=result+inttoHex(integer(Status.adapter_address[i]),2);
     if (i<5) then
     result:=result+'-';
   end;
end;
//

Function GetIETemp:string;
var
  ARegistry:TRegistry;
begin
  ARegistry:=TRegistry.Create;
  ARegistry.RootKey:=HKEY_LOCAL_MACHINE;
  ARegistry.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths',false);
  GetIETemp:=ARegistry.ReadString('Directory');
  ARegistry.CloseKey;
end;
Function TForm1.InputQQtoList(Input:TStrings):String;
{QQ������}
  Var
    Str,s:String;
    i:longint;
    List:string;
begin
  {Tstrings to string}
  For i:=0 to input.Count do
    S:=s+input.Strings[i];
 // showmessage(s);
  s:=StringReplace(s,'2007��������Ƽ�','z',[rfReplaceAll]);
  s:=StringReplace(s,'2008���������Ƽ�','z',[rfReplaceAll]);
  //  showmessage(s);
   //--------------
  for i:=1 to length(s) do
    if s[i] in ['0'..'9'] then
    begin
      Str:=Str+S[i];
      if length(Str)>=9 then
      begin
        List:=List+Str;
        Str:='';
      end;
    end;
  InputQQtoList:=list;
end;
Procedure TForm1.Work(Sender:TEmbeddedwb;text:Tmemo);
  Var
    S,dqurl,d:String;
    i:longint;
    b:boolean;
    Doc:IHTMLDocument2;
begin
  //��ʼ��
  img.Visible:=true;
  //����ԭʼ�ı�(text)ΪString����
  // Showmessage('test');
  text.Clear;
  text.Lines.Add(IHtmlDocument2(Sender.Document).Body.OuterText);
  For i:=0 to Text.Lines.Count do
  S:=s+Text.Lines.Strings[i];
  //����Ƿ�Ϊ��֤��ҳ��
  If AnsiContainsText(s,'��֤') then   //�Ƿ�Ϊ��֤��ҳ��
  begin
  auto.Enabled:=false;
  //��ʾW����ʾ��֤��
  img.Visible:=false;
  //��ʾ�û�
  ztl.Caption:='�밴��ͼ��ʾ������֤�롣';
  yzm:=true;
  yzmedit.Enabled:=true;
//Showmessage('1');
  exit; //�˳�
  end else auto.Enabled:=true;
  //��⵱ǰUrl<>QQURL
  ///��õ�ǰURL
  Doc:=Sender.Document as IHTMLDocument2;
  if Doc<>nil then
  dqurl:=Doc.url;
  ///�������Ƴ�
  if dqurl<>qqurl then begin Sender.Navigate(qqurl);
  exit; end;
  //��Z.Lines����ȡQQ��
  S:=InputQQtoList(Text.Lines);
  //����״̬��
  m:=m+(length(s) div 9) ;
  ztl.caption:='����'+inttostr(t div 1000)+'�� ���'+inttoStr(m)+
  '�� ����'+inttostr(qq.Items.count)+'�� �ٶ�'+inttostr(m div((t div 1000)+1))+'/��';
  //��ʼɸѡ�㷨
  For i:=1 to length(s) do
  begin
    d:=d+s[i];
    if length(d)=9 then
    begin
    {ɸѡ�㷨}
    //b��ʾ�Ƿ�ͨ��ɸѡ
    b:=true;
    if no4.Checked then
    if AnsiContainsText(d,'4') then b:=false;

    if AA.Checked then
    if not
    ((AnsiContainsText(d,'00'))or
    (AnsiContainsText(d,'11'))or
    (AnsiContainsText(d,'22'))or
    (AnsiContainsText(d,'33'))or
    (AnsiContainsText(d,'44'))or
    (AnsiContainsText(d,'55'))or
    (AnsiContainsText(d,'66'))or
    (AnsiContainsText(d,'77'))or
    (AnsiContainsText(d,'88'))or
    (AnsiContainsText(d,'99'))) then
    b:=false;
    if AAA.Checked then
    if not
    ((AnsiContainsText(d,'000')=AAA.Checked)or
    (AnsiContainsText(d,'111')=AAA.Checked)or
    (AnsiContainsText(d,'222')=AAA.Checked)or
    (AnsiContainsText(d,'333')=AAA.Checked)or
    (AnsiContainsText(d,'444')=AAA.Checked)or
    (AnsiContainsText(d,'555')=AAA.Checked)or
    (AnsiContainsText(d,'666')=AAA.Checked)or
    (AnsiContainsText(d,'777')=AAA.Checked)or
    (AnsiContainsText(d,'888')=AAA.Checked)or
    (AnsiContainsText(d,'999')=AAA.Checked)) then
    b:=false;
    if AAAA.Checked then
    if not (
    (AnsiContainsText(d,'0000')=AAAA.Checked)or
    (AnsiContainsText(d,'1111')=AAAA.Checked)or
    (AnsiContainsText(d,'2222')=AAAA.Checked)or
    (AnsiContainsText(d,'3333')=AAAA.Checked)or
    (AnsiContainsText(d,'4444')=AAAA.Checked)or
    (AnsiContainsText(d,'5555')=AAAA.Checked)or
    (AnsiContainsText(d,'6666')=AAAA.Checked)or
    (AnsiContainsText(d,'7777')=AAAA.Checked)or
    (AnsiContainsText(d,'8888')=AAAA.Checked)or
    (AnsiContainsText(d,'9999')=AAAA.Checked)) then
    b:=false;
    if AAAAA.Checked then
    if not (
    (AnsiContainsText(d,'00000')=AAAAA.Checked)or
    (AnsiContainsText(d,'11111')=AAAAA.Checked)or
    (AnsiContainsText(d,'22222')=AAAAA.Checked)or
    (AnsiContainsText(d,'33333')=AAAAA.Checked)or
    (AnsiContainsText(d,'44444')=AAAAA.Checked)or
    (AnsiContainsText(d,'55555')=AAAAA.Checked)or
    (AnsiContainsText(d,'66666')=AAAAA.Checked)or
    (AnsiContainsText(d,'77777')=AAAAA.Checked)or
    (AnsiContainsText(d,'88888')=AAAAA.Checked)or
    (AnsiContainsText(d,'99999')=AAAAA.Checked)) then
    b:=false;
    if zdyc.Checked then //�Զ���ɸѡ
    if AnsiContainsText(d,zdy.Text)=false then b:=false;
    //������ڡ������
    if qq.Items.IndexOf(d)<>-1 then b:=false;
    if b then qq.Items.Append(d);
    d:='';
    end;
  end;
  yzm:=false;
 // Sender.Navigate(qqurl);
end;
procedure TForm1.StratClick(Sender: TObject);
begin
  if run then
  begin
  m:=0;
  t:=0;
  auto.Enabled:=false;
  run:=false;
  Strat.Caption:='��ʼ';
  end else if not run then
  begin
  auto.Enabled:=true;
  run:=true;
  Strat.Caption:='ֹͣ';
  end;

end;


procedure TForm1.zdycClick(Sender: TObject);
begin
  zdy.Enabled:=zdyc.Checked;
end;

procedure TForm1.ClearClick(Sender: TObject);
begin
  qq.Clear;
end;
function GetDesktopDir: String;
var
  R: TRegistry;
begin
  R := TRegistry.Create;
  R.OpenKey('SOFTWARE\MICROSOFT\WINDOWS\CURRENTVERSION\EXPLORER\SHELL FOLDERS', FALSE);
  Result := R.ReadString('DESKTOP');
  Result := UpperCase(Result);//�D�Q���С��,���Բ�ʹ��;
  R.Free;
end;
procedure TForm1.SaveClick(Sender: TObject);
begin
  QQ.Items.SaveToFile(GetDesktopDir+'QQ����ɸѡ�б�.txt');
  Showmessage('�ѱ��浽 '+GetDesktopDir+'QQ����ɸѡ�б�.txt')

end;

procedure TForm1.regqqClick(Sender: TObject);
begin
  if qq.Count<>0 then 
  Winexec(pchar('C:\Program Files\Internet Explorer\Iexplore.exe http://haoma.qq.com/search.php?service=1&number='+QQ.Items.strings[qq.itemIndex]+'&url=http%3A%2F%2Fhaoma.qq.com%2Fgno.php'),sw_show)
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  ini:Tinifile;
begin
  qqurl:='http://haoma.qq.com/super/topic.php?type=19&cmd=list';
  mac.text:=GetNetBIOSAddress;
  if fileExists('key.ini') then
  begin
    ini:=Tinifile.Create(ExtractFilePath(Paramstr(0))+'key.ini');
    //ini.FileName:='key.ini'
    if GetNetBIOSAddress=ini.ReadString('Names','2','')
    then mac.text:='�Ѽ��лл��' else
    begin
    Showmessage('�����벻������Ȩʧ��!');
    application.Terminate;
    end;
  end;
end;

procedure TForm1.hClick(Sender: TObject);
begin
  case h.ItemIndex of
    0:qqurl:='http://haoma.qq.com/super/topic.php?type=19&cmd=list';
    1:qqurl:='http://haoma.qq.com/super/topic.php?type=18&cmd=list';
    2:qqurl:='http://haoma.qq.com/super/topic.php?type=17&cmd=list';
    3:qqurl:='http://haoma.qq.com/gno/topic_2007.php?cmd=list';
    4:qqurl:='http://haoma.qq.com/gno/topic_2008.php?cmd=list';
    5:qqurl:='http://haoma.qq.com/gno/topic_birthday.php?cmd=list2';
    6:qqurl:='http://haoma.qq.com/qqx.php?cmd=list';
    7:qqurl:='http://haoma.qq.com/gno/topic_mo_uin.php?id=130&cmd=list';
    8:qqurl:='http://haoma.qq.com/gno/topic_mo_uin.php?id=133&cmd=list';
    9:qqurl:='http://haoma.qq.com/gno/topic_mo_uin.php?id=138&cmd=list';
    10:qqurl:='http://haoma.qq.com/gno/topic_mo_uin.php?id=139&cmd=list';
    11:qqurl:='http://haoma.qq.com/gno/topic_mo_uin.php?id=159&cmd=list';
  end;
end;
procedure TForm1.yzmEditClick(Sender: TObject);
begin
  if (yzmedit.Text='QQ ����ɸѡ���� 2008')or(yzmedit.Text='�밴��ͼ��ʾ������֤�롣')
  then yzmedit.Text:='';
end;
procedure TForm1.autoTimer(Sender: TObject);
begin
  W.Navigate(qqurl);
  inc(t,500);
end;


procedure TForm1.yzmEditChange(Sender: TObject);
var
  o:Olevariant;
begin
  if yzm=False then
  begin
  yzmedit.Text:='';
  exit;
  end;
  o:=w.oleobject.document.all.item('vkey',0);
  if length(yzmedit.text)=4 then
  begin
    o.value:=yzmedit.text;
    o:=w.oleobject.document.all.item('form1',0);
    o.Submit;
    yzmedit.Text:='QQ ����ɸѡ���� 2008';
    img.Visible:=true;
    yzmedit.Enabled:=False;
    ztl.Caption:='���Եȡ���'
  end;
end;

procedure TForm1.wDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  work(w,z);
end;


procedure TForm1.TimerTimer(Sender: TObject);
begin
  if (yzm=False) and (auto.Enabled) then
  inc(t,100);
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  auto.Interval:=500;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
  auto.Interval:=800;
end;

end.


