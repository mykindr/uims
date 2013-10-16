unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, Stockrec;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Stockrec1: TStockrec;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
var
  I, R: Integer;
begin
  timer1.Interval := 3000;
  StringGrid1.RowCount := Stockrec1.StockData(0, '����', '').Count;
  StringGrid1.Rows[0].DelimitedText :=
    '����,����,����,��,���,���,����,����,����,�Ƿ�,���';
  for I := 0 to StringGrid1.RowCount - 1 do // Iterate
  begin
    R := I + 1;
    StringGrid1.Cells[0, R] := Stockrec1.StockData(R, '����', '').AsString;
    StringGrid1.Cells[1, R] := Stockrec1.StockData(R, '����', '').AsString;
    StringGrid1.Cells[2, R] := Stockrec1.StockData(R, '����', '').AsString;
    StringGrid1.Cells[3, R] := Stockrec1.StockData(R, '��', '').AsString;
    StringGrid1.Cells[4, R] := Stockrec1.StockData(R, '���', '').AsString;
    StringGrid1.Cells[5, R] := Stockrec1.StockData(R, '���', '').AsString;
    StringGrid1.Cells[6, R] := Stockrec1.StockData(R, '����', '').AsString;
    StringGrid1.Cells[7, R] := Stockrec1.StockData(R, '����', '').AsString;
    StringGrid1.Cells[8, R] := Stockrec1.StockData(R, '����', '').AsString;
    StringGrid1.Cells[9, R] := Stockrec1.StockData(R, '�Ƿ�', '').AsString;
    StringGrid1.Cells[10, R] := Stockrec1.StockData(R, '���', '').AsString;
  end; // for

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Timer1.Interval := 50;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Stockrec1.Receive := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Stockrec1.Receive := False;
end;

end.

