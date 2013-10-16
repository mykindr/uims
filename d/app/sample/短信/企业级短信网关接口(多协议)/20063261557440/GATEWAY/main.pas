{
2005/12/25
ʥ���ڣ������еĳ���������һ�Σ������������˴��뻹���ڰ��Ʒ��SGIPû�п����꣬��
Ϊû��ʵ�ʵ����ؿ����� CMPPҲ��2.0,CMPP3.0ͬ��ԭ��û�п�����
���˭���ô˴��룬�����޸ĳɹ��Ĵ��룬�뷢�ﹲ����ҲΪ��DLEPHI���õķ�չ����
���ɹ���������������룺�뿴�˽��������51JOB��������DELPHI��������>2000��DELPHI
��<10;���ǣ���˵�أ��ҽ���������Ĵ��룬����ʵ��������ҵ���ģ�һ�״���ļ�ֵ����
20�����ϣ���Щ�����г��Ļر�������Ǳ������ͬ����һ��DELPHI��������

����ʣ�www.cnrenwy.com Ҳ����������ʱ�򣬻�û�н���
�ر�ע�⣺www.cnrenwy.com �ҽ��������� ����ʱ���� �����ڷų� ���룻�ر�����Щ��
����ĳЩ�շ���վ��Ҫ һ�����ſ��Ի�á�����ȡ1�¹ҳ���
ע���˷ݴ��벿�ֲο����� ��Ѱ�õĲ��ִ��� ����ʱ �ṩ��δ����Ȩ��
 
unit main;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, IdBaseComponent, IdComponent, IdTCPConnection, md5, IdTCPClient,
  ComCtrls, StdCtrls, ExtCtrls, IdUDPBase, IdUDPClient, Buffer, DB, ADODB,
  IdAntiFreezeBase, IdAntiFreeze, SPPO10,global,  SMGP13, cmpp20, SGIP12, Activex;

type
  //���ţ�С��ͨ
  TOutPacket = class
  public
    pac: TSMGP13_PACKET;
    constructor Create(p: TSMGP13_PACKET);
    destructor destroy; override;
  end;

  //�ƶ�
  TOutcmppPacket = class
  public
    pac: TCMPP20_PACKET;
    constructor Create(p: TCMPP20_PACKET);
    destructor destroy; override;
  end;

  //��ͨ
  TOutSgipPacket = class
  public
    pac: TSGIP12_PACKET;
    constructor Create(p: TSGIP12_PACKET);
    destructor destroy; override;
  end;

  //MTȺ���߳�
  TMtQfThread = class(TThread)
    LastActiveTime: TDateTime;
    ErrMsg: string;
    AdoConnection: TADOConnection;
    AdoQuery: TAdoQuery;
    HaveMc: boolean;
  private
    Seqid: integer;
    function GetSeqid: integer;
    function GetInMsgId: string;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure ConnectDB;

    //�������ȼ���ߣ������ȼ���ָ���ȼ�Ϊ9��Ⱥ�����ݣ������ȼ���ָ9���µ�Ⱥ������
    procedure LowPriorityQf; //�����ȼ�Ⱥ��
    procedure HighPriovityQf; //�����ȼ�Ⱥ��
    procedure McQf; //����Ⱥ��
  end;

  //����߳�
  TMonitorThreadObj = class(TThread)
    LastActiveTime: TDateTime;
    OutListview: TListView;
    InListview: TListView;
    InMonitorBuffer: TMonitorInBufferObj;
    OutMonitorBuffer: TMonitorOutBufferObj;
    OutMonitorcmppBuffer: TMonitorOutcmppBufferObj;
    OutMonitorSgipBuffer: TMonitorOutSgipBufferObj;
    ErrMsg: string;
    LastPrcExpireTime: TDateTime;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure ShowOutPac(pac: TSMGP13_PACKET);
    procedure ShowOutcmppPac(pac: TCMPP20_PACKET);
    procedure ShowOutSgipPac(pac: TSGIP12_PACKET);
  end;

  //MT��ϢԤ�����߳�
  TMtPrePrcThreadObj = class(TThread)
    LastActiveTime: TDateTime;
    ErrMsg: string;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure MtPrePrc;
  end;

  //��־��¼�߳�
  TLogThreadObj = class(TThread)
    LastActiveTime: TDateTime;
    ErrMsg: string;
    AdoConnection: TADOConnection;
    AdoQuery: TAdoQuery;
  private
    procedure LogMt;
    procedure LogMo;
    procedure LogRpt;
  protected
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure ConnectDB;
    procedure CreateRpt(Buffer: TMtBuffer);
  end;

  //SMGP MT��Ϣ�����߳�
  TMtSendSMGPThreadObj = class(TThread)
    LastActiveTime: TDateTime;
    ErrMsg: string;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure MtPrc;
  end;

  //�ⲿ������Ϣ�����߳�   (����Ӫ��SMGP��Ҫ�߳�)
  TOutReadSMGPThreadObj = class(TThread)
    FTCPClient: TIdTCPClient;
    FRecBuffer: TCOMMBuffer;
    FlocPacketIn: TSMGP13_PACKET;
    FnetPacketIn: TSMGP13_PACKET;
    FLogined: boolean; //�Ƿ��ѵ�¼�ɹ�
    FMoCount: Cardinal; //Mo������
    FMtCount: Cardinal; //Mt������
    FMtRespCount: Cardinal; //MtӦ�������
    FMtRefuseCount: Cardinal; //Mt�ܾ�������
    FRptCount: Cardinal; //״̬���������
    FLastActiveTime: TDateTime; //���ʱ��
    LastSendActiveTime: TDateTime; //����ͻ���԰���ʱ��
    LastLoginTime: TDateTime; //����͵�¼����ʱ��
    ErrMsg: string; //������Ϣ
    MtMessage: string;
    MtNumber: string;
    MtUnsend: integer;
    MtHasUnsendMessage: boolean;
    WindowSize: integer; //�������ڴ�С
    Seqid: Cardinal; //���
    log_smgp_time: integer;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure ClientRead;
    function CreatePacket(const RequestID: Cardinal): TSMGP13_PACKET;
    function CreateRespPacket(const recpac: TSMGP13_PACKET): TSMGP13_PACKET;
    function GetSeqid: Cardinal;
    procedure SendPacket(pac: TSMGP13_PACKET);
    procedure SendMt(i: integer);
    procedure PrcMt;
  end;

  //CMPP MT��Ϣ�����߳�
  TMtSendCMPPThreadObj = class(TThread)
    LastActiveTime: TDateTime;
    ErrMsg: string;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure MtPrc;
  end;

  //�ⲿ������Ϣ�����߳�   (����Ӫ��cmpp��Ҫ�߳�)
  TOutReadCMPPThreadObj = class(TThread)
    FTCPCmppClient: TIdTCPClient; //����
    FRecCmppBuffer: TCOMMBuffer;
    FlocCmppPacketIn: TCMPP20_PACKET;
    FnetCmppPacketIn: TCMPP20_PACKET;
    FLogined: boolean; //�Ƿ��ѵ�¼�ɹ�
    FMoCount: Cardinal; //Mo������
    FMtCount: Cardinal; //Mt������
    FMtRespCount: Cardinal; //MtӦ�������
    FMtRefuseCount: Cardinal; //Mt�ܾ�������
    FRptCount: Cardinal; //״̬���������
    FLastActiveTime: TDateTime; //���ʱ��
    LastSendActiveTime: TDateTime; //����ͻ���԰���ʱ��
    LastLoginTime: TDateTime; //����͵�¼����ʱ��
    ErrMsg: string; //������Ϣ
    MtMessage: string;
    MtNumber: string;
    MtUnsend: integer;
    MtHasUnsendMessage: boolean;
    WindowSize: integer; //�������ڴ�С
    Seqid: Cardinal; //���
    log_cmpp_time: integer;
    log_port: integer; //����ͬʱ һ���˿� ���� �˿ں�ͬʱ��½ ��������
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure ClientRead;
    function CreatePacket(const RequestID: Cardinal): TCMPP20_PACKET; //����CMPP��
    function CreateRespPacket(const recpac: TCMPP20_PACKET): TCMPP20_PACKET;
    function GetSeqid: Cardinal;
    procedure SendPacket(pac: TCMPP20_PACKET); //����CMPP��
    procedure SendMt(i: integer);
    procedure PrcMt;
  end;

  //CMPP0 MT��Ϣ�����߳�
  TMtSendCMPP0ThreadObj = class(TThread)
    LastActiveTime: TDateTime;
    ErrMsg: string;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure MtPrc;
  end;

  //�ⲿ������Ϣ�����߳�   (����Ӫ��cmpp0��Ҫ�߳�)
  TOutReadCMPP0ThreadObj = class(TThread)
    FTCPCmppClient: TIdTCPClient; //����
    FRecCmppBuffer: TCOMMBuffer;
    FlocCmppPacketIn: TCMPP20_PACKET;
    FnetCmppPacketIn: TCMPP20_PACKET;
    FLogined: boolean; //�Ƿ��ѵ�¼�ɹ�
    FMoCount: Cardinal; //Mo������
    FMtCount: Cardinal; //Mt������
    FMtRespCount: Cardinal; //MtӦ�������
    FMtRefuseCount: Cardinal; //Mt�ܾ�������
    FRptCount: Cardinal; //״̬���������
    FLastActiveTime: TDateTime; //���ʱ��
    LastSendActiveTime: TDateTime; //����ͻ���԰���ʱ��
    LastLoginTime: TDateTime; //����͵�¼����ʱ��
    ErrMsg: string; //������Ϣ
    MtMessage: string;
    MtNumber: string;
    MtUnsend: integer;
    MtHasUnsendMessage: boolean;
    WindowSize: integer; //�������ڴ�С
    Seqid: Cardinal; //���
    log_cmpp_time: integer;
    log_port: integer; //����ͬʱ һ���˿� ���� �˿ں�ͬʱ��½ ��������
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure ClientRead;
    function CreatePacket(const RequestID: Cardinal): TCMPP20_PACKET; //����CMPP��
    function CreateRespPacket(const recpac: TCMPP20_PACKET): TCMPP20_PACKET;
    function GetSeqid: Cardinal;
    procedure SendPacket(pac: TCMPP20_PACKET); //����CMPP��
    procedure PrcMt;
  end;

  //Sgip MT��Ϣ�����߳�
  TMtSendSgipThreadObj = class(TThread)
    LastActiveTime: TDateTime;
    ErrMsg: string;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure MtPrc;
  end;

  //�ⲿ������Ϣ�����߳�   (����Ӫ��SGIP��Ҫ�߳�)
  TOutReadSgipThreadObj = class(TThread)
    FTCPClient: TIdTCPClient;
    FRecBuffer: TCOMMBuffer;
    FlocPacketIn: TSGIP12_PACKET;
    FnetPacketIn: TSGIP12_PACKET;
    FLogined: boolean; //�Ƿ��ѵ�¼�ɹ�
    FMoCount: Cardinal; //Mo������
    FMtCount: Cardinal; //Mt������
    FMtRespCount: Cardinal; //MtӦ�������
    FMtRefuseCount: Cardinal; //Mt�ܾ�������
    FRptCount: Cardinal; //״̬���������
    FLastActiveTime: TDateTime; //���ʱ��
    LastSendActiveTime: TDateTime; //����ͻ���԰���ʱ��
    LastLoginTime: TDateTime; //����͵�¼����ʱ��
    ErrMsg: string; //������Ϣ
    MtMessage: string;
    MtNumber: string;
    MtUnsend: integer;
    MtHasUnsendMessage: boolean;
    WindowSize: integer; //�������ڴ�С
    Seqid: Cardinal; //���
    log_smgp_time: integer;
  protected
    procedure Execute; override;
    procedure AddMsgToMemo(const Msg: string);
    procedure ThAddMsgToMemo;
  public
    constructor Create(CreateSuspended: boolean); overload;
    destructor destroy; override;
    procedure ClientRead;
    function CreatePacket(const RequestID: Cardinal): TSGIP12_PACKET;
    function CreateRespPacket(const recpac: TSGIP12_PACKET): TSGIP12_PACKET;
    function GetSeqid: Cardinal;
    procedure SendPacket(pac: TSGIP12_PACKET);
    procedure SendMt(i: integer); //�����߳�
    procedure PrcMt;
  end;

  TMainForm = class(TForm)
    SMGPTCPClient: TIdTCPClient;
    CmppTCPClient: TIdTCPClient;
    Cmpp0TCPClient: TIdTCPClient;
    SgipTCPClient: TIdTCPClient;
    PageControl1: TPageControl;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    OutListview: TListView;
    Splitter2: TSplitter;
    OutPMemo: TMemo;
    MonitorMemo: TMemo;
    IdAntiFreeze1: TIdAntiFreeze;
    AdoConnection: TADOConnection;
    AdoQuery: TAdoQuery;
    OutPopupMenu: TPopupMenu;
    OutMonitor: TMenuItem;
    N11: TMenuItem;
    MonitorTimer: TTimer;
    Timer1: TTimer;
    Label3: TLabel;
    Splitter1: TSplitter;
    MOMemo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SMGPTCPClientConnected(Sender: TObject);
    procedure SMGPTCPClientDisconnected(Sender: TObject);
    procedure CmppTCPClientConnected(Sender: TObject);
    procedure CmppTCPClientDisconnected(Sender: TObject);
    procedure Cmpp0TCPClientConnected(Sender: TObject);
    procedure Cmpp0TCPClientDisconnected(Sender: TObject);
    procedure SgipTCPClientConnected(Sender: TObject);
    procedure SgipTCPClientDisconnected(Sender: TObject);
    procedure OutListViewAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: boolean);
    procedure OutListViewDblClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure InListViewAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: boolean);
    procedure N9Click(Sender: TObject);
    procedure MonitorTimerTimer(Sender: TObject);
    procedure MonitorMemoChange(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    OutLastConnectTime: TDateTime; //SMGP �������ʱ��
    OutLastCMPPConnectTime: TDateTime; //cmpp �������ʱ��
    OutLastCMPP0ConnectTime: TDateTime; //cmpp0 �������ʱ��
    OutLastSgipConnectTime: TDateTime; //SGiP �������ʱ��
  public
    procedure ShowToMemo(s: string; m: TMemo);
    function ReadConfig: boolean; //��ȡ�����ļ�
    procedure ConnectDB(AdoConnection: TADOConnection); //���ӵ����ݿ�
    procedure LoadServiceCode; //��ʱ��ʹ�� �Լ��о���
    procedure LoadProtocol; //��ʱ��ʹ�� �Լ��о���
    procedure smcmo; //SMGP MO���� SMG--SP
    procedure smcmo0; //CMPP MO���� SMG--SP
    procedure smcmt; //MT���� SP--SMG
  end;

var
  MainForm: TMainForm;
  MonitorThread: TMonitorThreadObj;
  MtPrePrcThread: TMtPrePrcThreadObj;
  MtQfThread: TMtQfThread;
  LogThread: TLogThreadObj;
  OutReadThread: TOutReadSMGPThreadObj; //smgp �߳�
  MtSendThread: TMtSendSMGPThreadObj;
  OutReadCMPPThread: TOutReadCMPPThreadObj; //cmpp �߳�
  MtSendCMPPThread: TMtSendCMPPThreadObj;
  OutReadCMPP0Thread: TOutReadCMPP0ThreadObj; //cmpp0 �߳�
  MtSendCMPP0Thread: TMtSendCMPP0ThreadObj;
  OutReadSgipThread: TOutReadSgipThreadObj; //sgip �߳�
  MtSendSgipThread: TMtSendSgipThreadObj;
implementation
uses
  WinSock, Md5unit, Cryptcon, IniFiles, DateUtils;
{$R *.dfm}

{ TMtQfThread }
procedure TMtQfThread.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

constructor TMtQfThread.Create(CreateSuspended: boolean);
begin
  inherited;
  LastActiveTime := now;
  AdoConnection := TADOConnection.Create(nil);
  AdoQuery := TAdoQuery.Create(nil);
  AdoQuery.Connection := AdoConnection;
  Seqid := 1;
  HaveMc := false;
end;

destructor TMtQfThread.destroy;
begin
  AdoQuery.Free;
  AdoConnection.Free;
  LastActiveTime := 0;
  inherited;
end;

procedure TMtQfThread.Execute;
var
  iHour: integer;
  strSql: string;
  iDay: integer;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        if AdoConnection.Connected then
        begin
          iHour := hourof(now);
          iDay := Dayof(now);
          {if MainForm.HUADAN.Checked then
          begin
            if (iDay >= GGATECONFIG.MCSTART) and (iDay < GGATECONFIG.MCEND) then
            begin
              McQf;
            end;
          end;
        }
          //�����ȼ�
          HighPriovityQf;

          //�����ȼ�,������ʱ��
          {if (iHour in [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]) and (HaveMc = false) then
          begin
            if MainForm.QUNFA.Checked then
            begin
              LowPriorityQf;
            end;
          end; }

          //���Ѵ�������״̬���������ɾ��
          strSql := 'delete MTSEND where PrcEd = 1 and Gateid = ' + inttostr(GSMSCENTERCONFIG.GateId) + ' and status is not null';
          AdoConnection.Execute(strSql);
          //���ѹ�72Сʱ����δ��״̬����ģ�����״̬����Ϊ2������ʧ��
          strSql := 'update MTSEND set status = 2 where PrcEd = 1 and Gateid = ' + inttostr(GSMSCENTERCONFIG.GateId) + ' and getdate() - sendtime > 3';
          AdoConnection.Execute(strSql);
        end
        else
        begin
          ConnectDB;
          sleep(3000);
        end;
      except
        on e: exception do
        begin
          AddMsgToMemo('MTȺ���߳�:' + e.Message);

          if e.Message = '����ʧ��' then
          begin
            AdoConnection.Close;
          end;

        end;
      end;
    finally
      LastActiveTime := now;
      sleep(1000);
    end;
  end;
end;

function TMtQfThread.GetInMsgId: string;
var
  str: string;
  i: integer;
begin
  //3λ���غ� + 14 yyyymmddhhnnss + 3���,��20
  str := copy(inttostr(GSMSCENTERCONFIG.GateId), 2, 3) + FormatDatetime('yyyymmddhhnnss', now);
  i := GetSeqid;
  if i >= 100 then
  begin
    str := str + inttostr(i);
  end
  else if i >= 10 then
  begin
    str := str + '0' + inttostr(i);
  end
  else
  begin
    str := str + '00' + inttostr(i);
  end;
  result := str;
end;

function TMtQfThread.GetSeqid: integer;
begin
  result := Seqid;
  inc(Seqid);
  if Seqid >= 1000 then
  begin
    Seqid := 1;
  end;
end;

procedure TMtQfThread.HighPriovityQf;
var
  MtBufferCount: integer;
  strSql: string;
  pac: TSPPO_PACKET;
  Autoid: integer;
  MtInMsgId: string;
begin
  MtBufferCount := mtbuffer.Count;
  if MtBufferCount < GGATECONFIG.Flux then
  begin
    strSql := 'select top ' + inttostr(GGATECONFIG.Flux) + ' * from mtsend where gateid = ' + inttostr(GSMSCENTERCONFIG.GateId) + ' and Prced = 0 and Priority = 9 order by autoid';
    ;
    AdoQuery.Close;
    AdoQuery.SQL.Text := strSql;
    AdoQuery.Open;
    while not AdoQuery.Eof do
    begin
      ZeroMemory(@pac, sizeof(TSPPO_PACKET));
      Autoid := AdoQuery.fieldbyname('Autoid').AsInteger;
      pac.Body.Mt.MtLogicId := 1; //Ⱥ��
      pac.Body.Mt.MtMsgType := 1; //��MO�����MT
      pac.Body.Mt.MoOutMsgId := '';
      pac.Body.Mt.MoInMsgId := '';
      MtInMsgId := GetInMsgId;
      HexToChar(MtInMsgId, pac.Body.Mt.MtInMsgId);
      pac.Body.Mt.MoLinkId := '';

      SetPchar(pac.Body.Mt.MtSpAddr, AdoQuery.fieldbyname('MtSpAddr').AsString, sizeof(pac.Body.Mt.MtSpAddr));
      SetPchar(pac.Body.Mt.MtUserAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtUserAddr));
      SetPchar(pac.Body.Mt.MtFeeAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtFeeAddr));
      SetPchar(pac.Body.Mt.MtServiceId, AdoQuery.fieldbyname('MtServiceId').AsString, sizeof(pac.Body.Mt.MtServiceId));
      pac.Body.Mt.MtMsgFmt := 15;
      pac.Body.Mt.MtMsgLenth := length(AdoQuery.fieldbyname('MtMsgContent').AsString);
      SetPchar(pac.Body.Mt.MtMsgContent, AdoQuery.fieldbyname('MtMsgContent').AsString, pac.Body.Mt.MtMsgLenth);

      mtbuffer.Add(pac);
      strSql := 'update MTSEND set PrcEd = 1, MtInMsgId = ' + Quotedstr(MtInMsgId) + ' where autoid = ' + inttostr(Autoid);
      AdoConnection.Execute(strSql);
      AdoQuery.MoveBy(1);
    end;
    AdoQuery.Close;
  end;
end;

procedure TMtQfThread.LowPriorityQf;
var
  MtBufferCount: integer;
  strSql: string;
  pac: TSPPO_PACKET;
  Autoid: integer;
  MtInMsgId: string;
  ValidTime: string;
begin
  MtBufferCount := mtbuffer.Count;
  if MtBufferCount < GGATECONFIG.Flux then
  begin
    strSql := 'select top ' + inttostr(GGATECONFIG.Flux * 3) + ' * from mtsend where gateid = ' + inttostr(GSMSCENTERCONFIG.GateId) + ' and Prced = 0 order by autoid';
    AdoQuery.Close;
    AdoQuery.SQL.Text := strSql;
    AdoQuery.Open;
    while not AdoQuery.Eof do
    begin
      ZeroMemory(@pac, sizeof(TSPPO_PACKET));
      Autoid := AdoQuery.fieldbyname('Autoid').AsInteger;
      pac.Body.Mt.MtLogicId := 1; //Ⱥ��
      pac.Body.Mt.MtMsgType := 1; //��MO�����MT
      pac.Body.Mt.MoOutMsgId := '';
      pac.Body.Mt.MoInMsgId := '';
      MtInMsgId := GetInMsgId;
      HexToChar(MtInMsgId, pac.Body.Mt.MtInMsgId);
      pac.Body.Mt.MoLinkId := '';

      SetPchar(pac.Body.Mt.MtSpAddr, AdoQuery.fieldbyname('MtSpAddr').AsString, sizeof(pac.Body.Mt.MtSpAddr));
      SetPchar(pac.Body.Mt.MtUserAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtUserAddr));
      SetPchar(pac.Body.Mt.MtFeeAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtFeeAddr));
      SetPchar(pac.Body.Mt.MtServiceId, AdoQuery.fieldbyname('MtServiceId').AsString, sizeof(pac.Body.Mt.MtServiceId));
      pac.Body.Mt.MtMsgFmt := 15;
      pac.Body.Mt.MtMsgLenth := length(AdoQuery.fieldbyname('MtMsgContent').AsString);
      SetPchar(pac.Body.Mt.MtMsgContent, AdoQuery.fieldbyname('MtMsgContent').AsString, pac.Body.Mt.MtMsgLenth);

      mtbuffer.Add(pac);
      strSql := 'update MTSEND set PrcEd = 1, MtInMsgId = ' + Quotedstr(MtInMsgId) + ' where autoid = ' + inttostr(Autoid);
      AdoConnection.Execute(strSql);
      AdoQuery.MoveBy(1);
    end;
    AdoQuery.Close;
  end;
end;

procedure TMtQfThread.McQf;
var
  MtBufferCount: integer;
  strSql: string;
  pac: TSPPO_PACKET;
  Autoid: integer;
  MtInMsgId: string;
