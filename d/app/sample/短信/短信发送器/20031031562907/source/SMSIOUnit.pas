unit SMSIOUnit;

interface
  uses Classes;

function NetSendSMS(FLoginUser,FLoginPW,FSend,FRec,FContent:String):integer;STDCALL;
{
  ���أ�
     0�����ͳɹ�
     1: �޷����ӷ�����
     2: �ֻ�����
     3: ����ʧ��
     4: ����
}
function NetRegister(FSJNum:String):integer;STDCALL;
{
  ���أ�
     0��ע��ɹ�
     1: �޷����ӷ�����
     2: �ֻ��������
     3: ע��ʧ��
}


implementation

  function    NetSendSMS;         external 'SMSSend.DLL' name 'NetSendSMS';
  function    NetRegister;        external 'SMSSend.DLL' name 'NetRegister';
  
end.
