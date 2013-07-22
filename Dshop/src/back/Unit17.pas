unit Unit17;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, DBGrids, StdCtrls, Buttons, Mask, RzEdit, DB,
  ADODB;

type
  TFr_GJTH = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel5: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel1: TBevel;
    Panel3: TPanel;
    Label9: TLabel;
    DBGrid1: TDBGrid;
    RzEdit1: TRzEdit;
    RzEdit2: TRzEdit;
    RzEdit3: TRzEdit;
    RzEdit4: TRzEdit;
    RzEdit6: TRzEdit;
    RzEdit7: TRzEdit;
    RzEdit5: TRzEdit;
    RzEdit8: TRzEdit;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    ADOQuery1: TADOQuery;
    DataSource1: TDataSource;
    ADOQuery2: TADOQuery;
    procedure SpeedButton1Click(Sender: TObject);
    procedure RzEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure RzEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fr_GJTH: TFr_GJTH;

implementation

uses Unit18, Unit1, Unit2;

{$R *.dfm}

procedure TFr_GJTH.SpeedButton1Click(Sender: TObject);
begin
  if Fr_GJTH_1<>nil then
    Fr_GJTH_1.ShowModal
  else begin
    Fr_GJTH_1:=TFr_GJTH_1.Create(Application);
    Fr_GJTH_1.ShowModal;
  end;
end;

