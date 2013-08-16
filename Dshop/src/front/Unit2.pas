unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Grids, DBGrids, DB, ADODB, INIFiles,
  RzForms, RzStatus, Mask, RzEdit, QRCtrls, QuickRpt, Registry, DBTables;

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
    Label22: TLabel;
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
    bvl1: TBevel;
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
    qrxpr1: TQRExpr;
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
    qrsysdt1: TQRSysData;
    qrlbl1: TQRLabel;
    qrlbl2: TQRLabel;
    RzEdit5: TRzEdit;
    Label31: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  private
    { Private declarations }
  public
    procedure QH1;
    procedure WRecord;
    procedure QH2;
    procedure calcPrice();
    { Public declarations }
  end;

var
  Main: TMain;
  FTotalPages: Integer;
  UpdateTimeStr: string;

implementation

uses Unit1, Unit3, Unit4, Unit5, Unit10, Unit9, Unit11, Unit12, Unit13, Unit14, Unit7;

{$R *.dfm}


{�����Ʒ����}

procedure TMain.calcPrice();
begin
  {���ͻ��Ƿ����ض��Żݿͻ��������Ż����ڣ�������Żݼ۸񣬷�����������۸�}
  {��������ۿͻ��޼۸���ʾ}
  ADOQuery4.SQL.Clear;
  ADOQuery4.SQL.Add('select hprice from memberprices where pid = "' + RzEdit4.Text + '" and custid = "' + edt7.Text + '" and current_timestamp() between startdate and enddate');
  ADOQuery4.Open;
  if ADOQuery4.RecordCount = 1 then
  begin
    ADOQuery1.Edit;
    ADOQuery1.FieldByName('outprice').AsString := ADOQuery4.FieldByName('hprice').AsString;


    UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
    if ADOQuery1.FieldByName('created_at').AsString = '' then
      ADOQuery1.FieldByName('created_at').AsString := UpdateTimeStr;
    ADOQuery1.FieldByName('updated_at').AsString := UpdateTimeStr;
    
    ADOQuery1.Post;
    ADOQuery1.Refresh;
  end;
end;


{��ʼ���µ�ҳ��}

procedure TMain.FormCreate(Sender: TObject);
var
  vIniFile: TIniFile;
  Reg: TRegistry;
  D1, Data, SID, ds: string;
  i: Integer;
begin
  //����INI�ļ�����
  vIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Config.Ini');
  ds := vIniFile.Readstring('System', 'Data Source', 'shop');
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
  Main.Width:=798;//�ָ������ڴ�С
  Main.Height:=571;//�ָ������ڴ�С
  }
  //ʹ������λ����Ļ������
  Main.Top := (GetSystemMetrics(SM_CySCREEN) - Main.Height) div 2 - 13;
  Main.Left := (GetSystemMetrics(SM_CxSCREEN) - Main.Width) div 2;
  //�������ݿ�����
  {
  Data:='Provider='+vIniFile.Readstring('System','Provider','')+';';
  Data:=Data+'Data Source='+vIniFile.Readstring('System','Data Source','')+';';
  Data:=Data+'Persist Security Info=False';
  ADOConnection1.ConnectionString:=Data;
  }
  ADOConnection1.ConnectionString := 'Provider=MSDASQL.1;' +
    'Persist Security Info=False;' +
    'User ID=root;' +
    'Password=zaqwsxcde123;' +
    'Data Source=' + ds; //shop';
  {���ɳ�ʼ����}
  //��ʼ����
  {
  for i := 1 to 9999 do
  begin
    SID := FormatdateTime('yymmdd', Now) + FormatFloat('0000', i);
    ADOQuery2.SQL.Clear;
    ADOQuery2.SQL.Add('Select * from selllogmains Where slid="' + SID + '"');
    ADOQuery2.Open;
    if ADOQuery2.RecordCount = 0 then
    begin
      Break;
    end;
  end;
  }
  SID := FormatdateTime('yymmdd', Now);
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('select lpad(cast(substr(max(slid),7) as signed) + 1,4,"0") as id from selllogmains where DATE_FORMAT(created_at,"%y%m%d")="'+SID+'"');
  ADOQuery2.Open;
  SID := SID + ADOQuery2.FieldByName('id').AsString;

  //��ȡ����
  Label26.Caption := SID;
  ADOQuery1.SQL.Clear;
  //ADOQuery1.SQL.Add('Select * from selllogdetails Where slid="' + Label26.Caption + '" order by pid');
  ADOQuery1.SQL.Add('select pid,goodsname,color,FORMAT(volume,2) as volume,FORMAT(amount,0) as amount,unit,FORMAT(bundle,0) as bundle,FORMAT(outprice,0) as outprice,discount,additional,FORMAT((amount*outprice),0) as subtotal, ');
  ADOQuery1.SQL.Add('inprice, pfprice, hprice from selllogdetails where slid = "' + Label26.Caption + '" union select "�ϼ�" as pid, "" as goodsname, "" as color,FORMAT(sum(volume),2) ');
  ADOQuery1.SQL.Add('as volume,FORMAT(sum(amount),0) as amount,"" as unit,FORMAT(sum(bundle),0) as bundle,FORMAT(sum(outprice),0) as outprice,"" as discount,"" ');
  ADOQuery1.SQL.Add('as additional,FORMAT(sum(amount*outprice),0) as subtotal, inprice, pfprice, hprice  from selllogdetails where slid = "' + Label26.Caption + '"');
  ADOQuery1.Open;
  QH2;
  {��ʽ��С����ʾ}
  //TFloatField(DBGrid1.DataSource.DataSet.FieldByName('volume')).DisplayFormat := '0.00';

