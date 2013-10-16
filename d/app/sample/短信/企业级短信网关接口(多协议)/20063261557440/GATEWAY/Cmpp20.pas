unit Cmpp20;

interface


const
  CMPP_VERSION = $20;
  CMPP_CONNECT = $00000001; //  CP ��SMGW ��¼����
  CMPP_CONNECT_RESP = $80000001;
  CMPP_TERMINATE = $00000002;
  CMPP_TERMINATE_RESP = $80000002;
  CMPP_SUBMIT = $00000004;
  CMPP_SUBMIT_RESP = $80000004;
  CMPP_DELIVER = $00000005;
  CMPP_DELIVER_RESP = $80000005;
  CMPP_QUERY = $00000006;
  CMPP_QUERY_RESP = $80000006;
  CMPP_CANCEL = $00000007;
  CMPP_CANCEL_RESP = $80000007;
  CMPP_ACTIVE_TEST = $00000008;
  CMPP_ACTIVE_TEST_RESP = $80000008;
  CMPP_FWD = $00000009;
  CMPP_FWD_RESP = $80000009;
  CMPP_MT_ROUTE = $00000010;
  CMPP_MT_ROUTE_RESP = $80000010;
  CMPP_MO_ROUTE = $00000011;
  CMPP_MO_ROUTE_RESP = $80000011;
  CMPP_GET_ROUTE = $00000012;
  CMPP_GET_ROUTE_RESP = $80000012;
  CMPP_MT_ROUTE_UPDATE = $00000013;
  CMPP_MT_ROUTE_UPDATE_RESP = $80000013;
  CMPP_MO_ROUTE_UPDATE = $00000014;
  CMPP_MO_ROUTE_UPDATE_RESP = $80000014;
  CMPP_PUSH_MT_ROUTE_UPDATE = $00000015;
  CMPP_PUSH_MT_ROUTE_UPDATE_RESP = $80000015;
  CMPP_PUSH_MO_ROUTE_UPDATE = $00000016;
  CMPP_PUSH_MO_ROUTE_UPDATE_RESP = $80000016;

  CMPP_REPORT: LongWord = $00000050; //CMPPЭ����û�д���Ϣ��Ϊ������CMPP_DELIVER��

  MSG_LENGTH = 140; //�������ݳ���
  //Queue_Max_Length = 1000; //���е���󳤶�

  //Connect ����ֵ
  ERR_CONNECT_SUCCESS = $00; //������ȷ
  ERR_CONNECT_BODY = $01; //�ṹ�����
  ERR_CONNECT_INVALID_SP_ID = $02; //�Ƿ�SP ID
  ERR_CONNECT_SP_AUTHENTICATION = $03; //SP��֤��
  ERR_CONNECT_VERSION = $04; //�汾̫��

  //Submit ����ֵ
  ERR_SUBMIT_SUCCESS = $00; //�ɹ�
  ERR_SUBMIT_BODY = $01; //�ṹ���
  ERR_SUBMIT_COMMAND = $02; //�����
  ERR_SUBMIT_MSG_ID = $03; //��ˮ���ظ�
  ERR_SUBMIT_MSG_LENGTH = $04; //��Ϣ���ȴ�
  ERR_SUBMIT_FEE_CODE = $05; //�ʷѴ����
  ERR_SUBMIT_TO_LONG = $06; //��Ϣ̫��
  ERR_SUBMIT_SERVICE_ID = $07; //ҵ������
  ERR_SUBMIT_FLOW_CONTROL = $08; //�������ƴ�

  //Deliver ����ֵ
  ERR_DELIVER_SUCCESS = $00; //�ɹ�
  ERR_DELIVER_BODY = $01; //�ṹ���
  ERR_DELIVER_COMMAND = $02; //�����
  ERR_DELIVER_MSG_ID = $03; //��ˮ���ظ�
  ERR_DELIVER_MSG_LENGTH = $04; //��Ϣ���ȴ�
  ERR_DELIVER_FEE_CODE = $05; //�ʷѴ����
  ERR_DELIVER_TO_LONG = $06; //��Ϣ̫��
  ERR_DELIVER_SERVICE_ID = $07; //ҵ������
  ERR_DELIVER_FLOW_CONTROL = $08; //�������ƴ�

  //Cancel ����ֵ
  ERR_CANCEL_SUCCESS = $00; //�ɹ�
  ERR_CANCEL_FAULT = $01; //ʧ��

  //Active ����ֵ
  ERR_ACTIVE_SUCCESS = $00; //�ɹ�
