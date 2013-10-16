{������������������������������������������������}
{                  SUBMIT�߳�                    }
{                  Author: LUOXINXI              }
{                  DateTime: 2004/3/11           }
{������������������������������������������������}


unit U_CTThread;
interface
uses
  Windows, classes, Sockets, U_MsgInfo, Smgp13_XML, U_RequestID, Htonl,
  SysUtils, winsock, ScktComp, md5, DateUtils, NetDisconnect;
{MT Thread}
type
  TCPSubmit = class(TThread)
  private
    CTClient: TTcpClient;
    Statustr: string;
    StatuTxt: string;
    StatustrE: string;
    fsleeptime: integer;
    ClientID: string;
    sharesecret: string;
    SocketBuff: array of char;
    loginmode: byte;
    timeout: integer;
    HadLogin: boolean;
    Active_test_time: TDateTime; // integer;
    resptime, sendtimes: integer;
    MT_Warnning: byte;
    ErrWarnning: TWarnning;
    ErrMsg: array of char;
  protected
    procedure Execute; override;
    procedure LoginCT; {��½����}
    function ExitCT: boolean; {�˳�����}
    procedure MT_ActiveTest; {������·����}
    function SP_Submit: boolean; {���ж���}
    procedure Receive; {����������·����}
    procedure MTSocketError(Sender: TObject;
      SocketError: integer);
    procedure ReSubmit(SequenceID: Longword; statu: Longword); {�ط�}
    function DeleteMT(SequenceID: Longword; var aMid: string): boolean; {ɾ�����ж��Ż���������,����MID}
    procedure MTActive_Test_Resp(CTsequence: Longword); {�ظ���·����}
    function SubmitButDisConn(DisConnTime: TDateTime): integer; //�Ѿ��·����ŵ�û�л���������·�Ͽ�
    function MakeSockBuff(var SubmitLen: integer; rSubmit: xSubmit): Longword; //����socket������Ϣ ����ֵ�Ǹ���Ϣ���к�
    procedure upmemo;
    procedure NoResponse_Resubmit; //��ָ��ʱ��û�з��ػ���������ط�
    procedure showError;
    procedure showstatu;
    procedure AddsSeq;
    procedure AddCou;
  public
    constructor create(xCT_IP, xCT_port, xClientID, xsharesecret: string; xsleeptime, xtimeout, xresptime, xsendtimes: integer; xloginmode: byte); virtual;
    destructor destroy; override;
  end;

implementation
uses U_Main;

{ TCPSubmit }
constructor TCPSubmit.create(xCT_IP, xCT_port, xClientID, xsharesecret: string; xsleeptime, xtimeout, xresptime, xsendtimes: integer; xloginmode: byte);
begin
  inherited create(True);
  FreeOnTerminate := True;
  CTClient := TTcpClient.create(nil);
  CTClient.RemoteHost := xCT_IP;
  CTClient.RemotePort := xCT_port;
  CTClient.OnError := MTSocketError;
  ClientID := xClientID;
  sharesecret := xsharesecret;
  fsleeptime := xsleeptime;
  timeout := xtimeout;
  resptime := xresptime;
  sendtimes := xsendtimes;
  loginmode := xloginmode;
  StatuTxt := '��' + datetimetostr(now) + '�������̴߳���,�������ط�����' + xCT_IP + ',ThreadID:' + inttostr(self.ThreadID);
  synchronize(showstatu);
  Resume;
end;
destructor TCPSubmit.destroy;
begin
  StopCatchSMS := True;
  FreeAndNil(CTClient);
  SocketBuff := nil;
  ErrMsg:=nil;
  StatuTxt := '��' + datetimetostr(now) + '�������߳���ֹ,ThreadID:' + inttostr(self.ThreadID);
  synchronize(showstatu);
  LogList.AddLog('10' + StatuTxt);
  SMGPGateWay.Label8.Caption := 'Warning:���Ͷ���(MT)�߳�ֹͣ';
  MTExit := False;
  SMGPGateWay.MTLogin1.Enabled := True;
  inherited;
