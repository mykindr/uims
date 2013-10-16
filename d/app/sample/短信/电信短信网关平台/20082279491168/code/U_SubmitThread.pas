{������������������������������������������������}
{           ���м����������SUBMIT�߳�           }
{               Author: LUOXINXI                 }
{                DateTime: 2004/3/11             }
{������������������������������������������������}
unit U_SubmitThread;

interface
uses
  windows,
  classes,
  Sockets,
  U_MsgInfo,
  Smgp13_XML,
  StrUtils,
  SysUtils,
  U_SysConfig;
type
  TSubmitThread = class(TThread)
  private
    TcpSubmit: TTcpClient;
    xmlSubmit: TSPPack; //���м����������SUBMIT ����
    SMSReq: CTSMSHeader; //���м��������������
    Response: boolean;
    ftimeout: integer;
    fsleeptime: integer;
    statustr: string;
    StatuEstr: string;
    SendLen: integer;
    Createstr: string;
    StopSubmitTimes:integer;
  protected
    procedure execute; override;
    procedure upmemo;
    procedure upCreatestr;
    procedure showError;
    procedure catchsubmit; //���м��������������
    procedure madesubmit(aSubmit: TTCSubmit); //�����·����Ÿ�ʽ
    procedure madeSecondSubmit(aSubmit: TTCSubmit; SecondMsg: string);
    procedure SocketError(Sender: TObject; SocketError: integer);
    function countchar(const Str: string): integer; //ͳ�ƺ����ֽ���
    function countChina(const Str: string): integer; // ͳ�ƺ��ָ���
    procedure SplitPack(Source: string; var First, Second: string);
    procedure addSCou;
    procedure addE;

    procedure SaveToDeliverList();
  public
    constructor create(hostip, hostport: string; sleeptime, timeout: integer); virtual;
    destructor destroy; override;
  end;
implementation
uses U_main;
{ TSubmitThread }
constructor TSubmitThread.create(hostip, hostport: string; sleeptime, timeout: integer);
begin
  inherited create(True);
  FreeOnTerminate := True;
  TcpSubmit := TTcpClient.create(nil);
  TcpSubmit.RemoteHost := hostip;
  TcpSubmit.RemotePort := hostport;
  TcpSubmit.OnError := SocketError;
  ftimeout := timeout;
  fsleeptime := sleeptime;
  Createstr := '��' + datetimetostr(now) + '���������ж����̴߳����ɹ�,������IP:' + hostip + ',ThreadID:' + inttostr(self.ThreadID);
  synchronize(upCreatestr);
  Resume;
end;

destructor TSubmitThread.destroy;
begin
  FreeAndNil(TcpSubmit);
  GSubmitTList.Remove(self);
  Createstr := '��' + datetimetostr(now) + '���������ж����߳�ֹͣ,ThreadID:' + inttostr(self.ThreadID);
  synchronize(upCreatestr);
  SMGPGateWay.TBSubmitReq.Tag := 0;
  SMGPGateWay.TBSubmitReq.Caption := 'Start Request'; // SMGPGateWay.TBDToS.Update;
  LogList.AddLog('10' + Createstr);
  inherited;
end;

procedure TSubmitThread.execute;
var
  Status_ID, Version: string;
  Command_ID, Sequence_ID: word;
begin
  inherited;
  Fillchar(SMSReq, sizeof(CTSMSHeader), 0);
  readProto(Status_ID, Version, Response);
  readSsequence(Sequence_ID, Command_ID);
  SMSReq.Command_ID := Command_ID;
  SMSReq.Status_ID := strtoint(Status_ID);
  SMSReq.Sequence_ID := Sequence_ID;
  SMSReq.Version := strtoint(Version);
  SendLen := sizeof(CTSMSHeader);
  SMSReq.Total_Length := SendLen;
  StopSubmitTimes := 0;
  while not Terminated do
  begin
    Fillchar(xmlSubmit, sizeof(TSPPack), 0);
    if StopCatchSMS then
    begin
      statustr := '��' + datetimetostr(now) + '����������ӶϿ�,��ͣ���м���ȡ����';
      synchronize(upmemo);
      sleep(2000);//ͣ2��
      inc(StopSubmitTimes); //��StopSubmitTimes = 900 ��ʱ�������о���
      if StopSubmitTimes = 900 then SaveToDeliverList;
      continue;
    end; 
    try
      catchsubmit; //�������
    except
    end;
    sleep(fsleeptime);
  end;
end;
procedure TSubmitThread.catchsubmit;
var
  //aSubmit: xSubmit; //�����·�����
  aSubmit: TTCSubmit;