type
  ////////////////////////////////////////////////////////////////////////////
  TCMPPPhoneNum = array[0..20] of char;
  TEmpty = record //�ռ�¼
  end;

  //���ݰ���ͷ����
  //��Ϣͷ
  TCMPP_HEAD = packed record
    Total_Length: LongWord; //��Ϣ�ܳ���(����Ϣͷ����Ϣ��)
    Command_ID: LongWord; //�������Ӧ����
    Sequence_ID: LongWord; //��Ϣ��ˮ��,˳���ۼ�,����Ϊ1,ѭ��ʹ�ã�һ�������Ӧ����Ϣ����ˮ�ű�����ͬ��
  end;

  //��¼�����嶨��
  // SP �������ӵ� ISMG
  TCMPP_CONNECT = packed record
    Source_Addr: array[0..5] of char; //Դ��ַ���˴�ΪSP_Id����SP����ҵ���롣
    AuthenticatorSource: array[0..15] of char; //���ڼ���Դ��ַ����ֵͨ������MD5 hash����ó�����ʾ���£�AuthenticatorSource =MD5��Source_Addr+9 �ֽڵ�0 +shared secret+timestamp��Shared secret ���й��ƶ���Դ��ַʵ�������̶���timestamp��ʽΪ��MMDDHHMMSS��������ʱ���룬10λ��
    Version: byte; //˫��Э�̵İ汾��(��λ4bit��ʾ���汾��,��λ4bit��ʾ�ΰ汾��)
    TimeStamp: LongWord; //ʱ���������,�ɿͻ��˲���,��ʽΪMMDDHHMMSS��������ʱ���룬10λ���ֵ����ͣ��Ҷ��� ��
    //Timestamp:  Cardinal; //ʱ���������,�ɿͻ��˲���,��ʽΪMMDDHHMMSS��������ʱ���룬10λ���ֵ����ͣ��Ҷ��� ��
  end;

  //��¼Ӧ������嶨��
  TCMPP_CONNECT_RESP = packed record
    Status: byte; //״̬0����ȷ1����Ϣ�ṹ�� 2���Ƿ�Դ��ַ 3����֤�� 4���汾̫��  5~ ����������
    AuthenticatorISMG: array[0..15] of char; //ISMG��֤�룬���ڼ���ISMG����ֵͨ������MD5 hash����ó�����ʾ���£�AuthenticatorISMG =MD5��Status+AuthenticatorSource+shared secret����Shared secret ���й��ƶ���Դ��ַʵ�������̶���AuthenticatorSourceΪԴ��ַʵ�巢�͸�ISMG�Ķ�Ӧ��ϢCMPP_Connect�е�ֵ�� ��֤����ʱ������Ϊ��
    Version: byte; //������֧�ֵ���߰汾��
  end;

  // SP �� ISMG ����������
  TCMPP_TERMINATE_tag = TEmpty;

  TCMPP_TERMINATE_RESP_tag = TEmpty;

  //������Ϣ�����嶨��
  // SP �� ISMG �ύ����
  TCMPP_SUBMIT = packed record
    Msg_Id: Int64; //��Ϣ��ʶ����SP��������ر��������������ա�
    Pk_total: byte; //��ͬMsg_Id����Ϣ����������1��ʼ
    Pk_number: byte; //��ͬMsg_Id����Ϣ��ţ���1��ʼ
    Registered_Delivery: byte; //�Ƿ�Ҫ�󷵻�״̬ȷ�ϱ��棺0������Ҫ1����Ҫ2������SMC���� �������Ͷ��Ž������ؼƷ�ʹ�ã������͸�Ŀ���ն�)
    Msg_level: byte; //��Ϣ����
    service_id: array[0..9] of char; //ҵ�����ͣ������֡���ĸ�ͷ��ŵ���ϡ�
    Fee_UserType: byte; //�Ʒ��û������ֶ�0����Ŀ���ն�MSISDN�Ʒѣ�1����Դ�ն�MSISDN�Ʒѣ�2����SP�Ʒ�;3����ʾ���ֶ���Ч����˭�ƷѲμ�Fee_terminal_Id�ֶΡ�
    //Fee_terminal_Id: array[0..20] of Char; //���Ʒ��û��ĺ��루�籾�ֽ���գ����ʾ���ֶ���Ч����˭�ƷѲμ�Fee_Userstruct�ֶΣ����ֶ���Fee_Userstruct�ֶλ��⣩
    Fee_terminal_Id: TCMPPPhoneNum;
    TP_pId: byte; //GSMЭ�����͡���ϸ�ǽ�����ο�GSM03.40�е�9.2.3.9
    TP_udhi: byte; //GSMЭ�����͡���ϸ�ǽ�����ο�GSM03.40�е�9.2.3.23,��ʹ��1λ���Ҷ���
    Msg_Fmt: byte; //��Ϣ��ʽ  0��ASCII��  3������д������  4����������Ϣ  8��UCS2����15����GB����
    msg_src: array[0..5] of char; //��Ϣ������Դ(SP_Id)
    FeeType: array[0..1] of char; //�ʷ����01����"�Ʒ��û�����"���
    FeeCode: array[0..5] of char; //�ʷѴ��루�Է�Ϊ��λ��
    Valid_Time: array[0..16] of char; //�����Ч�ڣ���ʽ��ѭSMPP3.3Э��
    At_Time: array[0..16] of char; //��ʱ����ʱ�䣬��ʽ��ѭSMPP3.3Э��
    //Src_Id: array[0..20] of Char; //Դ����SP�ķ�������ǰ׺Ϊ�������ĳ�����, ���ؽ��ú����������SMPPЭ��Submit_SM��Ϣ��Ӧ��source_addr�ֶΣ��ú����������û��ֻ�����ʾΪ����Ϣ�����к���
    Src_ID: TCMPPPhoneNum; //Դ����SP�ķ�������ǰ׺Ϊ�������ĳ�����, ���ؽ��ú����������SMPPЭ��Submit_SM��Ϣ��Ӧ��source_addr�ֶΣ��ú����������û��ֻ�����ʾΪ����Ϣ�����к���
    DestUsr_tl: byte; //������Ϣ���û�����(С��100���û�)
    //Dest_terminal_Id: array[0..20] of Char; //���ն��ŵ�MSISDN����
    dest_terminal_id: TCMPPPhoneNum; //���ն��ŵ�MSISDN����
    MSG_LENGTH: byte; //��Ϣ����(Msg_FmtֵΪ0ʱ��<160���ֽڣ�����<=140���ֽ�)
    Msg_Content: array[0..MSG_LENGTH - 1] of char; //��Ϣ����
    Reserve: array[0..7] of char; //����
  end;

  //��������Ӧ������嶨��
  TCMPP_SUBMIT_RESP = packed record
    Msg_Id: Int64; //��Ϣ��ʶ
    result: byte; //���
  end;

  //���а����嶨��
  // ISMG �� SP �ͽ�����
  // ������CMPP�У�DELIVER��REPORTͬһ������ţ����Զ�������Ҳ������,���ȶ�ǰ
  // ���ݣ��ٴ�Msg_Length��Registered_Delivery���ж�ʣ�೤�Ⱥ�����
  TCMPP_DELIVER_HEAD = packed record
    Msg_Id: Int64; //��Ϣ��ʶ
    Dest_Id: array[0..20] of char; //Ŀ�ĺ���
    service_id: array[0..9] of char; //ҵ�����ͣ������֡���ĸ�ͷ��ŵ���ϡ�
    TP_pId: byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.9
    TP_udhi: byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.23����ʹ��1λ���Ҷ���
    Msg_Fmt: byte; //��Ϣ��ʽ
    Src_terminal_Id: array[0..20] of char; //Դ�ն�MSISDN����
    Registered_Delivery: byte; //�Ƿ�Ϊ״̬����0����״̬����1��״̬����
    MSG_LENGTH: byte; //��Ϣ����
  end;
  // Deliver��벿��
  //PCMPP_DELIVER_tag = ^TCMPP_DELIVER_tag;
  TCMPP_DELIVER = packed record
    Msg_Id: Int64; //��Ϣ��ʶ
    Dest_Id: array[0..20] of char; //Ŀ�ĺ���
    service_id: array[0..9] of char; //ҵ�����ͣ������֡���ĸ�ͷ��ŵ���ϡ�
    TP_pId: byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.9
    TP_udhi: byte; //GSMЭ�����͡���ϸ������ο�GSM03.40�е�9.2.3.23����ʹ��1λ���Ҷ���
    Msg_Fmt: byte; //��Ϣ��ʽ
    Src_terminal_Id: array[0..20] of char; //Դ�ն�MSISDN����
    Registered_Delivery: byte; //�Ƿ�Ϊ״̬����0����״̬����1��״̬����
    MSG_LENGTH: byte; //��Ϣ����
    Msg_Content: array[0..MSG_LENGTH - 1] of char; //��Ϣ����
    Reserved: array[0..7] of char; //������
  end;
  // ISMG �� SP �ͽ�״̬����
  PCMPP_Report_tag = ^TCMPP_Report_tag;
  TCMPP_Report_tag = packed record
    //  ISMG �� SP �ͽ�״̬����ʱ����Ϣ�����ֶ�(Msg_Content)��ʽ����
    Msg_Id: Int64; //��Ϣ��ʶ
    stat: array[0..6] of char; //����Ӧ���������CMPP
    Submit_time: array[0..9] of char; //�ύʱ��
    Done_time: array[0..9] of char; //���ʱ��
    dest_terminal_id: array[0..20] of char; //Ŀ���ն˺���
    SMSC_sequence: LongWord;
    //////////////////////////////
    Reserved: array[0..7] of char; //������
  end;

  //���а�Ӧ������嶨��
  //PCMPP_DELIVER_RESP_tag = ^TCMPP_DELIVER_RESP_tag;
  TCMPP_DELIVER_RESP = packed record
    Msg_Id: Int64; //��Ϣ��ʶ
    result: byte; //���
  end;


  //����Ⱥ�� ע����Ⱥ���У����� �ֻ����ǿɱ䳤�ģ������ڳ����ж��壬����Ϊ21*�ֻ�����
  PCMPP_SUBMIT_QF_tag1 = ^TCMPP_SUBMIT_QF_tag1;
  TCMPP_SUBMIT_QF_tag1 = packed record
    Msg_Id: Int64; //��Ϣ��ʶ����SP��������ر��������������ա�
    Pk_total: byte; //��ͬMsg_Id����Ϣ����������1��ʼ
    Pk_number: byte; //��ͬMsg_Id����Ϣ��ţ���1��ʼ
    Registered_Delivery: byte; //�Ƿ�Ҫ�󷵻�״̬ȷ�ϱ��棺0������Ҫ1����Ҫ2������SMC���� �������Ͷ��Ž������ؼƷ�ʹ�ã������͸�Ŀ���ն�)
    Msg_level: byte; //��Ϣ����
    service_id: array[0..9] of char; //ҵ�����ͣ������֡���ĸ�ͷ��ŵ���ϡ�
    Fee_UserType: byte; //�Ʒ��û������ֶ�0����Ŀ���ն�MSISDN�Ʒѣ�1����Դ�ն�MSISDN�Ʒѣ�2����SP�Ʒ�;3����ʾ���ֶ���Ч����˭�ƷѲμ�Fee_terminal_Id�ֶΡ�
    Fee_terminal_Id: array[0..20] of char; //���Ʒ��û��ĺ��루�籾�ֽ���գ����ʾ���ֶ���Ч����˭�ƷѲμ�Fee_Userstruct�ֶΣ����ֶ���Fee_Userstruct�ֶλ��⣩
    TP_pId: byte; //GSMЭ�����͡���ϸ�ǽ�����ο�GSM03.40�е�9.2.3.9
    TP_udhi: byte; //GSMЭ�����͡���ϸ�ǽ�����ο�GSM03.40�е�9.2.3.23,��ʹ��1λ���Ҷ���
    Msg_Fmt: byte; //��Ϣ��ʽ  0��ASCII��  3������д������  4����������Ϣ  8��UCS2����15����GB����
    msg_src: array[0..5] of char; //��Ϣ������Դ(SP_Id)
    FeeType: array[0..1] of char; //�ʷ����01����"�Ʒ��û�����"���
    FeeCode: array[0..5] of char; //�ʷѴ��루�Է�Ϊ��λ��
    Valid_Time: array[0..16] of char; //�����Ч�ڣ���ʽ��ѭSMPP3.3Э��
    At_Time: array[0..16] of char; //��ʱ����ʱ�䣬��ʽ��ѭSMPP3.3Э��
    Src_ID: array[0..20] of char; //Դ����SP�ķ�������ǰ׺Ϊ�������ĳ�����, ���ؽ��ú����������SMPPЭ��Submit_SM��Ϣ��Ӧ��source_addr�ֶΣ��ú����������û��ֻ�����ʾΪ����Ϣ�����к���
    DestUsr_tl: byte; //������Ϣ���û�����(С��100���û�)
  end;

  PCMPP_SUBMIT_QF_tag2 = ^TCMPP_SUBMIT_QF_tag2;
  TCMPP_SUBMIT_QF_tag2 = packed record
    MSG_LENGTH: byte; //��Ϣ����(Msg_FmtֵΪ0ʱ��<160���ֽڣ�����<=140���ֽ�)
    Msg_Content: array[0..MSG_LENGTH - 1] of char; //��Ϣ����
    Reserve: array[0..7] of char; //����
  end;

  // SP �� ISMG ��ѯ���Ͷ���״̬
  PCMPP_QUERY_tag = ^TCMPP_QUERY_tag;
  TCMPP_QUERY_tag = packed record
    Time: array[0..7] of char; //ʱ��YYYYMMDD(��ȷ����)
    Query_Type: byte; //��ѯ���0��������ѯ1����ҵ�����Ͳ�ѯ
    Query_Code: array[0..9] of char; //��ѯ�뵱Query_structΪ0ʱ��������Ч����Query_structΪ1ʱ��������дҵ������Service_Id.
    Reserve: array[0..7] of char; //����
  end;

  PCMPP_QUERY_RESP_tag = ^TCMPP_QUERY_RESP_tag;
  TCMPP_QUERY_RESP_tag = packed record
    Time: array[0..7] of char; //ʱ��(��ȷ����)
    Query_Type: byte; //��ѯ���0��������ѯ1����ҵ�����Ͳ�ѯ
    Query_Code: array[0..9] of char; //��ѯ��
    MT_TLMsg: LongWord; //��SP������Ϣ����
    MT_Tlusr: LongWord; //��SP�����û�����
    MT_Scs: LongWord; //�ɹ�ת������
    MT_WT: LongWord; //��ת������
    MT_FL: LongWord; //ת��ʧ������
    MO_Scs: LongWord; //��SP�ɹ��ʹ�����
    MO_WT: LongWord; //��SP���ʹ�����
    MO_FL: LongWord; //��SP�ʹ�ʧ������
  end;
  ////////////////////////////////////////////////////////////////////////////
  // SP �� ISMG ����ɾ�����Ų���
  PCMPP_CANCEL_tag = ^TCMPP_CANCEL_tag;
  TCMPP_CANCEL_tag = packed record
    Msg_Id: Int64; //��Ϣ��ʶ
  end;
  PCMPP_CANCEL_RESP_tag = ^TCMPP_CANCEL_RESP_tag;
  TCMPP_CANCEL_RESP_tag = packed record
    Success_Id: byte; //���
  end;

  ////////////////////////////////////////////////////////////////////////////
  //��·������
  TCMPP_ACTIVE_TEST = TEmpty;

  TCMPP_ACTIVE_TEST_RESP = packed record
    Success_Id: byte; //���
  end;

  //����
  TCMPP20_BODY = packed record
    case integer of
      1: (CMPP_CONNECT: TCMPP_CONNECT);
      2: (CMPP_CONNECT_RESP: TCMPP_CONNECT_RESP);
      3: (CMPP_SUBMIT: TCMPP_SUBMIT);
      4: (CMPP_SUBMIT_RESP: TCMPP_SUBMIT_RESP);
      5: (CMPP_DELIVER: TCMPP_DELIVER);
      6: (CMPP_DELIVER_RESP: TCMPP_DELIVER_RESP);
      7: (CMPP_ACTIVE_TEST: TCMPP_ACTIVE_TEST);
      8: (CMPP_ACTIVE_TEST_RESP: TCMPP_ACTIVE_TEST_RESP);
  end;

  //��
  TCMPP20_PACKET = packed record
    MsgHead: TCMPP_HEAD;
    MsgBody: TCMPP20_BODY;
  end;
  ////////////////////////////////////////////////////////////////////////////
  // ���Ͷ��Ŷ���
  tSendQueue = TCMPP_SUBMIT;
  // ���ն��Ŷ���
  tDeliverQueue = packed record
    Head: TCMPP_DELIVER_HEAD;
    Body: TCMPP_DELIVER
  end;
  // ����״̬�ر�����
  tReportQueue = packed record
    Head: TCMPP_DELIVER_HEAD;
    Body: TCMPP_Report_tag;
  end;

  {**************************************************************************}
  {���ڷ���ʱ��ͷ�Ͱ�����Ҫһ�鷢�ͣ�����Ϊ��ϳ�һ���Э��ṹ}
  ////////////////////////////////////////////////////////////////////////////
  // CMPP_CONNECT ��ϰ� SP to ISMG
  tCmpp_Connect_StoI = packed record
    Head: TCMPP_HEAD;
    Body: TCMPP_CONNECT;
  end;
  // CMPP_SUBMIT ��ϰ� SP to ISMG
  tCmpp_Submit_StoI = packed record
    Head: TCMPP_HEAD;
    Body: TCMPP_SUBMIT;
  end;
  // CMPP_ACTIVE_TEST ��ϰ� SP to ISMG
  tCmpp_ActiveTest_StoI = packed record
    Head: TCMPP_HEAD;
    Body: TCMPP_ACTIVE_TEST;
  end;

  // CMPP_DELIVER_RESP ��ϰ� ISMG to SP
  tCmpp_Deliver_Resp_ItoS = packed record
    Head: TCMPP_HEAD;
    Body: TCMPP_DELIVER_RESP;
  end;
  // CMPP_ACTIVE_TEST_RESP ��ϰ� ISMG to SP
  tCmpp_ActiveTest_Resp_ItoS = packed record
    Head: TCMPP_HEAD;
    Body: TCMPP_ACTIVE_TEST_RESP;
  end;
  // CMPP_CONNECT_RESP ��ϰ� ISMG to SP
  tCmpp_Connect_Resp_ItoS = packed record
    Head: TCMPP_HEAD;
    Body: TCMPP_CONNECT_RESP;
  end;
