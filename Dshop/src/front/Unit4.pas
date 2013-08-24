unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, DBGrids, DB,
  ADODB, INIFiles,
  RzForms, RzStatus, Mask, RzEdit, QRCtrls, QuickRpt,
  Registry, DBTables,
  RzCmboBx;

type
  TMain_T = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Bevel1: TBevel;
    Label17: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Bevel4: TBevel;
    RzEdit1: TRzEdit;
    RzEdit2: TRzEdit;
    RzEdit3: TRzEdit;
    Label24: TLabel;
    Label27: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Panel5: TPanel;
    QuickRep1: TQuickRep;
    DetailBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    SummaryBand1: TQRBand;
    QRLabel7: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel10: TQRLabel;
    Label30: TLabel;
    RzEdit4: TRzEdit;
    grp1: TGroupBox;
    grp2: TGroupBox;
    grp3: TGroupBox;
    grp4: TGroupBox;
    DBGrid1: TDBGrid;
    edt1: TRzEdit;
    lbl1: TLabel;
    lbl2: TLabel;
    edt2: TRzEdit;
    lbl3: TLabel;
    edt3: TRzEdit;
    lbl4: TLabel;
    edt4: TRzEdit;
    lbl5: TLabel;
    edt5: TRzEdit;
    lbl6: TLabel;
    edt6: TRzEdit;
    lbl7: TLabel;
    cbb1: TComboBox;
    lbl8: TLabel;
    mmo1: TMemo;
    lbl9: TLabel;
    edt7: TRzEdit;
    edt8: TRzEdit;
    lbl10: TLabel;
    qrbndPageFooter1: TQRBand;
    qrdbtxtpid: TQRDBText;
    qrdbtxtgoodsname: TQRDBText;
    qrdbtxtcolor: TQRDBText;
    qrdbtxtvolume: TQRDBText;
    qrdbtxtamount: TQRDBText;
    qrdbtxtunit: TQRDBText;
    qrdbtxtbundle: TQRDBText;
    qrdbtxtoutprice: TQRDBText;
    qrdbtxtrepeat: TQRDBText;
    qrdbtxtsubtotal: TQRDBText;
    qrlbl13: TQRLabel;
    qrlbl14: TQRLabel;
    qrlbl15: TQRLabel;
    qrlbl16: TQRLabel;
    qrlbl17: TQRLabel;
    qrlbl18: TQRLabel;
    qrlbl19: TQRLabel;
    qrlbl20: TQRLabel;
    qrlbl21: TQRLabel;
    qrlbl22: TQRLabel;
    qrlbl12: TQRLabel;
    qrlbl23: TQRLabel;
    qrbndtitleColumnHeaderBand1: TQRBand;
    qrbndtitleTitleBand1: TQRBand;
    qrlbl9: TQRLabel;
    qrlbl24: TQRLabel;
    qrlbl25: TQRLabel;
    qrlbl26: TQRLabel;
    qrlbl27: TQRLabel;
    qrlbl28: TQRLabel;
    qrlbl29: TQRLabel;
    qrlbl30: TQRLabel;
    qrlbl31: TQRLabel;
    qrlbl32: TQRLabel;
    qrlbl2: TQRLabel;
    RzEdit5: TRzEdit;
    Label31: TLabel;
    ADOQuerySQL: TADOQuery;
    QRLabel3: TQRLabel;
    qrdbtxtrow: TQRDBText;
    Label32: TLabel;
    ADOQuery2: TADOQuery;
    lbl11: TLabel;
    RzEdit7: TRzEdit;
    ComboBox1: TComboBox;
    Bevel5: TBevel;
    Label34: TLabel;
    QRLabel4: TQRLabel;
    qrdbtxttype: TQRDBText;
    grp5: TGroupBox;
    Label22: TLabel;
    cbb2: TComboBox;
    Label23: TLabel;
    mmo2: TMemo;
    bvl1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure QuickRep1StartPage(Sender: TCustomQuickRep);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzEdit1KeyPress(Sender: TObject; var Key:
      Char);
    procedure RzEdit3KeyPress(Sender: TObject; var Key:
      Char);
    procedure RzEdit5KeyPress(Sender: TObject; var Key:
      Char);
    procedure RzEdit2KeyPress(Sender: TObject; var Key:
      Char);
    procedure DBGrid1MouseUp(Sender: TObject; Button:
      TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzEdit4KeyPress(Sender: TObject; var Key:
      Char);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure edt4KeyPress(Sender: TObject; var Key: Char);
    procedure qrlbl12Print(sender: TObject; var Value:
      string);
    procedure edt8KeyPress(Sender: TObject; var Key: Char);
    procedure edt2KeyPress(Sender: TObject; var Key: Char);
    procedure FormHide(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key:
      Char);
  private
    { Private declarations }
  public
    reprint: Boolean;
    qsrc: string;
    hasorder: Boolean;
    procedure QH1;
    procedure WRecord;
    procedure QH2;
    procedure ListRefresh;
    procedure GetOrderId;
    procedure GetLoginTime;
    { Public declarations }
  end;

var
  Main_T: TMain_T;
  FTotalPages: Integer;
  source: string;

implementation

uses Unit1, Unit2, Unit3, Unit5, Unit7, Unit9, Unit10,
  Unit11, Unit12, Unit13,
  Unit14,
  Unit17, Unit18, Unit21, Unit22, Unit23, Unit24, Unit16;

{$R *.dfm}

{��ʼ���µ�ҳ��}

procedure TMain_T.FormCreate(Sender: TObject);
begin
  {
  Main_T.Width:=1045;//�ָ������ڴ�С
  Main_T.Height:=810;//�ָ������ڴ�С

//ʹ������λ����Ļ������
  Main_T.Top := (GetSystemMetrics(SM_CySCREEN) - 810) div 2 - 13;
  Main_T.Left := (GetSystemMetrics(SM_CxSCREEN) - 1045) div 2;
  }

  GetOrderId;

  ListRefresh;
  QH2;

end;

{��ȡ����}

procedure TMain_T.GetOrderId;
begin
  {ÿ����󵥺�9999}

  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('select concat("T",DATE_FORMAT(now(),"%y%m%d"),lpad(cast(substr(if(max(tid) is null,"0000",max(tid)),8) as signed) + 1,4,"0")) as id from aftersellmains where DATE_FORMAT(created_at,"%y%m%d")=DATE_FORMAT(now(),"%y%m%d") and tid like "T%"');
  ADOQuery2.Open;

  //��ȡ����
  Label26.Caption := ADOQuery2.FieldByName('id').AsString;
end;

procedure TMain_T.GetLoginTime;
begin

  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('select now() as now');
  ADOQuery2.Open;

  //��ȡ����
  Label21.Caption := ADOQuery2.FieldByName('now').AsString;
end;

{ˢ���б�}

procedure TMain_T.ListRefresh;
var
  bookmark: Pointer;
begin
  {��¼��ǰ�������λ�ã��Ա���ˢ�����ݺ�ָ���ǰ��λ��}
  bookmark := ADOQuery1.GetBookmark;

  ADOQuery1.SQL.Clear;

  ADOQuery1.SQL.Add('(select (@row := @row + 1) as row,id, pid,goodsname,color,FORMAT(volume,2) as volume,FORMAT(amount,0) as amount,');
  ADOQuery1.SQL.Add('FORMAT(ramount,0) as ramount,unit,FORMAT(bundle,0) as bundle,FORMAT(rbundle,0) as rbundle,FORMAT(outprice,0) as outprice,discount,additional,FORMAT((subtotal),0) as subtotal, ');
  ADOQuery1.SQL.Add('tid, barcode, size, inprice, pfprice,hprice,type from afterselldetails, (SELECT @row := 0) r where tid="' + Label26.Caption +
    '" and ramount>0 order by id) union (select "�ϼ�" as row, "" as id, "" as pid, "" as goodsname, "" as color,FORMAT(sum(volume*amount),2) ');
  ADOQuery1.SQL.Add('as volume,FORMAT(sum(amount),0) as amount,FORMAT(sum(ramount),0) as ramount,"" as unit,FORMAT(sum(bundle),0) as bundle,FORMAT(sum(rbundle),0) as rbundle,"" as outprice,"" as discount,"" ');
  ADOQuery1.SQL.Add('as additional,FORMAT(sum(subtotal),0) as subtotal, "" as tid, "" as barcode, "" as size, "" as inprice, "" as pfprice, "" as hprice, "" as type  from afterselldetails where tid = "' + Label26.Caption + '" and type="�˻�" and ramount>0)');

  ADOQuery1.Open;
  if ADOQuery1.RecordCount > 1 then
  begin
    try
      ADOQuery1.GotoBookmark(bookmark);
    except

    end;

  end;

  ADOQuery1.FreeBookmark(bookmark);

end;

procedure TMain_T.SpeedButton1Click(Sender: TObject);
begin
  Main.Show;
  Main_T.Close;
end;

procedure TMain_T.SpeedButton2Click(Sender: TObject);
begin
  if SpeedButton2.Caption = 'F12.���ע��' then
  begin
    //��ע�ᴰ��
    RegKey := TRegKey.Create(Application);
    RegKey.showmodal;
  end
  else
  begin
    //ʹ������λ����Ļ������
    Main_T.Top := (GetSystemMetrics(SM_CySCREEN) -
      Main_T.Height) div 2 - 13;
    Main_T.Left := (GetSystemMetrics(SM_CxSCREEN) -
      Main_T.Width) div 2;
  end;
end;

{��ӡ�����ϵ���Ϣ}

procedure TMain_T.QuickRep1StartPage(Sender:
  TCustomQuickRep);
var
  vIniFile: TIniFile;
begin
  vIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))
    +
    'Config.Ini');
  QRLabel1.Caption := viniFile.ReadString('System', 'Name',
    '');
  QRLabel2.Caption := viniFile.ReadString('System', 'La1',
    '');

  QRLabel10.Caption := '����Ա:' + Label19.Caption;
  QRLabel7.Caption := 'Ӧ��:' + Label14.Caption + 'Ԫ';
  QRLabel8.Caption := '����:' + Label15.Caption + 'Ԫ';
  QRLabel9.Caption := '����:' + Label16.Caption + 'Ԫ';

  qrlbl13.Caption := '�ռ���:' + Main_T.edt1.Text;
  qrlbl14.Caption := '�绰:' + Main_T.edt2.Text;
  qrlbl15.Caption := '�ջ���ַ:' + Main_T.edt3.Text;
  qrlbl19.Caption := '���ʽ:' + Main_T.cbb1.Text;

  qrlbl16.Caption := '���˲�:' + Main_T.edt4.Text;
  qrlbl17.Caption := '�绰:' + Main_T.edt5.Text;
  qrlbl18.Caption := '���˲���ַ:' + Main_T.edt6.Text;

  qrlbl20.Caption := '����:' + FormatDateTime('dddddd tt',
    Now);
  qrlbl21.Caption := '����:��' + Label26.Caption;
  qrlbl22.Caption := '�����绰:' +
    viniFile.ReadString('System', 'TEL', '');
  qrlbl23.Caption := viniFile.ReadString('System', 'La2',
    '');