begin
  try
    if TcpSubmit.Connect then
    begin
      Fillchar(aSubmit, sizeof(TTCSubmit), 0);
      if self.Terminated then exit;
      if SendLen = TcpSubmit.SendBuf(SMSReq, SendLen) then
        if TcpSubmit.WaitForData(ftimeout) then
        begin
          if SendLen = TcpSubmit.ReceiveBuf(xmlSubmit.Header, SendLen) then //���հ�ͷ
            case xmlSubmit.Header.Status_ID of
              11:
                if TcpSubmit.WaitForData(ftimeout) then
                  if (xmlSubmit.Header.Total_Length - SendLen) = TcpSubmit.ReceiveBuf(xmlSubmit.body, (xmlSubmit.Header.Total_Length - SendLen)) then
                  begin
                    addSCou;
                    if not ReadSubmit(xmlSubmit.body, aSubmit) then exit;
                    madesubmit(aSubmit);
                    synchronize(upmemo);
                    if Response then
                    begin
                      SMSReq.Status_ID := 31; SMSReq.Sequence_ID := xmlSubmit.Header.Sequence_ID;
                      TcpSubmit.SendBuf(SMSReq, SendLen);
                    end;
                  end
                  else
                    if Response then
                    begin
                      SMSReq.Status_ID := 32;
                      SMSReq.Sequence_ID := xmlSubmit.Header.Sequence_ID;
                      TcpSubmit.SendBuf(SMSReq, SendLen);
                    end;
            else
              begin
                StatuEstr := '��' + datetimetostr(now()) + '��Server-->GateWay Submit Status_ID:' + inttostr(xmlSubmit.Header.Status_ID);
                synchronize(showError);
                sleep(1000);
              end;
            end;
        end;
    end
    else
    begin
      StatuEstr := '��' + datetimetostr(now()) + '��Server-->GateWay Submit Connect Timeout';
      synchronize(showError);
    end;
  finally
    TcpSubmit.Close;
  end;
end;

procedure TSubmitThread.madesubmit(aSubmit: TTCSubmit);
var
  PSubmit: PxSubmit;
  First, Second: string;
  s: string;
