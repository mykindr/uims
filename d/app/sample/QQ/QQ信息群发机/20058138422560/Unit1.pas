//�˳���ʵ���˲��üӺ��ѣ�ֱ����QQ�ŷ�����Ϣ�Ĺ��ܡ�
//����QQ�ķ����������ƴ�������ҿ��Կ�����һϵ��(Խ��Խ��)��QQ�Ų��ϵ��л�����½����Ҫʱ����
//���ϵ����ӺͶϿ����磬�任IP�����QQ�����������ơ�


//�������޸ı������뱣��ԭ������Ϣ��лл��

//����0769��ַ�ղ�վ
//��ַ��http://www.0769cn.com


unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, ExtCtrls,shellapi;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    WebBrowser1: TWebBrowser;
    Timer1: TTimer;
    Memo2: TMemo;
    Label11: TLabel;
    procedure Button1Click(Sender: TObject);
    function  GetQQcaption:string;
    procedure Timer1Timer(Sender: TObject);
    procedure SendMessages(m:string);
    procedure WebBrowser1DocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label11MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   Form1: TForm1;
   msgs:string;
   EditHandle,RichEditHandle: Integer;
   captions:string;
   Gi:integer;
implementation

{$R *.dfm}


function Tform1.GetQQcaption:string;
     var
        hCurrentWindow: HWnd;
        szText: array[0..254] of char;
     begin
        result:='';
        hCurrentWindow := GetWindow(Handle, GW_HWNDFIRST);
        while hCurrentWindow <> 0 do
        begin
           if GetWindowText(hCurrentWindow, @szText, 255) > 0 then
           if pos('�Ự��',StrPas(@szText))>0 then
              result:=StrPas(@szText);
           hCurrentWindow := GetWindow(hCurrentWindow, GW_HWNDNEXT);
        end;
     end;


function GetButtonHandle(hwnd: Integer; lparam: Longint):Boolean; stdcall;
var
  buffer: array[0..255] of Char;
  buffer1: array[0..255] of Char;
begin
  Result := True;
  GetClassName(hwnd,buffer,256);

  if StrPas(Buffer)='Button' then
  begin
   GetWindowText(hwnd,buffer1,100);
    if trim(buffer1)= captions then
    begin

      PInteger(lparam)^ := hwnd; //�õ�Ŀ��ؼ���Hwnd(���)
      Result:=False;  //��ֹѭ��
    end;

  end;
end;

function GetRichEditHandle(hwnd: Integer; lparam: Longint):Boolean; stdcall;
var
  buffer: array[0..255] of Char;
begin
  Result := True;
  //�õ�Ŀ�괰�ڵĿؼ�
  GetClassName(hwnd,buffer,256);
  //�ҵ�����Ϣ��Ŀ�괰�ڵ�Ŀ��ؼ�
  if StrPas(Buffer)='RICHEDIT' then
 begin
   Gi:=Gi+1;
   PInteger(lparam)^ := hwnd; //�õ�Ŀ��ؼ���Hwnd(���)

   if Gi=1 then
   begin
     SendMessage(hwnd,WM_SETFOCUS,0,0);
     SendMessage(hwnd,WM_SETTEXT,0,Integer(pchar(msgs)));

     //PostMessage(hwnd,WM_KEYDOWN, 13, 0);
     //PostMessage(hwnd,WM_KEYUP, 13, 0);

     Result:=False;//��ֹѭ��
   end;
  end;
end;




procedure Tform1.SendMessages(m:string);
var
  FButtonHandle,
  ButtonHandle,
  WinHandle:Integer;
begin

    WinHandle:=0;
    WinHandle:=FindWindow(nil,pchar(form1.GetQQcaption));  //���Ǵ��ڵ�Caption


    RichEditHandle:=WinHandle;

    msgs:=m;
    EnumChildWindows(RichEditHandle,@GetRichEditHandle,Integer(@RichEditHandle));


    captions:='����(&S)';
    ButtonHandle:=WinHandle;
    EnumChildWindows(ButtonHandle,@GetButtonHandle,Integer(@ButtonHandle));
    FButtonHandle:=ButtonHandle;

    SendMessage(FButtonHandle,WM_LBUTTONDOWN,0,0);
    SendMessage(FButtonHandle,WM_LBUTTONUP,0,0);

    SendMessage(FButtonHandle,WM_LBUTTONDOWN,0,0);
    SendMessage(FButtonHandle,WM_LBUTTONUP,0,0);

    sleep(200);
    captions:='�ر�(&C)';
    ButtonHandle:=WinHandle;
    EnumChildWindows(ButtonHandle,@GetButtonHandle,Integer(@ButtonHandle));
    FButtonHandle:=ButtonHandle;

    SendMessage(FButtonHandle,WM_LBUTTONDOWN,0,0);
    SendMessage(FButtonHandle,WM_LBUTTONUP,0,0);
    sleep(1000);
    Button1Click(self)
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   Gi:=0;
   memo2.Text:=inttostr(strtoint(memo2.Text)+1);
   form1.WebBrowser1.Navigate('tencent://Message/?Menu=no&Uin='+form1.memo2.text+'&websiteName=������ѯ');
end;




procedure TForm1.Timer1Timer(Sender: TObject);
begin
if GetQQCaption<>'' then
   SendMessages(form1.Memo1.Text);
   timer1.Enabled:=false;
end;

procedure TForm1.WebBrowser1DocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  timer1.Enabled:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  form1.Label11.Caption:='����0769��ַ�ղ�վ:'+chr(13)+'http://www.0769cn.com';
  memo2.Lines.LoadFromFile('QQ.txt');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  memo2.Lines.SaveToFile('QQ.txt');
end;

procedure TForm1.Label11MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
label11.Font.Style:=label11.Font.Style+[fsunderline];
label11.Font.Color:=clred;
end;

procedure TForm1.Label11Click(Sender: TObject);
begin
shellexecute(handle,nil,'http://www.0769cn.com/?input=qqsend',nil,nil,sw_normal);
end;

end.
