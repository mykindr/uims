unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Buttons, Grids, DBGrids, ExtCtrls, INIFiles, StdCtrls;

type
  TQC_S = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure c1;
    { Public declarations }
  end;

var
  QC_S: TQC_S;

implementation

uses Unit2;

{$R *.dfm}

procedure TQC_S.SpeedButton1Click(Sender: TObject);
begin
  QC_S.Close;
end;

procedure TQC_S.FormKeyDown(Sender: TObject; var Key: Word;
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

procedure TQC_S.SpeedButton2Click(Sender: TObject);
begin
  {�ָ��ͻ�}
  Main.edt1.Text := DBGrid1.DataSource.DataSet.FieldByName('cname').AsString;
  Main.edt2.Text := DBGrid1.DataSource.DataSet.FieldByName('tel').AsString;
  Main.edt3.Text := DBGrid1.DataSource.DataSet.FieldByName('address').AsString;
  Main.edt7.Text := DBGrid1.DataSource.DataSet.FieldByName('cid').AsString;
  Main.edt8.Text := DBGrid1.DataSource.DataSet.FieldByName('state').AsString;
  Main.RzEdit7.Text := DBGrid1.DataSource.DataSet.FieldByName('shopname').AsString;
  SpeedButton1.Click;
end;

procedure TQC_S.c1;
begin
  //���û�пͻ��������˳�
  if ADOQuery1.RecordCount < 1 then
  begin
    ShowMessage('û���ҵ��ͻ���Ϣ~~!');
    QC_S.Close;
  end
end;

procedure TQC_S.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    SpeedButton2.Click;
  end;
end;

procedure TQC_S.FormShow(Sender: TObject);
begin
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('Select * from customers where state like "%' + Main.edt8.Text + '%"');
  ADOQuery1.Active := True;
end;

end.
