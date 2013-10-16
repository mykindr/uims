unit Umain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdAntiFreezeBase, IdAntiFreeze, SkinCaption, WinSkinData,
  ComCtrls, Buttons;

type
  TForm1 = class(TForm)
    EdtHost: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdtPort: TEdit;
    BtnConnect: TButton;
    IdTCPClient: TIdTCPClient;
    IdAntiFreeze1: TIdAntiFreeze;
    LbLog: TMemo;
    SkinData1: TSkinData;
    SkinCaption1: TSkinCaption;
    StatusBar1: TStatusBar;
    CB1: TCheckBox;
    CB2: TCheckBox;
    BitBtn1: TBitBtn;
    procedure BtnConnectClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CB1Click(Sender: TObject);
    procedure CB2Click(Sender: TObject);
    procedure EdtHostChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
TRWINI = function(RT:integer;INIPATH:string;Item,ItemDetail,Value:string):pchar; stdcall;
var
  Form1: TForm1;
  TipTime:string;
implementation

uses Utip;

{$R *.dfm}
//���嶯̬����DLL��ȡ����INI�ļ���inifile����,ȡ��Զ��ini�ļ�·��
function ReadINI(Item,detail:string):string;
var DLLHandle: THandle;
    Func:TRWINI;
begin
  DLLHandle:= LoadLibrary('RWINI.dll');
  try
    @Func := GetProcAddress(DLLHandle, 'RWINI');
    if Assigned(@Func) then
       begin
         result:=Func(1,ExtractFilePath(Application.ExeName)+'config.ini',Item,detail,'');
       end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;
//���嶯̬����DLLд����INI�ļ���inifile����
function WriteINI(Item,detail:string;value:string):string;
var DLLHandle: THandle;
    Func:TRWINI;
begin
  DLLHandle:= LoadLibrary('RWINI.dll');
  try
    @Func := GetProcAddress(DLLHandle, 'RWINI');
    if Assigned(@Func) then
       begin
         result:=Func(2,ExtractFilePath(Application.ExeName)+'config.ini',Item,detail,value);
       end;
  finally
    FreeLibrary(DLLHandle);
  end;
end;
//���ÿͻ���ϵͳʱ��
function SetSystemtime2(ATime: TDateTime) : boolean;
Var
  ADateTime:TSystemTime;
  yy,mon,dd,hh,min,ss,ms : Word;
Begin
  decodedate(ATime ,yy,mon,dd);
  decodetime(ATime ,hh,min,ss,ms);
  With ADateTime Do
    Begin
      wYear:=yy;
      wMonth:=mon;
      wDay:=dd;
      wHour:=hh;
      wMinute:=min;
      wSecond:=ss;
      wMilliseconds:=ms;
    End;
   Result:=SetLocalTime(ADateTime);
   SendMessage(HWND_BROADCAST,WM_TIMECHANGE,0,0) ;
  // If Result then ShowMessage('�ɹ��ı�ʱ��!');
End;

procedure TForm1.BtnConnectClick(Sender: TObject);
var T:string;
begin
  IdTCPClient.Disconnect();
  IdTCPClient.Host := EdtHost.Text;
  IdTCPClient.Port := StrToInt(EdtPort.Text);
  with IdTCPClient do
    begin
      try
        Connect(5000);
          try  
            T:=trim(ReadLn());
            if T = 'TER' then
               begin
                 LbLog.lines.Add(datetimetostr(now)+' ����˻�ȡ������ʱ�����!��������������������Уʱ�������Ƿ��ܷ���...');
                 exit;
               end
            else
              LbLog.lines.Add(T);
            if ReadINI('�Զ�����ϵͳʱ��','����') = '1' then
               begin
                 SetSystemtime2(strtodatetime(T));
               end
            else
              begin
                if cb1.Checked = true then
                   SetSystemtime2(strtodatetime(T));
              end;
            TipTime:=T;
            if ReadINI('������ʾ��','����') = '1' then
               begin
                 tip:=Ttip.Create(self);
                 tip.ShowModal;
                 tip.Free;
               end;
          except
            LbLog.lines.Add(datetimetostr(now)+' Զ����������Ӧ��');
            IdTCPClient.Disconnect();
            //MessageBox(Handle, 'Уʱʧ��', '������ʾ', MB_ICONEXCLAMATION);
          end;//end try
      except
        LbLog.lines.Add(datetimetostr(now)+' �޷�������' + EdtHost.Text + '�����ӣ�');
        //MessageBox(Handle, 'Уʱʧ��', '������ʾ', MB_ICONEXCLAMATION);
      end;//end try
    end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IdTCPClient.Disconnect();
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
BtnConnectClick(sender);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if readini('�Զ�����ϵͳʱ��','����') = '1' then cb1.Checked :=true
  else cb1.Checked :=false;
  if readini('������ʾ��','����') = '1' then cb2.Checked :=true
  else cb2.Checked :=false;
  LbLog.Lines.Add(datetimetostr(now)+' ��������...'); 
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EdtHost.Text:=trim(ReadINI('��������������','IP��ַ'));
  EdtPort.Text:=trim(ReadINI('��������������','���Ӷ˿�'));
end;

procedure TForm1.CB1Click(Sender: TObject);
begin
  if cb1.Checked = true then writeini('�Զ�����ϵͳʱ��','����','1')
  else writeini('�Զ�����ϵͳʱ��','����','0');
end;

procedure TForm1.CB2Click(Sender: TObject);
begin
  if cb2.Checked = true then writeini('������ʾ��','����','1')
  else writeini('������ʾ��','����','0');
end;

procedure TForm1.EdtHostChange(Sender: TObject);
begin
  writeini('��������������','IP��ַ',trim(EdtHost.Text));
  writeini('��������������','���Ӷ˿�',trim(EdtPort.Text));
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  application.Terminate ;   
end;

end.