begin
  //���ͻ���
  MtBufferCount := mtbuffer.Count;
  if MtBufferCount < GGATECONFIG.Flux then
  begin
    strSql := 'select top ' + inttostr(GGATECONFIG.Flux * 3) + ' * from mcsend where gateid = ' + inttostr(GSMSCENTERCONFIG.GateId) + ' and Prced = 0 and Priority = 9 order by autoid';
    ;
    AdoQuery.Close;
    AdoQuery.SQL.Text := strSql;
    AdoQuery.Open;
    if not AdoQuery.Eof then
    begin
      //�л�������
      while not AdoQuery.Eof do
      begin
        ZeroMemory(@pac, sizeof(TSPPO_PACKET));
        Autoid := AdoQuery.fieldbyname('Autoid').AsInteger;
        pac.Body.Mt.MtLogicId := 2; //����
        pac.Body.Mt.MtMsgType := AdoQuery.fieldbyname('InMtMsgType').AsInteger;
        pac.Body.Mt.MoOutMsgId := '';
        pac.Body.Mt.MoInMsgId := '';
        MtInMsgId := GetInMsgId;
        HexToChar(MtInMsgId, pac.Body.Mt.MtInMsgId);
        pac.Body.Mt.MoLinkId := '';
        SetPchar(pac.Body.Mt.MtSpAddr, AdoQuery.fieldbyname('MtSpAddr').AsString, sizeof(pac.Body.Mt.MtSpAddr));
        SetPchar(pac.Body.Mt.MtUserAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtUserAddr));
        SetPchar(pac.Body.Mt.MtFeeAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtFeeAddr));
        SetPchar(pac.Body.Mt.MtServiceId, AdoQuery.fieldbyname('MtServiceId').AsString, sizeof(pac.Body.Mt.MtServiceId));
        pac.Body.Mt.MtMsgFmt := 15;
        pac.Body.Mt.MtMsgLenth := length(AdoQuery.fieldbyname('MtMsgContent').AsString);
        SetPchar(pac.Body.Mt.MtMsgContent, AdoQuery.fieldbyname('MtMsgContent').AsString, pac.Body.Mt.MtMsgLenth);
        mtbuffer.Add(pac);
        strSql := 'update MCSEND set PrcEd = 1, MtInMsgId = ' + Quotedstr(MtInMsgId) + ', Sendtime = getdate() where autoid = ' + inttostr(Autoid);
        AdoConnection.Execute(strSql);
        AdoQuery.MoveBy(1);
      end;
      HaveMc := True;
    end
    else
    begin
      HaveMc := false;
    end;
    AdoQuery.Close;

    if HaveMc = false then
    begin
      //���ͱ����Ѿ����ͣ�������ʧ�ܵĻ���
      strSql := 'select top 1 * from MCSEND where gateid = ' + inttostr(GSMSCENTERCONFIG.GateId) + ' and PrcEd = 1 and McMonth = ' + Quotedstr(FormatDatetime('yyyymm', now)) + ' and (Status <> 1 or status is null) and getdate() > sendtime + 1 order by autoid';
      AdoQuery.Close;
      AdoQuery.SQL.Text := strSql;
      AdoQuery.Open;
      if not AdoQuery.Eof then
      begin
        ZeroMemory(@pac, sizeof(TSPPO_PACKET));
        Autoid := AdoQuery.fieldbyname('Autoid').AsInteger;
        pac.Body.Mt.MtLogicId := 2; //����
        pac.Body.Mt.MtMsgType := AdoQuery.fieldbyname('InMtMsgType').AsInteger;
        pac.Body.Mt.MoOutMsgId := '';
        pac.Body.Mt.MoInMsgId := '';
        MtInMsgId := GetInMsgId;
        HexToChar(MtInMsgId, pac.Body.Mt.MtInMsgId);
        pac.Body.Mt.MoLinkId := '';
        SetPchar(pac.Body.Mt.MtSpAddr, AdoQuery.fieldbyname('MtSpAddr').AsString, sizeof(pac.Body.Mt.MtSpAddr));
        SetPchar(pac.Body.Mt.MtUserAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtUserAddr));
        SetPchar(pac.Body.Mt.MtFeeAddr, AdoQuery.fieldbyname('MtUserAddr').AsString, sizeof(pac.Body.Mt.MtFeeAddr));
        SetPchar(pac.Body.Mt.MtServiceId, AdoQuery.fieldbyname('MtServiceId').AsString, sizeof(pac.Body.Mt.MtServiceId));
        pac.Body.Mt.MtMsgFmt := 15;
        pac.Body.Mt.MtMsgLenth := length(AdoQuery.fieldbyname('MtMsgContent').AsString);
        SetPchar(pac.Body.Mt.MtMsgContent, AdoQuery.fieldbyname('MtMsgContent').AsString, pac.Body.Mt.MtMsgLenth);
        mtbuffer.Add(pac);
        strSql := 'update MCSEND set PrcEd = 1, MtInMsgId = ' + Quotedstr(MtInMsgId) + ', Sendtime = getdate() where autoid = ' + inttostr(Autoid);
        AdoConnection.Execute(strSql);
        HaveMc := True;
      end
      else
      begin
        HaveMc := false;
      end;
    end;
    AdoQuery.Close;
  end;
end;

procedure TMtQfThread.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

{ TMtPrePrcThreadObj }
procedure TMtPrePrcThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

constructor TMtPrePrcThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  LastActiveTime := now;
end;

destructor TMtPrePrcThreadObj.destroy;
begin
  LastActiveTime := 0;
  inherited;
end;

procedure TMtPrePrcThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        MtPrePrc;
      except
        on e: exception do
        begin
          AddMsgToMemo('MOԤ����:' + e.Message);
        end;
      end;
    finally
      LastActiveTime := now;
      sleep(10);
    end;
  end;
end;

procedure TMtPrePrcThreadObj.MtPrePrc;
var
  Seqid: integer;
  Mt: TMtBuffer;
  i: integer;
  j: integer;
  preprced: boolean;
begin
  if mtbuffer = nil then exit;
  Seqid := mtbuffer.GetPrePrc;
  if Seqid > 0 then
  begin
    Mt := mtbuffer.Read(Seqid);
    if Mt.Mt.MtLogicId = 2 then
    begin
      for j := 0 to high(Protocol) do
      begin
        if (Protocol[j].GateCode = Mt.Mt.MtServiceId) and (Protocol[j].MsgType = Mt.Mt.MtMsgType) then
        begin
          mtbuffer.UpdatePrePrced(Seqid, j);
        end;
      end;
    end
    else
    begin
      //����ҵ�����У���ת��
      preprced := false;
      for i := 0 to high(ServiceCode) do
      begin
        if (UpperCase(Mt.Mt.MtServiceId) = ServiceCode[i].LogicCode) and (Mt.Mt.MtLogicId = ServiceCode[i].LogicId) then
        begin
          for j := 0 to high(Protocol) do
          begin
            if (Protocol[j].GateCode = ServiceCode[i].GateCode) and (Mt.Mt.MtMsgType = Protocol[j].MsgType) then
            begin
              mtbuffer.UpdatePrePrced(Seqid, j);
              preprced := True;
              break;
            end;
          end;
        end;
      end;
      if preprced = false then
      begin
        //ҵ�����У���ת��ʧ�ڰ�
        //Ԥ�����޶�Ӧ���͵�ҵ�����
        mtbuffer.UpdateFailPrePrced(Seqid, 1);
      end;
    end;
  end;
end;

procedure TMtPrePrcThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

{ TMonitorThreadObj }
procedure TMonitorThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

constructor TMonitorThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  InMonitorBuffer := TMonitorInBufferObj.Create;
  OutMonitorBuffer := TMonitorOutBufferObj.Create;
  OutMonitorcmppBuffer := TMonitorOutcmppBufferObj.Create;
end;

destructor TMonitorThreadObj.destroy;
begin
  OutMonitorBuffer.Free;
  InMonitorBuffer.Free;
  inherited;
end;

procedure TMonitorThreadObj.Execute;
var
  i: integer;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        for i := 0 to high(OutMonitorBuffer.Buffers) do
        begin
          if OutMonitorBuffer.Buffers[i].IsUsed = 1 then
          begin
            ShowOutPac(OutMonitorBuffer.Buffers[i].pac);
            OutMonitorBuffer.Delete(i);
            break;
          end;
        end;

        for i := 0 to high(OutMonitorcmppBuffer.Buffers) do
        begin
          if OutMonitorcmppBuffer.Buffers[i].IsUsed = 1 then
          begin
            ShowOutcmppPac(OutMonitorcmppBuffer.Buffers[i].pac);
            OutMonitorcmppBuffer.Delete(i);
            break;
          end;
        end;

        //ÿ2���ӣ�ɾ����������
        if now - LastPrcExpireTime > 2 / 60 / 24 then
        begin
          if mobuffer <> nil then
          begin
            mobuffer.DelExpired;
            mobuffer.BakBuffer;
          end;

          if mocmppbuffer <> nil then
          begin
            mocmppbuffer.DelExpired;
            mocmppbuffer.BakBuffer;
          end;

          if mtbuffer <> nil then
          begin
            mtbuffer.DelExpired;
            mtbuffer.BakBuffer;
          end;

          if mtcmppbuffer <> nil then
          begin
            mtcmppbuffer.DelExpired;
            mtcmppbuffer.BakBuffer;
          end;

          if rptbuffer <> nil then
          begin
            rptbuffer.DelExpired;
            rptbuffer.BakBuffer;
          end;

          if rptcmppbuffer <> nil then
          begin
            rptcmppbuffer.DelExpired;
            rptcmppbuffer.BakBuffer;
          end;
          LastPrcExpireTime := now;
        end;
      except
        on e: exception do
        begin
          AddMsgToMemo('���ݰ�����߳�:' + e.Message);
        end;
      end;
    finally
      LastActiveTime := now;
      sleep(10);
    end;
  end;
end;

procedure TMonitorThreadObj.ShowOutPac(pac: TSMGP13_PACKET);
var
  li: TListItem;
  p: TOutPacket;
begin

  if (pac.MsgHead.RequestID <> SMGP13_ACTIVE_TEST) and (pac.MsgHead.RequestID <> SMGP13_ACTIVE_TEST_RESP) then
  begin
    if OutListview = nil then exit;

    if OutListview.Items.Count > 100 then
    begin
      OutListview.Items.BeginUpdate;
      TOutPacket(OutListview.Items[OutListview.Items.Count - 1].Data).Free;
      OutListview.Items[OutListview.Items.Count - 1].Data := nil;
      OutListview.Items.Delete(OutListview.Items.Count - 1);
      OutListview.Items.EndUpdate;
    end;

    if OutListview.Items.Count > 0 then
    begin
      li := OutListview.Items.Insert(0);
    end
    else
    begin
      li := OutListview.Items.Add;
    end;

    li.SubItems.Add(inttostr(pac.MsgHead.SequenceID));
    li.SubItems.Add(FormatDatetime('yyyy-mm-dd hh:nn:ss', now()));

    p := TOutPacket.Create(pac);
    li.Data := p;

    case pac.MsgHead.RequestID of
      SMGP13_LOGIN:
        begin
          li.Caption := '��¼';
        end;

      SMGP13_LOGIN_RESP:
        begin
          li.Caption := '��¼Ӧ��';
        end;

      SMGP13_DELIVER:
        begin
          if pac.MsgBody.DELIVER.IsReport = 0 then
            li.Caption := '����'
          else li.Caption := '����';
        end;

      SMGP13_DELIVER_RESP:
        begin
          if pac.MsgBody.DELIVER_RESP.MsgID = '' then
            li.Caption := '����Ӧ��'
          else li.Caption := '����Ӧ��';
        end;

      SMGP13_SUBMIT:
        begin
          li.Caption := '����';
        end;

      SMGP13_SUBMIT_RESP:
        begin
          li.Caption := '����Ӧ��';
        end;
    end;
  end;
end;

procedure TMonitorThreadObj.ShowOutcmppPac(pac: TCMPP20_PACKET);
var
  li: TListItem;
  p: TOutcmppPacket;
begin
  if (pac.MsgHead.Command_ID <> CMPP_ACTIVE_TEST) and (pac.MsgHead.Command_ID <> CMPP_ACTIVE_TEST_RESP) then
  begin
    if OutListview = nil then exit;

    if OutListview.Items.Count > 100 then
    begin
      OutListview.Items.BeginUpdate;
      TOutcmppPacket(OutListview.Items[OutListview.Items.Count - 1].Data).Free;
      OutListview.Items[OutListview.Items.Count - 1].Data := nil;
      OutListview.Items.Delete(OutListview.Items.Count - 1);
      OutListview.Items.EndUpdate;
    end;

    if OutListview.Items.Count > 0 then
    begin
      li := OutListview.Items.Insert(0);
    end
    else
    begin
      li := OutListview.Items.Add;
    end;

    li.SubItems.Add(inttostr(pac.MsgHead.Sequence_ID));
    li.SubItems.Add(FormatDatetime('yyyy-mm-dd hh:nn:ss', now()));

    p := TOutcmppPacket.Create(pac);
    li.Data := p;

    case pac.MsgHead.Command_ID of
      CMPP_CONNECT:
        begin
          li.Caption := '��¼';
        end;

      CMPP_CONNECT_RESP:
        begin
          li.Caption := '��¼Ӧ��';
        end;

      CMPP_DELIVER:
        begin
          if pac.MsgBody.CMPP_DELIVER.Registered_Delivery = 0 then
            li.Caption := '����'
          else li.Caption := '����';
        end;

      CMPP_DELIVER_RESP:
        begin
          if pac.MsgBody.CMPP_DELIVER_RESP.Msg_Id = 0 then
            li.Caption := '����Ӧ��'
          else li.Caption := '����Ӧ��';
        end;

      CMPP_SUBMIT:
        begin
          li.Caption := '����';
        end;

      CMPP_SUBMIT_RESP:
        begin
          li.Caption := '����Ӧ��';
        end;
    end;
  end;
end;

procedure TMonitorThreadObj.ShowOutSgipPac(pac: TSGIP12_PACKET);
var
  li: TListItem;
  p: TOutcmppPacket;
begin
  { if (pac.MsgHead.Command_ID <> CMPP_ACTIVE_TEST) and (pac.MsgHead.Command_ID <> CMPP_ACTIVE_TEST_RESP) then
   begin
     if OutListview = nil then exit;

     if OutListview.Items.Count > 100 then
     begin
       OutListview.Items.BeginUpdate;
       TOutcmppPacket(OutListview.Items[OutListview.Items.Count - 1].Data).Free;
       OutListview.Items[OutListview.Items.Count - 1].Data := nil;
       OutListview.Items.Delete(OutListview.Items.Count - 1);
       OutListview.Items.EndUpdate;
     end;

     if OutListview.Items.Count > 0 then
     begin
       li := OutListview.Items.Insert(0);
     end
     else
     begin
       li := OutListview.Items.Add;
     end;

     li.SubItems.Add(inttostr(pac.MsgHead.Sequence_ID));
     li.SubItems.Add(FormatDatetime('yyyy-mm-dd hh:nn:ss', now()));

     p := TOutcmppPacket.Create(pac);
     li.Data := p;

     case pac.MsgHead.Command_ID of
       CMPP_CONNECT:
         begin
           li.Caption := '��¼';
         end;

       CMPP_CONNECT_RESP:
         begin
           li.Caption := '��¼Ӧ��';
         end;

       CMPP_DELIVER:
         begin
           if pac.MsgBody.CMPP_DELIVER.Registered_Delivery = 0 then
             li.Caption := '����'
           else li.Caption := '����';
         end;

       CMPP_DELIVER_RESP:
         begin
           if pac.MsgBody.CMPP_DELIVER_RESP.Msg_Id = 0 then
             li.Caption := '����Ӧ��'
           else li.Caption := '����Ӧ��';
         end;

       CMPP_SUBMIT:
         begin
           li.Caption := '����';
         end;

       CMPP_SUBMIT_RESP:
         begin
           li.Caption := '����Ӧ��';
         end;
     end;
   end;     }
end;

procedure TMonitorThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

{ TOutPacket }
constructor TOutPacket.Create(p: TSMGP13_PACKET);
begin
  pac := p;
end;

destructor TOutPacket.destroy;
begin
  inherited;
end;

{ TOutcmppPacket }
constructor TOutcmppPacket.Create(p: TCMPP20_PACKET);
begin
  pac := p;
end;

destructor TOutcmppPacket.destroy;
begin
  inherited;
end;

{ TOutSgipPacket }
constructor TOutSgipPacket.Create(p: TSGIP12_PACKET);
begin
  pac := p;
end;

destructor TOutSgipPacket.destroy;
begin
  inherited;
end;

procedure TMainForm.ShowToMemo(s: string; m: TMemo);
begin
  if m <> nil then
  begin
    m.Lines.Add('[' + FormatDatetime('yyyy-mm-dd hh:nn:ss', now) + ']' + s);
  end;
end;

procedure TMainForm.SMGPTCPClientConnected(Sender: TObject);
begin
  try
    ShowToMemo('�ⲿ����SMGP������', MonitorMemo);
    if MtSendThread <> nil then
    begin
      MtSendThread.Terminate;
      MtSendThread := nil;
    end;

    if OutReadThread <> nil then
    begin
      OutReadThread.Terminate;
      OutReadThread := nil;
    end;

    OutReadThread := TOutReadSMGPThreadObj.Create(True);
    OutReadThread.FTCPClient := SMGPTCPClient;
    OutReadThread.Resume;

    MtSendThread := TMtSendSMGPThreadObj.Create(True);
    MtSendThread.Resume;
  except

  end;
end;

//SMGP  С��ͨ ����
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{SMGP  TMtSendSmgpThreadObj }
procedure TMtSendSMGPThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

constructor TMtSendSMGPThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  LastActiveTime := now;
end;

destructor TMtSendSMGPThreadObj.destroy;
begin
  LastActiveTime := 0;
  inherited;
end;

procedure TMtSendSMGPThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        MtPrc;
      except
        on e: exception do
        begin
          AddMsgToMemo('MT��Ϣ�����߳�:' + e.Message);
        end;
      end;
    finally
      LastActiveTime := now;
      //������Ҫ����������
      sleep(1000 div GGATECONFIG.Flux);
    end;
  end;
end;

procedure TMtSendSMGPThreadObj.MtPrc;
begin
  if OutReadThread <> nil then
  begin
    OutReadThread.PrcMt;
  end;
end;

procedure TMtSendSMGPThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

{SMGP TOutReadSmgpThreadObj }
procedure TOutReadSMGPThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

procedure TOutReadSMGPThreadObj.ClientRead;
begin
  try
    try
      FTCPClient.CheckForGracefulDisconnect();
    except
      on e: exception do
      begin
        AddMsgToMemo('TOutReadSmgpThreadObj' + e.Message);
        sleep(1000);
      end;
    end;

    if FTCPClient.Connected then
    begin
      if FRecBuffer.BufferSize = 0 then
      begin
        //��ʼ���ṹ�壬�����ֱ����������ݰ��ͱ������ݰ�
        ZeroMemory(@FlocPacketIn, sizeof(TSMGP13_PACKET));
        ZeroMemory(@FnetPacketIn, sizeof(TSMGP13_PACKET));

        //����������ȡ���ݰ�ͷ
        FTCPClient.ReadBuffer(FRecBuffer.Buffer, sizeof(TSMGP13_HEAD));
        FRecBuffer.BufferSize := sizeof(TSMGP13_HEAD);

        //�������İ�ͷ���ݸ��Ƶ�����ṹ����
        Move(FRecBuffer.Buffer, FnetPacketIn.MsgHead, sizeof(TSMGP13_HEAD));
        //�������ֽ���ת���󣬽�����ṹ���ͷ���Ƶ����ؽṹ����
        FlocPacketIn.MsgHead.PacketLength := ntohl(FnetPacketIn.MsgHead.PacketLength);
        FlocPacketIn.MsgHead.RequestID := ntohl(FnetPacketIn.MsgHead.RequestID);
        FlocPacketIn.MsgHead.SequenceID := ntohl(FnetPacketIn.MsgHead.SequenceID);
      end;

      case FlocPacketIn.MsgHead.RequestID of
        SMGP13_LOGIN_RESP:
          begin
            //��¼Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPClient.ReadBuffer(FRecBuffer.Buffer[FRecBuffer.BufferSize], sizeof(TSMGP13_LOGIN_RESP));
            FRecBuffer.BufferSize := FRecBuffer.BufferSize + sizeof(TSMGP13_LOGIN_RESP);
            Move(FRecBuffer.Buffer, FnetPacketIn, FRecBuffer.BufferSize);
            FlocPacketIn.MsgBody.LOGIN_RESP := FnetPacketIn.MsgBody.LOGIN_RESP;
            FlocPacketIn.MsgBody.LOGIN_RESP.Status := ntohl(FnetPacketIn.MsgBody.LOGIN_RESP.Status);
          end;

        SMGP13_SUBMIT_RESP:
          begin
            //����Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPClient.ReadBuffer(FRecBuffer.Buffer[FRecBuffer.BufferSize], sizeof(TSMGP13_SUBMIT_RESP));
            FRecBuffer.BufferSize := FRecBuffer.BufferSize + sizeof(TSMGP13_SUBMIT_RESP);
            Move(FRecBuffer.Buffer, FnetPacketIn, FRecBuffer.BufferSize);
            FlocPacketIn.MsgBody.SUBMIT_RESP := FnetPacketIn.MsgBody.SUBMIT_RESP;
            FlocPacketIn.MsgBody.SUBMIT_RESP.Status := ntohl(FnetPacketIn.MsgBody.SUBMIT_RESP.Status);
          end;

        SMGP13_DELIVER:
          begin
            FTCPClient.ReadBuffer(FRecBuffer.Buffer[FRecBuffer.BufferSize], FlocPacketIn.MsgHead.PacketLength - FRecBuffer.BufferSize);
            FRecBuffer.BufferSize := FlocPacketIn.MsgHead.PacketLength;
            Move(FRecBuffer.Buffer, FnetPacketIn, FRecBuffer.BufferSize);
            FnetPacketIn.MsgBody.DELIVER.MsgLength := FlocPacketIn.MsgHead.PacketLength - sizeof(TSMGP13_HEAD) - 77;
            FlocPacketIn.MsgBody.DELIVER := FnetPacketIn.MsgBody.DELIVER;

            ZeroMemory(@FlocPacketIn.MsgBody.DELIVER.MsgContent, sizeof(FlocPacketIn.MsgBody.DELIVER.MsgContent));
            ZeroMemory(@FlocPacketIn.MsgBody.DELIVER.Reserve, sizeof(FlocPacketIn.MsgBody.DELIVER.Reserve));

            Move(FnetPacketIn.MsgBody.DELIVER.MsgContent, FlocPacketIn.MsgBody.DELIVER.MsgContent, FlocPacketIn.MsgBody.DELIVER.MsgLength);
            Move(FnetPacketIn.MsgBody.DELIVER.MsgContent[FlocPacketIn.MsgBody.DELIVER.MsgLength], FlocPacketIn.MsgBody.DELIVER.Reserve, sizeof(FlocPacketIn.MsgBody.DELIVER.Reserve));

            FnetPacketIn.MsgBody := FlocPacketIn.MsgBody;
          end;

        SMGP13_ACTIVE_TEST:
          begin
          end;

        SMGP13_ACTIVE_TEST_RESP:
          begin
          end;
      else
        begin
          FTCPClient.Disconnect;
        end;
      end;

      if MainForm.OutMonitor.Checked then
      begin
        MonitorThread.OutMonitorBuffer.Add(FlocPacketIn);
      end;

      case FlocPacketIn.MsgHead.RequestID of
        SMGP13_LOGIN_RESP:
          begin
            if FlocPacketIn.MsgBody.LOGIN_RESP.Status = 0 then
            begin
              FLogined := True;
              AddMsgToMemo('SMGP�ⲿ���ص�¼�ɹ�');
            end
            else
            begin
              FLogined := false;
              AddMsgToMemo('SMGP�ⲿ���ص�¼ʧ��');
            end;
          end;

        SMGP13_SUBMIT_RESP:
          begin
            mtbuffer.UpdateResp(FlocPacketIn.MsgHead.SequenceID, FlocPacketIn.MsgBody.SUBMIT_RESP.MsgID, FlocPacketIn.MsgBody.SUBMIT_RESP.Status);
            inc(FMtRespCount);
            WindowSize := WindowSize - 1;
            if WindowSize < 0 then WindowSize := 0;
          end;

        SMGP13_DELIVER: //mo���й�����д�뻺��
          begin
            //д�뻺�壬����״̬����
            if FlocPacketIn.MsgBody.DELIVER.IsReport = 1 then
            begin
              //״̬����,д��״̬���滺����
              rptbuffer.Add(FlocPacketIn);
              inc(FRptCount);
            end
            else
            begin
              //MO,��Moд��Mo������
              mobuffer.Add(FlocPacketIn);
              inc(FMoCount);
            end;
            //Ӧ��
            SendPacket(CreateRespPacket(FlocPacketIn));
          end;

        SMGP13_ACTIVE_TEST:
          begin
            WindowSize := 0;
            SendPacket(CreateRespPacket(FlocPacketIn));
          end;

        SMGP13_ACTIVE_TEST_RESP:
          begin
            WindowSize := 0;
          end;
      end;

      FRecBuffer.BufferSize := 0;
      ZeroMemory(@FRecBuffer.Buffer, sizeof(FRecBuffer.Buffer));
    end;
  except
    on e: exception do
    begin
      AddMsgToMemo('SMGP�ⲿ���ؽ����߳�:' + e.Message);
      sleep(1000);
      FTCPClient.Disconnect;
    end;
  end;
