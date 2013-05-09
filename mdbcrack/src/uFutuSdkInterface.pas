{/**********************************************************************
* Դ��������: futu_sdk_interface.h
* �������Ȩ: �������ӹɷ����޹�˾
* ϵͳ����  : 06�汾�ڻ�ϵͳ
* ģ������  : �����ڻ��ܱ߽ӿ�
* ����˵��  : �ܱ�ͨ�Žӿڶ���
* ��    ��  : xdx
* ��������  : 20110315
* ��    ע  : �ܱ�ͨ�Žӿڶ���  
* �޸���Ա  ��
* �޸�����  ��
* �޸�˵��  ��20110315 ����
**********************************************************************/}
unit uFutuSdkInterface;

interface

uses
  Classes,uFutuDataTypes,uFutuMessageInterface;

type

  //ǰ����
  IFuCallBack = class;

////////////////////////////////�ڻ�ͨ�Ŷ���ӿ�//////////////////////////////////////////
  IHsFutuComm = class(IHSKnown)
  public
	{/**
	 * �������ò���
	 *@param szSection �ڵ���
	 *@param szName    ������
	 *@param szVal     ����ֵ
	 *@return R_OK�ɹ�������ʧ��
         [���̰߳�ȫ]
        */}
	function SetConfig(const szSection:PChar;const szName:PChar;const szVal:PChar):Integer;virtual;stdcall;abstract;

	{/**
	 * ��ʼ���ӿ�,ʼ����������,���ӵ�½��������ȡ����Ӧ����Ϣ
	 *@param lpCallback �첽�ص�����,���û��̳ж�Ӧ�Ľӿ�ʵ��֮,ΪNULL���ʾ�����Ļص���Ϣ
	 *@param iTimeOut   ��ʱʱ��,��ʾ��ʼ����ʱʱ��,��λ����,-1��ʾ�����ڵȴ�.
	 *@return R_OK��ʾ�ɹ�,������ʾʧ��
         [�̰߳�ȫ]
	*/}
	function Init(lpCallback:IFuCallBack;iTimeOut:Integer=5000):Integer;virtual;stdcall;abstract;
	
	{/**
	 * ��������,��������Ӧ�õ�ͨ������.��ͨ�����ӶϿ�ʱ,Ҳ���Ե��ô˺���������������
	 *@param iType Ҫ�����ķ�������.����ȡֵ(���������):SERVICE_TYPE_TRADE,SERVICE_TYPE_QUOTE
	 *@param iTimeout ��������ʱ
         [�̰߳�ȫ]
	*/}
	function Start(iType:Integer;iTimeOut:Integer=5000):Integer;virtual;stdcall;abstract;

	{/**
	 * �û���¼,���������ҵ��֮ǰ,��Ҫ�ȵ�½��ȡ����ص���֤�����Ϣ
	 *@param szUserID   �û���,һ��ָ�ʲ��˺�
	 *@param szUserPass �û�����
	 *@param reportFlag �û��Ƿ���ҪUFT���ƻر���1��Ҫ��0����Ҫ
	 * *@param lpReserved ��������,V1�汾��������ΪNULL
	 *@return ERR_OK��ʾ����ɹ�(����ʱ������ʾ�Ѿ���½�ɹ�,����첽�ص���ȡӦ����Ϣ)
         [�̰߳�ȫ]
	*/}
	function DoLogin(const szUserID:PChar;const szUserPass:PChar;const reportFlag:Integer;const lpReserved:Pointer = nil):Integer;virtual;stdcall;abstract;

 {/**luyj 20110701������Ĳ��������ܻ�����Ϣ������Ҫ�첽�ص����޸ĵ�20110623004
	 * �û���¼,���������ҵ��֮ǰ,��Ҫ�ȵ�½��ȡ����ص���֤�����Ϣ
	 *@param szUserID   �û���,һ��ָ�ʲ��˺�
	 *@param szUserPass �û�����
	 *@param lpReceivedMsg �û��ķ�����Ϣ
	 *@param reportFlag �û��Ƿ���ҪUFT���ƻر���1��Ҫ��0����Ҫ
	 *@param lpReserved ��������,���汾�ӿڱ�������ΪNULL
	 *@return           ERR_OK��ʾ����ɹ�(����ʱ������ʾ�Ѿ���½�ɹ�,Ҫ��lpReceivedMsgȡ��Ӧ����Ϣ)
         [�̰߳�ȫ]
	*/}
	function DoLoginEx(const szUserID:PChar;const szUserPass:PChar;lpReceivedMsg:IFuMessage;const reportFlag:Integer;const lpReserved:Pointer = nil):Integer;virtual;stdcall;abstract;

	{/**
          *����һ��ҵ��������Ϣ(����������첽�ص��н���)
	  *@param lpMessage һ��ҵ��������Ϣ,���û����������������
	  *@param iKeyID    һ���Զ����ʶ,�첽Ӧ����л���˱�ʶ.-1��ʾ�����Ĵ˱�־(��Ĭ���첽Ӧ�����ʽ��˺���Ϊkeyid)
          *@return ERR_OK��ʾ��������ɹ�,��Ҫ���첽�ص���ȡ��Ӧ��Ӧ����Ϣ���
          [���̰߳�ȫ]
	*/}
	function AsyncSend(const lpReqMsg:IFuMessage;iKeyID:Integer=-1):Integer;virtual;stdcall;abstract;

	{/** ͬ������һ��ҵ��������Ϣ
	 *@param lpReqMsg �����ҵ����Ϣ  [in]
	 *@param lpAnsMsg ͬ��Ӧ��ҵ����Ϣ[out]
	 *@param iTimeout ��ʱʱ��,��λ����
	 *@return ERR_OK��ʾ�ɹ�,������ʾʧ��
	 [���̰߳�ȫ]
	*/}
	function SyncSendRecv(const lpReqMsg:IFuMessage;lpAnsMsg:IFuMessage;iTimeout:Integer=3000):Integer;virtual;stdcall;abstract;

	{/**
	 * ���Ͷ�������,ҵ����ս��
	 *@param rType   ��������(�μ�REGType�Ķ���)
	 *@param rAction ����/�˶��ȶ���(�μ�REGAction�Ķ���)
	 *@param szParam ���ݲ�ͬ��rType����:
	                 ��������:szParam��ʾ���ĵĺ�Լ�б�,�Զ��ŷָ��ַ���,����WS905,a0905,cu0905,IF0905  
	                          ������ȫ�г�������,���Ĵ���ΪALLWWW
	                          ��Լ��ֻ��ָ��һ������(���Ȼ������)
				     ���ǻر�/������Ϣ:szParam���ʾ�����ĵ��û��˺�,ע��������˺Ŷ��ǵ�½�����˺�
	 *@return ERR_OK��ʾ����ɹ�(���첽Ӧ����ȡ���Ľ��),������ʾ����ʧ��
	 [���̰߳�ȫ]
	*/}
	function SubscribeRequest(rType:REGType;rAction:REGAction;const szParam:PChar):Integer;virtual;stdcall;abstract;

	 {/*
          *�û��ǳ�
	  *@param szUserID    ���ǳ����û��˺�
	  *@param lpReserved  ����֮��,V1�汾��������ΪNULL
          *@return ERR_OK��ʾ����ɹ�,������Դӵ�½Ӧ����ȡ����Ϣ
	  [�̰߳�ȫ]
         */}
	function DoLogout(const szUserID:PChar;const lpReserved:Pointer = nil):Integer;virtual;stdcall;abstract;

	{/**
	  * �ر�����ͨ�Ŷ���,�ͷ���Ӧ����Դ
	  @return R_OK�ɹ�,������ʾʧ��
         [�̰߳�ȫ]
	*/}
	function Stop():Integer;virtual;stdcall;abstract;

	{/**
	 * ��ȡ����״̬
         *@param iIndex���ӱ��.SERVICE_TYPE_TRADE - ��ʾ�������� SERVICE_TYPE_QUOTE -����(���ܰ����ر�)����
	 *@return ��ȡ����״̬
         [�̰߳�ȫ]
	*/}
	function GetStatus(iIndex:Integer):Integer;virtual;stdcall;abstract;

	{/**
	 * ��ȡ������Ϣ
	 *@param iErrNo ��ȡ������Ϣ
	 *@return ��ȡ������Ϣ��˵��
         [�̰߳�ȫ]
	*/}
	function GetErrorMsg(iErrNo:Integer):PChar;virtual;stdcall;abstract;

	{/**
	 * ��ʵ���������
	 *@param lpKey   Ҫ�󶨵����ݻ�����
          *@param iKeyLen Ҫ�󶨵����ݳ���
	 *@return �󶨳ɹ�,��ʧ��
         [�̰߳�ȫ]
	*/}
	function SetKeyData(const lpKeyData:Pointer;iLen:Integer):Integer;virtual;stdcall;abstract;

	{/**
	 * ��ȡ�󶨵�����
	 *param iLen Ҫbanding�����ݳ���
	 *return ����Ҫ�󶨵�����ָ��
         [�̰߳�ȫ]
	*/}
	function GetKeyData(var iLen:Integer):Pointer;virtual;stdcall;abstract;
  end;

  ////////////////////////ͨ���첽�ص��ӿ�(ע��ص��е�IFuMessage��Ϣ��SDK��������������)//////////////////////////////////////////////////
  IFuCallBack = class(IHSKnown)
  public
	{/**
	 * ����״̬�ĸı�
	 *@param lpComm ͨ�Žӿڶ���
	 *@param iRet   ����״̬��ʶ
	 *@param szNotifyTime ������ʱ��
	 *@param szMessage ˵����Ϣ
	*/}
        procedure OnConnStateNotify(lpInst:Pointer;iType:Integer;iStatus:Integer;
                                     const szNotifyTime:PChar;
                                     const szMsg:PChar);virtual;stdcall;abstract;

	{/**
	 * ��½Ӧ����Ϣ
	 *@param lpComm ͨ�Žӿڶ���
	*/}
	procedure OnRspLogin(lpInst:Pointer;lpMsg:IFuMessage);virtual;stdcall;abstract;

	{/**
	 * �ǳ�����
	 *@param lpComm ͨ�Žӿڶ���
	*/}
	procedure OnRspLogout(lpInst:Pointer;lpMsg:IFuMessage);virtual;stdcall;abstract;

	{/**
	 *����\�˶�������߻ر��Ľ��
	 *@param lpComm    ͨ�Žӿڶ���
	 *@param sType     ��������(��������,�ر���)
	 *@param aAction   ����ʽ(����,ȡ��,ȡ��ȫ��,����)
	 *@param iResult   ���Ľ��,-1δ֪ʧ��,0���ĳɹ�,1�ظ�����,2ȡ���ɹ�,3û�ж��Ŀ���ȡ��
	 *@param lpParam   ���ӵĲ���,���ǻر�Ӧ��,�����˺�;��������,���Ǻ�Լ����;ALLWWW��ʾ����;NULLδ֪
	 *@param szMessage ����˵��  
	*/}
        procedure OnRspSubResult(lpInst:Pointer;sType:REGType;
                                 aAction:REGAction;iResult:Integer;
                                 const lpParam:PChar;const szMsg:PChar);virtual;stdcall;abstract;

	{/**
	 * ҵ����յ�ҵ��Ӧ����Ϣ
	 *@param lpComm     ͨ�Žӿڶ���
	 *@param lpAnsData  ҵ��Ӧ����Ϣ
       */}
	procedure OnReceivedBiz(lpInst:Pointer;lpAnsData:IFuMessage;iRet:Integer;iKeyID:Integer);virtual;stdcall;abstract;

	{/**
	 * ���յ������г�����
	 *@param lpComm     ͨ�Žӿڶ���
	 *@param lpInfo     ������������
	*/}
	procedure  OnRspMarketInfo(lpInst:Pointer;const lpData:LPCMarketInfo;rAction:REGAction);virtual;stdcall;abstract;

	//���յ�����г�����
	{/**
	* ���յ������г�����
	*@param lpComm     ͨ�Žӿڶ���
	*@param lpInfo     ������������
	*/}
	procedure  OnRspArgMaketInfo(lpInst:Pointer;const lpData:LPCArgMarketInfo;rAction:REGAction);virtual;stdcall;abstract;

        {/**
	 * ���յ�ί�з�����Ϣ
	 *@param lpComm     ͨ�Žӿڶ���
	 *@param lpInfo     ί�з�����Ϣ
	*/}
	procedure OnRecvOrderInfo(lpInst:Pointer;const lpInfo:LPCOrderRspInfo);virtual;stdcall;abstract;

	{/**
	 * ���յ������ɽ�����
	 *@param lpComm     ͨ�Žӿڶ���
	 *@param lpInfo     �����ɽ�����
	*/}
        procedure OnRecvOrderRealInfo(lpInst:Pointer;const lpInfo:LPCRealRspInfo);virtual;stdcall;abstract;
        
	{/**
	 * ���߸�����Ϣ
	 *@param  lpComm    ͨ�Žӿڶ���
	 *@param  szUsrID   ��Ϣ��ص��˺�
	 *@param  szMessage ��صĸ�����Ϣ
	*/}
        procedure OnRspOnlineMsg(lpInst:Pointer;szUsrID:PChar;szMessage:PChar);virtual;stdcall;abstract;
end;


implementation
  
end.