end;
procedure TCPSubmit.Execute;
begin
  HadLogin := False;
  MT_Warnning := 0;
  while not Terminated do
  try
    if not HadLogin then
      LoginCT //��½
    else
    begin
      NoResponse_Resubmit;
      if not SP_Submit then {���Ͷ���  {if MT List is null then send ActiveTest To CT}
        MT_ActiveTest; //���ŷ��Ͳ��ɹ���û�ж��ŷ���������·����
      Receive;
    end;
    if MTExit then //�˳�
      if HadLogin then
      begin
        if ExitCT then
        begin
          MTExit := False; break; end; //�˳��߳�
      end
      else
      begin
        MTExit := False; break;
      end;
      sleep(fsleeptime);
  except
    on e: exception do
    begin
      Statustr := '[' + datetimetostr(now) + ']' + 'MT Thread Error:' + e.Message;
      LogList.AddLog('10' + StatuTxt);
      synchronize(upmemo);
    end;
  end;
end;
procedure TCPSubmit.LoginCT;
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
    body.Version := GetVision; //ϵͳ֧�ֵİ汾��$20;
    body.loginmode := loginmode;
    DateTimeToString(timestr, 'MMDDHHMMSS', now);
    xLogin.body.Timestamp := winsock.Htonl(StrToInt(timestr));
    str1 := ClientID + #0#0#0#0#0#0#0 + sharesecret + timestr;
    MD5Init(md5_con);
    MD5Update(md5_con, pchar(str1), length(str1));
    MD5Final(md5_con, md5str);
    move(md5str, body.AuthenticatorClient, 16);
  end;
  try
    CTClient.Close;
  except
  end;
  try
    if CTClient.Connect then
      if sizeof(TLogin) = CTClient.SendBuf(xLogin, sizeof(xLogin), 0) then
      begin {//����}
        AddsSeq;
        StatuTxt := '��' + datetimetostr(now()) + '��SP-->CT(MT)LoginCT Request �������ӷ��͵�½����...';
        synchronize(showstatu);
        if CTClient.WaitForData(timeout) then
        begin
          if sizeof(TSMGPHead) = CTClient.ReceiveBuf(Head, sizeof(TSMGPHead), 0) then
          begin {//   ��ͷ}
            Active_test_time := now; //StrToInt(formatdatetime('ss', now)); //��½�ظ�ʱ��
            temp := winsock.Htonl(Head.RequestID);
            if Login_resp = temp then
              if CTClient.WaitForData(timeout) then
              begin
                if sizeof(TSMGPLogin_resp) = CTClient.ReceiveBuf(xLogin_resp, sizeof(TSMGPLogin_resp), 0) then
                begin
                  Status := HostToNet(xLogin_resp.Status);
                  case Status of
                    0:
                      begin
                        StatuTxt := '��' + datetimetostr(now()) + '��(MT)Login_Resp-- >�������ӳɹ���½�й�����'; HadLogin := True; MT_Warnning := 0; SCanExit := False; MTExit := False; StopCatchSMS := False; end;
                    1:
                      begin
                        StatuTxt := '��' + datetimetostr(now()) + '��(MT)Login_Resp-- >�������ӵ��Żظ�ϵͳæ�����Ժ��ٲ�'; CTClient.Close; sleep(RetryTime); StopCatchSMS := True; end;
                    21:
                      begin
                        StatuTxt := '��' + datetimetostr(now()) + '��(MT)Login_Resp-- >�������ӵ��Żظ���֤���󣡣�'; CTClient.Close; sleep(RetryTime); StopCatchSMS := True; end;
                  else
                    begin
                      StatuTxt := '��' + datetimetostr(now()) + '��(MT)Login_Resp-- >�������ӵ��Żظ�����ͻ��˽�������״̬ ' + inttostr(Status); CTClient.Close; sleep(RetryTime); StopCatchSMS := True; end;
                  end;
                  LogList.AddLog('10' + StatuTxt);
                end;
              end
              else
              begin
                StatuTxt := '��' + datetimetostr(now()) + '��(MT)Login�����������ӳ�ʱ,��·�ر�,�ȴ�' + inttostr(RetryTime div 1000) + '���µ�½...'; CTClient.Close; sleep(RetryTime); end;
          end;
        end
        else
        begin
          StatuTxt := '��' + datetimetostr(now()) + '��(MT)Login�����������ӳ�ʱ,��·�ر�,�ȴ�' + inttostr(RetryTime div 1000) + '�����µ�½...'; CTClient.Close; sleep(RetryTime); end;
        synchronize(showstatu);
      end;
  except
  end;
end;
procedure TCPSubmit.MT_ActiveTest;
var
  ActiveTest: TSMGPHead;
begin
  FillChar(ActiveTest, sizeof(TSMGPHead), 0);
  if CTClient.Connected then
  begin
    if DateUtils.SecondsBetween(now, Active_test_time) >= (ActiveTestTime div 1000) then
    begin
      with ActiveTest do
      begin
        ActiveTest.PacketLength := HostToNet(sizeof(TSMGPHead));
        ActiveTest.RequestID := HostToNet(Active_test);
        ActiveTest.SequenceID := HostToNet(sSequence);
      end;
      if sizeof(TSMGPHead) = CTClient.SendBuf(ActiveTest, sizeof(TSMGPHead), 0) then
      begin
        AddsSeq;
        StatuTxt := '��' + datetimetostr(now()) + '��(MT)ActiveTest ���з�����·���� ' + inttostr(HostToNet(ActiveTest.SequenceID));
        synchronize(showstatu);
      end;
    end;
  end;
end;
function TCPSubmit.ExitCT: boolean;
var
  SMGPExit: TSMGPHead;
  SMGPExit_Resp: TSMGPHead;
  temp: Longword;
begin
  Result := False;
  FillChar(SMGPExit, sizeof(TSMGPHead), 0);
  FillChar(SMGPExit_Resp, sizeof(TSMGPHead), 0);
  with SMGPExit do
  begin
    SMGPExit.PacketLength := HostToNet(sizeof(TSMGPHead));
    SMGPExit.RequestID := HostToNet(xExit);
    SMGPExit.SequenceID := HostToNet(sSequence);
  end;
  try
    if HadLogin then
      if sizeof(TSMGPHead) = CTClient.SendBuf(SMGPExit, sizeof(TSMGPHead), 0) then
      begin
        AddsSeq;
        StatuTxt := '��' + datetimetostr(now()) + '��SP-->CT(MT)ExitCT Request �������ӷ����˳�����...';
        synchronize(showstatu);
        if CTClient.WaitForData(timeout) then
        begin
          if sizeof(TSMGPHead) = CTClient.ReceiveBuf(SMGPExit_Resp, sizeof(TSMGPHead), 0) then
          begin
            temp := HostToNet(SMGPExit_Resp.RequestID);
            if temp = Exit_resp then
            begin
              CTClient.Close;
              Result := True;
              SCanExit := True;
              StatuTxt := '��' + datetimetostr(now()) + '��MT ExitCT --> ���������˳�����ŵ�����';
              synchronize(showstatu);
            end;
          end;
        end
        else
        begin
          CTClient.Close;
          SCanExit := True;
          Result := True;
          StatuTxt := '��' + datetimetostr(now()) + '��MT ExitCT Request �������ӷ����˳�����ʱ�������Ѿ��ر�';
          synchronize(showstatu);
        end;
      end;
  except
  end;
end;

procedure TCPSubmit.MTSocketError(Sender: TObject; SocketError: integer);
var
  Error: integer;
begin
  Error := SocketError;
  SocketError := 0;
  SCanExit := True;
  StatuTxt := '��' + datetimetostr(now) + '��(MT)������·�����������' + inttostr(Error) + ',�ȴ�' + inttostr(RetryTime div 1000) + '���ٴε�½...';
  StopCatchSMS := True;
  //SubmitButDisConn(now);
  synchronize(showstatu);
  LogList.AddLog('10' + StatuTxt);
  inc(MT_Warnning);
  if MT_Warnning > 10 then ErrWarnning := TWarnning.create;
  HadLogin := False;
  sleep(RetryTime);
end;

function TCPSubmit.SP_Submit: boolean;
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
  //=======================================================
  {2.0Э���}
  {FillChar(SMGPSubmit2011, sizeof(TSMGPSubmit2011), 0);
  FillChar(SMGPSubmit203, sizeof(TSMGPSubmit203), 0);
  FillChar(SMGPSubmit2021, sizeof(TSMGPSubmit2021), 0);
  FillChar(SMGPSubmit2022, sizeof(TSMGPSubmit2022), 0); }
  //=======================================================
  FillChar(rSubmit, sizeof(xSubmit), 0);
  if CTClient.Connected then
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
    SubmitSequence := MakeSockBuff(SubmitLen, rSubmit);
    try
      if (SubmitLen) = CTClient.SendBuf(SocketBuff[0], SubmitLen) then
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
        synchronize(upmemo);
      end
      else
      begin //���Ͳ��ɹ�
        new(xTCSubmit);
        xTCSubmit^ := rSubmit;
        SubmitList.Add(xTCSubmit);
      end;
      {    end;
  end
  else
  begin
    new(xTCSubmit);
    xTCSubmit^ := rSubmit;
    SubmitList.Add(xTCSubmit);
  end; }
    except
    end;
    SocketBuff := nil;
  end;
end;


procedure TCPSubmit.Receive;
var
  Head: TSMGPHead;
  CTSubmit_Resp: TSMGPDeliver_Resp; 
  SPResponse: PResponse;
  CTRequestID: Longword;
  CTsequence: Longword;
  Status: Longword;
  Rec_Len: Longword;
  MID: string;
begin
  FillChar(Head, sizeof(TSMGPHead), 0);
  FillChar(CTSubmit_Resp, sizeof(TSMGPDeliver_Resp), 0);
  CTRequestID := 0;
  CTsequence := 0;
  if CTClient.Connected then
    if CTClient.WaitForData(timeout) then
    begin
      if sizeof(TSMGPHead) = CTClient.ReceiveBuf(Head, sizeof(TSMGPHead)) then
      begin
        Active_test_time := now;  //������·�ظ�ʱ��
        CTRequestID := HostToNet(Head.RequestID); //��������
        CTsequence := HostToNet(Head.SequenceID); //���к�
        Rec_Len := HostToNet(Head.PacketLength);
        if Active_test_resp = CTRequestID then
        begin {//���ŷ�����·���Իظ�}
          StatuTxt := '��' + datetimetostr(now) + '��(MT)Active_Test_Resp ���Żظ�������·����...' + inttostr(CTsequence) + #32;
          LogList.AddLog('08' + StatuTxt);
          synchronize(showstatu);
        end
        else if Submit_resp = CTRequestID then
        begin {��������Submit_response}
          if CTClient.ReceiveBuf(CTSubmit_Resp, sizeof(TSMGPDeliver_Resp)) = sizeof(TSMGPDeliver_Resp) then
          begin
            Status := HostToNet(CTSubmit_Resp.Status);
            if ((Status > 0) and (Status < 10)) or (Status = 39) then //������Щ�����ʱ���ط�����
              ReSubmit(CTsequence, Status)
            else if Status = 0 then
            begin //����������ȷ����
              if not DeleteMT(CTsequence, MID) then //ɾ������������ ������MID
                Statustr := '��' + datetimetostr(now) + '��ɾ������������ʱû�з�����ȷ��MID';
              new(SPResponse);
              SPResponse^.MID := MID;
              strpcopy(SPResponse^.Submit_resp.MsgID, BCDToHex(CTSubmit_Resp.MsgID, sizeof(CTSubmit_Resp.MsgID)));
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
              DeleteMT(CTsequence, MID); //ɾ������������
              new(SPResponse);
              SPResponse^.MID := MID;
              strpcopy(SPResponse^.Submit_resp.MsgID, BCDToHex(CTSubmit_Resp.MsgID, sizeof(CTSubmit_Resp.MsgID)));
              SPResponse^.Submit_resp.Status := Status;
              ResponseList.Add(SPResponse); //�������л���������
              Statustr := '��' + datetimetostr(now) + '��Submit_Resp:' + MID + '����״̬=' + inttostr(Status) + ',����Ϣ�Ѿ���ɾ��';
              LogList.AddLog('09' + Statustr);
              synchronize(upmemo);
            end;
          end;
        end
        else if Active_test = CTRequestID then
        begin {���ŷ�����·����}
          StatuTxt := '��' + datetimetostr(now) + '��CT-->SP(MT) ActiveTest ' + inttostr(CTsequence);
          synchronize(showstatu);
          MTActive_Test_Resp(CTsequence);
        end
        else if Exit_resp = CTRequestID then
        begin
          CTClient.Close;
          SCanExit := True;
          StatuTxt := '��' + datetimetostr(now()) + '��MT ExitCT ���������˳�����ŵ�����';
          synchronize(showstatu);
        end
        else
        begin //����İ�ͷ������
          try
            SetLength(ErrMsg, Rec_Len - 12);
            CTClient.ReceiveBuf(ErrMsg, Rec_Len - 12);
            //SetLength(ErrMsg, 0);
            ErrMsg := nil;
          except
          end;
          StatuTxt := '��' + datetimetostr(now()) + '��MT ���յ����ʹ������Ϣ��'; 
          synchronize(showstatu);
        end;
      end;
    end;
  {else begin
    CTClient.Close;
    HadLogin := False;
    SCanExit := True;
    StatuTxt := '��' + datetimetostr(now) + '��(MT)���յȴ���ʱ,��·�ر�,�ȴ�' + inttostr(RetryTime div 1000) + '�����µ�½';
    synchronize(showstatu);
    sleep(RetryTime);
  end;}
end;
procedure TCPSubmit.MTActive_Test_Resp(CTsequence: Longword);
var
  spActiveTest_Resp: TSMGPHead;
begin
  FillChar(spActiveTest_Resp, sizeof(TSMGPHead), 0);
  spActiveTest_Resp.SequenceID := HostToNet(CTsequence);
  spActiveTest_Resp.PacketLength := HostToNet(sizeof(TSMGPHead));
  spActiveTest_Resp.RequestID := HostToNet(Active_test_resp);
  if CTClient.Connected then
    if sizeof(TSMGPHead) = CTClient.SendBuf(spActiveTest_Resp, sizeof(TSMGPHead)) then
    begin
      StatuTxt := '��' + datetimetostr(now()) + '��SP-->CT(MT)ActiveTest_Resp SP�ظ�������·����... ' + inttostr(CTsequence);
      synchronize(showstatu);
    end;
end;

procedure TCPSubmit.ReSubmit(SequenceID, statu: Longword);
var
  i: integer;
  cSubmit: PxSubmit;
  aList: TList;
  MID: string;
begin
  aList := SaveSubmitList.LockList;
  try
    for i := 0 to aList.count - 1 do
    begin
      cSubmit := PxSubmit(aList.Items[i]);
      if SequenceID = cSubmit^.SequenceID then
        if cSubmit^.Resend >= sendtimes then
        begin //�ط�4��ʧ�ܣ������ط�
          MID := cSubmit^.sSubmit.MID;
          dispose(cSubmit);
          aList.Delete(i);
          StatustrE := '��' + datetimetostr(now()) + '��Submit_Resp MID=' + MID + ' �������ط���״̬=' + inttostr(statu) + '���к�=' + inttostr(SequenceID) + ',��4���ʹ�ʧ�ܣ�����Ϣ�ѱ�ɾ��';
          LogList.AddLog('09' + StatustrE);
          synchronize(showError);
          break;
        end
        else
        begin
          SubmitList.Add(cSubmit);
          aList.Delete(i);
          MID := cSubmit^.sSubmit.MID;
          StatustrE := '��' + datetimetostr(now()) + '��Submit_Resp MID=' + MID + ' �������ط���״̬=' + inttostr(statu) + '����ʧ��,�ȴ��ٷ�...';
          synchronize(showError);
          break;
        end;
    end;
  finally
    SaveSubmitList.UnlockList;
  end;
end;
function TCPSubmit.DeleteMT(SequenceID: Longword; var aMid: string): boolean; //��������
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
        aMid := cSubmit^.sSubmit.MID; //����MID
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
          Statustr := '��' + datetimetostr(now()) + '��MID=' + #32 + cSubmit^.sSubmit.MID + #32 + '�ڷ���' + inttostr(resptime) + '���Ӻ���δ���յ����Ż�������,�������ط�����';
          synchronize(upmemo);
          LogList.AddLog('07' + Statustr);
        end;
      end;
    end;
  finally
    SaveSubmitList.UnlockList;
  end;
end;

procedure TCPSubmit.upmemo;
begin
  if SMGPGateWay.Memo1.Lines.count > 500 then SMGPGateWay.Memo1.Clear;
  if SMGPGateWay.N3.Checked then
    SMGPGateWay.Memo1.Lines.Add(Statustr + #13#10);
  SMGPGateWay.StatusBar1.Panels[7].Text := 'T: ' + inttostr(SPS_cou);
  SMGPGateWay.StatusBar1.Refresh;
end;

procedure TCPSubmit.showError;
begin
  if SMGPGateWay.Memo1.Lines.count > 500 then SMGPGateWay.Memo1.Clear;
  if SMGPGateWay.N2.Checked then
    SMGPGateWay.Memo1.Lines.Add(StatustrE + #13#10);
end;
procedure TCPSubmit.showstatu;
begin
  if SMGPGateWay.MeMO3.Lines.count > 1000 then SMGPGateWay.MeMO3.Clear;
  SMGPGateWay.MeMO3.Lines.Add(StatuTxt);
end;

procedure TCPSubmit.AddCou;
begin
  if SPS_cou > 2147483600 then SPS_cou := 1;
  inc(SPS_cou);
end;

procedure TCPSubmit.AddsSeq;
begin
  if sSequence >= 4294967200 then sSequence := 1;
  sSequence := sSequence + 1;
end;
function TCPSubmit.SubmitButDisConn(DisConnTime: TDateTime): integer;
var
  i, FirstCount: integer;
  cSubmit: PxSubmit;
  aList: TList;
  SPResponse: PResponse;
begin
  Result := 0; //����MID
  aList := SaveSubmitList.LockList;
  FirstCount := aList.count - 1; //�б��ʼԪ�ظ���
  try
    for i := FirstCount downto 0 do //ɨ�豣�����б�һ��
    begin
      cSubmit := PxSubmit(aList.Items[i]);
      if SecondsBetween(DisConnTime, cSubmit^.Then_DateTime) <= 5 then //������·�Ͽ�ǰ5��û�лظ���������Ĳ��ط�
      begin
        inc(Result);
        new(SPResponse);
        SPResponse^.MID := cSubmit^.sSubmit.MID;
        SPResponse^.Submit_resp.Status:=0;
        strpcopy(SPResponse^.Submit_resp.MsgID, '1186185' + formatdatetime('yymmddhhnn', now) + format('%.3d', [Result])); //�ֶ�����MsgID
        ResponseList.Add(SPResponse); //�������л���������
        Statustr := '��' + datetimetostr(now) + '������MID=' + #32 + cSubmit^.sSubmit.MID + #32 + '���·���·�Ͽ�û���յ���������,ϵͳ�����ط������������������Ѿ��ɹ�����';
        dispose(cSubmit);
        aList.Delete(i);
        synchronize(upmemo);
        LogList.AddLog('07' + Statustr);
      end;
    end;
  finally
    SaveSubmitList.UnlockList;
  end;
end;

procedure TCPSubmit.NoResponse_Resubmit;
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
        Statustr := '��' + datetimetostr(now()) + '��MID=' + #32 + cSubmit^.sSubmit.MID + #32 + '��' + inttostr(resptime) + '���Ӻ�û�н��յ����Ż�������,�������ط�����';
        synchronize(upmemo);
        LogList.AddLog('07' + Statustr);
      end;
    end;
  finally
    SaveSubmitList.UnlockList;
  end;
end;

function TCPSubmit.MakeSockBuff(var SubmitLen: integer; rSubmit: xSubmit): Longword;
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
end.