end;

{����ÿ����Ʒ��С�ƽ��}

procedure TMain_T.QH1;
begin

  ADOQuerySQL.SQL.Clear;
  ADOQuerySQL.SQL.Add('update afterselldetails set subtotal=(if(additional="-",(outprice*amount*discount/100),0)),updated_at=now() where tid = "' + Label26.Caption + '"');
  ADOQuerySQL.ExecSQL;

  {ˢ���б�}
  ListRefresh;
end;

{�����в�Ʒ����}

procedure TMain_T.WRecord;
begin

  {
  //���ݼ��
  try
    StrToCurr(RzEdit1.Text);
  except
    RzEdit1.Text := '100';
  end;

  try
    StrToCurr(RzEdit3.Text);
  except
    RzEdit3.Text := '1';
  end;
  }

  //��ʼ�ۿۺ�����
  RzEdit1.Text := '100';
  RzEdit3.Text := '1';

  {���²�Ʒѡ����Ϣ���м�¼�͸��£��޼�¼�Ͳ���}
  //�����������Ƿ��д˵���
  ADOQuerySQL.SQL.Clear;
  ADOQuerySQL.SQL.Add('Select * from selllogmains Where slid="' + Label26.Caption
    + '"');
  ADOQuerySQL.ExecSQL;
  if ADOQuerySQL.RecordCount = 0 then
  begin

    ADOQuerySQL.SQL.Clear;
    ADOQuerySQL.SQL.Add('insert into selllogmains(slid,custid,custstate,custname,shopname,custtel,custaddr,sname,stel,saddress,payment,status,uname,cdate,remark,created_at,updated_at) values("' + Label26.Caption + '","' + edt7.Text + '","' + edt8.Text
      +
      '","' + edt1.Text +
      '","' + RzEdit7.Text + '","' + edt2.Text + '","' +
      edt3.Text + '","' +
      edt4.Text + '","' + edt5.Text + '","' + edt6.Text +
      '","' + cbb1.Text +
      '","0","' + Label19.Caption + '",now(),"' +
      mmo1.Lines.GetText +
      '",now(),now())');
    ADOQuerySQL.ExecSQL;

  end;

  QH1;
  QH2;

