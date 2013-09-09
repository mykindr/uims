unit Unit20;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  Dialogs, DB, ADODB, Buttons, Grids, DBGrids, ExtCtrls,
  INIFiles, StdCtrls;

type
  TQPT = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    ADOQuerySQL: TADOQuery;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key:
      Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure c1;
    { Public declarations }
  end;

var
  QPT: TQPT;

implementation

uses Unit2;

{$R *.dfm}

procedure TQPT.SpeedButton1Click(Sender: TObject);
begin
  QPT.Close;
end;

procedure TQPT.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: SpeedButton1.Click;
    VK_SPACE: SpeedButton2.Click;

    VK_UP:
      begin
        DBGrid1.SetFocus;
      end;

    VK_DOWN:
      begin
        DBGrid1.SetFocus;
      end;
  end;
end;

procedure TQPT.SpeedButton2Click(Sender: TObject);
begin
  {�ָ���Ʒ���}
  Main.RzEdit4.Text :=
    DBGrid1.DataSource.DataSet.FieldByName('pid').AsString;

  SpeedButton1.Click;
end;

procedure TQPT.c1;
begin
  //���û�пͻ��������˳�
  if ADOQuery1.RecordCount < 1 then
  begin
    ShowMessage('û���ҵ����˲���Ϣ~~!');
    QPT.Close;
  end
end;

procedure TQPT.DBGrid1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    SpeedButton2.Click;
  end;
end;

procedure TQPT.FormShow(Sender: TObject);
begin

  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('select d.tid,d.pid,barcode,d.goodsname,d.size,d.color,d.volume,d.unit,d.inprice,d.pfprice,d.amount,');
  ADOQuery1.SQL.Add('d.ramount,d.bundle,d.additional,d.discount,d.remark from aftersellmains m, afterselldetails d where not(d.status) and d.dtype="ά��" and d.ramount>0 and m.tid=d.tid and m.dtype="�Ѵ���" and m.custtel="' + Main.edt2.Text + '"');
  ADOQuery1.Active := True;
  {��ʽ��С����ʾ}
  //TFloatField(DBGrid1.DataSource.DataSet.FieldByName('volume')).DisplayFormat := '0.00';
end;

end.
