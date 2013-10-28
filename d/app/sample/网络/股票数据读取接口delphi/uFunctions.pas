unit uFunctions;
{
ͨ����ʵʱ������տؼ� DLL ���ڲ����� Delphi ʵ�ּ���������
    renshouren
WEB     :http://renshou.net
E-MAIL  :lxy@renshou.net
QQ      :114032666
TEL     :13118369704
}
interface
uses SysUtils, Classes, Windows, TDXEDCode, uSockTDXManager, TDXGrobal;

{---------------ע��-----------------
   �ص������� Delphi ��������������ݽṹ��μ� TDXGrobal.pas
   �� DLL ����ʹ�� LoadLibrary ��ʽ��ʽ�����������
}

//2010.08.07
{
�������ݽ������(ʹ�ö��������ݹ����߳�)
����
Handle  = �����ߴ��� Handle ����������ڻ�����ݺ���������ڷ�����Ϣ�������ʹ�ûص�������ʽ�������򽫸ò�������Ϊ0
RegKey  = ע���ַ���������ʱֱ��ʹ�ÿ�ֵ�� δע��ʱ�����ؼ���һ�����������ݹ����󣬽���������ҽ���
����ֵ
���������ݽ�������ľ������Ҫ���þ�����б��棬�Ա�����������ݲ���
}
function  R_Open (Handle: THandle; RegKey: PChar): longword; stdcall;
{
�ͷ����ݽ������
����
TDXManager = ��Ҫ�ͷŵ�����ľ��
}
procedure R_Close (TDXManager: longword); stdcall;



{���ӵ����������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
ServerAddr = �����������ַ��������IP������
Port       = �������˿� ��ͨ��Ʊ����=7709  ��ָ�ڻ�=7721
����ֵ
True   �ɹ�����
False  ʧ��
}
function  R_Connect (TDXManager: longword; ServerAddr: PChar; port:integer=7709):LongBool; stdcall;

{
�Ͽ��������������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
}
procedure R_DisConnect (TDXManager: longword);stdcall;


{
��ʼ���г�����  ������µ�֤ȯ������֤ȯ���Ƶ����ݵı�
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
Market 0=���� 1=�Ϻ�
}
procedure R_InitMarketData (TDXManager: longword; Market: integer); stdcall;//��ʼ���г�����


procedure S_InitMarketData (TDXManager: longword; CallBack  :TOnDecodePacket_INITMARKET); stdcall;


{
���������̿�Ҫ��
���ṩ��������������׼ȷ����
�����ṩ֤ȯ���ƣ�Ҳһ����׼ȷ����
�����ṩ֤ȯ����
��Ϊ�Ϻ������ڴ���ͬ���Ĵ��룬��000001���Ϻ��������ָ���������ڴ����չ�������п��ܷ��͵��ǲ�������Ԥ�ڵ����ݣ�
��ʱ���������֤ȯ���������г�ָ���ַ����磺000001SH �ʹ����Ϻ���000001 000001SZ�������ڵ�000001
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StkCode = ֤ȯ����
StkName = ֤ȯ����
}
procedure R_GetPK (TDXManager: longword; StkCode  :PChar; StkName :PChar); stdcall;

{
���õ����յ���Ʊ�̿�ʱ�Ļص�����
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
CallBack  = �ص�����
}
procedure S_GetPK (TDXManager: longword; CallBack :TOnDecodePacket_PKDAT); stdcall;


{
���������̿�Ҫ��[֧��ͬʱ��ֻ��Ʊ]
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StockCodeNames  = ֤ȯ�б���ʽΪ ��Ʊ����+�г����룬�м���","�ָ������磺 600158SH,000002SZ ��ʾ������ �����ҵ �� ���A���̿�
}
procedure R_GetPKS (TDXManager: longword; StockCodeNames :PChar); stdcall;


{
�����Ƿ���ʵʱ���ݱ仯����
�����ñȽ�Ƶ��������������ͱ����󣬲����Ƿ����µĽ������ݻ��̿ڱ仯������У��򷵻����ݣ�û�У��򲻷�������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StkCode = ֤ȯ����
Market  = �г����
Time    = ���һ�ν��յ����̿����ݽṹ TTDX_PKBASE.LastDealTime ��ֵ����=0����һ���᷵�ص�ǰ�����̿�����

}
procedure R_GetTestRealPK (TDXManager: longword; StkCode: PChar; market, Time: integer);  stdcall;