end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if messagedlg('ȷ���˳���', mtconfirmation, [mbyes, mbno], 0) = mryes then
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
    Main.Top := (GetSystemMetrics(SM_CySCREEN) - Main.Height) div 2 - 13;
    Main.Left := (GetSystemMetrics(SM_CxSCREEN) - Main.Width) div 2;
  end;
end;

{��ӡ�����ϵ���Ϣ}

procedure TMain.QuickRep1StartPage(Sender: TCustomQuickRep);
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

  qrlbl13.Caption := '�ռ���:' + Main.edt1.Text;
  qrlbl14.Caption := '�绰:' + Main.edt2.Text;
  qrlbl15.Caption := '�ջ���ַ:' + Main.edt3.Text;
  qrlbl19.Caption := '���ʽ:' + Main.cbb1.Text;


  qrlbl16.Caption := '���˲�:' + Main.edt4.Text;
  qrlbl17.Caption := '�绰:' + Main.edt5.Text;
  qrlbl18.Caption := '���˲���ַ:' + Main.edt6.Text;


  qrlbl20.Caption := '����:' + FormatDateTime('dddddd tt', Now);
  qrlbl21.Caption := '����:��' + Label26.Caption;
  qrlbl22.Caption := '�����绰:' + viniFile.ReadString('System', 'TEL', '');
  qrlbl23.Caption := viniFile.ReadString('System', 'La2', '');
end;

{����ÿ����Ʒ��С�ƽ��}

procedure TMain.QH1;
begin
  //����ϼ���
  //�������ƷС��Ϊ��
  ADOQuery1.Edit;
  if ADOQuery1.FieldByName('additional').AsString = '����' then
  begin
    ADOQuery1.FieldByName('subtotal').AsCurrency := 0;
    ADOQuery1.Post;
    ADOQuery1.Refresh;
    Exit;
  end;
  //������¼��ϣ�С��=�ۼ�*����*�ۿ�/100
  ADOQuery1.FieldByName('subtotal').AsFloat := ADOQuery1.FieldByName('outprice').AsCurrency *
    ADOQuery1.FieldByName('amount').AsCurrency *
    ADOQuery1.FieldByName('discount').AsCurrency / 100;

  UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
  if ADOQuery1.FieldByName('created_at').AsString = '' then
    ADOQuery1.FieldByName('created_at').AsString := UpdateTimeStr;
  ADOQuery1.FieldByName('updated_at').AsString := UpdateTimeStr;
  

  ADOQuery1.Post;
  ADOQuery1.Refresh;
