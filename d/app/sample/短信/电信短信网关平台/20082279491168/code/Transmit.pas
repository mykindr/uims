{������������������������������������������������}
{                  Transmit�߳�(�շ�ģʽ)        }
{                    Author:  LUOXINXI           }
{                    DateTime: 2004/7/28         }
{������������������������������������������������}
unit Transmit;

interface
uses
  Windows, classes, Sockets, U_MsgInfo, Smgp13_XML, U_RequestID, Htonl, SysUtils,
  winsock, ScktComp, md5, NetDisconnect, DateUtils,strutils;

{�շ� Thread}
type
  TTransmit = class(TThread)
  private
    CTDeliver: TTcpClient; //socket ����
    Statustr: string;
    StatuTxt: string;
    StatustrE: string;
    fsleeptime: integer;
    ClientID: string;
    sharesecret: string;
    loginmode: byte;
    timeout: integer;
    HadLogin: boolean;
    Active_test_time: TDateTime; //integer;
    Warnning: byte;
    resptime, sendtimes: integer;
    ErrWarnning: TWarnning; //������·����ʱ����
    CTSubmit_Resp: TSMGPDeliver_Resp; //��������
    SocketBuff: array of char;
    SockCanExit: boolean;
    ReceiveDeliverTime: TDateTime;
  protected
    procedure Execute; override;
    procedure LoginCT; {��½����}
    function ExitCT: boolean; {�˳�����}

    procedure ReceiveHead;
    procedure ReceiveBody(CTRequestID, CTsequence, Len: Longword);

    procedure ActiveTest; {��·����}
    procedure ActiveTest_Resp(CTsequence: Longword); {��·���Իظ�}
    procedure SocketError(Sender: TObject;
      SocketError: integer);
    procedure SP_Deliver_Resp(Msg_id: array of char; SequenceID: Longword); {���лظ�}
    procedure WriteReport(const Msgid: array of char; const Source: array of char); {д״̬����}
    procedure SaveToDeliverList(aDeliver: TCTDeliver; const LinkID:string); {�������ж���}
    procedure ShowDeliver(aDeliver: TCTDeliver; const LinkID:string); {���а���¼}
    function SP_Submit: boolean; {���ж���}
    procedure ReSubmit(SequenceID: Longword; statu: Longword); {�ط�}
    function DeleteMT(SequenceID: Longword; var aMid: string): boolean; {ɾ�����ж��Ż���������,����MID}
    function MakeSockBuff(var SubmitLen: integer; rSubmit: xSubmit): Longword; //����socket������Ϣ ����ֵ�Ǹ���Ϣ���к�
    procedure NoResponse_Resubmit; //��ָ��ʱ��û�з��ػ���������ط�
    procedure upmemo;
    procedure showError;
    procedure showstatu;
    procedure AddsSeq;
    procedure AddCou;

    procedure ReceiveDeliver(CTsequence, Len: Longword);
    function ReceiveTLVMsg(const MsgLen:integer;var LinkID:string;var DealReslt:byte):byte;// SubmitMsgType.value
    procedure AddSyncOrdCelMsg(aDeliver: TCTDeliver;const LinkID:string);
    procedure DealWithSyncMsgCont(const msgcontent:string; var ServiceID, MsgContPart:string);
    function GetInstruct(const msgcontent:string):string;
  public
    constructor create(xCT_IP, xCT_port, xClientID, xsharesecret: string; xsleeptime, xtimeout, xresptime, xsendtimes: integer; xloginmode: byte); virtual;
    destructor destroy; override;
  end;

implementation
uses U_Main;

{ TCPCTDeliver }
constructor TTransmit.create(xCT_IP, xCT_port, xClientID, xsharesecret: string; xsleeptime, xtimeout, xresptime, xsendtimes: integer; xloginmode: byte);
begin
  inherited create(True);
  FreeOnTerminate := True;
  CTDeliver := TTcpClient.create(nil);
  CTDeliver.RemoteHost := xCT_IP;
  CTDeliver.RemotePort := xCT_port;
  CTDeliver.OnError := SocketError;
  ClientID := xClientID;
  sharesecret := xsharesecret;
  fsleeptime := xsleeptime;
  timeout := xtimeout;
  loginmode := xloginmode;
  sendtimes := xsendtimes;
  loginmode := xloginmode;
  StatuTxt := '��' + datetimetostr(now) + '���շ��̴߳���,�������ط�����' + xCT_IP + ',ThreadID:' + inttostr(self.ThreadID);
  synchronize(showstatu);
  Resume;
end;

destructor TTransmit.destroy;
begin
  StopCatchSMS := True;
  FreeAndNil(CTDeliver);
  SocketBuff := nil;
  StatuTxt := '��' + datetimetostr(now) + '���շ��߳���ֹ,ThreadID:' + inttostr(self.ThreadID);
  synchronize(showstatu);
  LogList.AddLog('10' + StatuTxt);
  SMGPGateWay.Label8.Caption := 'Warning:�շ��߳�ֹͣ';
  inherited;
end;
procedure TTransmit.Execute;
begin
  HadLogin := False;
  Warnning := 0;
  while not Terminated do
  try
    if not HadLogin then
    begin
      if TransmitExit then
      begin
        TransmitExit := False;
        break;
      end;
      LoginCT; //��½
    end
    else
    begin //�Ѿ���½
      if TransmitExit then //��������˳�����
      begin
        if HadLogin then
        begin
          ExitCT; //�����˳�����
        end
        else
        begin
          TransmitExit := False;
          break;
        end;
      end
      else
      begin
        NoResponse_Resubmit;
        if not SP_Submit then
          ActiveTest; //������·����
      end;
      ReceiveHead; //���հ�ͷ ���ý��հ������
      if SockCanExit then
      begin
        TransmitExit := False;
        break;
      end;
      sleep(fsleeptime);
    end;
  except
    on e: exception do
    begin
      Statustr := '[' + datetimetostr(now) + ']' + 'Thread Error:' + e.Message;
      LogList.AddLog('10' + Statustr);
      upmemo;
    end;
  end;
end;

procedure TTransmit.LoginCT;
var
  xLogin: TLogin;
  xLogin_resp: TSMGPLogin_resp;
  Head: TSMGPHead;
  timestr: string;
  str1: string;
  md5str: md5digest;
  md5_con: MD5Context;
  temp: Longword;
  Status: Longword;