end;

{����ָ�����ŵĺϼƼ۸�}

procedure TMain_T.QH2;
begin
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('Select sum(subtotal) from afterselldetails Where tid="' +
    Label26.Caption + '" and type="�˻�"');
  ADOQuery2.Open;

  Label7.Caption := FormatFloat('0.00',
    ADOQuery2.Fields[0].AsCurrency)
end;

{�����ݼ�}

procedure TMain_T.FormKeyDown(Sender: TObject; var Key:
  Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: SpeedButton1.Click; //�˳�

    VK_SPACE: //�ύ����
      begin
        //����������
        if ADOQuery1.RecordCount < 1 then
        begin
          ShowMessage('û����Ʒ��¼~~!');
          Exit;
        end
        else
        begin
          Gathering := TGathering.Create(Application);
          Gathering.ShowModal;
        end;
      end;

    VK_F1: RzEdit4.SetFocus; //������Ʒ

    VK_F2: //RzEdit3.SetFocus; //���
      begin
        {���}
        //��������ʾ�û���ֳ�����
        if ADOQuery1.FieldByName('ramount').AsInteger = 1
          then
        begin
          ShowMessage('��������1ʱ���ܲ��Ŷ��������ѡ�񡫡�');
          Exit;
        end;

        if CF <> nil then
          CF.ShowModal
        else
        begin
          CF := TCF.Create(Application);
          CF.ShowModal;
          RzEdit4.SetFocus;
        end;
      end;

    VK_F3: //RzEdit5.SetFocus;
      begin
        {�ϲ�}
        //�����б���ʾ�û��������ϲ�
        if QHB <> nil then
          QHB.ShowModal
        else
        begin
          QHB := TQHB.Create(Application);
          QHB.ShowModal;
          RzEdit4.SetFocus;
        end;
      end;

    VK_F4: //RzEdit2.SetFocus; //�˻�
      begin
        if ADOQuery1.FieldByName('pid').AsString = '' then
        begin
          if
            messagedlg('���õ�ǰ�����е�������Ʒ�ۺ�������?',
            mtconfirmation,
            [mbyes, mbno], 0) = mryes then
          begin
            Main.ADOConnection1.BeginTrans;
            try

              //additionalΪ"�����Ĳ���Ҫ�ϲ�����Ϊ��ֳ�����"
              //���Ȼ��ܳ����ݲ������ݱ���
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('insert into afterselldetails(tid,pid,barcode,goodsname,size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,ramount,');
              ADOQuerySQL.SQL.Add('bundle,rbundle,discount,additional,subtotal,status,type,cdate,remark,created_at,updated_at) select tid,pid,barcode,goodsname,');
              ADOQuerySQL.SQL.Add('size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,sum(ramount) as ramount,bundle,rbundle,discount,additional,');
              ADOQuerySQL.SQL.Add('subtotal,status,"all" as type,now() as cdate,remark,now() as created_at,now() as updated_at from afterselldetails ');
              ADOQuerySQL.SQL.Add('where tid="' +
                Label26.Caption +
                '" and additional<>"����" group by pid,additional,type');
              ADOQuerySQL.ExecSQL;

              //ɾ��ԭ�е�û�л��ܵ�����
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' +
                Label26.Caption +
                '" and additional<>"����" and type<>"all"');
              ADOQuerySQL.ExecSQL;

              //���»���ʱʹ�õ���ʱ���λ
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set type="�˻�" where tid="' + Label26.Caption + '" and type="all"');
              ADOQuerySQL.ExecSQL;

              Main.ADOConnection1.CommitTrans;
            except
              Main.ADOConnection1.RollbackTrans;
            end;

          end
          else
            Exit;
        end
        else
        begin

          if ADOQuery1.FieldByName('additional').AsString =
            '����' then
          begin
            ShowMessage('������Ʒ����ԭʼ�����н����˻�~~!');
            Exit;
          end;

          if ADOQuery1.FieldByName('type').AsString <>
            '�˻�' then
          begin
            //����Ѿ����˻���һ����¼�ͺϲ�
            ADOQuery2.SQL.Clear;
            ADOQuery2.SQL.Add('select * from afterselldetails where tid="' +
              Label26.Caption + '" and pid="' +
              ADOQuery1.FieldByName('pid').AsString +
              '" and additional="' +
              ADOQuery1.FieldByName('additional').AsString
              +
              '" and type="�˻�"');
            ADOQuery2.Open;

            if ADOQuery2.RecordCount > 0 then
            begin //���ظ���¼

              Main.ADOConnection1.BeginTrans;
              try
                //ִ�кϲ�
                //���ۼ�����
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update afterselldetails ad,(select tid,pid,ramount,type from afterselldetails where tid="' + Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '"');
                ADOQuerySQL.SQL.Add(' and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  +
                  '" and type="' +
                  ADOQuery1.FieldByName('type').AsString +
                  '") t set ad.ramount=(ad.ramount+t.ramount),updated_at=now() where t.tid=ad.tid and t.pid=ad.pid and ad.type="�˻�"');
                ADOQuerySQL.ExecSQL;

                //ɾ����¼
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' +
                  Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '" and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  +
                  '" and type="' +
                  ADOQuery1.FieldByName('type').AsString +
                  '"');
                ADOQuerySQL.ExecSQL;

                Main.ADOConnection1.CommitTrans;
              except
                Main.ADOConnection1.RollbackTrans;
              end;

            end
            else //���ظ���¼
            begin
              //ֱ�Ӹ���
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set type="�˻�",updated_at=now() where tid="' + Label26.Caption
                +
                '" and pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '" and additional="' +
                ADOQuery1.FieldByName('additional').AsString
                +
                '" and type="' +
                ADOQuery1.FieldByName('type').AsString +
                '"');
              ADOQuerySQL.ExecSQL;
            end;

          end;

        end;
        QH1;
        QH2;
      end;

    VK_F5: //ComboBox1.SetFocus;
      //�ۺ�������ͣ��˻�/����/ά��/����/
      begin
        if ADOQuery1.FieldByName('pid').AsString = '' then
        begin
          if
            messagedlg('���õ�ǰ�����е�������Ʒ�ۺ�������?',
            mtconfirmation,
            [mbyes, mbno], 0) = mryes then
          begin

            Main.ADOConnection1.BeginTrans;
            try
              //���Ȼ��ܳ����ݲ������ݱ���
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('insert into afterselldetails(tid,pid,barcode,goodsname,size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,ramount,');
              ADOQuerySQL.SQL.Add('bundle,rbundle,discount,additional,subtotal,status,type,cdate,remark,created_at,updated_at) select tid,pid,barcode,goodsname,');
              ADOQuerySQL.SQL.Add('size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,sum(ramount) as ramount,bundle,rbundle,discount,additional,');
              ADOQuerySQL.SQL.Add('subtotal,status,"all" as type,now() as cdate,remark,now() as created_at,now() as updated_at from afterselldetails ');
              ADOQuerySQL.SQL.Add('where tid="' +
                Label26.Caption +
                '" group by pid,additional');
              ADOQuerySQL.ExecSQL;

              //ɾ��ԭ�е�û�л��ܵ�����
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' +
                Label26.Caption + '" and type<>"all"');
              ADOQuerySQL.ExecSQL;

              //���»���ʱʹ�õ���ʱ���λ
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set type="ά��" where tid="' + Label26.Caption + '"');
              ADOQuerySQL.ExecSQL;

              Main.ADOConnection1.CommitTrans;
            except
              Main.ADOConnection1.RollbackTrans;
            end;
          end
          else
            Exit;
        end
        else
        begin

          if ADOQuery1.FieldByName('type').AsString <>
            'ά��' then
          begin
            //����Ѿ���ά����һ����¼�ͺϲ�
            ADOQuery2.SQL.Clear;
            ADOQuery2.SQL.Add('select * from afterselldetails where tid="' +
              Label26.Caption + '" and pid="' +
              ADOQuery1.FieldByName('pid').AsString +
              '" and additional="' +
              ADOQuery1.FieldByName('additional').AsString
              +
              '" and type="ά��"');
            ADOQuery2.Open;

            if ADOQuery2.RecordCount > 0 then
            begin //���ظ���¼

              Main.ADOConnection1.BeginTrans;
              try

                //ִ�кϲ�
                //���ۼ�����
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update afterselldetails ad,(select tid,pid,ramount,type from afterselldetails where tid="' + Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '"');
                ADOQuerySQL.SQL.Add(' and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  +
                  '" and type="' +
                  ADOQuery1.FieldByName('type').AsString +
                  '") t set ad.ramount=(ad.ramount+t.ramount),updated_at=now() where t.tid=ad.tid and t.pid=ad.pid and ad.type="ά��"');
                ADOQuerySQL.ExecSQL;

                //ɾ����¼
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' +
                  Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '" and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  +
                  '" and type="' +
                  ADOQuery1.FieldByName('type').AsString +
                  '"');
                ADOQuerySQL.ExecSQL;

                Main.ADOConnection1.CommitTrans;
              except
                Main.ADOConnection1.RollbackTrans;
              end;

            end
            else //���ظ���¼
            begin
              //ֱ�Ӹ���
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set type="ά��",updated_at=now() where tid="' + Label26.Caption
                +
                '" and pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '" and additional="' +
                ADOQuery1.FieldByName('additional').AsString
                +
                '" and type="' +
                ADOQuery1.FieldByName('type').AsString +
                '"');
              ADOQuerySQL.ExecSQL;
            end;

          end;
        end;
        QH1;
        QH2;
      end;

    VK_F6: //����ǰδ����˻��������� set status=0
      begin

        //ԭʼ������Ϣ������༭��������
        {
        ADOQuerySQL.SQL.Clear;
        ADOQuerySQL.SQL.Add('insert into aftersellmains(tid,custid,custstate,custname,shopname,custtel,custaddr,yingshou,shishou,sname,stel,saddress,payment,status,uname,cdate,remark,created_at,updated_at) values("' + Label26.Caption + '","","' + edt8.Text + '","' +
          edt1.Text + '","' +
          RzEdit7.Text + '","' + edt2.Text + '","' +
          edt3.Text + '","0","0","' +
          edt4.Text + '","' + edt6.Text + '","' + edt5.Text
          + '","' + cbb1.Text +
          '","0","' + Label19.Caption + '",now(),"' +
          mmo1.Lines.GetText +
          '",now(),now()) on duplicate key update custstate="' +
          edt8.Text +
          '",custname="' + edt1.Text + '",shopname="' +
          RzEdit7.Text +
          '",custtel="' + edt2.Text + '",custaddr="' +
          edt3.Text + '",sname="' +
          edt4.Text + '",stel="' + edt6.Text +
          '",saddress="' + edt5.Text +
          '",payment="' + cbb1.Text + '",uname="' +
          Label19.Caption + '",remark="'
          + mmo1.Lines.GetText + '",updated_at=now()');
        ADOQuerySQL.ExecSQL;
        }

        ADOQuerySQL.SQL.Clear;
        ADOQuerySQL.SQL.Add('update aftersellmains set tpayment="' + cbb2.Text +
          '",tuid="' + Main.uid + '",tuname="' + Label19.Caption + '",tremark="' +
          mmo2.Text + '",updated_at=now() where tid="' + Label26.Caption + '"');
        ADOQuerySQL.ExecSQL;

        {���������}
        edt1.Text := '';
        edt2.Text := '';
        edt3.Text := '';
        edt7.Text := '';
        edt8.Text := '';
        RzEdit7.Text := '';

        edt4.Text := '';
        edt5.Text := '';
        edt6.Text := '';

        cbb1.Text := '';
        mmo1.Text := '';

        {��������}
        GetOrderId;

        ListRefresh;
        QH2;

        hasorder := False;

        RzEdit4.SetFocus;
      end;

    VK_F7: //ȡδ��ɵ��˻����� status=0
      begin
        if QHDF7 <> nil then
          QHDF7.ShowModal
        else
        begin
          QHDF7 := TQHDF7.Create(Application);
          QHDF7.ShowModal;
          RzEdit4.SetFocus;
        end;
      end;

    VK_F8: //ȡ���˻�����
      begin

        if hasorder then
        begin

          ADOQuery2.SQL.Clear;
          ADOQuery2.SQL.Add('select * from selllogmains where nextid="' +
            Main_T.Label26.Caption + '" and type="�ۺ���"');
          ADOQuery2.Open;
          if ADOQuery2.RecordCount < 1 then
          begin
            ShowMessage('"' + Main_T.Label26.Caption +
              '"û���ҵ�ԭʼ������Ϣ������ϵ����Ա~~!');
            Exit;
          end
          else
          begin
            if messagedlg('ȡ�����ۺ󶩵���?',
              mtconfirmation,
              [mbyes, mbno], 0) =
              mryes then
            begin

              Main.ADOConnection1.BeginTrans;
              try
                //����
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update selllogmains set type="�ѳ���", nextid="" where slid="' + ADOQuery2.FieldByName('slid').AsString + '"');
                ADOQuerySQL.ExecSQL;

                {���Ƽ�¼}
                //����
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('delete from aftersellmains where tid="' +
                  Main_T.Label26.Caption + '"');
                ADOQuerySQL.ExecSQL;

                //��ϸ��
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' +
                  Main_T.Label26.Caption + '"');
                ADOQuerySQL.ExecSQL;

                Main.ADOConnection1.CommitTrans;
              except
                Main.ADOConnection1.RollbackTrans;
              end;
            end;
          end;

          QH1;
          QH2;
        end;
      end;

    VK_F10: //RzEdit1.SetFocus;
      begin
        if ADOQuery1.FieldByName('pid').AsString = '' then
        begin
          if
            messagedlg('���õ�ǰ�����е�������Ʒ�ۺ�������?',
            mtconfirmation,
            [mbyes, mbno], 0) = mryes then
          begin

            Main.ADOConnection1.BeginTrans;
            try
              //���Ȼ��ܳ����ݲ������ݱ���
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('insert into afterselldetails(tid,pid,barcode,goodsname,size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,ramount,');
              ADOQuerySQL.SQL.Add('bundle,rbundle,discount,additional,subtotal,status,type,cdate,remark,created_at,updated_at) select tid,pid,barcode,goodsname,');
              ADOQuerySQL.SQL.Add('size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,sum(ramount) as ramount,bundle,rbundle,discount,additional,');
              ADOQuerySQL.SQL.Add('subtotal,status,"all" as type,now() as cdate,remark,now() as created_at,now() as updated_at from afterselldetails ');
              ADOQuerySQL.SQL.Add('where tid="' +
                Label26.Caption +
                '" group by pid,additional');
              ADOQuerySQL.ExecSQL;

              //ɾ��ԭ�е�û�л��ܵ�����
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' +
                Label26.Caption + '" and type<>"all"');
              ADOQuerySQL.ExecSQL;

              //���»���ʱʹ�õ���ʱ���λ
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set type="-" where tid="' + Label26.Caption + '"');
              ADOQuerySQL.ExecSQL;

              Main.ADOConnection1.CommitTrans;
            except
              Main.ADOConnection1.RollbackTrans;
            end;
          end
          else
            Exit;
        end
        else
        begin

          if ADOQuery1.FieldByName('type').AsString <>
            '-' then
          begin
            //����Ѿ���ά����һ����¼�ͺϲ�
            ADOQuery2.SQL.Clear;
            ADOQuery2.SQL.Add('select * from afterselldetails where tid="' +
              Label26.Caption + '" and pid="' +
              ADOQuery1.FieldByName('pid').AsString +
              '" and additional="' +
              ADOQuery1.FieldByName('additional').AsString
              +
              '" and type="-"');
            ADOQuery2.Open;

            if ADOQuery2.RecordCount > 0 then
            begin //���ظ���¼
              Main.ADOConnection1.BeginTrans;
              try
                //ִ�кϲ�
                //���ۼ�����
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update afterselldetails ad,(select tid,pid,ramount,type from afterselldetails where tid="' + Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '"');
                ADOQuerySQL.SQL.Add(' and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  +
                  '" and type="' +
                  ADOQuery1.FieldByName('type').AsString +
                  '") t set ad.ramount=(ad.ramount+t.ramount),updated_at=now() where t.tid=ad.tid and t.pid=ad.pid and ad.type="-"');
                ADOQuerySQL.ExecSQL;

                //ɾ����¼
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' +
                  Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '" and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  +
                  '" and type="' +
                  ADOQuery1.FieldByName('type').AsString +
                  '"');
                ADOQuerySQL.ExecSQL;

                Main.ADOConnection1.CommitTrans;
              except
                Main.ADOConnection1.RollbackTrans;
              end;

            end
            else //���ظ���¼
            begin
              //ֱ�Ӹ���
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set type="-",updated_at=now() where tid="' + Label26.Caption
                +
                '" and pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '" and additional="' +
                ADOQuery1.FieldByName('additional').AsString
                +
                '" and type="' +
                ADOQuery1.FieldByName('type').AsString +
                '"');
              ADOQuerySQL.ExecSQL;
            end;

          end;
        end;
        QH1;
        QH2;
      end;
    {
    VK_F11:
      begin
        if QO <> nil then
          QO.ShowModal
        else
        begin
          QO := TQO.Create(Application);
          QO.ShowModal;
        end;
      end;
      }

    VK_F12: SpeedButton2.Click;

    VK_UP:
      begin
        DBGrid1.SetFocus;
      end;

    VK_DOWN:
      begin
        DBGrid1.SetFocus;
      end;

    VK_HOME: //���ݲ���
      begin
        if QHD_PT <> nil then
          QHD_PT.ShowModal
        else
        begin
          QHD_PT := TQHD_PT.Create(Application);
          QHD_PT.ShowModal;
        end;
      end;
    {
    VK_DELETE: //ɾ����Ʒ��Ŀ
      begin
        if ADOQuery1.RecordCount > 0 then
        begin

          if ADOQuery1.FieldByName('pid').AsString = ''
            then
          begin
            if messagedlg('��յ�ǰ�����е�������Ʒ��?',
              mtconfirmation, [mbyes,
              mbno], 0) = mryes then
            begin
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set ramount=0 where tid="' +
                Label26.Caption + '"');
              ADOQuerySQL.ExecSQL;
            end
            else
              Exit;
          end
          else
          begin
            if messagedlg('ȷ��ɾ��"' +
              ADOQuery1.FieldByName('goodsname').AsString +
              '"��?', mtconfirmation,
              [mbyes, mbno], 0) = mryes then
            begin
              //ADOQuery1.Delete;
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set ramount=0 where tid="' +
                Label26.Caption + '" and pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '"');
              ADOQuerySQL.ExecSQL;
            end;
          end;

          QH1;
          QH2;
        end
        else
        begin
          ShowMessage('û����Ʒ��¼~~!');
        end;
      end;

    VK_ADD: //���Ӳ�Ʒ���������ܳ���ԭ�ж�����ͬ����Ʒ������
      begin
        if ADOQuery1.RecordCount > 0 then
        begin
          if ADOQuery1.FieldByName('pid').AsString = ''
            then
            //�ϼ���
          begin
            if messagedlg('���ӵ�ǰ���������в�Ʒ������?',
              mtconfirmation,
              [mbyes, mbno], 0) = mryes then
            begin
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set ramount=(if(amount>ramount,ramount+1,amount)),updated_at=now()  where tid="' + Label26.Caption + '"');
              ADOQuerySQL.ExecSQL;
            end
            else
              Exit;
          end
          else
          begin
            ADOQuery2.SQL.Clear;
            ADOQuery2.SQL.Add('select * from selllogmains where nextid="' +
              Main_T.Label26.Caption +
              '" and type="�ۺ���"');
            ADOQuery2.Open;
            if ADOQuery2.RecordCount < 1 then
            begin
              ShowMessage('"' + Main_T.Label26.Caption +
                '"û���ҵ�ԭʼ������Ϣ������ϵ����Ա~~!');
              Exit;
            end
            else
            begin

              slid :=
                ADOQuery2.FieldByName('slid').AsString;

              ADOQuery2.SQL.Clear;
              ADOQuery2.SQL.Add('select * from selllogdetails where slid="' +
                slid + '" and pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '"');
              ADOQuery2.Open;

              //һ���Ʒ���������ܳ���ԭʼ�����еĲ�Ʒ����
              if ADOQuery1.FieldByName('ramount').AsInteger
                <
                ADOQuery1.FieldByName('amount').AsInteger
                then
              begin
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update afterselldetails set ramount=(ramount+1),updated_at=now()  where tid="' + Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '" and type="' +
                  ADOQuery1.FieldByName('type').AsString +
                  '"');
                ADOQuerySQL.ExecSQL;
              end
              else
              begin
                ShowMessage('�˻��������ܳ���ԭ�����в�Ʒ����~~!');
                Exit;
              end;
            end;
          end;

          QH1;
          QH2;
        end;

      end;

    VK_SUBTRACT: //���ٲ�Ʒ����,��ּ�¼
      begin
        if ADOQuery1.RecordCount > 0 then
        begin
          if ADOQuery1.FieldByName('pid').AsString = ''
            then
          begin
            if messagedlg('���ٵ�ǰ���������в�Ʒ������?',
              mtconfirmation,
              [mbyes, mbno], 0) = mryes then
            begin
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set ramount=(if(ramount>1,ramount-1,1)),updated_at=now()  where tid="' + Label26.Caption + '"');
              ADOQuerySQL.ExecSQL;
            end
            else
              Exit;
          end
          else
          begin
            if ADOQuery1.FieldByName('ramount').AsCurrency >
              1 then
            begin
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set ramount=(ramount-1),updated_at=now()  where tid="' + Label26.Caption + '" and pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '" and type="' +
                ADOQuery1.FieldByName('type').AsString +
                '"');
              ADOQuerySQL.ExecSQL;
            end;
          end;

          QH1;
          QH2;
        end;
      end;
      }
  end;
