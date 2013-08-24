unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, DBGrids, DB,
  ADODB, INIFiles,
  RzForms, RzStatus, Mask, RzEdit, QRCtrls, QuickRpt,
  Registry, DBTables,
  RzCmboBx, RzButton, RzRadChk;

type
  TMain = class(TForm)
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
    ADOQuery2: TADOQuery;
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
    ADOConnection1: TADOConnection;
    ADOQuery3: TADOQuery;
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
    ADOQuery4: TADOQuery;
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
    lbl11: TLabel;
    RzEdit7: TRzEdit;
    rzchckbx1: TRzCheckBox;
    bvl1: TBevel;
    lbl12: TLabel;
    lbl13: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action:
      TCloseAction);
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
    procedure RzComboBox1KeyPress(Sender: TObject; var Key:
      Char);
  private
    { Private declarations }
  public
    reprint: Boolean;
    qsrc: string;

    uid: string;
    cid: string;
    sid: string;

    procedure QH1;
    procedure WRecord;
    procedure QH2;
    procedure ListRefresh;
    procedure GetOrderId;
    procedure GetLoginTime;
    procedure calcPrice();
    { Public declarations }
  end;

var
  Main: TMain;
  FTotalPages: Integer;
  UpdateTimeStr: string;

implementation

uses Unit1, Unit3, Unit5, Unit7, Unit9, Unit10, Unit11,
  Unit12, Unit13, Unit14,
  Unit4, Unit19, Unit20;

{$R *.dfm}

{�����Ʒ����}

procedure TMain.calcPrice();
begin
  {���ͻ��Ƿ����ض��Żݿͻ��������Ż����ڣ�������Żݼ۸񣬷�����������۸�}
  {��������ۿͻ��޼۸���ʾ}
  ADOQuery4.SQL.Clear;
  ADOQuery4.SQL.Add('select hprice from memberprices where pid = "' +
    RzEdit4.Text + '" and custid = "' + edt7.Text +
    '" and current_timestamp() between startdate and enddate');
  ADOQuery4.Open;
  if ADOQuery4.RecordCount = 1 then
  begin
    ADOQuery1.Edit;
    ADOQuery1.FieldByName('outprice').AsString :=
      ADOQuery4.FieldByName('hprice').AsString;

    UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss',
      Now);
    if ADOQuery1.FieldByName('created_at').AsString = ''
      then
      ADOQuery1.FieldByName('created_at').AsString :=
        UpdateTimeStr;
    ADOQuery1.FieldByName('updated_at').AsString :=
      UpdateTimeStr;

    ADOQuery1.Post;
    ADOQuery1.Refresh;
  end;
end;

{��ʼ���µ�ҳ��}

procedure TMain.FormCreate(Sender: TObject);
var
  vIniFile: TIniFile;
  //Reg: TRegistry;
  ds: string;
  //i: Integer;
begin
  //����INI�ļ�����
  vIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0))
    +
    'Config.Ini');
  ds := vIniFile.Readstring('System', 'Data Source',
    'shop');
  {
  //����INI�ļ�����
  vIniFile:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Config.Ini');
  //д�Ƿ�Ϊע��汾
  if Pass.Key(vIniFile.Readstring('System','PCID',''))=vIniFile.Readstring('System','Key','') then
  begin
    Main.Label1.Caption:='����ע�ᣩ';
  end
  else
  begin
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_CURRENT_USER;
    Reg.OpenKey('Software\WL',True);
    D1:=CurrToStr(44-(StrToDate(FormatdateTime('yyyy-mm-dd', Now))-StrToDate(Reg.ReadString('Date'))));
    Main.Label1.Caption:='��δע�ᣩʣ��'+D1+'��';
    Main.SpeedButton2.Caption:='F12.���ע��';
    //��ע�ᴰ��
//    RegKey:=TRegKey.Create(Application);
//    RegKey.showmodal;
  end;
  }
  {���Ų���λ����}

  {
  Main.Width:=1045;//�ָ������ڴ�С
  Main.Height:=810;//�ָ������ڴ�С
  }

  //ʹ������λ����Ļ������
  Main.Top := (GetSystemMetrics(SM_CySCREEN) - Main.Height)
    div 2 - 13;
  Main.Left := (GetSystemMetrics(SM_CxSCREEN) - Main.Width)
    div 2;
  //�������ݿ�����
  {
  Data:='Provider='+vIniFile.Readstring('System','Provider','')+';';
  Data:=Data+'Data Source='+vIniFile.Readstring('System','Data Source','')+';';
  Data:=Data+'Persist Security Info=False';
  ADOConnection1.ConnectionString:=Data;
  }
  ADOConnection1.ConnectionString := 'Provider=MSDASQL.1;'
    +
    'Persist Security Info=False;' +
    'User ID=root;' +
    'Password=zaqwsxcde123;' +
    'Data Source=' + ds; //shop';
  {���ɳ�ʼ����}
  GetOrderId;

  ListRefresh;
  QH2;
  {��ʽ��С����ʾ}
  //TFloatField(DBGrid1.DataSource.DataSet.FieldByName('volume')).DisplayFormat := '0.00';

end;

{��ȡ����}

