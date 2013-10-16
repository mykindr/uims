{������������������������������������������������}
{                  ���Ͱ�����                    }
{                        LUOXX                   }
{                             2004/3/11          }
{������������������������������������������������}

unit U_MsgInfo;

interface
uses Smgp13_XML, sysutils;

const
  MAX_DATA_LEN = 1024 * 3; //XML��󳤶�
  MAx_UserNumber = 100;//�������绰������

type
  TSMGPHead = packed record
    PacketLength: Longword; //������ �� ��ͷ������
    RequestID: Longword; //������
    SequenceID: Longword; //��Ϣ���
  end;

  TSMGPLogin = packed record
    clientID: array[0..7] of char; //�û���
    AuthenticatorClient: array[0..15] of char; //��֤
    LoginMode: byte; //��½ģʽ
    TimeStamp: Longword; //ʱ��
    Version: byte; //ϵͳ�汾��
  end;
  TLogin = packed record
    Head: TSMGPHead;
    body: TSMGPLogin;
  end;
  {���а�}
  PDeliver = ^TCTDeliver;
  TCTDeliver = packed record
    MsgID: array[0..9] of char; //���ز����Ķ���Ϣ��ˮ��
    IsReport: byte; //�Ƿ�״̬���棨0�����ǣ�1���ǣ�
    MsgFormat: byte; //����Ϣ��ʽ
    RecvTime: array[0..13] of char; //����Ϣ����ʱ��
    SrcTermID: array[0..20] of char; //����Ϣ���ͺ���
    DestTermID: array[0..20] of char; //����Ϣ���պ���
    MsgLength: byte; //����Ϣ����
    MsgContent: array[0..251] of char; //����Ϣ����
    Reserve: array[0..7] of char; //����
  end;

  TSMGPLogin_resp = packed record
    Status: Longword;
    AuthenticatorServer: array[0..15] of char;
    Version: byte;
  end;

  TLogin_resp = packed record
    Head: TSMGPHead;
    body: TSMGPLogin_resp;
  end;
  {���а�1.3Э��} //Endo Cancel
  {pSMGPSubmit = ^TSMGPSubmit;
  TSMGPSubmit = packed record
    MsgType: byte;
    NeedReport: byte;
    Priority: byte;
    ServiceID: array[0..9] of char;
    FeeType: array[0..1] of char;
    FeeCode: array[0..5] of char;
    FixedFee: array[0..5] of char;
    MsgFormat: byte;
    ValidTime: array[0..16] of char;
    AtTime: array[0..16] of char; //
    SrcTermID: array[0..20] of char;
    ChargeTermID: array[0..20] of char;
    DestTermIDCount: byte;
    DestTermID: array[0..21 * MAx_UserNumber - 1] of char;
    MsgLength: byte;
    MsgContent: array[0..251] of char; //string;
    Reserve: array[0..7] of char;
  end;}
  {-------------------------------------------------------------------------}

  
  {-------------------------------------------------------------------------}
  //��2.0Э���޸����а���ṹ
  TSMGPSubmit201 = packed record //����1
    MsgType: byte;
    NeedReport: byte;
    Priority: byte;
    ServiceID: array[0..9] of char;
    FeeType: array[0..1] of char;
    FeeCode: array[0..5] of char;  //
    FixedFee: array[0..5] of char; //2.0 ��1.3Э��������  FixedFee �ֶ���  FeeCode�Ի�
    MsgFormat: byte;
    ValidTime: array[0..16] of char; //2.0Э�鲻ͬ��1.3Э���������2���ֶ�ֵ �ǿ���ռ17λ
    AtTime: array[0..16] of char; //
  end;

  TSMGPSubmit2011 = packed record //��ͷ������1
    Head: TSMGPHead;
    body: TSMGPSubmit201;
  end;
  //------------------------------------------------------------------  

  {TSMGPSubmit2021 = packed record //����2
    ValidTime: array[0..16] of char; //2.0Э�鲻ͬ��1.3Э���������2���ֶ�ֵ �ǿ���ռ17λ
    AtTime: array[0..16] of char; //
  end; }

 // TSMGPSubmit2022 = packed record //����2
 //   ValidTime: char; //2.0Э�鲻ͬ��1.3Э���������2���ֶ�ֵ Ϊ����ռ1λ
 //   AtTime: char; //
 // end;
  //------------------------------------------------------------------
  TSMGPSubmit203 = packed record //����3
    SrcTermID: array[0..20] of char;
    ChargeTermID: array[0..20] of char;
    DestTermIDCount: byte;
    DestTermID: array[0..21 * MAX_UserNumber - 1] of char;
    MsgLength: byte;
    MsgContent: array[0..251] of char; //string;
    Reserve: array[0..7] of char;
  end;
  {-------------------------------------------------------------------------}
  {-------------------------------------------------------------------------}

  {TSubmit = packed record  //Endo Cancel
    Head: TSMGPHead;
    body: TSMGPSubmit;
  end;}
  //�ڲ����ṹ����
  PxSubmit = ^xSubmit; {//}
  xSubmit = packed record
    Resend: byte; //�·�����
    SequenceID: Longword; //��ͷ���к�
    Then_DateTime: TDateTime;
    sSubmit: TTCSubmit;
  end;

  TDeliver = packed record
    Head: TSMGPHead;
    body: TTCDeliver;
  end;

  TSMGPDeliver_Resp = packed record {���������ṹ��ͬSubmit_resp }
    MsgID: array[0..9] of char;
    Status: Longword;
  end;
  TSMGPSubmit_Resp = packed record {���������ṹ��ͬSubmit_resp }
    MsgID: array[0..19] of char; //BCD10λ���20λ
    Status: Longword;
  end;
  TDeliver_Resp = packed record
    Head: TSMGPHead;
    body: TSMGPDeliver_Resp;
  end;

  TSubmit_resp = packed record
    Head: TSMGPHead;
    body: TSMGPDeliver_Resp;
  end;

  pSubmitMid = ^TSubmitMid;
  TSubmitMid = packed record
    Mid: string;
    sequence: Longword;
  end;

  {���л������м������}
  PResponse = ^TSPResponse;
  TSPResponse = packed record
    Mid: string;
    Submit_resp: TSMGPSubmit_Resp;
  end;

  {���/ͣ��}
  pCT_Free_Stop = ^TCT_Free_Stop;
  TCT_Free_Stop = packed record
    MsgID: string;
    SrcTermID: string;
    DestTermID: string;
    Free_Stop_time: string;
    Status: char;
  end;

  {�ڲ�Э��}

  CTSMSHeader = packed record
    Total_Length: Longword;
    Command_ID: Word;
    Status_ID: Word;
    Sequence_ID: Word;
    Version: Word;
  end;

  TSPPack = packed record
    Header: CTSMSHeader;
    body: array[0..MAX_DATA_LEN - 1] of char;
  end;



  {function}
function writeXmlResponse(xSPResponse: TSPResponse): string;
function writeXmluserFeeSop(xCT_Free_Stop: TCT_Free_Stop): string;
implementation

function writeXmlResponse(xSPResponse: TSPResponse): string;
begin
  Result := '';
  Result := '<?xml version="1.0" encoding="UTF-8"?>';
  Result := Result + '<SubmitResp>';
  Result := Result + '<Mid>' + xSPResponse.Mid + '</Mid>';
  Result := Result + '<MsgID>' + xSPResponse.Submit_resp.MsgID + '</MsgID>';
  Result := Result + '<Status>' + inttostr(xSPResponse.Submit_resp.Status) + '</Status>';
  Result := Result + '</SubmitResp>';
end;
function writeXmluserFeeSop(xCT_Free_Stop: TCT_Free_Stop): string;
begin
  Result := '';
  Result := '<?xml version="1.0" encoding="UTF-8"?>';
  Result := Result + '<UserFreeStop>';
  Result := Result + '<MsgID>' + xCT_Free_Stop.MsgID + '</MsgID>';
  Result := Result + '<SrcTermID>' + xCT_Free_Stop.SrcTermID + '</SrcTermID>';
  Result := Result + '<DestTermID>' + xCT_Free_Stop.DestTermID + '</DestTermID>';
  Result := Result + '<Free_Stop_time>' + xCT_Free_Stop.Free_Stop_time + '</Free_Stop_time>';
  Result := Result + '<Status>' + xCT_Free_Stop.Status + '</Status>';
  Result := Result + '</UserFreeStop>';
end;

end.

