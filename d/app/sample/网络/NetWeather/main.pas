unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WinSkinForm, WinSkinData, ComCtrls, StdCtrls, ExtCtrls, jpeg,
  inifiles, Menus,IdGlobal, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,shellapi,
  Grids, hxCalendar, XPMenu,Registry;
const
  mousemsg = wm_user + 1; //�Զ�����Ϣ�����ڴ����û���ͼ���ϵ�������¼�
  iid = 100; //�û��Զ�����ֵ����TnotifyIconDataA����ȫ�ֱ���ntida��ʹ��
type
  TForm1 = class(TForm)
    SkinData1: TSkinData;
    WinSkinForm1: TWinSkinForm;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    IdAntiFreeze1: TIdAntiFreeze;
    IdHTTP1: TIdHTTP;
    N7: TMenuItem;
    Calendar1: ThxCalendar;
    Image4: TImage;
    XPMenu1: TXPMenu;
    N4: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
  private
    { Private declarations }
    //�Զ�����Ϣ�����������������ͼ���¼�
    procedure mousemessage(var message: tmessage); message
      mousemsg;
  public
    { Public declarations }
  end;

  getdatathread=class(TThread)
protected
procedure execute;override;
end;

var
  Form1: TForm1;
  mystr:string;
  ntida: TNotifyIcondataA;//�������Ӻ�ɾ��ϵͳ״̬ͼ��
implementation

uses config, about;

{$R *.dfm}
procedure TForm1.mousemessage(var message: tmessage);
var
  mousept: TPoint; //�����λ��
begin
  inherited;
  if message.LParam = wm_rbuttonup then begin //������Ҽ����ͼ��
      getcursorpos(mousept); //��ȡ���λ��
      popupmenu1.popup(mousept.x, mousept.y);
      //�ڹ��λ�õ���ѡ��
    end;
  if message.LParam = wm_lbuttonup then begin //�����������ͼ��
      //��ʾӦ�ó��򴰿�
      ShowWindow(Handle, SW_SHOW);
      //������������ʾӦ�ó��򴰿�
      ShowWindow(Application.handle, SW_SHOW);
      SetWindowLong(Application.Handle, GWL_EXSTYLE,
        not (GetWindowLong(Application.handle, GWL_EXSTYLE)
        or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW));
    end;
  message.Result := 0;
end;

procedure getdatathread.execute;
var
d1,d2,d3,min1,min2,min3,max1,max2,max3,n1,n2,n3:string;
times,provinces,citys:string;
configsini:tinifile;
function CenterStr(Src:String;Before,After:String):String;
  var
    Pos1,Pos2:WORD;

  begin
    Pos1:=Pos(Before,Src)+Length(Before);
    Pos2:=Pos(After,Src);
    Result:=Copy(Src,Pos1,Pos2-Pos1);
  end;
