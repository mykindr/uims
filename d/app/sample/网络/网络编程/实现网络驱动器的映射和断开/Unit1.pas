unit Unit1;
{Download by http://www.codefans.net}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Button2: TButton;
    Panel1: TPanel;
    Edit3: TEdit;
    Edit4: TEdit;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Bevel1: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender : TObject);
var
 NetSource : TNetResource;
begin
 with NetSource do
 begin
  dwType := RESOURCETYPE_DISK;
  lpLocalName :=Pchar(edit2.text);
  // ��Զ����Դӳ�䵽��������
  lpRemoteName :=pchar(edit1.text);
  // Զ��������Դ
  lpProvider := '';
  // ���븳ֵ,��Ϊ����ʹ��lpRemoteName��ֵ��
 end;
if WnetAddConnection2(NetSource, pchar(edit4.text), pchar(edit3.text), CONNECT_UPDATE_PROFILE)=NO_ERROR
 //�û���ΪGuest������ΪPassword,�´ε�¼ʱ��������,��ʱ��Windows��Դ�������пɿ���������������
 then     //ӳ��ɹ�
    showmessage(edit1.text+'�ɹ�ӳ���'+edit2.text)
  else
    showmessage('ӳ��ʧ�ܣ�');
 end;

procedure TForm1.Button2Click(Sender: TObject);
begin
if MessageDlg('ȷʵҪ�Ͽ�ô?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//�����Ƿ����ļ��򿪣��Ͽ�������������
 if WNetCancelConnection2(pchar(edit2.text), CONNECT_UPDATE_PROFILE, True)=NO_ERROR then
    //ӳ��Ͽ��ɹ�
    showmessage(edit1.text+'ӳ��Ͽ���')
  else
    showmessage('�Ͽ�ӳ��ʧ��');
end;

end.
