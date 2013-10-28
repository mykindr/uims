unit untMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzStatus, ExtCtrls, RzPanel, RzTray, StdCtrls, 
  RzButton, ComCtrls, RzListVw, PHPRPC, Mask, RzEdit, ImgList,
  Menus, XPMan, ActnList, untTFastReportEx, untOrderReport,  IdComponent, ShellAPI;

type
  TfrmMain = class(TForm)
    RzStatusBar1: TRzStatusBar;
    RzTrayIcon1: TRzTrayIcon;
    RzListView1: TRzListView;
    btnPageFirst: TRzBitBtn;
    btnPagePrev: TRzBitBtn;
    btnPageNext: TRzBitBtn;
    btnPageLast: TRzBitBtn;
    edtPageSize: TRzEdit;
    lblRecordCount: TLabel;
    lblPageCount: TLabel;
    lblPage: TLabel;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    lblListTitle: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    XPManifest1: TXPManifest;
    ActionList1: TActionList;
    actPrintShipping: TAction;
    actEditOrderInfo: TAction;
    actSearchOrder: TAction;
    actPrintPreview: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    actShowAbout: TAction;
    actOrderList: TAction;
    N6: TMenuItem;
    actViewShipped: TAction;
    N7: TMenuItem;
    RzVersionInfo1: TRzVersionInfo;
    RzVersionInfoStatus1: TRzVersionInfoStatus;
    RzStatusPane2: TRzStatusPane;
    RzStatusPane1: TRzStatusPane;
    RzClockStatus1: TRzClockStatus;
    RzStatusPane3: TRzStatusPane;
    RzProgressStatus1: TRzProgressStatus;
    edtConsignee: TRzEdit;
    Label7: TLabel;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    edtDirectPage: TRzEdit;
    Label8: TLabel;
    RzBitBtn3: TRzBitBtn;
    RzBitBtn4: TRzBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure RzListView1Data(Sender: TObject; Item: TListItem);
    procedure btnPageFirstClick(Sender: TObject);
    procedure btnPagePrevClick(Sender: TObject);
    procedure btnPageNextClick(Sender: TObject);
    procedure btnPageLastClick(Sender: TObject);
    procedure edtPageSizeKeyPress(Sender: TObject; var Key: Char);
    procedure actPrintShippingExecute(Sender: TObject);
    procedure actEditOrderInfoExecute(Sender: TObject);
    procedure actSearchOrderExecute(Sender: TObject);
    procedure actPrintPreviewExecute(Sender: TObject);
    procedure actShowAboutExecute(Sender: TObject);
    procedure actOrderListExecute(Sender: TObject);
    procedure actViewShippedExecute(Sender: TObject);
    procedure RzListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure RzListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure RzListView1Click(Sender: TObject);
  private
    { Private declarations }
    page:Integer;           //��ǰҳ��
    page_size:integer;      //ÿҳ��¼��
    max_page:Integer;       //���ҳ��
    count:Integer;          //�ܼ�¼��
    arraylist: TArrayList;  //��Ʒ�б�����

    SortCol: Integer;
    SortWay: Integer;

    procedure InitListView;
    procedure setListView;
    procedure getOrdersList(ASearchWhere:string=''); //����ѯ�ؼ���

    procedure WorkBeginEvent(Sender: TObject; AWorkMode: TWorkMode; const AWorkCountMax: Integer);
    procedure WorkEndEvent(Sender: TObject; AWorkMode: TWorkMode);
    procedure WorkEvent(Sender: TObject; AWorkMode: TWorkMode; const AWorkCount: Integer);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  
implementation

{$R *.dfm}

uses untConsts, untOrderInfo, untSearchOrder, untAbout;

{ TfrmMain }


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption:=Caption + '   - '+ PServerName;
  RzStatusPane1.Caption:=PServerName + ' ��ǰ����Ա��'+PAdminName;
  RzTrayIcon1.ShowBalloonHint( RSTR_MAIN_TITLE, RSTR_MAIN_MSG );
  PWhere:=STR_WHERE;
  //��ʼ��������
  RzProgressStatus1.TotalParts:=100;
  RzProgressStatus1.PartsComplete:=0;
  RzProgressStatus1.Visible:=False;

  InitListView;
  getOrdersList;
  setListView;
end;