begin
form1.Memo1.Text :='';
form1.StatusBar1.Panels[0].Text:='';
configsini:=tinifile.Create(extractfilepath(application.ExeName)+'config.ini');
provinces:=configsini.ReadString('config','province','');
citys:=configsini.ReadString('config','city','');
times:=configsini.ReadString('config','time','');
configsini.Free;
form1.Caption:='����Ԥ������'+provinces+' '+citys+' ����';
form1.IdAntiFreeze1.OnlyWhenIdle:=False;//����ʹ�����з�Ӧ.
try
//MyStr:=form1.IdHTTP1.Get('http://localhost/t7/data.htm');
//form1.NMHTTP1.Get('http://www.lonetear.com/weather/getdata.asp?v=1.6&p=����&c=����');
//mystr:=form1.NMHTTP1.Body;
MyStr:=form1.IdHTTP1.Get('http://www.lonetear.com/weather/getdata.asp?v=1.8&p='+provinces+'&c='+citys);
form1.memo1.Lines.Add(mystr);
if  FileExists(ExtractFilePath(Application.Exename)+'data.htm') then    //ɾ����ԭ�����ļ���������д���ļ�
deletefile(ExtractFilePath(Application.Exename)+'data.htm');
form1.memo1.Lines.SaveToFile(ExtractFilePath(Application.Exename)+'data.htm');
except
form1.memo1.Lines.LoadFromFile(ExtractFilePath(Application.Exename)+'data.htm');
form1.StatusBar1.Panels[0].Text:='   ����ʱ�����������ɼ�¼';
mystr:=form1.memo1.Text ;
end;
begin
d1:=CenterStr(mystr,'[D1]','[/D1]');
d2:=CenterStr(mystr,'[D2]','[/D2]');
d3:=CenterStr(mystr,'[D3]','[/D3]');
form1.label5.Caption :=d1;
form1.label6.Caption :=d2;
form1.label7.Caption :=d3;
max1:=CenterStr(mystr,'[MAX1]','[/MAX1]');
max2:=CenterStr(mystr,'[MAX2]','[/MAX2]');
max3:=CenterStr(mystr,'[MAX3]','[/MAX3]');
form1.label8.Caption :=max1+'��';
form1.label9.Caption :=max2+'��';
form1.label10.Caption :=max3+'��';
min1:=CenterStr(mystr,'[MIN1]','[/MIN1]');
min2:=CenterStr(mystr,'[MIN2]','[/MIN2]');
min3:=CenterStr(mystr,'[MIN3]','[/MIN3]');
form1.label11.Caption :=min1+'��';
form1.label12.Caption :=min2+'��';
form1.label13.Caption :=min3+'��';
n1:=CenterStr(mystr,'[M1]','[/M1]');
n2:=CenterStr(mystr,'[M2]','[/M2]');
n3:=CenterStr(mystr,'[M3]','[/M3]');
if (pos('��',n1)>0 )then
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr1__.jpg')
else if (pos('��',n1)>0 )and (pos('ת',n1)>0 )and (pos('����',n1)>0)then
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/wb____.jpg')
else if (pos('����',n1)>0) and (pos('��',n1)>0) then
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bd____.jpg')
else if (pos('��',n1)>0 )and (pos('��',n1)>0) then
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr2__.jpg')
else if  pos('��',n1)>0 then
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/so____.jpg')
else if pos('��',n1)>0 then
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bd____.jpg')
else if pos('����',n1)>0 then
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/ms____(1).jpg')
else
form1.Image1.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr2__.jpg');
//��һ�����
if (pos('��',n2)>0 )then
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr1__.jpg')
else if (pos('��',n2)>0 )and (pos('ת',n2)>0 )and (pos('����',n2)>0)then
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/wb____.jpg')
else if (pos('����',n2)>0) and (pos('��',n2)>0) then
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bd____.jpg')
else if (pos('��',n2)>0 )and (pos('��',n2)>0) then
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr2__.jpg')
else if  pos('��',n2)>0 then
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/so____.jpg')
else if pos('��',n2)>0 then
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bd____.jpg')
else if pos('����',n2)>0 then
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/ms____(1).jpg')
else
form1.Image2.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr2__.jpg');
//�ڶ������
if (pos('��',n3)>0 )then
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr1__.jpg')
else if (pos('��',n3)>0 )and (pos('ת',n3)>0 )and (pos('����',n3)>0)then
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/wb____.jpg')
else if (pos('����',n3)>0) and (pos('��',n3)>0) then
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bd____.jpg')
else if (pos('��',n3)>0 )and (pos('��',n3)>0) then
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr2__.jpg')
else if  pos('��',n3)>0 then
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/so____.jpg')
else if pos('��',n3)>0 then
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bd____.jpg')
else if pos('����',n3)>0 then
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/ms____(1).jpg')
else
form1.Image3.Picture.LoadFromFile(ExtractFilePath(Application.Exename)+'/ͼ��/jpg/bdr2__.jpg');
//���������
form1.Image1.Hint:=n1;
form1.Image2.Hint:=n2;
form1.Image3.Hint:=n3;
end;
self.FreeOnTerminate :=true;
 form1.Timer1.Interval:=strtocard(inttostr(strtoint(times)*60000));
end;


procedure TForm1.FormCreate(Sender: TObject);
var
HzDate:THzDate;
flag:string;
configsini:tinifile;
begin
configsini:=tinifile.Create(extractfilepath(application.ExeName)+'config.ini');
flag:=configsini.ReadString('run','flag','');
configsini.Free;
if flag='true' then
n8.Checked:=true;
if flag='false' then
n8.Checked:=false;

