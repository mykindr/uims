unit Unit6;
////΢����ӡλ�ý���
///ֵ��ע�����:edit1��edit2����ʾ����Զ�ǵ�ǰ�ĵ���ֵ.
//����ȷ���޸� �͹رս���ʱʲô������,���ָ�Ĭ������ʱeditΪ0,��ʾ����ʱedit��unit7��ȡ����.
interface
//download by http://www.codefans.net
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,unit7,unit1;

type
  TForm6 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    Button2: TButton;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button3: TButton;
    ComboBox1: TComboBox;
    Label5: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.Button2Click(Sender: TObject);
var
  temp:double;
  temp2:double;
begin
   try
   ///unit7.firstLineDownVersusStandard:=unit7.firstLineDownVersusStandard+strtofloat(trim(edit1.Text));
   unit7.firstLineDownVersusStandard:=strtofloat(trim(edit1.Text));
   unit7.pageNum:=strtoint(combobox1.Text);
   unit7.everyPageAddVersusStandard:=strtofloat(trim(edit2.Text));
   except on e:exception do
   begin
     showmessage('�޸�ʧ��,��������ȷ�����ָ�ʽ'+e.Message);
     exit;
   end;
   end;

   temp:=strtofloat(trim(edit1.Text));
   temp2:=unit1.firstLineStandardDown/180*25.4;
   if((temp<0) and (abs(temp)>temp2)) then
   begin
      showmessage('�޸�ʧ��,��ӡ��һҳ��1��֮ǰ, ��ӡ����ֽ�������Ĭ����ֽ����,���ֻ�ܼ���Լ'+ floattostr(temp2)+'����');
      exit;
   end;

   try
   unit7.saveParams;
   except on e:exception do
   begin
     showmessage('���������params.cfg�ļ�ʧ��!�޸�ʧ��!'+e.Message);
     exit;
   end;
   end;
   showMessage('�޸����');
   //�����е�����,Ϊ�˷�ֹxx����,��0�������.
   //edit1.Text:='0';
   //edit2.Text:='0';
   //edit1.Clear;
   //edit2.Clear;
   //form6.Visible:=false;
end;

procedure TForm6.Button1Click(Sender: TObject);
begin
  unit7.firstLineDownVersusStandard:=0;
  unit7.everyPageAddVersusStandard:=0;
  try
   unit7.saveParams;
   except
   begin
     showmessage('���������params.cfg�ļ�ʧ��!�޸�ʧ��!');
     exit;
   end;
   end;

  showMessage('�ָ�Ĭ���������');
  edit1.Text:='0';
  edit2.Text:='0';
end;

procedure TForm6.Button3Click(Sender: TObject);
begin
 //  edit1.text:='0';
  //edit2.Text:='0';
  form6.Visible:=false;
end;

procedure TForm6.FormHide(Sender: TObject);
begin
   Button3Click(Sender);
end;

procedure TForm6.FormShow(Sender: TObject);
begin
   edit1.Text:=floattostr(unit7.firstLineDownVersusStandard);
   edit2.Text:=floattostr(unit7.everyPageAddVersusStandard);
   combobox1.Text:=inttostr(unit7.pageNum);
end;

end.