implementation

function ResultCommandString(var i: LongWord): string;
begin
  case i of
    $1: result := 'CMPP_CONNECT';
    $80000001: result := 'CMPP_CONNECT_RESP';
    $2: result := 'CMPP_TERMINATE';
    $80000002: result := 'CMPP_TERMINATE_RESP';
    $4: result := 'CMPP_SUBMIT';
    $80000004: result := 'CMPP_SUBMIT_RESP';
    $5: result := 'CMPP_DELIVER';
    $80000005: result := 'CMPP_DELIVER_RESP';
    $6: result := 'CMPP_QUERY';
    $80000006: result := 'CMPP_QUERY_RESP';
    $7: result := 'CMPP_CANCEL';
    $80000007: result := 'CMPP_CANCEL_RESP';
    $8: result := 'CMPP_ACTIVE_TEST';
    $80000008: result := 'CMPP_ACTIVE_TEST_RESP';
    $9: result := 'CMPP_FWD';
    $80000009: result := 'CMPP_FWD_RESP ';
    $10: result := 'CMPP_MT_ROUTE';
    $80000010: result := 'CMPP_MT_ROUTE_RESP';
    $11: result := 'CMPP_MO_ROUTE';
    $80000011: result := 'CMPP_MO_ROUTE_RESP';
    $12: result := 'CMPP_GET_ROUTE';
    $80000012: result := 'CMPP_GET_ROUTE_RESP';
    $13: result := 'CMPP_MT_ROUTE_UPDATE';
    $80000013: result := 'CMPP_MT_ROUTE_UPDATE_RESP';
    $14: result := 'CMPP_MO_ROUTE_UPDATE';
    $80000014: result := 'CMPP_MO_ROUTE_UPDATE_RESP';
    $15: result := 'CMPP_PUSH_MT_ROUTE_UPDATE';
    $80000015: result := 'CMPP_PUSH_MT_ROUTE_UPDATE_RESP';
    $16: result := 'CMPP_PUSH_MO_ROUTE_UPDATE';
    $80000016: result := 'CMPP_PUSH_MO_ROUTE_UPDATE_RESP';
  end;
end;

end.

