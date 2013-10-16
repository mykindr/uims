unit Dama2;

interface

uses
  Windows, Variants, Classes;

//************************************
//			error code
//************************************
	//success code
Const ERR_CC_SUCCESS					: Integer = (0);
	//parameter eror
Const ERR_CC_SOFTWARE_NAME_ERR			: Integer = (-1);
Const ERR_CC_SOFTWARE_ID_ERR			: Integer = (-2);
Const ERR_CC_FILE_URL_ERR				: Integer = (-3);
Const ERR_CC_COOKIE_ERR					: Integer = (-4);
Const ERR_CC_REFERER_ERR				: Integer = (-5);
Const ERR_CC_VCODE_LEN_ERR				: Integer = (-6);
Const ERR_CC_VCODE_TYPE_ID_ERR			: Integer = (-7);
Const ERR_CC_POINTER_ERROR				: Integer = (-8);
Const ERR_CC_TIMEOUT_ERR				: Integer = (-9);
Const ERR_CC_INVALID_SOFTWARE			: Integer = (-10);
Const ERR_CC_COOKIE_BUFFER_TOO_SMALL	: Integer = (-11);
Const ERR_CC_PARAMETER_ERROR			: Integer = (-12);
	//user error
Const ERR_CC_USER_ALREADY_EXIST			: Integer = (-100);
Const ERR_CC_BALANCE_NOT_ENOUGH			: Integer = (-101);
Const ERR_CC_USER_NAME_ERR				: Integer = (-102);
Const ERR_CC_USER_PASSWORD_ERR			: Integer = (-103);
Const ERR_CC_QQ_NO_ERR					: Integer = (-104);
Const ERR_CC_EMAIL_ERR					: Integer = (-105);
Const ERR_CC_TELNO_ERR					: Integer = (-106);
Const ERR_CC_DYNC_VCODE_SEND_MODE_ERR	: Integer = (-107);
Const ERR_CC_INVALID_CARDNO				: Integer = (-108);
Const ERR_CC_DYNC_VCODE_OVERFLOW		: Integer = (-109);
Const ERR_CC_DYNC_VCODE_TIMEOUT			: Integer = (-110);
Const ERR_CC_USER_SOFTWARE_NOT_MATCH	: Integer = (-111);
Const ERR_CC_NEED_DYNC_VCODE			: Integer = (-112);
	//logic error
Const ERR_CC_NOT_LOGIN					: Integer = (-201);
Const ERR_CC_ALREADY_LOGIN				: Integer = (-202);
Const ERR_CC_INVALID_REQUEST_ID			: Integer = (-203);		//invalid request id, perhaps request is timeout
Const ERR_CC_INVALID_VCODE_ID			: Integer = (-204);		//invalid captcha id
Const ERR_CC_NO_RESULT					: Integer = (-205);
Const ERR_CC_NOT_INIT_PARAM				: Integer = (-206);
Const ERR_CC_ALREADY_INIT_PARAM			: Integer = (-207);
Const ERR_CC_SOFTWARE_DISABLED			: Integer = (-208);
Const ERR_CC_NEED_RELOGIN				: Integer = (-209);
Const EER_CC_ILLEGAL_USER				: Integer = (-210);
Const EER_CC_REQUEST_TOO_MUCH			: Integer = (-211);		//concurrent request is too much

	//system error
Const ERR_CC_CONFIG_ERROR				: Integer = (-301);
Const ERR_CC_NETWORK_ERROR				: Integer = (-302);
Const ERR_CC_DOWNLOAD_FILE_ERR			: Integer = (-303);
Const ERR_CC_CONNECT_SERVER_FAIL		: Integer = (-304);
Const ERR_CC_MEMORY_OVERFLOW			: Integer = (-305);
Const ERR_CC_SYSTEM_ERR					: Integer = (-306);
Const ERR_CC_SERVER_ERR					: Integer = (-307);
Const ERR_CC_VERSION_ERROR				: Integer = (-308);


/////////////////////////////////////////////////////////////////
//          Dama2��������
/////////////////////////////////////////////////////////////////
//�õ�ԭʼ�����루��������������ʧ��ʱ�����øú����õ�ϵͳԭʼ�����룩
function GetOrigError() : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'GetOrigError';


