{/**********************************************************************
* Դ��������: futu_message_interface.h
* �������Ȩ: �������ӹɷ����޹�˾
* ϵͳ����  : 06�汾�ڻ�ϵͳ
* ģ������  : �����ڻ��ܱ߽ӿ�
* ����˵��  : �ܱ߽ӿ����ݲ�������
* ��    ��  : xdx
* ��������  : 20110315
* ��    ע  : �������Ͷ���
* �޸���Ա  ��
* �޸�����  ��
* �޸�˵��  ��20110315 ����
**********************************************************************/}

unit uFutuMessageInterface;

interface

uses
  Classes;

type

//����ӿ�ͳһ�Ĳ�ѯ�����ýӿ� (����COM��׼)
  IHSKnown = class
  public
    {/**
    * ��ѯ�뵱ǰ�ӿ���ص������ӿ�(���ӿ���һ�㲻ʹ��)
     *@param HS_SID  iid  �ӿ�ȫ��Ψһ��ʶ
     *@param IKnown **ppv ����iid��Ӧ�Ľӿ�ָ��
     *@return R_OK �ɹ���R_FAIL δ�鵽iid ��Ӧ�ӿ�
    */}
    function QueryInterface(const iid: PChar; ppv: Pointer): Integer; virtual; stdcall; abstract;

    {/**
     * ���ýӿڣ����ü�����һ
     *@return ��ǰ���ü���
    */}
    function AddRef(): Integer; virtual; stdcall; abstract;

    {/**
     * �ͷŽӿڣ����ü�����һ������Ϊ0ʱ�ͷŽӿڵ�ʵ�ֶ���
     *@param R_OK��ʾ�ɹ�,������ʾʧ��
    */}
    function Release(): Integer; virtual; stdcall; abstract;
  end;


{/*
  һ����Ϣ���ݼ�¼,�����˺ܶ��tag=value,����tag���ظ�
  �ظ�������ͬ��tag,�򸲸��ϴε�����
  Ϊ��ʹ�ӿڿ�����,��֧��������������:
          ���ַ���(char),��'A','1',
 ����(int),��123,-2343
 ������(float),��23.50,-34.34
 �ַ�����(C���Է��'\0'��β�Ĵ�)(char*),��"Hello World"
  ע����ӿڷ����̰߳�ȫ��
*/}
  IFuRecord = class(IHSKnown)
  public
    ///������ݵķ���,������field�򸲸���ֵ
    {/**
      * ���һ���ַ���ֵ
      *@param sField   �ֶ�����
      *@param cValue   һ���ַ�ֵ
      *@return R_OK��ӳɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function SetChar(const sField: PChar; cValue: Char): Integer; virtual; stdcall; abstract;

    {/**
      * ���һ������ֵ
      *@param sField �ֶ�����
      *@param iValue һ������ֵ
      *@return R_OK��ӳɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function SetInt(const sField: PChar; iValue: Integer): Integer; virtual; stdcall; abstract;

    {/**
      * ���һ������ֵ
      *@param sField �ֶ�����
      *@param cValue һ������ֵ
      *@return R_OK��ӳɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function SetDouble(const sField: PChar; dValue: Double): Integer; virtual; stdcall; abstract;

    {/**
      * ���һ���ַ���(C���Ը�ʽ'\0'��β���ַ���)
      *@param sField �ֶ�����
      *@param cValue һ���ַ���ֵ
      *@return R_OK��ӳɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function SetString(const sField: PChar; const strValue: PChar): Integer; virtual; stdcall; abstract;

    ///�����ֶη������ݵķ���

    {/**
      * ��ȡһ���ַ���ֵ
      *@param sField �ֶ�����
      *@return ��Ч�ַ�ֵ;�ֶβ�������Ĭ��'\0'
      [�̰߳�ȫ]
    */}
    function GetChar(const sField: PChar): Char; virtual; stdcall; abstract;

    {/**
      * ��ȡһ������ֵ
      *@param sField �ֶ�����
      *@return ����һ������ֵ;�ֶβ�������Ĭ�Ϸ���0
      [�̰߳�ȫ]
    */}
    function GetInt(const sField: PChar): Integer; virtual; stdcall; abstract;

    {/**
      * ���һ������ֵ
      *@param sField �ֶ�����
      *@return ����һ������ֵ;�ֶβ�������Ĭ�Ϸ���0.0(ע�⸡���͵ľ�������)
      [�̰߳�ȫ]
    */}
    function GetDouble(const sField: PChar): Double; virtual; stdcall; abstract;

    {/**
      * ���һ���ַ���
      *@param sField �ֶ�����
      *@return ����һ���ַ���,�粻���ڸ��ֶ��򷵻�NULL(0)
      [�̰߳�ȫ]
    */}
    function GetString(const sField: Pchar): PChar; virtual; stdcall; abstract;

    ///�������ʷ���,ͨ���˷��ʿɱ�����������¼
    {/**
      * �ƶ�����¼ͷ(��һ��tag=value)
      *@return R_OK��ʾ�ɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function MoveFirst(): Integer; virtual; stdcall; abstract;

    {/**
      * ��һ����¼
      *@return R_OK��ʾ�ɹ�,������ʾʧ�ܻ��Ѿ�����¼β
      [���̰߳�ȫ]
    */}
    function MoveNext(): Integer; virtual; stdcall; abstract;

    {/**
      * �ж��Ƿ��Ƶ��˼�¼β
      *@return 0��ʾδ����¼β,1��ʾ�ѵ���¼β
      [���̰߳�ȫ]
    */}
    function IsEOF(): Integer; virtual; stdcall; abstract;

    {/**
      * ��ȡ��ǰ�ֶ���(ͨ���������Է��ʵ�ֵ)
      *@return NULL��ʾ�ѵ���β��������,��NULL��ʾ�ֶ���
      [�̰߳�ȫ]
    */}
    function GetFieldName(): PChar; virtual; stdcall; abstract;

    {/**
      * ɾ��һ���ֶ�
      *@param sField Ҫɾ�����ֶ���
      *@return R_OK��ʾɾ���ɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function RemoveField(const sField: PChar): Integer; virtual; stdcall; abstract;

    {/**
      * �Ƿ����ĳ���ֶ�
      *@param sField �ֶ���
      *@return 0��ʾ������,1��ʾ����
      [���̰߳�ȫ]
    */}
    function IsExist(const sField: PChar): Integer; virtual; stdcall; abstract;

    {/**
      * ɾ�����е��ֶ�
      *@return R_OK��ʾ�ɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function Clear(): Integer; virtual; stdcall; abstract;

    {/**
      * ��ȡ��¼����(Field=Value)
      *@return ��ʾ��¼������
      [�̰߳�ȫ]
    */}
    function GetCount(): Integer; virtual; stdcall; abstract;
  end;


