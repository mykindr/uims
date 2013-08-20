unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, DBGrids, DB, ADODB, INIFiles,
  RzForms, RzStatus, Mask, RzEdit, QRCtrls, QuickRpt, Registry, DBTables,
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
    RzFormShape1: TRzFormShape;
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
    Label23: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
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
    Label22: TLabel;
    Label33: TLabel;
    ADOQuery2: TADOQuery;
    RzComboBox1: TRzComboBox;
    lbl11: TLabel;
    RzEdit7: TRzEdit;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure QuickRep1StartPage(Sender: TCustomQuickRep);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure RzEdit3KeyPress(Sender: TObject; var Key: Char);
    procedure RzEdit5KeyPress(Sender: TObject; var Key: Char);
    procedure RzEdit2KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RzEdit4KeyPress(Sender: TObject; var Key: Char);
    procedure edt1KeyPress(Sender: TObject; var Key: Char);
    procedure edt4KeyPress(Sender: TObject; var Key: Char);
    procedure qrlbl12Print(sender: TObject; var Value: string);
    procedure edt8KeyPress(Sender: TObject; var Key: Char);
    procedure edt2KeyPress(Sender: TObject; var Key: Char);
    procedure FormHide(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RzComboBox1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
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

uses Unit1, Unit2, Unit3, Unit5, Unit7, Unit9, Unit10, Unit11, Unit12, Unit13, Unit14, Unit15, Unit16,
  Unit17, Unit18;

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

  ADOQuery1.SQL.Add('(select (@row := @row + 1) as row,id, pid,goodsname,color,FORMAT(volume,2) as volume,FORMAT(amount,0) as amount,unit,FORMAT(bundle,0) as bundle,FORMAT(outprice,0) as outprice,discount,additional,FORMAT((subtotal),0) as subtotal, ');
  ADOQuery1.SQL.Add('tid, barcode, size, inprice, pfprice,hprice,type from afterselldetails, (SELECT @row := 0) r where tid = "' + Label26.Caption + '" order by id) union (select "�ϼ�" as row, "" as id, "" as pid, "" as goodsname, "" as color,FORMAT(sum(volume*amount),2) ');
  ADOQuery1.SQL.Add('as volume,FORMAT(sum(amount),0) as amount,"" as unit,FORMAT(sum(bundle),0) as bundle,"" as outprice,"" as discount,"" ');
  ADOQuery1.SQL.Add('as additional,-FORMAT(sum(subtotal),0) as subtotal, "" as tid, "" as barcode, "" as size, "" as inprice, "" as pfprice, "" as hprice, "" as type  from afterselldetails where tid = "' + Label26.Caption + '" and type="�˻�")');

  ADOQuery1.Open;
  if ADOQuery1.RecordCount > 1 then
    ADOQuery1.GotoBookmark(bookmark);

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
    Main_T.Top := (GetSystemMetrics(SM_CySCREEN) - Main_T.Height) div 2 - 13;
    Main_T.Left := (GetSystemMetrics(SM_CxSCREEN) - Main_T.Width) div 2;
  end;
end;

{��ӡ�����ϵ���Ϣ}

procedure TMain_T.QuickRep1StartPage(Sender: TCustomQuickRep);
var
  vIniFile: TIniFile;
begin
  vIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.Ini');
  QRLabel1.Caption := viniFile.ReadString('System', 'Name', '');
  QRLabel2.Caption := viniFile.ReadString('System', 'La1', '');

  QRLabel10.Caption := '����Ա:' + Label19.Caption;
  QRLabel7.Caption := 'Ӧ��:' + Label14.Caption + 'Ԫ';
  QRLabel8.Caption := 'ʵ��:' + Label15.Caption + 'Ԫ';
  QRLabel9.Caption := '����:' + Label16.Caption + 'Ԫ';

  qrlbl13.Caption := '�ռ���:' + Main_T.edt1.Text;
  qrlbl14.Caption := '�绰:' + Main_T.edt2.Text;
  qrlbl15.Caption := '�ջ���ַ:' + Main_T.edt3.Text;
  qrlbl19.Caption := '���ʽ:' + Main_T.cbb1.Text;


  qrlbl16.Caption := '���˲�:' + Main_T.edt4.Text;
  qrlbl17.Caption := '�绰:' + Main_T.edt5.Text;
  qrlbl18.Caption := '���˲���ַ:' + Main_T.edt6.Text;


  qrlbl20.Caption := '����:' + FormatDateTime('dddddd tt', Now);
  qrlbl21.Caption := '����:��' + Label26.Caption;
  qrlbl22.Caption := '�����绰:' + viniFile.ReadString('System', 'TEL', '');
  qrlbl23.Caption := viniFile.ReadString('System', 'La2', '');
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
  ADOQuerySQL.SQL.Add('Select * from selllogmains Where slid="' + Label26.Caption + '"');
  ADOQuerySQL.ExecSQL;
  if ADOQuerySQL.RecordCount = 0 then
  begin

    ADOQuerySQL.SQL.Clear;
    ADOQuerySQL.SQL.Add('insert into selllogmains(slid,custid,custstate,custname,shopname,custtel,custaddr,sname,stel,saddress,payment,status,uname,cdate,remark,created_at,updated_at) values("' + Label26.Caption + '","' + edt7.Text + '","' + edt8.Text + '","' + edt1.Text + '","' + RzEdit7.Text + '","' + edt2.Text + '","' + edt3.Text + '","' + edt4.Text + '","' + edt5.Text + '","' + edt6.Text + '","' + cbb1.Text + '","0","' + Label19.Caption + '",now(),"' + mmo1.Lines.GetText + '",now(),now())');
    ADOQuerySQL.ExecSQL;

  end;

  //ADOQuerySQL.SQL.Clear;
  //ADOQuerySQL.SQL.Add('insert into selllogdetails(slid,pid,barcode,goodsname,size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,bundle,discount,additional,cdate,status,created_at,updated_at) values("' + Label26.Caption + '","' + ADOQuery2.FieldByName('pid').AsString + '","' + ADOQuery2.FieldByName('barcode').AsString + '","' + ADOQuery2.FieldByName('goodsname').AsString + '","' + ADOQuery2.FieldByName('size').AsString + '","' + ADOQuery2.FieldByName('color').AsString + '","' + ADOQuery2.FieldByName('volume').AsString + '","' + ADOQuery2.FieldByName('unit').AsString + '","' + ADOQuery2.FieldByName('inprice').AsString + '","' + ADOQuery2.FieldByName('pfprice').AsString + '","' + ADOQuery2.FieldByName('pfprice').AsString + '","' + ADOQuery2.FieldByName('pfprice').AsString + '","' + RzEdit3.Text + '","0","' + RzEdit1.Text + '","-",now(),"0",now(),now()) on duplicate key update amount=amount+1,updated_at=now()');
  //ADOQuerySQL.ExecSQL;

  QH1;
  QH2;


end;

{����ָ�����ŵĺϼƼ۸�}

procedure TMain_T.QH2;
begin
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('Select -sum(subtotal) from afterselldetails Where tid="' + Label26.Caption + '" and type="�˻�"');
  ADOQuery2.Open;

  Label7.Caption := FormatFloat('0.00', ADOQuery2.Fields[0].AsCurrency)
end;

{�����ݼ�}

procedure TMain_T.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  slid: string;
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

    VK_F2: RzEdit3.SetFocus; //�޸�����

    VK_F3: RzEdit5.SetFocus; //�޸ļ���

    VK_F4: RzEdit2.SetFocus; //�޸ĵ���

    VK_F5: RzComboBox1.SetFocus; //�ۺ�������ͣ��˻�/����/ά��/����/

    VK_F6: //����ǰδ����˻��������� set status=0
      begin

        ADOQuerySQL.SQL.Clear;
        ADOQuerySQL.SQL.Add('insert into aftersellmains(tid,custid,custstate,custname,shopname,custtel,custaddr,yingshou,shishou,sname,stel,saddress,payment,status,uname,cdate,remark,created_at,updated_at) values("' + Label26.Caption + '","","' + edt8.Text + '","' + edt1.Text + '","' + RzEdit7.Text + '","' + edt2.Text + '","' + edt3.Text + '","0","0","' + edt4.Text + '","' + edt6.Text + '","' + edt5.Text + '","' + cbb1.Text + '","0","' + Label19.Caption + '",now(),"' + mmo1.Lines.GetText + '",now(),now()) on duplicate key update custstate="' + edt8.Text + '",custname="' + edt1.Text + '",shopname="' + RzEdit7.Text + '",custtel="' + edt2.Text + '",custaddr="' + edt3.Text + '",sname="' + edt4.Text + '",stel="' + edt6.Text + '",saddress="' + edt5.Text + '",payment="' + cbb1.Text + '",uname="' + Label19.Caption + '",remark="' + mmo1.Lines.GetText + '",updated_at=now()');
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

        ADOQuery2.SQL.Clear;
        ADOQuery2.SQL.Add('select * from selllogmains where nextid="' + Main_T.Label26.Caption + '" and type="�ۺ���"');
        ADOQuery2.Open;
        if ADOQuery2.RecordCount < 1 then
        begin
          ShowMessage('"' + Main_T.Label26.Caption + '"û���ҵ�ԭʼ������Ϣ������ϵ����Ա~~!');
          Exit;
        end
        else
        begin
          if messagedlg('ȡ�����ۺ󶩵���?', mtconfirmation, [mbyes, mbno], 0) = mryes then
          begin
            //����
            ADOQuerySQL.SQL.Clear;
            ADOQuerySQL.SQL.Add('update selllogmains set type="������", nextid="" where slid="' + ADOQuery2.FieldByName('slid').AsString + '"');
            ADOQuerySQL.ExecSQL;

            {���Ƽ�¼}
            //����
            ADOQuerySQL.SQL.Clear;
            ADOQuerySQL.SQL.Add('delete from aftersellmains where tid="' + Main_T.Label26.Caption + '"');
            ADOQuerySQL.ExecSQL;

            //��ϸ��
            ADOQuerySQL.SQL.Clear;
            ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' + Main_T.Label26.Caption + '"');
            ADOQuerySQL.ExecSQL;
          end;
        end;

        QH1;
        QH2;
      end;

    VK_F10: RzEdit1.SetFocus;

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

    VK_F12: SpeedButton2.Click;

    VK_UP:
      begin
        DBGrid1.SetFocus;
      end;

    VK_DOWN:
      begin
        DBGrid1.SetFocus;
      end;

    VK_DELETE: //ɾ����Ʒ��Ŀ
      begin
        if ADOQuery1.RecordCount > 0 then
        begin


          if ADOQuery1.FieldByName('pid').AsString = '' then
          begin
            if messagedlg('��յ�ǰ�����е�������Ʒ��?', mtconfirmation, [mbyes, mbno], 0) = mryes then
            begin
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' + Label26.Caption + '"');
              ADOQuerySQL.ExecSQL;
            end
            else
              Exit;
          end
          else
          begin
            if messagedlg('ȷ��ɾ��"' + ADOQuery1.FieldByName('goodsname').AsString + '"��?', mtconfirmation, [mbyes, mbno], 0) = mryes then
            begin
              //ADOQuery1.Delete;
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('delete from afterselldetails where tid="' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
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
          if ADOQuery1.FieldByName('pid').AsString = '' then //�ϼ���
          begin
            {�ݲ�֧��������������}
          end
          else
          begin
            ADOQuery2.SQL.Clear;
            ADOQuery2.SQL.Add('select * from selllogmains where nextid="' + Main_T.Label26.Caption + '" and type="�ۺ���"');
            ADOQuery2.Open;
            if ADOQuery2.RecordCount < 1 then
            begin
              ShowMessage('"' + Main_T.Label26.Caption + '"û���ҵ�ԭʼ������Ϣ������ϵ����Ա~~!');
              Exit;
            end
            else
            begin
              slid := ADOQuery2.FieldByName('slid').AsString;

              ADOQuery2.SQL.Clear;
              ADOQuery2.SQL.Add('select * from selllogdetails where slid="' + slid + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
              ADOQuery2.Open;

              //һ���Ʒ���������ܳ���ԭʼ�����еĲ�Ʒ����
              if ADOQuery1.FieldByName('amount').AsInteger < ADOQuery2.FieldByName('amount').AsInteger then
              begin
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update afterselldetails set amount=(amount+1),updated_at=now()  where tid="' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
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
          if ADOQuery1.FieldByName('pid').AsString = '' then
          begin
            if messagedlg('���ٵ�ǰ���������в�Ʒ������?', mtconfirmation, [mbyes, mbno], 0) = mryes then
            begin
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set amount=(if(amount>1,amount-1,amount)),updated_at=now()  where tid="' + Label26.Caption + '"');
              ADOQuerySQL.ExecSQL;
            end
            else
              Exit;
          end
          else
          begin
            if ADOQuery1.FieldByName('amount').AsCurrency > 1 then
            begin
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update afterselldetails set amount=(amount-1),updated_at=now()  where tid="' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
              ADOQuerySQL.ExecSQL;
            end;
          end;

          QH1;
          QH2;
        end;
      end;

  end;
end;

{�޸��ۿ���Ϣ}

procedure TMain_T.RzEdit1KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuerySQL.SQL.Add('update afterselldetails set discount="' + RzEdit1.Text + '",updated_at=now() where tid = "' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit1.Text := '100';
    RzEdit4.SetFocus;
  end;
end;

{�޸�����}

procedure TMain_T.RzEdit3KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuerySQL.SQL.Add('update afterselldetails set amount="' + RzEdit3.Text + '",updated_at=now() where tid = "' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit3.Text := '1';
    RzEdit4.SetFocus;
  end;
end;


{�޸ļ���}

procedure TMain_T.RzEdit5KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuerySQL.SQL.Add('update afterselldetails set bundle="' + RzEdit5.Text + '",updated_at=now() where tid = "' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit5.Text := '1';
    RzEdit4.SetFocus;
  end;
end;

{�޸ĵ���}

procedure TMain_T.RzEdit2KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuerySQL.SQL.Add('update afterselldetails set outprice="' + RzEdit2.Text + '",updated_at=now() where tid = "' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit4.SetFocus;
  end;
end;


{�����ƶ��б���ʱ��������}

procedure TMain_T.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RzEdit1.Text := ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text := ADOQuery1.FieldByName('outprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
  RzEdit5.Text := ADOQuery1.FieldByName('bundle').AsString;
  RzComboBox1.Text := ADOQuery1.FieldByName('type').AsString;
end;

procedure TMain_T.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RzEdit1.Text := ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text := ADOQuery1.FieldByName('outprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
  RzEdit5.Text := ADOQuery1.FieldByName('bundle').AsString;
  RzComboBox1.Text := ADOQuery1.FieldByName('type').AsString;
end;

{������������Ʒ}

procedure TMain_T.RzEdit4KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    //������Ϊ�������
    if (RzEdit4.Text = '') and (ADOQuery1.RecordCount > 0) then
    begin

      if cbb1.Text = '' then
      begin
        ShowMessage('��ѡ��֧����ʽ~~!');
        cbb1.SetFocus;
        Exit;
      end;

      Gathering := TGathering.create(application);
      Gathering.showmodal;
      Exit;
    end;

    {����Ҫ��������ͻ�����}
    //����������
    if edt1.Text = '' then
    begin
      ShowMessage('��������ͻ���Ϣ�ٿ�ʼ�µ�~~!');
      edt1.SetFocus;
      Exit;
    end;

    {�ṩ�ͻ�ѡ���Ʒ�Ĺ���}
    if QP <> nil then
      QP.ShowModal
    else
    begin
      QP := TQP.Create(Application);
      QP.ShowModal;
    end;


    //�ڿ���а����������Ʒ
    ADOQuerySQL.SQL.Clear;
    ADOQuerySQL.SQL.Add('Select * from stocks Where pid="' + RzEdit4.Text + '"');
    ADOQuerySQL.ExecSQL;
    if ADOQuerySQL.RecordCount <> 0 then
    begin
      WRecord;
      RzEdit4.Text := '';
      RzEdit4.SetFocus;
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;


{���ݿͻ�����ģ����ѯ�ÿͻ�����ʷ����}

procedure TMain_T.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
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

procedure TMain_T.edt4KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin

    {����Ҫ��������ͻ�����}
  //���ͻ����
    if edt7.Text = '' then
    begin
      if messagedlg('�����¿ͻ���', mtconfirmation, [mbyes, mbno], 0) = mryes then
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

procedure TMain_T.qrlbl12Print(sender: TObject; var Value: string);
begin
  Value := '��' + IntToStr(QuickRep1.QRPrinter.PageNumber) + 'ҳ / ��' + IntToStr(FTotalPages) + 'ҳ';
end;

procedure TMain_T.edt8KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if QC_S <> nil then
      QC_S.ShowModal
    else
    begin
      QC_S := TQC_S.Create(Application);
      QC_S.ShowModal;
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;

procedure TMain_T.edt2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    if QC_T <> nil then
      QC_T.ShowModal
    else
    begin
      QC_T := TQC_T.Create(Application);
      QC_T.ShowModal;
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
  Main_T.Top := (GetSystemMetrics(SM_CySCREEN) - Main_T.Height) div 2 - 13;
  Main_T.Left := (GetSystemMetrics(SM_CxSCREEN) - Main_T.Width) div 2;

end;

procedure TMain_T.RzComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;

    if (RzComboBox1.Text <> '') and (RzComboBox1.Text <> '�˻�') and (RzComboBox1.Text <> 'ά��') and (RzComboBox1.Text = '����') then
    begin
      ShowMessage('��ѡ����Ч���ۺ�����~~!');
      Exit;
    end
    else
    begin

      if ADOQuery1.FieldByName('pid').AsString = '' then
      begin
        if messagedlg('���õ�ǰ�����е�������Ʒ�ۺ�������?', mtconfirmation, [mbyes, mbno], 0) = mryes then
        begin
          ADOQuerySQL.SQL.Clear;
          ADOQuerySQL.SQL.Add('update afterselldetails set type="' + RzComboBox1.Text + '",updated_at=now() where tid="' + Label26.Caption + '"');
          ADOQuerySQL.ExecSQL;
        end
        else
          Exit;
      end
      else
      begin
        ADOQuerySQL.SQL.Clear;
        ADOQuerySQL.SQL.Add('update afterselldetails set type="' + RzComboBox1.Text + '",updated_at=now() where tid="' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
        ADOQuerySQL.ExecSQL;
      end;
    end;
    QH1;
    QH2;

    RzEdit4.SetFocus;
  end;
end;

end.