procedure TFr_GJTH.RzEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  RzEdit2.Text:='';
  RzEdit3.Text:='';
  RzEdit4.Text:='';
  RzEdit5.Text:='';
  RzEdit6.Text:='';
  RzEdit7.Text:='';
  RzEdit8.Text:='';
  if key=#13 then begin
    ADOQuery2.SQL.Clear;
    ADOQuery2.SQL.Add('Select * from Purchase Where InvoiceID="'+RzEdit1.Text+'"');
    ADOQuery2.Open;
    if ADOQuery2.RecordCount=0 then begin
      ShowMessage('�޴˵���,��ע��˶�~~!'+#10#10+'˫�����������������~~!');
      RzEdit1.Text:='';
      RzEdit1.SetFocus;
      Exit;
    end else begin
      RzEdit3.Text:=ADOQuery2.FieldByName('BarCode').AsString;
      RzEdit4.Text:=ADOQuery2.FieldByName('GoodsName').AsString;
      RzEdit5.Text:=ADOQuery2.FieldByName('FeederName').AsString;
      RzEdit6.Text:=ADOQuery2.FieldByName('Unit').AsString;
      RzEdit7.Text:=ADOQuery2.FieldByName('PurchaseScalar').AsString;
      RzEdit8.Text:=ADOQuery2.FieldByName('PurchasePrice').AsString;
      RzEdit2.SetFocus;
    end;
  end;
end;

procedure TFr_GJTH.RzEdit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    Button1.Click;
  end;
  if (key<>#8)and(key<>#46)and(key<#48)or(key>#57) then
    key:=#0;
end;

procedure TFr_GJTH.Button1Click(Sender: TObject);
var
  i     : integer;
  UID,s : String;
begin
  //�ж����������ǷǺϷ�
  Try
    StrToCurr(RzEdit2.Text);
  Except
    ShowMessage('�˻��������ͷǷ�~~!'+#10#10+'����������~~!');
    RzEdit2.Text:='';
    RzEdit2.SetFocus;
    Exit;
  end;

  //�ж��˻������Ƿ�С�ڽ�������
  if StrToCurr(RzEdit2.Text)>StrToCurr(RzEdit7.Text) then begin
    ShowMessage('�˻��������ܴ��ڽ�������~~!'+#10#10+'����������~~!');
    RzEdit2.Text:='';
    RzEdit2.SetFocus;
    Exit;
  end;

  if StrToCurr(RzEdit2.Text)=0 then begin
    ShowMessage('�˻��������ܵ�����~~!'+#10#10+'����������~~!');
    RzEdit2.Text:='';
    RzEdit2.SetFocus;
    Exit;
  end;

  if RzEdit7.Text='' then begin
    ShowMessage('��д��Ŀ��ȫ~~!'+#10#10+'��������ɹ����Ż�˫�����������������~~!');
    RzEdit1.SetFocus;
    Exit;
  end;

  //ѯ���Ƿ����˿�
  s:='�˻�"'+ADOQuery2.FieldByName('GoodsName').AsString+'"'+RzEdit2.Text+
     ADOQuery2.FieldByName('Unit').AsString+'��?';
  if messagedlg(s,mtconfirmation,[mbyes,mbno],0)<>mryes then
    Exit;


  //���Ҳ��ظ�����С����
  for i:=1 to 9999 do
  begin
    UID:='U'+FormatdateTime('yymmdd', Now)+FormatFloat('0000',i);
    ADOQuery2.SQL.Clear;
    ADOQuery2.SQL.Add('Select * from UNStock Where InvoiceID="'+UID+'"');
    ADOQuery2.Open;
    if ADOQuery2.RecordCount=0 then
    begin
      Break;
    end;
  end;
  //��д�˻���¼
  ADOQuery1.Append;
  ADOQuery1.Edit;
  ADOQuery1.FieldByName('InvoiceID').AsString := UID;
  ADOQuery1.FieldByName('PID').AsString       := RzEdit1.Text;
  ADOQuery1.FieldByName('BarCode').AsString   := RzEdit3.Text;
  ADOQuery1.FieldByName('GoodsName').AsString := RzEdit4.Text;
  ADOQuery1.FieldByName('Unit').AsString      := RzEdit6.Text;
  ADOQuery1.FieldByName('UnitPrice').AsString := RzEdit8.Text;
  ADOQuery1.FieldByName('UNScalar').AsString  := RzEdit2.Text;
  ADOQuery1.FieldByName('UNDate').AsString    := FormatdateTime('yyyy-mm-dd tt', Now);
  ADOQuery1.FieldByName('UserName').AsString  := Fr_Main.Label5.Caption;
  ADOQuery1.Post;
  //�˼��ɹ���
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('Select * from Purchase Where InvoiceID="'+RzEdit1.Text+'"');
  ADOQuery2.Open;
  ADOQuery2.Edit;
  ADOQuery2.FieldByName('purchaseScalar').AsCurrency:=ADOQuery2.FieldByName('purchaseScalar').AsCurrency-StrToCurr(RzEdit2.Text);
  ADOQuery2.FieldByName('Remark').AsString:=UID;
  ADOQuery2.Post;
  //�˼����
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('Select * from Stock Where BarCode="'+RzEdit3.Text+'"');
  ADOQuery2.Open;
  ADOQuery2.Edit;
  ADOQuery2.FieldByName('STockScalar').AsCurrency:=ADOQuery2.FieldByName('STockScalar').AsCurrency-StrToCurr(RzEdit2.Text);
  ADOQuery2.Post;
  //��������
  RzEdit1.Text:='';
  RzEdit2.Text:='';
  RzEdit3.Text:='';
  RzEdit4.Text:='';
  RzEdit5.Text:='';
  RzEdit6.Text:='';
  RzEdit7.Text:='';
  RzEdit8.Text:='';
  RzEdit1.SetFocus;

end;

procedure TFr_GJTH.FormShow(Sender: TObject);
begin
  ADOQuery1.SQL.Clear;
  ADOQuery1.sql.Add('select * from UNStock where UNDate <=:A and UNDate >=:B');
  ADOQuery1.Parameters.ParamByName('A').Value:=formatdatetime('YYYY-MM-DD', Now)+' 23:59:59';
  ADOQuery1.Parameters.ParamByName('B').Value:=formatdatetime('YYYY-MM-DD', Now)+' 00:00:00';
  ADOQuery1.Open;
end;

procedure TFr_GJTH.Button2Click(Sender: TObject);
begin
  Fr_GJTH.Close;
end;

end.
