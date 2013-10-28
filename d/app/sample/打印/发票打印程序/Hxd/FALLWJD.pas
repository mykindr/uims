unit FALLWJD;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids,
  DBGrids;

type
  TPrintNoHandInAllForm = class(TForm)
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
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PrintNoHandInAllForm: TPrintNoHandInAllForm;

implementation
uses
  PREVIEW_WJD_ALL;

{$R *.DFM}

procedure TPrintNoHandInAllForm.Button2Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  Close;
end;

procedure TPrintNoHandInAllForm.FormShow(Sender: TObject);
begin
  Query1.Close;
  Query1.SQL.Clear;
  Query1.SQL.Add('select ����������,��Ʊ����,Ʒ��,���ڽ����Ԫ Ӧ�ջ���,a.�쵥����+b.�����뽻������ ��������,�쵥������,�������� ��ע from hxdk.db a,system.db b where (�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today1)');
  Query1.ParamByName('Today1').AsDateTime := Date;
  Query1.Open;
  Query2.Close;
  Query2.SQL.Clear;
  Query2.SQL.Add('select Count(*) ����,sum(���ڽ����Ԫ) ��� from hxdk.db a,system.db b where (�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today2)');
  Query2.ParamByName('Today2').AsDateTime := Date;
  Query2.Open;
end;

procedure TPrintNoHandInAllForm.Button1Click(Sender: TObject);
begin
  try
    PrintNoHandInAll := TPrintNoHandInAll.Create(Application);
    PrintNoHandInAll.QuickRep1.Preview;
  finally
    PrintNoHandInAll.Free;
  end;
end;

end.
