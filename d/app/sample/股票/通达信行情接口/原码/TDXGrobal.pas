unit TDXGrobal;

interface
uses SysUtils, Classes, Windows, Messages;

{
ͨ����ʵʱ������տؼ�
    renshouren
WEB     :http://renshou.net
E-MAIL  :lxy@renshou.net
QQ      :114032666
TEL     :13118369704

2010.02.28

---------------------------------------- ������־
��ʾ��
   DLL �汾��ʹ�� LoadLibrary ������̬����
   
2010.10.27
   ���ӶԹ�ָ�ڻ����ݵ�֧��
   Get_Futures_KDays() ��ȡ��ָ�ڻ���K��ͼ
   Get_Furures_Deals() ��ȡ��ָ�ڻ��ֱʽ���
   Get_Futures_Mins()  ʵʱ�ɽ�
   Get_TestRealFutures() ʵʱ�̿ڣ���������󣬷���������10������������ʵʱ�̿ڱ仯
   DLL �汾���ӻص��������÷�ʽ���������� Delphi �汾������ο� uFunctions.pas


}

//{$DEFINE _IS_NOT_DELPHI_}     //For DLL �汾����Ϊ DELPHI ����汾��ע�͵�����

Const
   MARKET_SZ        = 0;       //�����г����
   MARKET_SH        = 1;       //�Ϻ��г����

   MARKETS_COUNT    = 2;

   FMarketNames    :array[0..MARKETS_COUNT-1] of string = ('����', '�Ϻ�');
   FMarketCodes    :array[0..MARKETS_COUNT-1] of string = ('SZ', 'SH');




{
=====================================================
dll ����ģʽ ʱ������ô��ڷ��ص���Ϣ
======================================================
}
   //���յ���������   ==>>������Ӧ[SendMessage]  wParam = �������� lParam = ������������ ��TTdxDllShareData)
   WM_TDX_DEPACKDATA = WM_USER + $111;


   //���յ��¼�֪ͨ   ==>>���Բ���Ӧ[PostMessage] wParam = �¼����� lParam = �����߳�(TDXManager)
   WM_TDX_NOTIFYEVENT = WM_USER +$110;


   {-------------------------
   WM_TDX_DEPACKDATA ��Ϣ�� wParam ���������ݴ˲����Ĳ�ͬ, lParam ��ʾ�� PTTdxDllShareData.buf �ֱ��Ӧ��ͬ�����ݽṹ
   ----------------------------
   }
   TDX_MSG_TESTREALPK     = $526;       //ʵʱ�����̿�,��ѯ�Ƿ������±仯
   TDX_MSG_GETPK          = $53E;       // �̿�
   TDX_MSG_GET_K_DAY      = $529;       //�����K��   $52C
   TDX_MSG_GET_MINS       = $51D;       //��ʱͼ
   TDX_MSG_GET_DEALS      = $FC5;       //�ֱ�����
   TDX_MSG_INITDATA       = $450;       //����г���ʼ������
   TDX_MSG_GET_BASEINFO   = $1E;
   TDX_MSG_GET_BASEINFO_  = $0D;
   TDX_MSG_GET_F10        = $2CF;       //���F10��Ŀ�б�
   TDX_MSG_GET_F10TXT     = $2D0;       //��õ�����Ŀ����

   //��ָ�ڻ�
   TDX_MSG_GET_FUTURES_INITMARKETS  = $23F4; //����ڻ��г���ʼ������
   TDX_MSG_GET_FUTURES    = $23FB;      //�ڻ��̿�         Size=$12C
   TDX_MSG_GET_FUTURES_DEALS  =$23FC;   //�ֱ�
   TDX_MSG_GET_FUTURES_MINS  = $23FD;    //��ʱͼ
   TDX_MSG_GET_FUTURES_KDAY = $23FF;    //��K
   TDX_MSG_GET_FUTURES_PK = $2400;      //����̿�����     Size=$12C


   {--------------------
   WM_TDX_NOTIFYEVENT ��Ϣ �� wParam ����
   ----------------------
   }
   TNE_CONNECTED           = 1;                        //ĳ�����߳������ӵ�������
   TNE_ERROR               = -1;
   TNE_BEFOREDEPACKDATA    = 2;                        //�ڽ��յ��κ����ݣ�������δ��ʼ���н������ʱ
   TNE_AFTERDEPACKDATA     = 3;                        //�ڽ��յ��κ����ݣ������ڽ��������ɺ�
   TNE_DISCONNECTED        = 4;                        //ĳ�����߳��Ѵӷ������Ͽ�����

type

   //2011.09.18 K������
   TKLineDateMode   = (
      KD_MIN,  KD_MIN5, KD_MIN10,  KD_MIN15, KD_MIN30, KD_MIN60,
      KD_DAY,  KD_WEEK, KD_MONTH,  KD_DAY45, KD_DAY120,
      KD_YEAR);
