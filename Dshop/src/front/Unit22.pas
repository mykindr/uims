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
    procedure FormActivate(Sender: TObject);
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

uses Unit6, Unit8, Unit4, Unit2, Unit5;

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

  {����֧����ʽ��д�յ����}
  if Main_T.cbb2.Text <> '�ֽ�' then
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

  if Main_T.cbb2.Text = '' then
  begin
    ShowMessage('��ѡ��֧����ʽ~~!');
    SHQR.Close;
    Main_T.RzEdit4.SetFocus;
    Exit;
  end
  else if (Main_T.cbb2.Text <> '�ֽ�') and (Main_T.cbb2.Text <> '����') then
  begin
    ShowMessage('֧����ʽ��Ч����ѡ����ȷ���˿�֧����ʽ~~!');
    Gathering.Close;
    Main.RzEdit4.SetFocus;
    Exit;
  end;

  //���ʹ���ֽ�֧��������������Ƿ�С��Ӧ����
  if Main_T.cbb2.Text = '�ֽ�' then
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
      StrToCurr(RzEdit1.Text) - StrToCurr(Label2.Caption));
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
        Main_T.FTotalPages := Main_T.QuickRep1.QRPrinter.PageCount;
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

  Main_T.ADOQuery2.SQL.Clear;
  Main_T.ADOQuery2.SQL.Add('select * from aftersellmains where tid="' +
    Main_T.Label26.Caption
    + '"');
  Main_T.ADOQuery2.Open;
  if (Main_T.ADOQuery2.RecordCount = 1) and
    (Main_T.ADOQuery2.FieldByName('pdate').AsString <> '') then
  begin
    //�����ݲ���
    Main_T.Labeluid.Caption := Main_T.uid;
    Main_T.Label19.Caption := Main_T.uname;

    Main_T.edt1.Enabled := True;
    Main_T.edt2.Enabled := True;
    Main_T.edt3.Enabled := True;
    Main_T.edt7.Enabled := True;
    Main_T.edt8.Enabled := True;
    Main_T.RzEdit7.Enabled := True;

    Main_T.edt4.Enabled := True;
    Main_T.edt5.Enabled := True;
    Main_T.edt6.Enabled := True;

    Main_T.cbb1.Enabled := True;
    Main_T.mmo1.Enabled := True;

    Main_T.cbb2.Enabled := True;
    Main_T.mmo2.Enabled := True;

  end
  else //�������ݴ���
  begin
    Main.ADOConnection1.BeginTrans;
    try
      //�����ۺ���
      Main_T.ADOQuerySQL.SQL.Clear;
      Main_T.ADOQuerySQL.SQL.Add('update aftersellmains set yingtui="' +
        Label2.Caption + '", shitui="' + Label2.Caption
        +
        '", status="1", type="�Ѵ���", tpayment="' + Main_T.cbb2.Text +
        '",tuid="' + Main_T.Labeluid.Caption + '",tuname="' +
        Main_T.Label19.Caption +
        '",pdate=now(),tremark="' + Main_T.mmo2.Text +
        '", pdate=now(),updated_at=now() where tid="' +
        Main_T.Label26.Caption + '"');
      Main_T.ADOQuerySQL.ExecSQL;

      //����֧����ʽ����
      if Main_T.cbb2.Text = '�ֽ�' then
      begin
        Main_T.ADOQuerySQL.SQL.Clear;
        Main_T.ADOQuerySQL.SQL.Add('insert into contactpayments(custid,custname,outmoney,inmoney,strike,method,proof,ticketid,cdate,remark,created_at,updated_at) values("' + Main_T.edt7.Text + '","' + Main_T.edt1.Text +
          '","","","-'
          + CurrToStr(StrToCurr(Label2.Caption)) + '","' +
          Main_T.cbb2.Text
          +
          '","","' + Main_T.Label26.Caption + '",now(),"' +
          Main_T.mmo2.Lines.GetText + '",now(),now())');
        Main_T.ADOQuerySQL.ExecSQL;
      end
      else if Main_T.cbb2.Text = '����' then
      begin
        Main_T.ADOQuerySQL.SQL.Clear;
        Main_T.ADOQuerySQL.SQL.Add('insert into contactpayments(custid,custname,outmoney,inmoney,strike,method,proof,ticketid,cdate,remark,created_at,updated_at) values("' + Main_T.edt7.Text + '","' + Main_T.edt1.Text +
          '","","","-'
          + CurrToStr(StrToCurr(Label2.Caption)) + '","' +
          Main_T.cbb2.Text
          +
          '","","' + Main_T.Label26.Caption + '",now(),"' +
          Main_T.mmo2.Lines.GetText + '",now(),now())');
        Main_T.ADOQuerySQL.ExecSQL;
      end;

      //����selllogdetails�пͻ�ʵ��ӵ�еĲ�Ʒ������
      Main_T.ADOQuerySQL.SQL.Clear;
      Main_T.ADOQuerySQL.SQL.Add('update (select a.ramount, a.tid, a.pid, a.type, a.goodsname, a.preid,b.slid, b.additional,b.camount from (select sum(ad.ramount)');
      Main_T.ADOQuerySQL.SQL.Add(' as ramount, ad.tid, ad.pid, ad.additional, ad.type, ad.goodsname, am.preid from afterselldetails ad,aftersellmains am where ');
      Main_T.ADOQuerySQL.SQL.Add('ad.tid="' +
        Main_T.Label26.Caption +
        '" and ad.tid=am.tid and ad.type="�˻�" group by tid,pid,additional) a,(select sd.slid, sd.pid, sd.additional,');
      Main_T.ADOQuerySQL.SQL.Add(' sd.camount from selllogdetails sd,aftersellmains am where sd.slid=am.preid and am.tid="' + Main_T.Label26.Caption + '" and additional<>"����" ');
      Main_T.ADOQuerySQL.SQL.Add('group by slid,pid,additional) b where a.preid=b.slid and a.pid=b.pid and a.additional=b.additional) t, selllogdetails sd ');
      Main_T.ADOQuerySQL.SQL.Add('set sd.camount=(sd.camount-t.ramount),sd.updated_at=now() where t.slid=sd.slid and t.pid=sd.pid and t.additional=sd.additional');
      Main_T.ADOQuerySQL.ExecSQL;

      //����selllogmain��״̬Ϊ���ۺ�
      Main_T.ADOQuerySQL.SQL.Clear;
      Main_T.ADOQuerySQL.SQL.Add('update selllogmains sm,aftersellmains am set sm.type="���ۺ�" where sm.slid=am.preid and am.tid="' + Main_T.Label26.Caption + '"');
      Main_T.ADOQuerySQL.ExecSQL;
      Main.ADOConnection1.CommitTrans;
    except
      Main.ADOConnection1.RollbackTrans;
    end;

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
  Main_T.cbb2.Text := '';
  Main_T.mmo2.Text := '';

  //ˢ�������б�
  Main_T.ListRefresh;
  //�رս��㴰��
  SHQR.Close;
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

procedure TSHQR.FormActivate(Sender: TObject);
begin
  Main_T.ADOQuery2.SQL.Clear;
  Main_T.ADOQuery2.SQL.Add('select * from aftersellmains where tid="' +
    Main_T.Label26.Caption
    + '"');
  Main_T.ADOQuery2.Open;
  if (Main_T.ADOQuery2.RecordCount = 1) and
    (Main_T.ADOQuery2.FieldByName('pdate').AsString <> '') then
  begin
    //RzEdit1.ReadOnly := True;
  end;
end;

end.
