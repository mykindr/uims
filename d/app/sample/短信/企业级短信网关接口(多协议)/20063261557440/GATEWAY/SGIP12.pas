{************************************
ModuleName: 	SGIP12 DEFINE
FileName:     SGIP12.PAS
DESCRIPTION:   RENWY SGIP 1.2 Protocol Message Definition
History:
Date       	Version			Modifier			 	Activies
2004/12/17	1.0				  CNRENWY			Create
************************************}
unit SGIP12;

interface
const
  SGIP12_VERSION = $12;

  SGIP12_BIND = $1; //�Կͻ�����֤
  SGIP12_BIND_RESP = $80000001; //����˷�����֤����
  SGIP12_UNBIND = $2; //�Ͽ�����
  SGIP12_UNBIND_RESP = $80000002; //���ضϿ�����״̬
  SGIP12_SUBMIT = $3; //��SMG�ύMT����Ϣ
  SGIP12_SUBMIT_RESP = $80000003; //����SP�ύMT����Ϣ״̬
  SGIP12_DELIVER = $4; //SMG��SP����һ��MO����Ϣ
  SGIP12_DELIVER_RESP = $80000004; //����SMG״̬
  SGIP12_REPORT = $5; //��SP����һ����ǰ��submit����ĵ�ǰ״̬
  SGIP12_REPORT_RESP = $80000005; //��ӦSMG״̬
  SGIP12_ADDSP = $6; //
  SGIP12_ADDSP_RESP = $80000006; //
  SGIP12_MODIFYSP = $7; //
  SGIP12_MODIFYSP_RESP = $80000007; //
  SGIP12_DELETESP = $8; //
  SGIP12_DELETESP_RESP = $80000008; //
  SGIP12_QUERYROUTE = $9; //
  SGIP12_QUERYROUTE_RESP = $80000009; //
  SGIP12_ADDTELESEG = $A; //
  SGIP12_ADDTELESEG_RESP = $8000000A; //
  SGIP12_MODIFYTELESEG = $B; //
  SGIP12_MODIFYTELESEG_RESP = $8000000B; //
  SGIP12_DELETETELESEG = $C; //
  SGIP12_DELETETELESEG_RESP = $8000000C; //
  SGIP12_ADDSMG = $D; //
  SGIP12_ADDSMG_RESP = $8000000D; //
  SGIP12_MODIFYSMG = $E; //
  SGIP12_MODIFYSMG_RESP = $0000000E; //
  SGIP12_DELETESMG = $F; //
  SGIP12_DELETESMG_RESP = $8000000F; //
  SGIP12_CHECKUSER = $10; //
  SGIP12_CHECKUSER_RESP = $80000010; //
  SGIP12_USERRPT = $11; //
  SGIP12_USERRPT_RESP = $80000011; //
  SGIP12_TRACE = $1000; //
  SGIP12_TRACE_RESP = $80001000; //
  MSG_LENGTH = 140; //�������ݳ���
  DestUsr_tl = 1; //������Ϣ���û�����(С��100���û�)��
type
  TSGIP12honeNum = array[0..20] of char;
  TEmpty = record //�ռ�¼
  end;
  //���ݰ���ͷ����

  TSGIP12_HEAD = packed record
   { MessageLength: LongWord; //��Ϣ���ܳ���(�ֽ�)
    CommandId: LongWord; //����ID
    //SNumber1, SNumber2, SNumber3: LongWord; //���к�
    SequenceNumber: LongWord; //���к�   }
    Message_Length: LongWord; //��Ϣ�ܳ���(����Ϣͷ����Ϣ��)
    Command_ID: LongWord; //�������Ӧ����
    SNumber1, SNumber2, SNumber3: longword; //���к�,��Ϣ��ˮ��,˳���ۼ�,����Ϊ1,ѭ��ʹ�ã�һ�������Ӧ����Ϣ����ˮ�ű�����ͬ��
  end;

  //��¼�����嶨��
  TSGIP12_Bind = packed record
    LonginType: byte;
    LonginPass: array[0..15] of char;
    LonginName: array[0..15] of char;
    Reserve: array[0..7] of char;
  end;

  //��¼Ӧ������嶨��
  TSGIP12_Bind_Resp = packed record
    result: byte;
    Reserve: array[0..7] of char;
  end;

  Unbind = TEmpty;
  Unbind_Resp = TEmpty;

  //������Ϣ�����嶨��
  TSGIP12_SUBMIT = packed record
    {SPNumber: array[0..20] of char;
    ChargeNumber: array[0..20] of char;
    UserCount: byte; //1-100
    UserNumber: array[0..20] of char; //TelCount;  file://����ΪUserCount
    CorpID: array[0..4] of char;
    ServiceType: array[0..9] of char;
    FeeType: byte;
    FeeValue: array[0..5] of char;
    GivenValue: array[0..5] of char;
    AgentFlag: byte;
    MOrelatetoMTFlag: byte;
    Priority: byte;
    ExpireTime: array[0..15] of char;
    ScheduleTime: array[0..15] of char;
    ReportFlag: byte;
    TP_pId: byte;
    TP_udhi: byte;
    MessageCoding: byte;
    MessageType: byte;
    MessageLength: LongWord;
    MessageContent: array[0..160] of char; //����Ϊ  MessageLength;
    Reserve: array[0..7] of char;
     }
    SPNumber: array[0..20] of Char; //SP�Ľ������
    ChargeNumber: array[0..20] of Char; //���Ѻ��룬�ֻ�����ǰ��"86"�����־�����ҽ���Ⱥ���Ҷ��û��շ�ʱΪ�գ����Ϊ�գ����������Ϣ�����ķ�����UserNumber������û�֧�������Ϊȫ���ַ���"000000000000000000000"����ʾ��������Ϣ�����ķ�����SP֧����
    UserCount: Byte; //���ն���Ϣ���ֻ�������ȡֵ��Χ1��100
    UserNumber: array[0..20] of Char; //���ոö���Ϣ���ֻ��ţ����ֶ��ظ�UserCountָ���Ĵ������ֻ�����ǰ��"86"�����־
    CorpId: array[0..4] of Char; //��ҵ���룬ȡֵ��Χ0-99999
    ServiceType: array[0..9] of Char; //ҵ����룬��SP����
    FeeType: Byte; //�Ʒ�����
    FeeValue: array[0..5] of Char; //ȡֵ��Χ0-99999����������Ϣ���շ�ֵ����λΪ�֣���SP������ڰ������շѵ��û�����ֵΪ����ѵ�ֵ
    GivenValue: array[0..5] of Char; //ȡֵ��Χ0-99999�������û��Ļ��ѣ���λΪ�֣���SP���壬��ָ��SP���û����͹��ʱ�����ͻ���
    AgentFlag: Byte; //���շѱ�־��0��Ӧ�գ�1��ʵ��
    MorelatetoMTFlag: Byte; //����MT��Ϣ��ԭ�� 0-MO�㲥����ĵ�һ��MT��Ϣ��1-MO�㲥����ķǵ�һ��MT��Ϣ��2-��MO�㲥�����MT��Ϣ��3-ϵͳ���������MT��Ϣ��
    Priority: Byte; //���ȼ�0-9�ӵ͵��ߣ�Ĭ��Ϊ0
    ExpireTime: array[0..16] of Char; //����Ϣ��������ֹʱ�䣬���Ϊ�գ���ʾʹ�ö���Ϣ���ĵ�ȱʡֵ��ʱ������Ϊ16���ַ�����ʽΪ"yymmddhhmmsstnnp" ������"tnnp"ȡ�̶�ֵ"032+"����Ĭ��ϵͳΪ����ʱ��
    ScheduleTime: array[0..16] of Char; //����Ϣ��ʱ���͵�ʱ�䣬���Ϊ�գ���ʾ���̷��͸ö���Ϣ��ʱ������Ϊ16���ַ�����ʽΪ"yymmddhhmmsstnnp" ������"tnnp"ȡ�̶�ֵ"032+"����Ĭ��ϵͳΪ����ʱ��
    ReportFlag: Byte; //״̬������ 0-������Ϣֻ��������ʱҪ����״̬���� 1-������Ϣ��������Ƿ�ɹ���Ҫ����״̬���� 2-������Ϣ����Ҫ����״̬���� 3-������Ϣ��Я�����¼Ʒ���Ϣ�����·����û���Ҫ����״̬���� ����-���� ȱʡ����Ϊ0
    TP_pid: Byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.9
    TP_udhi: Byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.23,��ʹ��1λ���Ҷ���
    MessageCoding: Byte; //����Ϣ�ı����ʽ��0����ASCII�ַ��� 3��д������ 4�������Ʊ��� 8��UCS2���� 15: GBK���� �����μ�GSM3.38��4�ڣ�SMS Data Coding Scheme
    MessageType: Byte; //��Ϣ���ͣ�0-����Ϣ��Ϣ ����������
    MessageLength: Byte; //����Ϣ�ĳ���
    MessageContent: array[0..MSG_LENGTH - 1] of Char; //����Ϣ������
    Reserve: array[0..7] of Char; //��������չ��
  end;

  //������ϢӦ������嶨��
  TSGIP12_SUBMIT_RESP = packed record
    result: byte;
    Reserve: array[0..7] of char;
  end;

  //������Ϣ�����嶨��
  TSGIP12_DELIVER = packed record
    {UserNumber: array[0..20] of char;
    SPNumber: array[0..27] of char;
    TP_pId: byte;
    TP_udhi: byte;
    MessageCoding: byte;
    MessageLength: LongWord;
    MessageContent: array[0..254] of char; //����Ϊ  MessageLength;
    Reserver: array[0..7] of char; }
    UserNumber: array[0..20] of Char; //���Ͷ���Ϣ���û��ֻ��ţ��ֻ�����ǰ��"86"�����־
    SPNumber: array[0..20] of Char; //SP�Ľ������
    TP_pid: Byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.9
    TP_udhi: Byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.23����ʹ��1λ���Ҷ���
    MessageCoding: Byte; //����Ϣ�ı����ʽ��0����ASCII�ַ���3��д������4�������Ʊ���8��UCS2����15: GBK���������μ�GSM3.38��4�ڣ�SMS Data Coding Scheme
    MessageLength: Byte; //����Ϣ�ĳ���
    MessageContent: array[0..MSG_LENGTH - 1] of Char; //����Ϣ������
    Reserve: array[0..7] of Char; //��������չ��
  end;

  //��������Ӧ������嶨��
  TSGIP12_DELIVER_RESP = packed record
    result: byte;
    Reserve: array[0..7] of char;
  end;

  //����
  TSGIP12_BODY = packed record
    case integer of
      1: (LOGIN: TSGIP12_Bind);
      2: (LOGIN_RESP: TSGIP12_Bind_Resp);
      3: (SUBMIT: TSGIP12_SUBMIT);
      4: (SUBMIT_RESP: TSGIP12_SUBMIT_RESP);
      5: (DELIVER: TSGIP12_DELIVER);
      6: (DELIVER_RESP: TSGIP12_DELIVER_RESP);
  end;

  //��
  TSGIP12_PACKET = packed record
    MsgHead: TSGIP12_HEAD;
    MsgBody: TSGIP12_BODY;
  end;

  //״̬����
  TSGIP12RPT = packed record
    SubSequNumber1, SubSequNumber2, SubSequNumber3: LongWord;
    ReportType: byte;
    UserNumber: array[0..20] of char;
    State: byte;
    ErrorCode: byte;
    Reserve: array[0..7] of char;
  end;

  TSGIP12RPT_Resp = packed record
    result: byte;
    Reserve: array[0..7] of char;
  end;

function SGIP12_StatusToDesc(Status: Cardinal): string;
function SGIP12_StatusToStr(Status: Cardinal): string;

implementation

uses
  SysUtils;

function SGIP12_StatusToStr(Status: Cardinal): string;
begin
  result := inttostr(Status);
  if length(result) = 1 then result := '00' + result;
  if length(result) = 2 then result := '0' + result;
end;

function SGIP12_StatusToDesc(Status: Cardinal): string;
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