HzDate := Calendar1.ToLunar(Calendar1.CalendarDate);
//label14.Caption :='ũ����'+Calendar1.cyclical(HzDate.year-1900+36)+Calendar1.FormatLunarMonth(HzDate.Month,HzDate.isLeap)+Calendar1.FormatLunarDay(Hzdate.Day);
StatusBar1.Panels[1].Text:= FormatDateTime('dddddd', Calendar1.CalendarDate)+'  ũ����'+Calendar1.cyclical(HzDate.year-1900+36)+Calendar1.FormatLunarMonth(HzDate.Month,HzDate.isLeap)+Calendar1.FormatLunarDay(Hzdate.Day);
getdatathread.Create(false);
ntida.cbSize := sizeof(tnotifyicondataa); //ָ��ntida�ĳ���
  ntida.Wnd := handle; //ȡӦ�ó���������ľ��
  ntida.uID := iid; //�û��Զ����һ����ֵ����uCallbackMessage����ָ������Ϣ��ʹ
  ntida.uFlags := nif_icon + nif_tip +
    nif_message; //ָ���ڸýṹ��uCallbackMessage��hIcon��szTip��������Ч
  ntida.uCallbackMessage := mousemsg;
  //ָ���Ĵ�����Ϣ
  ntida.hIcon := Application.Icon.handle;
  //ָ��ϵͳ״̬����ʾӦ�ó����ͼ����
  ntida.szTip := '����Ԥ��';
  //�����ͣ����ϵͳ״̬����ͼ����ʱ�����ָ���ʾ��Ϣ
  shell_notifyicona(NIM_ADD, @ntida);
  //��ϵͳ״̬������һ����ͼ��
end;

procedure TForm1.N6Click(Sender: TObject);
begin
//Ϊntida��ֵ��ָ���������
  ntida.cbSize := sizeof(tnotifyicondataa);
  ntida.wnd := handle;
  ntida.uID := iid;
  ntida.uFlags := nif_icon + nif_tip + nif_message;
  ntida.uCallbackMessage := mousemsg;
  ntida.hIcon := Application.Icon.handle;
  ntida.szTip := '����Ԥ��';
  shell_notifyicona(NIM_DELETE, @ntida);
  //ɾ�����е�Ӧ�ó���ͼ��
  Application.Terminate;
  //�ж�Ӧ�ó������У��˳�Ӧ�ó���
end;

procedure TForm1.N1Click(Sender: TObject);
begin
 form2.ShowModal;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
getdatathread.Create(false);
end;

procedure TForm1.N3Click(Sender: TObject);
begin
form3.ShowModal;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Action := caNone; //���Դ�������κβ���
  ShowWindow(Handle, SW_HIDE); //����������
  //����Ӧ�ó��򴰿����������ϵ���ʾ
  ShowWindow(Application.Handle, SW_HIDE);
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
    not (GetWindowLong(Application.handle, GWL_EXSTYLE)
    or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW));
end;

procedure TForm1.N7Click(Sender: TObject);
begin
 //��ʾӦ�ó��򴰿�
      ShowWindow(Handle, SW_SHOW);
      //������������ʾӦ�ó��򴰿�
      ShowWindow(Application.handle, SW_SHOW);
      SetWindowLong(Application.Handle, GWL_EXSTYLE,
        not (GetWindowLong(Application.handle, GWL_EXSTYLE)
        or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW));
end;

procedure TForm1.N8Click(Sender: TObject);
var Rego:TRegistry;
flag:string;
configsini:tinifile;
begin
if n8.Checked=false then
begin
n8.Checked:=true;
configsini:=tinifile.Create(extractfilepath(application.ExeName)+'config.ini');
configsini.writestring('run','flag','true');
configsini.Free;
end
else
begin
n8.Checked:=false;
configsini:=tinifile.Create(extractfilepath(application.ExeName)+'config.ini');
configsini.writeString('run','flag','false');
configsini.Free;
end;
if n8.Checked=true then
begin
                Rego:=TRegistry.Create;
                Rego.RootKey:=HKEY_LOCAL_MACHINE;
                rego.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True);
                Rego.WriteString('weather',application.ExeName );

                Rego.Free;
                end
else
                begin
                Rego:=TRegistry.Create;
                Rego.RootKey:=HKEY_LOCAL_MACHINE;
                rego.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True);
                Rego.WriteString('weather','' );

                Rego.Free;
                end;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
shellexecute(handle,nil,pchar((ExtractFilePath(Application.Exename)+'˵���ĵ�.htm')),nil,nil,sw_shownormal);
end;

end.