end;

constructor TOutReadSMGPThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  ZeroMemory(@FRecBuffer.Buffer, sizeof(FRecBuffer.Buffer));
  FRecBuffer.BufferSize := 0;
  ZeroMemory(@FlocPacketIn, sizeof(TSMGP13_PACKET));
  ZeroMemory(@FnetPacketIn, sizeof(TSMGP13_PACKET));
  FLogined := false;
  FMoCount := 0;
  FMtCount := 0;
  FRptCount := 0;
  FMtRespCount := 0;
  FMtRefuseCount := 0;
  Seqid := 1;
  WindowSize := 0;
  FLastActiveTime := now;
  MtHasUnsendMessage := false;
  MtMessage := '';
  MtNumber := '';
  MtUnsend := 100;
end;

function TOutReadSMGPThreadObj.CreatePacket(
  const RequestID: Cardinal): TSMGP13_PACKET;
var
  pac: TSMGP13_PACKET;
  Time: string;
  strTemp: string;
  tempArray: array[0..255] of char;
  tempbArray: array[0..255] of byte;
  md5: TMD5;
begin
  ZeroMemory(@pac, sizeof(TSMGP13_PACKET));
  pac.MsgHead.RequestID := RequestID;

  case RequestID of
    SMGP13_LOGIN:
      begin
        pac.MsgHead.PacketLength := sizeof(TSMGP13_HEAD) + sizeof(TSMGP13_LOGIN);
        pac.MsgHead.SequenceID := GetSeqid;

        with pac.MsgBody.LOGIN do
        begin
          SetPchar(ClientID, GGATECONFIG.ClientID, sizeof(ClientID));
          LoginMode := 2;
          Time := FormatDatetime('MMDDHHNNSS', now);
          TimeStamp := strtoint(Time);
          Version := SMGP13_VERSION;

          strTemp := GGATECONFIG.ClientID + #0#0#0#0#0#0#0 + GGATECONFIG.ClientSecret + Time;
          SetPchar(tempArray, strTemp, sizeof(tempArray));
          Move(tempArray, tempbArray, sizeof(tempbArray));

          md5 := TMD5.Create(nil);
          try
            md5.InputType := SourceByteArray;
            md5.InputLength := 17 + length(GGATECONFIG.ClientID) + length(GGATECONFIG.ClientSecret);
            md5.pInputArray := @tempbArray;
            md5.pOutputArray := @AuthenticatorClient;
            md5.MD5_Hash;
          finally
            md5.Free;
          end;
        end;
      end;

    SMGP13_SUBMIT:
      begin
        pac.MsgBody.SUBMIT.NeedReport := 1;
        pac.MsgBody.SUBMIT.Priority := 0;
        pac.MsgBody.SUBMIT.DestTermIDCount := 1;
      end;

    SMGP13_ACTIVE_TEST:
      begin
        pac.MsgHead.PacketLength := sizeof(TSMGP13_HEAD);
        pac.MsgHead.SequenceID := GetSeqid;
      end;
  end;
  result := pac;
end;

function TOutReadSMGPThreadObj.CreateRespPacket(
  const recpac: TSMGP13_PACKET): TSMGP13_PACKET;
var
  pac: TSMGP13_PACKET;
begin
  ZeroMemory(@pac, sizeof(TSMGP13_PACKET));

  case recpac.MsgHead.RequestID of
    SMGP13_DELIVER:
      begin
        pac.MsgHead.RequestID := SMGP13_DELIVER_RESP;
        pac.MsgHead.PacketLength := sizeof(TSMGP13_HEAD) + sizeof(TSMGP13_DELIVER_RESP);
        pac.MsgHead.SequenceID := recpac.MsgHead.SequenceID;
        Move(recpac.MsgBody.DELIVER_RESP.MsgID, pac.MsgBody.DELIVER_RESP.MsgID, sizeof(pac.MsgBody.DELIVER_RESP.MsgID));
        pac.MsgBody.DELIVER_RESP.Status := 0;
      end;

    SMGP13_ACTIVE_TEST:
      begin
        pac.MsgHead.PacketLength := sizeof(TSMGP13_HEAD);
        pac.MsgHead.RequestID := SMGP13_ACTIVE_TEST_RESP;
        pac.MsgHead.SequenceID := recpac.MsgHead.SequenceID;
      end;
  end;
  result := pac;
end;

destructor TOutReadSMGPThreadObj.destroy;
begin
  FTCPClient := nil;
  inherited;
end;

procedure TOutReadSMGPThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      ClientRead;
      FLastActiveTime := now(); //������ʱ������ڳ���2���ӣ����ͻ���԰�
    finally
      sleep(0);
    end;
  end;
end;

function TOutReadSMGPThreadObj.GetSeqid: Cardinal;
begin
  result := Seqid;
  inc(Seqid);
  if Seqid >= 4294967295 then
  begin
    Seqid := 1;
  end;
end;

// ʵ�ʵķ�����Ϣ���ն˵Ĵ������
procedure TOutReadSMGPThreadObj.PrcMt;
var
  MtSeqId: integer;
begin
  if FTCPClient.Connected then
  begin
    if FLogined then
    begin
      if now - FLastActiveTime > 30 / 3600 / 24 then
      begin
        if now - FLastActiveTime > 90 / 3600 / 24 then
        begin
          FTCPClient.Disconnect;
        end
        else
        begin
          if now - LastSendActiveTime > 10 / 3600 / 24 then
          begin
            //���ͻ���԰�
            SendPacket(CreatePacket(SMGP13_ACTIVE_TEST));
            //��������ͻ���԰�ʱ��
            LastSendActiveTime := now();
          end;
        end;
      end
      else
      begin
        // ������Ϣ(1)
        MtSeqId := mtbuffer.Get;
        if MtSeqId > 0 then
        begin
          SendMt(MtSeqId);
        end;
      end;
    end
    else
    begin
      if now - LastLoginTime > 6 / 3600 / 24 then
      begin
        SendPacket(CreatePacket(SMGP13_LOGIN));
        LastLoginTime := now;
      end;
    end;
  end;
end;
// ���ⷢ�ͺ���
procedure TOutReadSMGPThreadObj.SendMt(i: integer);
var
  Buffer: TMtBuffer;
  outpac: TSMGP13_PACKET;
begin
  Buffer := mtbuffer.Read(i);
  outpac := CreatePacket(SMGP13_SUBMIT);
  outpac.MsgHead.SequenceID := i;
  outpac.MsgBody.SUBMIT.MsgType := Buffer.OutMsgType;
  Move(Buffer.OutServiceID, outpac.MsgBody.SUBMIT.ServiceID, sizeof(Buffer.OutServiceID));
  Move(Buffer.OutFeeType, outpac.MsgBody.SUBMIT.FeeType, sizeof(Buffer.OutFeeType));
  Move(Buffer.OutFixedFee, outpac.MsgBody.SUBMIT.FixedFee, sizeof(Buffer.OutFixedFee));
  Move(Buffer.OutFeeCode, outpac.MsgBody.SUBMIT.FeeCode, sizeof(Buffer.OutFeeCode));
  outpac.MsgBody.SUBMIT.MsgFormat := Buffer.Mt.MtMsgFmt;
  Move(Buffer.Mt.MtValidTime, outpac.MsgBody.SUBMIT.ValidTime, sizeof(Buffer.Mt.MtValidTime));
  Move(Buffer.Mt.MtAtTime, outpac.MsgBody.SUBMIT.AtTime, sizeof(Buffer.Mt.MtAtTime));
  Move(Buffer.Mt.MtSpAddr, outpac.MsgBody.SUBMIT.SrcTermID, sizeof(TSMGP13PhoneNum));
  Move(Buffer.Mt.MtFeeAddr, outpac.MsgBody.SUBMIT.ChargeTermID, sizeof(TSMGP13PhoneNum));
  Move(Buffer.Mt.MtUserAddr, outpac.MsgBody.SUBMIT.DestTermID, sizeof(TSMGP13PhoneNum));
  outpac.MsgBody.SUBMIT.MsgLength := Buffer.Mt.MtMsgLenth;
  Move(Buffer.Mt.MtMsgContent, outpac.MsgBody.SUBMIT.MsgContent, Buffer.Mt.MtMsgLenth);
  outpac.MsgHead.PacketLength := sizeof(TSMGP13_HEAD) + sizeof(TSMGP13_SUBMIT) - sizeof(outpac.MsgBody.SUBMIT.MsgContent) + Buffer.Mt.MtMsgLenth;
  SendPacket(outpac);
end;

procedure TOutReadSMGPThreadObj.SendPacket(pac: TSMGP13_PACKET);
var
  sendbuffer: TCOMMBuffer;
  NetPacOut, LocPacOut: TSMGP13_PACKET;
begin
  //��ʼ������
  ZeroMemory(@sendbuffer, sizeof(TCOMMBuffer));
  sendbuffer.BufferSize := 0;
  NetPacOut := pac;
  LocPacOut := pac;

  //��ͷ���֣����������ֽ���ת��
  //htonl����32λ�����ַ�˳��ת���������ַ�˳��.
  NetPacOut.MsgHead.PacketLength := htonl(LocPacOut.MsgHead.PacketLength);
  NetPacOut.MsgHead.RequestID := htonl(LocPacOut.MsgHead.RequestID);
  NetPacOut.MsgHead.SequenceID := htonl(LocPacOut.MsgHead.SequenceID);

  //����ͷ���Ƶ����ͻ�����
  //move�����������ǽ����������е�Ԫ�شӺ��濪ʼ������������ѭ��������n����
  Move(NetPacOut.MsgHead, sendbuffer.Buffer, sizeof(TSMGP13_HEAD));
  sendbuffer.BufferSize := sizeof(TSMGP13_HEAD);

  case pac.MsgHead.RequestID of
    SMGP13_LOGIN:
      begin
        NetPacOut.MsgBody.LOGIN.TimeStamp := htonl(LocPacOut.MsgBody.LOGIN.TimeStamp);
        Move(NetPacOut.MsgBody.LOGIN, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TSMGP13_LOGIN));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TSMGP13_LOGIN);
      end;

    SMGP13_SUBMIT:
      begin
        Move(NetPacOut.MsgBody.SUBMIT, sendbuffer.Buffer[sendbuffer.BufferSize], 127);
        sendbuffer.BufferSize := sendbuffer.BufferSize + 127;
        Move(NetPacOut.MsgBody.SUBMIT.MsgContent, sendbuffer.Buffer[sendbuffer.BufferSize], NetPacOut.MsgBody.SUBMIT.MsgLength);
        sendbuffer.BufferSize := sendbuffer.BufferSize + NetPacOut.MsgBody.SUBMIT.MsgLength;
        Move(NetPacOut.MsgBody.SUBMIT.Reserve, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(NetPacOut.MsgBody.SUBMIT.Reserve));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(NetPacOut.MsgBody.SUBMIT.Reserve);
      end;

    SMGP13_DELIVER_RESP:
      begin
        NetPacOut.MsgBody.DELIVER_RESP.Status := htonl(LocPacOut.MsgBody.DELIVER_RESP.Status);
        Move(NetPacOut.MsgBody.DELIVER_RESP, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TSMGP13_DELIVER_RESP));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TSMGP13_DELIVER_RESP);
      end;

    SMGP13_ACTIVE_TEST:
      begin

      end;

    SMGP13_ACTIVE_TEST_RESP:
      begin

      end;
  end;

  if sendbuffer.BufferSize = LocPacOut.MsgHead.PacketLength then
  begin
    if LocPacOut.MsgHead.RequestID = SMGP13_SUBMIT then
    begin
      inc(WindowSize);
      mtbuffer.Update(LocPacOut.MsgHead.SequenceID);
      inc(FMtCount);
    end;

    if MainForm.OutMonitor.Checked then
    begin
      MonitorThread.OutMonitorBuffer.Add(LocPacOut);
    end;

    try
      FTCPClient.WriteBuffer(sendbuffer.Buffer, sendbuffer.BufferSize);
    except
      on e: exception do
      begin
        AddMsgToMemo('SMGP�ⲿ���ط����߳�' + e.Message);
        FTCPClient.Disconnect;
      end;
    end;
  end;
end;

procedure TOutReadSMGPThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;
//SMGP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//CMPP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{CMPP0 �ƶ� 7890  TMtSendCMPPThreadObj}
procedure TMtSendCMPPThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

constructor TMtSendCMPPThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  LastActiveTime := now;
end;

destructor TMtSendCMPPThreadObj.destroy;
begin
  LastActiveTime := 0;
  inherited;
end;

procedure TMtSendCMPPThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        MtPrc;
      except
        on e: exception do
        begin
          AddMsgToMemo('MTCMPP��Ϣ�����߳�:' + e.Message);
        end;
      end;
    finally
      LastActiveTime := now;
      //������Ҫ����������
      sleep(1000 div GGATECONFIG.Flux);
    end;
  end;
end;

procedure TMtSendCMPPThreadObj.MtPrc;
begin
  if OutReadCMPPThread <> nil then
  begin
    OutReadCMPPThread.PrcMt;
  end;
end;

procedure TMtSendCMPPThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

{CMPP0 �ƶ� 7890  TOutReadCMPPThreadObj}
procedure TOutReadCMPPThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

procedure TOutReadCMPPThreadObj.ClientRead;
begin
  //CMPP ��ȡ��CMPP����
  try
    try
      FTCPCmppClient.CheckForGracefulDisconnect();
    except
      on e: exception do
      begin
        AddMsgToMemo('TOutReadCmppThreadObj' + e.Message);
        sleep(1000);
      end;
    end;

    if FTCPCmppClient.Connected then
    begin
      if FRecCmppBuffer.BufferSize = 0 then
      begin
        //��ʼ���ṹ�壬�����ֱ����������ݰ��ͱ������ݰ�
        ZeroMemory(@FlocCmppPacketIn, sizeof(TCMPP20_PACKET));
        ZeroMemory(@FnetCmppPacketIn, sizeof(TCMPP20_PACKET));
        //����������ȡ���ݰ�ͷ
        FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer, sizeof(TCMPP_HEAD));
        FRecCmppBuffer.BufferSize := sizeof(TCMPP_HEAD);
        //�������İ�ͷ���ݸ��Ƶ�����ṹ����
        Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn.MsgHead, sizeof(TCMPP_HEAD));
        //�������ֽ���ת���󣬽�����ṹ���ͷ���Ƶ����ؽṹ����
        FlocCmppPacketIn.MsgHead.Total_Length := ntohl(FnetCmppPacketIn.MsgHead.Total_Length);
        FlocCmppPacketIn.MsgHead.Command_ID := ntohl(FnetCmppPacketIn.MsgHead.Command_ID);
        FlocCmppPacketIn.MsgHead.Sequence_ID := ntohl(FnetCmppPacketIn.MsgHead.Sequence_ID);
      end;

      case FlocCmppPacketIn.MsgHead.Command_ID of
        CMPP_CONNECT_RESP:
          begin
            //��¼Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer[FRecCmppBuffer.BufferSize], sizeof(TCMPP_CONNECT_RESP));
            FRecCmppBuffer.BufferSize := FRecCmppBuffer.BufferSize + sizeof(TCMPP_CONNECT_RESP);
            Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn, FRecCmppBuffer.BufferSize);
            FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP := FnetCmppPacketIn.MsgBody.CMPP_CONNECT_RESP;
            FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status := ntohl(FnetCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status);
          end;

        CMPP_SUBMIT_RESP:
          begin
            //����Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer[FRecCmppBuffer.BufferSize], sizeof(TCMPP_SUBMIT_RESP));
            FRecCmppBuffer.BufferSize := FRecCmppBuffer.BufferSize + sizeof(TCMPP_SUBMIT_RESP);
            Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn, FRecCmppBuffer.BufferSize);
            FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP := FnetCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP;
            FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.result := ntohl(FnetCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.result);
          end;

        CMPP_DELIVER:
          begin
            FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer[FRecCmppBuffer.BufferSize], FlocCmppPacketIn.MsgHead.Total_Length - FRecCmppBuffer.BufferSize);
            FRecCmppBuffer.BufferSize := FlocCmppPacketIn.MsgHead.Total_Length;
            Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn, FRecCmppBuffer.BufferSize);
            FnetCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH := FlocCmppPacketIn.MsgHead.Total_Length - sizeof(TCMPP_HEAD) - 77;
            FlocCmppPacketIn.MsgBody.CMPP_DELIVER := FnetCmppPacketIn.MsgBody.CMPP_DELIVER;
            ZeroMemory(@FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, sizeof(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content));
            ZeroMemory(@FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved, sizeof(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved));
            Move(FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH);
            Move(FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content[FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH], FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved, sizeof(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved));
            FnetCmppPacketIn.MsgBody := FlocCmppPacketIn.MsgBody;
          end;

        CMPP_ACTIVE_TEST:
          begin
            //AddMsgToMemo('CMPP�ⲿ���ػ����Ҫ��');
          end;

        CMPP_ACTIVE_TEST_RESP:
          begin
            //AddMsgToMemo('CMPP�ⲿ���ػ���Իظ�');
          end;
        CMPP_TERMINATE:
          begin
            AddMsgToMemo('CMPP�ⲿ����Ҫ����ֹ����');
          end;
        CMPP_TERMINATE_RESP:
          begin
            AddMsgToMemo('CMPP�ⲿ����Ҫ����ֹ����Ӧ��');
          end;

      else
        begin
          FTCPCmppClient.Disconnect;
        end;
      end;

      if MainForm.OutMonitor.Checked then
      begin
        //��ʱȡ����� 2005/11/12
        MonitorThread.OutMonitorcmppBuffer.Add(FlocCmppPacketIn);
      end;

      case FlocCmppPacketIn.MsgHead.Command_ID of
        CMPP_CONNECT_RESP:
          begin
            if (FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status = 0) and (FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Version <> 0) then
            begin
              FLogined := True;
              AddMsgToMemo('CMPP�ⲿ���ض˿ڵ�¼�ɹ�');
            end
            else
            begin
              FLogined := false;
              AddMsgToMemo('CMPP�ⲿ���ص�¼ʧ��');
            end;
          end;

        CMPP_SUBMIT_RESP:
          begin
            if FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.Msg_Id = 0 then
            begin
              AddMsgToMemo('NO');
            end else
            begin
              AddMsgToMemo('YES');
            end;
            mtcmppbuffer.UpdateResp(FlocCmppPacketIn.MsgHead.Command_ID, FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.Msg_Id, FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.result);
            inc(FMtRespCount);
            WindowSize := WindowSize - 1;
            if WindowSize < 0 then WindowSize := 0;
          end;

        CMPP_DELIVER: //mo���й�����д�뻺��
          begin
            //д�뻺�壬����״̬����
            if FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Registered_Delivery = 1 then
            begin
              //״̬����,д��״̬���滺����
              rptcmppbuffer.Add(FlocCmppPacketIn);
              inc(FRptCount);
            end
            else
            begin
              //MO,��Moд��Mo������
              mocmppbuffer.Add(FlocCmppPacketIn);
              inc(FMoCount);
            end;

            //Ӧ��
            SendPacket(CreateRespPacket(FlocCmppPacketIn));
          end;

        CMPP_ACTIVE_TEST:
          begin
            WindowSize := 0;
            SendPacket(CreateRespPacket(FlocCmppPacketIn));
            LastSendActiveTime := now();
          end;

        CMPP_ACTIVE_TEST_RESP:
          begin
            WindowSize := 0;
            LastSendActiveTime := now();
          end;
      end;

      FRecCmppBuffer.BufferSize := 0;
      ZeroMemory(@FRecCmppBuffer.Buffer, sizeof(FRecCmppBuffer.Buffer));
    end;
  except
    on e: exception do
    begin
      AddMsgToMemo('CMPP�ⲿ���ؽ����߳�:' + e.Message);
      sleep(1000);
      FTCPCmppClient.Disconnect;
    end;
  end;

end;

constructor TOutReadCMPPThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  ZeroMemory(@FRecCmppBuffer.Buffer, sizeof(FRecCmppBuffer.Buffer));
  FRecCmppBuffer.BufferSize := 0;
  ZeroMemory(@FlocCmppPacketIn, sizeof(TCMPP20_PACKET));
  ZeroMemory(@FnetCmppPacketIn, sizeof(TCMPP20_PACKET));
  FLogined := false;
  FMoCount := 0;
  FMtCount := 0;
  FRptCount := 0;
  FMtRespCount := 0;
  FMtRefuseCount := 0;
  Seqid := 1;
  WindowSize := 0;
  FLastActiveTime := now;
  MtHasUnsendMessage := false;
  MtMessage := '';
  MtNumber := '';
  MtUnsend := 100;
  log_port := 0;
end;

function TOutReadCMPPThreadObj.CreatePacket(
  const RequestID: Cardinal): TCMPP20_PACKET;
var
  pac: TCMPP20_PACKET;
  Time: string;
  strTemp: string;
  tempArray: array[0..255] of char;
  tempbArray: array[0..255] of byte;
  md5: TMD5;
  md5str: md5digest;
  md5_con: MD5Context;
  Md5UpLen, i: integer; //MD5Update Length;
  str1: array[0..31] of char;
begin
  ZeroMemory(@pac, sizeof(TCMPP20_PACKET));
  pac.MsgHead.Command_ID := RequestID;

  case RequestID of
    CMPP_CONNECT:
      begin
        //01200 �˿ڵ�½ 1�˿ڵ�½
        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD) + sizeof(TCMPP_CONNECT);
        pac.MsgHead.Sequence_ID := GetSeqid;
        with pac.MsgBody.CMPP_CONNECT do
        begin
          SetPchar(Source_Addr, GGATECONFIG.cmppClientID, sizeof(Source_Addr));
          DateTimeToString(Time, 'MMDDHHMMSS', now);
          Version := CMPP_VERSION;
          strTemp := GGATECONFIG.cmppClientID + '000000000' + GGATECONFIG.cmppClientSecret + Time;
          StrPCopy(str1, strTemp);
          for i := length(GGATECONFIG.cmppClientID) to (length(GGATECONFIG.cmppClientID) + 8) do
            str1[i] := #0;
          Md5UpLen := length(GGATECONFIG.cmppClientID) + 9 + length(GGATECONFIG.cmppClientSecret) + 10;
          MD5Init(md5_con);
          MD5Update(md5_con, str1, Md5UpLen);
          MD5Final(md5_con, md5str);
          Move(md5str, AuthenticatorSource, 16);
          TimeStamp := strtoint(Time);
        end;
      end;

    CMPP_SUBMIT:
      begin
        pac.MsgBody.CMPP_SUBMIT.Registered_Delivery := 1;
        pac.MsgBody.CMPP_SUBMIT.Msg_level := 0;
        pac.MsgBody.CMPP_SUBMIT.DestUsr_tl := 1;
      end;

    CMPP_ACTIVE_TEST:
      begin
        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD);
        pac.MsgHead.Sequence_ID := GetSeqid;
      end;
  end;

  result := pac;
