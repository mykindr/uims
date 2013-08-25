unit Unit16;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  Dialogs, DB, ADODB, Buttons, Grids, DBGrids, ExtCtrls,
  INIFiles, StdCtrls;

type
  TQHD_PT = class(TForm)
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
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton2Click(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key:
      Char);
    procedure FormShow(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key:
      Char);
  private
    { Private declarations }
  public
    procedure c1;

    { Public declarations }
  end;

var
  QHD_PT: TQHD_PT;

implementation

uses Unit4, Unit2;

{$R *.dfm}

procedure TQHD_PT.SpeedButton1Click(Sender: TObject);
begin
  QHD_PT.Close;
end;

procedure TQHD_PT.FormKeyDown(Sender: TObject; var Key:
  Word;
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

{ȷ��ѡ��ʱ�����Ƽ�¼ȥAftersellmain��}

procedure TQHD_PT.SpeedButton2Click(Sender: TObject);
begin
  //�����ӡ
  if messagedlg('ȷ�ϴ�ӡ��', mtconfirmation, [mbyes,
    mbno], 0) = mryes then
  begin

    //���ݵ�ǰ���� �����F6��ݼ�������ͬ
    Main_T.ADOQuerySQL.SQL.Clear;
    Main_T.ADOQuerySQL.SQL.Add('insert into aftersellmains(tid,custid,custstate,custname,shopname,custtel,custaddr,yingshou,shishou,sname,stel,saddress,payment,status,uname,cdate,remark,created_at,updated_at) values("' + Main_T.Label26.Caption + '","","' + Main_T.edt8.Text + '","' +
      Main_T.edt1.Text + '","' +
      Main_T.RzEdit7.Text + '","' + Main_T.edt2.Text + '","' +
      Main_T.edt3.Text + '","0","0","' +
      Main_T.edt4.Text + '","' + Main_T.edt6.Text + '","' + Main_T.edt5.Text
      + '","' + Main_T.cbb1.Text +
      '","0","' + Main_T.Label19.Caption + '",now(),"' +
      Main_T.mmo1.Lines.GetText +
      '",now(),now()) on duplicate key update custstate="' +
      Main_T.edt8.Text +
      '",custname="' + Main_T.edt1.Text + '",shopname="' +
      Main_T.RzEdit7.Text +
      '",custtel="' + Main_T.edt2.Text + '",custaddr="' +
      Main_T.edt3.Text + '",sname="' +
      Main_T.edt4.Text + '",stel="' + Main_T.edt6.Text +
      '",saddress="' + Main_T.edt5.Text +
      '",payment="' + Main_T.cbb1.Text + '",uname="' +
      Main_T.Label19.Caption + '",remark="'
      + Main_T.mmo1.Lines.GetText + '",updated_at=now()');
    Main_T.ADOQuerySQL.ExecSQL;

    {���������}
    Main_T.edt1.Text := '';
    Main_T.edt2.Text := '';
    Main_T.edt3.Text := '';
    Main_T.edt7.Text := '';
    Main_T.edt8.Text := '';
    Main_T.RzEdit7.Text := '';

    Main_T.edt4.Text := '';
    Main_T.edt5.Text := '';
    Main_T.edt6.Text := '';

    Main_T.cbb1.Text := '';
    Main_T.mmo1.Text := '';

    //�ָ���ʷ������Ϣ

    //���ò�����
    Main_T.reprint := True;
    Main_T.uid := Main_T.Labeluid.Caption;
    Main_T.name := Main_T.Label19.Caption;

    Main_T.Labeluid.Caption := ADOQuery1.FieldByName('uid').AsString;
    Main_T.Label19.Caption := ADOQuery1.FieldByName('uname').AsString;

    Main_T.Label26.Caption :=
      ADOQuery1.FieldByName('tid').AsString;
    Main_T.QH1;
    Main_T.QH2;

    {�ָ��ͻ�����������Ϣ}
    Main_T.edt1.Text :=
      ADOQuery1.FieldByName('custname').AsString;
    Main_T.edt2.Text :=
      ADOQuery1.FieldByName('custtel').AsString;
    Main_T.edt3.Text :=
      ADOQuery1.FieldByName('custaddr').AsString;
    Main_T.edt7.Text :=
      ADOQuery1.FieldByName('custid').AsString;
    Main_T.edt8.Text :=
      ADOQuery1.FieldByName('custstate').AsString;
    Main_T.RzEdit7.Text :=
      ADOQuery1.FieldByName('shopname').AsString;

    Main_T.Labelsid.Caption := ADOQuery1.FieldByName('sid').AsString;

    Main_T.edt4.Text :=
      ADOQuery1.FieldByName('sname').AsString;
    Main_T.edt5.Text :=
      ADOQuery1.FieldByName('stel').AsString;
    Main_T.edt6.Text :=
      ADOQuery1.FieldByName('saddress').AsString;

    Main_T.cbb1.Text :=
      ADOQuery1.FieldByName('payment').AsString;
    Main_T.mmo1.Text :=
      ADOQuery1.FieldByName('remark').AsString;

    //���ᴰ�ڣ���ֹ�޸�������ݡ�����ֱ�Ӵ�ӡ

    SpeedButton1.Click;

  end;

  //�رյ�ǰ����
  SpeedButton1.Click;
end;

procedure TQHD_PT.c1;
begin
  //���û�йҵ��������˳�
  if ADOQuery1.RecordCount < 1 then
  begin
    ShowMessage('�ҵ���û�м�¼~~!');
    QHD_PT.Close;
  end
end;

procedure TQHD_PT.DBGrid1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    SpeedButton2.Click;
  end;
end;

{��ѯ���ۼ�¼��}

procedure TQHD_PT.FormShow(Sender: TObject);
begin
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  //Ĭ��ֻ�ܲ�����ĵ���
  ADOQuery1.SQL.Add('select * from selllogmains where DATE_FORMAT(cdate,"%y%m%d")=DATE_FORMAT(now(),"%y%m%d") and status');
  ADOQuery1.Active := True;
end;

procedure TQHD_PT.Edit1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    {���յ���ģ����ѯ}
    ADOQuery1.Close;
    ADOQuery1.SQL.Clear;
    //Ĭ��ֻ�ܲ�����ĵ���
    ADOQuery1.SQL.Add('select * from selllogmains where DATE_FORMAT(cdate,"%y%m%d")=DATE_FORMAT(now(),"%y%m%d") and status and slid like "%' + Edit1.Text + '%"');
    ADOQuery1.Active := True;
  end;

end;

end.
