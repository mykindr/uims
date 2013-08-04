unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ExtCtrls, INIFiles, RzForms;

type
  TGathering = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RzEdit1: TRzEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RzFormShape1: TRzFormShape;
    CheckBox1: TCheckBox;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzEdit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure JZ;
    { Public declarations }
  end;

var
  Gathering: TGathering;
  Count: Integer;
implementation

uses Unit2, Unit6, Unit8;

{$R *.dfm}

procedure TGathering.FormCreate(Sender: TObject);
var
  vIniFile: TIniFile;
begin
  vIniFile:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Config.Ini');
  Label2.Caption:=Main.Label7.Caption;
  CheckBox1.Checked:=vIniFile.ReadBool('System','PB',True);
end;

procedure TGathering.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE:Gathering.Close;
    VK_F1: begin
      if CheckBox1.Checked then begin
        CheckBox1.Checked:=False;
        RzEdit1.SetFocus;
      end else begin
        CheckBox1.Checked:=True;
        RzEdit1.SetFocus;
      end;
    end;
    VK_F2: begin
      if MoLing<>nil then begin
        MoLing.RzEdit1.Text:=Label2.Caption;
        MoLing.RzEdit1.SelectAll;
        MoLing.ShowModal;
      end else begin
        MoLing:=TMoLing.Create(Application);
        MoLing.RzEdit1.Text:=Label2.Caption;
        MoLing.RzEdit1.SelectAll;
        MoLing.ShowModal;
      end;
    end;
    VK_F3: begin
      RzEdit1.Text:=Label2.Caption;
      if Card<>nil then
        Card.ShowModal
      else begin
        Card:=TCard.Create(Application);
        Card.ShowModal;
      end;
    end;
  end;
end;

procedure TGathering.jz;
var
  vIniFile: TIniFile;
  SID: String;
  i: Integer;
begin
  vIniFile:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Config.Ini');
  //�������ݼ��
  try
  begin
    StrToCurr(RzEdit1.Text);
  end;
  Except
  begin
    ShowMessage('����Ƿ��ַ�~~!');
    RzEdit1.Text:='';
    RzEdit1.SetFocus;
    Exit;
  end;
  end;
  //����������Ƿ�С��Ӧ����
  if StrToCurr(RzEdit1.Text)-StrToCurr(Label2.Caption)<0 then
  begin
    ShowMessage('�������С��Ӧ�տ�~~!');
    RzEdit1.Text:='';
    RzEdit1.SetFocus;
    Exit;
  end;
  //��������
  Label7.Caption:=FormatFloat('0.00',StrToCurr(RzEdit1.Text)-StrToCurr(Label2.Caption));
  //��������
  RzEdit1.ReadOnly:=True;
  //��ʾ��ʾ��
  Label9.Visible:=True;
  //д�����ڼ�¼
  Main.Label14.Caption:=FormatFloat('0.00',StrToCurr(Label2.Caption));
  Main.Label15.Caption:=FormatFloat('0.00',StrToCurr(RzEdit1.Text));
  Main.Label16.Caption:=FormatFloat('0.00',StrToCurr(Label7.Caption));
  //��ӡСƱ
  if CheckBox1.Checked then
  begin
    if messagedlg('ȷ�ϴ�ӡ��',mtconfirmation,[mbyes,mbno],0)=mryes then
    begin
      Main.QuickRep1.Height:=200+Main.DetailBand1.Height*Main.ADOQuery1.RecordCount;
      Main.QuickRep1.Page.LeftMargin:=vIniFile.ReadInteger('System','P0',0);
      Main.QuickRep1.Print;
    end;
  end;
  //�����Ƿ��ӡСƱ��Ϣ
  if CheckBox1.Checked then
  begin
    vIniFile.WriteBool('System','PB',True);
  end
  else
  begin
    vIniFile.WriteBool('System','PB',False);
  end;
  //д���ۼ�¼
  Main.ADOQuery1.First;
  while not(Main.ADOQuery1.Eof) do
  begin
    Main.ADOQuery2.Edit;
    //������Ʒ
    Main.ADOQuery2.SQL.Clear;
    Main.ADOQuery2.SQL.Add('Select * from stock Where BarCode="'+Main.ADOQuery1.FieldByName('BarCode').AsString+'"');
    Main.ADOQuery2.Open;
    //���ٿ��
    Main.ADOQuery2.Edit;
    Main.ADOQuery2.FieldByName('StockScalar').AsCurrency:=Main.ADOQuery2.FieldByName('StockScalar').AsCurrency-Main.ADOQuery1.FieldByName('SellScalar').AsCurrency;
    Main.ADOQuery2.Post;
    Main.ADOQuery1.Next;
  end;
  //�������۱��
  Main.ADOQuery2.SQL.Clear;
  Main.ADOQuery2.SQL.Add('Select * from sell_main Where InvoiceID="'+Main.Label26.Caption+'"');
  Main.ADOQuery2.Open;
  Main.ADOQuery2.Edit;
  Main.ADOQuery2.FieldByName('AR').AsString:=Main.Label7.Caption;
  Main.ADOQuery2.FieldByName('PU').AsString:=Label2.Caption;
  Main.ADOQuery2.FieldByName('Hang').AsString:='1';
  if StrToCurr(Main.Label7.Caption)-StrToCurr(Label2.Caption)<>0 then
    Main.ADOQuery2.FieldByName('Remark').AsCurrency:=StrToCurr(Main.Label7.Caption)-StrToCurr(Label2.Caption);
  Main.ADOQuery2.Post;
  //������С����
  for i:=1 to 9999 do
  begin
    SID:=FormatdateTime('yymmdd', Now)+FormatFloat('0000',i);
    Main.ADOQuery2.SQL.Clear;
    Main.ADOQuery2.SQL.Add('Select * from sell_main Where InvoiceID="'+SID+'"');
    Main.ADOQuery2.Open;
    if Main.ADOQuery2.RecordCount=0 then
      Break;
  end;
  Main.Label26.Caption:=SID;
  //���¼�����������Ʒ�۸�
  Main.QH2;

  //ˢ�������б�
  Main.ADOQuery1.Refresh;
  Main.ADOQuery1.Close;
  Main.ADOQuery1.SQL.Clear;
  Main.ADOQuery1.SQL.Add('Select * from sell_minor Where InvoiceID="'+Main.Label26.Caption+'"');
  Main.ADOQuery1.Open;
end;



procedure TGathering.RzEdit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
  if key=13 then
  begin
    count:=count+key;
    if RzEdit1.ReadOnly then
      Gathering.Close;
    if Not(RzEdit1.ReadOnly) then
      JZ;
  end;
end;

end.