end;

{����б�����}

procedure TMain.WRecord;
begin
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

  //��ʼ�ۿۺ�����
  RzEdit1.Text := '100';
  RzEdit3.Text := '1';

  //�����������Ƿ��д˵���
  ADOQuery3.SQL.Clear;
  ADOQuery3.SQL.Add('Select * from selllogmains Where slid="' + Label26.Caption + '"');
  ADOQuery3.Open;
  if ADOQuery3.RecordCount = 0 then
  begin
    ADOQuery3.Edit;
    ADOQuery3.Append;
    {�������ۼ�¼}
    ADOQuery3.FieldByName('slid').AsString := Label26.Caption;
    {ADOQuery3.FieldByName('custid').AsString := ADOQuery1.FieldByName('pid').AsString; }
    ADOQuery3.FieldByName('custname').AsString := edt1.Text;
    ADOQuery3.FieldByName('custtel').AsString := edt2.Text;
    ADOQuery3.FieldByName('custaddr').AsString := edt3.Text;
    ADOQuery3.FieldByName('custid').AsString := edt7.Text;
    ADOQuery3.FieldByName('custstate').AsString := edt8.Text;
    ADOQuery3.FieldByName('yingshou').AsFloat := 0;
    ADOQuery3.FieldByName('shishou').AsFloat := 0;
    {ADOQuery3.FieldByName('sid').AsString := edt4.Text;}
    ADOQuery3.FieldByName('sname').AsString := edt4.Text;
    ADOQuery3.FieldByName('saddress').AsString := edt5.Text;
    ADOQuery3.FieldByName('stel').AsString := edt6.Text;
    ADOQuery3.FieldByName('payment').AsString := cbb1.Text;
    ADOQuery3.FieldByName('status').AsInteger := 0;
    {ADOQuery3.FieldByName('uid').AsInteger := 0;}
    ADOQuery3.FieldByName('uname').AsString := Label19.Caption;
    ADOQuery3.FieldByName('remark').AsString := mmo1.Lines.GetText;


    UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
    if ADOQuery3.FieldByName('created_at').AsString = '' then
      ADOQuery3.FieldByName('created_at').AsString := UpdateTimeStr;
    ADOQuery3.FieldByName('updated_at').AsString := UpdateTimeStr;


    ADOQuery3.Post;
    ADOQuery3.Refresh;
  end;

  //��ɨ���¼
  ADOQuery1.Edit;
  ADOQuery1.Append;
  ADOQuery1.FieldByName('slid').AsString := Label26.Caption;
  ADOQuery1.FieldByName('pid').AsString := ADOQuery2.FieldByName('pid').AsString;
  ADOQuery1.FieldByName('barcode').AsString := ADOQuery2.FieldByName('barcode').AsString;
  ADOQuery1.FieldByName('goodsname').AsString := ADOQuery2.FieldByName('goodsname').AsString;
  ADOQuery1.FieldByName('size').AsString := ADOQuery2.FieldByName('size').AsString;
  ADOQuery1.FieldByName('color').AsString := ADOQuery2.FieldByName('color').AsString;
  ADOQuery1.FieldByName('volume').AsFloat := ADOQuery2.FieldByName('volume').AsFloat;
  ADOQuery1.FieldByName('unit').AsString := ADOQuery2.FieldByName('unit').AsString;
  ADOQuery1.FieldByName('inprice').AsFloat := ADOQuery2.FieldByName('inprice').AsFloat;
  ADOQuery1.FieldByName('pfprice').AsFloat := ADOQuery2.FieldByName('pfprice').AsFloat;
  ADOQuery1.FieldByName('hprice').AsFloat := 0;
  ADOQuery1.FieldByName('outprice').AsFloat := ADOQuery2.FieldByName('pfprice').AsFloat;
  ADOQuery1.FieldByName('amount').AsInteger := StrToInt(RzEdit3.Text);
  ADOQuery1.FieldByName('bundle').AsInteger := 0;
  ADOQuery1.FieldByName('discount').AsInteger := StrToInt(RzEdit1.Text);
  ADOQuery1.FieldByName('additional').AsString := '-';

  ADOQuery1.FieldByName('status').AsInteger := 0;


  UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
  if ADOQuery1.FieldByName('created_at').AsString = '' then
    ADOQuery1.FieldByName('created_at').AsString := UpdateTimeStr;
  ADOQuery1.FieldByName('updated_at').AsString := UpdateTimeStr;


  ADOQuery1.Post;
  ADOQuery1.Refresh;

  calcPrice();

  QH1;
  QH2;


