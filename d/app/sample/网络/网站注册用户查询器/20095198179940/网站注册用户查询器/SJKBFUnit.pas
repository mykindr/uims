unit SJKBFUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, Buttons, ComCtrls, AAFont, AACtrls, RzBckgnd,
  pngimage,shellapi,StdCtrls, RzLabel;

type
  TSJKBFForm = class(TForm)
    RzPanel1: TRzPanel;
    Image6: TImage;
    RzSeparator6: TRzSeparator;
    ProgressBar1: TProgressBar;
    sbtnKSBF: TSpeedButton;
    lblts: TRzLabel;
    procedure sbtnKSBFClick(Sender: TObject);
    //�ý���������ʾ���ݵĽ���
    procedure mycopyfile(sourcef,targetf:string);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SJKBFForm: TSJKBFForm;
  bflf:string;//��ű���·���ı���
  ml:string;//��ȡ�����ļ����ڵ�Ŀ¼
  
implementation

uses DCEXCLEUnit;

{$R *.dfm}

procedure TSJKBFForm.mycopyfile(sourcef, targetf: string);
var
  FromF, ToF: file;
  NumRead, NumWritten: Integer;
  Buf: array[1..2048] of Char;
  n:integer;
begin
//�ý���������ʾ���ݵĽ���
AssignFile(FromF, sourcef);
Reset(FromF, 1);//���ݴ�СΪ1
AssignFile(ToF,targetf);//�򿪱��ݵ��ļ�
Rewrite(ToF, 1);//���ݴ�СΪ1
n:=0;
repeat
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    ProgressBar1.Position:=sizeof(buf)*n*100 div FileSize(FromF);
    lblts.Caption:='���ڱ���';
    application.ProcessMessages;
    //��ʾ����
    BlockWrite(ToF, Buf, NumRead, NumWritten);
    inc(n);
until (NumRead = 0) or (NumWritten <> NumRead);
lblts.Caption:='�������';
CloseFile(FromF);
CloseFile(ToF);
end;

procedure TSJKBFForm.sbtnKSBFClick(Sender: TObject);
begin
//��ʼ���ݰ�ť
bflf:=trim(ExtractFilePath(Application.ExeName))+'���ݿⱸ��\'+'webstation.mdb';
try
  if bflf<>'' then
  begin
    mycopyfile(ml+'webstation.mdb',bflf);
    application.MessageBox(pchar('���ݳɹ�!'+#13+bflf),'��վע���û���ѯ��',mb_ok+mb_iconinformation);
    lblts.Caption:='�������';
  end;
except
  begin
    application.MessageBox(pchar('����ʧ��!'+#13+bflf),'��վע���û���ѯ��',mb_ok+mb_iconwarning);
    abort;
  end;
end;
end;

procedure TSJKBFForm.FormShow(Sender: TObject);
begin
ml:=ExtractFilePath(Application.ExeName);
end;

end.