end;

function TOutReadCMPPThreadObj.CreateRespPacket(
  const recpac: TCMPP20_PACKET): TCMPP20_PACKET;
var
  pac: TCMPP20_PACKET;
begin
  ZeroMemory(@pac, sizeof(TCMPP20_PACKET));
  case recpac.MsgHead.Command_ID of
    CMPP_DELIVER:
      begin
        pac.MsgHead.Command_ID := CMPP_DELIVER_RESP;

        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD) + sizeof(TCMPP_DELIVER_RESP);
        pac.MsgHead.Sequence_ID := recpac.MsgHead.Sequence_ID;
        Move(recpac.MsgBody.CMPP_DELIVER_RESP.Msg_Id, pac.MsgBody.CMPP_DELIVER_RESP.Msg_Id, sizeof(pac.MsgBody.CMPP_DELIVER_RESP.Msg_Id));
        pac.MsgBody.CMPP_DELIVER_RESP.result := 0;
      end;

    CMPP_ACTIVE_TEST:
      begin
        pac.MsgHead.Command_ID := CMPP_ACTIVE_TEST_RESP;
        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD) + sizeof(TCMPP_ACTIVE_TEST_RESP);
        pac.MsgHead.Sequence_ID := recpac.MsgHead.Sequence_ID;
        pac.MsgBody.CMPP_ACTIVE_TEST_RESP.Success_Id := 0;
      end;
  end;
  result := pac;
end;

destructor TOutReadCMPPThreadObj.destroy;
begin
  FTCPCmppClient := nil;
  inherited;
end;

procedure TOutReadCMPPThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      ClientRead;
      FLastActiveTime := now(); //������ʱ������ڳ���2���ӣ����ͻ���԰�
    finally
      sleep(0);
    end;
  end;
end;

function TOutReadCMPPThreadObj.GetSeqid: Cardinal;
begin
  result := Seqid;
  inc(Seqid);
  if Seqid >= 4294967295 then
  begin
    //Seqid := 1;
    Seqid := 0;
  end;
end;

// �����½ ���͵�½��Ϣ
procedure TOutReadCMPPThreadObj.PrcMt;
var
  MtSeqId: integer;
begin
  if FTCPCmppClient.Connected then
  begin
    if FLogined then
    begin
      if now - FLastActiveTime > 30 / 3600 / 24 then
      begin
        if now - FLastActiveTime > 90 / 3600 / 24 then
        begin
          FTCPCmppClient.Disconnect;
        end
        else
        begin
          if now - LastSendActiveTime > 10 / 3600 / 24 then
          begin
            //���ͻ���԰�
            SendPacket(CreatePacket(CMPP_ACTIVE_TEST));
            //��������ͻ���԰�ʱ��
            LastSendActiveTime := now();
            //AddMsgToMemo('���Ͳ��԰�');
          end;
        end;
      end
      else
      begin
        // ������Ϣ(1)
        MtSeqId := mtcmppbuffer.Get;
        if MtSeqId > 0 then
        begin
          SendMt(MtSeqId);
        end;
      end;
    end
    else
    begin
      if now - LastLoginTime > 6 / 3600 / 24 then
      begin
        //�ƶ���½����
        //log_port := 1;
        SendPacket(CreatePacket(CMPP_CONNECT));
        LastLoginTime := now;
      end;
    end;
  end;
end;

// ���ⷢ�ͺ���
procedure TOutReadCMPPThreadObj.SendMt(i: integer);
var
  Buffer: TMtBuffer;
  outpac: TCMPP20_PACKET;
begin
  ZeroMemory(@Buffer, sizeof(TMtBuffer));
  // ����Buffer
  Buffer := mtcmppbuffer.Read(i);
  outpac := CreatePacket(CMPP_SUBMIT);
  outpac.MsgHead.Sequence_ID := GetSeqid;
  outpac.MsgBody.CMPP_SUBMIT.Pk_total := 1; //�Ծ�����  pk_total
  outpac.MsgBody.CMPP_SUBMIT.Pk_number := 1; //�Ծ�����  pk_number
  outpac.MsgBody.CMPP_SUBMIT.Msg_Fmt := Buffer.Mt.MtMsgFmt;
  Move(Buffer.Mt.msg_src, outpac.MsgBody.CMPP_SUBMIT.msg_src, sizeof(Buffer.Mt.msg_src));
  Move(Buffer.Mt.OutFeeCode, outpac.MsgBody.CMPP_SUBMIT.FeeCode, sizeof(Buffer.Mt.OutFeeCode));
  Move(Buffer.Mt.OutServiceID, outpac.MsgBody.CMPP_SUBMIT.service_id, sizeof(Buffer.Mt.OutServiceID));
  Move(Buffer.Mt.OutFeeType, outpac.MsgBody.CMPP_SUBMIT.FeeType, sizeof(Buffer.Mt.OutFeeType));
  Move(Buffer.Mt.MtValidTime, outpac.MsgBody.CMPP_SUBMIT.Valid_Time, sizeof(Buffer.Mt.MtValidTime));
  Move(Buffer.Mt.MtAtTime, outpac.MsgBody.CMPP_SUBMIT.At_Time, sizeof(Buffer.Mt.MtAtTime));
  Move(Buffer.Mt.MtSpAddr, outpac.MsgBody.CMPP_SUBMIT.Src_ID, sizeof(TCMPPPhoneNum));
  Move(Buffer.Mt.MtUserAddr, outpac.MsgBody.CMPP_SUBMIT.dest_terminal_id, sizeof(TCMPPPhoneNum));
  outpac.MsgBody.CMPP_SUBMIT.MSG_LENGTH := Buffer.Mt.MtMsgLenth;
  outpac.MsgHead.Total_Length := sizeof(TCMPP_HEAD) + sizeof(TCMPP_SUBMIT) - sizeof(outpac.MsgBody.CMPP_SUBMIT.Msg_Content) + Buffer.Mt.MtMsgLenth;
  Move(Buffer.Mt.MtMsgContent, outpac.MsgBody.CMPP_SUBMIT.Msg_Content, Buffer.Mt.MtMsgLenth);
  SendPacket(outpac);
  mtcmppbuffer.Delete(i);
end;

procedure TOutReadCMPPThreadObj.SendPacket(pac: TCMPP20_PACKET);
var
  sendbuffer: TCOMMBuffer;
  sendbuffer0: TCOMMBuffer;
  NetPacOut, LocPacOut: TCMPP20_PACKET;
  Filestream: Tfilestream;
  i: integer;
begin
  //��ʼ������
  ZeroMemory(@sendbuffer, sizeof(TCOMMBuffer));
  sendbuffer.BufferSize := 0;
  NetPacOut := pac;
  LocPacOut := pac;
  //��ͷ���֣����������ֽ���ת��
  //htonl����32λ�����ַ�˳��ת���������ַ�˳��.
  NetPacOut.MsgHead.Total_Length := htonl(LocPacOut.MsgHead.Total_Length);
  NetPacOut.MsgHead.Command_ID := htonl(LocPacOut.MsgHead.Command_ID);
  NetPacOut.MsgHead.Sequence_ID := htonl(LocPacOut.MsgHead.Sequence_ID);
  //����ͷ���Ƶ����ͻ�����
  //move�����������ǽ����������е�Ԫ�شӺ��濪ʼ������������ѭ��������n����
  Move(NetPacOut.MsgHead, sendbuffer.Buffer, sizeof(TCMPP_HEAD));
  sendbuffer.BufferSize := sizeof(TCMPP_HEAD);

  case pac.MsgHead.Command_ID of
    CMPP_CONNECT:
      begin
        NetPacOut.MsgBody.CMPP_CONNECT.TimeStamp := htonl(LocPacOut.MsgBody.CMPP_CONNECT.TimeStamp);
        Move(NetPacOut.MsgBody.CMPP_CONNECT, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TCMPP_CONNECT));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TCMPP_CONNECT);
      end;

    CMPP_SUBMIT:
      begin
        Move(NetPacOut.MsgBody.CMPP_SUBMIT, sendbuffer.Buffer[sendbuffer.BufferSize], 139);
        sendbuffer.BufferSize := sendbuffer.BufferSize + 139;
        //������ ���͵������ڴ���
        Move(NetPacOut.MsgBody.CMPP_SUBMIT.Msg_Content, sendbuffer.Buffer[sendbuffer.BufferSize], NetPacOut.MsgBody.CMPP_SUBMIT.MSG_LENGTH);
        //����ĳ��� = ����ǰ���ֽ� + ���ݵĳ���
        sendbuffer.BufferSize := sendbuffer.BufferSize + NetPacOut.MsgBody.CMPP_SUBMIT.MSG_LENGTH;
        //�� Reserve��ֵ���� buffersizeȥ
        Move(NetPacOut.MsgBody.CMPP_SUBMIT.Reserve, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(NetPacOut.MsgBody.CMPP_SUBMIT.Reserve));
        //���� reserve�� 8���ֽ�
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(NetPacOut.MsgBody.CMPP_SUBMIT.Reserve);

      end;

    CMPP_DELIVER_RESP:
      begin
        NetPacOut.MsgBody.CMPP_DELIVER_RESP.result := htonl(LocPacOut.MsgBody.CMPP_DELIVER_RESP.result);

        Move(NetPacOut.MsgBody.CMPP_DELIVER_RESP, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TCMPP_SUBMIT_RESP));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TCMPP_SUBMIT_RESP);
      end;

    CMPP_ACTIVE_TEST:
      begin

      end;

    CMPP_ACTIVE_TEST_RESP:
      begin
        NetPacOut.MsgBody.CMPP_ACTIVE_TEST_RESP.Success_Id := htonl(LocPacOut.MsgBody.CMPP_ACTIVE_TEST_RESP.Success_Id);

        Move(NetPacOut.MsgBody.CMPP_ACTIVE_TEST_RESP, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TCMPP_ACTIVE_TEST_RESP));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TCMPP_ACTIVE_TEST_RESP);
      end;
  end;

  if sendbuffer.BufferSize = LocPacOut.MsgHead.Total_Length then
  begin
    if LocPacOut.MsgHead.Command_ID = CMPP_SUBMIT then
    begin
      inc(WindowSize);
      mtcmppbuffer.Update(LocPacOut.MsgHead.Sequence_ID);
      inc(FMtCount);
    end;

    if MainForm.OutMonitor.Checked then
    begin
      //��ʱȥ����ذ� 2005/11/12
      MonitorThread.OutMonitorcmppBuffer.Add(LocPacOut);
    end;

    try
      FTCPCmppClient.WriteBuffer(sendbuffer.Buffer, sendbuffer.BufferSize);
      //AddMsgToMemo('cmpp�ⲿ���ط������');
    except
      on e: exception do
      begin
        AddMsgToMemo('cmpp�ⲿ���ط��ʹ���' + e.Message);
        FTCPCmppClient.Disconnect;
      end;
    end;
  end;
end;

procedure TOutReadCMPPThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

{CMPP0 �ƶ� 7910  TMtSendThreadObj }
procedure TMtSendCMPP0ThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

constructor TMtSendCMPP0ThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  LastActiveTime := now;
end;

destructor TMtSendCMPP0ThreadObj.destroy;
begin
  LastActiveTime := 0;
  inherited;
end;

procedure TMtSendCMPP0ThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        MtPrc;
      except
        on e: exception do
        begin
          AddMsgToMemo('MTCMPP��Ϣ�����߳�:' + e.Message);
        end;
      end;
    finally
      LastActiveTime := now;
      //������Ҫ����������
      sleep(1000 div GGATECONFIG.Flux);
    end;
  end;
end;

procedure TMtSendCMPP0ThreadObj.MtPrc;
begin
  if OutReadCMPP0Thread <> nil then
  begin
    OutReadCMPP0Thread.PrcMt;
  end;
end;

procedure TMtSendCMPP0ThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;


{CMPP0 7910�˿� TOutReadCMPP0ThreadObj}
procedure TOutReadCMPP0ThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

procedure TOutReadCMPP0ThreadObj.ClientRead;
var
  deliver_file: Tfilestream;
  i, i0, i1: integer;
  HEXS, MSG_CON: string;
begin
  //CMPP ��ȡ��CMPP����
  try
    try
      //FTCPCmppClient.CheckForGracefulDisconnect(false);
      FTCPCmppClient.CheckForGracefulDisconnect();
    except
      on e: exception do
      begin
        AddMsgToMemo('TOutReadCMPP0ThreadObj' + e.Message);
        sleep(1000);
      end;
    end;

    if FTCPCmppClient.Connected then
    begin
      if FRecCmppBuffer.BufferSize = 0 then
      begin
        //��ʼ���ṹ�壬�����ֱ����������ݰ��ͱ������ݰ�
        ZeroMemory(@FlocCmppPacketIn, sizeof(TCMPP20_PACKET));
        ZeroMemory(@FnetCmppPacketIn, sizeof(TCMPP20_PACKET));

        //����������ȡ���ݰ�ͷ
        FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer, sizeof(TCMPP_HEAD));
        FRecCmppBuffer.BufferSize := sizeof(TCMPP_HEAD);

        //�������İ�ͷ���ݸ��Ƶ�����ṹ����
        Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn.MsgHead, sizeof(TCMPP_HEAD));
        //�������ֽ���ת���󣬽�����ṹ���ͷ���Ƶ����ؽṹ����
        FlocCmppPacketIn.MsgHead.Total_Length := ntohl(FnetCmppPacketIn.MsgHead.Total_Length);
        FlocCmppPacketIn.MsgHead.Command_ID := ntohl(FnetCmppPacketIn.MsgHead.Command_ID);
        FlocCmppPacketIn.MsgHead.Sequence_ID := ntohl(FnetCmppPacketIn.MsgHead.Sequence_ID);
      end;

      case FlocCmppPacketIn.MsgHead.Command_ID of
        CMPP_CONNECT_RESP:
          begin
            //��¼Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            {FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer[FRecCmppBuffer.BufferSize], sizeof(TCMPP_CONNECT_RESP));
            FRecCmppBuffer.BufferSize := FRecCmppBuffer.BufferSize + sizeof(TCMPP_CONNECT_RESP);
            Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn, FRecCmppBuffer.BufferSize);
            FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP := FnetCmppPacketIn.MsgBody.CMPP_CONNECT_RESP;
            FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status := ntohl(FnetCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status);
            }
            //��¼Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer[FRecCmppBuffer.BufferSize], sizeof(TCMPP_CONNECT_RESP));
            FRecCmppBuffer.BufferSize := FRecCmppBuffer.BufferSize + sizeof(TCMPP_CONNECT_RESP);
            Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn, FRecCmppBuffer.BufferSize);
            FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP := FnetCmppPacketIn.MsgBody.CMPP_CONNECT_RESP;
            FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status := ntohl(FnetCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status);

          end;

        CMPP_SUBMIT_RESP:
          begin
            //����Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer[FRecCmppBuffer.BufferSize], sizeof(TCMPP_SUBMIT_RESP));
            FRecCmppBuffer.BufferSize := FRecCmppBuffer.BufferSize + sizeof(TCMPP_SUBMIT_RESP);
            Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn, FRecCmppBuffer.BufferSize);
            FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP := FnetCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP;
            FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.result := ntohl(FnetCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.result);
          end;

        CMPP_DELIVER:
          begin
            //����������˿� ��ȡ ��ͷԼ�������ݰ����� - ��ͷ�ĳ��ȣ��õ�ʣ��İ��岿��
            //FRecCmppBuffer.Buffer �Ѿ������˰�ͷ���ڴӰ�ͷ���������忪ʼ��λ���ٶ�ȡʣ�ಿ�ֵõ������
            FTCPCmppClient.ReadBuffer(FRecCmppBuffer.Buffer[FRecCmppBuffer.BufferSize], FlocCmppPacketIn.MsgHead.Total_Length - FRecCmppBuffer.BufferSize);
            //�õ������ܳ���
            FRecCmppBuffer.BufferSize := FlocCmppPacketIn.MsgHead.Total_Length;
            //�õ��ܵİ� �ŵ�  FnetCmppPacketIn ���� FnetCmppPacketInΪ�����
            Move(FRecCmppBuffer.Buffer, FnetCmppPacketIn, FRecCmppBuffer.BufferSize);

            FnetCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH := FlocCmppPacketIn.MsgHead.Total_Length - sizeof(TCMPP_HEAD) - 70; //77
            //FnetCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH := FlocCmppPacketIn.MsgHead.Total_Length - sizeof(TCMPP_HEAD) - 77;
            FlocCmppPacketIn.MsgBody.CMPP_DELIVER := FnetCmppPacketIn.MsgBody.CMPP_DELIVER;
            ZeroMemory(@FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, sizeof(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content));
            ZeroMemory(@FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved, sizeof(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved));
            Move(FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH);
            Move(FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content[FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH], FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved, sizeof(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Reserved));
            FnetCmppPacketIn.MsgBody := FlocCmppPacketIn.MsgBody;
            //deliver_file := TFileStream.Create( 'Deliver' + inttostr(FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Id) + '.del', fmCreate );
            //deliver_file.WriteBuffer(  FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content,FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH);
            HEXS := '';
            for i0 := 0 to FnetCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH - 1 do
              HEXS := HEXS + IntToHex(byte(FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content[i0]), 2);
            //MainForm.MOMemo.Lines.Add(HEXS);
            case FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Fmt of
              8:
                begin
                  for i1 := 0 to (length(HEXS) div 4) - 1 do
                  begin
                    //  MSG_CON :=MSG_CON + WChar(StrToInt('$' +  HEXS[i1 * 4 + 1] + HEXS[i1 * 4 + 2]) shl 8
                     //   + StrToInt('$' + HEXS[i1 * 4 + 3] +  HEXS[i1 * 4 + 4]));
                    MSG_CON := MSG_CON + wchar(strtoint('$' + HEXS[i1 * 4 + 1] + HEXS[i1 * 4 + 2]
                      + HEXS[i1 * 4 + 3] + HEXS[i1 * 4 + 4]));
                  end;
                  //MainForm.MOMemo.Lines.Add(MSG_CON);
                  // MSG_CON := Ucs2ToGBK(Buffer.mo.Msg_Fmt, HEXS);
                end;
              0:
                begin
                  MSG_CON := FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content;
                end;
              15:
                begin
                  MSG_CON := FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content;
                end;
              25:
                begin
                  MSG_CON := BIG5TOGB(FnetCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content);
                end;
              //:= htonl(length());
            end;
            //FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH := length(trim(MSG_CON));
            //FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content := MSG_CON;
           // SetPchar(Move(MSG_CON, FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH));
            SetPchar(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content, MSG_CON, FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH);
            //MainForm.MOMemo.Lines.Add(MSG_CON);
            //MainForm.MOMemo.Lines.Add(inttostr(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.MSG_LENGTH));
           // MainForm.MOMemo.Lines.Add(FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Msg_Content);
            //
            //end;
          end;

        CMPP_ACTIVE_TEST:
          begin
            //AddMsgToMemo('CMPP0�ⲿ���ػ����Ҫ��');
          end;

        CMPP_ACTIVE_TEST_RESP:
          begin
            //AddMsgToMemo('CMPP0�ⲿ���ػ���Իظ�');
          end;
        CMPP_TERMINATE:
          begin
            AddMsgToMemo('CMPP0�ⲿ����Ҫ����ֹ����');
          end;
        CMPP_TERMINATE_RESP:
          begin
            AddMsgToMemo('CMPP0�ⲿ����Ҫ����ֹ����Ӧ��');
          end;
      else
        begin
          FTCPCmppClient.Disconnect;
        end;
      end;

      if MainForm.OutMonitor.Checked then
      begin
        //��ʱȡ����� 2005/11/12
        MonitorThread.OutMonitorcmppBuffer.Add(FlocCmppPacketIn);
      end;

      case FlocCmppPacketIn.MsgHead.Command_ID of
        CMPP_CONNECT_RESP:
          begin
            if FlocCmppPacketIn.MsgBody.CMPP_CONNECT_RESP.Status = 0 then
            begin
              FLogined := True;
              AddMsgToMemo('CMPP�ⲿ����0�˿ڵ�¼�ɹ�');
            end
            else
            begin
              FLogined := false;
              AddMsgToMemo('CMPP�ⲿ����0��¼ʧ��');
            end;
          end;

        CMPP_SUBMIT_RESP:
          begin
            mtcmppbuffer.UpdateResp(FlocCmppPacketIn.MsgHead.Command_ID, FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.Msg_Id, FlocCmppPacketIn.MsgBody.CMPP_SUBMIT_RESP.result);
            inc(FMtRespCount);

            WindowSize := WindowSize - 1;
            if WindowSize < 0 then WindowSize := 0;
          end;

        CMPP_DELIVER: //mo���й�����д�뻺��
          begin
            //д�뻺�壬����״̬����
            if FlocCmppPacketIn.MsgBody.CMPP_DELIVER.Registered_Delivery = 1 then
            begin
              //״̬����,д��״̬���滺����
              rptcmppbuffer.Add(FlocCmppPacketIn);
              inc(FRptCount);
            end
            else
            begin
              //MO,��Moд��Mo������
              mocmppbuffer.Add(FlocCmppPacketIn);
              inc(FMoCount);
            end;

            //Ӧ��
            SendPacket(CreateRespPacket(FlocCmppPacketIn));
          end;

        CMPP_ACTIVE_TEST:
          begin
            WindowSize := 0;
            SendPacket(CreateRespPacket(FlocCmppPacketIn));
            //AddMsgToMemo('cmpp�ⲿ����0���ͳ����Ӳ��԰����');
            //2005/11/21
            LastSendActiveTime := now();
          end;

        CMPP_ACTIVE_TEST_RESP:
          begin
            WindowSize := 0;
            //2005/11/21
            LastSendActiveTime := now();
          end;
      end;

      FRecCmppBuffer.BufferSize := 0;
      ZeroMemory(@FRecCmppBuffer.Buffer, sizeof(FRecCmppBuffer.Buffer));
    end;
  except
    on e: exception do
    begin
      AddMsgToMemo('CMPP�ⲿ����0�����߳�:' + e.Message);
      sleep(1000);
      FTCPCmppClient.Disconnect;
    end;
  end;

end;

constructor TOutReadCMPP0ThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  ZeroMemory(@FRecCmppBuffer.Buffer, sizeof(FRecCmppBuffer.Buffer));
  FRecCmppBuffer.BufferSize := 0;

  ZeroMemory(@FlocCmppPacketIn, sizeof(TCMPP20_PACKET));
  ZeroMemory(@FnetCmppPacketIn, sizeof(TCMPP20_PACKET));

  FLogined := false;
  FMoCount := 0;
  FMtCount := 0;
  FRptCount := 0;
  FMtRespCount := 0;
  FMtRefuseCount := 0;
  Seqid := 1;
  WindowSize := 0;
  FLastActiveTime := now;
  MtHasUnsendMessage := false;
  MtMessage := '';
  MtNumber := '';
  MtUnsend := 100;
  log_port := 0;
end;

function TOutReadCMPP0ThreadObj.CreatePacket(
  const RequestID: Cardinal): TCMPP20_PACKET;
var
  //pac: TSMGP13_PACKET;
  pac: TCMPP20_PACKET;
  Time: string;
  strTemp: string;
  tempArray: array[0..255] of char;
  tempbArray: array[0..255] of byte;
  md5: TMD5;
  md5str: md5digest;
  md5_con: MD5Context;
  Md5UpLen, i: integer; //MD5Update Length;
  str1: array[0..31] of char;