end;

{�޸��ۿ���Ϣ}

procedure TMain_T.RzEdit1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if ADOQuery1.RecordCount > 0 then
    begin
      //�������ݼ��
      try
        StrToInt(RzEdit1.Text);
        if StrToInt(RzEdit1.Text) < 1 then
        begin
          ShowMessage('�ۿ۲���С��1~~!');
          RzEdit1.Text := '100';
          Exit;
        end;
      except
        ShowMessage('����Ƿ��ַ�~~!');
        RzEdit1.Text := '100';
        Exit;
      end;

      ADOQuerySQL.SQL.Clear;
      ADOQuerySQL.SQL.Add('update afterselldetails set discount="' + RzEdit1.Text
        + '",updated_at=now() where tid = "' +
        Label26.Caption + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit1.Text := '100';
    RzEdit4.SetFocus;
  end;
end;

{�޸�����}

procedure TMain_T.RzEdit3KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if ADOQuery1.RecordCount > 0 then
    begin
      //�������ݼ��
      try
        StrToCurr(RzEdit3.Text);
        if StrToCurr(RzEdit3.Text) < 0 then
        begin
          ShowMessage('��Ʒ��������С����~~!');
          RzEdit3.Text := '1';
          Exit;
        end;
      except
        ShowMessage('����Ƿ��ַ�~~!');
        Exit;
      end;

      ADOQuerySQL.SQL.Clear;
      ADOQuerySQL.SQL.Add('update afterselldetails set amount="' + RzEdit3.Text
        +
        '",updated_at=now() where tid = "' + Label26.Caption
        + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString +
        '" and type="' +
        ADOQuery1.FieldByName('type').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit3.Text := '1';
    RzEdit4.SetFocus;
  end;
end;

{�޸ļ���}

procedure TMain_T.RzEdit5KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if ADOQuery1.RecordCount > 0 then
    begin
      //�������ݼ��
      try
        StrToCurr(RzEdit5.Text);
        if StrToCurr(RzEdit5.Text) < 0 then
        begin
          ShowMessage('��Ʒ��������С����~~!');
          RzEdit5.Text := '1';
          Exit;
        end;
      except
        ShowMessage('����Ƿ��ַ�~~!');
        Exit;
      end;

      ADOQuerySQL.SQL.Clear;
      ADOQuerySQL.SQL.Add('update afterselldetails set bundle="' + RzEdit5.Text
        +
        '",updated_at=now() where tid = "' + Label26.Caption
        + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString +
        '" and type="' +
        ADOQuery1.FieldByName('type').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit5.Text := '1';
    RzEdit4.SetFocus;
  end;
end;

{�޸ĵ���}

procedure TMain_T.RzEdit2KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if ADOQuery1.RecordCount > 0 then
    begin
      //�������ݼ��
      try
        StrToCurr(RzEdit2.Text);
        if StrToCurr(RzEdit2.Text) < 0 then
        begin
          ShowMessage('��Ʒ�ۼ۲���Ϊ����~~!');
          RzEdit1.Text := '100';
          Exit;
        end;
      except
        ShowMessage('����Ƿ��ַ�~~!');
        Exit;
      end;

      ADOQuerySQL.SQL.Clear;
      ADOQuerySQL.SQL.Add('update afterselldetails set outprice="' + RzEdit2.Text
        + '",updated_at=now() where tid = "' +
        Label26.Caption + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit4.SetFocus;
  end;
end;

{�����ƶ��б���ʱ��������}

procedure TMain_T.DBGrid1MouseUp(Sender: TObject; Button:
  TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RzEdit1.Text :=
    ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text :=
    ADOQuery1.FieldByName('outprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
  RzEdit5.Text := ADOQuery1.FieldByName('bundle').AsString;
  ComboBox1.Text :=
    ADOQuery1.FieldByName('type').AsString;
end;

procedure TMain_T.DBGrid1KeyUp(Sender: TObject; var Key:
  Word;
  Shift: TShiftState);
begin
  RzEdit1.Text :=
    ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text :=
    ADOQuery1.FieldByName('outprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
  RzEdit5.Text := ADOQuery1.FieldByName('bundle').AsString;
  ComboBox1.Text :=
    ADOQuery1.FieldByName('type').AsString;
end;

{������������Ʒ}

procedure TMain_T.RzEdit4KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    //������Ϊ@�����
    if (RzEdit4.Text = '') and (ADOQuery1.RecordCount > 0)
      then
    begin

      if cbb1.Text = '' then
      begin
        ShowMessage('��ѡ��֧����ʽ~~!');
        cbb1.SetFocus;
        Exit;
      end;

      SHQR := TSHQR.create(application);
      SHQR.showmodal;
      Exit;
    end;

    //���ݿͻ����Ϳͻ��ṩ�Ĳ�Ʒ��ţ���ѯ����ԭʼ����
    if edt1.Text = '' then
    begin
      ShowMessage('�����ṩ�ͻ����ƺͲ�Ʒ��Ų��ܲ�ѯԭʼ������');
      Exit;
    end;

    qsrc := 'pid';
    if QHD <> nil then
      QHD.ShowModal
    else
    begin
      QHD := TQHD.Create(Application);
      QHD.ShowModal;
      //RzEdit4.SetFocus;
    end;

  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;

{���ݿͻ�����ģ����ѯ�ÿͻ�����ʷ����}

procedure TMain_T.edt1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    qsrc := 'custname';
    if QHD <> nil then
      QHD.ShowModal
    else
    begin
      QHD := TQHD.Create(Application);
      QHD.ShowModal;
      //RzEdit4.SetFocus;
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;

end;

{���ݿͻ���Ų�ѯ�ͻ�ƫ�����˲�}

procedure TMain_T.edt4KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin

    {����Ҫ��������ͻ�����}
  //���ͻ����
    if edt7.Text = '' then
    begin
      if messagedlg('�����¿ͻ���', mtconfirmation,
        [mbyes, mbno], 0) = mryes
        then
        Exit;
    end;

    if QS <> nil then
      QS.ShowModal
    else
    begin
      QS := TQS.Create(Application);
      QS.ShowModal;
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;

procedure TMain_T.qrlbl12Print(sender: TObject; var Value:
  string);
begin
  Value := '��' + IntToStr(QuickRep1.QRPrinter.PageNumber)
    +
    'ҳ / ��' +
    IntToStr(FTotalPages) + 'ҳ';
end;

procedure TMain_T.edt8KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    qsrc := 'state';
    if QC <> nil then
      QC.ShowModal
    else
    begin
      QC := TQC.Create(Application);
      QC.ShowModal;
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;

procedure TMain_T.edt2KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin

    qsrc := 'tel';

    if QC <> nil then
      QC.ShowModal
    else
    begin
      QC := TQC.Create(Application);
      QC.ShowModal;
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;

procedure TMain_T.FormHide(Sender: TObject);
begin
  Main.Show;
end;

procedure TMain_T.FormActivate(Sender: TObject);
begin
  Main.Hide;

  Main_T.Width := 1045; //�ָ������ڴ�С
  Main_T.Height := 810; //�ָ������ڴ�С

  //ʹ������λ����Ļ������
  Main_T.Top := (GetSystemMetrics(SM_CySCREEN) -
    Main_T.Height) div 2 - 13;
  Main_T.Left := (GetSystemMetrics(SM_CxSCREEN) -
    Main_T.Width) div 2;

end;

procedure TMain_T.ComboBox1KeyPress(Sender: TObject; var
  Key: Char);
begin
  if key = #13 then
  begin
    key := #0;

    if (ComboBox1.Text <> '') and (ComboBox1.Text <>
      '�˻�') and
      (ComboBox1.Text <> 'ά��') and (ComboBox1.Text =
      '����') then
    begin
      ShowMessage('��ѡ����Ч���ۺ�����~~!');
      Exit;
    end
    else
    begin

      if ADOQuery1.FieldByName('pid').AsString = '' then
      begin
        if
          messagedlg('���õ�ǰ�����е�������Ʒ�ۺ�������?',
          mtconfirmation,
          [mbyes, mbno], 0) = mryes then
        begin
          ADOQuerySQL.SQL.Clear;
          ADOQuerySQL.SQL.Add('update afterselldetails set type="' +
            ComboBox1.Text +
            '",updated_at=now() where tid="' +
            Label26.Caption +
            '"');
          ADOQuerySQL.ExecSQL;
        end
        else
          Exit;
      end
      else
      begin
        ADOQuerySQL.SQL.Clear;
        ADOQuerySQL.SQL.Add('update afterselldetails set type="' +
          ComboBox1.Text +
          '",updated_at=now() where tid="' + Label26.Caption
          +
          '" and pid="' +
          ADOQuery1.FieldByName('pid').AsString + '"');
        ADOQuerySQL.ExecSQL;
      end;
    end;
    QH1;
    QH2;

    //RzEdit4.SetFocus;
  end;
end;

end.