end;

{����ָ�����ŵĺϼƼ۸�}

procedure TMain.QH2;
begin
  ADOQuery2.SQL.Clear;
  ADOQuery2.SQL.Add('Select sum(subtotal) from selllogdetails Where slid="' + Label26.Caption + '" order by pid');

  ADOQuery2.Open;
  Label7.Caption := FormatFloat('0.00', ADOQuery2.Fields[0].AsCurrency)
end;

{�����ݼ�}

procedure TMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  SID: string;
  i: Integer;
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

    VK_F2: RzEdit1.SetFocus;

    VK_F3: RzEdit2.SetFocus;

    VK_F4: RzEdit3.SetFocus;

    VK_F5:
      begin
        if ADOQuery1.FieldByName('additional').AsString = '-' then
        begin
          if ADOQuery1.RecordCount > 0 then
          begin
            ADOQuery1.Edit;
            ADOQuery1.FieldByName('additional').AsString := '����';
          end;
          QH1;
          QH2;
        end
        else
        begin
          if ADOQuery1.RecordCount > 0 then
          begin
            ADOQuery1.Edit;
            ADOQuery1.FieldByName('additional').AsString := '-';
          end;
          QH1;
          QH2;
        end;
      end;
    VK_F6:
      begin

        {������չ��Ϣ}
         //�����������Ƿ��д˵���

        ADOQuery3.Open;
        if ADOQuery3.RecordCount = 1 then
        begin
          ADOQuery3.Edit;
          {�������ۼ�¼}
          ADOQuery3.FieldByName('slid').AsString := Label26.Caption;
          {ADOQuery3.FieldByName('custid').AsString := ADOQuery1.FieldByName('pid').AsString; }
          ADOQuery3.FieldByName('custname').AsString := edt1.Text;
          ADOQuery3.FieldByName('custtel').AsString := edt2.Text;
          ADOQuery3.FieldByName('custaddr').AsString := edt3.Text;
          ADOQuery3.FieldByName('yingshou').AsFloat := 0;
          ADOQuery3.FieldByName('shishou').AsFloat := 0;
          {ADOQuery3.FieldByName('sid').AsString := edt4.Text;}
          ADOQuery3.FieldByName('sname').AsString := edt4.Text;
          ADOQuery3.FieldByName('saddress').AsString := edt5.Text;
          ADOQuery3.FieldByName('stel').AsString := edt6.Text;
          ADOQuery3.FieldByName('payment').AsString := cbb1.Text;
          ADOQuery3.FieldByName('status').AsInteger := 0;
          {ADOQuery3.FieldByName('uid').AsInteger := 0;}
          ADOQuery3.FieldByName('uname').AsString := Label19.Caption;
          ADOQuery3.FieldByName('remark').AsString := mmo1.Lines.GetText;


          UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
          if ADOQuery3.FieldByName('created_at').AsString = '' then
            ADOQuery3.FieldByName('created_at').AsString := UpdateTimeStr;
          ADOQuery3.FieldByName('updated_at').AsString := UpdateTimeStr;


          ADOQuery3.Post;
          ADOQuery3.Refresh;
        end;

        {���������}
        edt1.Text := '';
        edt2.Text := '';
        edt3.Text := '';
        edt7.Text := '';
        edt8.Text := '';

        edt4.Text := '';
        edt5.Text := '';
        edt6.Text := '';

        cbb1.Text := '';
        mmo1.Text := '';



        {��������}
        //��ʼ����
        for i := 1 to 9999 do
        begin
          SID := FormatdateTime('yymmdd', Now) + FormatFloat('0000', i);
          ADOQuery2.SQL.Clear;
          ADOQuery2.SQL.Add('Select * from selllogmains Where slid="' + SID + '"');
          ADOQuery2.Open;
          if ADOQuery2.RecordCount = 0 then
          begin
            Break;
          end;
        end;
        //��ȡ����
        Label26.Caption := SID;
        ADOQuery1.SQL.Clear;
        ADOQuery1.SQL.Add('select pid,goodsname,color,FORMAT(volume,2) as volume,FORMAT(amount,0) as amount,unit,FORMAT(bundle,0) as bundle,FORMAT(outprice,0) as outprice,discount,additional,FORMAT((amount*outprice),0) as subtotal, ');
        ADOQuery1.SQL.Add('inprice, pfprice, hprice from selllogdetails where slid = "' + Label26.Caption + '" union select "�ϼ�" as pid, "" as goodsname, "" as color,FORMAT(sum(volume),2) ');
        ADOQuery1.SQL.Add('as volume,FORMAT(sum(amount),0) as amount,"" as unit,FORMAT(sum(bundle),0) as bundle,FORMAT(sum(outprice),0) as outprice,"" as discount,"" ');
        ADOQuery1.SQL.Add('as additional,FORMAT(sum(amount*outprice),0) as subtotal,inprice, pfprice, hprice  from selllogdetails where slid = "' + Label26.Caption + '"');
  
        ADOQuery1.Open;
        QH2;

        {��ʽ��С����ʾ}
        TFloatField(DBGrid1.DataSource.DataSet.FieldByName('volume')).DisplayFormat := '0.00';

      end;

    VK_F7:
      begin
        if QD <> nil then
          QD.ShowModal
        else
        begin
          QD := TQD.Create(Application);
          QD.ShowModal;
        end;
      end;

    VK_F9:
      begin
        if Pos_Setup <> nil then
          Pos_Setup.ShowModal
        else
        begin
          Pos_Setup := TPos_Setup.Create(Application);
          Pos_Setup.ShowModal;
        end;
      end;

    VK_F10: RzEdit5.SetFocus;

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

    VK_F12:
      begin
        if QR <> nil then
          QR.ShowModal
        else
        begin
          QR := TQR.Create(Application);
          QR.ShowModal;
        end;
      end;

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
          if messagedlg('ȷ��ɾ��"' + ADOQuery1.FieldByName('goodsname').AsString + '"��?', mtconfirmation, [mbyes, mbno], 0) = mryes then
          begin
            ADOQuery1.Delete;
            QH2;
          end;
        end
        else
        begin
          ShowMessage('û����Ʒ��¼~~!');
        end;
      end;

    VK_ADD:
      begin
        ADOQuery1.Edit;
        ADOQuery1.FieldByName('amount').AsCurrency := ADOQuery1.FieldByName('amount').AsCurrency + 1;
        QH1;
        QH2;
      end;

    VK_SUBTRACT:
      begin
        if ADOQuery1.FieldByName('amount').AsCurrency > 1 then
        begin
          ADOQuery1.Edit;
          ADOQuery1.FieldByName('amount').AsCurrency := ADOQuery1.FieldByName('amount').AsCurrency - 1;
          QH1;
          QH2;
        end;
      end;
  end;
