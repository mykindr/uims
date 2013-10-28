unit FALLJD;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids, DBGrids;

type
  THandInAllForm = class(TForm)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    DBGrid1: TDBGrid;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Query1: TQuery;
    Query2: TQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBText1: TDBText;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  HandInAllForm: THandInAllForm;

implementation

{$R *.DFM}


procedure THandInAllForm.Button1Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  close;
end;

procedure THandInAllForm.ComboBox1Change(Sender: TObject);
begin
  if Combobox1.text = 'ȫ���ѽ���' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select ����������,��Ʊ����,�쵥������,���ڽ����Ԫ Ӧ�������,�ջ�����Ԫ �ѽ������,���ڽ����Ԫ-�ջ�����Ԫ δ������� from hxdk.db where (�Ƿ񽻵�="y")or(�Ƿ񽻵�="Y")');
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select Count(*) ���� from hxdk.db where (�Ƿ񽻵�="y")or(�Ƿ񽻵�="Y")');
    Query2.Open;
  end;

  if Combobox1.text = 'ȫ��δ����' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select ����������,��Ʊ����,�쵥������,���ڽ����Ԫ Ӧ�������,�ջ�����Ԫ �ѽ������,���ڽ����Ԫ-�ջ�����Ԫ δ������� from hxdk.db where �Ƿ񽻵�=""');
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select Count(*) ���� from hxdk.db where �Ƿ񽻵�=""');
    Query2.Open;
  end;

  if Combobox1.text = '����δ����' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select ����������,��Ʊ����,�쵥������,���ڽ����Ԫ Ӧ�������,�ջ�����Ԫ �ѽ������,���ڽ����Ԫ-�ջ�����Ԫ δ�����ս�� from hxdk.db a,system.db b where (�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today1)');
    Query1.ParamByName('Today1').AsDateTime := Date;
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select Count(*) ���� from hxdk.db a,system.db b where (�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today2)');
    Query2.ParamByName('Today2').AsDateTime := Date;
    Query2.Open;
  end;
end;

end.
