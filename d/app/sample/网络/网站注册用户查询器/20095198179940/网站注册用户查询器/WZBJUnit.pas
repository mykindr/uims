unit WZBJUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, RzBckgnd, StdCtrls, RzEdit, Mask, pngextra,
  AACtrls, AAFont, jpeg;

type
  TWZBJForm = class(TForm)
    RzPanel1: TRzPanel;
    Image1: TImage;
    AAFadeText1: TAAFadeText;
    AALabel1: TAALabel;
    AALabel3: TAALabel;
    AALabel4: TAALabel;
    AALabel5: TAALabel;
    AALabel6: TAALabel;
    btnBC: TPNGButton;
    btnQX: TPNGButton;
    txtWZMC: TRzEdit;
    txtWZDZ: TRzEdit;
    txtYHM: TRzEdit;
    txtMM: TRzEdit;
    txtWZJS: TRzMemo;
    RzSeparator2: TRzSeparator;
    procedure btnBCClick(Sender: TObject);
    //�༭�������¼
    procedure BCBZWZ(Sender: TObject);
    //����ı��е�����
    procedure TXTClear(Sender: TObject);
    procedure btnQXClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WZBJForm: TWZBJForm;

implementation

uses dmUnit, mainUnit;

{$R *.dfm}

procedure TWZBJForm.BCBZWZ(Sender: TObject);
begin
//�༭�������¼
if(txtWZMC.Text='') or (txtWZDZ.Text='') or (txtYHM.Text='') or (txtMM.Text='') then
  begin
    application.MessageBox('����д������¼��          ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    abort;
  end
else
  begin
    dm.ADOZJWZQuery.Edit;
    dm.ADOZJWZQuery['��վ����']:=txtwzmc.Text;
    dm.ADOZJWZQuery['��ַ']:=txtwzdz.Text;
    dm.ADOZJWZQuery['�û���']:=txtYHM.Text;
    dm.ADOZJWZQuery['����']:=txtMM.Text;
    dm.ADOZJWZQuery['��վ����']:=txtWZJS.Text;
    try
      begin
        dm.ADOZJWZQuery.Post;
        application.MessageBox('����ɹ���          ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
        //����ı��е�����
        TXTClear(Sender);
      end;
    except
      begin
        application.MessageBox('���ʧ�ܣ�          ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
        abort;
      end;
    end;
  end;
end;

procedure TWZBJForm.btnBCClick(Sender: TObject);
begin
//�����¼��ť
//�༭�������¼
BCBZWZ(Sender);
end;

procedure TWZBJForm.TXTClear(Sender: TObject);
begin
//����ı��е�����
txtWZMC.Clear;//��վ����
txtWZDZ.Clear;//��վ��ַ
txtYHM.Clear;//�û�����
txtMM.Clear;//�û�����
txtWZJS.Clear;//��վ����
close;//�رձ�����
end;

procedure TWZBJForm.btnQXClick(Sender: TObject);
begin
//ȡ����¼��ť
//����ı��е�����
TXTClear(Sender);
end;

end.