begin
  ZeroMemory(@pac, sizeof(TCMPP20_PACKET));
  pac.MsgHead.Command_ID := RequestID;

  case RequestID of
    CMPP_CONNECT:
      begin
        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD) + sizeof(TCMPP_CONNECT);
        pac.MsgHead.Sequence_ID := GetSeqid;
        with pac.MsgBody.CMPP_CONNECT do
        begin
          SetPchar(Source_Addr, GGATECONFIG.cmppClientID, sizeof(Source_Addr));
          DateTimeToString(Time, 'MMDDHHMMSS', now);
          Version := CMPP_VERSION;
          strTemp := GGATECONFIG.cmppClientID + '000000000' + GGATECONFIG.cmppClientSecret + Time;
          StrPCopy(str1, strTemp);
          for i := length(GGATECONFIG.cmppClientID) to (length(GGATECONFIG.cmppClientID) + 8) do
            str1[i] := #0;
          Md5UpLen := length(GGATECONFIG.cmppClientID) + 9 + length(GGATECONFIG.cmppClientSecret) + 10;
          MD5Init(md5_con);
          MD5Update(md5_con, str1, Md5UpLen);
          MD5Final(md5_con, md5str);
          Move(md5str, AuthenticatorSource, 16);
          TimeStamp := strtoint(Time);
        end;

      end;

    CMPP_SUBMIT:
      begin
        pac.MsgBody.CMPP_SUBMIT.Registered_Delivery := 1;
        pac.MsgBody.CMPP_SUBMIT.Msg_level := 0;
        pac.MsgBody.CMPP_SUBMIT.DestUsr_tl := 1;
      end;

    CMPP_ACTIVE_TEST:
      begin
        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD);
        pac.MsgHead.Sequence_ID := GetSeqid;
      end;
  end;

  result := pac;
end;

function TOutReadCMPP0ThreadObj.CreateRespPacket(
  const recpac: TCMPP20_PACKET): TCMPP20_PACKET;
var
  pac: TCMPP20_PACKET;
begin
  ZeroMemory(@pac, sizeof(TCMPP20_PACKET));

  case recpac.MsgHead.Command_ID of
    CMPP_DELIVER:
      begin
        pac.MsgHead.Command_ID := CMPP_DELIVER_RESP;
        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD) + sizeof(TCMPP_DELIVER_RESP);
        pac.MsgHead.Sequence_ID := recpac.MsgHead.Sequence_ID;
        Move(recpac.MsgBody.CMPP_DELIVER_RESP.Msg_Id, pac.MsgBody.CMPP_DELIVER_RESP.Msg_Id, sizeof(pac.MsgBody.CMPP_DELIVER_RESP.Msg_Id));
        pac.MsgBody.CMPP_DELIVER_RESP.result := 0;
      end;

    CMPP_ACTIVE_TEST:
      begin
        {pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD);
        pac.MsgHead.Command_ID := CMPP_ACTIVE_TEST_RESP;
        pac.MsgHead.Sequence_ID := recpac.MsgHead.Sequence_ID;}
        pac.MsgHead.Command_ID := CMPP_ACTIVE_TEST_RESP;
        pac.MsgHead.Total_Length := sizeof(TCMPP_HEAD) + sizeof(TCMPP_ACTIVE_TEST_RESP);
        pac.MsgHead.Sequence_ID := recpac.MsgHead.Sequence_ID;
        pac.MsgBody.CMPP_ACTIVE_TEST_RESP.Success_Id := 0;
      end;
  end;

  result := pac;
end;

destructor TOutReadCMPP0ThreadObj.destroy;
begin
  FTCPCmppClient := nil;
  inherited;
end;

procedure TOutReadCMPP0ThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      ClientRead;
      FLastActiveTime := now(); //������ʱ������ڳ���2���ӣ����ͻ���԰�
    finally
      sleep(0);
    end;
  end;
end;

function TOutReadCMPP0ThreadObj.GetSeqid: Cardinal;
begin
  result := Seqid;
  inc(Seqid);
  if Seqid >= 4294967295 then
  begin
    Seqid := 1;
  end;
end;

// �����½ ���͵�½��Ϣ
procedure TOutReadCMPP0ThreadObj.PrcMt;
var
  MtSeqId: integer;
begin
  if FTCPCmppClient.Connected then
  begin
    if FLogined then
    begin
      if now - FLastActiveTime > 30 / 3600 / 24 then
      begin
        if now - FLastActiveTime > 90 / 3600 / 24 then
        begin
          FTCPCmppClient.Disconnect;
        end
        else
        begin
          if now - LastSendActiveTime > 10 / 3600 / 24 then
          begin
            //���ͻ���԰�
            SendPacket(CreatePacket(CMPP_ACTIVE_TEST));
            //��������ͻ���԰�ʱ��
            LastSendActiveTime := now();
          end;
        end;
      end
      else
      begin

      end;
    end
    else
    begin
      if now - LastLoginTime > 6 / 3600 / 24 then
      begin
        //�ƶ���½����
        SendPacket(CreatePacket(CMPP_CONNECT));
        LastLoginTime := now;
      end;
    end;
  end;
end;

procedure TOutReadCMPP0ThreadObj.SendPacket(pac: TCMPP20_PACKET);
var
  sendbuffer: TCOMMBuffer;
  NetPacOut, LocPacOut: TCMPP20_PACKET;
begin
  //��ʼ������
  ZeroMemory(@sendbuffer, sizeof(TCOMMBuffer));
  sendbuffer.BufferSize := 0;
  NetPacOut := pac;
  LocPacOut := pac;

  //��ͷ���֣����������ֽ���ת��
  //htonl����32λ�����ַ�˳��ת���������ַ�˳��.
  NetPacOut.MsgHead.Total_Length := htonl(LocPacOut.MsgHead.Total_Length);
  NetPacOut.MsgHead.Command_ID := htonl(LocPacOut.MsgHead.Command_ID);
  NetPacOut.MsgHead.Sequence_ID := htonl(LocPacOut.MsgHead.Sequence_ID);

  //����ͷ���Ƶ����ͻ�����
  //move�����������ǽ����������е�Ԫ�شӺ��濪ʼ������������ѭ��������n����
  Move(NetPacOut.MsgHead, sendbuffer.Buffer, sizeof(TCMPP_HEAD));
  sendbuffer.BufferSize := sizeof(TCMPP_HEAD);

  case pac.MsgHead.Command_ID of
    CMPP_CONNECT:
      begin
        NetPacOut.MsgBody.CMPP_CONNECT.TimeStamp := htonl(LocPacOut.MsgBody.CMPP_CONNECT.TimeStamp);
        Move(NetPacOut.MsgBody.CMPP_CONNECT, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TCMPP_CONNECT));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TCMPP_CONNECT);
      end;

    CMPP_SUBMIT:
      begin
        Move(NetPacOut.MsgBody.CMPP_SUBMIT, sendbuffer.Buffer[sendbuffer.BufferSize], 127);
        sendbuffer.BufferSize := sendbuffer.BufferSize + 127;

        Move(NetPacOut.MsgBody.CMPP_SUBMIT.Msg_Content, sendbuffer.Buffer[sendbuffer.BufferSize], NetPacOut.MsgBody.CMPP_SUBMIT.MSG_LENGTH);
        sendbuffer.BufferSize := sendbuffer.BufferSize + NetPacOut.MsgBody.CMPP_SUBMIT.MSG_LENGTH;

        Move(NetPacOut.MsgBody.CMPP_SUBMIT.Reserve, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(NetPacOut.MsgBody.CMPP_SUBMIT.Reserve));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(NetPacOut.MsgBody.CMPP_SUBMIT.Reserve);
      end;

    CMPP_DELIVER_RESP:
      begin
        NetPacOut.MsgBody.CMPP_DELIVER_RESP.result := htonl(LocPacOut.MsgBody.CMPP_DELIVER_RESP.result);

        Move(NetPacOut.MsgBody.CMPP_DELIVER_RESP, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TCMPP_SUBMIT_RESP));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TCMPP_SUBMIT_RESP);
      end;

    CMPP_ACTIVE_TEST:
      begin

      end;

    CMPP_ACTIVE_TEST_RESP:
      begin
        NetPacOut.MsgBody.CMPP_ACTIVE_TEST_RESP.Success_Id := htonl(LocPacOut.MsgBody.CMPP_ACTIVE_TEST_RESP.Success_Id);

        Move(NetPacOut.MsgBody.CMPP_ACTIVE_TEST_RESP, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TCMPP_ACTIVE_TEST_RESP));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TCMPP_ACTIVE_TEST_RESP);

      end;
  end;

  if sendbuffer.BufferSize = LocPacOut.MsgHead.Total_Length then
  begin
    if LocPacOut.MsgHead.Command_ID = CMPP_SUBMIT then
    begin
      inc(WindowSize);
      mtcmppbuffer.Update(LocPacOut.MsgHead.Sequence_ID);
      inc(FMtCount);
    end;

    if MainForm.OutMonitor.Checked then
    begin
      MonitorThread.OutMonitorcmppBuffer.Add(LocPacOut);
    end;

    try
      FTCPCmppClient.WriteBuffer(sendbuffer.Buffer, sendbuffer.BufferSize);
    except
      on e: exception do
      begin
        AddMsgToMemo('cmpp0�ⲿ���ط��ʹ���:' + e.Message);
        FTCPCmppClient.Disconnect;
      end;
    end;
  end;
end;

procedure TOutReadCMPP0ThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;
//CMPP �ƶ�
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


//sgip ��ͨ
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
{SGIP  TMtSendThreadObj }
procedure TMtSendSgipThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

constructor TMtSendSgipThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  LastActiveTime := now;
end;

destructor TMtSendSgipThreadObj.destroy;
begin
  LastActiveTime := 0;
  inherited;
end;

procedure TMtSendSgipThreadObj.Execute;
begin
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        MtPrc;
      except
        on e: exception do
        begin
          AddMsgToMemo('MT��Ϣ�����߳�:' + e.Message);
        end;
      end;
    finally
      LastActiveTime := now;
      //������Ҫ����������
      sleep(1000 div GGATECONFIG.Flux);
    end;
  end;
end;

procedure TMtSendSgipThreadObj.MtPrc;
begin
  if OutReadSgipThread <> nil then
  begin
    OutReadSgipThread.PrcMt;
  end;
end;

procedure TMtSendSgipThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

{Sgip TOutReadSgipThreadObj }
procedure TOutReadSgipThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

procedure TOutReadSgipThreadObj.ClientRead;
begin
  try
    try
      FTCPClient.CheckForGracefulDisconnect();
    except
      on e: exception do
      begin
        AddMsgToMemo('TOutReadSgipThreadObj' + e.Message);
        sleep(1000);
      end;
    end;

    if FTCPClient.Connected then
    begin
      if FRecBuffer.BufferSize = 0 then
      begin
        //��ʼ���ṹ�壬�����ֱ����������ݰ��ͱ������ݰ�
        ZeroMemory(@FlocPacketIn, sizeof(TSGIP12_PACKET));
        ZeroMemory(@FnetPacketIn, sizeof(TSGIP12_PACKET));

        //����������ȡ���ݰ�ͷ
        FTCPClient.ReadBuffer(FRecBuffer.Buffer, sizeof(TSGIP12_HEAD));
        FRecBuffer.BufferSize := sizeof(TSGIP12_HEAD);

        //�������İ�ͷ���ݸ��Ƶ�����ṹ����
        Move(FRecBuffer.Buffer, FnetPacketIn.MsgHead, sizeof(TSGIP12_HEAD));
        //�������ֽ���ת���󣬽�����ṹ���ͷ���Ƶ����ؽṹ����
        FlocPacketIn.MsgHead.Message_Length := ntohl(FnetPacketIn.MsgHead.Message_Length);
        FlocPacketIn.MsgHead.Command_ID := ntohl(FnetPacketIn.MsgHead.Command_ID);
        FlocPacketIn.MsgHead.SNumber1 := ntohl(FnetPacketIn.MsgHead.SNumber1);
      end;

      case FlocPacketIn.MsgHead.Command_ID of
        SGIP12_Bind_RESP:
          begin
            //��¼Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPClient.ReadBuffer(FRecBuffer.Buffer[FRecBuffer.BufferSize], sizeof(TSGIP12_Bind_RESP));
            FRecBuffer.BufferSize := FRecBuffer.BufferSize + sizeof(TSGIP12_Bind_RESP);
            Move(FRecBuffer.Buffer, FnetPacketIn, FRecBuffer.BufferSize);
            FlocPacketIn.MsgBody.LOGIN_RESP := FnetPacketIn.MsgBody.LOGIN_RESP;
            FlocPacketIn.MsgBody.LOGIN_RESP.result := ntohl(FnetPacketIn.MsgBody.LOGIN_RESP.result);
          end;

        SGIP12_SUBMIT_RESP:
          begin
            //����Ӧ�������ȡ��Ӧ�ĳ��ȣ������Ƶ�����ṹ��ͱ��ؽṹ����
            FTCPClient.ReadBuffer(FRecBuffer.Buffer[FRecBuffer.BufferSize], sizeof(TSGIP12_SUBMIT_RESP));
            FRecBuffer.BufferSize := FRecBuffer.BufferSize + sizeof(TSGIP12_SUBMIT_RESP);
            Move(FRecBuffer.Buffer, FnetPacketIn, FRecBuffer.BufferSize);
            FlocPacketIn.MsgBody.SUBMIT_RESP := FnetPacketIn.MsgBody.SUBMIT_RESP;
            FlocPacketIn.MsgBody.SUBMIT_RESP.result := ntohl(FnetPacketIn.MsgBody.SUBMIT_RESP.result);
          end;

        SGIP12_DELIVER:
          begin
            FTCPClient.ReadBuffer(FRecBuffer.Buffer[FRecBuffer.BufferSize], FlocPacketIn.MsgHead.Message_Length - FRecBuffer.BufferSize);
            FRecBuffer.BufferSize := FlocPacketIn.MsgHead.Message_Length;
            Move(FRecBuffer.Buffer, FnetPacketIn, FRecBuffer.BufferSize);
            FnetPacketIn.MsgBody.DELIVER.MessageLength := FlocPacketIn.MsgHead.Message_Length - sizeof(TSGIP12_HEAD) - 77;
            FlocPacketIn.MsgBody.DELIVER := FnetPacketIn.MsgBody.DELIVER;

            ZeroMemory(@FlocPacketIn.MsgBody.DELIVER.MessageContent, sizeof(FlocPacketIn.MsgBody.DELIVER.MessageContent));
            ZeroMemory(@FlocPacketIn.MsgBody.DELIVER.Reserve, sizeof(FlocPacketIn.MsgBody.DELIVER.Reserve));

            Move(FnetPacketIn.MsgBody.DELIVER.MessageContent, FlocPacketIn.MsgBody.DELIVER.MessageContent, FlocPacketIn.MsgBody.DELIVER.MessageLength);
            Move(FnetPacketIn.MsgBody.DELIVER.MessageContent[FlocPacketIn.MsgBody.DELIVER.MessageLength], FlocPacketIn.MsgBody.DELIVER.Reserve, sizeof(FlocPacketIn.MsgBody.DELIVER.Reserve));

            FnetPacketIn.MsgBody := FlocPacketIn.MsgBody;
          end;

        {SGIP12_ACTIVE_TEST:
          begin

          end;

        SGIP12_ACTIVE_TEST_RESP:
          begin

          end;    }

      else
        begin
          FTCPClient.Disconnect;
        end;
      end;

      if MainForm.OutMonitor.Checked then
      begin
        MonitorThread.OutMonitorSgipBuffer.Add(FlocPacketIn);
      end;

      case FlocPacketIn.MsgHead.Command_ID of
        SGIP12_Bind_RESP:
          begin
            if FlocPacketIn.MsgBody.LOGIN_RESP.result = 0 then
            begin
              FLogined := True;
              AddMsgToMemo('SGIP�ⲿ���ص�¼�ɹ�');
            end
            else
            begin
              FLogined := false;
              AddMsgToMemo('SGIP�ⲿ���ص�¼ʧ��');
            end;
          end;

        SGIP12_SUBMIT_RESP:
          begin
            mtbuffer.UpdateResp(FlocPacketIn.MsgHead.SNumber1, FlocPacketIn.MsgBody.SUBMIT_RESP.Reserve, FlocPacketIn.MsgBody.SUBMIT_RESP.result);
            inc(FMtRespCount);

            WindowSize := WindowSize - 1;
            if WindowSize < 0 then WindowSize := 0;
          end;

        SGIP12_DELIVER: //mo���й�����д�뻺��
          begin
            //д�뻺�壬����״̬����
            {if FlocPacketIn.MsgBody.DELIVER. = 1 then
            begin
              //״̬����,д��״̬���滺����
              rptbuffer.Add(FlocPacketIn);
              inc(FRptCount);
            end
            else
            begin    }
              //MO,��Moд��Mo������
            moSgipbuffer.Add(FlocPacketIn);
            inc(FMoCount);
            //end;

            //Ӧ��
            SendPacket(CreateRespPacket(FlocPacketIn));
          end;

        {SGIP12_ACTIVE_TEST:
          begin
            WindowSize := 0;
            SendPacket(CreateRespPacket(FlocPacketIn));
          end;

        SGIP12_ACTIVE_TEST_RESP:
          begin
            WindowSize := 0;
          end;   }
      end;

      FRecBuffer.BufferSize := 0;
      ZeroMemory(@FRecBuffer.Buffer, sizeof(FRecBuffer.Buffer));
    end;
  except
    on e: exception do
    begin
      AddMsgToMemo('SGIP�ⲿ���ؽ����߳�:' + e.Message);
      sleep(1000);
      FTCPClient.Disconnect;
    end;
  end;
end;

constructor TOutReadSgipThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  ZeroMemory(@FRecBuffer.Buffer, sizeof(FRecBuffer.Buffer));
  FRecBuffer.BufferSize := 0;

  ZeroMemory(@FlocPacketIn, sizeof(TSGIP12_PACKET));
  ZeroMemory(@FnetPacketIn, sizeof(TSGIP12_PACKET));

  FLogined := false;
  FMoCount := 0;
  FMtCount := 0;
  FRptCount := 0;
  FMtRespCount := 0;
  FMtRefuseCount := 0;
  Seqid := 1;
  WindowSize := 0;
  FLastActiveTime := now;
  MtHasUnsendMessage := false;
  MtMessage := '';
  MtNumber := '';
  MtUnsend := 100;
end;

function TOutReadSgipThreadObj.CreatePacket(
  const RequestID: Cardinal): TSGIP12_PACKET;
var
  pac: TSGIP12_PACKET;
  Time: string;
  strTemp: string;
  tempArray: array[0..255] of char;
  tempbArray: array[0..255] of byte;
  md5: TMD5;
  FV_Date1_S, FV_Date2_S: string;
  str_i, SendSize: integer;
  abc, bc: longword;
begin
  ZeroMemory(@pac, sizeof(TSGIP12_PACKET));
  pac.MsgHead.Command_ID := RequestID;

  case RequestID of
    SGIP12_BIND:
      begin
        pac.MsgHead.Message_Length := sizeof(TSGIP12_HEAD) + sizeof(TSGIP12_Bind);
        pac.MsgHead.SNumber1 := GetSeqid;


        DateTimeToString(FV_Date1_S, 'mmddhhnnss', now);
        DateTimeToString(FV_Date2_S, 'zzz', now);
        //FillChar(sBind,sizeof(sBind),0);
        //FillChar(sHead,sizeof(sHead),0);
        str_i := sizeof(TSGIP12_HEAD) + sizeof(TSGIP12_Bind);
        pac.MsgBody.LOGIN.LonginType := 1;
        StrPCopy(pac.MsgBody.LOGIN.LonginPass, GGATECONFIG.sgipClientSecret);
        StrPCopy(pac.MsgBody.LOGIN.LonginName, GGATECONFIG.sgipClientID);
        abc := 3053112345;
        pac.MsgHead.SNumber1 := abc;
        pac.MsgHead.SNumber2 := htonl(strtoint(FV_Date1_S));
        pac.MsgHead.SNumber3 := htonl(strtoint(FV_Date2_S));
      end;

    SGIP12_SUBMIT:
      begin
        //pac.MsgBody.SUBMIT.NeedReport := 1;
        pac.MsgBody.SUBMIT.Priority := 0;
        pac.MsgBody.SUBMIT.UserCount := 1;
      end;

    {SMGP13_ACTIVE_TEST:
      begin
        pac.MsgHead.PacketLength := sizeof(TSGIP12_HEAD);
        pac.MsgHead.SequenceID := GetSeqid;
      end; }
  end;

  result := pac;
end;

function TOutReadSgipThreadObj.CreateRespPacket(
  const recpac: TSGIP12_PACKET): TSGIP12_PACKET;
var
  pac: TSGIP12_PACKET;
begin
  ZeroMemory(@pac, sizeof(TSGIP12_PACKET));

  case recpac.MsgHead.Command_ID of
    SGIP12_DELIVER:
      begin
        pac.MsgHead.Command_ID := SGIP12_DELIVER_RESP;

        pac.MsgHead.Message_Length := sizeof(TSGIP12_HEAD) + sizeof(TSGIP12_DELIVER_RESP);
        pac.MsgHead.SNumber1 := recpac.MsgHead.SNumber1;
        Move(recpac.MsgBody.DELIVER_RESP.result, pac.MsgBody.DELIVER_RESP.result, sizeof(pac.MsgBody.DELIVER_RESP.result));
        pac.MsgBody.DELIVER_RESP.result := 0;
      end;

    {SGIP12_ACTIVE_TEST:
      begin
        pac.MsgHead.PacketLength := sizeof(TSGIP12_HEAD);
        pac.MsgHead.RequestID := SMGP13_ACTIVE_TEST_RESP;
        pac.MsgHead.SequenceID := recpac.MsgHead.SequenceID;
      end; }
  end;

  result := pac;
end;

destructor TOutReadSgipThreadObj.destroy;
begin
  FTCPClient := nil;
  inherited;
end;

procedure TOutReadSgipThreadObj.Execute;
begin
  FreeOnTerminate := True;

  while not Terminated do
  begin
    try
      ClientRead;
      FLastActiveTime := now(); //������ʱ������ڳ���2���ӣ����ͻ���԰�
    finally
      sleep(0);
    end;
  end;
end;

function TOutReadSgipThreadObj.GetSeqid: Cardinal;
begin
  result := Seqid;
  inc(Seqid);
  if Seqid >= 4294967295 then
  begin
    Seqid := 1;
  end;
end;

// ʵ�ʵķ�����Ϣ���ն˵Ĵ������
procedure TOutReadSgipThreadObj.PrcMt;
var
  MtSeqId: integer;
begin
  {log_smgp_time := log_smgp_time + 1;
  if log_smgp_time = 5 then
  begin
    FTCPClient.Disconnect;
    OutReadThread.Terminate;
  end;      }
  if FTCPClient.Connected then
  begin
    if FLogined then
    begin
      if now - FLastActiveTime > 30 / 3600 / 24 then
      begin
        if now - FLastActiveTime > 90 / 3600 / 24 then
        begin
          FTCPClient.Disconnect;
        end
        else
        begin
          if now - LastSendActiveTime > 10 / 3600 / 24 then
          begin
            //���ͻ���԰�
            SendPacket(CreatePacket(SMGP13_ACTIVE_TEST));
            //��������ͻ���԰�ʱ��
            LastSendActiveTime := now();
          end;
        end;
      end
      else
      begin
        // ������Ϣ(1)
        MtSeqId := mtbuffer.Get;
        if MtSeqId > 0 then
        begin
          SendMt(MtSeqId);
        end;

      end;
    end
    else
    begin
      if now - LastLoginTime > 6 / 3600 / 24 then
      begin
        SendPacket(CreatePacket(SMGP13_LOGIN));
        LastLoginTime := now;
      end;
    end;
  end;