end;

procedure TMain.RzEdit1KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuery1.Edit;
      ADOQuery1.FieldByName('discount').AsString := RzEdit1.Text;
      ADOQuery1.Post;
      ADOQuery1.Refresh;
      QH1;
      QH2;
    end;
    RzEdit1.Text := '100';
    RzEdit4.SetFocus;
  end;
end;

procedure TMain.RzEdit3KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuery1.Edit;
      ADOQuery1.FieldByName('amount').AsString := RzEdit3.Text;


      UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
      if ADOQuery1.FieldByName('created_at').AsString = '' then
        ADOQuery1.FieldByName('created_at').AsString := UpdateTimeStr;
      ADOQuery1.FieldByName('updated_at').AsString := UpdateTimeStr;


      ADOQuery1.Post;
      ADOQuery1.Refresh;
      QH1;
      QH2;
    end;
    RzEdit3.Text := '1';
    RzEdit4.SetFocus;
  end;
end;


procedure TMain.RzEdit5KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuery1.Edit;
      ADOQuery1.FieldByName('bundle').AsString := RzEdit5.Text;

      UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
      if ADOQuery1.FieldByName('created_at').AsString = '' then
        ADOQuery1.FieldByName('created_at').AsString := UpdateTimeStr;
      ADOQuery1.FieldByName('updated_at').AsString := UpdateTimeStr;
      
      ADOQuery1.Post;
      ADOQuery1.Refresh;
      QH1;
      QH2;
    end;
    RzEdit5.Text := '1';
    RzEdit4.SetFocus;
  end;
