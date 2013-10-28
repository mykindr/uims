unit EnterpriseRegister;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, EditNew, ExtCtrls, ComCtrls, Buttons, Grids, AdvGrid, DrLabel,
  ImgList, AsgPrev;

type
  TfrmEnterpriseRegister = class(TForm)
    pnlTop: TPanel;
    pnlEdit: TPanel;
    pnlBrowse: TPanel;
    pnlLeft: TPanel;
    Splitter1: TSplitter;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    edtRatepayingNo: TEditN;
    edtEnterpriseName: TEditN;
    edtTelephoneNo: TEditN;
    edtTaxRegisterNo: TEditN;
    edtDetailAddress: TEditN;
    edtLinkman: TEditN;
    bbtnNew: TBitBtn;
    bbtnModify: TBitBtn;
    bbtnDelete: TBitBtn;
    bbtnPrint: TBitBtn;
    bbtnClose: TBitBtn;
    TreeView: TTreeView;
    sgEnterprise: TAdvStringGrid;
    bbtnSave: TBitBtn;
    bbtnCancel: TBitBtn;
    bbtnCharge: TBitBtn;
    lblTitle: TDRLabel;
    ilNodeImages: TImageList;
    Label1: TDRLabel;
    Label3: TDRLabel;
    Label5: TDRLabel;
    Label2: TDRLabel;
    Label4: TDRLabel;
    Label6: TDRLabel;
    lblAffiliateTown: TDRLabel;
    bbtnPreview: TBitBtn;
    AdvPreviewDialog1: TAdvPreviewDialog;
    procedure FormCreate(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure bbtnNewClick(Sender: TObject);
    procedure bbtnModifyClick(Sender: TObject);
    procedure bbtnDeleteClick(Sender: TObject);
    procedure bbtnChargeClick(Sender: TObject);
    procedure bbtnPrintClick(Sender: TObject);
    procedure bbtnCloseClick(Sender: TObject);
    procedure sgEnterpriseClickCell(Sender: TObject; arow, acol: Integer);
    procedure bbtnSaveClick(Sender: TObject);
    procedure bbtnCancelClick(Sender: TObject);
    procedure edtRatepayingNoKeyPress(Sender: TObject; var Key: Char);
    procedure sgEnterpriseGetAlignment(Sender: TObject; ARow,
      ACol: Integer; var AAlignment: TAlignment);
    procedure sgEnterpriseGetCellColor(Sender: TObject; ARow,
      ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure bbtnPreviewClick(Sender: TObject);
    procedure sgEnterprisePrintStart(Sender: TObject; NrOfPages: Integer;
      var FromPage, ToPage: Integer);
    procedure sgEnterpriseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgEnterpriseRowChanging(Sender: TObject; OldRow,
      NewRow: Integer; var Allow: Boolean);
    procedure edtRatepayingNoExit(Sender: TObject);
    procedure edtTaxRegisterNoExit(Sender: TObject);
  private
    procedure GetEnterprise(ATownCode: string);
    procedure GetStatus;
    procedure ClearEdit;
    procedure SetImeName;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnterpriseRegister: TfrmEnterpriseRegister;

implementation

uses
  DBTables, Global, ClassEnterprise;

var
  CurrRow, CurrCol: Integer;

{$R *.DFM}

procedure TfrmEnterpriseRegister.FormCreate(Sender: TObject);
begin
  //���TREEVIEW��������ϲ�����뷨
  GetTown(TreeView);
  SetImeName;
end;

procedure TfrmEnterpriseRegister.GetEnterprise(ATownCode: string);
var
  TmpQuery: TQuery;
  I: Integer;
begin
//����������ȡ����
  I := 1;
  sgEnterprise.ClearRows(1, sgEnterprise.RowCount - 1);
  sgEnterprise.RowCount := 2;
  try
    TmpQuery := TQuery.Create(nil);
    with TmpQuery do
    try
      DataBaseName := 'JB';
      Close;
      SQl.Clear;
      SQL.Add(' SELECT * FROM Enterprise.DB ');
      SQL.Add(' WHERE  AffiliateTown LIKE "' + ATownCode + '%" ');
      SQL.Add(' ORDER  BY RatepayingNo');
      Open;
      First;
      if not IsEmpty then
      begin
        sgEnterprise.RowCount := RecordCount + 1;
        while not EOF do
        begin
          sgEnterprise.Cells[0, I] := FieldByName('RatepayingNo').AsString;
          sgEnterprise.Cells[1, I] := FieldByName('TaxRegisterNo').AsString;
          sgEnterprise.Cells[2, I] := FieldByName('EnterpriseName').AsString;
          sgEnterprise.Cells[3, I] := FieldByName('DetailAddress').AsString;
          sgEnterprise.Cells[4, I] := FieldByName('TelephoneNo').AsString;
          sgEnterprise.Cells[5, I] := FieldByName('Linkman').AsString;
          Inc(I);
          Next;
        end;
        sgEnterprise.AutoSize := True;
      end;
    finally
      Close;
      Free;
    end;
  except
  end;
end;

procedure TfrmEnterpriseRegister.TreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  //���ݸ�������ȡ�������������ø���ť״̬
  GetEnterprise(GetFront(Node.Text, '-'));
  GetStatus;
end;

procedure TfrmEnterpriseRegister.bbtnNewClick(Sender: TObject);
begin
//����¼�¼
  pnlLeft.Enabled := False;
  pnlBrowse.Enabled := False;
  lblAffiliateTown.Caption := '��������:' + TreeView.Selected.Text;
  ClearEdit;
  PageControl1.ActivePageIndex := 1;
  bbtnSave.Tag := 1;
end;

procedure TfrmEnterpriseRegister.bbtnModifyClick(Sender: TObject);
begin
//�޸�ѡ����¼
  sgEnterpriseClickCell(bbtnModify, CurrRow, CurrCol);
  pnlLeft.Enabled := False;
  pnlBrowse.Enabled := False;
  lblAffiliateTown.Caption := '��������:' + TreeView.Selected.Text;
  edtRatepayingNo.Enabled := False;
  PageControl1.ActivePageIndex := 1;
  bbtnSave.Tag := 2;
end;

procedure TfrmEnterpriseRegister.bbtnDeleteClick(Sender: TObject);
begin
//ɾ��ѡ����¼
  if Application.MessageBox(PChar('���Ҫɾ��[' + sgEnterprise.Cells[2, CurrRow] + ']��'), '����', MB_YESNO + MB_ICONWARNING) = IDYES then
  begin
    Enterprise.RatepayingNo := Trim(sgEnterprise.Cells[0, CurrRow]);
    Enterprise.Delete;
    TreeViewChange(bbtnDelete, TreeView.Selected);
  end;
end;

procedure TfrmEnterpriseRegister.bbtnChargeClick(Sender: TObject);
begin
//�շ�{ TODO : ��ҵ�ǼǺ����Ͻ����շ� }
end;

procedure TfrmEnterpriseRegister.bbtnPrintClick(Sender: TObject);
begin
//��ӡ���
  sgEnterprise.Print;
end;

procedure TfrmEnterpriseRegister.bbtnCloseClick(Sender: TObject);
begin
//�˳�
  Close;
end;

procedure TfrmEnterpriseRegister.GetStatus;
begin
  //���ø���ť״̬
  bbtnNew.Enabled := (TreeView.Selected.Level = 1);
  sgEnterpriseClickCell(sgEnterprise, 1, 0);
end;

procedure TfrmEnterpriseRegister.sgEnterpriseClickCell(Sender: TObject; arow, acol: Integer);
begin
  //��ȡ��ǰ���У����ø�����ť״̬�����༭��
  CurrRow := ARow;
  CurrCol := ACol;
  bbtnModify.Enabled := (TreeView.Selected.Level = 1) and (Trim(sgEnterprise.Cells[0, ARow]) <> '');
  bbtnDelete.Enabled := (Trim(sgEnterprise.Cells[0, ARow]) <> '');
  bbtnCharge.Enabled := (Trim(sgEnterprise.Cells[0, ARow]) <> '');
  bbtnPreview.Enabled := (Trim(sgEnterprise.Cells[0, ARow]) <> '');
  bbtnPrint.Enabled := (Trim(sgEnterprise.Cells[0, ARow]) <> '');

  edtRatepayingNo.Text := Trim(sgEnterprise.Cells[0, ARow]);
  edtTaxRegisterNo.Text := Trim(sgEnterprise.Cells[1, ARow]);
  edtEnterpriseName.Text := Trim(sgEnterprise.Cells[2, ARow]);
  edtDetailAddress.Text := Trim(sgEnterprise.Cells[3, ARow]);
  edtTelephoneNo.Text := Trim(sgEnterprise.Cells[4, ARow]);
  edtLinkman.Text := Trim(sgEnterprise.Cells[5, ARow]);
end;

procedure TfrmEnterpriseRegister.bbtnSaveClick(Sender: TObject);
begin
//���浱ǰ����
  Enterprise.RatepayingNo := Trim(edtRatepayingNo.Text);
  Enterprise.TaxRegisterNo := Trim(edtTaxRegisterNo.Text);
  Enterprise.EnterpriseName := Trim(edtEnterpriseName.Text);
  Enterprise.AffiliateTown := Trim(GetFront(GetBack(lblAffiliateTown.Caption, ':'), '-'));
  Enterprise.DetailAddress := Trim(edtDetailAddress.Text);
  Enterprise.TelephoneNo := Trim(edtTelephoneNo.Text);
  Enterprise.Linkman := Trim(edtLinkman.Text);
  case bbtnSave.Tag of
    1: Enterprise.Insert;
    2: Enterprise.Update;
  end;
  TreeViewChange(bbtnSave, TreeView.Selected);

  bbtnSave.Tag := 0;
  pnlLeft.Enabled := True;
  pnlBrowse.Enabled := True;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmEnterpriseRegister.bbtnCancelClick(Sender: TObject);
begin
//������ǰ����
  bbtnSave.Tag := 0;
  pnlLeft.Enabled := True;
  pnlBrowse.Enabled := True;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmEnterpriseRegister.edtRatepayingNoKeyPress(Sender: TObject;
  var Key: Char);
begin
//ȷ������Ķ�������
  if not (Key in ['0'..'9', #8, #13, #35, #36, #37, #39]) then
    Key := #0;
end;

procedure TfrmEnterpriseRegister.ClearEdit;
begin
//������б༭��
  edtRatepayingNo.Text := '';
  edtEnterpriseName.Text := '';
  edtTelephoneNo.Text := '';
  edtTaxRegisterNo.Text := '';
  edtDetailAddress.Text := '';
  edtLinkman.Text := '';
end;

procedure TfrmEnterpriseRegister.sgEnterpriseGetAlignment(Sender: TObject;
  ARow, ACol: Integer; var AAlignment: TAlignment);
begin
//���ö��뷽ʽ
  if (ARow=0)or((ARow > 0) and (ACol in [0, 1])) then
    AAlignment := taCenter;
end;

procedure TfrmEnterpriseRegister.sgEnterpriseGetCellColor(Sender: TObject;
  ARow, ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
begin
//���ñ�����ɫ
  if (ARow > 0) and (ARow mod 2 = 0) then
    ABrush.Color := RGB(106, 202, 240);
end;

procedure TfrmEnterpriseRegister.bbtnPreviewClick(Sender: TObject);
begin
  //���ô�ӡԤ��
  sgEnterprise.PrintSettings.TitleText := 'ί�д�����ҵ������' + GetBack(TreeView.Selected.Text, '-');
  AdvPreviewDialog1.PreviewWidth := Screen.Width;
  AdvPreviewDialog1.PreviewHeight := Screen.Height;
  AdvPreviewDialog1.Execute;
end;

procedure TfrmEnterpriseRegister.sgEnterprisePrintStart(Sender: TObject;
  NrOfPages: Integer; var FromPage, ToPage: Integer);
begin
  //���ñ��ı���
  sgEnterprise.PrintSettings.TitleText := 'ί�д�����ҵ������' + GetBack(TreeView.Selected.Text, '-');
end;

procedure TfrmEnterpriseRegister.sgEnterpriseKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  //���̲�������ӣ��޸ģ�ɾ����
  if TreeView.Selected.Level = 1 then
  begin
    if Key = VK_INSERT then
    begin
      bbtnNewClick(sgEnterprise);
      edtRatepayingNo.SetFocus;
    end;

    if Key = VK_RETURN then
    begin
      bbtnModifyClick(sgEnterprise);
      edtEnterpriseName.SetFocus;
    end;
  end;

  if Key = VK_DELETE then
  begin
    bbtnDeleteClick(sgEnterprise);
  end;
end;

procedure TfrmEnterpriseRegister.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
//ESC��ȡ���������˳���
  if Key = VK_ESCAPE then
    if PageControl1.ActivePageIndex = 1 then
      bbtnCancelClick(Self)
    else
      Close;
end;

procedure TfrmEnterpriseRegister.sgEnterpriseRowChanging(Sender: TObject;
  OldRow, NewRow: Integer; var Allow: Boolean);
begin
  //ȡ��ǰ��
  CurrRow := NewRow;
end;

procedure TfrmEnterpriseRegister.SetImeName;
begin
  //������ϲ�������뷨
  edtRatepayingNo.ImeName := IniInfo.ImeName;
  edtEnterpriseName.ImeName := IniInfo.ImeName;
  edtTelephoneNo.ImeName := IniInfo.ImeName;
  edtTaxRegisterNo.ImeName := IniInfo.ImeName;
  edtDetailAddress.ImeName := IniInfo.ImeName;
  edtLinkman.ImeName := IniInfo.ImeName;
end;

procedure TfrmEnterpriseRegister.edtRatepayingNoExit(Sender: TObject);
begin
  //ȷ��������ȷ����˰����λ��
  if Length(edtRatepayingNo.Text)<edtRatepayingNo.MaxLength then
  begin
    Application.MessageBox('��˰�������Ϊ6λ��','��ʾ',MB_OK+ MB_ICONINFORMATION);
    edtRatepayingNo.SetFocus;
  end;
end;

procedure TfrmEnterpriseRegister.edtTaxRegisterNoExit(Sender: TObject);
begin
  //ȷ��������ȷ��˰��Ǽ�֤��λ��
  if Length(edtRatepayingNo.Text)<edtRatepayingNo.MaxLength then
  begin
    Application.MessageBox('˰��Ǽ�֤�ű���Ϊ15λ��','��ʾ',MB_OK+ MB_ICONINFORMATION);
    edtRatepayingNo.SetFocus;
  end;
end;

end.

