{/**********************************************************************
* Դ��������: futu_data_types.h
* �������Ȩ: �������ӹɷ����޹�˾
* ϵͳ����  : 06�汾�ڻ�ϵͳ
* ģ������  : �����ڻ��ܱ߽ӿ�
* ����˵��  : �ܱ߽ӿڳ����������Ͷ���
* ��    ��  : xdx
* ��������  : 20110315
* ��    ע  : �������Ͷ���
* �޸���Ա  ��
* �޸�����  ��
* �޸�˵��  ��20110315 ����
20110701 luyj �޸ĵ���20110603001 �汾���ӵ�V1.0.0.1
20110802 luyj �޸ĵ���20110802006 �汾���ӵ�V1.0.0.2
20110809 luyj �޸ĵ���20110808022 �汾���ӵ�V1.0.0.3
20110824 luyj �޸ĵ���20110819035 �汾���ӵ�V1.0.0.4
20110913 luyj �޸ĵ���20110913002 �汾���ӵ�V1.0.0.5
20111026 luyj �޸ĵ���20111026001 �汾���ӵ�V1.0.0.6
20111027 luyj �޸ĵ���20111103023 �汾���ӵ�V1.0.0.7
20111027 luyj �޸ĵ���20111124003 �汾���ӵ�V1.0.0.8
20120207 luyj �޸ĵ���20120207003 �汾���ӵ�V1.0.0.9
20120216 tangui �޸ĵ���20120214036 �汾���ӵ�V1.0.0.10
20120216 tangui �޸ĵ���20120214036 �汾���ӵ�V1.0.0.11
20120504 tangui �޸ĵ���20120412046 �汾���ӵ�V1.0.0.12
20120512 tangui �޸ĵ���20120509021 �汾���ӵ�V1.0.0.13
20120720 tanghui  �޸ĵ���20120515030 �汾���ӵ�V1.0.0.14
**********************************************************************/}
unit uFutuDataTypes;

interface