end;

procedure TMain.RzEdit2KeyPress(Sender: TObject; var Key: Char);
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
      ADOQuery1.Edit;
      ADOQuery1.FieldByName('outprice').AsString := RzEdit2.Text;


      UpdateTimeStr := FormatdateTime('yyyy-mm-dd hh:mm:ss', Now);
      if ADOQuery1.FieldByName('created_at').AsString = '' then
        ADOQuery1.FieldByName('created_at').AsString := UpdateTimeStr;
      ADOQuery1.FieldByName('updated_at').AsString := UpdateTimeStr;


      ADOQuery1.Post;
      ADOQuery1.Refresh;
      QH1;
      QH2;
    end;
    RzEdit4.SetFocus;
  end;
end;



procedure TMain.DBGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RzEdit1.Text := ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text := ADOQuery1.FieldByName('pfprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
end;

procedure TMain.DBGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  RzEdit1.Text := ADOQuery1.FieldByName('discount').AsString;
  RzEdit2.Text := ADOQuery1.FieldByName('pfprice').AsString;
  RzEdit3.Text := ADOQuery1.FieldByName('amount').AsString;
end;

{������������Ʒ}

procedure TMain.RzEdit4KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    //������Ϊ�������
    if (RzEdit4.Text = '') and (ADOQuery1.RecordCount > 0) then
    begin
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
    ADOQuery2.SQL.Clear;
    ADOQuery2.SQL.Add('Select * from stocks Where pid="' + RzEdit4.Text + '"');
    ADOQuery2.Open;
    if ADOQuery2.RecordCount <> 0 then
    begin
      WRecord;
      RzEdit4.Text := '';
      RzEdit4.SetFocus;
      {end else begin
        //������������û����ƴ������
        ADOQuery2.SQL.Clear;
        ADOQuery2.SQL.Add('Select * from stock Where PYBrevity="'+RzEdit4.Text+'"');
        ADOQuery2.Open;
        if ADOQuery2.RecordCount<>0 then begin
          if ADOQuery2.RecordCount>1 then begin
            Sele:=TSele.Create(Application);
            Sele.showmodal;
            Exit;
          end;
          WRecord;
          RzEdit4.Text:='';
          RzEdit4.SetFocus;
        end else begin
          //ƴ������û����ʾ
          showmessage('�޴���ƷID'+#13#13+'ע��˶�~~!');
          RzEdit4.Text:='';
          RzEdit4.SetFocus;
        end; }
    end;
  end;
  if (key = #43) or (key = #45) then
    key := #0;
end;


{���ݿͻ�������ѯ�ͻ�}

procedure TMain.edt1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
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

{���ݿͻ���Ų�ѯ�ͻ�ƫ�����˲�}

procedure TMain.edt4KeyPress(Sender: TObject; var Key: Char);
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

procedure TMain.qrlbl12Print(sender: TObject; var Value: string);
begin
  Value := '��' + IntToStr(QuickRep1.QRPrinter.PageNumber) + 'ҳ / ��' + IntToStr(FTotalPages) + 'ҳ';
end;

end.
