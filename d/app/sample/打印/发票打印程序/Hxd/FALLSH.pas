unit FALLSH;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids, DBGrids;

type
  TGetAllForm = class(TForm)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    DataSource1: TDataSource;
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
    DBText1: TDBText;
    DataSource2: TDataSource;
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  n: integer;
  m: longint;
  GetAllForm: TGetAllForm;

implementation

{$R *.DFM}

procedure TGetAllForm.ComboBox1Change(Sender: TObject);
var
  T1, T2, S1, S2: string;
begin
  if Combobox1.text = 'ȫ�����ջ�' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where (�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ)');
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select Count(*) ���� from hxdk.db where (�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ)');
    Query2.Open;
  end;

  T1 := 'select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where ((�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ))and(�ջ�����>Ӧ�ջ�����)';
  T2 := 'select Count(*) ���� from hxdk.db where ((�ջ�����Ԫ<>0)and(�ջ�����Ԫ=���ڽ����Ԫ))and(�ջ�����>Ӧ�ջ�����)';
  if Combobox1.text = '�������ջ�' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add(T1);
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add(T2);
    Query2.Open;
  end;

  if Combobox1.text = 'ȫ��δ�ջ�' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where ((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0)');
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select count(*) ���� from hxdk.db where ((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0)');
    Query2.Open;
  end;

  S1 := 'select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ��� from hxdk.db where (((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:Today3)'; //����δ�ջ��¼
  s2 := 'select Count(*) ���� from hxdk.db where (((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:Today4)'; //����δ�ջ�����
  if Combobox1.text = '����δ�ջ�' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add(s1);
    Query1.ParamByName('Today3').AsDateTime := Date;
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add(s2);
    Query2.ParamByName('Today4').AsDateTime := Date;
    Query2.Open;
  end;

end;


procedure TGetAllForm.Button1Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  Close;
end;

end.