const
  //����汾��Ϣ
  HSFUSDK_VERSION = $10000014;
  HSFUSDK_VERSTRING = 'V1.0.0.14';

  //�������ӷ�������
  SERVICE_TYPE_TRADE = 1; //���׷���
  SERVICE_TYPE_QUOTE = 2; //����ر�����

  //������Ϣ����
  MSG_TYPE_UNKNOWN = -1; //δ֪��Ϣ����

  MSG_TYPE_USER_LOGIN = 100; //�û���¼
  MSG_TYPE_USER_LOGOUT = 101; //UFT�ͻ�ע��
  MSG_TYPE_CONFIRM_BILL = 102; //�ͻ�ȷ���˵�
  MSG_TYPE_CHECK_CONTRACT_CODE = 103; //����Լ����(����)
  MSG_TYPE_CHECK_ENTRUST_PRICE = 104; //���ί�м۸�
  MSG_TYPE_NEW_SINGLE_ORDER = 105; //ί���µ�
  MSG_TYPE_CANCEL_ORDER = 106; //ί�г���
  MSG_TYPE_BANK_TRANSFER = 107; //����ת��
  MSG_TYPE_MODIFY_PASSWORD = 108; //�ͻ��޸�����

  //20110822 luyj �������ί�� �޸ĵ���:20110819035
  MSG_TYPE_CHECK_COMBIN_CODE = 109; //�����Ϻ�Լ����
  MSG_TYPE_NEW_COMBIN_ORDER = 110; //���ί��ȷ��
  //20110822 end

  MSG_TYPE_GET_TRADING_CODE = 200; //���ױ����ѯ
  MSG_TYPE_GET_PROFIT = 201; //�ڻ��ͻ��ʽ�Ȩ���ѯ
  MSG_TYPE_GET_HOLDSINFO = 202; //�ֲֲ�ѯ
  MSG_TYPE_GET_ENTRUST_ORDERS = 203; //ί�в�ѯ
  MSG_TYPE_GET_TRANS_DETAIL = 204; //�ɽ���ϸ��ѯ
  MSG_TYPE_GET_FUNDJOUR = 205; //��ʷ�ʽ���ˮ��ѯ
  MSG_TYPE_GET_FUND_HISTRANSJOUR = 206; //����ʷת����ˮ
  MSG_TYPE_GET_BANK_ACCOUNT = 207; //�����˺Ų�ѯ
  MSG_TYPE_GET_BANK_TRANSJOUR = 208; //����ת����ˮ��ѯ
  MSG_TYPE_GET_BANKBALA = 209; //�����˻�����ѯ
  MSG_TYPE_GET_MARKET_DATA = 210; //�ڻ������ѯ
  MSG_TYPE_GET_MARGIN = 211; //��Լ��֤���ѯ
  MSG_TYPE_GET_FUTU_BANKINFO = 212; //�ڻ��Ǽ�������Ϣ��ѯ
  MSG_TYPE_GET_EXCH_TIME = 213; //������ʱ����ѯ
  MSG_TYPE_GET_FMMC_PWD = 214; //������Ľ��㵥ϵͳ�����ѯ
  MSG_TYPE_GET_BILL = 215; //���㵥��ѯ
  MSG_TYPE_GET_HIS_ENTRUST = 216; //��ʷί�в�ѯ
  MSG_TYPE_GET_HIS_BUSINESS = 217; //��ʷ�ɽ���ѯ
  MSG_TYPE_GET_HIS_FUND = 218; //��ʷ�ʽ��ѯ
  MSG_TYPE_UFT_ORDERHSACK = 219; //ί�з���
  MSG_TYPE_UFT_ORDEREXACK = 220; //�ɽ�����

  //20110822 luyj �������ί����ز�ѯ(06) �޸ĵ���:20110819035
  MSG_TYPE_GET_COMBIN_CODE = 221; //��ѯ��ϴ���
  MSG_TYPE_GET_COMBIN_QUOTE = 222; //��ѯ�������
  MSG_TYPE_CHECK_PWD = 223; //У������
  //20110822 end

  //20120426 tanghui ���ӵ��ͻ���������Ժͱ�֤������ �޸ĵ�:20120412046
  MSG_TYPE_GET_FEE_PROPERTY = 224; //UFT�ͻ���ѯ��������
  MSG_TYPE_GET_MARGIN_PROPERTY = 225; //UFT�ͻ���ѯ��֤������

type
  //����Integerָ��
  PInteger = ^Integer;
  //��������
  REGType =
    (
    UnKnownType = -1, // δ֪����
    SingleCode = 0, // ��������
    RspReport = 1, // ί�лر�
    CombinCode = 2, // �������
    OnlineMsg = 3 // ������Ϣ
    );

  //���Ķ���
  REGAction =
    (
    UnKnownAction = -1, // δ֪����
    Subscription = 0, // ����ˢ��(��Ҫָ����)����ָʾ�����˶�
    CxlAll = 1, // ȡ��ȫ���Ķ���
    CxlFlag = 2, // �����ƶ����Ͷ���
    Snapshot = 3 // ��ѯ����(��Ҫָ����)
    );

  //���ӵ�״̬
  CONState =
    (
    Uninitialized = -1, // ����δ��ʼ��
    Disconnected = $0000, // δ����
    Connecting = $0001, // socket��������
    Connected = $0002, // socket������
    SafeConnecting = $0004, // ���ڽ�����ȫ����
    SafeConnected = $0008, // �ѽ�����ȫ����
    Registering = $0010, // ��ע��
    Registered = $0020, // ��ע��
    Rejected = $0040 // ���ܾ�,�����ر�
    );

  //������Ϣģʽ(FUTU_MSG_MODE����)
  FUTU_MSG_MODE =
    (
    MSG_MODE_UNKNOWN = -1, //δ֪��Ϣģʽ
    MSG_MODE_REQUEST = 0, //��ʾ��������Ϣ
    MSG_MODE_ANSWER = 1 //��ʾ��Ӧ����Ϣ
    );

  //Ϊ������ͳһ��4�ֽڶ���,���������ݶ��������
{$A4}
  // ��������
  LPCMarketInfo = ^CMarketInfo;
  CMarketInfo = record
    contract_code: array[0..12] of Char; //0 ��Լ����,
    pre_square_price: Double; //1 ���ս�������
    futu_open_price: Double; //2 ���̼�
    futu_last_price: Double; //3 ���¼۸�
    buy_high_price: Double; //4 ��������
    buy_high_amount: Integer; //5 ������������
    buy_total_amount: Integer; //6 ȫ������
    sale_low_price: Double; //7 ������ۼ۸�
    sale_low_amount: Integer; //8 �����������
    sale_total_amount: Integer; //9 ȫ������
    futu_high_price: Double; //10 ��߼�
    futu_low_price: Double; //11 ��ͼ�
    average_price: Double; //12 ����
    change_direction: Double; //13 ����
    business_amount: Integer; //14 �ɽ���
    bear_amount: Integer; //15 �ܳ���
    business_balance: Double; //16 �ɽ���
    uplimited_price: Double; //17 ��ͣ��
    downlimited_price: Double; //18 ��ͣ��
    futu_exch_type: array[0..2] of Char; //19 �������
    form_buy_price: Double; //20 �������۸�
    form_sale_price: Double; //21 ��������۸�
    form_buy_amount: Integer; //22 �����������
    form_sale_amount: Integer; //23 �����������
    pre_close_price: Double; //24 �������̼�
    pre_open_interest: Double; //25 ���տ�����
    futu_close_price: Double; //26 �������̼�
    square_price: Double; //27 �����
    pre_delta: Double; //28 ������ʵ��
    curr_delta: Double; //29 ������ʵ��
    bid_price2: Double; //30 �����
    bid_volume2: Integer; //31 �����
    bid_price3: Double; //32 ������
    bid_volume3: Integer; //33 ������
    bid_price4: Double; //34 ���ļ�
    bid_volume4: Integer; //35 ������
    bid_price5: Double; //36 �����
    bid_volume5: Integer; //37 ������
    ask_price2: Double; //38 ������
    ask_volume2: Integer; //39 ������
    ask_price3: Double; //40 ������
    ask_volume3: Integer; //41 ������
    ask_price4: Double; //42 ���ļ�
    ask_volume4: Integer; //43 ������
    ask_price5: Double; //44 �����
    ask_volume5: Integer; //45 ������
  end;

  // �������
  LPCArgMarketInfo = ^CArgMarketInfo;
  CArgMarketInfo = record
    arbicontract_id: array[0..30] of Char; //0 ������Լ��
    futu_exch_type: array[0..2] of Char; //1 �������
    first_code: array[0..12] of Char; //2 ��һ��
    second_code: array[0..12] of Char; //3 �ڶ���
    arbi_type: Char; //4 �������1-SPD, 2 -IPS
    buy_price: Double; //5 ��������
    buy_amount: Integer; //6 ������������
    buy_total_amount: Integer; //7 ȫ������
    sale_price: Double; //8 ������ۼ۸�
    sale_amount: Integer; //9 �����������
    sale_total_amount: Integer; //10 ȫ������
    futu_high_price: Double; //11 ��߼�
    futu_low_price: Double; //12 ��ͼ�
    uplimited_price: Double; //13 ��ͣ��۸�
    downlimited_price: Double; //14 ��ͣ��۸�
  end;

  //ί�з�����Ϣ
  LPCOrderRspInfo = ^COrderRspInfo;
  COrderRspInfo = record
    entrust_no: Integer; //0 ί�к�
    futures_account: array[0..20] of Char; //1 ���ױ���
    futu_exch_type: array[0..10] of Char; //2 ���������
    contract_code: array[0..12] of Char; //3 ��Լ����
    entrust_bs: array[0..8] of Char; //4 ������ʶ
    entrust_direction: array[0..8] of Char; //6 ��ƽ��ʶ
    hedge_type: array[0..8] of Char; //7 �ױ���ʶ
    fund_account: Integer; //8 �ʽ��˻�
    futu_report_no: array[0..20] of Char; //9 ���ص���
    firm_no: array[0..8] of Char; //10 ��Ա��
    operator_no: array[0..8] of Char; //11 ����Ա��
    client_group: Integer; //12 �ͻ����
    entrust_amount: Integer; //13 ί������
    business_total_amount: Integer; //14 �ɽ�������
    cacel_amount: Integer; //15 ��������
    entrust_price: Double; //16 ί�м۸�
    entrust_status: Char; //17 ί��״̬
    branch_no: Integer; //18 Ӫҵ����
    batch_no: Integer; //19 ί������
    futu_entrust_type: Char; //20 ί������
    amount_per_hand: Integer; //21 ��Լ����
    forceclose_reason: Char; //22 ǿƽԭ��
    init_date: Integer; //23 ��������
    curr_time: Integer; //24 ��ǰʱ��
    confirm_no: array[0..20] of Char; //25 ��������
    weave_type: Integer; //26 ���ί������
    arbitrage_code: array[0..20] of Char; //27 ���ί������
    time_condition: Integer; //28 ��Ч������
    volume_condition: Integer; //29 �ɽ�������
    futu_entrust_prop: Integer; //30 �ڻ�ί������
    frozen_fare: Double; //31 �����ܷ���
    //20120428 tanghui ί�з����ͳɽ��������Ӵ�����Ϣ�ֶ� �޸ĵ�:20120412049
    error_message: array[0..254] of Char; //32 ������Ϣ
  end;

  //�ɽ�������Ϣ
  LPCRealRspInfo = ^CRealRspInfo;
  CRealRspInfo = record
    entrust_no: Integer; //0 ί�к�
    futures_account: array[0..20] of Char; //1 ���ױ���
    futu_exch_type: array[0..10] of Char; //2 ���������
    business_no: array[0..20] of Char; //3 �ɽ����
    contract_code: array[0..12] of Char; //4 ��Լ����
    entrust_bs: array[0..8] of Char; //5 ������ʶ
    entrust_direction: array[0..8] of Char; //6 ��ƽ��ʶ
    business_price: Double; //7 �ɽ��۸�
    business_amount: Double; //8 �ɽ�����
    hedge_type: array[0..8] of Char; //9 �ױ���ʶ
    fund_account: Integer; //10 �ʽ��˻�
    futu_report_no: array[0..20] of Char; //11 ���ص���
    firm_no: array[0..8] of Char; //12 ��Ա��
    operator_no: array[0..8] of Char; //13 ����Ա��
    client_group: Integer; //14 �ͻ����
    entrust_amount: Integer; //15 ί������
    business_total_amount: Integer; //16 �ɽ�������
    cacel_amount: Integer; //17 ��������
    entrust_price: Double; //18 ί�м۸�
    entrust_status: Char; //19 ί��״̬
    branch_no: Integer; //20 Ӫҵ����
    batch_no: Integer; //21 ί������
    futu_entrust_type: Char; //22 ί������
    amount_per_hand: Integer; //23 ��Լ����
    forceclose_reason: Char; //24 ǿƽԭ��
    init_date: Integer; //25 ��������
    business_time: Integer; //26 �ɽ�ʱ��
    confirm_no: array[0..20] of Char; //27 ��������
    frozen_fare: Double; //28 �����ܷ���
    //20120428 tanghui ί�з����ͳɽ��������Ӵ�����Ϣ�ֶ� �޸ĵ�:20120412049
    error_message: array[0..254] of Char; //29 ������Ϣ
  end;
{$A8}
implementation

end.
