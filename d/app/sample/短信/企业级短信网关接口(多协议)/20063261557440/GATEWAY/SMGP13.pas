unit SMGP13;

interface
const
  SMGP13_VERSION = $13;
  SMGP13_LOGIN = $00000001; //  CP ��SMGW ��¼����
  SMGP13_LOGIN_RESP = $80000001; //  CP ��SMGW ��¼��Ӧ
  SMGP13_SUBMIT = $00000002; //  CP ���Ͷ���Ϣ����
  SMGP13_SUBMIT_RESP = $80000002; //  CP ���Ͷ���Ϣ��Ӧ
  SMGP13_DELIVER = $00000003; //  SMGW ��CP ���Ͷ���Ϣ����
  SMGP13_DELIVER_RESP = $80000003; //  SMGW ��CP ���Ͷ���Ϣ��Ӧ
  SMGP13_ACTIVE_TEST = $00000004; //  ����ͨ����·�Ƿ����������ɿͻ��˷���CP ��SMGW����ͨ����ʱ���ʹ�������ά�����ӣ�
  SMGP13_ACTIVE_TEST_RESP = $80000004; //  ����ͨ����·�Ƿ�������Ӧ

type
  TSMGP13PhoneNum = array[0..20] of char;

  //���ݰ���ͷ����
  TSMGP13_HEAD = packed record
    PacketLength: Cardinal;
    RequestID: Cardinal;
    SequenceID: Cardinal;
  end;

  //��¼�����嶨��
  TSMGP13_LOGIN = packed record
    ClientID: array[0..7] of char;
    AuthenticatorClient: array[0..15] of char;
    LoginMode: byte;
    TimeStamp: Cardinal;
    Version: byte;
  end;

  //��¼Ӧ������嶨��
  TSMGP13_LOGIN_RESP = packed record
    Status: Cardinal;
    AuthenticatorServer: array[0..15] of char;
    Version: byte;
  end;

  //������Ϣ�����嶨��
  TSMGP13_SUBMIT = packed record
    MsgType: byte;
    NeedReport: byte;
    Priority: byte;
    ServiceID: array[0..9] of char;
    FeeType: array[0..1] of char;
    FeeCode: array[0..5] of char;
    FixedFee: array[0..5] of char;
    MsgFormat: byte;
    ValidTime: array[0..16] of char;
    AtTime: array[0..16] of char;
    SrcTermID: TSMGP13PhoneNum;
    ChargeTermID: TSMGP13PhoneNum;
    DestTermIDCount: byte;
    DestTermID: TSMGP13PhoneNum;
    MsgLength: byte;
    MsgContent: array[0..252] of char;
    Reserve: array[0..7] of char;
  end;

  //������ϢӦ������嶨��
  TSMGP13_SUBMIT_RESP = packed record
    MsgID: array[0..9] of char;
    Status: Cardinal;
  end;

  //������Ϣ�����嶨��
  TSMGP13_DELIVER = packed record
    MsgID: array[0..9] of char;
    IsReport: byte;
    MsgFormat: byte;
    RecvTime: array[0..13] of char;
    SrcTermID: TSMGP13PhoneNum;
    DestTermID: TSMGP13PhoneNum;
    MsgLength: byte;
    MsgContent: array[0..251] of char;
    Reserve: array[0..7] of char;
  end;

  //��������Ӧ������嶨��
  TSMGP13_DELIVER_RESP = packed record
    MsgID: array[0..9] of char;
    Status: Cardinal;
  end;

  //����
  TSMGP13_BODY = packed record
    case integer of
      1: (LOGIN: TSMGP13_LOGIN);
      2: (LOGIN_RESP: TSMGP13_LOGIN_RESP);
      3: (SUBMIT: TSMGP13_SUBMIT);
      4: (SUBMIT_RESP: TSMGP13_SUBMIT_RESP);
      5: (DELIVER: TSMGP13_DELIVER);
      6: (DELIVER_RESP: TSMGP13_DELIVER_RESP);
  end;

  //��
  TSMGP13_PACKET = packed record
    MsgHead: TSMGP13_HEAD;
    MsgBody: TSMGP13_BODY;
  end;

  //״̬����
  TSMGP13RPT = packed record
    TID: array[0..2] of char; //�ַ�'id:' 3�ֽ�
    ID: array[0..9] of char; //��Ϣid 10�ֽ�
    SP1: char; //�ո� 1�ֽ�
    TSUB: array[0..3] of char; //sub: 4�ֽ�
    SUB: array[0..2] of char; //001 3�ֽ�
    SP2: char; //�ո� 1����
    TDLVRD: array[0..5] of char; //dlvrd: 6�ֽ�
    DLVRD: array[0..2] of char; //001 3�ֽ�
    SP3: char; //�ո� 1�ֽ�
    TSUBMITDATE: array[0..11] of char; //submit date: 12�ֽ�
    SUBMITDATE: array[0..9] of char; //YYMMDDHHMI   10�ֽ�
    SP4: char; //�ո� 1
    TDONEDATE: array[0..9] of char; //TODO date: 10
    DONEDATE: array[0..9] of char; //10
    sp5: char; //�ո� 1�ֽ�
    tSTAT: array[0..4] of char; //5
    stat: array[0..6] of char; //7
    sp6: char; //
    tERR: array[0..3] of char; //
    Err: array[0..2] of char; //
    sp7: char; //
    tTXT: array[0..3] of char; //
    sp8: char;
    txt: array[0..2] of char; //
    msgcon: array[0..16] of char; //
    sp9: char; //  #0
  end;

