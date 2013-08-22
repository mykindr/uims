unit Unit22;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ExtCtrls, INIFiles,
  RzForms;

type
  TSHQR = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    RzEdit1: TRzEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RzFormShape1: TRzFormShape;
    CheckBox1: TCheckBox;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzEdit1KeyDown(Sender: TObject; var Key:
      Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure JZ;
    { Public declarations }
  end;

var
  SHQR: TSHQR;
  Count: Integer;
implementation

uses Unit6, Unit8, Unit4;

{$R *.dfm}

procedure TSHQR.FormCreate(Sender: TObject);
var
  vIniFile: TIniFile;
begin
  vIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))
    +
    'Config.Ini');
  Label2.Caption := Main_T.Label7.Caption;
  CheckBox1.Checked := vIniFile.ReadBool('System', 'PB',
    True);

  {����֧����ʽ��д�ܵ����}
  if Main_T.cbb1.Text <> '�ֽ�' then
  begin
    RzEdit1.Text := Label2.Caption;
  end;
end;

procedure TSHQR.FormKeyDown(Sender: TObject; var Key:
  Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: SHQR.Close;
    VK_F1:
      begin
        if CheckBox1.Checked then
        begin
          CheckBox1.Checked := False;
          RzEdit1.SetFocus;
        end
        else
        begin
          CheckBox1.Checked := True;
          RzEdit1.SetFocus;
        end;
      end;
    VK_F2:
      begin
        if MoLing <> nil then
        begin
          MoLing.RzEdit1.Text := Label2.Caption;
          MoLing.RzEdit1.SelectAll;
          MoLing.ShowModal;
        end
        else
        begin
          MoLing := TMoLing.Create(Application);
          MoLing.RzEdit1.Text := Label2.Caption;
          MoLing.RzEdit1.SelectAll;
          MoLing.ShowModal;
        end;
      end;
    {
    VK_F3:
      begin
        RzEdit1.Text := Label2.Caption;
        if Card <> nil then
          Card.ShowModal
        else
        begin
          Card := TCard.Create(Application);
          Card.ShowModal;
        end;
      end;
      }
  end;
end;

{���˲���}

procedure TSHQR.jz;
var
  vIniFile: TIniFile;
begin
  vIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))
    +
    'Config.Ini');
  //�������ݼ��
  try
    begin
      StrToCurr(RzEdit1.Text); //�յ��Ľ��
    end;
  except
    begin
      ShowMessage('����Ƿ��ַ�~~!');
      RzEdit1.Text := '';
      RzEdit1.SetFocus;
      Exit;
    end;
  end;

  if Main_T.cbb1.Text = '' then
  begin
    ShowMessage('��ѡ��֧����ʽ~~!');
    SHQR.Close;
    Main_T.RzEdit4.SetFocus;
    Exit;
  end;

  //���ʹ���ֽ�֧��������������Ƿ�С��Ӧ����
  if Main_T.cbb1.Text = '�ֽ�' then
  begin
    if StrToCurr(RzEdit1.Text) - StrToCurr(Label2.Caption)
      < 0 then
    begin
      ShowMessage('�ֽ�֧��ʱ���յ�����С��Ӧ�տ�~~!');
      RzEdit1.Text := '';
      RzEdit1.SetFocus;
      Exit;
    end;

    //��������
    Label7.Caption := FormatFloat('0.00',
      StrToCurr(RzEdit1.Text) -
      StrToCurr(Label2.Caption));
  end;

  //��������
  RzEdit1.ReadOnly := True;
  //��ʾ��ʾ��
  Label9.Visible := True;

  //д�����ڼ�¼
  Main_T.Label14.Caption := FormatFloat('0.00',
    StrToCurr(Label2.Caption));
  Main_T.Label15.Caption := FormatFloat('0.00',
    StrToCurr(RzEdit1.Text));
  Main_T.Label16.Caption := FormatFloat('0.00',
    StrToCurr(Label7.Caption));

  //��ӡСƱ
  if CheckBox1.Checked then
  begin
    if messagedlg('ȷ�ϴ�ӡ��', mtconfirmation, [mbyes,
      mbno], 0) = mryes then
    begin
      {
      Main_T.QuickRep1.Height := 200 + Main_T.DetailBand1.Height * Main_T.ADOQuery1.RecordCount;
      Main_T.QuickRep1.Page.LeftMargin := vIniFile.ReadInteger('System', 'P0', 0);
      }

      try
        Main_T.QuickRep1.Prepare;
        FTotalPages :=
          Main_T.QuickRep1.QRPrinter.PageCount;
      finally
        Main_T.QuickRep1.QRPrinter.Cleanup;
      end;

      Main_T.QuickRep1.Print;
      //Main_T.QuickRep1.Preview;
    end;
  end;

  //�����Ƿ��ӡСƱ��Ϣ
  if CheckBox1.Checked then
  begin
    vIniFile.WriteBool('System', 'PB', True);
  end
  else
  begin
    vIniFile.WriteBool('System', 'PB', False);
  end;

  //����ƾ֤ʱ���޸���������
  if Main_T.reprint then
    Main_T.reprint := False
  else //�������ݴ���
  begin

    {
    //д���ۼ�¼
    Main_T.ADOQuery1.First;
    while not (Main_T.ADOQuery1.Eof) do
    begin
      Main_T.ADOQuerySQL.SQL.Clear;
      Main_T.ADOQuerySQL.SQL.Add('update stocks set amount=amount-' +
        Main_T.ADOQuery1.FieldByName('amount').AsString +
        ', updated_at=now() where pid="' +
        Main_T.ADOQuery1.FieldByName('pid').AsString + '"');
      Main_T.ADOQuerySQL.ExecSQL;

      Main_T.ADOQuery1.Next;
    end;
    }

    //�����ۺ���
    Main_T.ADOQuerySQL.SQL.Clear;
    Main_T.ADOQuerySQL.SQL.Add('update aftersellmains set yingtui="' +
      Label7.Caption + '", shitui="' + Label2.Caption
      +
      '", status="1", type="������", updated_at=now() where slid="' +
      Main_T.ADOQuery2.FieldByName('slid').AsString + '"');
    Main_T.ADOQuerySQL.ExecSQL;

    //����֧����ʽ����
    Main_T.ADOQuerySQL.SQL.Clear;
    Main_T.ADOQuerySQL.SQL.Add('insert into contactpayments(custid,custname,outmoney,inmoney,strike,method,cdate,remark,created_at,updated_at) values("' + Main_T.edt7.Text + '","' + Main_T.edt1.Text + '","","","'
      +
      CurrToStr(StrToCurr(Main_T.Label7.Caption) -
      StrToCurr(Label2.Caption)) + '","' + Main_T.cbb1.Text
      +
      '",now(),"' +
      Main_T.mmo1.Lines.GetText + '",now(),now())');
    Main_T.ADOQuerySQL.ExecSQL;

    //����selllogdetails�пͻ�ʵ��ӵ�еĲ�Ʒ������
    Main_T.ADOQuerySQL.SQL.Clear;
    Main_T.ADOQuerySQL.SQL.Add('update (select a.ramount, a.tid, a.pid, a.type, a.goodsname, a.preid,b.slid, b.additional,');
    Main_T.ADOQuerySQL.SQL.Add(' b.camount from (select sum(af.ramount) as ramount, af.tid, af.pid, af.type, af.goodsname, am.preid');
    Main_T.ADOQuerySQL.SQL.Add(' from afterselldetails af,aftersellmains am where af.tid="' + Main_T.Label26.Caption +
      '" and af.tid=am.tid group by tid,pid,type) a,');
    Main_T.ADOQuerySQL.SQL.Add('(select sd.slid, sd.pid, sd.additional, sd.camount from selllogdetails sd,aftersellmains am where sd.slid=am.preid and am.tid="' + Main_T.Label26.Caption + '" and additional<>"����"');
    Main_T.ADOQuerySQL.SQL.Add('  group by slid,pid,additional) t, selllogdetails sd set sd.camount=(sd.camount-t.ramount),sd.updated_at=now() where t.slid=sd.slid and t.pid=sd.pid and t.additional=sd.additional');
    Main_T.ADOQuerySQL.ExecSQL;

    //ά�޿��״̬����

  end;

  //������С����
  Main_T.GetOrderId;

  //���¼�����������Ʒ�۸�
  Main_T.QH2;

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

  //ˢ�������б�
  Main_T.ListRefresh;
end;

procedure TSHQR.RzEdit1KeyDown(Sender: TObject; var
  Key: Word;
  Shift: TShiftState);
begin
  if key = 13 then
  begin
    count := count + key;
    if RzEdit1.ReadOnly then
      SHQR.Close;
    if not (RzEdit1.ReadOnly) then
      JZ;
  end;
end;

end.

