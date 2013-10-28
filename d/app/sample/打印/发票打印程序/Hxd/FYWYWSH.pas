unit FYWYWSH;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids, DBGrids,
  Dialogs, DBEditK;

type
  TPrintYWYNoGetForm = class(TForm)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Button2: TButton;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Query1: TQuery;
    Query2: TQuery;
    DBText1: TDBText;
    DBText2: TDBText;
    EditK1: TEditK;
    procedure Button2Click(Sender: TObject);
    procedure EditK1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  n: integer;
  m: longint;
  PrintYWYNoGetForm: TPrintYWYNoGetForm;

implementation
uses
  PREVIEW_WSH_YWY;

{$R *.DFM}

procedure TPrintYWYNoGetForm.Button2Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  Close;
end;

procedure TPrintYWYNoGetForm.EditK1Exit(Sender: TObject);
var
  S1, S2: string;
begin
  if Editk1.Text <> '' then
  begin
    S1 := 'select ����������,��Ʊ����,Ʒ��,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ���,Ӧ�ջ�����,ҵ��Ա����,�������� ��ע from hxdk.db where ((((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ))and(���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:T3))and(ҵ��Ա=:y1)'; //����δ�ջ��¼
    s2 := 'select Count(*) ����,sum(���ڽ����Ԫ-�ջ�����Ԫ) ��� from hxdk.db where ((((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:Today4))and(ҵ��Ա=:ywy2)'; //����δ�ջ�����
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add(s1);
    Query1.ParamByName('T3').AsDateTime := Date;
    Query1.ParamByName('y1').AsString := Editk1.Text;
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add(s2);
    Query2.ParamByName('Today4').AsDateTime := Date;
    Query2.ParamByName('ywy2').AsString := Editk1.Text;
    Query2.Open;
  end;
  Button1.SetFocus;
end;

procedure TPrintYWYNoGetForm.FormShow(Sender: TObject);
begin
  Editk1.SetFocus;
end;

procedure TPrintYWYNoGetForm.Button1Click(Sender: TObject);
begin
  try
    PrintNoCancel := TPrintNoCancel.Create(Application);
    PrintNoCancel.QuickRep1.Preview;
  finally
    PrintNoCancel.Free;
  end;
end;

end.
