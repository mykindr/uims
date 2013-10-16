unit SPPO10;

interface
const
  SPPO_VERSION = $40;

  //�������ֶ���
  SPPO_LOGIN = $00000001;
  SPPO_LOGIN_RESP = $80000001;
  SPPO_MO = $00000002;
  SPPO_MO_RESP = $80000002;
  SPPO_MT = $00000003;
  SPPO_MT_RESP = $80000003;
  SPPO_ACTIVETEST = $00000004;
  SPPO_ACTIVETEST_RESP = $80000004;
  SPPO_REPORT = $00000005;
  SPPO_REPORT_RESP = $80000005;

  //��Ϣ�����
  SPPO_MSGTYPE_UNMO = 1; //��MO�����MT
  SPPO_MSGTYPE_MOFIRST = 2; //MO����ĵ�һ��MT
  SPPO_MSGTYPE_MOUNFIRST = 3; //MO����ķǵ�һ��MT
  SPPO_MSGTYPE_REQUESTORDER = 4; //����ȷ��
  SPPO_MSGTYPE_CANCELORDER = 5; //ȡ������
  SPPO_MSGTYPE_BAOYUEFEE = 6; //���¼ƷѰ�
  SPPO_MSGTYPE_QXBAOYUEFEE = 7; //ȡ�����¼ƷѰ�
  SPPO_MSGTYPE_QF = 9; //Ⱥ��

type
  TPHONENUM = array[0..31] of char; //�绰����
  TINMSGID = array[0..9] of char; //�ڲ���Ϣ��ˮ��

  //Э���ͷ
  TSPPO_HEAD = packed record
    length: Cardinal; //����
    CmdId: Cardinal; //��������
    Seqid: Cardinal; //�����
  end;

  //���ص�¼
  TSPPO_LOGIN = packed record
    GateId: Cardinal; //���غ�
    PassWord: array[0..9] of char; //����
    GateDesc: array[0..31] of char; //����˵��
  end;

  //���ص�¼Ӧ��
  TSPPO_LOGIN_RESP = packed record
    result: byte; //��¼���0�ɹ�
  end;

  //������Ϣ
  TSPPO_MO = packed record
    MoOutMsgId: array[0..11] of char;
    MoInMsgId: TINMSGID;
    MoLinkId: array[0..19] of char;
    MoSpAddr: TPHONENUM;
    MoUserAddr: TPHONENUM;
    MoServiceId: array[0..9] of char;
    MoTpPid: byte;
    MoTpUdhi: byte;
    MoMsgFmt: byte;
    MoMsgLenth: Cardinal;
    MoMsgContent: array[0..511] of char;
    MoReserve: array[0..7] of char;
  end;

  //������ϢӦ��
  TSPPO_MO_RESP = packed record
    result: byte;
  end;

  //������Ϣ
  TSPPO_MT = packed record //��Ϣ���
    MtLogicId: Cardinal; //ҵ���ʶ
    MtMsgType: byte; //��Ϣ����
    MoOutMsgId: array[0..11] of char; //Mo���ⲿ��Ϣ��ˮ��
    MoInMsgId: TINMSGID; //Mo���ڲ���Ϣ��ˮ��
    MtInMsgId: TINMSGID; //mt���ڲ���Ϣ��ˮ��
    MoLinkId: array[0..19] of char; //
    OutServiceID: array[0..9] of char; //smgp20�ƷѴ���
    OutFeeType: array[0..1] of char; //smgp20�������
    OutFixedFee: array[0..5] of char; //smgp20�̶�����
    OutFeeCode: array[0..5] of char; //smgp20����
    Msg_src: array[0..5] of char; //��Ϣ������Դ(SP_Id)
    MtSpAddr: TPHONENUM; //sp 1200 2333
    MtUserAddr: TPHONENUM; //Ŀ���û��ֻ���
    MtFeeAddr: TPHONENUM; //�Ʒ��û�����(�ֻ���)
    MtServiceId: array[0..9] of char; //ҵ�����
    MtTpPid: byte;
    MtTpUdhi: byte;
    MtMsgFmt: byte; //��Ϣ����
    MtValidTime: array[0..16] of char;
    MtAtTime: array[0..16] of char;
    MtMsgLenth: Cardinal; //��Ϣ����
    MtMsgContent: array[0..511] of char; //��Ϣ
    MtReserve: array[0..7] of char; //����λ��
  end;

  //������ϢӦ��
  TSPPO_MT_RESP = packed record
    result: byte;
  end;

  //״̬�����
  TSPPO_REPORT = packed record
    MtLogicId: Cardinal;
    MtInMsgId: TINMSGID;
    MtSpAddr: TPHONENUM;
    MtUserAddr: TPHONENUM;
    stat: array[0..6] of char;
    Err: array[0..2] of char;
  end;

  TSPPO_REPORT_RESP = packed record
    result: byte;
  end;

  //����԰����ް���
  //�����Ӧ������ް���

  TSPPO_BODY = packed record
    case integer of
      1: (LOGIN: TSPPO_LOGIN);
      2: (LOGIN_RESP: TSPPO_LOGIN_RESP);
      3: (mo: TSPPO_MO);
      4: (Mo_Resp: TSPPO_MO_RESP);
      5: (Mt: TSPPO_MT);
      6: (Mt_Resp: TSPPO_MT_RESP);
      7: (Report: TSPPO_REPORT);
      8: (Report_Resp: TSPPO_REPORT_RESP);
  end;

  TSPPO_PACKET = packed record
    Head: TSPPO_HEAD;
    Body: TSPPO_BODY;
  end;

const
  SPPO_HEADLEN = sizeof(TSPPO_HEAD);
  SPPO_LOGINLEN = SPPO_HEADLEN + sizeof(TSPPO_LOGIN);
  SPPO_LOGINRESPLEN = SPPO_HEADLEN + sizeof(TSPPO_LOGIN_RESP);
  SPPO_MORESPLEN = SPPO_HEADLEN + sizeof(TSPPO_MO_RESP);
  SPPO_MTRESPLEN = SPPO_HEADLEN + sizeof(TSPPO_MT_RESP);
  SPPO_ACTIVELEN = SPPO_HEADLEN;
  SPPO_ACTIVERESPLEN = SPPO_HEADLEN;

implementation

end.