Const
   KLineDateModeStr : array[KD_MIN..KD_YEAR] of string =
    (
    '1����',
    '5����',
    '10����',
    '15����',
    '30����',
    '60����',
    '����',
    '����',
    '����',
    '45����',
    '����',
    '����');
type

  TTDX_MSG = record
      MsgID :integer;
      Code  :array[0..1023] of char;                   //��ȡ�̿�����ʱ���п����Ƕ����Ʊ�Ĵ����ַ���
      Name  :array[0..1023] of char;
      Market:integer;
      Date  :TDateTime;
      P1, P2, P3  :integer;
   end;
   pTTDX_MSG  =^TTDX_MSG;
   
  //PTTDX_STOCKINFO = ^TTDX_STOCKINFO;
  TTDX_STOCKINFO = packed record    //��ʼ������ 29�ֽ�
     code :array[0..5] of char;
     rate :word;                    //ʵʱ�̿��еĳɽ�����ȥ�ĳ�����1��=n�ɣ�
     Name :array[0..7] of char;     //4������
     W1, W2 :Word;
     PriceMag :byte;                //�۸�ת��ģʽ 10��n�η�
     YClose  :single;
     W3, W4  :Word;
  end;
  PTTDX_STOCKINFO = ^TTDX_STOCKINFO;


  TF10Data = record                 //F10����
      Title :array [0..31] of char;
      tmp1 :array [ 0..31] of byte;
      FilePath  :array [0..9] of char;  //$40
      tmp2  :array [0..5] of byte;
      tmp3  :array [0..$3F] of byte;
      Offset  :integer;                 //$90
      length  :integer;                 //$94
   end;

   TF10Rcd  = record
      Data  :TF10Data;
      index: integer;
   end;
   PTF10Rcd = ^TF10Rcd;



  TTDX_PK_ADD = packed record
      tmp9E   :byte;
      tmp9F   :single;
      tmpA3, tmpA7, tmpAB :single;
      tmpAF   :word;
  end;
  //�̿�����
  //pTTDX_PKDAT = ^TTDX_PKDAT;     //size=
  TTDX_PKBASE = packed record
      MarketMode  :byte;   //�г�
      code  :array[0..5] of char;
      tmp7  :byte;
      DealCount  :word;   //�ɽ�����
      tmpA  :word;
      YClose  :Single;   //�����̼�
      Open    :Single;   //���̼�
      High    :single;
      Low     :Single;
      Close   :Single;   //�ּ�
      LastDealTime  :longword;
      tmp24  :Single;
      Volume  :longword;  //�ɽ���
      LastVolume  :longword; //���һ�ʵ��ӳɽ���
      Amount  :Single;     //���
      Inside, OutSide  :longword;
      tmp3C   : single;
      tmp40   : single;//��Ӯ�ʣ�
      Buyp    : array[1..5] of Single;	 //��������    $3C+8
      Buyv    : array[1..5] of LongWord;	   //��Ӧ�������۵��������   $50+8
      Sellp   : array[1..5] of Single;	 //���������
      Sellv   : array[1..5] of LongWord;	   //��Ӧ��������۵��������
      tmp94   :word;
      tmp96   :Longword;
      tmp9A   :LongWord;
      //DatEx   :TTDX_PK_ADD;
  end;
  PTTDX_PKBASE =^TTDX_PKBASE;

  TTDX_PKDAT = packed record
     D: TTDX_PKBASE;
     DEx  :TTDX_PK_ADD;
  end;
  PTTDX_PKDAT =^TTDX_PKDAT;


  TTDX_REALPK_ADD = packed record
     tmp9E    :array[1..5] of longword;
     tmpB2    :array[1..5] of longword;
     tmpC6    :array[1..5] of Single;
     tmpDA    :array[1..5] of longword;
  end;

  //ʵʱ�̿�����
  TTDX_REALPKDAT = packed record
     PK :TTDX_PKBASE;
     DatEx  :TTDX_REALPK_ADD;
     tmpEE, tmpF2  :Single;
     tmpF6, tmpFA  :longword;
  end;

  //�ڻ�
  TTDX_FUTURES_PK  = packed record   //Size=$12C
     Code :array[0..7] of char;      //����
     tmp8 :word;
     tmpA :longword;
     YClose,                     //�����̼�
     Open,                       //���̼�
     High,                       //��߼�
     Low,                        //��ͼ�
     Close :single;              //��ǰ��
     InSide  :longword;          //����
     OutSide  :longword;
     Volume  :longword;          //���� $2A
     tmp2E  :longword;           //=1
     Amount  :single;             //���
     tmp36  :longword;
     tmp3A  :longword;
     tmp3E  :longword;            //=0
     ChiCang  :longword;          //�ֲ�
     Buyp    : array[1..5] of Single;	 //��������
     Buyv    : array[1..5] of LongWord;	   //��Ӧ�������۵��������
     Sellp   : array[1..5] of Single;	 //���������
     Sellv   : array[1..5] of LongWord;	   //��Ӧ��������۵��������
     
     {tmp96, tmp9A, tmp9E, tmpA2,
     tmpA6, tmpAA, tmpAE, tmpB2 :longword;
      tmpB6, tmpBA, tmpBE, tmpC2,
     tmpC6, tmpCA, tmpCE, tmpD2, tmpD6, tmpDA, tmpDE, tmpE2,
     tmpE6, tmpEA, tmpEE, tmpF2, tmpF6, tmpFA, tmpFE, tmp102,
     tmp106, tmp10A, tmp10E, tmp112, tmp116, tmp11A, tmp11E, tmp122,
     tmp126 :longword;
     tmp12A :word; }
     tmp96  :array[0..$12C-$96-1] of byte;

  end;
  PTTDX_FUTURES_PK =^TTDX_FUTURES_PK;

  TTDX_Futures_DAYInfo  = packed record   //size=$20
     DAY  :longword;//  20100920��ʽ
     Open, High, Low, Close :Single;     //���� ��� ��� ����
     ChiCang  :longword; //�ֲ�
     Volume :longword;  //�ɽ�
     settlement :single; //����
  end;
  PTTDX_Futures_DAYInfo =^TTDX_Futures_DAYInfo;

  //��K������
  TTDX_DAYInfo = packed record
      DAY   :longword;    //�ڴ�����Ϊtmp1C
      Open  :Single;      //����
      High  :Single;      //���
      Low   :Single;      //���
      Close :Single;      //��
      Amount:Single;     //���
      Volume  :longword;//�ɽ���
      UpCount :word;
      DownCount :word;
  end;
  PTTDX_DAYInfo =^ TTDX_DAYInfo;
  

  //�ֱ���ʷ�ɽ�����
  TTDX_DEALInfo = packed record
      Min   :word;   //h *60 + Min
      value  :longword;   //�۸�*1000
      Volume  :longword;  //�ɽ���
      DealCount  :Integer;  //�ɽ�����
      SellOrBuy  :word; //Sell=1 buy=0
  end;
  PTTDX_DEALInfo =^TTDX_DEALInfo;

  TTDX_Futures_DEALInfo = packed record
      Min   :word;   //h *60 + Min
      value  :longword;   //�۸�*1000
      Volume  :longword;  //����
      DealCount  :Integer;  //����
      DealType  :word; //
  end;
  PTTDX_Futures_DEALInfo =^TTDX_Futures_DEALInfo;

  TTDX_MIN = packed record  //size=$1A ��ʱͼ
      Min  :word;
      Close  :single;
      Arg   :single;     //����
      Volume  :integer;  //�ɽ���
      tmpE  :longword;
      tmp12 :longword;
      tmp16 :single;
  end;
  PTTDX_MIN = ^TTDX_MIN;

  TTDX_FUTURES_MIN  = packed record  //Size=$1A
      Min  :word;
      Close  :single;
      Arg   :single;     //����
      Volume  :integer;  //�ɽ���
      tmpE  :longword;
      tmp12 :longword;
      ChiCang :longword;
  end;
  PTTDX_FUTURES_MIN =^TTDX_FUTURES_MIN;

  
  TCallBackStockInfo = packed record   //�ص����ݴ�������ʱ�ṩ��Ϣ
      Code  :array[0..5] of char;
      Name  :array[0..7] of char;
      Market  :Word;
   end;


   //========================== Dll ģʽʹ��
   TTdxDllShareData = packed record
      stockinfo :TCallBackStockInfo;
      start :integer;
      count :integer;
      buf :array[0..256*256-1] of char;
   end;
   PTTdxDllShareData = ^TTdxDllShareData;

   TWM_TDX_DEPACKDATA = record
      Msg: Cardinal;
      TDX_MSG :longint;
      Data  :PTTdxDllShareData;
      Result  :longint;
   end;

   TWM_TDX_NOTIFYEVENT  = record
      Msg: Cardinal;
      EventCode :longint;
      TDXManager  :longint;
      Result  :longint;
   end;