{
���õ����յ�ʵʱ�̿�ʱ�Ļص�����
}
procedure S_GetTestRealPK (TDXManager: longword; CallBack :TOnDecodePacket_REALPK); stdcall;


{
������������K������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StkCode = ֤ȯ����
Market  = �г����
startcount  = ��ʼ�������������ӵ�ǰ���½����������Ƶ����֣���=0������½����տ�ʼ
count   = ��ȡ����K������
}
procedure R_GetKDays (TDXManager: longword; StkCode: PChar; market, startcount, count: integer); stdcall;//�����K��


{
���õ����յ���K������ʱ�Ļص�����
}
procedure S_GetKDays (TDXManager: longword; CallBack  :TOnDecodePacket_DAYS); stdcall;


{
���������÷ֱʳɽ�����
����
startcount  = ������һ�ʽ��������ƵĿ�ʼ����
count       = ��Ҫ��ȡ�ı���
}
procedure R_GetDeals (TDXManager: longword; StkCode: PChar; market, startcount, count: integer); stdcall; //�ֱʳɽ�

{
���õ���÷ֱʳɽ�ʱ�Ļص�����
}
procedure S_GetDeals (TDXManager: longword; CallBack  :TOnDecodePacket_DEALS); stdcall;


{
���������÷�ʱ�ɽ�����
����
start   = ��ʼ��������һ��ȡ0�����ص�ǰ���з�ʱ����
}
procedure R_GetMins  (TDXManager: longword; StkCode: PChar; market, start: integer); stdcall;//��ʱͼ


{
���õ���÷�ʱͼʱ�Ļص�����
}
procedure S_GetMins  (TDXManager: longword; CallBack  :TOnDecodePacket_MINS); stdcall;



//====================�ڻ�
{
���������ù�ָ�ڻ���K������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StkCode = ֤ȯ����
startcount  = ��ʼ�������������ӵ�ǰ���½����������Ƶ����֣���=0������½����տ�ʼ
count   = ��ȡ����K������
}
procedure R_Get_QH_KDays (TDXManager: longword; StkCode :PChar; startcount, count: integer); stdcall;

{
���õ����յ��ڻ���K��ʱ�Ļص�����
}
procedure S_Get_QH_KDays (TDXManager: longword; CallBack  :TOnDecodePacket_FUTURES_DAYS); stdcall;

{
���ͻ��ʵʱ���ݱ仯���󣬷��ͱ�����󣬹�ָ�ڻ�����������10�����������ö�ʱ���������̿ڱ仯����ִη���
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StkCode = ֤ȯ����
}
procedure R_Get_QH_TestRealPK (TDXManager: longword; StkCode  :PChar); stdcall;

{
���õ����յ���ָ�ڻ������������̿�����ʱ�Ļص�����
}
procedure S_Get_QH_TestRealPK (TDXManager: longword; CallBack :TOnDecodePacket_FUTURES_PKDAT); stdcall;

{
���������ڻ���ʱͼ����
}
procedure R_Get_QH_Mins (TDXManager: longword; StkCode  :PChar); stdcall;

{
���õ�����ڻ���ʱͼʱ�Ļص�����
}
procedure S_Get_QH_Mins (TDXManager: longword; CallBack :TOnDecodePacket_FUTURES_MINS); stdcall;

{
���������ڻ��ֱʳɽ���������
}
procedure R_Get_QH_Deals (TDXManager: longword; StkCode :PChar; startcount, count: integer); stdcall;

{
���õ�����ڻ��ֱʳɽ�����ʱ�Ļص�����
}
procedure S_Get_QH_Deals (TDXManager: longword; CallBack  :TOnDecodePacket_FUTURES_DEALS); stdcall;

{
����г����ͣ������ڵ��� R_InitMarketData ������ó�ʼ���г����ݺ�
��������������ȷ����ʱ������׼ȷ�����г������ֻ��StkCode��������˲������п��ܴ���ͬ������˷�������һ���г�������
��ֻ��StkName������һ������¶�����׼ȷ����
����
StkCode = ֤ȯ����
StkName = ֤ȯ����
����ֵ
0=����
1=�Ϻ�
255=δ�ҵ�
}
function  R_GetMarket (StkCode  :PChar; StkName :PChar): integer; stdcall;
function  R_GetMarketByStockCode (StkCode  :PChar): integer; stdcall;
function  R_GetMarketByStockName (StkName  :PChar): integer; stdcall;
function  R_GetStockName (StkCode :PChar; Market: integer): PChar; stdcall;
function  R_GetStockCode (StkName :PChar): PChar; stdcall;


