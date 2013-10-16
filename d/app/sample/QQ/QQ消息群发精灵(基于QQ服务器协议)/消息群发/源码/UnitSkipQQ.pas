//**********************************
//Դ�����ƣ�QQ��ϢȺ������(����QQ������Э��)
//����������Delphi7.0+WinXP
//Դ�����ߣ�Դ�����
//�ٷ���վ��http://www.codesky.net
//�ر��л��΢�� �ṩQQЭ�����
//������ԭ���ߵ��Ͷ�������������޸�Դ�룬���뱣��������Ϣ�������ԡ�
// **********************************
unit UnitSkipQQ;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,inifiles;

Const inifn='config.ini';

type
  TfrmSetSkipQQ = class(TForm)
    meoSkipQQ: TMemo;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ReadData;
    procedure SaveData;
  public
    { Public declarations }
    procedure SetSkipQQ;

  end;

var
  frmSetSkipQQ: TfrmSetSkipQQ;

implementation

{$R *.dfm}
procedure TfrmSetSkipQQ.SetSkipQQ;
begin
ReadData;
self.ShowModal;
end;

procedure TfrmSetSkipQQ.ReadData;
var
fini:tinifile;
filename:String;
SkipQQ:String;
begin
filename:=extractfilepath(application.Exename)+inifn;
try
fini:=tinifile.Create(filename);
SkipQQ:=fini.ReadString('Config','SkipQQ','');
SkipQQ:=stringreplace(SkipQQ,',',#13#10,[rfReplaceAll]);
meoSkipQQ.Lines.Text:=SkipQQ;
finally
fini.Free;
end;
end;

procedure TfrmSetSkipQQ.SaveData;
var
fini:tinifile;
filename:String;
SkipQQ:String;
begin
filename:=extractfilepath(application.Exename)+inifn;
SkipQQ:=meoSkipQQ.Lines.Text;
SkipQQ:=stringreplace(SkipQQ,#13#10,',',[rfReplaceAll]);
try
fini:=tinifile.Create(filename);
fini.WriteString('Config','SkipQQ',SkipQQ);
finally
fini.Free;
end;
end;

procedure TfrmSetSkipQQ.Button1Click(Sender: TObject);
begin
SaveData;
end;

end.