procedure TMain.GetOrderId;
begin
  {ÿ����󵥺�9999}

  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('select concat("C",DATE_FORMAT(now(),"%y%m%d"),lpad(cast(substr(if(max(slid) is null,"0000",max(slid)),8) as signed) + 1,4,"0")) as id from selllogmains where DATE_FORMAT(created_at,"%y%m%d")=DATE_FORMAT(now(),"%y%m%d") and slid like "C%"');
  ADOQuery2.Open;

  //��ȡ����
  Label26.Caption := ADOQuery2.FieldByName('id').AsString;
end;

procedure TMain.GetLoginTime;
begin

  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('select now() as now');
  ADOQuery2.Open;

  //��ȡ����
  Label21.Caption := ADOQuery2.FieldByName('now').AsString;
end;

{ˢ���б�}

procedure TMain.ListRefresh;
var
  bookmark: Pointer;
begin
  {��¼��ǰ�������λ�ã��Ա���ˢ�����ݺ�ָ���ǰ��λ��}
  bookmark := ADOQuery1.GetBookmark;

  ADOQuery1.SQL.Clear;

  //ADOQuery1.SQL.Add('Select * from selllogdetails Where slid="' + Label26.Caption + '" order by pid');
  ADOQuery1.SQL.Add('(select (@row := @row + 1) as row,id, store, pid,goodsname,color,FORMAT(volume,2) as volume,FORMAT(amount,0) as amount,unit,FORMAT(bundle,0) as bundle,FORMAT(outprice,0) as outprice,discount,additional,type,FORMAT((subtotal),0) as subtotal, ');
  ADOQuery1.SQL.Add('slid, barcode, size, inprice, pfprice, hprice from selllogdetails, (SELECT @row := 0) r where slid = "' + Label26.Caption +
    '" order by id) union (select "�ϼ�" as row, "" as id, "" as store, "" as pid, "" as goodsname, "" as color,FORMAT(sum(volume*amount),2) ');
  ADOQuery1.SQL.Add('as volume,FORMAT(sum(amount),0) as amount,"" as unit,FORMAT(sum(bundle),0) as bundle,"" as outprice,"" as discount,"" ');
  ADOQuery1.SQL.Add('as additional,"" as type,FORMAT(sum(subtotal),0) as subtotal, "" as slid, "" as barcode, "" as size, "" as inprice, "" as pfprice, "" as hprice  from selllogdetails where slid = "' + Label26.Caption + '")');

  ADOQuery1.Open;
  if ADOQuery1.RecordCount > 1 then
    ADOQuery1.GotoBookmark(bookmark);

  ADOQuery1.FreeBookmark(bookmark);

end;

procedure TMain.FormClose(Sender: TObject; var Action:
  TCloseAction);
begin
  if messagedlg('ȷ���˳���', mtconfirmation, [mbyes,
    mbno], 0) = mryes then
    Application.Terminate
  else
    Action := caNone;
end;

procedure TMain.SpeedButton1Click(Sender: TObject);
begin
  Main.Close;
end;

procedure TMain.SpeedButton2Click(Sender: TObject);
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
    Main.Top := (GetSystemMetrics(SM_CySCREEN) -
      Main.Height) div 2 - 13;
    Main.Left := (GetSystemMetrics(SM_CxSCREEN) -
      Main.Width) div 2;
  end;
end;

{��ӡ�����ϵ���Ϣ}