//ע�ᵱ TDXManager �����Ϸ�����ʱ�Ļص�����
procedure S_Connected (TDXManager: longword; CallBack :TRNotifyEvent); stdcall;
//ע�ᵱ TDXManager ����������ӶϿ�ʱ�Ļص�����
procedure S_DisConnected (TDXManager: longword; CallBack  :TRNotifyEvent); stdcall;


var
   //tdx  :TTDXManager;
   TimerID  :longword;
   Managers :TList;

implementation
procedure TimerProc (a, b, c, d: longword); Stdcall;
var i: integer;
begin

   for i  := 0 to Managers.Count - 1 do  begin
      TTDXManager (Managers.Items[i]).Run;
      //MessageBox (0, 'dd', nil, 0);
   end;
end;

procedure ClearManagers;
var i: integer;
begin
   for i  := Managers.Count -1 downto 0 do begin
          TTDXManager (Managers.Items[i]).Free;
   end; 
   Managers.Clear;
end;

function  R_Open (Handle: THandle; RegKey: PChar): longword; stdcall;
var obj: TTDXManager;
begin
   obj  := TTDXManager.Create(nil);
   obj.Handle := Handle;
   obj.RegKeyString := StrPas (RegKey);
   Managers.Add(obj);
   result := longword (obj);
end;
procedure R_Close (TDXManager: longword); stdcall;
var i: integer;
begin
   for i  := Managers.Count - 1 downto 0 do begin
      if TDXManager = longword (Managers.Items[i]) then begin
         Managers.Delete(i);

         TTDXManager (TDXManager).Free;
         break;
      end;
   end;
end;

function  R_Connect (TDXManager: longword; ServerAddr: PChar; port:integer=7709):LongBool; stdcall;
begin
   if ServerAddr <> nil then
      TTDXManager (TDXManager).Host := StrPas (ServerAddr);
   TTDXManager (TDXManager).Port := port;
   result   := TTDXManager (TDXManager).Connect;
end;

procedure R_DisConnect (TDXManager: longword) ;stdcall;
begin
   if TTDXManager (TDXManager).IdTCPClient.Connected then begin
      TTDXManager (TDXManager).IdTCPClient.Disconnect;
   end;
end;

//ע�ᵱ TDXManager �����Ϸ�����ʱ�Ļص�����
procedure S_Connected (TDXManager: longword; CallBack :TRNotifyEvent); stdcall;
begin
   TTDXManager (TDXManager).OnConnected := CallBack;
end;
//ע�ᵱ TDXManager ����������ӶϿ�ʱ�Ļص�����
procedure S_DisConnected (TDXManager: longword; CallBack  :TRNotifyEvent); stdcall;
begin
   TTDXManager (TDXManager).OnDisConnected  := CallBack;
end;

procedure R_InitMarketData (TDXManager: longword; Market: integer); stdcall;//��ʼ���г�����
begin
   TTDXManager (TDXManager).Get_InitData(market);
end;

procedure S_InitMarketData (TDXManager: longword; CallBack  :TOnDecodePacket_INITMARKET); stdcall;
begin
   TTDXManager (TDXManager).OnDecodePacket_INITMARKET := CallBack;
end;

procedure R_GetPK (TDXManager: longword; StkCode  :PChar; StkName: PChar); stdcall;
var sCode, sName, str: string;
    market: byte;
begin
   sCode  := StrPas (StkCode);
   sName  := StrPas (StkName);
   str  := '';
   if SName <> '' then begin
      str := GetStockCode (SName);
      if Str <> '' then
         sCode := str;
   end;

   if length (sCode) = 8 then begin
      str := copy (sCode, 7, 2);
      Delete (sCode, 7, 2);
      if SameText (str, 'SZ') then
         market := 0
      else if Sametext (str, 'SH') then
         market := 1
      else
         market := 255;
   end else
      market := GetMarketMode (scode, sName);

   if market = 255 then begin
      MessageBox (0, 'δ�ҵ�ƥ��Ĵ��������ơ�', '����', 0);
      exit;
   end;


   Case market of
         0: sCode := sCode + 'SZ';
         1: sCode := sCode + 'SH';
   end;

   TTDXManager(TDXManager).Get_PK(sCode);

end;

procedure S_GetPK (TDXManager: longword; CallBack :TOnDecodePacket_PKDAT); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_PKDAT := CallBack;
end;

