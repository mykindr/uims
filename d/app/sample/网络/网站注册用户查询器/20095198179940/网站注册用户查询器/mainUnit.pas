unit mainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitASBase, UnitASPages, ExtCtrls, RzPanel, RzStatus, RzButton,
  ImgList, jpeg, AAFont, AACtrls, StdCtrls, Mask, RzEdit, pngextra, Grids,
  DBGrids, RzDBGrid, UnitASEdit, UnitASComboBox, pngimage, UnitASButtons,
  RzBckgnd;

type
  TmainForm = class(TForm)
    RzStatusBar1: TRzStatusBar;
    RzClockStatus1: TRzClockStatus;
    RzStatusPane2: TRzStatusPane;
    RzMarqueeStatus1: TRzMarqueeStatus;
    RzToolbar1: TRzToolbar;
    ImageList1: TImageList;
    btnTJWZ: TRzToolButton;
    ASPageControl1: TASPageControl;
    Image1: TImage;
    AAFadeText1: TAAFadeText;
    AALabel1: TAALabel;
    txtWZMC: TRzEdit;
    AALabel2: TAALabel;
    AALabel3: TAALabel;
    txtWZDZ: TRzEdit;
    txtYHM: TRzEdit;
    AALabel4: TAALabel;
    AALabel5: TAALabel;
    txtMM: TRzEdit;
    AALabel6: TAALabel;
    txtWZJS: TRzMemo;
    btnBC: TPNGButton;
    btnQX: TPNGButton;
    RzSpacer1: TRzSpacer;
    btnBJWZ: TRzToolButton;
    RzSpacer2: TRzSpacer;
    Image2: TImage;
    AAFadeText2: TAAFadeText;
    DBBJWZGrid: TRzDBGrid;
    AALabel7: TAALabel;
    txtZD: TASComboBox;
    txtTJ: TASEdit;
    btnBJWZCX: TASActiveButton;
    panTS: TRzPanel;
    RzSeparator1: TRzSeparator;
    RzSeparator2: TRzSeparator;
    btnSCWZ: TRzToolButton;
    RzSpacer3: TRzSpacer;
    Image3: TImage;
    RzSeparator3: TRzSeparator;
    AAFadeText3: TAAFadeText;
    DBSCWZGrid: TRzDBGrid;
    Image4: TImage;
    RzSeparator4: TRzSeparator;
    AAFadeText4: TAAFadeText;
    btnCXWZ: TRzToolButton;
    RzSpacer4: TRzSpacer;
    AALabel8: TAALabel;
    AALabel9: TAALabel;
    txtTJ1: TASEdit;
    txtZD1: TASComboBox;
    btnCXWZ1: TASActiveButton;
    DBCXWZGrid: TRzDBGrid;
    btnSXSJ: TRzToolButton;
    DBLLWZGrid: TRzDBGrid;
    Image5: TImage;
    RzSeparator5: TRzSeparator;
    AAFadeText5: TAAFadeText;
    RzSpacer5: TRzSpacer;
    btnWZLL: TRzToolButton;
    RzSpacer6: TRzSpacer;
    Image6: TImage;
    RzSeparator6: TRzSeparator;
    AAFadeText6: TAAFadeText;
    btnSJKBF: TPNGButton;
    btnSJKYS: TPNGButton;
    btnDREXCLE: TPNGButton;
    btnSJWH: TRzToolButton;
    btnDRWB: TPNGButton;
    procedure btnTJWZClick(Sender: TObject);
    procedure btnQXClick(Sender: TObject);
    //����ı��е�����
    procedure TXTClear(Sender: TObject);
    //��Ӽ�¼
    procedure TJJL(Sender: TObject);
    procedure btnBCClick(Sender: TObject);
    procedure btnBJWZClick(Sender: TObject);
    //��ñ����ֶ�
    procedure COMZD(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBJWZCXClick(Sender: TObject);
    //��ʼ����
    procedure InitTable(Sender: TObject);
    procedure DBBJWZGridDblClick(Sender: TObject);
    procedure btnSCWZClick(Sender: TObject);
    procedure DBSCWZGridDblClick(Sender: TObject);
    procedure btnCXWZClick(Sender: TObject);
    procedure btnCXWZ1Click(Sender: TObject);
    procedure DBCXWZGridDblClick(Sender: TObject);
    procedure btnSXSJClick(Sender: TObject);
    procedure btnWZLLClick(Sender: TObject);
    procedure DBLLWZGridDblClick(Sender: TObject);
    procedure btnSJKBFClick(Sender: TObject);
    procedure btnDREXCLEClick(Sender: TObject);
    procedure btnSJWHClick(Sender: TObject);
    procedure btnDRWBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;

implementation

uses dmUnit, WZBJUnit, IELLQUnit, SJKBFUnit, DCEXCLEUnit, DCTXTUnit;

{$R *.dfm}

procedure TmainForm.btnTJWZClick(Sender: TObject);
begin
//������վ���߰�ť
aspagecontrol1.ActivePage:='������վ';
end;

procedure TmainForm.btnQXClick(Sender: TObject);
begin
//ȡ����¼��ť
//����ı��е�����
TXTClear(Sender);
mainform.txtWZMC.SetFocus;
end;

procedure TmainForm.TXTClear(Sender: TObject);
begin
//����ı��е�����
mainform.txtWZMC.Clear;//��վ����
mainform.txtWZDZ.Clear;//��վ��ַ
mainform.txtYHM.Clear;//�û�����
mainform.txtMM.Clear;//�û�����
mainform.txtWZJS.Clear;//��վ����
end;

procedure TmainForm.TJJL(Sender: TObject);
begin
//��Ӽ�¼
if(mainform.txtWZMC.Text='') or (mainform.txtWZDZ.Text='') or (mainform.txtYHM.Text='') or (mainform.txtMM.Text='') then
  begin
    application.MessageBox('����д������¼��          ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    abort;
  end
else
  begin
    dm.ADOZJWZQuery.Close;
    dm.ADOZJWZQuery.SQL.Clear;
    dm.ADOZJWZQuery.SQL.Add('insert into ��վע���û������ (��վ����,��ַ,�û���,����,��վ����) values(:wzmc,:wz,:yhm,:mm,:wzjs)');
    dm.ADOZJWZQuery.Parameters.ParamByName('wzmc').Value:=txtWZMC.Text;//��վ����
    dm.ADOZJWZQuery.Parameters.ParamByName('wz').Value:=txtWZDZ.Text;//��վ��ַ
    dm.ADOZJWZQuery.Parameters.ParamByName('yhm').Value:=txtYHM.Text;//�û�����
    dm.ADOZJWZQuery.Parameters.ParamByName('mm').Value:=txtMM.Text;//�û�����
    dm.ADOZJWZQuery.Parameters.ParamByName('wzjs').Value:=txtWZJS.Text;//��վ����
    dm.ADOZJWZQuery.ExecSQL;
    application.MessageBox('��¼�ɹ���         ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    dm.ADOZJWZTable.Active:=false;
    dm.ADOZJWZTable.Active:=true;
    //����ı��е�����
    TXTClear(Sender);
    mainform.txtWZMC.SetFocus;
  end;
end;

procedure TmainForm.btnBCClick(Sender: TObject);
begin
//��Ӽ�¼��ť
//��Ӽ�¼
TJJL(Sender);
//��ʼ����
InitTable(Sender);
//ˢ��IELLQ�������е�����
iellqform.FormShow(sender);
end;

procedure TmainForm.btnBJWZClick(Sender: TObject);
begin
//�༭��վ���߰�ť
aspagecontrol1.ActivePage:='�༭��վ';
end;

procedure TmainForm.COMZD(Sender: TObject);
var   
  i:integer;
begin
//��ñ����ֶ�
//������վע���û������
dm.ADOZJWZQuery.Close;
dm.ADOZJWZQuery.SQL.Clear;
dm.ADOZJWZQuery.SQL.Add('select * from ��վע���û������');
dm.ADOZJWZQuery.Open;
for i:=1 to dm.ADOZJWZQuery.FieldCount-1 do
  begin
    txtZD.Items.Add(dm.ADOZJWZQuery.Fields[i].FieldName);
    txtZD1.Items.Add(dm.ADOZJWZQuery.Fields[i].FieldName);
  end;
end;

procedure TmainForm.FormShow(Sender: TObject);
begin
//��ñ����ֶ�
COMZD(Sender);
//��ʼ����
InitTable(Sender);
end;

procedure TmainForm.btnBJWZCXClick(Sender: TObject);
begin
//�༭��վ��ѯ��ť
if (txtzd.Text='') or (txttj.Text='') then
  begin
    application.MessageBox('����д������¼��          ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    abort;
  end
else
  begin
    dm.ADOZJWZQuery.Close;
    dm.ADOZJWZQuery.SQL.Clear;
    dm.ADOZJWZQuery.SQL.Add('select * from ��վע���û������ where '+txtzd.Text+'='+''''+txttj.Text+'''');
    dm.ADOZJWZQuery.Open;
    if(dm.ADOZJWZQuery.RecordCount>=1) then
      begin
        pants.Caption:='һ����ѯ��'+inttostr(dm.DataWZBJSource.DataSet.RecordCount)+'����¼';
      end
    else
      begin
        pants.Caption:='һ����ѯ��'+inttostr(dm.DataWZBJSource.DataSet.RecordCount)+'����¼';
      end;
     txtzd.ItemIndex:=-1;
     txttj.Clear;
  end;
end;

procedure TmainForm.InitTable(Sender: TObject);
begin
//��ʼ����
with dm.ADOZJWZQuery do
  begin
    close;
    sql.Clear;
    sql.Add('select * from ��վע���û������');
    open;
  end;
pants.Caption:='һ����ѯ��'+inttostr(dm.DataWZBJSource.DataSet.RecordCount)+'����¼';  
end;

procedure TmainForm.DBBJWZGridDblClick(Sender: TObject);
begin
//˫������Ҫ��ʾ����Ϣ��ʾ�ڱ༭��վ������
if(dm.ADOZJWZQuery.IsEmpty=true) then
  begin
    application.MessageBox('û�п���ȡ����Ϣ!   ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    abort;
  end
else
  begin
    wzbjform.txtWZMC.Text:=DBBJWZGrid.DataSource.DataSet.FieldValues['��վ����'];
    wzbjform.txtWZDZ.Text:=DBBJWZGrid.DataSource.DataSet.FieldValues['��ַ'];
    wzbjform.txtYHM.Text:=DBBJWZGrid.DataSource.DataSet.FieldValues['�û���'];
    wzbjform.txtMM.Text:=DBBJWZGrid.DataSource.DataSet.FieldValues['����'];
    wzbjform.txtWZJS.Text:=DBBJWZGrid.DataSource.DataSet.FieldValues['��վ����'];
    wzbjform.ShowModal;//��ʾ�༭��վ����
    //ˢ��IELLQ�������е�����
    iellqform.FormShow(sender);
  end;
end;

procedure TmainForm.btnSCWZClick(Sender: TObject);
begin
//ɾ����վ���߰�ť
aspagecontrol1.ActivePage:='ɾ����վ';
end;

procedure TmainForm.DBSCWZGridDblClick(Sender: TObject);
begin
//˫�����ɾ����վ
if(dm.ADOZJWZQuery.IsEmpty=true) then
  begin
    application.MessageBox('Ŀǰ�����û��Ҫɾ������վ��Ϣ!','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    abort;
  end
else
  begin
    if(application.MessageBox('�����Ҫɾ��������Ϣ��?','��վע���û���ѯ��',mb_yesno+mb_iconquestion)=idyes) then
      begin
        dm.ADOZJWZQuery.Delete;
        try
          begin
            application.MessageBox('ɾ���ɹ�!','��վע���û���ѯ��',mb_ok+mb_iconquestion);
            //��ʼ����
            InitTable(Sender);
            //ˢ��IELLQ�������е�����
            iellqform.FormShow(sender);
          end;
        except
          begin
            application.MessageBox('ɾ��ʧ��!','��վע���û���ѯ��',mb_ok+mb_iconquestion);
            abort;
          end;
        end;
       end
  else
    begin
      abort;
    end;
  end;   
end;

procedure TmainForm.btnCXWZClick(Sender: TObject);
begin
//��ѯ��վ���߰�ť
aspagecontrol1.ActivePage:='��ѯ��վ';
end;

procedure TmainForm.btnCXWZ1Click(Sender: TObject);
var
 stra:string;
begin
//��ѯ��վ��ť
//�༭��վ��ѯ��ť
if (txtzd1.Text='') or (txttj1.Text='') then
  begin
    application.MessageBox('����д������¼��          ','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    abort;
  end
else
  begin
    dm.ADOZJWZQuery.Close;
    dm.ADOZJWZQuery.SQL.Clear;
    stra:='select * from ��վע���û������ where '+txtzd1.Text+' like '+'''%'+txttj1.Text+'%''';
    dm.ADOZJWZQuery.SQL.Add(stra);
    dm.ADOZJWZQuery.Open;
    {if(dm.ADOZJWZQuery.RecordCount>=1) then
      begin
        pants.Caption:='һ����ѯ��'+inttostr(dm.DataWZBJSource.DataSet.RecordCount)+'����¼';
      end
    else
      begin
        pants.Caption:='һ����ѯ��'+inttostr(dm.DataWZBJSource.DataSet.RecordCount)+'����¼';
      end;}
     txtzd1.ItemIndex:=-1;
     txttj1.Clear;
  end;
end;

procedure TmainForm.DBCXWZGridDblClick(Sender: TObject);
begin
//���ñ���˫���¼�
//�༭��վ���˫���¼�(���ļ�¼����)
DBBJWZGridDblClick(sender);
end;

procedure TmainForm.btnSXSJClick(Sender: TObject);
begin
//ˢ�����ݹ��߰�ť
//��ʼ����
InitTable(Sender);
end;

procedure TmainForm.btnWZLLClick(Sender: TObject);
begin
//��վ������߰�ť
aspagecontrol1.ActivePage:='�����վ';
end;

procedure TmainForm.DBLLWZGridDblClick(Sender: TObject);
begin
//˫����������վ
if(dm.ADOZJWZQuery.IsEmpty=true) then
  begin
    application.MessageBox('Ŀǰ�����û��Ҫɾ������վ��Ϣ!','��վע���û���ѯ��',mb_ok+mb_iconquestion);
    abort;
  end
else
  begin
    iellqform.Show;//��ʾIE�����
  end;
end;

procedure TmainForm.btnSJKBFClick(Sender: TObject);
begin
//���ݿⱸ�ݰ�ť
sjkbfform.ShowModal;//���ݿⱸ�ݴ���
end;

procedure TmainForm.btnDREXCLEClick(Sender: TObject);
begin
//����EXCEL��ť
dcexcleform.ShowModal;//����EXCEL����
end;

procedure TmainForm.btnSJWHClick(Sender: TObject);
begin
//����ά�����߰�ť
aspagecontrol1.ActivePage:='����ά��';
end;

procedure TmainForm.btnDRWBClick(Sender: TObject);
begin
//�����ı���ť
dctxtform.ShowModal;//�����ı�����
end;

end.