end;

// ���ⷢ�ͺ���
procedure TOutReadSgipThreadObj.SendMt(i: integer);
var
  Buffer: TMtBuffer;
  outpac: TSGIP12_PACKET;
begin
  { Buffer := mtbuffer.Read(i);
   outpac := CreatePacket(SMGP13_SUBMIT);
   outpac.MsgHead.SequenceID := i;
   outpac.MsgBody.SUBMIT.MsgType := Buffer.OutMsgType;
   Move(Buffer.OutServiceID, outpac.MsgBody.SUBMIT.ServiceID, sizeof(Buffer.OutServiceID));
   Move(Buffer.OutFeeType, outpac.MsgBody.SUBMIT.FeeType, sizeof(Buffer.OutFeeType));
   Move(Buffer.OutFixedFee, outpac.MsgBody.SUBMIT.FixedFee, sizeof(Buffer.OutFixedFee));
   Move(Buffer.OutFeeCode, outpac.MsgBody.SUBMIT.FeeCode, sizeof(Buffer.OutFeeCode));
   outpac.MsgBody.SUBMIT.MsgFormat := Buffer.Mt.MtMsgFmt;
   Move(Buffer.Mt.MtValidTime, outpac.MsgBody.SUBMIT.ValidTime, sizeof(Buffer.Mt.MtValidTime));
   Move(Buffer.Mt.MtAtTime, outpac.MsgBody.SUBMIT.AtTime, sizeof(Buffer.Mt.MtAtTime));
   Move(Buffer.Mt.MtSpAddr, outpac.MsgBody.SUBMIT.SrcTermID, sizeof(TSMGP13PhoneNum));
   Move(Buffer.Mt.MtFeeAddr, outpac.MsgBody.SUBMIT.ChargeTermID, sizeof(TSMGP13PhoneNum));
   Move(Buffer.Mt.MtUserAddr, outpac.MsgBody.SUBMIT.DestTermID, sizeof(TSMGP13PhoneNum));
   outpac.MsgBody.SUBMIT.MsgLength := Buffer.Mt.MtMsgLenth;
   Move(Buffer.Mt.MtMsgContent, outpac.MsgBody.SUBMIT.MsgContent, Buffer.Mt.MtMsgLenth);
   outpac.MsgHead.PacketLength := sizeof(TSGIP12_HEAD) + sizeof(TSGIP12_SUBMIT) - sizeof(outpac.MsgBody.SUBMIT.MsgContent) + Buffer.Mt.MtMsgLenth;
   SendPacket(outpac);  }
end;

procedure TOutReadSgipThreadObj.SendPacket(pac: TSGIP12_PACKET);
var
  sendbuffer: TCOMMBuffer;
  NetPacOut, LocPacOut: TSGIP12_PACKET;
begin
  //��ʼ������
  ZeroMemory(@sendbuffer, sizeof(TCOMMBuffer));
  sendbuffer.BufferSize := 0;
  NetPacOut := pac;
  LocPacOut := pac;

  //��ͷ���֣����������ֽ���ת��
  //htonl����32λ�����ַ�˳��ת���������ַ�˳��.
  NetPacOut.MsgHead.Message_Length := htonl(LocPacOut.MsgHead.Message_Length);
  NetPacOut.MsgHead.Command_ID := htonl(LocPacOut.MsgHead.Command_ID);
  NetPacOut.MsgHead.SNumber1 := htonl(LocPacOut.MsgHead.SNumber1);

  //����ͷ���Ƶ����ͻ�����
  //move�����������ǽ����������е�Ԫ�شӺ��濪ʼ������������ѭ��������n����
  Move(NetPacOut.MsgHead, sendbuffer.Buffer, sizeof(TSGIP12_HEAD));
  sendbuffer.BufferSize := sizeof(TSGIP12_HEAD);

  case pac.MsgHead.Command_ID of
    SGIP12_BIND:
      begin
        Move(NetPacOut.MsgBody.LOGIN, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TSGIP12_Bind));
        sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TSGIP12_Bind);
      end;

    SGIP12_SUBMIT:
      begin
        { Move(NetPacOut.MsgBody.SUBMIT, sendbuffer.Buffer[sendbuffer.BufferSize], 127);
         sendbuffer.BufferSize := sendbuffer.BufferSize + 127;

         Move(NetPacOut.MsgBody.SUBMIT.MsgContent, sendbuffer.Buffer[sendbuffer.BufferSize], NetPacOut.MsgBody.SUBMIT.MsgLength);
         sendbuffer.BufferSize := sendbuffer.BufferSize + NetPacOut.MsgBody.SUBMIT.MsgLength;

         Move(NetPacOut.MsgBody.SUBMIT.Reserve, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(NetPacOut.MsgBody.SUBMIT.Reserve));
         sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(NetPacOut.MsgBody.SUBMIT.Reserve);  }
      end;

    SGIP12_DELIVER_RESP:
      begin
        { NetPacOut.MsgBody.DELIVER_RESP.Status := htonl(LocPacOut.MsgBody.DELIVER_RESP.Status);

         Move(NetPacOut.MsgBody.DELIVER_RESP, sendbuffer.Buffer[sendbuffer.BufferSize], sizeof(TSGIP12_DELIVER_RESP));
         sendbuffer.BufferSize := sendbuffer.BufferSize + sizeof(TSGIP12_DELIVER_RESP); }
      end;

    {SGIP12_ACTIVE_TEST:
      begin

      end;

    SGIP12_ACTIVE_TEST_RESP:
      begin

      end;   }
  end;

  if sendbuffer.BufferSize = LocPacOut.MsgHead.Message_Length then
  begin
    if LocPacOut.MsgHead.Command_ID = SGIP12_SUBMIT then
    begin
      inc(WindowSize);
      mtbuffer.Update(LocPacOut.MsgHead.SNumber1);
      inc(FMtCount);
    end;

    if MainForm.OutMonitor.Checked then
    begin
      MonitorThread.OutMonitorSgipBuffer.Add(LocPacOut);
    end;

    try
      FTCPClient.WriteBuffer(sendbuffer.Buffer, sendbuffer.BufferSize);
    except
      on e: exception do
      begin
        AddMsgToMemo('SGIP�ⲿ���ط����߳�' + e.Message);
        FTCPClient.Disconnect;
      end;
    end;
  end;
end;

procedure TOutReadSgipThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;
//SGIP ����߳̽���
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


procedure TMainForm.FormCreate(Sender: TObject);
var
  ZAppName: array[0..127] of char;
  Hold: string;
  Found: HWND;
begin
  ReadConfig;
  Application.Title := inttostr(GSMSCENTERCONFIG.GateId);
  ChDir(Extractfilepath(Application.exename));
  Hold := Application.Title;
  Application.Title := 'Cnrenwy' + inttostr(HInstance); // ��ʱ�޸Ĵ��ڱ���
  StrPCopy(ZAppName, Hold); // ԭ���ڱ���
  Found := FindWindow(nil, ZAppName); // ���Ҵ���
  Application.Title := Hold; // �ָ����ڱ���
  MainForm.Caption := '�������أ�' + Hold;
  if Found <> 0 then
  begin
    // ���ҵ��򼤻������еĳ��򲢽�������
    ShowWindow(Found, SW_SHOWDEFAULT);
    SetForegroundWindow(Found);
    Application.Terminate;
  end
  else
  begin
    //����errlog
    if not DirectoryExists(Extractfilepath(Application.exename) + '\errlog') then
    begin
      CreateDir('errlog');
    end;
    //CoInitialize(nil);

    //�������ݿ�
    ConnectDB(AdoConnection);
    //����ҵ�����ת������
    LoadServiceCode;
    //����Э���
    LoadProtocol;
    //��ʼ������
    mobuffer := TMoBufferObj.Create;
    mocmppbuffer := TMocmppBufferObj.Create;
    moSgipbuffer := TMoSgipBufferObj.Create;
    mtbuffer := TMtBufferObj.Create;
    mtcmppbuffer := TMtcmppBufferObj.Create;
    mtSgipbuffer := TMtSgipBufferObj.Create;
    rptbuffer := TRptLogBufferObj.Create;
    rptcmppbuffer := TRptLogcmppBufferObj.Create;
    rptSgipbuffer := TRptLogSgipBufferObj.Create;

    //���ݰ�����߳�
    MonitorThread := TMonitorThreadObj.Create(True);
    MonitorThread.OutListview := OutListview;
    MonitorThread.Resume;

    //MO,Mt,״̬������Ϣ��־�߳�
    LogThread := TLogThreadObj.Create(false);
    //MT��ϢԤ�����߳�
    MtPrePrcThread := TMtPrePrcThreadObj.Create(false);
    //MTȺ���߳�
    MtQfThread := TMtQfThread.Create(false);

    Timer1.Enabled := True;
  end;
end;

//�������ļ��ж�ȡ����
function TMainForm.ReadConfig: boolean;
var
  iniFile: Tinifile;
  iniPath: string;
begin
  result := false;
  iniPath := Extractfilepath(Application.exename) + 'Config.ini';
  if FileExists(iniPath) then
  begin
    try
      iniFile := Tinifile.Create(iniPath);
      try
        //SMGP
        GGATECONFIG.RemoteIp := iniFile.ReadString('SMGPGATEWAY', 'SMGPADDRESS', '127.0.0.1');
        GGATECONFIG.RemotePort := iniFile.ReadInteger('SMGPGATEWAY', 'SMGPPORT', 18906);
        GGATECONFIG.ClientID := iniFile.ReadString('SMGPGATEWAY', 'SMGPCLIENTID', '');
        GGATECONFIG.ClientSecret := iniFile.ReadString('SMGPGATEWAY', 'SMGPPASSWORD', '');
        GGATECONFIG.Smgp_Tag := iniFile.ReadInteger('SMGPGATEWAY', 'Smgp_Tag', 0);

        GGATECONFIG.SPNUM := iniFile.ReadString('GATEWAY', 'SPNUM', '1291');
        GGATECONFIG.Flux := iniFile.ReadInteger('GATEWAY', 'FLUX', 5);
        GGATECONFIG.MCSTART := iniFile.ReadInteger('GATEWAY', 'MCSTART', 1);
        GGATECONFIG.MCEND := iniFile.ReadInteger('GATEWAY', 'MCEND', 21);

        //CMPP
        GGATECONFIG.cmppRemoteIp := iniFile.ReadString('CMPPGATEWAY', 'CMPPADDRESS', '127.0.0.1');
        GGATECONFIG.cmppRemotePort := iniFile.ReadInteger('CMPPGATEWAY', 'CMPPPORT', 18906);
        GGATECONFIG.cmppRemotePort0 := iniFile.ReadInteger('CMPPGATEWAY', 'CMPPPORT0', 18906);
        GGATECONFIG.cmppClientID := iniFile.ReadString('CMPPGATEWAY', 'CMPPCLIENTID', '');
        GGATECONFIG.cmppClientSecret := iniFile.ReadString('CMPPGATEWAY', 'CMPPPASSWORD', '');
        GGATECONFIG.Cmpp_Tag := iniFile.ReadInteger('SMGPGATEWAY', 'Cmpp_Tag', 0);

        GGATECONFIG.SPNUM := iniFile.ReadString('GATEWAY', 'SPNUM', '1291');
        GGATECONFIG.Flux := iniFile.ReadInteger('GATEWAY', 'FLUX', 5);
        GGATECONFIG.MCSTART := iniFile.ReadInteger('GATEWAY', 'MCSTART', 1);
        GGATECONFIG.MCEND := iniFile.ReadInteger('GATEWAY', 'MCEND', 21);

        //Sgip
        GGATECONFIG.SgipRemoteIp := iniFile.ReadString('SgipGATEWAY', 'SgipADDRESS', '127.0.0.1');
        GGATECONFIG.SgipRemotePort := iniFile.ReadInteger('SgipGATEWAY', 'SgipPORT', 18906);
        GGATECONFIG.sgipClientID := iniFile.ReadString('SgipGATEWAY', 'SgipCLIENTID', '');
        GGATECONFIG.sgipClientSecret := iniFile.ReadString('SgipGATEWAY', 'SgipPASSWORD', '');
        GGATECONFIG.Sgip_Tag := iniFile.ReadInteger('SMGPGATEWAY', 'Sgip_Tag', 0);

        GGATECONFIG.SPNUM := iniFile.ReadString('GATEWAY', 'SPNUM', '1291');
        GGATECONFIG.Flux := iniFile.ReadInteger('GATEWAY', 'FLUX', 5);
        GGATECONFIG.MCSTART := iniFile.ReadInteger('GATEWAY', 'MCSTART', 1);
        GGATECONFIG.MCEND := iniFile.ReadInteger('GATEWAY', 'MCEND', 21);

        //SMSCENTER
        GSMSCENTERCONFIG.GateId := iniFile.ReadInteger('SMSCENTER', 'GateId', 0);
        GSMSCENTERCONFIG.Gatename := iniFile.ReadString('SMSCENTER', 'Gatename', '1182333');
        GSMSCENTERCONFIG.GateDesc := iniFile.ReadString('SMSCENTER', 'GateDesc', '0');
        GSMSCENTERCONFIG.Flux := iniFile.ReadInteger('SMSCENTER', 'FLUX', 20);

        //GDBCONFIG
        GDBCONFIG.Address := iniFile.ReadString('DBCONFIG', 'ADDRESS', '127.0.0.1');
        GDBCONFIG.User := iniFile.ReadString('DBCONFIG', 'USER', 'sa');
        GDBCONFIG.Pass := iniFile.ReadString('DBCONFIG', 'PASS', '');
        GDBCONFIG.TnsName := iniFile.ReadString('DBCONFIG', 'TNSNAME', '1291log');
      finally
        iniFile.Free;
      end;
    except
      result := false;
    end;
  end;
end;

procedure TMainForm.ConnectDB(AdoConnection: TADOConnection);
begin
  if {false}  AdoConnection.Connected = false then
  begin
    AdoConnection.ConnectionString := 'Provider=SQLOLEDB.1;Password='
      + GDBCONFIG.Pass
      + ';Persist Security Info=True;Application Name='
      + GSMSCENTERCONFIG.GateDesc
      + ';User ID='
      + GDBCONFIG.User
      + ';Initial Catalog='
      + GDBCONFIG.TnsName
      + ';Data Source='
      + GDBCONFIG.Address;
    try
      // ADOConnection.Open();
      ShowToMemo('���ݿ����ӳɹ�', MonitorMemo);
    except
      on e: exception do
      begin
        ShowToMemo('���ݿ�����ʧ��', MonitorMemo);
        ShowToMemo(e.Message, MonitorMemo);
      end;
    end;
  end;
end;

procedure TMainForm.LoadServiceCode;
var
  strSql: string;
  i: integer;
begin
  if AdoConnection.Connected then
  begin
    strSql := 'select LogicId, LogicCode, ServiceId from ServiceCodeConvertView where GateId = ' + inttostr(GSMSCENTERCONFIG.GateId);
    AdoQuery.Close;
    AdoQuery.SQL.Text := strSql;
    AdoQuery.Open;
    if high(ServiceCode) = -1 then
    begin
      setlength(ServiceCode, AdoQuery.RecordCount);
    end
    else
    begin
      ServiceCode := nil;
      setlength(ServiceCode, AdoQuery.RecordCount);
    end;
    i := 0;
    while not AdoQuery.Eof do
    begin
      ServiceCode[i].LogicId := AdoQuery.fieldbyname('LogicId').AsInteger;
      //�ڲ�ҵ�����ȫΪ��д
      SetPchar(ServiceCode[i].LogicCode, UpperCase(AdoQuery.fieldbyname('LogicCode').AsString), sizeof(ServiceCode[i].LogicCode));
      SetPchar(ServiceCode[i].GateCode, AdoQuery.fieldbyname('ServiceId').AsString, sizeof(ServiceCode[i].GateCode));
      inc(i);
      AdoQuery.MoveBy(1);
    end;
    AdoQuery.Close;
  end;
end;



procedure TMainForm.SMGPTCPClientDisconnected(Sender: TObject);
begin
  try
    ShowToMemo('�ⲿ����SMGP�����ѶϿ�', MonitorMemo);

    if MtSendThread <> nil then
    begin
      MtSendThread.Terminate;
      MtSendThread := nil;
    end;

    if OutReadThread <> nil then
    begin
      OutReadThread.Terminate;
      OutReadThread := nil;
    end;
  except
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MonitorTimer.Enabled := false;
  Timer1.Enabled := false;
  try
    //CoUninitialize();
    SMGPTCPClient.CheckForGracefulDisconnect(false);
    if SMGPTCPClient.Connected then
    begin
      SMGPTCPClient.Disconnect;
    end;
  except
    on e: exception do
    begin
      ShowToMemo('1:' + e.Message, MonitorMemo);
    end;
  end;

  try
    //CoUninitialize();
    CmppTCPClient.CheckForGracefulDisconnect(false);
    if CmppTCPClient.Connected then
    begin
      CmppTCPClient.Disconnect;
    end;
  except
    on e: exception do
    begin
      ShowToMemo('1:' + e.Message, MonitorMemo);
    end;
  end;

  try
    Cmpp0TCPClient.CheckForGracefulDisconnect(false);
    if Cmpp0TCPClient.Connected then
    begin
      Cmpp0TCPClient.Disconnect;
    end;
  except
    on e: exception do
    begin
      ShowToMemo('1:' + e.Message, MonitorMemo);
    end;
  end;

  try
    if MtSendThread <> nil then
    begin
      MtSendThread.Terminate;
      MtSendThread := nil;
    end;
  except
    on e: exception do
    begin
      ShowToMemo('2' + e.Message, MonitorMemo);
    end;
  end;

  try
    if OutReadThread <> nil then
    begin
      OutReadThread.Terminate;
      OutReadThread := nil;
    end;
  except
    on e: exception do
    begin
      ShowToMemo('3:' + e.Message, MonitorMemo);
    end;
  end;

  try
    SgipTCPClient.CheckForGracefulDisconnect(false);
    if SgipTCPClient.Connected then
    begin
      SgipTCPClient.Disconnect;
    end;
  except
    on e: exception do
    begin
      ShowToMemo('4:' + e.Message, MonitorMemo);
    end;
  end;

  try
    MtQfThread.Terminate;
    MtQfThread := nil;
  except
    on e: exception do
    begin
      ShowToMemo('7:' + e.Message, MonitorMemo);
    end;
  end;

  try
    MtPrePrcThread.Terminate;
    MtPrePrcThread := nil;
  except
    on e: exception do
    begin
      ShowToMemo('8:' + e.Message, MonitorMemo);
    end;
  end;

  try
    LogThread.Terminate;
    LogThread := nil;
  except
    on e: exception do
    begin
      ShowToMemo('9:' + e.Message, MonitorMemo);
    end;
  end;

  try
    MonitorThread.Terminate;
    MonitorThread := nil;
  except
    on e: exception do
    begin
      ShowToMemo('10:' + e.Message, MonitorMemo);
    end;
  end;

  mobuffer.Free;
  mobuffer := nil;
  mtbuffer.Free;
  mtbuffer := nil;
  mtcmppbuffer.Free;
  mtcmppbuffer := nil;
  mtSgipbuffer.Free;
  mtSgipbuffer := nil;
  rptbuffer.Free;
  rptbuffer := nil;

  ServiceCode := nil;

  MonitorMemo.Lines.SaveToFile('ErrLog\' + FormatDatetime('yyyymmddhhnnss', now()) + '.log');
  MonitorMemo.Clear;
end;

{ TLogThreadObj }
procedure TLogThreadObj.AddMsgToMemo(const Msg: string);
begin
  ErrMsg := Msg;
  Synchronize(ThAddMsgToMemo);
end;

procedure TLogThreadObj.ConnectDB;
begin
  if false {ADOConnection.Connected = false} then
  begin
    AdoConnection.ConnectionString := 'Provider=SQLOLEDB.1;Password='
      + GDBCONFIG.Pass
      + ';Persist Security Info=True;Application Name='
      + GSMSCENTERCONFIG.GateDesc
      + ';User ID='
      + GDBCONFIG.User
      + ';Initial Catalog='
      + GDBCONFIG.TnsName
      + ';Data Source='
      + GDBCONFIG.Address;
    try
      AdoConnection.Open();
    except
      on e: exception do
      begin
        AddMsgToMemo('��־�߳����ݿ�����ʧ��');
        AddMsgToMemo(e.Message);
      end;
    end;
  end;
end;

constructor TLogThreadObj.Create(CreateSuspended: boolean);
begin
  inherited;
  LastActiveTime := now;
  AdoConnection := TADOConnection.Create(nil);
  AdoQuery := TAdoQuery.Create(nil);
  AdoQuery.Connection := AdoConnection;
end;

procedure TLogThreadObj.CreateRpt(Buffer: TMtBuffer);
var
  rptbuff: TRptBuffer;
  Rpt: TSMGP13RPT;
begin
  ZeroMemory(@rptbuff, sizeof(TRptBuffer));
  ZeroMemory(@Rpt, sizeof(TSMGP13RPT));

  rptbuff.MtLogicId := Buffer.Mt.MtLogicId;
  rptbuff.MtInMsgId := Buffer.Mt.MtInMsgId;
  rptbuff.MtSpAddr := Buffer.Mt.MtSpAddr;
  rptbuff.MtUserAddr := Buffer.Mt.MtUserAddr;

  if Buffer.PrePrcResult <> 0 then
  begin
    Rpt.stat := 'PRECERR';
    Rpt.Err := '001';
  end
  else
  begin
    Rpt.stat := 'RESPERR';
    SetPchar(Rpt.Err, SMGP13_StatusToStr(Buffer.Status), sizeof(Rpt.Err));
  end;
  rptbuff.Rpt.MsgLength := sizeof(Rpt);
  Move(Rpt, rptbuff.Rpt.MsgContent, sizeof(Rpt));
  rptbuffer.SendBuffers.Add(rptbuff);
end;

destructor TLogThreadObj.destroy;
begin
  AdoQuery.Free;
  AdoConnection.Free;
  LastActiveTime := 0;
  inherited;
end;

procedure TLogThreadObj.Execute;
begin
  //CoInitialize(nil);
  FreeOnTerminate := True;
  while not Terminated do
  begin
    try
      try
        if AdoConnection.Connected then
        begin
          LogMt;
          LogMo;
          LogRpt;
        end
        else
        begin
          ConnectDB;
          sleep(3000);
        end;
      except
        on e: exception do
        begin
          AddMsgToMemo('��־�߳�:' + e.Message);

          if e.Message = '����ʧ��' then
          begin
            AdoConnection.Close;
          end;
        end;
      end;
    finally
      LastActiveTime := now;
      sleep(10);
    end;
  end;
  //CoUninitialize;
end;

procedure TLogThreadObj.LogMo;
var
  logseqid: integer;
  strSql: string;
  Buffer: TMoBuffer;
begin
  //logseqid := mobuffer.LogBuffers.Get;
  logseqid := mobuffer.Get;
  if logseqid > 0 then
  begin
    //buffer := mobuffer.LogBuffers.Read(logseqid);
    Buffer := mobuffer.Read(logseqid);
    ConvertNull(Buffer.mo.MsgContent, Buffer.mo.MsgLength, Buffer.mo.MsgContent);
    strSql := 'insert into OutMo (MoOutMsgId, MoInMsgId, MoSpAddr, MoUserAddr, MoMsgFmt, MoMsgLenth, MoMsgContent, MoReserve, OutRecTime, G2CED, SPPOrcTimes, G2CLastPrcTime, MoGateId) values (';
    strSql := strSql + Quotedstr(Chartohex(Buffer.mo.MsgID)) + ',';
    strSql := strSql + Quotedstr(Chartohex(Buffer.MoInMsgId)) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.DestTermID) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.SrcTermID) + ',';
    strSql := strSql + inttostr(Buffer.mo.MsgFormat) + ',';
    strSql := strSql + inttostr(Buffer.mo.MsgLength) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.MsgContent) + ',';
    strSql := strSql + '''''' + ',';
    strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ',';
    strSql := strSql + inttostr(Buffer.Prced) + ',';
    strSql := strSql + inttostr(Buffer.PrcTimes) + ',';
    strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.LastPrcTime)) + ',';
    strSql := strSql + inttostr(GSMSCENTERCONFIG.GateId);
    strSql := strSql + ')';
  end;
