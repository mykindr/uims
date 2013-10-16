unit ADSLStringRes;

interface
uses
  Windows;
  
const
  RAS_MaxDeviceType = 16; //�豸�������Ƴ���
  RAS_MaxEntryName = 256; //����������󳤶�
  RAS_MaxDeviceName = 128; //�豸������󳤶�
  RAS_MaxIpAddress = 15; //IP��ַ����󳤶�
  RASP_PppIp = $8021; //�������ӵ�Э�����ͣ�����ֵ��ʾPPP����

type
  HRASCONN = DWORD; //�������Ӿ��������
  RASCONN = record //��Ĳ������ӵľ����������Ϣ
    dwSize: DWORD;
    //�ýṹ��ռ�ڴ�Ĵ�С(Bytes),һ������ΪSizeOf(RASCONN)
    hrasconn: HRASCONN; //����ӵľ��
    szEntryName: array[0..RAS_MaxEntryName] of char;
 //����ӵ�����
    szDeviceType: array[0..RAS_MaxDeviceType] of char;
//����ӵ����õ��豸����
    szDeviceName: array[0..RAS_MaxDeviceName] of char;
//����ӵ����õ��豸����
  end;

  TRASPPPIP = record //��Ĳ������ӵĶ�̬IP��ַ��Ϣ
    dwSize: DWORD;
    //�ýṹ��ռ�ڴ�Ĵ�С(Bytes),һ������ΪSizeOf(TRASPPPIP)
    dwError: DWORD; //�������ͱ�ʶ��
    szIpAddress: array[0..RAS_MaxIpAddress] of char;
//��Ĳ������ӵ�IP��ַ
  end;

//��ȡ���л�Ĳ������ӵ���Ϣ�����Ӿ����������Ϣ��
function RasEnumConnections(var lprasconn: RASCONN;
//���ջ���ӵĻ�������ָ��
  var lpcb: DWORD; //��������С
  var lpcConnections: DWORD //ʵ�ʵĻ������
  ): DWORD; stdcall;

function RasEnumConnections; external 'Rasapi32.dll' name 'RasEnumConnectionsA';
//��ȡָ����Ĳ������ӵĶ�̬IP��Ϣ
function RasGetProjectionInfo(
  hrasconn: HRasConn; //ָ������ӵľ��
  rasprojection: DWORD; //RAS��������
  var lpprojection: TRASPPPIP; //���ն�̬IP��Ϣ�Ļ�����
  var lpcb: DWord //���ջ������Ĵ�С
  ): DWORD; stdcall;
function RasGetProjectionInfo; external
'Rasapi32.dll' name 'RasGetProjectionInfoA';

const
  Str1 = '������ʱ:';
  Str2 = '������ʱ:';
  Str3 = '���ο�ʼʱ��:';

  TabStr = '    ';

var
  Path: string; //�������ڵ�Ŀ¼λ��

implementation

end.

