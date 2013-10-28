unit FYWYWJD;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, ExtCtrls, Grids, DBGrids,
  Dialogs, DBEditK;

type
  TPrintLDRNoHandInForm = class(TForm)
    ScrollBox: TScrollBox;
    Panel1: TPanel;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Button1: TButton;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Button3: TButton;
    Query1: TQuery;
    Query2: TQuery;
    EditK1: TEditK;
    DBText1: TDBText;
    DBText2: TDBText;
    procedure Button1Click(Sender: TObject);
    procedure EditK1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  PrintLDRNoHandInForm: TPrintLDRNoHandInForm;

implementation
uses
  PREVIEW_WJD_YWY;

{$R *.DFM}

procedure TPrintLDRNoHandInForm.Button1Click(Sender: TObject);
begin
  Query1.Close;
  Query2.Close;
  close;
end;

procedure TPrintLDRNoHandInForm.EditK1Exit(Sender: TObject);
begin
  if Editk1.Text <> '' then
  begin
    Query1.Close;
    Query1.SQL.Clear;
    Query1.SQL.Add('select ����������,��Ʊ����,Ʒ��,���ڽ����Ԫ Ӧ�ջ���,a.�쵥����+b.�����뽻������ ��������,�쵥������,�������� ��ע from hxdk.db a,system.db b where ((�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today1))and(�쵥��=:ldr1)');
    Query1.ParamByName('Today1').AsDateTime := Date;
    Query1.ParamByName('ldr1').AsString := Editk1.Text;
    Query1.Open;
    Query2.Close;
    Query2.SQL.Clear;
    Query2.SQL.Add('select Count(*) ����,sum(���ڽ����Ԫ) ��� from hxdk.db a,system.db b where ((�Ƿ񽻵�="")and(a.�쵥����+b.�����뽻������<:Today2))and(�쵥��=:ldr2)');
    Query2.ParamByName('Today2').AsDateTime := Date;
    Query2.ParamByName('ldr2').AsString := Editk1.Text;
    Query2.Open;
  end;
  Button1.SetFocus
end;

procedure TPrintLDRNoHandInForm.FormShow(Sender: TObject);
begin
  Editk1.SetFocus;
end;

procedure TPrintLDRNoHandInForm.Button3Click(Sender: TObject);
begin
  try
    PrintNoHandInLDR := TPrintNoHandInLDR.Create(Application);
    PrintNoHandInLDR.QuickRep1.Preview;
  finally
    PrintNoHandInLDR.Free;
  end;
end;

end.