end;

procedure TLogThreadObj.LogMt;
var
  logseqid: integer;
  strSql: string;
  Buffer: TMtBuffer;
  qfSql: string;
  hdSql: string;
begin
  logseqid := mtbuffer.LogBuffers.Get;
  if logseqid > 0 then
  begin
    Buffer := mtbuffer.LogBuffers.Read(logseqid);
    ConvertNull(Buffer.Mt.MtMsgContent, Buffer.Mt.MtMsgLenth, Buffer.Mt.MtMsgContent);
    if Buffer.Status = 0 then
    begin
      if Buffer.Mt.MtLogicId = 2 then
      begin
        //�㶫���ŷ��ͻ����гɹ�Ӧ������ǳɹ���
        strSql := 'insert into OUTMTLOG (L2CMtMsgType, MoOutMsgId, MoInMsgId, MtGateId, MoLinkId, MtSpAddr, MtUserAddr, MtFeeAddr, L2CMtServiceId, MtTpPid, MtTpUdhi, MtMsgFmt, MtValidTime, MtAtTime, MtMsgLenth, MtMsgContent, MtReserve, MtInMsgId, MtLogicId, PrePrcResult, ';
        strSql := strSql + 'OutMsgType, OutServiceID, OutFeeType, OutFixedFee, OutFeeCode, RealFeeCode, C2GRecTime, OUTStatus, OutMtMsgid, OutPrced, OutPrcTimes, OutLastprctime, OutRptSubDate, OutRptDonDate, OutRptStat, OutRptErr, OutRptRecTime) values (';
        strSql := strSql + inttostr(Buffer.Mt.MtMsgType) + ',';
        strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MoOutMsgId)) + ',';
        strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MoInMsgId)) + ',';
        strSql := strSql + inttostr(GSMSCENTERCONFIG.GateId) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MoLinkId) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtSpAddr) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtUserAddr) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtFeeAddr) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtServiceId) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtTpPid) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtTpUdhi) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtMsgFmt) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtValidTime) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtAtTime) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtMsgLenth) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtMsgContent) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtReserve) + ',';
        strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MtInMsgId)) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtLogicId) + ',';
        strSql := strSql + inttostr(Buffer.PrePrcResult) + ','; //PrePrcResult
        strSql := strSql + inttostr(Buffer.OutMsgType) + ','; //OutMsgType
        strSql := strSql + Quotedstr(Buffer.OutServiceID) + ','; //OutServiceID
        strSql := strSql + Quotedstr(Buffer.OutFeeType) + ','; //OutFeeType
        strSql := strSql + Quotedstr(Buffer.OutFixedFee) + ','; //OutFixedFee
        strSql := strSql + Quotedstr(Buffer.OutFeeCode) + ','; //OutFeeCode
        strSql := strSql + inttostr(Buffer.RealFeeCode) + ','; //RealFeeCode
        strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ','; //C2GRecTime
        strSql := strSql + inttostr(Buffer.Status) + ','; //OUTStatus
        strSql := strSql + Quotedstr(Chartohex(Buffer.OutMtMsgid)) + ','; //OutMtMsgid
        strSql := strSql + inttostr(Buffer.Prced) + ','; //OutPrced
        strSql := strSql + inttostr(Buffer.PrcTimes) + ','; //OutPrcTimes
        strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.LastPrcTime)) + ','; //OutLastprctime
        strSql := strSql + '''''' + ','; //OutRptSubDate
        strSql := strSql + '''''' + ','; //OutRptDonDate
        strSql := strSql + Quotedstr('DELIVRD') + ','; //OutRptStat
        strSql := strSql + Quotedstr('000') + ','; //OutRptErr
        strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.LastPrcTime)); //OutRptRecTime
        strSql := strSql + ')';
        hdSql := 'update MCSEND set Status = 1 where MtInMsgId = ' + Quotedstr(Chartohex(Buffer.Mt.MtInMsgId)) + ' and gateid = ' + inttostr(GSMSCENTERCONFIG.GateId);
      end
      else
      begin
        //Ӧ������
        strSql := 'insert into OUTMT (L2CMtMsgType, MoOutMsgId, MoInMsgId, MtGateId, MoLinkId, MtSpAddr, MtUserAddr, MtFeeAddr, L2CMtServiceId, MtMsgFmt, MtValidTime, MtAtTime, MtMsgLenth, MtMsgContent, MtReserve, MtInMsgId, MtLogicId, ';
        strSql := strSql + 'PrePrcResult, OutMsgType, OutServiceID, OutFeeType, OutFixedFee, OutFeeCode, RealFeeCode, C2GRecTime, OUTStatus, OutMtMsgid, OutPrced, OutPrcTimes, OutLastprctime) values (';
        strSql := strSql + inttostr(Buffer.Mt.MtMsgType) + ',';
        strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MoOutMsgId)) + ',';
        strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MoInMsgId)) + ',';
        strSql := strSql + inttostr(GSMSCENTERCONFIG.GateId) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MoLinkId) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtSpAddr) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtUserAddr) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtFeeAddr) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtServiceId) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtMsgFmt) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtValidTime) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtAtTime) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtMsgLenth) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtMsgContent) + ',';
        strSql := strSql + Quotedstr(Buffer.Mt.MtReserve) + ',';
        strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MtInMsgId)) + ',';
        strSql := strSql + inttostr(Buffer.Mt.MtLogicId) + ',';
        strSql := strSql + inttostr(Buffer.PrePrcResult) + ',';
        strSql := strSql + inttostr(Buffer.OutMsgType) + ',';
        strSql := strSql + Quotedstr(Buffer.OutServiceID) + ',';
        strSql := strSql + Quotedstr(Buffer.OutFeeType) + ',';
        strSql := strSql + Quotedstr(Buffer.OutFixedFee) + ',';
        strSql := strSql + Quotedstr(Buffer.OutFeeCode) + ',';
        strSql := strSql + inttostr(Buffer.RealFeeCode) + ',';
        strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ',';
        strSql := strSql + inttostr(Buffer.Status) + ',';
        strSql := strSql + Quotedstr(Chartohex(Buffer.OutMtMsgid)) + ',';
        strSql := strSql + inttostr(Buffer.Prced) + ',';
        strSql := strSql + inttostr(Buffer.PrcTimes) + ',';
        strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.LastPrcTime));
        strSql := strSql + ')';
      end;
    end
    else
    begin
      //Ӧ��ʧ�ܻ�Ԥ�������
      strSql := 'insert into OUTERRMTLOG (L2CMtMsgType, MoOutMsgId, MoInMsgId, MtGateId, MoLinkId, MtSpAddr, MtUserAddr, MtFeeAddr, L2CMtServiceId, MtMsgFmt, MtValidTime, MtAtTime, MtMsgLenth, MtMsgContent, MtReserve, MtInMsgId, MtLogicId, ';
      strSql := strSql + 'PrePrcResult, OutMsgType, OutServiceID, OutFeeType, OutFixedFee, OutFeeCode, RealFeeCode, C2GRecTime, OUTStatus, OutMtMsgid, OutPrced, OutPrcTimes, OutLastprctime) values (';
      strSql := strSql + inttostr(Buffer.Mt.MtMsgType) + ',';
      strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MoOutMsgId)) + ',';
      strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MoInMsgId)) + ',';
      strSql := strSql + inttostr(GSMSCENTERCONFIG.GateId) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MoLinkId) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtSpAddr) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtUserAddr) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtFeeAddr) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtServiceId) + ',';
      strSql := strSql + inttostr(Buffer.Mt.MtMsgFmt) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtValidTime) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtAtTime) + ',';
      strSql := strSql + inttostr(Buffer.Mt.MtMsgLenth) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtMsgContent) + ',';
      strSql := strSql + Quotedstr(Buffer.Mt.MtReserve) + ',';
      strSql := strSql + Quotedstr(Chartohex(Buffer.Mt.MtInMsgId)) + ',';
      strSql := strSql + inttostr(Buffer.Mt.MtLogicId) + ',';
      strSql := strSql + inttostr(Buffer.PrePrcResult) + ',';
      strSql := strSql + inttostr(Buffer.OutMsgType) + ',';
      strSql := strSql + Quotedstr(Buffer.OutServiceID) + ',';
      strSql := strSql + Quotedstr(Buffer.OutFeeType) + ',';
      strSql := strSql + Quotedstr(Buffer.OutFixedFee) + ',';
      strSql := strSql + Quotedstr(Buffer.OutFeeCode) + ',';
      strSql := strSql + inttostr(Buffer.RealFeeCode) + ',';
      strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ',';
      strSql := strSql + inttostr(Buffer.Status) + ',';
      strSql := strSql + Quotedstr(Chartohex(Buffer.OutMtMsgid)) + ',';
      strSql := strSql + inttostr(Buffer.Prced) + ',';
      strSql := strSql + inttostr(Buffer.PrcTimes) + ',';
      strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.LastPrcTime));
      strSql := strSql + ')';
      if Buffer.Mt.MtLogicId = 1 then
      begin
        //Ⱥ��
        qfSql := 'update MTSEND set Status = 2 where MtInMsgId = ' + Quotedstr(Chartohex(Buffer.Mt.MtInMsgId)) + ' and gateid = ' + inttostr(GSMSCENTERCONFIG.GateId);
      end
      else if Buffer.Mt.MtLogicId = 2 then
      begin
        //����
      end
      else if Buffer.Mt.MtLogicId = 3 then
      begin
        //ϵͳ��Ϣ
      end
      else
      begin
        //����ҵ����Ҫ���ɴ���״̬����
        CreateRpt(Buffer);
      end;
    end;

    try
      AdoConnection.Execute(strSql);
      mtbuffer.LogBuffers.Delete(logseqid);

      if qfSql <> '' then
      begin
        AdoConnection.Execute(qfSql);
      end;

      if hdSql <> '' then
      begin
        AdoConnection.Execute(hdSql);
      end;
    except
      on e: exception do
      begin
        AddMsgToMemo('MT��־�쳣:' + e.Message);

        if e.Message = '����ʧ��' then
        begin
          AdoConnection.Close;
        end;
      end;
    end;
  end;
end;

procedure TLogThreadObj.LogRpt;
var
  logseqid: integer;
  strSql: string;
  Buffer: TRptBuffer;
  MtOutMsgId: string;
  MtOutSubDate: string;
  MtOutDonDate: string;
  MtOutStat: string;
  MtOutErr: string;
  Rpt: TSMGP13RPT;
  MtInMsgId: string;
  MtLogicId: Cardinal;
  MtSpAddr: string;
  MtUserAddr: string;
begin
  logseqid := rptbuffer.Get;
  if logseqid > 0 then
  begin
    //ȡ��һ�����
    Buffer := rptbuffer.Read(logseqid);

    ZeroMemory(@Rpt, sizeof(Rpt));
    Move(Buffer.Rpt.MsgContent, Rpt, Buffer.Rpt.MsgLength);

    MtOutMsgId := Chartohex(Rpt.ID); //ת��16����
    MtOutSubDate := Rpt.SUBMITDATE;
    MtOutDonDate := Rpt.DONEDATE;
    MtOutStat := Rpt.stat;
    MtOutErr := Rpt.Err;

    strSql := 'select * from OUTMT where OutMtMsgid = ' + Quotedstr(MtOutMsgId);
    AdoQuery.Close;
    AdoQuery.SQL.Text := strSql;
    AdoQuery.Open;
    if not AdoQuery.Eof then
    begin
      MtInMsgId := AdoQuery.fieldbyname('MtInMsgId').AsString;
      MtLogicId := AdoQuery.fieldbyname('MtLogicId').AsInteger;
      MtSpAddr := AdoQuery.fieldbyname('MtSpAddr').AsString;
      MtUserAddr := AdoQuery.fieldbyname('MtUserAddr').AsString;

      if MtLogicId = 1 then
      begin
        //Ⱥ��
        if MtOutStat = 'DELIVRD' then
        begin
          strSql := 'update mtsend set Status = 1 where MtInMsgId = ' + Quotedstr(AdoQuery.fieldbyname('MtInMsgId').AsString) + ' and gateid = ' + inttostr(GSMSCENTERCONFIG.GateId);
          AdoConnection.Execute(strSql);
        end
        else
        begin
          strSql := 'update mtsend set Status = 2 where MtInMsgId = ' + Quotedstr(AdoQuery.fieldbyname('MtInMsgId').AsString) + ' and gateid = ' + inttostr(GSMSCENTERCONFIG.GateId);
          AdoConnection.Execute(strSql);
        end;
      end;

      if MtLogicId = 2 then
      begin
        //����
        if MtOutStat = 'DELIVRD' then
        begin
          strSql := 'update mcsend set Status = 1 where MtInMsgId = ' + Quotedstr(AdoQuery.fieldbyname('MtInMsgId').AsString) + ' and gateid = ' + inttostr(GSMSCENTERCONFIG.GateId);
          AdoConnection.Execute(strSql);
        end
        else
        begin
          strSql := 'update mcsend set Status = 2 where MtInMsgId = ' + Quotedstr(AdoQuery.fieldbyname('MtInMsgId').AsString) + ' and gateid = ' + inttostr(GSMSCENTERCONFIG.GateId);
          AdoConnection.Execute(strSql);
        end;
      end;

      if MtOutStat = 'DELIVRD' then
      begin
        strSql := 'insert into OUTMTLOG (L2CMtMsgType, MoOutMsgId, MoInMsgId, MtGateId, MoLinkId, MtSpAddr, MtUserAddr, MtFeeAddr, L2CMtServiceId, MtMsgFmt, MtValidTime, MtAtTime, MtMsgLenth, MtMsgContent, MtReserve, MtInMsgId, MtLogicId, ';
        strSql := strSql + 'PrePrcResult, OutMsgType, OutServiceID, OutFeeType, OutFixedFee, OutFeeCode, RealFeeCode, C2GRecTime, OUTStatus, OutMtMsgid, OutPrced, OutPrcTimes, OutLastprctime, OutRptSubDate, OutRptDonDate, OutRptStat, OutRptErr, OutRptRecTime) values (';
        strSql := strSql + AdoQuery.fieldbyname('L2CMtMsgType').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MoOutMsgId').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MoInMsgId').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtGateId').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MoLinkId').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtSpAddr').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtUserAddr').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtFeeAddr').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('L2CMtServiceId').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtMsgFmt').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtValidTime').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtAtTime').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtMsgLenth').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtMsgContent').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtReserve').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtInMsgId').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtLogicId').AsString + ',';
        strSql := strSql + AdoQuery.fieldbyname('PrePrcResult').AsString + ',';
        strSql := strSql + AdoQuery.fieldbyname('OutMsgType').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutServiceID').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutFeeType').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutFixedFee').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutFeeCode').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('RealFeeCode').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('C2GRecTime').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('OUTStatus').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutMtMsgid').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('OutPrced').AsString + ',';
        strSql := strSql + AdoQuery.fieldbyname('OutPrcTimes').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutLastprctime').AsString) + ',';
        strSql := strSql + Quotedstr(MtOutSubDate) + ',';
        strSql := strSql + Quotedstr(MtOutDonDate) + ',';
        strSql := strSql + Quotedstr(MtOutStat) + ',';
        strSql := strSql + Quotedstr(MtOutErr) + ',';
        strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ')';
      end
      else
      begin
        strSql := 'insert into OUTERRMTLOG (L2CMtMsgType, MoOutMsgId, MoInMsgId, MtGateId, MoLinkId, MtSpAddr, MtUserAddr, MtFeeAddr, L2CMtServiceId, MtMsgFmt, MtValidTime, MtAtTime, MtMsgLenth, MtMsgContent, MtReserve, MtInMsgId, MtLogicId, ';
        strSql := strSql + 'PrePrcResult, OutMsgType, OutServiceID, OutFeeType, OutFixedFee, OutFeeCode, RealFeeCode, C2GRecTime, OUTStatus, OutMtMsgid, OutPrced, OutPrcTimes, OutLastprctime, OutRptSubDate, OutRptDonDate, OutRptStat, OutRptErr, OutRptRecTime) values (';
        strSql := strSql + AdoQuery.fieldbyname('L2CMtMsgType').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MoOutMsgId').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MoInMsgId').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtGateId').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MoLinkId').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtSpAddr').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtUserAddr').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtFeeAddr').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('L2CMtServiceId').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtMsgFmt').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtValidTime').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtAtTime').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtMsgLenth').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtMsgContent').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtReserve').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('MtInMsgId').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('MtLogicId').AsString + ',';
        strSql := strSql + AdoQuery.fieldbyname('PrePrcResult').AsString + ',';
        strSql := strSql + AdoQuery.fieldbyname('OutMsgType').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutServiceID').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutFeeType').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutFixedFee').AsString) + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutFeeCode').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('RealFeeCode').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('C2GRecTime').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('OUTStatus').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutMtMsgid').AsString) + ',';
        strSql := strSql + AdoQuery.fieldbyname('OutPrced').AsString + ',';
        strSql := strSql + AdoQuery.fieldbyname('OutPrcTimes').AsString + ',';
        strSql := strSql + Quotedstr(AdoQuery.fieldbyname('OutLastprctime').AsString) + ',';
        strSql := strSql + Quotedstr(MtOutSubDate) + ',';
        strSql := strSql + Quotedstr(MtOutDonDate) + ',';
        strSql := strSql + Quotedstr(MtOutStat) + ',';
        strSql := strSql + Quotedstr(MtOutErr) + ',';
        strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ')';
      end;

      AdoQuery.Close;

      try
        AdoConnection.Execute(strSql);
        AdoConnection.Execute('delete OUTMT where OutMtMsgid = ' + Quotedstr(MtOutMsgId));
        rptbuffer.UpdateMsgId(logseqid, MtInMsgId, MtLogicId, MtSpAddr, MtUserAddr);
      except
        on e: exception do
        begin
          rptbuffer.Update(logseqid);
          AddMsgToMemo('RPT��־�쳣' + e.Message);
          if e.Message = '����ʧ��' then
          begin
            AdoConnection.Close;
          end;
        end;
      end;
    end
    else
    begin
      rptbuffer.Update(logseqid);
    end;
  end;
end;

procedure TLogThreadObj.ThAddMsgToMemo;
begin
  if MainForm <> nil then
  begin
    MainForm.ShowToMemo(ErrMsg, MainForm.MonitorMemo);
  end;
end;

procedure TMainForm.OutListViewAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: boolean);
begin
  try
    DefaultDraw := True;
    with OutListview.Canvas do
    begin
      lock;
      if Item.Index mod 2 = 0 then
        Brush.Color := clWhite
      else
        Brush.Color := TColor($C0C0C0);
      unlock;
    end;
  except
  end;
end;

procedure TMainForm.OutListViewDblClick(Sender: TObject);
var
  li: TListItem;
  p: TOutPacket;
  Rpt: TSMGP13RPT;
  temp: array[0..119] of char;
begin
  try
    if OutListview.Selected = nil then exit;
    li := OutListview.Selected;
    p := TOutPacket(li.Data);
    OutPMemo.Text := '';
    OutPMemo.Lines.Add('[PacketLength]' + inttostr(p.pac.MsgHead.PacketLength));
    OutPMemo.Lines.Add('[RequestID]' + inttostr(p.pac.MsgHead.RequestID));
    OutPMemo.Lines.Add('[SequenceID]' + inttostr(p.pac.MsgHead.SequenceID));

    case p.pac.MsgHead.RequestID of
      SMGP13_LOGIN:
        begin
          OutPMemo.Lines.Add('[ClientID]' + p.pac.MsgBody.LOGIN.ClientID);
          OutPMemo.Lines.Add('[AuthenticatorClient]' + Chartohex(p.pac.MsgBody.LOGIN.AuthenticatorClient));
          OutPMemo.Lines.Add('[LoginMode]' + inttostr(p.pac.MsgBody.LOGIN.LoginMode));
          OutPMemo.Lines.Add('[TimeStamp]' + inttostr(p.pac.MsgBody.LOGIN.TimeStamp));
          OutPMemo.Lines.Add('[Version]' + inttostr(p.pac.MsgBody.LOGIN.Version));
        end;

      SMGP13_LOGIN_RESP:
        begin
          OutPMemo.Lines.Add('[Status]' + inttostr(p.pac.MsgBody.LOGIN_RESP.Status));
          OutPMemo.Lines.Add('[AuthenticatorServer]' + p.pac.MsgBody.LOGIN_RESP.AuthenticatorServer);
          OutPMemo.Lines.Add('[Version]' + inttostr(p.pac.MsgBody.LOGIN_RESP.Version));
        end;

      SMGP13_SUBMIT:
        begin
          OutPMemo.Lines.Add('[MsgType]' + inttostr(p.pac.MsgBody.SUBMIT.MsgType));
          OutPMemo.Lines.Add('[NeedReport]' + inttostr(p.pac.MsgBody.SUBMIT.NeedReport));
          OutPMemo.Lines.Add('[Priority]' + inttostr(p.pac.MsgBody.SUBMIT.Priority));
          OutPMemo.Lines.Add('[ServiceID]' + (p.pac.MsgBody.SUBMIT.ServiceID));
          OutPMemo.Lines.Add('[FeeType]' + (p.pac.MsgBody.SUBMIT.FeeType));
          OutPMemo.Lines.Add('[FixedFee]' + (p.pac.MsgBody.SUBMIT.FixedFee));
          OutPMemo.Lines.Add('[FeeCode]' + (p.pac.MsgBody.SUBMIT.FeeCode));
          OutPMemo.Lines.Add('[MsgFormat]' + inttostr(p.pac.MsgBody.SUBMIT.MsgFormat));
          OutPMemo.Lines.Add('[ValidTime]' + (p.pac.MsgBody.SUBMIT.ValidTime));
          OutPMemo.Lines.Add('[AtTime]' + (p.pac.MsgBody.SUBMIT.AtTime));
          OutPMemo.Lines.Add('[SrcTermID]' + (p.pac.MsgBody.SUBMIT.SrcTermID));
          OutPMemo.Lines.Add('[ChargeTermID]' + (p.pac.MsgBody.SUBMIT.ChargeTermID));
          OutPMemo.Lines.Add('[DestTermIDCount]' + inttostr(p.pac.MsgBody.SUBMIT.DestTermIDCount));
          OutPMemo.Lines.Add('[DestTermID]' + (p.pac.MsgBody.SUBMIT.DestTermID));
          OutPMemo.Lines.Add('[MsgLength]' + inttostr(p.pac.MsgBody.SUBMIT.MsgLength));
          OutPMemo.Lines.Add('[MsgContent]' + (p.pac.MsgBody.SUBMIT.MsgContent));
          OutPMemo.Lines.Add('[Reserve]' + (p.pac.MsgBody.SUBMIT.Reserve));
        end;

      SMGP13_SUBMIT_RESP:
        begin
          OutPMemo.Lines.Add('[MsgID]' + Chartohex(p.pac.MsgBody.SUBMIT_RESP.MsgID));
          OutPMemo.Lines.Add('[Status]' + inttostr(p.pac.MsgBody.SUBMIT_RESP.Status));
        end;

      SMGP13_DELIVER:
        begin
          OutPMemo.Lines.Add('[MsgID]' + Chartohex(p.pac.MsgBody.DELIVER.MsgID));
          OutPMemo.Lines.Add('[IsReport]' + inttostr(p.pac.MsgBody.DELIVER.IsReport));
          OutPMemo.Lines.Add('[MsgFormat]' + inttostr(p.pac.MsgBody.DELIVER.MsgFormat));
          OutPMemo.Lines.Add('[RecvTime]' + p.pac.MsgBody.DELIVER.RecvTime);
          OutPMemo.Lines.Add('[SrcTermID]' + p.pac.MsgBody.DELIVER.SrcTermID);
          OutPMemo.Lines.Add('[DestTermID]' + p.pac.MsgBody.DELIVER.DestTermID);
          OutPMemo.Lines.Add('[MsgLength]' + inttostr(p.pac.MsgBody.DELIVER.MsgLength));
          if p.pac.MsgBody.DELIVER.IsReport = 0 then
          begin
            OutPMemo.Lines.Add('[MsgContent]' + p.pac.MsgBody.DELIVER.MsgContent);
          end
          else
          begin
            Move(p.pac.MsgBody.DELIVER.MsgContent, Rpt, sizeof(Rpt));
            Move(p.pac.MsgBody.DELIVER.MsgContent[13], temp, sizeof(temp));
            OutPMemo.Lines.Add('[MsgContent]' + Rpt.TID + Chartohex(Rpt.ID) + temp);
          end;
          OutPMemo.Lines.Add('[Reserve]' + p.pac.MsgBody.DELIVER.Reserve);
        end;

      SMGP13_DELIVER_RESP:
        begin
          OutPMemo.Lines.Add('[MsgID]' + Chartohex(p.pac.MsgBody.DELIVER_RESP.MsgID));
          OutPMemo.Lines.Add('[Status]' + inttostr(p.pac.MsgBody.DELIVER_RESP.Status));
        end;

      SMGP13_ACTIVE_TEST:
        begin

        end;

      SMGP13_ACTIVE_TEST_RESP:
        begin

        end;
    end;
  except
  end;
