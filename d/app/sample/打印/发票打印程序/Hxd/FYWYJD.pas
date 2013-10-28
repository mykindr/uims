unit FYWYJD;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids, DBGrids,
  Dialogs, DBEditK;

type
  THandInLDRForm = class(TForm)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Button1: TButton;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Query1: TQuery;
    Query2: TQuery;
    DBText1: TDBText;
    EditK1: TEditK;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditK1Exit(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  HandInLDRForm: THandInLDRForm;

implementation

{$R *.DFM}

procedure THandInLDRForm.Button1Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  close;
end;

procedure THandInLDRForm.ComboBox1Change(Sender: TObject);
begin
  if EditK1.Text <> '' then
  begin
    if Combobox1.text = 'ȫ���ѽ���' then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add('select ����������,��Ʊ����,�쵥������,���ڽ����Ԫ Ӧ�������,�ջ�����Ԫ �ѽ������,���ڽ����Ԫ-�ջ�����Ԫ δ������� from hxdk.db where ((�Ƿ񽻵�="y")or(�Ƿ񽻵�="Y"))and(�쵥��=:ldr1)');
      Query1.ParamByName('ldr1').AsString := Editk1.Text;
      Query1.Open;
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add('select Count(*) ���� from hxdk.db where ((�Ƿ񽻵�="y")or(�Ƿ񽻵�="Y"))and(�쵥��=:ldr2)');
      Query2.ParamByName('ldr2').AsString := Editk1.Text;
      Query2.Open;
    end;

    if Combobox1.text = 'ȫ��δ����' then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add('select ����������,��Ʊ����,�쵥������,���ڽ����Ԫ Ӧ�������,�ջ�����Ԫ �ѽ������,���ڽ����Ԫ-�ջ�����Ԫ δ������� from hxdk.db where (�Ƿ񽻵�="")and(�쵥��=:ldr1)');
      Query1.ParamByName('ldr1').AsString := Editk1.Text;
      Query1.Open;
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add('select Count(*) ���� from hxdk.db where (�Ƿ񽻵�="")and(�쵥��=:ldr2)');
      Query2.ParamByName('ldr2').AsString := Editk1.Text;
      Query2.Open;
    end;

    if Combobox1.text = '����δ����' then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add('select ����������,��Ʊ����,�쵥������,���ڽ����Ԫ Ӧ�������,�ջ�����Ԫ �ѽ������,���ڽ����Ԫ-�ջ�����Ԫ δ�����ս�� from hxdk.db a,system.db b where ((�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today1))and(�쵥��=:ldr1)');
      Query1.ParamByName('Today1').AsDateTime := Date;
      Query1.ParamByName('ldr1').AsString := Editk1.Text;
      Query1.Open;
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add('select Count(*) ���� from hxdk.db a,system.db b where ((�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today2))and(�쵥��=:ldr2)');
      Query2.ParamByName('Today2').AsDateTime := Date;
      Query2.ParamByName('ldr2').AsString := Editk1.Text;
      Query2.Open;
    end;
  end;
end;


procedure THandInLDRForm.FormShow(Sender: TObject);
begin
  Editk1.SetFocus;
end;

procedure THandInLDRForm.EditK1Exit(Sender: TObject);
begin
  ComboBox1.SetFocus;
end;

end.