///�ڻ���Ϣ�ӿ�,һ����Ϣ����������Ϣ������,����һ��������IFuRecord���
  IFuMessage = class(IHSKnown)
  public
    {/**
      * ������Ϣ����
      *@param iType �μ�FUTU_MSG_TYPE�Ķ���
      *@param iMode ��ʾ����Ϣ��������Ӧ��,0-����,1-Ӧ��
      *@return R_OK��ʾ�ɹ�,������ʾ��Ч��֧�ֵ���Ϣ����
      [���̰߳�ȫ]
    */}
    function SetMsgType(iType: Integer; iMode: Integer): Integer; virtual; stdcall; abstract;

    {/**
      * ��ȡ��Ϣ����
      *@param [int]��Ϣ����.�ο�FUTU_MSG_TYPE�Ķ���
      *@return ��Ϣģʽ.�ο�FUTU_MSG_MODE�Ķ���
      [�̰߳�ȫ]
    */}
    function GetMsgType(iMsgMode: PInteger = nil): Integer; virtual; stdcall; abstract;

    {/**
      * ��ȡ��¼����
      *@param >=0��ʾ��¼����,������ʾ�����ʧ��
      [�̰߳�ȫ]
    */}
    function GetCount(): Integer; virtual; stdcall; abstract;

    {/**
      * ����һ����¼,�������ص�ָ���Բ�����ֵ
      *@return ��NULL��ʾһ����Ч�ļ�¼,NULL��ʾ�����ڴ�ʧ��
      [���̰߳�ȫ]
    */}
    function AddRecord(): IFuRecord; virtual; stdcall; abstract;

    {/**
      * ��ȡһ����¼
      *@param iIndex ��¼����λ��,��0��ʼ����
      *@return ��NULL��ʾһ����Ч�ļ�¼,NULL��ʾ����Խ��
      [���̰߳�ȫ]
    */}
    function GetRecord(iIndex: Integer = 0): IFuRecord; virtual; stdcall; abstract;

    {/**
      * ɾ��һ����¼
      *@param iIndex ��¼����λ��,��0��ʼ����
      *@return R_OK��ʾɾ������,����ʧ��(����������Խ��)
      [���̰߳�ȫ]
    */}
    function DelRecord(iIndex: Integer = 0): Integer; virtual; stdcall; abstract;

    {/**
      * ɾ�����еļ�¼
      *@return R_OK��ʾ�ɹ�,������ʾʧ��
      [���̰߳�ȫ]
    */}
    function Clear(): Integer; virtual; stdcall; abstract;
  end;

implementation

end.