procedure TfrmMain.getOrdersList(ASearchWhere:string);
var
  PHPRPC_Client1: TPHPRPC_Client;
  clientProxy: Variant;
  vhashmap: Variant;
  ohashmap: THashMap;
begin
  if ASearchWhere='' then ASearchWhere:=PWhere;
  
  PHPRPC_Client1 := TPHPRPC_Client.Create;
  //PHPRPC_Client1.OnWork:=WorkEvent;
  //PHPRPC_Client1.OnWorkBegin:=WorkBeginEvent;
  //PHPRPC_Client1.OnWorkEnd:=WorkEndEvent;

  try
    PHPRPC_Client1.URL := PServiceURL;
    clientProxy := PHPRPC_Client1.ToVariant;
//    if ASearchWhere='' then
//      vhashmap := clientProxy.get_orders_list(page, page_size, STR_WHERE) //�в�ѯ����
//    else
//      vhashmap := clientProxy.get_orders_list(page, page_size, ASearchWhere);
    vhashmap := clientProxy.get_orders_list(page, page_size, ASearchWhere);
    if vhashmap<>null then
    begin
      ohashmap:= THashMap(THashMap.FromVariant(UnSerialize(vhashmap,False)));
      arraylist := ohashmap.Values;
    end;

  finally
    PHPRPC_Client1.Free;
  end;
end;

procedure TfrmMain.InitListView;
var
  PHPRPC_Client1: TPHPRPC_Client;
  clientProxy, data: Variant;
begin
  PHPRPC_Client1 := TPHPRPC_Client.Create;
  try
    PHPRPC_Client1.URL := PServiceURL;
    clientProxy := PHPRPC_Client1.ToVariant;
    //data := clientProxy.get_table_count('order_info', STR_WHERE); //�в�ѯ����
    data := clientProxy.get_table_count('order_info', PWhere); //�в�ѯ����
    data := Utf8ToAnsi(data);
    count:=data;

    page:=0;
    page_size:=StrToInt(edtPageSize.Text);
    max_page:=count div page_size;

    lblRecordCount.Caption:=IntToStr(count);
    lblPageCount.Caption:=IntToStr(max_page+1);
    lblPage.Caption:=IntToStr(page+1);

    //setPageList(page);
  finally
    PHPRPC_Client1.Free;
  end;
end;

procedure TfrmMain.setListView;
var
  i:integer;
begin
  with RzListView1 do
  begin
    Columns.Clear;
    RowSelect:=True;
    //ReadOnly:=True;
    //Checkboxes:=True;
    ViewStyle:=vsReport;
    OwnerData:=True;
    GridLines:=True;
    Items.Count:=arraylist.Count;
  end;

  RzListView1.Columns.Add.Caption:='�������';
  RzListView1.Columns.Add.Caption:='�������';
  RzListView1.Columns.Add.Caption:='�ջ�������';
  RzListView1.Columns.Add.Caption:='��ϸ��ַ';
  RzListView1.Columns.Add.Caption:='��ݵ���';
  RzListView1.Columns.Add.Caption:='֧����ʽ';
  RzListView1.Columns.Add.Caption:='���ͷ�ʽ';
  RzListView1.Columns.Add.Caption:='����״̬';
  RzListView1.Columns.Add.Caption:='�µ�ʱ��';

  for i:=0 to RzListView1.Columns.Count-1 do
  begin
    case i of
      0: RzListView1.Columns.Items[i].Width:=70;
      1: RzListView1.Columns.Items[i].Width:=90;
      2: RzListView1.Columns.Items[i].Width:=75;
      3: RzListView1.Columns.Items[i].Width:=230;
      5,6: RzListView1.Columns.Items[i].Width:=80;
      7: RzListView1.Columns.Items[i].Width:=110;
      8: RzListView1.Columns.Items[i].Width:=140;
    else
      RzListView1.Columns.Items[i].Width:=100;
    end;
  end;
end;

procedure TfrmMain.RzListView1Data(Sender: TObject; Item: TListItem);
var
  i:integer;
