unit FYWYSH;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids, DBGrids,
  Dialogs, DBEditK;

type
  TGetYWYForm = class(TForm)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Button1: TButton;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditK1: TEditK;
    Query1: TQuery;
    Query2: TQuery;
    DBText1: TDBText;
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
  n: integer;
  m: longint;
  GetYWYForm: TGetYWYForm;

implementation

{$R *.DFM}

procedure TGetYWYForm.Button1Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  close;
end;

procedure TGetYWYForm.ComboBox1Change(Sender: TObject);
var
  T1, T2, S1, S2: string;
begin
  if EditK1.Text <> '' then
  begin
    if Combobox1.Text = 'ȫ�����ջ�' then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add('select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where ((�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ))and(ҵ��Ա=:ywy1)');
      Query1.ParamByName('ywy1').AsString := Editk1.Text;
      Query1.Open;
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add('select Count(*) ���� from hxdk.db where ((�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ))and(ҵ��Ա=:ywy2)');
      Query2.ParamByName('ywy2').AsString := Editk1.Text;
      Query2.Open;
    end;

    T1 := 'select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where (((�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ))and(�ջ�����>Ӧ�ջ�����))and(ҵ��Ա=:ywy1)';
    T2 := 'select Count(*) ���� from hxdk.db where (((�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ))and(�ջ�����>Ӧ�ջ�����))and(ҵ��Ա=:ywy2)';
    if Combobox1.text = '�������ջ�' then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(T1);
      Query1.ParamByName('ywy1').AsString := Editk1.Text;
      Query1.Open;
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add(T2);
      Query2.ParamByName('ywy2').AsString := Editk1.Text;
      Query2.Open;
    end;

    if Combobox1.text = 'ȫ��δ�ջ�' then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add('select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where (((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0))and(ҵ��Ա=:ywy1)');
      Query1.ParamByName('ywy1').AsString := Editk1.Text;
      Query1.Open;
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add('select count(*) ���� from hxdk.db where (((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0))and(ҵ��Ա=:ywy2)');
      Query2.ParamByName('ywy2').AsString := Editk1.Text;
      Query2.Open;
    end;

    S1 := 'select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where ((((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ))and(���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:Today3))and(ҵ��Ա=:ywy1)'; //����δ�ջ��¼
    s2 := 'select Count(*) ���� from hxdk.db where ((((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:Today4))and(ҵ��Ա=:ywy2)'; //����δ�ջ�����
    if Combobox1.text = '����δ�ջ�' then
    begin
      Query1.Close;
      Query1.SQL.Clear;
      Query1.SQL.Add(s1);
      Query1.ParamByName('Today3').AsDateTime := Date;
      Query1.ParamByName('ywy1').AsString := Editk1.Text;
      Query1.Open;
      Query2.Close;
      Query2.SQL.Clear;
      Query2.SQL.Add(s2);
      Query2.ParamByName('Today4').AsDateTime := Date;
      Query2.ParamByName('ywy2').AsString := Editk1.Text;
      Query2.Open;
    end;
  end;
end;


procedure TGetYWYForm.FormShow(Sender: TObject);
begin
  Editk1.SetFocus;
end;

procedure TGetYWYForm.EditK1Exit(Sender: TObject);
begin
  ComboBox1.SetFocus;
end;

end.
