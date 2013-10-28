unit AutoCtl;
 {���������ʾ��ʹ��Word��Ϊ�Զ�����������Delphi���Զ�������������ν�һ����ѯ������뵽word�ĵ���}

interface

uses Windows, Classes, SysUtils, Graphics, Forms, Controls, DB, DBGrids,
  DBTables, Grids, StdCtrls, ExtCtrls, ComCtrls, Dialogs;

type
  TForm1 = class(TForm)
    Query1: TQuery;
    Panel1: TPanel;
    InsertBtn: TButton;
    Query1Company: TStringField;
    Query1OrderNo: TFloatField;
    Query1SaleDate: TDateTimeField;
    Edit1: TEdit;
    Label1: TLabel;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Query2: TQuery;
    DataSource1: TDataSource;
    procedure InsertBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

uses ComObj;

{$R *.dfm}
//Download by http://www.codefans.net
procedure TForm1.InsertBtnClick(Sender: TObject);
var
  S, Lang: string;
  MSWord: Variant;
  L: Integer;
begin
  try
    MsWord := CreateOleObject('Word.Basic');
  except
    ShowMessage('��������Word.');
    Exit;
  end;
  try
    { ����Ӧ�ò���.���������Ӣ�ĺͷ��İ�� Word����ͬ�� }
    Lang := MsWord.AppInfo(Integer(16));
  except
    try
      { �Ե��İ��Word������������Ƿ����ġ�}
      Lang := MsWord.AnwInfo(Integer(16));
    except
      { ���������̲����ڣ�����һ����ͬ��Word����汾��}
       ShowMessage('Microsoft Word�汾���ǵ���,���Ļ�Ӣ�İ�.');
       Exit;
    end;
  end;
  with Query1 do
  begin
    Form1.Caption := Lang;
    Close;
    Params[0].Text := '%'+Edit1.Text+'%';
    Open;
    try
      First;
      L := 0;
      while not EOF do
      begin
        S := S + Query1Company.AsString + ListSeparator +
          Query1OrderNo.AsString + ListSeparator + Query1SaleDate.AsString + #13;
        Inc(L);
        Next;
      end;
       if (Lang = 'English (US)') or (Lang = 'English (United States)') or
          (Lang = 'English (UK)') or (Lang = 'German (Standard)') or
          (Lang = 'French (Standard') then
        begin
        MsWord.AppShow;
        MSWord.FileNew;
        MSWord.Insert(S);
        MSWord.LineUp(L, 1);
        MSWord.TextToTable(ConvertFrom := 2, NumColumns := 3);
       end;
        if Lang = 'Fran�ais' then
       begin
         MsWord.FenAppAfficher;
         MsWord.FichierNouveau;
         MSWord.Insertion(S);
         MSWord.LigneVersHaut(L, 1);
         MSWord.TexteEnTableau(ConvertirDe := 2, NbColonnesTableau := 3);
      end;
       if (Lang = 'German (De)') or (Lang = 'Deutsch') then
       begin
         MsWord.AnwAnzeigen;
         MSWord.DateiNeu;
         MSWord.Einf�gen(S);
         MSWord.ZeileOben(L, 1);
         MSWord.TextInTabelle(UmWandelnVon := 2, AnzSpalten := 3);
      end;
    finally
        {������Word�ڴ˲���}
        MsWord.AppShow;
        MSWord.FileNew;
        MSWord.Insert(S);
        MSWord.LineUp(L, 1);
        MSWord.TextToTable(ConvertFrom := 2, NumColumns := 3);
      Close;
    end;
  end;
end;

end.
