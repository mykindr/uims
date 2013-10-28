unit untConsts;

interface

const
  STR_APPNAME = 'OrderHelper 1.0';
  STR_APPTITLE = 'Order System Manager';
  STR_TUNNELVERSION = '1.00';
  STR_WHERE = 'order_status=1 and shipping_status=3'; //��ѯ��ȷ�ϣ�����еĶ���
  STR_SEARCH_FMT = 'order_status=1 and (consignee LIKE %s OR tel LIKE %s OR mobile LIKE %s OR invoice_no LIKE %s OR order_sn LIKE %s)';
resourcestring
  RSTR_CHECK_VERSION = '����汾���ͣ���������������У�';
  RSTR_LOGIN_USRPWINPUT = '�û���/����������������롣';
  RSTR_INPUT_SEARCHKEYWORD = '���ҹؼ��ֲ�����Ϊ�գ����������ҡ�';
  RSTR_EMPTY_INVOICE_NO = '��ݵ��Ų�����Ϊ�գ���������ύ��';
  RSTR_EMPTY_PAYMENT = '���ͷ�ʽδѡ����ѡ����ύ��';
  RSTR_EMPTY_PRINT = '��ѡ��Ҫ�����ļ�¼��';
  RSTR_POST_ORDERINFOFAILMSG = '�����޸��ύʧ�ܣ�����ѯ�����Ա��';
  RSTR_NOTFOUND_INVOICE_NO = '��ݵ��Ų����ڣ���༭����';
  RSTR_NOTFOUND_SHIPPING = '�����ͷ�ʽ�����ڣ���༭����';
  RSTR_NOTFOUND_MODFILE = '���ͷ�ʽ�Ĵ�ӡģ���ļ������ڡ�';
  RSTR_MAIN_MSG = ' ����������վ��̨�����������п�ݵ��Ŀ��ٴ�ӡ��';
  RSTR_MAIN_TITLE = '��ݵ���ӡ��ʽ��';
  RSTR_MAIN_MSG2 = '�����Ѹ��Ƶ���������';
var
  PServerName:string;
  PAdminName:string;
  PServiceURL:string;
  PSearchKeyWord:string;
  PWhere:string;
  PReportFile:string; //������ӡ�����һ����ѡ���ģ��
  PPrintName:string;
  PIsPrint:Boolean;
  
implementation

end.
 