//�����ʼ��
//��������������pszSoftwareName�����31���ַ���
//  ������������pszSoftwareID��32��16hex�ַ���ɣ�
//�����룺0 �ɹ�, ����ʧ�ܣ���������붨��
function Init(softwareName : LPCSTR; softwareID : LPCSTR) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'Init';


//�������ʼ�����ͷ�ϵͳ��Դ
//����������������
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
procedure Uninit();
stdcall; external 'CrackCaptchaAPI.dll' name 'Uninit';


//�û���¼
//��������������  [in]pszUserName���û��������31�ֽڣ�
//����������������[in]pszUserPassword�����룬���16�ֽڣ�
//����������������[in]pDyncVerificationCode����̬��֤�룬û�ж�̬��֤���ֱ�Ӵ�NULL��
//����������������[out]pszSysAnnouncementURL�����ش�����ƽ̨����URL������Ļ���������512�ֽڣ������߿����о����Ƿ��ڽ�������ʾ��
//����������������[out]pszAppAnnouncementURL�����ش����ÿ����ߺ�̨���Ѷ���Ĺ���URL������Ļ���������512�ֽڣ�
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function Login(userName : LPCSTR; userPassword : LPCSTR; dyncVCode : LPCSTR;
  sysAnnouncementURL: LPSTR; appAnnouncementURL : LPSTR ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'Login';

//�û���¼
//��������������  [in]pszUserName���û��������31�ֽڣ�
//����������������[in]pszUserPassword�����룬���16�ֽڣ�
//����������������[in]pDyncVerificationCode����̬��֤�룬û�ж�̬��֤���ֱ�Ӵ�NULL��
//����������������[out]pszSysAnnouncementURL�����ش�����ƽ̨����URL������Ļ���������512�ֽڣ������߿����о����Ƿ��ڽ�������ʾ��
//����������������[out]pszAppAnnouncementURL�����ش����ÿ����ߺ�̨���Ѷ���Ĺ���URL������Ļ���������512�ֽڣ�
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function Login2(userName : LPCSTR; userPassword : LPCSTR) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'Login2';



//�û��ǳ����û�ע��
//����������������
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function Logoff() : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'Logoff';


//ͨ��������֤��ͼƬURL��ַ������룬�ɴ����ÿؼ����������ϴ�������ʡʱʡ��
//
//��������������[in]pszFileURL - ��֤��ͼƬURL���511
//��������������[in]pszCookie - ��ȡ��֤������Cookie���4095�ֽ�
//��������������[in]pszReferer - ��ȡ��֤������Referer���511�ֽ�
//��������������[in]ucVerificationCodeLen - ��֤�볤�ȣ�������ȷ����֤�볤�ȣ�
//                      �����ȱ�ʶ��������Ȳ������ɴ�0
//��������������[in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//��������������[in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨
//                      ����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//��������������[in]bDownloadPictureByLocalMachine -
//                      �Ƿ񱾻����أ���Ϊ��Щ��֤���IP��������Զ�̻�ȡ��
//                      ����˱�־ΪTRUE��������ÿؼ��������������Զ�����ͼƬ���ϴ���
//��������������������������û�д����Ƶ���֤�룬�����ɴ����û������أ�Ч�ʸ��ߣ�������FALSE
//��������������[out]pulRequestID - ��������ID��Ϊ�����GetResultȡ���������á�
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function Decode(fileURL : LPCSTR; cookie : LPCSTR; referer : LPCSTR;
  ucVerificationCodeLen: Byte; usTimeout : Word;
  ulVCodeTypeID : Longint; bDownloadPictureByLocalMachine : Integer;
  var pulRequestID : Integer ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'Decode';


//���봰�ڶ��崮�������ø��������ָ�����ڽ�ͼ���ϴ��������
//��������������[in]pszWndDef - ���ڶ����ִ��������������
//��������������[in]lpRect - Ҫ��ȡ�Ĵ������ݾ���(����ڴ��������Ͻ�),NULL��ʾ��ȡ������������
//��������������[in]ucVerificationCodeLen - ��֤�볤�ȣ�������ȷ����֤�볤�ȣ�
//                            �����ȱ�ʶ��������Ȳ������ɴ�0
//��������������[in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//��������������[in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨
//                            ����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//��������������[out]pulRequestID - ��������ID��Ϊ�����GetResultȡ���������á�
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
//���ڶ����ִ�,��ʽ����:
//������"\n"�ָ��Ķ���Ӵ����,һ���Ӵ���ʾһ�����ڲ��ҵ�����.��һ��������Ϊ��������
//����ÿ���Ӵ���3��Ԫ�����:����Class��,������,��������.Ԫ��֮���Զ���(���)�ָ�
//����������������:�粻��ͨ����������,��"ANY_CLASS"
//��������������:���ڵ�����,��û�д�����,��"ANY_NAME"
//�����������:��1��ʼ����,1��ʾ��1���������ʹ����������ϵĴ���,
//����������������Ų�Ϊ1,�����β��ҷ�����������ŵĴ���
//�������ڼ����Ϊ50��
//������Ҫ����Ҫ���ҵ�һ������Ϊ"TopClass"���������޵ĵڶ��Ӵ���(����������������),
//�����ִ�����:
//��������TopClass,ANY_NAME,1\nANY_CLASS,ANY_NAME,2
function DecodeWnd(
  pszWndDef : LPCSTR;
  lpRect : PRect;
  ucVerificationCodeLen: Byte; usTimeout : Word;
  ulVCodeTypeID : Longint;
  var pulRequestID : Integer ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'DecodeWnd';


//ͨ��������֤��ͼƬ������������룬��������Ҫ�������ز�����֤��ͼƬ��
//    ���ͼƬ���ݺ���ñ������������
//��������������[in]pImageData - ��֤��ͼƬ����
//��������������[in]dwDataLen - ��֤��ͼƬ���ݳ��ȣ���pImageData��С������4M
//��������������[in]pszExtName - ͼƬ��չ������JPEG��BMP��PNG��GIF
//��������������[in]ucVerificationCodeLen - ��֤�볤�ȣ�������ȷ����֤�볤�ȣ�
//                      �����ȱ�ʶ��������Ȳ������ɴ�0
//��������������[in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//��������������[in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨
//                      ����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//��������������[out]pulRequestID - ��������ID��Ϊ�����GetResultȡ���������á�
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function DecodeBuf(
  pImageData : Pointer;
  dwDataLen : Integer;
  pszExtName : LPCSTR;
  ucVerificationCodeLen: Byte;
  usTimeout : Word;
  ulVCodeTypeID : Longint;
  var pulRequestID : Integer ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'DecodeBuf';


//ȡ��֤��ʶ����
//��������������[in]ulRequestID - ��֤������ID����Decode��DecodeBuf��DecodeWnd�Ⱥ�������
//��������������[in]ulTimeout - GetResult�����ȴ���ʱʱ��(��λΪ����)��
//                      �����0�������������������أ��������ֵΪERR_CC_NO_RESULT��
//                          �����ɿ�����ѭ������ֱ�����سɹ�����������
//�����������������������������Ч��ʱʱ�䣬�����������ȴ����������ȵ�������������أ�û�ȵ����ڳ�ʱʱ��󷵻ء�
//��������������[out]pszVCode - ��֤��ʶ��������ͨ������������ʶ����
//��������������[in]ulVCodeBufLen - ������֤��ʶ������������С����pszVCode��������С
//��������������[out]pulVCodeID - ������֤��ID��������óɹ�ȡ����֤������
//                      �������豣�����֤��ID������ReportResult����������֤�����ĳɹ�ʧ��״̬��
//��������������[out]pszReturnCookie - ����������֤��ͼƬʱ���ص�Cookie������Ҫʱ�ɴ�nil
//��������������[in]ulCookieBufferLen - ���մ���cookie�Ļ�������С����pszReturnCookie�Ĵ�С����ǰһ����ΪnilʱΪ0
//����ֵ��������0 �ɹ�; ERR_CC_NO_RESULT, �����������ڴ����ٴε���GetResult�õ����; ����ʧ�ܣ���������붨��
function GetResult(
  requestID : Integer;
  timeoutWait : Longword;
  textVCode : LPSTR;
  textBufLen : Integer;
  var pulVCodeID: Integer;
  pszReturnCookie : LPSTR;
  ulCookieBufferLen : Integer ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'GetResult';


//������֤������ȷ��
//��������������ulVCodeID - ��֤��ID��ʹ��GetResult�������ص���֤��ID
//��������������bCorrect - 1��ȷ 0 ����
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function ReportResult(idVCode : Integer; bCorrect : Integer) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'ReportResult';


//�û�ע��(�����½)
//��������������pszUserName - �û��������31���ֽ�
//��������������pszUserPassword - ���룬���16�ֽ�
//��������������pszQQ - QQ���룬��Ϊ�գ����16�ֽ�
//��������������pszTelNo - �ֻ����룬���16�ֽڣ������̬�뷢�ͷ�ʽΪ1��3���ֻ��������
//��������������pszEmail - ���䣬���48�ֽڣ������̬�뷢�ͷ�ʽΪ2��3�����������
//��������������nDyncSendMode - ��̬�뷢�ͷ�ʽ��1�ֻ� 2���� 3�ֻ�������
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function Register(pszUserName : LPCSTR; pszUserPassword : LPCSTR;
    pszQQ : LPCSTR; pszTelNo : LPCSTR; pszEmail : LPCSTR;
    nDyncSendMode : Integer) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'Register';


//���ܣ����������û���ֵ(�����½)
//��������������Recharge
//��������������[in]pszUserName - ��ֵ�û��������32�ֽ�
//��������������[in]pszCardNo - ��ֵ���ţ�32�ֽ�
//��������������[out]pulBalance - �����û���ֵ������
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function Recharge(pszUserName : LPCSTR; pszCardNo : LPCSTR;
    var pulBalance : Integer) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'Recharge';


//���ܣ�����������ѯ�û����(���½ʹ��)
//��������������QueryBalance
//��������������[out]pulBalance�������û������֣�
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function QueryBalance(var pulBalance : Integer) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'QueryBalance';

//���ܣ�����������ȡ�û���Ϣ
//��������������ReadInfo
//��������������[out]pszUserName - �û��������뻺������С��32�ֽ�
//��������������[out]pszQQ - QQ���룬���뻺������С��16�ֽ�
//��������������[out]pszTelNo - �ֻ����룬���뻺������С��16�ֽ�
//��������������[out]pszEmail - ���䣬���뻺������С��48�ֽ�
//��������������[out]pDyncSendMode - ��̬�뷢�ͷ�ʽ
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨��
function ReadInfo(pszUserName : LPSTR;
    pszQQ : LPSTR; pszTelNo : LPSTR; pszEmail : LPSTR;
    var pDyncSendMode : Integer) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'ReadInfo';

//���ܣ����������޸ĵ�¼�û���Ϣ
//��������������ChangeInfo
//��������������pUserOldPassword - �����룬���16�ֽ�
//��������������pUserNewPassword - �����룬���16�ֽ�
//��������������pszQQ - QQ���룬��Ϊ�գ����16�ֽ�
//��������������pszTelNo - �ֻ����룬���16�ֽڣ������̬�뷢�ͷ�ʽΪ1��3���ֻ��������
//��������������pszEmail - ���䣬���48�ֽڣ������̬�뷢�ͷ�ʽΪ2��3�����������
//��������������pszDyncVCode - ��̬��֤�룬��һ�ε��ÿɴ�NULL�����ж�̬��֤��������û�����Ķ�̬���ٴε��á�
//��������������nDyncSendMode - ��̬�뷢�ͷ�ʽ��1�ֻ� 2���� 3�ֻ�������
//����ֵ��������0 �ɹ�, ����ʧ�ܣ���������붨�塣
//                  �ر�أ�DAMA2_RET_NEED_DYNC_VCODE,��Ҫ��ʾ�û����붯̬��֤��
function ChangeInfo(pUserOldPassword : LPCSTR; pUserNewPassword : LPCSTR;
    pszQQ : LPCSTR; pszTelNo : LPCSTR; pszEmail : LPCSTR;
    pszDyncVCode : LPCSTR;
    nDyncSendMode : Integer) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'ChangeInfo';



/////////////////////////////////////////////////////////////////////////////
//
//      ����Ϊͬ��������������൱�ڵ���DecodeXXX��GetResult��������
//
/////////////////////////////////////////////////////////////////////////////

//ͨ��������֤��ͼƬURL��ַ������루ͬ�������ɴ����ÿؼ����������ϴ�������ʡʱʡ��
//
//��������������[in]pszFileURL - ��֤��ͼƬURL���511
//��������������[in]pszCookie - ��ȡ��֤������Cookie���4095�ֽ�
//��������������[in]pszReferer - ��ȡ��֤������Referer���511�ֽ�
//��������������[in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//��������������[in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨
//                      ����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//��������������[out]pszVCodeText - �ɹ�ʱ������֤���ı�������������30���ֽڡ�
//��������������[out]pszRetCookie - �ɹ�ʱ����Cookie������������4096���ֽڣ�����Ҫʱ�ɴ�nil��
//����ֵ��������>0 �ɹ���������֤��ID���û�����ReportResult; <0ʧ�ܣ���������붨��
function DecodeSync(fileURL : LPCSTR; cookie : LPCSTR; referer : LPCSTR;
  usTimeout : Word;
  ulVCodeTypeID : Longint;
  lpszVCodeText : LPSTR; lpszRetCookie : LPSTR ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'DecodeSync';


//���봰�ڶ��崮�������ø��������ָ�����ڽ�ͼ���ϴ�������루ͬ����
//��������������[in]pszWndDef - ���ڶ����ִ��������������
//��������������[in]lpRect - Ҫ��ȡ�Ĵ������ݾ���(����ڴ��������Ͻ�),NULL��ʾ��ȡ������������
//��������������[in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//��������������[in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨
//                            ����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//��������������[out]pszVCodeText - �ɹ�ʱ������֤���ı�������������30���ֽڡ�
//����ֵ��������>0 �ɹ���������֤��ID���û�����ReportResult; <0ʧ�ܣ���������붨��
//���ڶ����ִ�,��ʽ����:
//������"\n"�ָ��Ķ���Ӵ����,һ���Ӵ���ʾһ�����ڲ��ҵ�����.��һ��������Ϊ��������
//����ÿ���Ӵ���3��Ԫ�����:����Class��,������,��������.Ԫ��֮���Զ���(���)�ָ�
//����������������:�粻��ͨ����������,��"ANY_CLASS"
//��������������:���ڵ�����,��û�д�����,��"ANY_NAME"
//�����������:��1��ʼ����,1��ʾ��1���������ʹ����������ϵĴ���,
//����������������Ų�Ϊ1,�����β��ҷ�����������ŵĴ���
//�������ڼ����Ϊ50��
//������Ҫ����Ҫ���ҵ�һ������Ϊ"TopClass"���������޵ĵڶ��Ӵ���(����������������),
//�����ִ�����:
//��������TopClass,ANY_NAME,1\nANY_CLASS,ANY_NAME,2
function DecodeWndSync(
  pszWndDef : LPCSTR;
  lpRect : PRect;
  usTimeout : Word;
  ulVCodeTypeID : Longint;
  lpszVCodeText : LPSTR ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'DecodeWndSync';


//ͨ��������֤��ͼƬ�������������(ͬ��)����������Ҫ�������ز�����֤��ͼƬ��
//    ���ͼƬ���ݺ���ñ������������
//��������������[in]pImageData - ��֤��ͼƬ����
//��������������[in]dwDataLen - ��֤��ͼƬ���ݳ��ȣ���pImageData��С������4M
//��������������[in]pszExtName - ͼƬ��չ������JPEG��BMP��PNG��GIF
//��������������[in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//��������������[in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨
//                      ����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//��������������[out]pszVCodeText - �ɹ�ʱ������֤���ı�������������30���ֽڡ�
//����ֵ��������>0 �ɹ���������֤��ID���û�����ReportResult; <0ʧ�ܣ���������붨��
function DecodeBufSync(
  pImageData : Pointer;
  dwDataLen : Integer;
  pszExtName : LPCSTR;
  usTimeout : Word;
  ulVCodeTypeID : Longint;
  lpszVCodeText : LPSTR ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'DecodeBufSync';


//ͨ�����뱾��ͼƬ�ļ����������(ͬ��)����������Ҫ����������֤��ͼƬ�ļ�������
//��������������[in]pszFilePath - ��֤��ͼƬ�ļ�·������Ϊ���·����Ҳ��Ϊ����·����
//��������������[in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//��������������[in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨
//                      ����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//��������������[out]pszVCodeText - �ɹ�ʱ������֤���ı�������������30���ֽڡ�
//����ֵ��������>0 �ɹ���������֤��ID���û�����ReportResult; <0ʧ�ܣ���������붨��
function DecodeFileSync(
  pszFilePath : LPCSTR;
  usTimeout : Word;
  ulVCodeTypeID : Longint;
  lpszVCodeText : LPSTR ) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'DecodeFileSync';


//���ܣ���������һ��ͨ�����뱾����֤��ͼƬ�ļ������������루ͬ���汾��
//��������������D2File
//����ֵ��������>0���ɹ���������֤��ID�����ڵ���ReportResult,��С��0��ʧ�ܣ���������붨��
//          Ӧ��ͣ������Ĵ����������-1~-199�����������û����󣩡�-208��������ã���-210���Ƿ��û�����-301�����ô���DLL�Ҳ�����
//������
//      [in]pszSoftwareID��32��16hex�ַ���ɣ�
//      [in]pszUserName���û��������31�ֽڣ�
//      [in]pszUserPassword�����룬���16�ֽڣ�
//      [in]pszFileName - ������֤��ͼƬ�ļ���
//      [in]ucVerificationCodeLen - ��֤�볤�ȣ�������ȷ����֤�볤�ȣ������ȱ�ʶ��������Ȳ������ɴ�0
//      [in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//      [in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//      [out]pszVCodeText - �ɹ�ʱ������֤���ı�������������30���ֽڡ�
function D2File(
    pszSoftwareID : LPCSTR;
    pszUserName : LPCSTR;
    pszUswrPassword : LPCSTR;
    pszFileName : LPCSTR;
    usTimeout : Word;
    ulVCodeTypeID : Longint;
    pszVCodeText : LPSTR) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'D2File';


//���ܣ���������һ��ͨ��������֤��ͼƬ������������룬��������Ҫ�������ز�����֤��ͼƬ�����ͼƬ���ݺ���ñ�����������루ͬ���汾��
//��������������D2Buf
//����ֵ��������>0���ɹ���������֤��ID�����ڵ���ReportResult,��С��0��ʧ�ܣ���������붨��
//          Ӧ��ͣ������Ĵ����������-1~-199�����������û����󣩡�-208��������ã���-210���Ƿ��û�����-301�����ô���DLL�Ҳ�����
//��������������
//      [in]pszSoftwareID��32��16hex�ַ���ɣ�
//      [in]pszUserName���û��������31�ֽڣ�
//      [in]pszUserPassword�����룬���16�ֽڣ�
//      [in]pImageData - ��֤��ͼƬ����
//      [in]dwDataLen - ��֤��ͼƬ���ݳ��ȣ���pImageData��С������4M
//      [in]usTimeout - ��֤�볬ʱʱ�䣬���������֤�뽫ʧЧ����λ�롣�Ƽ�120
//      [in]ulVCodeTypeID - ��֤������ID����ͨ�������ÿ����ߺ�̨����ӵ����������Լ���������õ�����֤�����ͣ�����ȡ���ɵ�ID
//      [out]pszVCodeText - �ɹ�ʱ������֤���ı�������������30���ֽڡ�
function D2Buf(
    pszSoftwareID : LPCSTR;
    pszUserName : LPCSTR;
    pszUswrPassword : LPCSTR;
    pImageData : Pointer;
    dwDataLen : Integer;
    usTimeout : Word;
    ulVCodeTypeID : Longint;
    pszVCodeText : LPSTR) : Integer;
stdcall; external 'CrackCaptchaAPI.dll' name 'D2Buf';

////////////////////////////////////////////////////////////////////////
//      End of Dama2.dll
////////////////////////////////////////////////////////////////////////

implementation

end.
