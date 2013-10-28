unit FIND_WJD_ALL;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids,
  DBGrids;

type
  TForm16 = class(TForm)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Button2: TButton;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label3: TLabel;
    Button1: TButton;
    DBText1: TDBText;
    DBText2: TDBText;
    Query1: TQuery;
    Query2: TQuery;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form16: TForm16;

implementation

{$R *.DFM}

procedure TForm16.Button2Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  Close;
end;

procedure TForm16.FormShow(Sender: TObject);
begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select ����������,��Ʊ����,�쵥������,���ڽ����Ԫ Ӧ�������,�ջ�����Ԫ �ѽ������,���ڽ����Ԫ-�ջ�����Ԫ δ�����ս��,�������� ��ע from hxdk.db a,system.db b where (�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today1)');
    Query1.ParamByName('Today1').AsDateTime:=Date;
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select Count(*) ����,sum(���ڽ����Ԫ-�ջ�����Ԫ) ��� from hxdk.db a,system.db b where (�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today2)');
    Query2.ParamByName('Today2').AsDateTime:=Date;
    Query2.Open;
end;

end.