//----------------------------------

   TTdxDataHeader = packed record
      CheckSum  :longword; //
      EncodeMode  :byte;
      tmp :array[0..4] of byte;
      MsgID :word;      //��Ϣ����
      Size  :word;     //���ζ�ȡ�����ݰ�����
      DePackSize :word;   //��ѹ��Ĵ�С
   end;

   TTdxSendHeader = packed record
      CheckSum  :byte; //$0C
      tmp   :array[0..4] of byte;
      Size  :word;
      Size2 :word;
      //..����2���ֽھ��Ƿ��͵���ϢID
   end;

   TTdxData = record
      Len :word;
      buf :array[0..256*256+SizeOf(TTdxDataHeader)-1] of char;
   end;
   pTTdxData  =^ TTdxData;

   TTdxDepackData = record
      Head  :TTdxDataHeader;
      buf :array[0..256*256-1] of char;
   end;



   //�¼�����

   {$IFDEF _IS_NOT_DELPHI_}

   TOnReadTDXStockDataEvent = procedure(Const pData: pTTdxData)of object; stdcall;
   TRNotifyEvent = procedure (Sender: TObject) of object; stdcall;
   TOnAfterReadDataEvent        = procedure (Msg: TTDX_MSG) of object; stdcall;
   //TOnDecodePacket    = procedure (Sender: TObject; Const MSG_ID: integer; Const pData: pTTdxData; pDeBuffer: PChar)of object; stdcall;
   TOnDecodePacket_PKDAT    = procedure (Msg: TTDX_MSG; data: array of TTDX_PKDAT; StockCount: integer)of object; stdcall;
   TOnDecodePacket_FUTURES_PKDAT    = procedure (data: array of TTDX_FUTURES_PK; StockCount: integer)of object;stdcall;
   TOnDecodePacket_REALPK   = procedure (data: TTDX_REALPKDAT) of object; stdcall;
   TOnDecodePacket_DAYS    = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_DAYInfo; start, daysCount: integer)of object; stdcall;
   TOnDecodePacket_FUTURES_DAYS    = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_DAYInfo; start, daysCount: integer)of object; stdcall;
   TOnDecodePacket_DEALS    = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_DEALINFO; start, Count: integer)of object; stdcall;
   TOnDecodePacket_FUTURES_DEALS    = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_DEALINFO; start, Count: integer)of object; stdcall;
   TOnDecodePacket_MINS     = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_MIN; start, Count: integer) of object; stdcall;
   TOnDecodePacket_FUTURES_MINS     = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_MIN; Count: integer) of object; stdcall;
   TOnDecodePacket_INITMARKET    = procedure (data: array of TTDX_STOCKINFO; Market: byte; Count: integer)of object; stdcall;
   TErrorMessageEvent = procedure(Const ErrMsg: string; Const ErrCode: integer; var boStopUnPacket: boolean)of object; stdcall;
   {$ELSE}
   TOnReadTDXStockDataEvent = procedure(Const pData: pTTdxData)of object;
   TRNotifyEvent = procedure (Sender: TObject) of object;
   TOnAfterReadDataEvent        = procedure (Msg: TTDX_MSG) of object;
   //TOnAfterReadDataEvent        = procedure (lastMsg: TTDX_MSG) of object;
   //TOnDecodePacket    = procedure (Sender: TObject; Const MSG_ID: integer; Const pData: pTTdxData; pDeBuffer: PChar)of object; stdcall;
   TOnDecodepacket_F10      = procedure (Msg: TTDX_MSG; data: array of TF10Rcd; count: integer) of object;
   TOnDecodePacket_F10TXT   = procedure (Msg: TTDX_MSG; memory: TMemoryStream) of object;
   TOnDecodePacket_PKDAT    = procedure (Msg: TTDX_MSG; data: array of TTDX_PKDAT; StockCount: integer)of object;
   TOnDecodePacket_FUTURES_PKDAT    = procedure (data: array of TTDX_FUTURES_PK; StockCount: integer)of object;
   TOnDecodePacket_REALPK   = procedure (data: TTDX_REALPKDAT) of object;
   TOnDecodePacket_DAYS    = procedure (Msg: TTDX_MSG; data: array of TTDX_DAYInfo; start, daysCount: integer)of object;
   TOnDecodePacket_FUTURES_DAYS    = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_DAYInfo; start, daysCount: integer)of object;
   TOnDecodePacket_DEALS    = procedure (Msg: TTDX_MSG; data: array of TTDX_DEALINFO; start, Count: integer)of object;
   TOnDecodePacket_FUTURES_DEALS    = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_DEALINFO; start, Count: integer)of object;
   TOnDecodePacket_MINS     = procedure (Msg: TTDX_MSG; data: array of TTDX_MIN; start, Count: integer) of object;
   TOnDecodePacket_FUTURES_MINS     = procedure (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_MIN; Count: integer) of object;
   TOnDecodePacket_INITMARKET    = procedure (data: array of TTDX_STOCKINFO; Market: byte; Count: integer)of object;
   TErrorMessageEvent = procedure(Const ErrMsg: string; Const ErrCode: integer; var boStopUnPacket: boolean)of object;
   {$ENDIF}


implementation

end.