procedure TMain.QuickRep1StartPage(Sender:
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
  QRLabel8.Caption := 'ʵ��:' + Label15.Caption + 'Ԫ';
  QRLabel9.Caption := '����:' + Label16.Caption + 'Ԫ';

  qrlbl13.Caption := '�ռ���:' + Main.edt1.Text;
  qrlbl14.Caption := '�绰:' + Main.edt2.Text;
  qrlbl15.Caption := '�ջ���ַ:' + Main.edt3.Text;
  qrlbl19.Caption := '���ʽ:' + Main.cbb1.Text;

  qrlbl16.Caption := '���˲�:' + Main.edt4.Text;
  qrlbl17.Caption := '�绰:' + Main.edt5.Text;
  qrlbl18.Caption := '���˲���ַ:' + Main.edt6.Text;

  qrlbl20.Caption := '����:' + FormatDateTime('dddddd tt',
    Now);
  qrlbl21.Caption := '����:��' + Label26.Caption;
  qrlbl22.Caption := '�����绰:' +
    viniFile.ReadString('System', 'TEL', '');
  qrlbl23.Caption := viniFile.ReadString('System', 'La2',
    '');
end;

{����ÿ����Ʒ��С�ƽ��}

procedure TMain.QH1;
begin

  ADOQuerySQL.SQL.Clear;
  ADOQuerySQL.SQL.Add('update selllogdetails set subtotal=(if(additional="-",(outprice*amount*discount/100),0)),updated_at=now() where slid = "' + Label26.Caption + '"');
  ADOQuerySQL.ExecSQL;

  {ˢ���б�}
  ListRefresh;
end;

{�����в�Ʒ����}

procedure TMain.WRecord;
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
  Main.ADOConnection1.BeginTrans;
  try

    {���²�Ʒѡ����Ϣ���м�¼�͸��£��޼�¼�Ͳ���}
    //�����������Ƿ��д˵���
    //todo:Ӧ��ʹ��insert into on duplicat update ���ȷ�������ֶ���ÿ���޸�ʱ�����£�����������ύ����ʱ�ٸ���
    ADOQuery3.SQL.Clear;
    ADOQuery3.SQL.Add('Select * from selllogmains Where slid="' + Label26.Caption
      +
      '"');
    ADOQuery3.Open;
    if ADOQuery3.RecordCount = 0 then
    begin

      ADOQuerySQL.SQL.Clear;
      ADOQuerySQL.SQL.Add('insert into selllogmains(slid,custid,custstate,custname,shopname,custtel,custaddr,sname,stel,saddress,payment,status,type,uid,uname,cdate,remark,created_at,updated_at) values("' + Label26.Caption + '","' + edt7.Text + '","' + edt8.Text
        +
        '","' + edt1.Text +
        '","' + RzEdit7.Text + '","' + edt2.Text + '","' + edt3.Text + '","' +
        edt4.Text + '","' +
        edt5.Text + '","' + edt6.Text + '","' + cbb1.Text +
        '","0","������","' + uid + '","' +
        Label19.Caption + '",now(),"' + mmo1.Lines.GetText +
        '",now(),now())');
      ADOQuerySQL.ExecSQL;

    end;

    if rzchckbx1.Checked then //ά�޿�
    begin
      ADOQuerySQL.SQL.Clear;
      ADOQuerySQL.SQL.Add('insert into selllogdetails(slid,store,pid,barcode,goodsname,size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,bundle,discount,additional,type,cdate,status,created_at,updated_at) values("' + Label26.Caption + '","' +
        ADOQuery2.FieldByName('store').AsString + '","' +
        ADOQuery2.FieldByName('pid').AsString + '","' +
        ADOQuery2.FieldByName('barcode').AsString + '","' +
        ADOQuery2.FieldByName('goodsname').AsString + '","' +
        ADOQuery2.FieldByName('size').AsString + '","' +
        ADOQuery2.FieldByName('color').AsString + '","' +
        ADOQuery2.FieldByName('volume').AsString + '","' +
        ADOQuery2.FieldByName('unit').AsString + '","' +
        ADOQuery2.FieldByName('inprice').AsString + '","' +
        ADOQuery2.FieldByName('pfprice').AsString + '","' +
        ADOQuery2.FieldByName('pfprice').AsString + '","' +
        ADOQuery2.FieldByName('pfprice').AsString + '","' +
        RzEdit3.Text + '","0","'
        + RzEdit1.Text +
        '","����","' + ADOQuery2.FieldByName('type').AsString
        +
        '",now(),"0",now(),now()) on duplicate key update amount=amount+1,type="' +
        ADOQuery2.FieldByName('type').AsString +
        '", updated_at=now()');
      ADOQuerySQL.ExecSQL;
    end
    else
    begin
      ADOQuerySQL.SQL.Clear;
      ADOQuerySQL.SQL.Add('insert into selllogdetails(slid,store,pid,barcode,goodsname,size,color,volume,unit,inprice,pfprice,hprice,outprice,amount,bundle,discount,additional,cdate,status,created_at,updated_at) values("' + Label26.Caption + '","","' +
        ADOQuery2.FieldByName('pid').AsString + '","' +
        ADOQuery2.FieldByName('barcode').AsString + '","' +
        ADOQuery2.FieldByName('goodsname').AsString + '","' +
        ADOQuery2.FieldByName('size').AsString + '","' +
        ADOQuery2.FieldByName('color').AsString + '","' +
        ADOQuery2.FieldByName('volume').AsString + '","' +
        ADOQuery2.FieldByName('unit').AsString + '","' +
        ADOQuery2.FieldByName('inprice').AsString + '","' +
        ADOQuery2.FieldByName('pfprice').AsString + '","' +
        ADOQuery2.FieldByName('pfprice').AsString + '","' +
        ADOQuery2.FieldByName('pfprice').AsString + '","' +
        RzEdit3.Text + '","0","'
        + RzEdit1.Text +
        '","-",now(),"0",now(),now()) on duplicate key update amount=amount+1,updated_at=now()');
      ADOQuerySQL.ExecSQL;
    end;

    calcPrice();

    Main.ADOConnection1.CommitTrans;
  except
    Main.ADOConnection1.RollbackTrans;
  end;

  QH1;
  QH2;

end;

{����ָ�����ŵĺϼƼ۸�}

procedure TMain.QH2;
begin
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('Select sum(subtotal) from selllogdetails Where slid="' +
    Label26.Caption + '"');

  ADOQuery2.Open;
  Label7.Caption := FormatFloat('0.00',
    ADOQuery2.Fields[0].AsCurrency)
end;

{�����ݼ�}

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: SpeedButton1.Click;

    VK_SPACE:
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

    VK_F1: RzEdit4.SetFocus;

    VK_F2: RzEdit3.SetFocus; //����

    VK_F3: RzEdit5.SetFocus; //����

    VK_F4: RzEdit2.SetFocus; //����

    VK_F5: //����
      begin
        if ADOQuery1.FieldByName('additional').AsString =
          '-' then
        begin
          if ADOQuery1.RecordCount > 0 then
          begin
            ADOQuerySQL.SQL.Clear;
            ADOQuerySQL.SQL.Add('update selllogdetails set additional="��Ʒ",updated_at=now()  where slid="' + Label26.Caption + '" and pid="' +
              ADOQuery1.FieldByName('pid').AsString +
              '"');
            ADOQuerySQL.ExecSQL;
          end;
          QH1;
          QH2;
        end
        else if ADOQuery1.FieldByName('additional').AsString
          = '��Ʒ' then
        begin
          if ADOQuery1.RecordCount > 0 then
          begin
            ADOQuerySQL.SQL.Clear;
            ADOQuerySQL.SQL.Add('update selllogdetails set additional="-",updated_at=now()  where slid="' + Label26.Caption + '" and pid="' +
              ADOQuery1.FieldByName('pid').AsString +
              '"');
            ADOQuerySQL.ExecSQL;
          end;
          QH1;
          QH2;
        end;
      end;

    VK_F6: //����δ��ɳ��ⵥ
      begin

        {������չ��Ϣ}
         //�����������Ƿ��д˵���

        ADOQuerySQL.SQL.Clear;
        ADOQuerySQL.SQL.Add('insert into selllogmains(slid,custid,custstate,custname,shopname,custtel,custaddr,yingshou,shishou,sname,stel,saddress,payment,status,uname,cdate,remark,created_at,updated_at) values("' + Label26.Caption + '","","' + edt8.Text + '","' +
          edt1.Text + '","' +
          RzEdit7.Text + '","' + edt2.Text + '","' +
          edt3.Text + '","0","0","' +
          edt4.Text + '","' + edt5.Text + '","' + edt6.Text
          + '","' + cbb1.Text +
          '","0","' + Label19.Caption + '",now(),"' +
          mmo1.Lines.GetText +
          '",now(),now()) on duplicate key update custstate="' +
          edt8.Text +
          '",custname="' + edt1.Text + '",shopname="' +
          RzEdit7.Text +
          '",custtel="' + edt2.Text + '",custaddr="' +
          edt3.Text + '",sname="' +
          edt4.Text + '",stel="' + edt5.Text +
          '",saddress="' + edt6.Text +
          '",payment="' + cbb1.Text + '",uname="' +
          Label19.Caption + '",remark="'
          + mmo1.Lines.GetText + '",updated_at=now()');
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

        {��ʽ��С����ʾ}
        //TFloatField(DBGrid1.DataSource.DataSet.FieldByName('volume')).DisplayFormat := '0.00';
        RzEdit4.SetFocus;
      end;

    VK_F7: //ȡδ��ɳ��ⵥ
      begin
        if QD <> nil then
          QD.ShowModal
        else
        begin
          QD := TQD.Create(Application);
          QD.ShowModal;
          RzEdit4.SetFocus;
        end;
      end;

    VK_F8: //�˻����ۺ�
      begin
        if Main_T <> nil then
          Main_T.ShowModal
        else
        begin
          Main_T := TMain_T.Create(Application);
          Main_T.ShowModal;
        end;
      end;
    {
    VK_F9: //����
      begin
        if Pos_Setup <> nil then
          Pos_Setup.ShowModal
        else
        begin
          Pos_Setup := TPos_Setup.Create(Application);
          Pos_Setup.ShowModal;
        end;
      end;
    }
    VK_F10: RzEdit1.SetFocus; //�ۿ�

    VK_F11: //ȡ�ͻ��������д����Ѿ�����selllogmain�еĶ�����Ϣ��ɾ����
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

    VK_DELETE:
      begin
        if ADOQuery1.RecordCount > 0 then
        begin

          if ADOQuery1.FieldByName('additional').AsString =
            '����' then
          begin

            if messagedlg('ȷ��ɾ��"' +
              ADOQuery1.FieldByName('goodsname').AsString
              +
              '"��?', mtconfirmation,
              [mbyes, mbno], 0) = mryes then
            begin

              Main.ADOConnection1.BeginTrans;
              try

                //���ڴ�ά�޿ⲹ������Ҫ�������ӵ��������ܳ�������ά�޵�����
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update selllogmains sm, selllogdetails sd, aftersellmains am, afterselldetails ad set ad.type="ά��",sm.preid="",sm.updated_at=now(), ad.ramount=(ad.ramount+sd.amount) where sd.slid="' + Label26.Caption + '" and sd.pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '" and not(ad.status) and ad.tid=am.tid and sm.slid=sd.slid and sd.additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  + '" and am.custtel="' +
                  edt2.Text +
                  '" and sd.pid=ad.pid and ad.type="���ⵥռ��" and ad.tid="' +
                  ADOQuery1.FieldByName('store').AsString +
                  '"');
                ADOQuerySQL.ExecSQL;

                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('delete from selllogdetails where slid="' +
                  Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '" and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  + '"');
                ADOQuerySQL.ExecSQL;
                Main.ADOConnection1.CommitTrans;
              except
                Main.ADOConnection1.RollbackTrans;
              end;
            end;

          end
          else
          begin
            //���ڴӲɹ��������ȡ���������
            if ADOQuery1.FieldByName('pid').AsString = ''
              then
            begin
              if messagedlg('��յ�ǰ�����е�������Ʒ��?',
                mtconfirmation, [mbyes,
                mbno], 0) = mryes then
              begin
                Main.ADOConnection1.BeginTrans;
                try
                  //����ά�޿�����Ҫ��������
                  ADOQuery1.First;
                  while not (Main.ADOQuery1.Eof) do
                  begin
                    if
                      ADOQuery1.FieldByName('additional').AsString =
                      '����' then
                    begin
                      ADOQuerySQL.SQL.Clear;
                      ADOQuerySQL.SQL.Add('update selllogmains sm, selllogdetails sd, aftersellmains am, afterselldetails ad set ad.type="ά��",sm.preid="",sm.updated_at=now(), ad.ramount=(ad.ramount+sd.amount) where sd.slid="' + Label26.Caption + '" and sd.pid="' +
                        ADOQuery1.FieldByName('pid').AsString
                        +
                        '" and not(ad.status) and ad.tid=am.tid and sm.slid=sd.slid and sd.additional="' +
                        ADOQuery1.FieldByName('additional').AsString
                        + '" and am.custtel="' +
                        edt2.Text +
                        '" and sd.pid=ad.pid and ad.type="���ⵥռ��" and ad.tid="' +
                        ADOQuery1.FieldByName('store').AsString
                        +
                        '"');
                      ADOQuerySQL.ExecSQL;
                    end;
                    ADOQuery1.Next;
                  end;

                  ADOQuerySQL.SQL.Clear;
                  ADOQuerySQL.SQL.Add('delete from selllogdetails where slid="'
                    +
                    Label26.Caption + '"');
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
              if messagedlg('ȷ��ɾ��"' +
                ADOQuery1.FieldByName('goodsname').AsString
                +
                '"��?', mtconfirmation,
                [mbyes, mbno], 0) = mryes then
              begin
                //ADOQuery1.Delete;
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('delete from selllogdetails where slid="' +
                  Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '"');
                ADOQuerySQL.ExecSQL;
              end;
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

    VK_ADD:
      begin
        if ADOQuery1.RecordCount > 0 then
        begin
          //ADOQuery1.Edit;
          //ADOQuery1.FieldByName('amount').AsCurrency := ADOQuery1.FieldByName('amount').AsCurrency + 1;
          {���ѡ����Ǻϼ��У����������е��в�Ʒ����}

          if ADOQuery1.FieldByName('additional').AsString =
            '����' then
          begin
            //���ڴ�ά�޿ⲹ������Ҫ�������ӵ��������ܳ�������ά�޵�����
            ADOQuerySQL.SQL.Clear;
            //ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ad.type=if(ad.ramount<=1,"���ⵥռ��","ά��"),');
            ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ');
            ADOQuerySQL.SQL.Add('sd.amount=if(ad.ramount>0,(sd.amount+1),sd.amount), ad.ramount=if(ad.ramount>0,(ad.ramount-1),ad.ramount),sd.updated_at=now(),ad.updated_at=now() where sd.slid="' + Label26.Caption + '" and sd.pid="' +
              ADOQuery1.FieldByName('pid').AsString +
              '" and not(ad.status) and ad.type="ά��" and ad.tid=am.tid and am.custtel="' +
              edt2.Text +
              '" and sd.pid=ad.pid and sd.additional="' +
              ADOQuery1.FieldByName('additional').AsString
              + '" and ad.tid="'
              + ADOQuery1.FieldByName('store').AsString +
              '"');
            ADOQuerySQL.ExecSQL;
          end
          else
          begin
            //���ڴӲɹ��������ȡ���������
            if ADOQuery1.FieldByName('pid').AsString = ''
              then
            begin
              if
                messagedlg('���ӵ�ǰ���������в�Ʒ������?',
                mtconfirmation,
                [mbyes, mbno], 0) = mryes then
              begin

                Main.ADOConnection1.BeginTrans;
                try
                  ADOQuery1.First;
                  while not (Main.ADOQuery1.Eof) do
                  begin
                    if
                      ADOQuery1.FieldByName('additional').AsString =
                      '����' then
                    begin
                      //���ڴ�ά�޿ⲹ������Ҫ�������ӵ��������ܳ�������ά�޵�����
                      ADOQuerySQL.SQL.Clear;
                      //ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ad.type=if(ad.ramount<=1,"���ⵥռ��","ά��"),');
                      ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ');
                      ADOQuerySQL.SQL.Add('sd.amount=if(ad.ramount>0,(sd.amount+1),sd.amount), ad.ramount=if(ad.ramount>0,(ad.ramount-1),ad.ramount),sd.updated_at=now(),ad.updated_at=now() where sd.slid="' + Label26.Caption + '" and sd.pid="' +
                        ADOQuery1.FieldByName('pid').AsString
                        +
                        '" and not(ad.status) and ad.type="ά��" and ad.tid=am.tid and am.custtel="' +
                        edt2.Text +
                        '" and sd.pid=ad.pid and sd.additional="' +
                        ADOQuery1.FieldByName('additional').AsString
                        + '" and ad.tid="'
                        +
                        ADOQuery1.FieldByName('store').AsString +
                        '"');
                      ADOQuerySQL.ExecSQL;
                    end;
                    ADOQuery1.Next;
                  end;

                  ADOQuerySQL.SQL.Clear;
                  ADOQuerySQL.SQL.Add('update selllogdetails set amount=(amount+1),updated_at=now()  where slid="' + Label26.Caption + '" and additional<>"����"');
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
              ADOQuerySQL.SQL.Clear;
              ADOQuerySQL.SQL.Add('update selllogdetails set amount=(amount+1),updated_at=now()  where slid="' + Label26.Caption + '" and pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '" and additional="' +
                ADOQuery1.FieldByName('additional').AsString
                + '"');
              ADOQuerySQL.ExecSQL;
            end;
          end;
          QH1;
          QH2;

        end;

      end;

    VK_SUBTRACT:
      begin
        if ADOQuery1.RecordCount > 0 then
        begin
          //ADOQuery1.Edit;
          //ADOQuery1.FieldByName('amount').AsCurrency := ADOQuery1.FieldByName('amount').AsCurrency - 1;

          if ADOQuery1.FieldByName('additional').AsString =
            '����' then
          begin
            if ADOQuery1.FieldByName('amount').AsInteger > 1
              then
            begin
              //���ڴ�ά�޿ⲹ������Ҫ���Ƽ��ٵ�����ʱ��ͬʱ����ά�޿���е�������ͬ�µ�ǰ������Ϊ0
              //�����õ���set ����������������������ͳһ��������Ҫ�����ò�Ӱ�������ı������������쳣����Ϊ�����˳��ִ�еġ�
              ADOQuerySQL.SQL.Clear;
              //ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ad.type=if(ad.ramount>=0,"ά��","���ⵥռ��"),');
              ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ');
              ADOQuerySQL.SQL.Add(' ad.ramount=(ad.ramount+1), sd.amount=(sd.amount-1),sd.updated_at=now(),ad.updated_at=now() where sd.slid="' + Label26.Caption + '" and sd.pid="' +
                ADOQuery1.FieldByName('pid').AsString +
                '" and not(ad.status) and ad.type="ά��" and ad.tid=am.tid and am.custtel="' +
                edt2.Text +
                '" and sd.pid=ad.pid and sd.additional="' +
                ADOQuery1.FieldByName('additional').AsString
                + '" and ad.tid="'
                + ADOQuery1.FieldByName('store').AsString +
                '"');
              ADOQuerySQL.ExecSQL;
            end;
          end
          else
          begin
            //���ڴӲɹ��������ȡ���������
            if ADOQuery1.FieldByName('pid').AsString = ''
              then
            begin
              if
                messagedlg('���ٵ�ǰ���������в�Ʒ������?',
                mtconfirmation,
                [mbyes, mbno], 0) = mryes then
              begin
                Main.ADOConnection1.BeginTrans;
                try
                  ADOQuery1.First;
                  while not (Main.ADOQuery1.Eof) do
                  begin
                    if
                      ADOQuery1.FieldByName('additional').AsString =
                      '����' then
                    begin
                      if
                        ADOQuery1.FieldByName('amount').AsInteger > 1
                        then
                      begin
                        //���ڴ�ά�޿ⲹ������Ҫ���Ƽ��ٵ�����ʱ��ͬʱ����ά�޿���е�������ͬ�µ�ǰ������Ϊ0
                  //�����õ���set ����������������������ͳһ��������Ҫ�����ò�Ӱ�������ı������������쳣����Ϊ�����˳��ִ�еġ�
                        ADOQuerySQL.SQL.Clear;
                        //ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ad.type=if(ad.ramount>=0,"ά��","���ⵥռ��"),');
                        ADOQuerySQL.SQL.Add('update selllogdetails sd, aftersellmains am, afterselldetails ad set ');
                        ADOQuerySQL.SQL.Add(' ad.ramount=(ad.ramount+1), sd.amount=(sd.amount-1),sd.updated_at=now(),ad.updated_at=now() where sd.slid="' + Label26.Caption + '" and sd.pid="' +
                          ADOQuery1.FieldByName('pid').AsString
                          +
                          '" and not(ad.status) and ad.type="ά��" and ad.tid=am.tid and am.custtel="' +
                          edt2.Text +
                          '" and sd.pid=ad.pid and sd.additional="' +
                          ADOQuery1.FieldByName('additional').AsString
                          + '" and ad.tid="'
                          +
                          ADOQuery1.FieldByName('store').AsString +
                          '"');
                        ADOQuerySQL.ExecSQL;
                      end;
                    end;
                    ADOQuery1.Next;
                  end;

                  ADOQuerySQL.SQL.Clear;
                  ADOQuerySQL.SQL.Add('update selllogdetails set amount=(if(amount>1,amount-1,amount)),updated_at=now()  where slid="' + Label26.Caption + '" and additional<>"����"');
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
              if ADOQuery1.FieldByName('amount').AsCurrency
                >
                1 then
              begin
                ADOQuerySQL.SQL.Clear;
                ADOQuerySQL.SQL.Add('update selllogdetails set amount=(amount-1),updated_at=now()  where slid="' + Label26.Caption + '" and pid="' +
                  ADOQuery1.FieldByName('pid').AsString +
                  '" and additional="' +
                  ADOQuery1.FieldByName('additional').AsString
                  + '"');
                ADOQuerySQL.ExecSQL;
              end;
            end;

          end;

          QH1;
          QH2;
        end;
      end;

    VK_HOME: //���ݲ���
      begin
        if QHD_P <> nil then
          QHD_P.ShowModal
        else
        begin
          QHD_P := TQHD_P.Create(Application);
          QHD_P.ShowModal;
        end;
      end;

  end;
end;

{�޸��ۿ���Ϣ}

procedure TMain.RzEdit1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if (ADOQuery1.RecordCount > 0) and
      (ADOQuery1.FieldByName('additional').AsString <>
      '����')
      then
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
      ADOQuerySQL.SQL.Add('update selllogdetails set discount="' + RzEdit1.Text
        +
        '",updated_at=now() where slid = "' +
        Label26.Caption + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString +
        '" and additional="' +
        ADOQuery1.FieldByName('additional').AsString +
        '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit1.Text := '100';
    RzEdit4.SetFocus;
  end;
end;

{�޸�����}

procedure TMain.RzEdit3KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if (ADOQuery1.RecordCount > 0) and
      (ADOQuery1.FieldByName('additional').AsString <>
      '����')
      then
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
      ADOQuerySQL.SQL.Add('update selllogdetails set amount="' + RzEdit3.Text +
        '",updated_at=now() where slid = "' +
        Label26.Caption + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString +
        '" and additional="' +
        ADOQuery1.FieldByName('additional').AsString +
        '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit3.Text := '1';
    RzEdit4.SetFocus;
  end;
end;

{�޸ļ���}

procedure TMain.RzEdit5KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if (ADOQuery1.RecordCount > 0) and
      (ADOQuery1.FieldByName('additional').AsString <>
      '����')
      then
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
      ADOQuerySQL.SQL.Add('update selllogdetails set bundle="' + RzEdit5.Text +
        '",updated_at=now() where slid = "' +
        Label26.Caption + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString +
        '" and additional="' +
        ADOQuery1.FieldByName('additional').AsString +
        '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit5.Text := '1';
    RzEdit4.SetFocus;
  end;
end;

{�޸ĵ���}

procedure TMain.RzEdit2KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    key := #0;
    if (ADOQuery1.RecordCount > 0) and
      (ADOQuery1.FieldByName('additional').AsString <>
      '����')
      then
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
      ADOQuerySQL.SQL.Add('update selllogdetails set outprice="' + RzEdit2.Text
        +
        '",updated_at=now() where slid = "' +
        Label26.Caption + '" and pid="' +
        ADOQuery1.FieldByName('pid').AsString +
        '" and additional="' +
        ADOQuery1.FieldByName('additional').AsString +
        '"');
      ADOQuerySQL.ExecSQL;

      QH1;
      QH2;
    end;
    RzEdit4.SetFocus;
  end;
end;

{�����ƶ��б���ʱ��������}

procedure TMain.DBGrid1MouseUp(Sender: TObject; Button:
  TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RzEdit1.Text :=
    ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text :=
    ADOQuery1.FieldByName('outprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
  RzEdit5.Text := ADOQuery1.FieldByName('bundle').AsString;
end;

procedure TMain.DBGrid1KeyUp(Sender: TObject; var Key:
  Word;
  Shift: TShiftState);
begin
  RzEdit1.Text :=
    ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text :=
    ADOQuery1.FieldByName('outprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
  RzEdit5.Text := ADOQuery1.FieldByName('bundle').AsString;
end;

{������������Ʒ}

procedure TMain.RzEdit4KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin

    if not (rzchckbx1.Checked) then
    begin

      //������Ϊ�������
      if (RzEdit4.Text = '') and (ADOQuery1.RecordCount > 0)
        then
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

      if RzEdit4.Text = '' then
        Exit;

      //�ڿ���а����������Ʒ
      ADOQuery2.SQL.Clear;
      ADOQuery2.SQL.Add('Select * from stocks Where pid="'
        + RzEdit4.Text +
        '"');
      ADOQuery2.Open;
      if ADOQuery2.RecordCount = 1 then
      begin
        WRecord;
        RzEdit4.Text := '';
        RzEdit4.SetFocus;
      end;
    end
    else //ѡ��ά�޿��в�Ʒ
    begin

      {����Ҫ��������ͻ�����}
      //����������
      if edt2.Text = '' then
      begin
        ShowMessage('��������ͻ���Ϣ�ٿ�ʼ�µ�~~!');
        edt1.SetFocus;
        Exit;
      end;

      {�ṩ�ͻ�ѡ���ά�޿���ѡ����û�����ά�޵Ĳ�Ʒ���ܣ����ݿͻ��绰��Ψһ��ʶ�ͻ�}
      if QPT <> nil then
        QPT.ShowModal
      else
      begin
        QPT := TQPT.Create(Application);
        QPT.ShowModal;
      end;

      if RzEdit4.Text = '' then
        Exit;

      //�ڿ���а����������Ʒ��׼����Ʒ���ݣ�pid,additional,type�ڵ���tid����Ψһ��
      ADOQuery2.SQL.Clear;
      ADOQuery2.SQL.Add('select d.tid, "' +
        QPT.ADOQuery1.FieldByName('tid').AsString +
        '" as store, d.pid,barcode,d.goodsname,d.size,d.color,d.volume,d.unit,d.inprice,d.pfprice,d.amount,d.bundle,d.discount,d.type,d.remark from aftersellmains m, afterselldetails d where not(d.status) and d.type="ά��" and m.tid=m.tid and m.custtel="' +
        edt2.Text + '" and d.additional="' +
        QPT.ADOQuery1.FieldByName('additional').AsString +
        '" and d.pid="' + RzEdit4.Text +
        '" and d.tid="' +
        QPT.ADOQuery1.FieldByName('tid').AsString + '"');
      ADOQuery2.Open;
      if ADOQuery2.RecordCount = 1 then
      begin
        WRecord;

        //����ά�޿����иò�ƷΪ����׼��ռ�ã�ǰ���ǵǼǵ�ά�������Ѿ�ȫ��ʹ����ϣ�
        ADOQuerySQL.SQL.Clear;
        //ADOQuerySQL.SQL.Add('update aftersellmains m, afterselldetails d set d.type=if(d.ramount=1,"���ⵥռ��","ά��"),d.ramount=(d.ramount-1), d.updated_at=now() where not(d.status) and d.type="ά��"  and d.additional="' + QPT.ADOQuery1.FieldByName('additional').AsString +
        ADOQuerySQL.SQL.Add('update aftersellmains m, afterselldetails d set d.ramount=(d.ramount-1), d.updated_at=now() where not(d.status) and d.type="ά��"  and d.additional="' + QPT.ADOQuery1.FieldByName('additional').AsString +
          '" and m.tid=m.tid and m.custtel="' + edt2.Text +
          '" and d.pid="' + RzEdit4.Text +
          '" and d.tid="' +
          QPT.ADOQuery1.FieldByName('tid').AsString + '"');
        ADOQuerySQL.ExecSQL;

        RzEdit4.Text := '';
        RzEdit4.SetFocus;
      end;
    end;

  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;

{���ݿͻ�������ѯ�ͻ�}

procedure TMain.edt1KeyPress(Sender: TObject; var Key:
  Char);
begin
  if key = #13 then
  begin
    qsrc := 'cname';
    if QC <> nil then
      QC.ShowModal
    else
    begin
      QC := TQC.Create(Application);
      QC.ShowModal;
      RzEdit4.SetFocus;
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;

end;

{���ݿͻ���Ų�ѯ�ͻ�ƫ�����˲�}

procedure TMain.edt4KeyPress(Sender: TObject; var Key:
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

procedure TMain.qrlbl12Print(sender: TObject; var Value:
  string);
begin
  Value := '��' + IntToStr(QuickRep1.QRPrinter.PageNumber)
    +
    'ҳ / ��' +
    IntToStr(FTotalPages) + 'ҳ';
end;

procedure TMain.edt8KeyPress(Sender: TObject; var Key:
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

procedure TMain.edt2KeyPress(Sender: TObject; var Key:
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

procedure TMain.RzComboBox1KeyPress(Sender: TObject; var
  Key: Char);
begin
  if key = #13 then
  begin
    {
    if RzComboBox1.Text = '��Ʒ' then
    begin
      if ADOQuery1.FieldByName('additional').AsString = '-' then
      begin
        if ADOQuery1.RecordCount > 0 then
        begin
          ADOQuerySQL.SQL.Clear;
          ADOQuerySQL.SQL.Add('update selllogdetails set additional="��Ʒ",updated_at=now()  where slid="' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
          ADOQuerySQL.ExecSQL;
        end;
        QH1;
        QH2;
      end
      else if ADOQuery1.FieldByName('additional').AsString = '��Ʒ' then
      begin
        if ADOQuery1.RecordCount > 0 then
        begin
          ADOQuerySQL.SQL.Clear;
          ADOQuerySQL.SQL.Add('update selllogdetails set additional="-",updated_at=now()  where slid="' + Label26.Caption + '" and pid="' + ADOQuery1.FieldByName('pid').AsString + '"');
          ADOQuerySQL.ExecSQL;
        end;
        QH1;
        QH2;
      end;
    end
    else if RzComboBox1.Text = '����' then
    begin

      //����Ҫ��������ͻ�����
      //����������
      if edt2.Text = '' then
      begin
        ShowMessage('��������ͻ���Ϣ�ٿ�ʼ�µ�~~!');
        edt1.SetFocus;
        Exit;
      end;

      //�ṩ�ͻ�ѡ���ά�޿���ѡ����û�����ά�޵Ĳ�Ʒ���ܣ����ݿͻ��绰��Ψһ��ʶ�ͻ�
      if QP <> nil then
        QP.ShowModal
      else
      begin
        QP := TQP.Create(Application);
        QP.ShowModal;
      end;

      if RzEdit4.Text = '' then
        Exit;

      //�ڿ���а����������Ʒ��׼����Ʒ����
      ADOQuery2.SQL.Clear;
      ADOQuery2.SQL.Add('select d.pid,barcode,d.goodsname,d.size,d.color,d.volume,d.unit,d.inprice,d.pfprice,d.amount,d.bundle,d.discount,d.remark from aftersellmains m, afterselldetails d where not(d.status) and d.type="ά��" and m.tid=m.tid and m.custtel="' + edt2.Text + '" and d.pid="' + RzEdit4.Text + '"');
      ADOQuery2.Open;
      if ADOQuery2.RecordCount <> 0 then
      begin
        WRecord;

        //����ά�޿����иò�ƷΪ����׼��ռ�ã�ǰ���ǵǼǵ�ά�������Ѿ�ȫ��ʹ����ϣ�
        ADOQuerySQL.SQL.Clear;
        ADOQuerySQL.SQL.Add('update aftersellmains m, afterselldetails d set d.type="���ⵥռ��", d.updated_at=now() where not(d.status) and d.type="ά��" and m.tid=m.tid and m.custtel="' + edt2.Text + '" and d.pid="' + RzEdit4.Text + '"');
        ADOQuerySQL.ExecSQL;

        RzEdit4.Text := '';
        RzEdit4.SetFocus;
      end;
    end;
    }
  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;

end.

