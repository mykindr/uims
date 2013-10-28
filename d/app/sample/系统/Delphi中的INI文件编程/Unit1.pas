unit Unit1;

interface
//Download by http://www.codefans.net
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Inifiles;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Timer1: TTimer;
    CheckBox1: TCheckBox;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  myinifile:TInifile;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // ÿ��һ������1
  Edit2.Text := IntToStr(StrToInt(Edit2.Text) + 1);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileName:string;
begin
  // ��ȡ��ǰ��������·��
  FileName := 'c:\myini.ini';
  // ����myinifile���󣬲��������myini.ini�ļ�
  myinifile := TInifile.Create(FileName);
  // ��ȡֵ
  Edit1.Text := myinifile.ReadString('�������', '�û�����', 'ȱʡ���û�����');
  Edit2.Text := IntToStr(myinifile.ReadInteger('�������', '������ʱ��', 0));
  Checkbox1.Checked := myinifile.ReadBool('�������', '�Ƿ���ʽ�û�', False);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // �ڳ���ر�ʱд��myini.ini�ļ�
  myinifile.WriteString('�������', '�û�����', Edit1.Text);
  myinifile.WriteInteger('�������', '������ʱ��', StrToInt(Edit2.Text));
  myinifile.WriteBool('�������', '�Ƿ���ʽ�û�', CheckBox1.Checked);

  // �ͷ�myinifile����
  myinifile.Destroy; 
end;

end.