procedure  R_GetPKS (TDXManager: longword; StockCodeNames :PChar); stdcall;
begin
   TTDXManager(TDXManager).Get_PK(StrPas (StockCodeNames));
end;

procedure R_GetTestRealPK (TDXManager: longword; StkCode: PChar; market, Time: integer);  stdcall;
begin
   TTDXManager(TDXManager).Get_TestRealPK(StkCode, market, Time);
end;
procedure S_GetTestRealPK (TDXManager: longword; CallBack :TOnDecodePacket_REALPK); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_REALPK  := CallBack;
end;
procedure R_GetKDays (TDXManager: longword; StkCode: PChar; market, startcount, count: integer); stdcall;//�����K��
begin
   TTDXManager(TDXManager).Get_K_Days(stkcode, market, startcount, count);
end;
procedure S_GetKDays (TDXManager: longword; CallBack  :TOnDecodePacket_DAYS); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_DAYS  := CallBack;
end;
procedure R_GetDeals (TDXManager: longword; StkCode: PChar; market, startcount, count: integer); stdcall; //�ֱʳɽ�
begin
   TTDXManager(TDXManager).Get_Deals(stkcode, market, startcount, count);
end;
procedure S_GetDeals (TDXManager: longword; CallBack  :TOnDecodePacket_DEALS); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_DEALS := CallBack;
end;
procedure R_GetMins  (TDXManager: longword; StkCode: PChar; market, start: integer); stdcall; //��ʱͼ
begin
   TTDXManager(TDXManager).Get_Mins(stkcode, market, start);
end;

procedure S_GetMins  (TDXManager: longword; CallBack  :TOnDecodePacket_MINS); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_MINS  := CallBack;
end;

function  R_GetMarket (StkCode  :PChar; StkName :PChar): integer; stdcall;
begin
   result := GetMarketMode (StrPas (StkCode), StrPas (StkName));
end;

function  R_GetMarketByStockCode (StkCode  :PChar): integer; stdcall;
begin
   result := GetMarketModeByStockCode (StrPas (StkCode));
end;
function  R_GetMarketByStockName (StkName  :PChar): integer; stdcall;
begin
   result := GetMarketModeByStockName (StrPas (StkName) );
end;
function  R_GetStockName (StkCode :PChar; Market: integer): PChar; stdcall;
begin
   result := PChar (GetStockName ( StrPas (StkCode), Market ));
end;
function  R_GetStockCode (StkName :PChar): PChar; stdcall;
begin
   result := PChar (GetStockCode ( StrPas (StkName) ));
end;


//�ڻ�
//�ڻ�
procedure R_Get_QH_KDays (TDXManager: longword; StkCode :PChar; startcount, count: integer); stdcall;
begin
   TTDXManager(TDXManager).Get_Futures_KDays(StrPas (StkCode), startcount, count);
end;
procedure S_Get_QH_KDays (TDXManager: longword; CallBack  :TOnDecodePacket_FUTURES_DAYS); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_FUTURES_DAYS  := CallBack;
end;
procedure R_Get_QH_TestRealPK (TDXManager: longword; StkCode  :PChar); stdcall;
begin
   TTDXManager(TDXManager).Get_TestRealFutures(StrPas (StkCode));
end;

procedure S_Get_QH_TestRealPK (TDXManager: longword; CallBack :TOnDecodePacket_FUTURES_PKDAT); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePatcket_FUTURES_PKDAT  := CallBack;
end;

procedure R_Get_QH_Mins (TDXManager: longword; StkCode  :PChar); stdcall;
begin
   TTDXManager(TDXManager).Get_Futures_Mins(StrPas (StkCode));
end;

procedure S_Get_QH_Mins (TDXManager: longword; CallBack :TOnDecodePacket_FUTURES_MINS); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_FUTURES_MINS  := CallBack;
end;

procedure R_Get_QH_Deals (TDXManager: longword; StkCode :PChar; startcount, count: integer); stdcall;
begin
   TTDXManager(TDXManager).Get_Furures_Deals(StrPas (StkCode), startcount, count);
end;
procedure S_Get_QH_Deals (TDXManager: longword; CallBack  :TOnDecodePacket_FUTURES_DEALS); stdcall;
begin
   TTDXManager(TDXManager).OnDecodePacket_FUTURES_DEALS := CallBack;
end;

Initialization

   Managers := TList.Create;
   TimerID  := SetTimer (0, 0, 100, @TimerProc);

finalization
   if TimerID <> 0 then
      KIllTimer (0, TimerID);
   ClearManagers;
   Managers.Free;
  

end.