begin
  item.ImageIndex:=0;
  try
    if (Item.Index <= arraylist.Count-1) then
    begin
      for i:=0 to 8 do
      begin
        case i of
          0: Item.Caption:= utf8toansi(arraylist.items[Item.Index].get('order_id'));
          1: Item.SubItems.Add(utf8toansi( arraylist.items[Item.Index].get('order_sn')) );
          2: Item.SubItems.Add(utf8toansi( arraylist.items[Item.Index].get('consignee')) );
          3: Item.SubItems.Add(utf8toansi( arraylist.items[Item.Index].get('address')) );
          4: Item.SubItems.Add(utf8toansi( arraylist.items[Item.Index].get('invoice_no')) );
          5: Item.SubItems.Add(Utf8ToAnsi( arraylist.Items[item.index].get('pay_name')));
          6: Item.SubItems.Add(Utf8ToAnsi( arraylist.Items[item.index].get('shipping_name')));
          7: Item.SubItems.Add(Utf8ToAnsi( arraylist.Items[item.index].get('shipping_status')));
          8: Item.SubItems.Add(Utf8ToAnsi( arraylist.Items[item.index].get('add_time')));
        end;
      end;
    end;
  except
    //ShowMessage(IntToStr(Item.Index));
  end;
end;

procedure TfrmMain.btnPageFirstClick(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  page:=0;
  page_size:=StrToInt(edtPageSize.Text);
  lblPage.Caption:=IntToStr(page+1);

  getOrdersList;
  RzListView1.Items.Clear;
  RzListView1.Items.Count:=arraylist.Count;
  Screen.Cursor:=crDefault;
end;

procedure TfrmMain.btnPagePrevClick(Sender: TObject);
begin
  if page = StrToInt(lblPage.Caption) then exit;
  Screen.Cursor:=crHourGlass;
  page:=page-1;
  if page<0 then page:=0;
  lblPage.Caption:=IntToStr(page+1);

  getOrdersList;
  RzListView1.Items.Clear;
  RzListView1.Items.Count:=arraylist.Count;
  Screen.Cursor:=crDefault;
end;

procedure TfrmMain.btnPageNextClick(Sender: TObject);
begin
  if page = StrToInt(lblPage.Caption) then exit;
  Screen.Cursor:=crHourGlass;
  page:=page+1;
  if page>max_page then page:=max_page;
  lblPage.Caption:=IntToStr(page+1);


  getOrdersList;
  RzListView1.Items.Clear;
  RzListView1.Items.Count:=arraylist.Count;
  Screen.Cursor:=crDefault;
end;

procedure TfrmMain.btnPageLastClick(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  page:=max_page;
  page_size:=StrToInt(edtPageSize.Text);

  lblPage.Caption:=IntToStr(page+1);

  getOrdersList;
  RzListView1.Items.Clear;
  RzListView1.Items.Count:=arraylist.Count;
  Screen.Cursor:=crDefault;
end;

procedure TfrmMain.edtPageSizeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Screen.Cursor:=crHourGlass;

    page:=StrToInt(edtDirectPage.Text)-1;
    if page>max_page then page:=max_page;
    lblPage.Caption:=IntToStr(page+1);

    getOrdersList;
    RzListView1.Items.Clear;
    RzListView1.Items.Count:=arraylist.Count;
    Screen.Cursor:=crDefault;
  end;

  if not (Key in ['0'..'9',#13,#8,#46]) then key := #0;
end;

procedure TfrmMain.actPrintShippingExecute(Sender: TObject);
var
  order_id{, invoice_no, OrderMsg, PrintMsg, crlf}:string;
  OrderPrintInfo:TOrderPrintInfo;
  //ReportModFile:string;
  FastReportEx1: TFastReportEx;
  i:Integer;
begin
  if RzListView1.Items.Count=0 then Exit;
  if RzListView1.Selected=nil then Exit;
  //��ӡ����
  try
    order_id:=RzListView1.Selected.Caption;
  except
    MessageBox( Self.Handle, PChar( RSTR_EMPTY_PRINT ),
      PChar( STR_APPTITLE ), MB_ICONEXCLAMATION );
    Exit;
  end;
//  OrderMsg:='';
//  PrintMsg:='';
//  crlf:='';

  PReportFile:='';//��ʼ����ӡ�����ļ����ɵ�һ�δ�ӡʱ����
  PPrintName:='';//��ʼ����ӡ������
  PIsPrint:=False;//��ʼ���Ƿ��ӡ��־
  for i:=0 to RzListView1.Items.Count-1 do
  begin
    if RzListView1.Items[i].Selected then
    begin
      order_id:=RzListView1.Items[i].Caption;
//      if i>0 then crlf:=#13#10;

      //����ݵ���  --- ȥ�����ȴ�ӡ���ύ��ݵ���
//      invoice_no:=RzListView1.Items[i].SubItems[3];
//      if (invoice_no='δ����') or (invoice_no='') then
//      begin
//        OrderMsg:= OrderMsg + crlf + order_id;
//        Continue;
//      end;


      //��ȡ������ӡ����ϸ��Ϣ
      OrderPrintInfo:=getOrderPrintInfo(order_id, PServiceURL);
      //��ӡѭ���еĶ�������ѡ���еģ�
      FastReportEx1:=TFastReportEx.Create(Self);
      FastReportEx1.AppDirectory:=ExtractFilePath(Application.ExeName);
      FastReportEx1.PrintOrder('shipping', order_id, OrderPrintInfo, True);//����������ӡ
      FastReportEx1.Free;

//      ReportModFile:=Format(ExtractFilePath(ParamStr(0))+'shipping\%s.fr3',[OrderPrintInfo.ShippingCode]);
//      if FileExists(ReportModFile) then
//      begin
//        OrderPrintPreview(OrderPrintInfo, ReportModFile, False); //��ӡ��ݵ�
//        postOrerShipping(order_id, PServiceURL); //��ķ���״̬
//      end
//      else
//      begin
//          PrintMsg:= PrintMsg + crlf + order_id;
//      end;

    end;
    //��ӡ���
  end;
//  if OrderMsg<>'' then
//    MessageBox( Self.Handle, PChar( OrderMsg + crlf + '���϶�����'+ RSTR_NOTFOUND_INVOICE_NO ),
//      PChar( STR_APPTITLE ), MB_ICONEXCLAMATION );
//  if PrintMsg<>'' then
//    MessageBox( Self.Handle, PChar( PrintMsg + crlf + '���϶�����'+ RSTR_NOTFOUND_MODFILE ),
//      PChar( STR_APPTITLE ), MB_ICONEXCLAMATION );
    //��������б�---------
    PWhere:=STR_WHERE;
    page:=0;
    if page>max_page then page:=max_page;
    lblPage.Caption:=IntToStr(page+1);
    getOrdersList;
    RzListView1.Items.Clear;
    RzListView1.Items.Count:=arraylist.Count;
end;

procedure TfrmMain.actEditOrderInfoExecute(Sender: TObject);
var
  OrderId:string;
  ModalResult: TModalResult;
begin
  if RzListView1.Items.Count=0 then Exit;
  if RzListView1.Selected=nil then Exit;
  //�༭����
  inherited;
  try
    OrderId:=RzListView1.Selected.Caption;
  except
    MessageBox( Self.Handle, PChar( RSTR_EMPTY_PRINT ),
      PChar( STR_APPTITLE ), MB_ICONEXCLAMATION );
    Exit;
  end;
  
  try
    Screen.Cursor:=crHourGlass;
    frmOrderInfo:=TfrmOrderInfo.Create(Self, OrderId);
    ModalResult:=frmOrderInfo.ShowModal;
    if ModalResult = mrOK then
    begin
      getOrdersList;
      setListView;
    end;
  finally
    frmOrderInfo.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfrmMain.actSearchOrderExecute(Sender: TObject);
var
  SearchWhere:string;
  ModalResult: TModalResult;
begin
  //���Ҷ���
  inherited;
  try
    frmSearchOrder:=TfrmSearchOrder.Create(Self);
    ModalResult:=frmSearchOrder.ShowModal;
    // TODO: ˢ����ʾ���ҽ��ҳ��
    if (ModalResult = mrOK) and (PSearchKeyWord<>'')  then
    begin
      try
        Screen.Cursor:=crHourGlass;
        SearchWhere:= QuotedStr('%'+ AnsiToUtf8( Trim(PSearchKeyWord) )+'%');
        SearchWhere:=Format(STR_SEARCH_FMT, [SearchWhere, SearchWhere, SearchWhere, SearchWhere, SearchWhere]);
        PWhere:=SearchWhere;
        InitListView;
        getOrdersList(SearchWhere);
        setListView;                                       
        Screen.Cursor:=crDefault;
      except
        Screen.Cursor:=crDefault;
      end;
    end;
  finally
    frmSearchOrder.Free;
  end;
end;

procedure TfrmMain.actPrintPreviewExecute(Sender: TObject);
var
  order_id:string;
  OrderPrintInfo:TOrderPrintInfo;
  //ReportModFile:string;
  FastReportEx1: TFastReportEx;
begin
  if RzListView1.Items.Count=0 then Exit;
  if RzListView1.Selected=nil then Exit;
  //��ӡԤ��
  try
    order_id:=RzListView1.Selected.Caption;
  except
    MessageBox( Self.Handle, PChar( RSTR_EMPTY_PRINT ),
      PChar( STR_APPTITLE ), MB_ICONEXCLAMATION );
    Exit;
  end;

  Screen.Cursor:=crHourGlass;
  PIsPrint:=False;//δ��ӡ

  //��ȡ������ӡ����ϸ��Ϣ
  OrderPrintInfo:=getOrderPrintInfo(order_id, PServiceURL);

//  ReportModFile:=Format(ExtractFilePath(ParamStr(0))+'shipping\%s.fr3',[OrderPrintInfo.ShippingCode]);
//  if FileExists(ReportModFile) then
//    OrderPrintPreview(OrderPrintInfo, ReportModFile)
//  else
//  begin
//    if OrderPrintInfo.ShippingCode='' then
//      MessageBox( Self.Handle, PChar( RSTR_NOTFOUND_SHIPPING ),
//      PChar( STR_APPTITLE ), MB_ICONEXCLAMATION )
//    else
//      MessageBox( Self.Handle, PChar( Format('%s.fr3',[OrderPrintInfo.ShippingCode]) +#13#10+ RSTR_NOTFOUND_MODFILE ),
//      PChar( STR_APPTITLE ), MB_ICONEXCLAMATION );
//  end;

  FastReportEx1:=TFastReportEx.Create(Self);
  FastReportEx1.AppDirectory:=ExtractFilePath(Application.ExeName);
  FastReportEx1.PrintOrder('shipping', order_id, OrderPrintInfo);
  FastReportEx1.Free;

  if PIsPrint then //����Ѵ�ӡ��ˢ���б�
  begin
    //��������б�---------
    PWhere:=STR_WHERE;
    InitListView;
    getOrdersList;
    setListView;
  end;

  Screen.Cursor:=crDefault;
end;

procedure TfrmMain.actShowAboutExecute(Sender: TObject);
begin
  //���ڳ���
  inherited;
  frmAbout:=TfrmAbout.Create(Self);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain.actOrderListExecute(Sender: TObject);
begin
  PWhere:=STR_WHERE;
  InitListView;
  getOrdersList;
  setListView;
end;

procedure TfrmMain.actViewShippedExecute(Sender: TObject);
begin
  PWhere:='order_status=1 and shipping_status=1';
  InitListView;
  getOrdersList;
  setListView;
end;

procedure TfrmMain.RzListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  SortCol:=Column.Index;
  if (SortWay=1) then SortWay:=-1 else SortWay:=1;
  (Sender as TCustomListView).AlphaSort;
end;

procedure TfrmMain.RzListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  t: Integer;  
begin
  if (SortCol=0) then
  begin
    Compare:=SortWay * CompareText(Item1.Caption,Item2.Caption);
  end else
  begin
    t:=SortCol-1;
    Compare:=SortWay * CompareText(Item1.SubItems[t],Item2.SubItems[t]);
  end;
end;

procedure TfrmMain.WorkBeginEvent(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: Integer);
begin
  RzProgressStatus1.Visible:=True;
  RzProgressStatus1.TotalParts:=AWorkCountMax;
  RzProgressStatus1.PartsComplete:=0;
end;

procedure TfrmMain.WorkEndEvent(Sender: TObject; AWorkMode: TWorkMode);
begin
  RzProgressStatus1.Visible:=False;
end;

procedure TfrmMain.WorkEvent(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: Integer);
begin
  RzProgressStatus1.PartsComplete:=AWorkCount;
end;

procedure TfrmMain.RzListView1Click(Sender: TObject);
begin
  if RzListView1.Items.Count=0 then exit;
  if RzListView1.Selected=nil then exit;
  edtConsignee.Text:=RzListView1.Selected.SubItems[2];
end;

end.