begin
  HadLogin := False;
  FillChar(xLogin, sizeof(TLogin), 0);
  FillChar(Head, sizeof(TSMGPHead), 0);
  FillChar(xLogin_resp, sizeof(TSMGPLogin_resp), 0);
  with xLogin do
  begin
    Head.PacketLength := winsock.Htonl(sizeof(TLogin));
    Head.RequestID := winsock.Htonl(Login);
    Head.SequenceID := winsock.Htonl(sSequence);
    strpcopy(body.ClientID, ClientID);
    body.Version := GetVision; //ϵͳ֧�ֵİ汾��$13;
    body.loginmode := loginmode;
    DateTimeToString(timestr, 'MMDDHHMMSS', now); //ʱ��ת��Ϊ�ַ���
    xLogin.body.Timestamp := winsock.Htonl(StrToInt(timestr)); //�ֽ�ϵת��
    //MD5������֤
    str1 := ClientID + #0#0#0#0#0#0#0 + sharesecret + timestr; //�û��������룫7��#0����½����+ʱ��
    MD5Init(md5_con); //��ʼ��md5_con
    MD5Update(md5_con, pchar(str1), length(str1)); //MD5����
    MD5Final(md5_con, md5str);
    move(md5str, body.AuthenticatorClient, 16); //���Ƶ���Ϣ���е�"AuthenticatorClient"�ֶ�
  end;
  try
    CTDeliver.Close;
  except
  end;
  try
    if CTDeliver.Connect then
      if sizeof(TLogin) = CTDeliver.SendBuf(xLogin, sizeof(xLogin), 0) then
      begin {//����}
        AddsSeq;
        StatuTxt := '��' + datetimetostr(now()) + '��SP-->CTLoginCT Request ���͵�½����...';
        synchronize(showstatu);
        if CTDeliver.WaitForData(timeout) then
        begin
          if sizeof(TSMGPHead) = CTDeliver.ReceiveBuf(Head, sizeof(TSMGPHead), 0) then
          begin {//��ͷ}
            Active_test_time := now; //StrToInt(formatdatetime('ss', now)); //��½�ظ�ʱ��
            temp := winsock.Htonl(Head.RequestID);
            if Login_resp = temp then
              if CTDeliver.WaitForData(timeout) then
              begin
                if sizeof(TSMGPLogin_resp) = CTDeliver.ReceiveBuf(xLogin_resp, sizeof(TSMGPLogin_resp), 0) then
                begin
                  Status := HostToNet(xLogin_resp.Status);
                  case Status of
                    0:
                      begin
                        StatuTxt := '��' + datetimetostr(now()) + '��Login_Resp-->�ɹ���½�й�����'; HadLogin := True; Warnning := 0; DCanExit := False; TransmitExit := False; StopCatchSMS := False; ReceiveDeliverTime := now; Counter := 0; end;
                    1:
                      begin
                        StatuTxt := '��' + datetimetostr(now()) + '��Login_Resp-->���Żظ�ϵͳæ�����Ժ��ٲ�'; CTDeliver.Close; sleep(RetryTime); StopCatchSMS := True; end;
                    21:
                      begin
                        StatuTxt := '��' + datetimetostr(now()) + '��Login_Resp-->���Żظ���֤���󣡣���'; CTDeliver.Close; sleep(RetryTime); StopCatchSMS := True; end;
                  else
                    begin
                      StatuTxt := '��' + datetimetostr(now()) + '��Login_Resp-->���Żظ�����ͻ��˽�������״̬ ' + inttostr(Status); CTDeliver.Close; sleep(RetryTime); StopCatchSMS := True; end;
                  end;
                  LogList.AddLog('10' + StatuTxt);
                end;
              end
              else
              begin
                StatuTxt := '��' + datetimetostr(now()) + '���������ӳ�ʱ,��·�ر�,�ȴ�' + inttostr(RetryTime div 1000) + '���µ�½...'; CTDeliver.Close; sleep(RetryTime); end;
          end;
        end
        else
        begin
          StatuTxt := '��' + datetimetostr(now()) + '���������ӳ�ʱ,��·�ر�,�ȴ�' + inttostr(RetryTime div 1000) + '�����µ�½...'; CTDeliver.Close; sleep(RetryTime); end;
        synchronize(showstatu);
      end;
  except
  end;
end;

procedure TTransmit.ActiveTest;
var
  ActiveTest: TSMGPHead;
begin
  FillChar(ActiveTest, sizeof(TSMGPHead), 0);
  if CTDeliver.Connected then
  begin
    if DateUtils.SecondsBetween(now, Active_test_time) >= (ActiveTestTime div 1000) then
    begin
      with ActiveTest do
      begin
        ActiveTest.PacketLength := HostToNet(sizeof(TSMGPHead));
        ActiveTest.RequestID := HostToNet(Active_test);
        ActiveTest.SequenceID := HostToNet(sSequence);
      end;
      if sizeof(TSMGPHead) = CTDeliver.SendBuf(ActiveTest, sizeof(TSMGPHead), 0) then
      begin
        AddsSeq;
        StatuTxt := '��' + datetimetostr(now()) + '��ActiveTest ������·���� ' + inttostr(HostToNet(ActiveTest.SequenceID));
        synchronize(showstatu);
      end;
    end;
  end;
end;

function TTransmit.ExitCT: boolean;
var
  SMGPExit: TSMGPHead;
  SMGPExit_Resp: TSMGPHead;
  temp: Longword;
begin
  Result := False;
  FillChar(SMGPExit, sizeof(TSMGPHead), 0);
  with SMGPExit do
  begin
    SMGPExit.PacketLength := HostToNet(sizeof(TSMGPHead));
    SMGPExit.RequestID := HostToNet(xExit);
    SMGPExit.SequenceID := HostToNet(sSequence);
  end;
  try
    if HadLogin then
      if sizeof(TSMGPHead) = CTDeliver.SendBuf(SMGPExit, sizeof(TSMGPHead), 0) then
      begin
        AddsSeq;
        StatuTxt := '��' + datetimetostr(now()) + '��SP-->CT ExitCT Request �����˳�����...';
        synchronize(showstatu);
      end;
    if CTDeliver.WaitForData(timeout) then
    begin
      if sizeof(TSMGPHead) = CTDeliver.ReceiveBuf(SMGPExit_Resp, sizeof(TSMGPHead), 0) then
      begin
        temp := HostToNet(SMGPExit_Resp.RequestID);
        if temp = Exit_resp then
        begin
          CTDeliver.Close;
          Result := True;
          DCanExit := True;
          StatuTxt := '��' + datetimetostr(now()) + '��ExitCT �˳�����ŵ�����';
          synchronize(showstatu);
        end;
      end;
    end
    else
    begin
      CTDeliver.Close;
      DCanExit := True;
      Result := True;
      StatuTxt := '��' + datetimetostr(now()) + '��ExitCT Request �����˳�����ʱ�������Ѿ��ر�';
      synchronize(showstatu);
    end;
  except
  end;
end;

procedure TTransmit.SocketError(Sender: TObject; SocketError: integer);
var
  Error: integer;
begin
  Error := SocketError;
  SocketError := 0;
  DCanExit := True;
  StatuTxt := '��' + datetimetostr(now) + '����·�����������' + inttostr(Error) + ',�ȴ�' + inttostr(RetryTime div 1000) + '���ٴε�½...';
  StopCatchSMS := True;
  synchronize(showstatu);
  LogList.AddLog('10' + StatuTxt);
  inc(Warnning);
  if Warnning > 10 then ErrWarnning := TWarnning.create;
  HadLogin := False;
  sleep(RetryTime);
end;


procedure TTransmit.ActiveTest_Resp(CTsequence: Longword);
var
  spActiveTest_Resp: TSMGPHead;
begin
  FillChar(spActiveTest_Resp, sizeof(TSMGPHead), 0);
  spActiveTest_Resp.SequenceID := HostToNet(CTsequence);
  spActiveTest_Resp.PacketLength := HostToNet(sizeof(TSMGPHead));
  spActiveTest_Resp.RequestID := HostToNet(Active_test_resp);
  if CTDeliver.Active then
    if sizeof(TSMGPHead) = CTDeliver.SendBuf(spActiveTest_Resp, sizeof(TSMGPHead)) then
    begin
      StatuTxt := '��' + datetimetostr(now()) + '��SP-->CT ActiveTest_Resp SP�ظ���·����... ' + inttostr(CTsequence);
      synchronize(showstatu);
    end;
end;

procedure TTransmit.upmemo;
begin
  if SMGPGateWay.MeMO1.Lines.count > 500 then SMGPGateWay.MeMO1.Clear;
  if SMGPGateWay.N3.Checked then
    SMGPGateWay.MeMO1.Lines.Add(Statustr + #13#10);
  SMGPGateWay.StatusBar1.Panels[1].Text := 'T: ' + inttostr(CTD_cou);
  SMGPGateWay.StatusBar1.Refresh;
end;

procedure TTransmit.showError;
begin
  if SMGPGateWay.MeMO1.Lines.count > 500 then SMGPGateWay.MeMO1.Clear;
  if SMGPGateWay.N2.Checked then
    SMGPGateWay.MeMO1.Lines.Add(StatustrE + #13#10);
end;
procedure TTransmit.showstatu;
begin
  if SMGPGateWay.MeMO3.Lines.count > 1000 then SMGPGateWay.MeMO3.Clear;
  SMGPGateWay.MeMO3.Lines.Add(StatuTxt);
end;

procedure TTransmit.AddCou;
begin
  if CTD_cou > 2147483600 then CTD_cou := 1;
  inc(CTD_cou);
end;

procedure TTransmit.AddsSeq;
begin
  if sSequence >= 4294967200 then sSequence := 1;
  sSequence := sSequence + 1;
end;

procedure TTransmit.WriteReport(const Msgid: array of char; const Source: array of char);
var
  CTReport: PReport;
  buff: array[0..19] of char;
  temp: string;
begin
  FillChar(buff, sizeof(buff), 0);
  new(CTReport);
  move(Source[3], buff, 10);
  CTReport^.id := BCDToHex(buff, 10); // ״̬�����Ӧԭ����Ϣ���������е�MsgID
  FillChar(buff, sizeof(buff), 0);
  move(Source[18], buff, 3);
  CTReport^.sub := buff; //   sub
  FillChar(buff, sizeof(buff), 0);
  move(Source[28], buff, 3);
  CTReport^.dlvrd := buff; //   dlvrd
  FillChar(buff, sizeof(buff), 0);
  move(Source[44], buff, 10);
  CTReport^.Submit_date := buff; //   Submit_date
  FillChar(buff, sizeof(buff), 0);
  move(Source[65], buff, 10);
  CTReport^.done_date := buff; //   done_date
  FillChar(buff, sizeof(buff), 0);
  move(Source[81], buff, 7);
  CTReport^.Stat := buff; //    Stat
  FillChar(buff, sizeof(buff), 0);
  move(Source[93], buff, 3);
  CTReport^.Err := buff; //    Err
  FillChar(buff, sizeof(buff), 0);
  move(Source[101], buff, 3); // Txtǰ3��byte
  temp := buff;
  FillChar(buff, sizeof(buff), 0);
  move(Source[108], buff, 12); //��12��BYTE
  temp := temp + buff;
  CTReport^.Txt := temp;
  ReportList.Add(CTReport);
  Statustr := '[' + datetimetostr(now) + ']Report:';
  Statustr := Statustr +'<MsgID>'+CTReport^.id + #32;
  Statustr := Statustr +'<Submit_date>'+CTReport^.Submit_date + #32;
  Statustr := Statustr +'<done_date>'+ CTReport^.done_date + #32;
  Statustr := Statustr +'<Stat>'+ CTReport^.Stat + #32;
  Statustr := Statustr +'<Err>'+ CTReport^.Err;
  LogList.AddLog('04' + Statustr);
  upmemo;
end;

procedure TTransmit.ShowDeliver(aDeliver: TCTDeliver; const LinkID:string);
begin
  Statustr := '[' + datetimetostr(now) + ']Deliver:';
  Statustr := Statustr +'<Msgid>' +BCDToHex(aDeliver.Msgid, sizeof(aDeliver.Msgid)) + #32;
  //Statustr := Statustr + inttostr(aDeliver.IsReport) + #32;
  Statustr := Statustr +'<SrcTermID>' + aDeliver.SrcTermID + #32;
  Statustr := Statustr +'<DestTermID>' +aDeliver.DestTermID + #32;
  Statustr := Statustr +'<MsgFormat>' + inttostr(aDeliver.MsgFormat) + #13#10;
  Statustr := Statustr +'<LinkID>' +LinkID + #32;
  Statustr := Statustr +'<MsgContent>' + aDeliver.MsgContent;
  LogList.AddLog('00' + Statustr);
  upmemo;
end;

procedure TTransmit.SaveToDeliverList(aDeliver: TCTDeliver;const LinkID:string); //����
var
  pDeliver: PCTDeliver;
begin
  new(pDeliver);
  pDeliver^.Msgid := BCDToHex(aDeliver.Msgid, sizeof(aDeliver.Msgid));
  pDeliver^.IsReport := aDeliver.IsReport;
  pDeliver^.MsgFormat := aDeliver.MsgFormat;
  pDeliver^.RecvTime := aDeliver.RecvTime;
  pDeliver^.SrcTermID := aDeliver.SrcTermID;
  pDeliver^.DestTermID := aDeliver.DestTermID;
  pDeliver^.MsgLength := aDeliver.MsgLength;
  if aDeliver.MsgFormat = 8 then {Unicode}
    pDeliver.MsgContent := Ucs2ToString(aDeliver.MsgContent)
  else if aDeliver.MsgFormat = 15 then
    pDeliver^.MsgContent := aDeliver.MsgContent
  else if aDeliver.IsReport = 9 then
  begin {�û������ͣ����Ϣ}
    pDeliver^.MsgContent := copy(aDeliver.MsgContent, 1, 12);
    pDeliver^.MsgContent := pDeliver^.MsgContent + aDeliver.MsgContent[17];
  end;
  pDeliver^.LinkID := LinkID;
  DeliverList.Add(pDeliver); //����DELIVER������
end;
procedure TTransmit.SP_Deliver_Resp(Msg_id: array of char; SequenceID: Longword);
var
  SPDeliver_Resp: TDeliver_Resp; // ���л���
  Msgid: string;
begin
  FillChar(SPDeliver_Resp, sizeof(TDeliver_Resp), 0);
  SPDeliver_Resp.Head.PacketLength := HostToNet(sizeof(TDeliver_Resp));
  SPDeliver_Resp.Head.RequestID := HostToNet(Deliver_resp);
  SPDeliver_Resp.Head.SequenceID := HostToNet(SequenceID);
  move(Msg_id, SPDeliver_Resp.body.Msgid, 10);
  Msgid := BCDToHex(Msg_id, 10);
  SPDeliver_Resp.body.Status := HostToNet(0);
  if CTDeliver.Connected then
    if sizeof(TDeliver_Resp) = CTDeliver.SendBuf(SPDeliver_Resp, sizeof(TDeliver_Resp)) then
    begin
      Statustr := '[' + datetimetostr(now()) + ']Deliver_Resp:' + Msgid;
      upmemo;
    end;
end;
function TTransmit.SP_Submit: boolean;
var
  xList: TList;
  SubmitLen: integer;
  Empty: boolean;
  xTCSubmit: PxSubmit; //ϵͳ�ڲ�������Ϣ��ָ��
  rSubmit: xSubmit; //ϵͳ�ڲ�������Ϣ��
  SubmitSequence: Longword;
begin
  Result := True;
  Empty := False;
  xTCSubmit := nil;
  FillChar(rSubmit, sizeof(xSubmit), 0);
  if CTDeliver.Connected then
  begin
    xList := SubmitList.LockList;
    try
      if xList.count > 0 then
      begin
        try
          xTCSubmit := PxSubmit(xList.First); //ǿ������ת��
          rSubmit := xTCSubmit^; //ת����¼
          try
            dispose(xTCSubmit); //�ͷ�ָ��
            xList.Delete(0); //ɾ���б�
            xTCSubmit := nil;
          except
          end;
        except
        end;
      end
      else
        Empty := True;
    finally
      SubmitList.UnlockList;
    end;
    if Empty then
    begin
      Result := False;
      exit;
    end;
    //����socket������Ϣ����
    SubmitSequence := MakeSockBuff(SubmitLen, rSubmit);
    //=============================================================================
    try
      if (SubmitLen) = CTDeliver.SendBuf(SocketBuff[0], SubmitLen) then
      begin
        AddsSeq;
        inc(rSubmit.Resend); //���ʹ�����1
        rSubmit.SequenceID := SubmitSequence; //HostToNet(SMGPSubmit2011.Head.SequenceID);
        rSubmit.Then_DateTime := now; //���õ�ǰ����ʱ��
        new(xTCSubmit);
        xTCSubmit^ := rSubmit;
        SaveSubmitList.Add(xTCSubmit); //SAVE SM
       Statustr := '[' + datetimetostr(now) + ']Submit:';
        Statustr := Statustr +'<SequenceID>'+inttostr(xTCSubmit^.SequenceID) + #32;
        Statustr := Statustr +'<Mid>'+ xTCSubmit^.sSubmit.Mid + #32;
        Statustr := Statustr +'<MsgType>'+ inttostr(xTCSubmit^.sSubmit.MsgType) + #32;
        //Statustr := Statustr +'<NeedReport>'+ inttostr(xTCSubmit^.sSubmit.NeedReport) + #32;
        Statustr := Statustr +'<ServiceID>'+ xTCSubmit^.sSubmit.ServiceID + #32;
        Statustr := Statustr +'<FeeCode>'+ xTCSubmit^.sSubmit.FeeCode + #32;
        Statustr := Statustr +'<FixedFee>'+ xTCSubmit^.sSubmit.FixedFee + #32;
        Statustr := Statustr +'<ChargeTermID>'+ xTCSubmit^.sSubmit.ChargeTermID + #32;
        Statustr := Statustr +'<DestTermID>'+ xTCSubmit^.sSubmit.DestTermID + #13#10;
        Statustr := Statustr +'<SrcTermID>'+ xTCSubmit^.sSubmit.SrcTermID + #32;
        Statustr := Statustr +'<SubmitMsgType>'+ inttostr(xTCSubmit^.sSubmit.SubmitMsgType) + #32;
        Statustr := Statustr +'<LinkID>'+ xTCSubmit^.sSubmit.LinkID + #32;
        Statustr := Statustr +'<MsgContent>'+ xTCSubmit^.sSubmit.MsgContent + #32;
        LogList.AddLog('07' + Statustr);
        AddCou;
        upmemo;
      end
      else
      begin {���Ͳ��ɹ�}
        new(xTCSubmit);
        xTCSubmit^ := rSubmit;
        SubmitList.Add(xTCSubmit);
      end;
    except
    end;
    SocketBuff := nil;
  end;
end;

procedure TTransmit.ReSubmit(SequenceID, statu: Longword);
var
  i: integer;
  cSubmit: PxSubmit;
  aList: TList;
  Mid: string;
begin
  aList := SaveSubmitList.LockList;
  try
    for i := 0 to aList.count - 1 do
    begin
      cSubmit := PxSubmit(aList.Items[i]);
      if SequenceID = cSubmit^.SequenceID then
        if cSubmit^.Resend >= sendtimes then
        begin //�ط�4��ʧ�ܣ������ط�
          Mid := cSubmit^.sSubmit.Mid;
          dispose(cSubmit);
          aList.Delete(i);
          StatustrE := '��' + datetimetostr(now()) + '��Submit_Resp MID=' + Mid + ' �������ط���״̬=' + inttostr(statu) + '���к�=' + inttostr(SequenceID) + ',��4���ʹ�ʧ�ܣ�����Ϣ�ѱ�ɾ��';
          LogList.AddLog('09' + StatustrE);
          synchronize(showError);
          break;
        end
        else
        begin
          SubmitList.Add(cSubmit);
          aList.Delete(i);
          Mid := cSubmit^.sSubmit.Mid;
          StatustrE := '��' + datetimetostr(now()) + '��Submit_Resp MID=' + Mid + ' �������ط���״̬=' + inttostr(statu) + '����ʧ��,�ȴ��ٷ�...';
          synchronize(showError);
          break;
        end;
    end;
  finally
    SaveSubmitList.UnlockList;
  end;
end;
function TTransmit.DeleteMT(SequenceID: Longword; var aMid: string): boolean; //��������
var
  i, FirstCount: integer;
  cSubmit: PxSubmit;
  aList: TList;
begin
  Result := False; //����MID
  aList := SaveSubmitList.LockList;
  FirstCount := aList.count - 1; //�б��ʼԪ�ظ���
  try
    for i := FirstCount downto 0 do //ɨ�豣�����б�һ��
    begin
      cSubmit := PxSubmit(aList.Items[i]);
      if SequenceID = cSubmit^.SequenceID then
      begin
        aMid := cSubmit^.sSubmit.Mid; //����MID
        dispose(cSubmit);
        aList.Delete(i);
        Result := True;
      end
      else
      begin {SaveSubmitList���л�û�л�����������Ķ���}
        if minutesBetween(now, cSubmit^.Then_DateTime) > resptime then {����10����û�лػ��������ط�}
        begin
          SubmitList.Add(cSubmit);
          aList.Delete(i);
          Statustr := '��' + datetimetostr(now()) + '��MID=' + #32 + cSubmit^.sSubmit.Mid + #32 + '��' + inttostr(resptime) + '���Ӻ�û�н��յ����Ż�������,�������ط�����';
          synchronize(upmemo);
          LogList.AddLog('07' + Statustr);
        end;
      end;
    end;
  finally
    SaveSubmitList.UnlockList;
  end;
end;
procedure TTransmit.NoResponse_Resubmit;
var
  i, FirstCount: integer;
  cSubmit: PxSubmit;
  aList: TList;
begin
  aList := SaveSubmitList.LockList;
  FirstCount := aList.count - 1; //�б��ʼԪ�ظ���
  try
    for i := FirstCount downto 0 do //ɨ�豣�����б�һ��
    begin
      cSubmit := PxSubmit(aList.Items[i]);
      {SaveSubmitList���л�û�л�����������Ķ���}
      if minutesBetween(now, cSubmit^.Then_DateTime) > resptime then {����10����û�лػ��������ط�}
      begin
        SubmitList.Add(cSubmit);
        aList.Delete(i);
        Statustr := '��' + datetimetostr(now()) + '��MID=' + #32 + cSubmit^.sSubmit.Mid + #32 + '��' + inttostr(resptime) + '���Ӻ�û�н��յ����Ż�������,�������ط�����';
        synchronize(upmemo);
        LogList.AddLog('07' + Statustr);
      end;
    end;
  finally
    SaveSubmitList.UnlockList;
  end;
end;

function TTransmit.MakeSockBuff(var SubmitLen: integer;
  rSubmit: xSubmit): Longword;
var
  i, count: integer;
  onenumber, Source: string;
  tmpBuf: array[0..20] of char;
  {2.0Э���}
  SMGPSubmit2011: TSMGPSubmit2011; //��ͷ������1
  SMGPSubmit203: TSMGPSubmit203; //����3
  SMGPTLV_tag:TSMGPTLV_tag;
  SMGPTLVLinkID_tag:TSMGPTLVLinkID_tag;
begin
  Result := 0;
  FillChar(SMGPSubmit2011, sizeof(TSMGPSubmit2011), 0);
  FillChar(SMGPSubmit203, sizeof(TSMGPSubmit203), 0);
  with SMGPSubmit203 do //����3
  begin
    count := rSubmit.sSubmit.DestTermIDCount; //������
    Source := rSubmit.sSubmit.DestTermID; //�����б�
    if count > 1 then
    begin
      for i := 0 to count - 1 do
      begin
        FillChar(tmpBuf, sizeof(tmpBuf), 0);
        Source := ChtchOne(Source, onenumber); //��ȡ��������
        strpcopy(tmpBuf, onenumber);
        move(tmpBuf, DestTermID[i * 21], 21);
      end;
    end
    else
      strpcopy(DestTermID, Source);
    DestTermIDCount := count;
    strpcopy(SrcTermID, rSubmit.sSubmit.SrcTermID);
    strpcopy(ChargeTermID, rSubmit.sSubmit.ChargeTermID);
    MsgLength := rSubmit.sSubmit.MsgLength;
    strpcopy(MsgContent, rSubmit.sSubmit.MsgContent);    
  end;
  SubmitLen := sizeof(TSMGPSubmit2011) + sizeof(TSMGPSubmit203) - 252 - 21 * (MAx_UserNumber - count) + SMGPSubmit203.MsgLength + 34; //34�����ǿ�ѡ�����е����� linkID submitmsgtype, spdealresult

  //��ͷ�Ͱ���1
  with SMGPSubmit2011 do
  begin
    Head.PacketLength := winsock.Htonl(SubmitLen);
    Head.RequestID := winsock.Htonl(Submit);
    Head.SequenceID := winsock.Htonl(sSequence);
    body.MsgType := rSubmit.sSubmit.MsgType;
    body.NeedReport := rSubmit.sSubmit.NeedReport;
    body.Priority := rSubmit.sSubmit.Priority;
    body.MsgFormat := rSubmit.sSubmit.MsgFormat;
    strpcopy(body.ServiceID, rSubmit.sSubmit.ServiceID);
    strpcopy(body.FeeType, rSubmit.sSubmit.FeeType);
    strpcopy(body.FeeCode, rSubmit.sSubmit.FeeCode);
    strpcopy(body.FixedFee, rSubmit.sSubmit.FixedFee);
    body.MsgFormat := rSubmit.sSubmit.MsgFormat;
    strpcopy(body.ValidTime, rSubmit.sSubmit.ValidTime);
    strpcopy(body.ATTime, rSubmit.sSubmit.ATTime);
  end;
  //===========================================================
  SetLength(SocketBuff, SubmitLen);  
  FillChar(SocketBuff[0], SubmitLen, 0);
  move(SMGPSubmit2011, SocketBuff[0], 74);
  move(SMGPSubmit203, SocketBuff[74], 43);
  move(SMGPSubmit203.DestTermID, SocketBuff[74 + 43], 21 * count);
  move(SMGPSubmit203.MsgLength, SocketBuff[74 + 43 + 21 * count], 1);
  move(SMGPSubmit203.MsgContent, SocketBuff[74+ 43 + 21 * count + 1], SMGPSubmit203.MsgLength);
  move(SMGPSubmit203.Reserve, SocketBuff[74 + 43 + 21 * count + 1 + SMGPSubmit203.MsgLength], 8);
  //��װ��ѡ����
  FillChar(SMGPTLVLinkID_tag,sizeof(TSMGPTLVLinkID_tag), 0);
  SMGPTLVLinkID_tag.Tag := winsock.htons(TLV_Lab_LinkID);
  SMGPTLVLinkID_tag.Length:=winsock.htons(20);
//  move(rSubmit.sSubmit.LinkID, SMGPTLVLinkID_tag.Value, 20);
  strpcopy(SMGPTLVLinkID_tag.Value, rSubmit.sSubmit.LinkID);
  move(SMGPTLVLinkID_tag, SocketBuff[74 + 43 + 21 * count + 1 + SMGPSubmit203.MsgLength+8], 24);
  FillChar(SMGPTLV_tag,sizeof(TSMGPTLV_tag),0);
  SMGPTLV_tag.Tag:=winsock.htons(TLV_Lab_SubmitMsgType);
  SMGPTLV_tag.Length:=winsock.htons(1);
  SMGPTLV_tag.Value := rSubmit.sSubmit.SubmitMsgType;
  move(SMGPTLV_tag, SocketBuff[74 + 43 + 21 * count + 1 + SMGPSubmit203.MsgLength+8 + 24], 5);
  FillChar(SMGPTLV_tag,sizeof(TSMGPTLV_tag),0);
  SMGPTLV_tag.Tag:=winsock.htons(TLV_Lab_SPDealReslt);
  SMGPTLV_tag.Length:=winsock.htons(1);
  SMGPTLV_tag.Value:=0;
  move(SMGPTLV_tag, SocketBuff[74 + 43 + 21 * count + 1 + SMGPSubmit203.MsgLength+8 + 24+5], 5);
  Result := HostToNet(SMGPSubmit2011.Head.SequenceID); //���ذ����к�
end;

procedure TTransmit.ReceiveHead;
var
  Head: TSMGPHead;
  CTRequestID: Longword;
  CTsequence: Longword;
  Len: Longword;
begin
  FillChar(Head, sizeof(TSMGPHead), 0);
  if CTDeliver.Connected then
    if CTDeliver.WaitForData(timeout) then
      if sizeof(TSMGPHead) = CTDeliver.ReceiveBuf(Head, sizeof(TSMGPHead)) then
      begin
        Active_test_time := now;
        CTRequestID := winsock.Htonl(Head.RequestID); //��������
        Len := winsock.Htonl(Head.PacketLength); //��Ϣ����
        CTsequence := winsock.Htonl(Head.SequenceID); //���к�
        ReceiveBody(CTRequestID, CTsequence, Len);
      end;
end;
procedure TTransmit.AddSyncOrdCelMsg(aDeliver: TCTDeliver;const LinkID:string);
var
  PSubmit: PxSubmit;
  srcMsg, ServiceID, MsgContent:string;
begin
  srcMsg:=Copy(aDeliver.MsgContent, 0, aDeliver.MsgLength);
  DealWithSyncMsgCont(srcMsg, ServiceID, MsgContent);
  new(PSubmit);
  PSubmit^.Resend := 0;
  PSubmit^.SequenceID := 0;
  PSubmit^.Then_DateTime := 0;
  PSubmit^.sSubmit.Mid := 'syc'+Formatdatetime('MMDDHHNNSS',now());
  PSubmit^.sSubmit.MsgType := 6;
  PSubmit^.sSubmit.NeedReport := 0;
  PSubmit^.sSubmit.Priority := 0;
  PSubmit^.sSubmit.ServiceID := ServiceID;//ҵ������ö������������ҵ�����
  PSubmit^.sSubmit.FeeType := '0';
  PSubmit^.sSubmit.FeeCode := '0';
  PSubmit^.sSubmit.FixedFee := '0';
  PSubmit^.sSubmit.MsgFormat := 15;
  PSubmit^.sSubmit.SrcTermID := aDeliver.DestTermID;
  PSubmit^.sSubmit.ChargeTermID := aDeliver.SrcTermID;
  PSubmit^.sSubmit.DestTermIDCount := 1;
  PSubmit^.sSubmit.DestTermID := aDeliver.SrcTermID;
  PSubmit^.sSubmit.MsgLength := Length(MsgContent);
  PSubmit^.sSubmit.LinkID := LinkID;
  PSubmit^.sSubmit.MsgContent := MsgContent;//StringReplace(aSubmit.MsgContent, #13, '', [rfReplaceAll]); //ȥ���س���
  PSubmit^.sSubmit.SubmitMsgType := 15; //�����ĵ㲥��Ϣ
  SubmitList.Add(PSubmit);
end;
procedure TTransmit.DealWithSyncMsgCont(const msgcontent: string;
  var ServiceID, MsgContPart: string);
var
  pos1,pos2:integer;
begin
//  DG���ո�ҵ����룫˫�ո��ܻ��û����ն˺��룫ð�ţ��û����������
//  QX���ո�ҵ����룫˫�ո��ܻ��û����ն˺��룫ð�ţ��û����������
  if msgcontent ='00000' then
  begin
    ServiceID := msgcontent;
    MsgContPart := msgcontent;
    exit;
  end;
  pos1:=AnsiPos(#32,  msgcontent);
  pos2:=AnsiPos(#32#32,  msgcontent);
  ServiceID := MidStr(msgcontent, pos1+1, pos2-pos1-1);
  pos1:= AnsiPos(':',  msgcontent);
  MsgContPart:= MidStr(msgcontent, 1, pos1-1);// ��ȡð��ǰ����ִ�
end;
//��ȡ�û�����ö�������,
function TTransmit.GetInstruct(const msgcontent: string): string;
var
  pos:integer;
begin
  if msgcontent ='00000' then //����ȡ������ҵ���ʱ��
  begin
    result:= msgcontent;
    exit;
  end;
  pos:=AnsiPos(':',  msgcontent);
  if pos=0 then
    result:= msgcontent
  else
    result:=strutils.RightStr(msgcontent, length(msgcontent)-pos);
end;
procedure TTransmit.ReceiveBody(CTRequestID, CTsequence, Len: Longword);
var
  xLogin_resp: TSMGPLogin_resp;
  SPResponse: PResponse;
  xDeliver: TCTDeliver;
  ErrMsg: array of char;
  Status: Longword;
  isRep: byte;
  Mid: string;
begin
  FillChar(xLogin_resp, sizeof(TSMGPLogin_resp), 0);
  FillChar(xDeliver, sizeof(TCTDeliver), 0);
  if CTDeliver.Connected then
  begin
    if Active_test_resp = CTRequestID then
    begin {//���ŷ�����·���Իظ�}
      StatuTxt := '��' + datetimetostr(now) + '��Active_Test_Resp ���Żظ���·����...' + inttostr(CTsequence);
      LogList.AddLog('08' + StatuTxt);
      showstatu;
       if (MinutesBetween(now, LastSendWarnMsgTime) >= NoReceiveDeliver) and (MinutesBetween(now, ReceiveDeliverTime) >= NoReceiveDeliver) and (SendWarn) and (Counter < SendCount) then
      begin
        LogList.AddLog('10' + '�����������ϴ����л��½ʱ��' + datetimetostr(ReceiveDeliverTime) + '��Ŀǰʱ��' + datetimetostr(now) + '�Ѿ�����' + inttostr(MinutesBetween(now, ReceiveDeliverTime)) + '����û�����У��������Աע���������(ϵͳ����������' + inttostr(SendCount) + '��)');
        inc(Counter);
        if Counter = SendCount then
        begin
          LastSendWarnMsgTime := now;
          Counter := 0;
        end;
      end;
    end
    else if Deliver = CTRequestID then
    begin {//���ж���}
      ReceiveDeliver(CTsequence, Len);
      {ReceiveDeliverTime := now;
      if 69 = CTDeliver.ReceiveBuf(xDeliver, 69) then
        if xDeliver.MsgLength = CTDeliver.ReceiveBuf(xDeliver.MsgContent, xDeliver.MsgLength) then
          if 8 = CTDeliver.ReceiveBuf(xDeliver.Reserve, 8) then
          begin
            SP_Deliver_Resp(xDeliver.Msgid, CTsequence); //���ж��Ż���CP-->CT
            isRep := xDeliver.IsReport;
            if isRep = 1 then
              WriteReport(xDeliver.Msgid, xDeliver.MsgContent)
            else
            begin
              SaveToDeliverList(xDeliver);
              synchronize(AddCou);
              ShowDeliver(xDeliver);
            end;
          end; }
    end
    else if Submit_resp = CTRequestID then
    begin {��������Submit_response}
      if CTDeliver.ReceiveBuf(CTSubmit_Resp, sizeof(TSMGPDeliver_Resp)) = sizeof(TSMGPDeliver_Resp) then
      begin
        Status := HostToNet(CTSubmit_Resp.Status);
        if ((Status > 0) and (Status < 10)) or (Status = 39) then //������Щ�����ʱ���ط�����
          ReSubmit(CTsequence, Status)
        else if Status = 0 then
        begin //����������ȷ����
          if not DeleteMT(CTsequence, Mid) then //ɾ������������ ������MID
            Statustr := '��' + datetimetostr(now) + '��ɾ������������ʱû�з�����ȷ��MID';
          new(SPResponse);
          SPResponse^.Mid := Mid;
          strpcopy(SPResponse^.Submit_resp.Msgid, BCDToHex(CTSubmit_Resp.Msgid, sizeof(CTSubmit_Resp.Msgid)));
          SPResponse^.Submit_resp.Status := Status;
          ResponseList.Add(SPResponse); //�������л���������
          Statustr := '[' + datetimetostr(now) + ']Submit_Resp:';
          Statustr := Statustr +'<CTsequence>' +inttostr(CTsequence) + #32;
          Statustr := Statustr +'<Mid>' + Mid + #32;
          Statustr := Statustr +'<Msgid>' + SPResponse^.Submit_resp.Msgid + #32;
          Statustr := Statustr +'<Status>' + inttostr(Status);
          LogList.AddLog('02' + Statustr);
          synchronize(upmemo);
        end
        else
        begin //���������������
          DeleteMT(CTsequence, Mid); //ɾ������������
          Statustr := '��' + datetimetostr(now) + '��Submit_Resp:' + Mid + '����״̬=' + inttostr(Status) + ',����Ϣ�Ѿ���ɾ��';
          LogList.AddLog('09' + Statustr);
          synchronize(upmemo);
        end;
      end;
    end
    else if Active_test = CTRequestID then
    begin {���ŷ���������·����}
      StatuTxt := '��' + datetimetostr(now) + '��CT-->SPActiveTest ���ŷ�����·���� ' + inttostr(CTsequence);
      showstatu;
      ActiveTest_Resp(CTsequence);
    end
    else if Exit_resp = CTRequestID then
    begin {�˳��ظ�}
      CTDeliver.Close;
      DCanExit := True;
      TransmitExit := False;
      SockCanExit := True; ;
      StatuTxt := '��' + datetimetostr(now()) + '��ExitCT --> �˳����й����ŵ�����';
      LogList.AddLog('11' + StatuTxt);
      showstatu;
    end
    else
    begin //����İ�ͷ������
      try
        setlength(ErrMsg, Len - 12);
        CTDeliver.ReceiveBuf(ErrMsg, Len - 12);
        ErrMsg := nil;
      except
      end;
      StatuTxt := '��' + datetimetostr(now()) + '�����յ����ʹ������Ϣ��';
      showstatu;
    end;
  end;
end;

function TTransmit.ReceiveTLVMsg(const MsgLen: integer; var LinkID:string;var DealReslt:byte):byte;
var
  tmpbuf:array of char;
  tag, Len:word;
  pos:integer;
  value:array of char;
begin
  SetLength(tmpbuf,MsgLen);
  result:=0;
  DealReslt:=0;
  if CTDeliver.ReceiveBuf(tmpbuf[0], MsgLen) = MsgLen then  //�������п�ѡ����
  begin
    pos:=0;
    while(pos < MsgLen)do
    begin
      Len:=0;
      tag:=0;
      Move(tmpbuf[pos], tag, 2);
      Move(tmpbuf[pos+2], Len, 2);
      tag:=htons(tag);//��ǩ
      len:=htons(len);
      SetLength(value,len);
      Move(tmpbuf[pos+4], value[0], Len);
      case tag of
        TLV_Lab_LinkID:
        begin
          //CopyMemory(@LinkID, @value, len);
          setLength(LinkID, len);
          Move(value[0],LinkID[1], len);
        end;
        TLV_Lab_SubmitMsgType:// 13 ��ͬ������, 15 ��ͬ�������ظ� 0����������
        begin
          //CopyMemory(@Result, @Value, 1);
          Move(value[0], Result, 1);
        end;
        TLV_Lab_SPDealReslt: //ͬ������������ 0 �ɹ�,1 ʧ��
        begin
          //CopyMemory(@DealReslt, @Value,1);
          Move(value[0], DealReslt, 1);
        end;
      end;
      value:=nil;
      inc(pos,4 + Len);
    end;
  end; 
  tmpbuf:=nil;
end;

procedure TTransmit.ReceiveDeliver(CTsequence, Len: Longword);
var
  xDeliver: TCTDeliver;
  isRep: byte;
  LinkID:string;
  SubmitMsgType,DealResult:byte;
  Msg:string;
begin
  FillChar(xDeliver, sizeof(TCTDeliver), 0);
  ReceiveDeliverTime := now;
  Counter := 0;
  if 69 = CTDeliver.ReceiveBuf(xDeliver, 69) then
    if xDeliver.MsgLength = CTDeliver.ReceiveBuf(xDeliver.MsgContent, xDeliver.MsgLength) then
      if 8 = CTDeliver.ReceiveBuf(xDeliver.Reserve, 8) then
      begin    //���տ�ѡ����
        if (len - sizeof(CTSMSHeader) > 77+ xDeliver.MsgLength) then
        begin //���տ�ѡ����,��������� ��ѡ�����ܳ���, LinkID, DealResult==������
          SubmitMsgType := ReceiveTLVMsg(len - (89 + xDeliver.MsgLength), LinkID, DealResult);
        end;
        SP_Deliver_Resp(xDeliver.Msgid, CTsequence); //���ж��Ż���CP-->CT
        isRep := xDeliver.IsReport;
        if isRep = 1 then {//״̬����}
          WriteReport(xDeliver.Msgid, xDeliver.MsgContent)
        else
        begin {//���������ж���/���û����ͣ�� ��Ϣ}
          case SubmitMsgType of
            13://��Ҫ�ظ�����, SubmitMsgType = 15,LinkIDҲ��Ҫ, ������Ϊ"DG���ո�ҵ����룫˫�ո��ܻ��û����ն˺���
               //����Ҫ�ٰѶ�������ֻȡ�û���������ݲ���
               begin //������,ȡ��
                 AddSyncOrdCelMsg(xDeliver, LinkID);//д��submit����,
                 //���ж������ݸ�Ϊ�û���������
                 msg:=Copy(xDeliver.MsgContent,0, xDeliver.MsgLength);
                 FillChar(xDeliver.MsgContent,sizeof(xDeliver.MsgContent),0);
                 StrpCopy(xDeliver.MsgContent, GetInstruct(msg));
               end;
            15://������,ȡ�� �ظ�,��Ҫ�� ReSycQX+1���ո�+ ������ + 1���ո� + DealReslt
               begin
                 msg:=Copy(xDeliver.MsgContent,0, xDeliver.MsgLength);
                 FillChar(xDeliver.MsgContent,sizeof(xDeliver.MsgContent),0);
                 StrpCopy(xDeliver.MsgContent, 'ReSyc '+ msg + #32 + inttostr(DealResult));
               end;
          end;
          SaveToDeliverList(xDeliver, LinkID);
          synchronize(AddCou);
          showDeliver(xDeliver,LinkID);
        end;
        {try
         fs:=Tfilestream.create( 'd:\Stream\D'+formatdatetime('ddhhnnss',now)+'.txt',fmCreate	);
         fs.WriteBuffer(xDeliver,sizeof(xDeliver));
        finally
         fs.free;
        end;}
      end;
end;

end.