begin
  if (aSubmit.MsgContent = '') and (aSubmit.MsgType < 8) then
  begin
    statustr := '��' + datetimetostr(now) + '��Server-->GateWay Submit Error:���ж������ݿ�,MsgType:' + inttostr(aSubmit.MsgType) + ',MID:' + aSubmit.Mid; LogList.AddLog('09' + statustr); exit; end;
  if aSubmit.DestTermID = '' then
  begin
    statustr := '��' + datetimetostr(now) + '��Server-->GateWay Submit Error:���ж���Ŀ�ĺ����,MID:' + aSubmit.Mid; LogList.AddLog('09' + statustr); exit; end;
  if aSubmit.ServiceID = '' then
  begin
    statustr := '��' + datetimetostr(now) + '��Server-->GateWay Submit Error:ҵ������,MID:' + aSubmit.Mid; LogList.AddLog('09' + statustr); exit; end;
  if  not StrUtils.AnsiStartsText( SPID,aSubmit.SrcTermID) then
  begin
    statustr := '��' + datetimetostr(now) + '��Server-->GateWay Submit Error:�����������,MID:' + aSubmit.Mid; LogList.AddLog('09' + statustr); exit; end;
  new(PSubmit);
  PSubmit^.Resend := 0;
  PSubmit^.SequenceID := 0;
  PSubmit^.Then_DateTime := 0;
  PSubmit^.sSubmit.Mid := aSubmit.Mid;
  PSubmit^.sSubmit.MsgType := aSubmit.MsgType;
  PSubmit^.sSubmit.NeedReport := aSubmit.NeedReport;
  PSubmit^.sSubmit.Priority := aSubmit.NeedReport;
  PSubmit^.sSubmit.ServiceID := aSubmit.ServiceID;
  PSubmit^.sSubmit.FeeType := aSubmit.FeeType;
  PSubmit^.sSubmit.FeeCode := aSubmit.FeeCode;
  PSubmit^.sSubmit.FixedFee := aSubmit.FixedFee;
  PSubmit^.sSubmit.MsgFormat := aSubmit.MsgFormat;
  if aSubmit.ValidTime <> '' then //2.0Э����������
    PSubmit^.sSubmit.ValidTime := aSubmit.ValidTime + '000R';
  if aSubmit.AtTime <> '' then //2.0Э����������
    PSubmit^.sSubmit.AtTime := aSubmit.AtTime + '000R';
  PSubmit^.sSubmit.SrcTermID := aSubmit.SrcTermID; //
  PSubmit^.sSubmit.ChargeTermID := aSubmit.ChargeTermID; //
  PSubmit^.sSubmit.DestTermIDCount := aSubmit.DestTermIDCount;
  PSubmit^.sSubmit.DestTermID := aSubmit.DestTermID;
  PSubmit^.sSubmit.MsgLength := aSubmit.MsgLength;
  PSubmit^.sSubmit.LinkID := aSubmit.LinkID;
  //���������Ƿ񳬳�250�ַ�
  aSubmit.MsgContent := StringReplace(aSubmit.MsgContent, #13, '', [rfReplaceAll]); //ȥ���س���
  if LengTh(aSubmit.MsgContent) > 250 then
  begin
    SplitPack(aSubmit.MsgContent, First, Second);
    madeSecondSubmit(aSubmit, First); //��һ��
    PSubmit^.sSubmit.MsgContent := Second; //�ڶ���
    PSubmit^.sSubmit.MsgLength := LengTh(Second);
    s := #32#32'��������:�ð���Ϣ���ݹ���,ϵͳ�����ְ����д���';
  end
  else
    PSubmit^.sSubmit.MsgContent := aSubmit.MsgContent;
  PSubmit^.sSubmit.SubmitMsgType := 0; //�����ĵ㲥��Ϣ
  if (aSubmit.MsgContent = '00000')or(AnsiPos('QX ',aSubmit.MsgContent)>0) then     //endo add
    PSubmit^.sSubmit.SubmitMsgType := 13;  //����ȡ������ ��ֵΪ13

  SubmitList.Add(PSubmit);
  statustr := '[' + datetimetostr(now) + '](Submit):';
  statustr := statustr + PSubmit^.sSubmit.Mid + #32;
  statustr := statustr + inttostr(PSubmit^.sSubmit.MsgType) + #32;
  statustr := statustr + inttostr(PSubmit^.sSubmit.NeedReport) + #32;
  statustr := statustr + PSubmit^.sSubmit.FeeType + #32;
  statustr := statustr + PSubmit^.sSubmit.FeeCode + #32;
  statustr := statustr + PSubmit^.sSubmit.ServiceID + #32;
  statustr := statustr + PSubmit^.sSubmit.SrcTermID + #32;
  statustr := statustr + inttostr(PSubmit^.sSubmit.DestTermIDCount) + #32;
  statustr := statustr + PSubmit^.sSubmit.ChargeTermID + #32;
  statustr := statustr + PSubmit^.sSubmit.DestTermID + #32;
  statustr := statustr + aSubmit.MsgContent + s;
  LogList.AddLog('06' + statustr);
end;
procedure TSubmitThread.madeSecondSubmit(aSubmit: TTCSubmit;
  SecondMsg: string);
var
  PSubmit: PxSubmit;
begin
  new(PSubmit);
  PSubmit^.Resend := 0;
  PSubmit^.SequenceID := 0;
  PSubmit^.Then_DateTime := 0;
  PSubmit^.sSubmit.Mid := aSubmit.Mid;
  PSubmit^.sSubmit.MsgType := aSubmit.MsgType;
  PSubmit^.sSubmit.NeedReport := aSubmit.NeedReport;
  PSubmit^.sSubmit.Priority := aSubmit.NeedReport;
  PSubmit^.sSubmit.ServiceID := aSubmit.ServiceID;
  PSubmit^.sSubmit.FeeType := aSubmit.FeeType;
  PSubmit^.sSubmit.FeeCode := aSubmit.FeeCode;
  PSubmit^.sSubmit.FixedFee := aSubmit.FixedFee;
  PSubmit^.sSubmit.MsgFormat := aSubmit.MsgFormat;
  //PSubmit^.sSubmit.ValidTime := aSubmit.ValidTime;
  //PSubmit^.sSubmit.AtTime := aSubmit.AtTime;
   if aSubmit.ValidTime <> '' then //2.0Э����������
    PSubmit^.sSubmit.ValidTime := aSubmit.ValidTime + '000R';
  if aSubmit.AtTime <> '' then //2.0Э����������
    PSubmit^.sSubmit.AtTime := aSubmit.AtTime + '000R';
    
  PSubmit^.sSubmit.SrcTermID := aSubmit.SrcTermID; //
  PSubmit^.sSubmit.ChargeTermID := aSubmit.ChargeTermID; //
  PSubmit^.sSubmit.DestTermIDCount := aSubmit.DestTermIDCount;
  PSubmit^.sSubmit.DestTermID := aSubmit.DestTermID;
  PSubmit^.sSubmit.MsgLength := LengTh(SecondMsg);
  PSubmit^.sSubmit.MsgContent := SecondMsg;
  PSubmit^.sSubmit.LinkID := aSubmit.LinkID;
  SubmitList.Add(PSubmit);
end;

procedure TSubmitThread.SocketError(Sender: TObject; SocketError: integer);
begin
  StatuEstr := '��' + datetimetostr(now) + '���������Disconnect, SocketError: ' + inttostr(SocketError);
  SocketError := 0;
  addE;
  synchronize(showError);
end;
procedure TSubmitThread.addE;
begin
  if SToG_E > 20000 then SToG_E := 0
  else
    inc(SToG_E);
end;

procedure TSubmitThread.addSCou;
begin
  if SToG_cou > 2147483600 then SToG_cou := 0
  else
    inc(SToG_cou);
end;
procedure TSubmitThread.upmemo;
begin
  if SMGPGateWay.Memo2.Lines.Count > 400 then SMGPGateWay.Memo2.Clear;
  if SMGPGateWay.N3.Checked then
    SMGPGateWay.Memo2.Lines.Add(statustr + #13#10);
  SMGPGateWay.StatusBar1.Panels[9].Text := 'T:' + inttostr(SToG_cou) + 'E:' + inttostr(SToG_E);
  SMGPGateWay.StatusBar1.Refresh;
end;

procedure TSubmitThread.showError;
begin
  if SMGPGateWay.Memo2.Lines.Count > 400 then SMGPGateWay.Memo2.Clear;
  if SMGPGateWay.N2.Checked then
    SMGPGateWay.Memo2.Lines.Add(StatuEstr + #13#10);
end;
procedure TSubmitThread.upCreatestr;
begin
  SMGPGateWay.Memo3.Lines.Add(Createstr);
end;

function TSubmitThread.countchar(const Str: string): integer;
var
  i: integer;
  TmpStr: string;
begin
  TmpStr := trim(Str);
  Result := 0;
  i := 0;
  while (i <= LengTh(TmpStr)) and (LengTh(TmpStr) > 0) do
  begin
    inc(i);
    //Ӣ���ַ�
    if ord(TmpStr[i]) >= 128 then //�����ַ�
    begin
      inc(Result); //����������1
    end;
  end;
end;

function TSubmitThread.countChina(const Str: string): integer;
var
  i: integer;
  TmpStr: string;
begin
  TmpStr := trim(Str);
  Result := 0;
  i := 0;
  while (i <= LengTh(TmpStr)) and (LengTh(TmpStr) > 0) do
  begin
    inc(i);
    if ((i + 1) > LengTh(TmpStr)) then exit; //
    if (ord(TmpStr[i]) >= 128) and (ord(TmpStr[i + 1]) >= 128) then //�����ַ�
    begin
      inc(i);
      inc(Result); //�����ַ���1
    end;
  end;
end;
//�����  --�����Ź�����ʱ��ֳ�2�������·� 248���ֽ�
procedure TSubmitThread.SplitPack(Source: string; var First,
  Second: string);
begin
  if ord(Source[248]) >= 128 then //�����ֽ�
  begin
    if (countchar(copy(Source, 1, 248)) mod 2) = 0 then //ż���������ֽ�
    begin
      First := copy(Source, 1, 248);
      Second := copy(Source, 249, LengTh(Source) - 248);
    end
    else //����
    begin
      if (countChina(copy(Source, 1, 248)) mod 2) = 0 then //ż��������
      begin
        First := copy(Source, 1, 247);
        Second := copy(Source, 248, LengTh(Source) - 247);
      end
      else //����������
      begin
        First := copy(Source, 1, 249);
        Second := copy(Source, 250, LengTh(Source) - 249);
      end;
    end;
  end
  else //�Ǻ����ֽ�
  begin
    First := copy(Source, 1, 248);
    Second := copy(Source, 249, LengTh(Source) - 248);
  end;
end;

procedure TSubmitThread.SaveToDeliverList(); //����
var
  pDeliver: PCTDeliver;
begin
  new(pDeliver);
  pDeliver^.Msgid := '1190000000000';
  pDeliver^.IsReport := 0;
  pDeliver^.MsgFormat := 15;
  pDeliver^.RecvTime := formatdatetime('yymmddhhnnss', now);
  pDeliver^.SrcTermID := '1189109';
  pDeliver^.DestTermID := '1189109';
  pDeliver^.MsgLength := 0;
  pDeliver^.MsgContent := 'Warnning:��������3.0 ������ϳ���30����,�����������ԭ��';
  pDeliver^.LinkID:='';
  pDeliver^.LinkID := '';
  DeliverList.Add(pDeliver); //����DELIVER������
  StopSubmitTimes := 0;
end;

end.

