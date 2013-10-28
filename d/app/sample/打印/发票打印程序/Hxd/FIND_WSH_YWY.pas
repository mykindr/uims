unit FIND_WSH_YWY;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids, DBGrids,
  Dialogs,PREVIEW_WSH_YWY, DBEditK;

type
  TForm15 = class(TForm)
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
    procedure Button1Click(Sender: TObject);
    procedure EditK1Exit(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  n:integer;
  m:longint;
  Form14: TForm14;

implementation

{$R *.DFM}

procedure TForm15.Button1Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  Close;
end;

procedure TForm15.EditK1Exit(Sender: TObject);
var
  S1,S2:String;
begin
  if Editk1.Text<>'' then
  begin
    S1:='select ����������,��Ʊ����,ҵ��Ա����,���ڽ����Ԫ Ӧ�ջ���,�ջ�����Ԫ ���ջ���,���ڽ����Ԫ-�ջ�����Ԫ δ�ջ���,�������� ��ע from hxdk.db where ((((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ))and(���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:Today3))and(ҵ��Ա=:ywy1)';//����δ�ջ��¼
    s2:='select Count(*) ����,sum(���ڽ����Ԫ-�ջ�����Ԫ) ��� from hxdk.db where ((((�ջ�����Ԫ=0)or(�ջ�����Ԫ<���ڽ����Ԫ)) and (���ڽ����Ԫ<>0))and(Ӧ�ջ�����<:Today4))and(ҵ��Ա=:ywy2)';//����δ�ջ�����
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add(s1);
    Query1.ParamByName('Today3').AsDateTime:=Date;
    Query1.ParamByName('ywy1').AsString:=Editk1.Text;
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add(s2);
    Query2.ParamByName('Today4').AsDateTime:=Date;
    Query2.ParamByName('ywy2').AsString:=Editk1.Text;
    Query2.Open;
  end;
end;

end.