end;


procedure TMainForm.N7Click(Sender: TObject);
begin
  try
    LoadServiceCode;
    LoadProtocol;
  except
  end;
end;

procedure TMainForm.InListViewAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: boolean);
begin
  { try
     DefaultDraw := True;
     with InListview.Canvas do
     begin
       lock;
       if Item.Index mod 2 = 0 then
         Brush.Color := clWhite
       else
         Brush.Color := TColor($C0C0C0);
       unlock;
     end;
   except
   end;  }
end;


procedure TMainForm.N9Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MonitorTimerTimer(Sender: TObject);
var
  bad: boolean;
begin
  smcmo0;
  smcmt;
  smcmo;
end;

procedure TMainForm.MonitorMemoChange(Sender: TObject);
begin
  try
    if MonitorMemo.Lines.Count > 200 then
    begin
      MonitorMemo.Lines.SaveToFile('ErrLog\' + FormatDatetime('yyyymmddhhnnss', now()) + '.log');
      MonitorMemo.Clear;
    end;
  except
  end;
end;

procedure TMainForm.N11Click(Sender: TObject);
var
  i: integer;
begin
  try
    for i := 0 to OutListview.Items.Count - 1 do
    begin
      TOutPacket(OutListview.Items[i].Data).Free;
      OutListview.Items[i].Data := nil;
    end;

    OutListview.Items.BeginUpdate;
    try
      OutListview.Clear;
    finally
      OutListview.Items.EndUpdate;
    end;
  except
  end;
end;

procedure TMtQfThread.ConnectDB;
begin
  if false {ADOConnection.Connected = false} then
  begin
    AdoConnection.ConnectionString := 'Provider=SQLOLEDB.1;Password='
      + GDBCONFIG.Pass
      + ';Persist Security Info=True;Application Name='
      + GSMSCENTERCONFIG.GateDesc
      + ';User ID='
      + GDBCONFIG.User
      + ';Initial Catalog='
      + GDBCONFIG.TnsName
      + ';Data Source='
      + GDBCONFIG.Address;
    try
      AdoConnection.Open();
    except
      on e: exception do
      begin
        AddMsgToMemo('��־�߳����ݿ�����ʧ��');
        AddMsgToMemo(e.Message);
      end;
    end;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  try
    if now - OutLastConnectTime > 5 / 3600 / 24 then
    begin
      SMGPTCPClient.CheckForGracefulDisconnect(false);
      if SMGPTCPClient.Connected then
      begin
        OutLastConnectTime := now;
      end
      else
      begin
        SMGPTCPClient.Host := GGATECONFIG.RemoteIp;
        SMGPTCPClient.Port := GGATECONFIG.RemotePort;
        try
          if GGATECONFIG.Smgp_Tag = 1 then
            SMGPTCPClient.Connect();
        except
          on e: exception do
          begin
            ShowToMemo('����������SMGPSMCʧ��:' + e.Message, MonitorMemo);
          end;
        end;
        OutLastConnectTime := now;
      end;
    end;

    //cmpp ���ж˿�
    if now - OutLastCMPPConnectTime > 5 / 3600 / 24 then
    begin
      CmppTCPClient.CheckForGracefulDisconnect(false);
      if CmppTCPClient.Connected then
      begin
        OutLastCMPPConnectTime := now;
      end
      else
      begin
        CmppTCPClient.Host := GGATECONFIG.cmppRemoteIp;
        CmppTCPClient.Port := GGATECONFIG.cmppRemotePort;
        try
          if GGATECONFIG.Cmpp_Tag = 1 then
            CmppTCPClient.Connect();
        except
          on e: exception do
          begin
            ShowToMemo('����������CMPPSMCʧ��:' + e.Message, MonitorMemo);
          end;
        end;
        OutLastCMPPConnectTime := now;
      end;
    end;

    //cmpp ���ж˿�
    if now - OutLastCMPP0ConnectTime > 5 / 3600 / 24 then
    begin
      Cmpp0TCPClient.CheckForGracefulDisconnect(false);
      if Cmpp0TCPClient.Connected then
      begin
        OutLastCMPP0ConnectTime := now;
      end
      else
      begin
        Cmpp0TCPClient.Host := GGATECONFIG.cmppRemoteIp;
        Cmpp0TCPClient.Port := GGATECONFIG.cmppRemotePort0;
        try
          if GGATECONFIG.Cmpp_Tag = 1 then
            Cmpp0TCPClient.Connect();
        except
          on e: exception do
          begin
            ShowToMemo('����������CMPPSMC0ʧ��:' + e.Message, MonitorMemo);
          end;
        end;
        OutLastCMPP0ConnectTime := now;
      end;
    end;

    //Sgip
    if now - OutLastSgipConnectTime > 5 / 3600 / 24 then
    begin
      SgipTCPClient.CheckForGracefulDisconnect(false);
      if SgipTCPClient.Connected then
      begin
        OutLastSgipConnectTime := now;
      end
      else
      begin
        SgipTCPClient.Host := GGATECONFIG.SgipRemoteIp;
        SgipTCPClient.Port := GGATECONFIG.SgipRemotePort;
        try
          if GGATECONFIG.Smgp_Tag = 1 then
            SgipTCPClient.Connect();
        except
          on e: exception do
          begin
            ShowToMemo('����������SMGPSMCʧ��:' + e.Message, MonitorMemo);
          end;
        end;
        OutLastSgipConnectTime := now;
      end;
    end;

  except
  end;
  MonitorTimer.Enabled := True; //��ؿ�ʼ
end;

//������Ҫ����Ϣȡ������SMC�����ص���Ϣ
procedure TMainForm.smcmo;
var
  MoSeqId: integer;
  strSql: string;
  Buffer: TMoBuffer;
begin
  MoSeqId := mobuffer.Get;
  if MoSeqId > 0 then
  begin
    Buffer := mobuffer.Read(MoSeqId);
    ConvertNull(Buffer.mo.MsgContent, Buffer.mo.MsgLength, Buffer.mo.MsgContent);
    strSql := 'insert into SmcMo (MoOutMsgId, MoInMsgId, MoSpAddr, MoUserAddr, MoMsgFmt, MoMsgLenth, MoMsgContent, MoReserve, OutRecTime, G2CED, SPPOrcTimes, G2CLastPrcTime, MoGateId,smc_tag) values (';
    strSql := strSql + Quotedstr(Chartohex(Buffer.mo.MsgID)) + ',';
    strSql := strSql + Quotedstr(Chartohex(Buffer.MoInMsgId)) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.DestTermID) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.SrcTermID) + ',';
    strSql := strSql + inttostr(Buffer.mo.MsgFormat) + ',';
    strSql := strSql + inttostr(Buffer.mo.MsgLength) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.MsgContent) + ',';
    strSql := strSql + '0' + ',';
    strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ',';
    strSql := strSql + inttostr(Buffer.Prced) + ',';
    strSql := strSql + inttostr(Buffer.PrcTimes) + ',';
    strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.LastPrcTime)) + ',';
    strSql := strSql + inttostr(GSMSCENTERCONFIG.GateId) + ',';
    strSql := strSql + inttostr(0);
    strSql := strSql + ')';
    MainForm.MOMemo.Lines.Add('MO�û����룺' + Buffer.mo.SrcTermID);
    MainForm.MOMemo.Lines.Add('MO�˿ڣ�' + Buffer.mo.DestTermID);
    MainForm.MOMemo.Lines.Add('MO���ݣ�' + Buffer.mo.MsgContent);
    try
      AdoConnection.Execute(strSql);
      mobuffer.Delete(MoSeqId);
    except
    end;
  end;
end;

procedure TMainForm.smcmo0;
var
  MoSeqId: integer;
  strSql: string;
  Buffer: TMocmppBuffer;
  strtest: string;
  i: integer;
  str0: string;
  InValue: string;
  dest_str: string;
  MSG_CON: string;
  HEXS: string;
  i0: integer;
  function DecodeWideString(Value: string): WideString;
  var
    i: integer;
  begin
    result := '';
    for i := 0 to (length(Value) div 4) - 1 do
    begin
      result := result + wchar(strtoint('$' + Value[i * 4 + 1] + Value[i * 4 + 2]) shl 8
        + strtoint('$' + Value[i * 4 + 3] + Value[i * 4 + 4]));
    end;
  end;
begin
  MoSeqId := mocmppbuffer.Get;
  if MoSeqId > 0 then
  begin
    Buffer := mocmppbuffer.Read(MoSeqId);
    ConvertNull(Buffer.mo.Msg_Content, Buffer.mo.MSG_LENGTH, Buffer.mo.Msg_Content);
    strSql := 'insert into SmcMo (MoOutMsgId, MoInMsgId, MoSpAddr, MoUserAddr, MoMsgFmt, MoMsgLenth, MoMsgContent, MoReserve, OutRecTime, G2CED, SPPOrcTimes, G2CLastPrcTime, MoGateId,smc_tag) values (';
    strSql := strSql + inttostr(Buffer.mo.Msg_Id) + ',';
    strSql := strSql + Quotedstr(Chartohex(Buffer.MoInMsgId)) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.Dest_Id) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.Src_terminal_Id) + ',';
    strSql := strSql + inttostr(Buffer.mo.Msg_Fmt) + ',';
    strSql := strSql + inttostr(Buffer.mo.MSG_LENGTH) + ',';
    strSql := strSql + Quotedstr(Buffer.mo.Msg_Content) + ',';
    strSql := strSql + '0' + ',';
    strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.RecTime)) + ',';
    strSql := strSql + inttostr(Buffer.Prced) + ',';
    strSql := strSql + inttostr(Buffer.PrcTimes) + ',';
    strSql := strSql + Quotedstr(FormatDatetime('yyyy-mm-dd hh:nn:ss:zzz', Buffer.LastPrcTime)) + ',';
    strSql := strSql + inttostr(GSMSCENTERCONFIG.GateId) + ',';
    strSql := strSql + inttostr(1);
    strSql := strSql + ')';
    MainForm.MOMemo.Lines.Add('MO�û����룺' + Buffer.mo.Src_terminal_Id);
    MainForm.MOMemo.Lines.Add('MO�˿ڣ�' + Buffer.mo.Dest_Id);
    MainForm.MOMemo.Lines.Add('MO���ݣ�' + Buffer.mo.Msg_Content);
    try
      AdoConnection.Execute(strSql);
      mocmppbuffer.Delete(MoSeqId);
    except
    end;
  end;
end;

procedure TMainForm.smcmt;
var
  MoSeqId: integer;
  strSql: string;
  strtest: string;
  querytemp: TAdoQuery;
  querytemp0: TAdoQuery;
  Buffercmpp: TMtBuffer;
  outpac: TSPPO_PACKET;
  sendbuffer: TCOMMBuffer;
  NetPacOut, LocPacOut: TSPPO_PACKET;
  pac: TSPPO_PACKET;
  Seqid: integer;
  Autoid: integer;
  MtInMsgId: string;
  spcode: string; //SP sumbit ���еı��

  function GetSeqid: Cardinal;
  begin
    result := Seqid;
    inc(Seqid);
    if Seqid >= 4294967295 then
    begin
      Seqid := 1;
    end;
  end;

  function GetInMsgId: string;
  var
    str: string;
    i: integer;
  begin
    //3λ���غ� + 14 yyyymmddhhnnss + 3���,��20
    str := copy(inttostr(GSMSCENTERCONFIG.GateId), 2, 3) + FormatDatetime('yyyymmddhhnnss', now);
    i := GetSeqid;
    if i >= 100 then
    begin
      str := str + inttostr(i);
    end
    else if i >= 10 then
    begin
      str := str + '0' + inttostr(i);
    end
    else
    begin
      str := str + '00' + inttostr(i);
    end;
    result := str;
  end;

  function GetSmsNum(sms: string): integer;
  var
    i, i1, i0: integer;
    sms0: string;
  begin
    sms0 := sms;
    i0 := 1;
    for i := 0 to 10 do
    begin
      if length(sms0) - 140 >= 0 then
      begin
        i0 := i0 + 1;
      end;
      if length(sms0) >= 140 then
      begin
        sms0 := copy(sms0, 141, length(sms0));
      end;
      //inc(i);
    end;
    result := i0;
  end;
begin
  querytemp := TAdoQuery.Create(self);
  querytemp.Connection := AdoConnection;
  querytemp0 := TAdoQuery.Create(self);
  querytemp0.Connection := AdoConnection;
  querytemp.Close;
  querytemp.SQL.Clear;
  //������ж��Ƿ����ڱ����ص� ��ȡ����
  //querytemp.SQL.Add('select * from zxsp_sendsms where zx_send_tag=''1'' and msg_src=''' + GSMSCENTERCONFIG.Gatename + ''' and port_tag=0');
  querytemp.SQL.Add('select * from sendsms where send_tag=''1''  and port_tag=0');
  //querytemp.Open;
  with querytemp do
  begin
    Close;
    try
      Open;
    except
    end;
    First;
    while not Eof do
    begin
      SetPchar(Buffercmpp.Mt.MtMsgContent, trim(fieldbyname('sms_text').AsString), sizeof(Buffercmpp.Mt.MtMsgContent));
      Buffercmpp.Mt.MtMsgLenth := length(trim(fieldbyname('sms_text').AsString));
      if length(trim(fieldbyname('sms_text').AsString)) > 140 then
      begin
      end;
      spcode := fieldbyname('code_id').AsString;
      ZeroMemory(@Buffercmpp, sizeof(TMtBuffer));
      {Buffercmpp.OutMsgType := 3;
      SetPchar(Buffercmpp.OutServiceID, trim(fieldbyname('sms_ywcode').AsString), sizeof(Buffercmpp.OutServiceID));
      Buffercmpp.OutFeeType := '01'; //
      Buffercmpp.OutFixedFee := '00';
      Buffercmpp.OutFeeCode := '000000';   }
      SetPchar(Buffercmpp.Mt.OutServiceID, trim(fieldbyname('sms_ywcode').AsString), sizeof(Buffercmpp.Mt.OutServiceID));
      Buffercmpp.Mt.OutFeeType := '01'; //
      Buffercmpp.Mt.OutFixedFee := '00';
      Buffercmpp.Mt.OutFeeCode := '000000';
      Buffercmpp.Mt.MtMsgFmt := 15;
      Buffercmpp.Mt.MtValidTime := '20051222140000';
      Buffercmpp.Mt.MtAtTime := '20051222140000';
      //�˿ں�
      SetPchar(Buffercmpp.Mt.MtSpAddr, trim(fieldbyname('source_num').AsString), sizeof(Buffercmpp.Mt.MtSpAddr));
      //SP_ID
      SetPchar(Buffercmpp.Mt.msg_src, trim(fieldbyname('msg_src').AsString), sizeof(Buffercmpp.Mt.msg_src));
      //Buffer.Mt.MtFeeAddr :='13883722170';
      //Buffer.Mt.MtUserAddr :='13883722170';
      //SetPchar ����ǰ�һ���ַ�����ֵ��һ�� ������ֵ
      SetPchar(Buffercmpp.Mt.MtUserAddr, trim(fieldbyname('sms_mob').AsString), sizeof(Buffercmpp.Mt.MtUserAddr));
      SetPchar(Buffercmpp.Mt.MtFeeAddr, trim(fieldbyname('sms_mob').AsString), sizeof(Buffercmpp.Mt.MtFeeAddr));
      Buffercmpp.Mt.MtMsgLenth := length(trim(fieldbyname('sms_text').AsString));
      SetPchar(Buffercmpp.Mt.MtMsgContent, trim(fieldbyname('sms_text').AsString), sizeof(Buffercmpp.Mt.MtMsgContent));
      ZeroMemory(@outpac, sizeof(TSPPO_PACKET));
      outpac.Head.CmdId := htonl(SPPO_MT);
      outpac.Head.Seqid := htonl(Seqid);
      //outpac.Head.Seqid := htonl(fieldbyname('zx_code_id').AsVariant);
      outpac.Head.length := htonl(sizeof(TSPPO_HEAD) + sizeof(TSPPO_MT) - sizeof(outpac.Body.Mt.MtMsgContent) + Buffercmpp.Mt.MtMsgLenth);
      Move(Buffercmpp.Mt, outpac.Body.Mt, sizeof(Buffercmpp.Mt));
      case fieldbyname('smc_tag').AsInteger of
        0:
          begin
            mtbuffer.Add(outpac);
          end;
        1: //�ƶ�
          begin
            mtcmppbuffer.Add(outpac);
          end;
        2:
          begin
          end;
      end;
      with querytemp0 do
      begin
        Close;
        SQL.Clear;
        SQL.Add('update sendsms set  send_tag=''2'' where code_id =''' + spcode + '''');
        ExecSql;
      end;
      next;
    end;
  end;
  querytemp.Free;
  querytemp0.Free;
end;

procedure TMainForm.LoadProtocol;
var
  strSql: string;
  i: integer;
begin
  if AdoConnection.Connected then
  begin
    strSql := 'select Serviceid,msgtype,gatefeetype,gatefeecode,gatemsgtype,gatefixfee,realfeecode from ProtocolView where gateid = ' + inttostr(GSMSCENTERCONFIG.GateId);
    AdoQuery.Close;
    AdoQuery.SQL.Text := strSql;
    AdoQuery.Open;
    if high(Protocol) = -1 then
    begin
      setlength(Protocol, AdoQuery.RecordCount);
    end
    else
    begin
      Protocol := nil;
      setlength(Protocol, AdoQuery.RecordCount);
    end;
    i := 0;
    while not AdoQuery.Eof do
    begin
      SetPchar(Protocol[i].GateCode, AdoQuery.fieldbyname('Serviceid').AsString, sizeof(ServiceCode[i].GateCode));
      Protocol[i].MsgType := AdoQuery.fieldbyname('msgtype').AsInteger;
      SetPchar(Protocol[i].GateFeeType, AdoQuery.fieldbyname('gatefeetype').AsString, sizeof(Protocol[i].GateFeeType));
      SetPchar(Protocol[i].gatefeecode, AdoQuery.fieldbyname('gatefeecode').AsString, sizeof(Protocol[i].gatefeecode));
      SetPchar(Protocol[i].gatefeecode, AdoQuery.fieldbyname('gatefeecode').AsString, sizeof(Protocol[i].gatefeecode));
      Protocol[i].GateMsgType := AdoQuery.fieldbyname('GateMsgType').AsInteger;
      SetPchar(Protocol[i].GateFixFee, AdoQuery.fieldbyname('GateFixFee').AsString, sizeof(Protocol[i].GateFixFee));
      Protocol[i].RealFeeCode := AdoQuery.fieldbyname('realfeecode').AsInteger;
      inc(i);
      AdoQuery.MoveBy(1);
    end;
    AdoQuery.Close;
  end;
end;

procedure TMainForm.N3Click(Sender: TObject);
begin
  try
    LoadProtocol;
  except
  end;
end;


procedure TMainForm.CmppTCPClientConnected(Sender: TObject);
begin
  try
    if MtSendCMPPThread <> nil then
    begin
      MtSendCMPPThread.Terminate;
      MtSendCMPPThread := nil;
    end;
    if OutReadCMPPThread <> nil then
    begin
      OutReadCMPPThread.Terminate;
      OutReadCMPPThread := nil;
    end;
    OutReadCMPPThread := TOutReadCMPPThreadObj.Create(True);
    OutReadCMPPThread.FTCPCmppClient := CmppTCPClient;
    OutReadCMPPThread.Resume;
    MtSendCMPPThread := TMtSendCMPPThreadObj.Create(True);
    MtSendCMPPThread.Resume;
  except

  end;
end;

procedure TMainForm.CmppTCPClientDisconnected(Sender: TObject);
begin
  try
    ShowToMemo('CMPP�����ѶϿ�', MonitorMemo);
    if MtSendCMPPThread <> nil then
    begin
      MtSendCMPPThread.Terminate;
      MtSendCMPPThread := nil;
    end;
    if OutReadCMPPThread <> nil then
    begin
      OutReadCMPPThread.Terminate;
      OutReadCMPPThread := nil;
    end;
  except
  end;
end;

procedure TMainForm.Cmpp0TCPClientConnected(Sender: TObject);
begin
  try
    if MtSendCMPP0Thread <> nil then
    begin
      MtSendCMPP0Thread.Terminate;
      MtSendCMPP0Thread := nil;
    end;
    if OutReadCMPP0Thread <> nil then
    begin
      OutReadCMPP0Thread.Terminate;
      OutReadCMPP0Thread := nil;
    end;
    OutReadCMPP0Thread := TOutReadCMPP0ThreadObj.Create(True);
    OutReadCMPP0Thread.FTCPCmppClient := Cmpp0TCPClient;
    OutReadCMPP0Thread.Resume;
    MtSendCMPP0Thread := TMtSendCMPP0ThreadObj.Create(True);
    MtSendCMPP0Thread.Resume;
  except

  end;
end;

procedure TMainForm.Cmpp0TCPClientDisconnected(Sender: TObject);
begin
  try
    ShowToMemo('CMPP0�����ѶϿ�', MonitorMemo);
    if MtSendCMPP0Thread <> nil then
    begin
      MtSendCMPP0Thread.Terminate;
      MtSendCMPP0Thread := nil;
    end;

    if OutReadCMPP0Thread <> nil then
    begin
      OutReadCMPP0Thread.Terminate;
      OutReadCMPP0Thread := nil;
    end;
  except
  end;
end;

procedure TMainForm.SgipTCPClientConnected(Sender: TObject);
begin
  try
    if MtSendSgipThread <> nil then
    begin
      MtSendSgipThread.Terminate;
      MtSendSgipThread := nil;
    end;

    if OutReadSgipThread <> nil then
    begin
      OutReadSgipThread.Terminate;
      OutReadSgipThread := nil;
    end;
    OutReadSgipThread := TOutReadSgipThreadObj.Create(True);
    OutReadSgipThread.FTCPClient := SgipTCPClient;
    OutReadSgipThread.Resume;
    MtSendSgipThread := TMtSendSgipThreadObj.Create(True);
    MtSendSgipThread.Resume;
  except

  end;
end;

procedure TMainForm.SgipTCPClientDisconnected(Sender: TObject);
begin
  try
    ShowToMemo('Sgip�����ѶϿ�', MonitorMemo);
    if MtSendSgipThread <> nil then
    begin
      MtSendSgipThread.Terminate;
      MtSendSgipThread := nil;
    end;
    if OutReadSgipThread <> nil then
    begin
      OutReadSgipThread.Terminate;
      OutReadSgipThread := nil;
    end;
  except
  end;
end;

end.