function SMGP13_StatusToDesc(Status: Cardinal): string;
function SMGP13_StatusToStr(Status: Cardinal): string;

implementation

uses
  SysUtils;

function SMGP13_StatusToStr(Status: Cardinal): string;
begin
  result := inttostr(Status);
  if length(result) = 1 then result := '00' + result;
  if length(result) = 2 then result := '0' + result;
end;

function SMGP13_StatusToDesc(Status: Cardinal): string;
begin
  case Status of
    0: result := '�ɹ�';
    1: result := 'ϵͳæ';
    2: result := '�������������';
    3..9: result := '����';
    10: result := '��Ϣ�ṹ��';
    11: result := '�����ִ�';
    12: result := '���к��ظ�';
    13..19: result := '����';
    20: result := 'IP ��ַ��';
    21: result := '��֤��';
    22: result := '�汾̫��';
    23..29: result := '����';
    30: result := '�Ƿ���Ϣ���ͣ�SMType��';
    31: result := '�Ƿ����ȼ���Priority��';
    32: result := '�Ƿ��ʷ����ͣ�FeeType��';
    33: result := '�Ƿ��ʷѴ��루FeeCode��';
    34: result := '�Ƿ�����Ϣ��ʽ��MsgFormat��';
    35: result := '�Ƿ�ʱ���ʽ';
    36: result := '�Ƿ�����Ϣ���ȣ�MsgLength��';
    37: result := '��Ч���ѹ�';
    38: result := '�Ƿ���ѯ���QueryType��';
    39: result := '·�ɴ���';
    40: result := '�Ƿ�����/�ⶥ��(FIXEDFEE)';
    41: result := '�Ƿ��������ͣ�UPDATETYPE��';
    42: result := '�Ƿ�·�ɱ�ţ�ROUTERID��';
    43: result := '�Ƿ�������루SERVICEID��';
    44: result := '�Ƿ���Ч�ڣ�VALIDTIME��';
    45: result := '�Ƿ���ʱ����ʱ�䣨ATTIME��';
    46: result := '�Ƿ������û����루SRCTERMID��';
    47: result := '�Ƿ������û����루DESTTERMID��';
    48: result := '�Ƿ��Ʒ��û����루CHARGETERMID��';
    49: result := '�Ƿ�SP����';
    50..127: result := '����';
    128..255: result := '�����Զ���';
  end;
end;

end.

