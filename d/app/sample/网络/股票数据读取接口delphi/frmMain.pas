unit frmMain;
//Download by http://www.codefans.net
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TDXGrobal, ComCtrls, ExtCtrls;

type
{
******************************************
����ΪDelphi������ݽṹ����ص��ú�������
ʹ�������������Եģ�ֻҪת�����Լ����Ե���Ӧ��ʽ�Ϳ�����
Ŀǰ�� RSRStock.dll �У��ṩ�����¼�������������
   DLLVER, R_Open, R_Close, R_Connect, R_DisConnect, R_InitMarketData, 
   R_GetPK, R_GetTestRealPK, R_GetKDays, R_GetDeals, R_GetMins,
   R_GetMarket, R_GetMarketByStockCode, R_GetMarketByStockName,
   R_GetStockName, R_GetStockCode
���Ƕ�ʹ�õ��� stdcall �Ĳ������ݸ�ʽ
******************************************
}

  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    StaticText1: TStaticText;
    Button8: TButton;
    Button7: TButton;
    Button6: TButton;
    Button5: TButton;
    Button3: TButton;
    Button2: TButton;
    Button4: TButton;
    Button1: TButton;
    ComboBox1: TComboBox;
    Button9: TButton;
    RG: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure RGClick(Sender: TObject);
  private
    { Private declarations }
    procedure  WM_TDX_DEPACKDATA(var Msg : TWM_TDX_DEPACKDATA); message WM_TDX_DEPACKDATA;
    procedure  WM_TDX_NOTIFYEVENT(var Msg : TWM_TDX_NOTIFYEVENT); message WM_TDX_NOTIFYEVENT;
  public
    { Public declarations }
    procedure  OnConnect;stdcall;
    procedure  OnDisConnect; Stdcall;
    procedure OnGetFuturesPK(data: array of TTDX_FUTURES_PK; StockCount: integer); stdcall;
    procedure OnGetFuturesDeals (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_DEALINFO; start, Count: integer); stdcall;
    procedure OnGetFuturesMins (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_MIN; Count: integer); stdcall;
    procedure OnGetFuturesKDays (StockInfo: TCallBackStockInfo; data: array of TTDX_FUTURES_DAYInfo; start, daysCount: integer); stdcall;
    procedure GetAllPK;

  end;



var
  Form1: TForm1;
  DLL :THandle;
  TDX :longword;

{
�������ݽ������(ʹ�ö��������ݹ����߳�)
����
Handle  = �����ߴ��� Handle ����������ڻ�����ݺ���������ڷ�����Ϣ
RegKey  = ע���ַ���������ʱֱ��ʹ�ÿ�ֵ
����ֵ
���������ݽ�������ľ������Ҫ���þ�����б��棬�Ա�����������ݲ���
}
  R_Open  :function(Handle: THandle; RegKey: PChar): longword; stdcall;

{
�ͷ����ݽ������
����
TDXManager = ��Ҫ�ͷŵ�����ľ��
}
  R_Close :procedure(TDXManager: longword); stdcall;
{
���ӵ����������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
ServerAddr = �����������ַ��������IP������
Port       = �������˿� 7709
����ֵ
True   �ɹ�����
False  ʧ��
}
  R_Connect :function   (TDXManager: longword; ServerAddr: PChar; port:integer=7709):LongBool; stdcall;
{
�Ͽ��������������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
}
  R_DisConnect  :procedure (TDXManager: longword); stdcall;
{
��ʼ���г�����  ������µ�֤ȯ������֤ȯ���Ƶ����ݵı�
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
Market 0=���� 1=�Ϻ�
}
  R_InitMarketData  :procedure  (TDXManager: longword; Market: integer); stdcall;
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
  R_GetPK :procedure  (TDXManager: longword; StkCode  :PChar; StkName :PChar); stdcall;

{
�����Ƿ���ʵʱ���ݱ仯����
�����ñȽ�Ƶ��������������ͱ����󣬲����Ƿ����µĽ������ݻ��̿ڱ仯������У��򷵻����ݣ�û�У��򲻷�������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StkCode = ֤ȯ����
Market  = �г����
Time    = ���һ�ν��յ����̿����ݽṹ TTDX_PKBASE.LastDealTime ��ֵ����=0����һ���᷵�ص�ǰ�����̿�����

}
   R_GetTestRealPK : procedure(TDXManager: longword; StkCode: PChar; market, Time: integer);  stdcall;

{
������������K������
����
TDXManager = ʹ�� R_Open ���������ݽ���������صľ��
StkCode = ֤ȯ����
Market  = �г����
startcount  = ��ʼ�������������ӵ�ǰ���½����������Ƶ����֣���=0������½����տ�ʼ
count   = ��ȡ����K������
}
   R_GetKDays :procedure(TDXManager: longword; StkCode: PChar; market, startcount, count: integer); stdcall;//�����K��

{
���������÷ֱʳɽ�����
����
startcount  = ������һ�ʽ��������ƵĿ�ʼ����
count       = ��Ҫ��ȡ�ı���
}
   R_GetDeals :procedure (TDXManager: longword; StkCode: PChar; market, startcount, count: integer); stdcall;//�ֱʳɽ�

{
���������÷�ʱ�ɽ�����
����
start   = ��ʼ��������һ��ȡ0�����ص�ǰ���з�ʱ����
}
   R_GetMins  :procedure (TDXManager: longword; StkCode: PChar; market, start: integer); stdcall;//��ʱͼ

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
   R_GetMarket :function   (StkCode  :PChar; StkName :PChar): integer; stdcall;
   R_GetMarketByStockCode :function  (StkCode  :PChar): integer; stdcall;
   R_GetMarketByStockName :function  (StkName  :PChar): integer; stdcall;
   R_GetStockName :function  (StkCode :PChar; Market: integer): PChar; stdcall;
   R_GetStockCode :function  (StkName :PChar): PChar; stdcall;



   R_Get_QH_KDays :procedure  (TDXManager: longword; StkCode :PChar; startcount, count: integer); stdcall;
   S_Get_QH_KDays :procedure (TDXManager: longword; CallBack  :TOnDecodePacket_FUTURES_DAYS); stdcall;
   R_Get_QH_TestRealPK  :procedure (TDXManager: longword; StkCode  :PChar); stdcall;
   S_Get_QH_TestRealPK  :procedure (TDXManager: longword; CallBack :TOnDecodePacket_FUTURES_PKDAT); stdcall;
   R_Get_QH_Mins  :procedure  (TDXManager: longword; StkCode  :PChar); stdcall;
   S_Get_QH_Mins  :procedure  (TDXManager: longword; CallBack :TOnDecodePacket_FUTURES_MINS); stdcall;
   R_Get_QH_Deals :procedure  (TDXManager: longword; StkCode :PChar; startcount, count: integer); stdcall;
   S_Get_QH_Deals :procedure  (TDXManager: longword; CallBack  :TOnDecodePacket_FUTURES_DEALS); stdcall;

   S_Connected  :procedure (TDXManager: longword; CallBack :TRNotifyEvent); stdcall;
   S_DisConnected  :procedure (TDXManager: longword; CallBack :TRNotifyEvent); stdcall;
{
�����������汾��
����ֵ   =����������İ汾��
}
  GetDLLVER :function ():PChar; stdcall;

  boMarketInit  :array[0..1] of Boolean; //�Ƿ��ѳ�ʼ���ı�־


  PKCount :integer;
  InitDatas :array of TCallBackStockInfo;
  BoQH  :Boolean;  //�Ƿ����ڻ�����

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

   if FileExists ('˵��.txt') then
      Memo1.Lines.LoadFromFile('˵��.txt');
end;

procedure TForm1.Button1Click(Sender: TObject);
var Host: string; Port: integer;
begin
   Port := 7709;
   Case ComboBox1.ItemIndex of
      0: Host := '218.18.103.38'; //��������1
      1: Host := '61.51.17.231';  //���ű�����ͨ1
      2:
      begin
         Host := '121.12.171.71';
         Port := 7721;
      end;
   end;
   if not R_Connect (TDX, PChar (Host), Port) then
      ShowMessage ('Connect Fail.')
   else begin
      BoQH  := Port = 7721;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   if not BoQH then begin
   R_InitMarketData (TDX, 0);  //��ó�ʼ���г�����
   R_InitMarketData (TDX, 1);
   end else begin
   end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   if not BoQH then
      R_GetPK (TDX, PChar (Edit1.Text), PChar (Edit2.Text))
   else
      R_Get_QH_TestRealPK (TDX, PChar (Edit1.Text));
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   if DLL <> 0 then begin
      if TDX <> 0 then
         R_Close (TDX);
      FreeLibrary (DLL);
   end;
end;

procedure TForm1.OnConnect;
begin
   Button1.Enabled  := False;
   Button2.Enabled := True;
   Button3.Enabled := True;
   Button4.Enabled  := True;
   Button5.Enabled  := True;
   Button6.Enabled  := True;
   Button7.Enabled  := True;
   Button8.Enabled  := True;
   Memo1.Lines.Clear;
end;

procedure TForm1.OnDisConnect;
begin

   Button2.Enabled  := False;
   Button3.Enabled  := False;
   Button4.Enabled  := False;
   Button5.Enabled  := False;
   Button6.Enabled  := False;
   Button7.Enabled  := False;
   Button8.Enabled  := False;
   Button1.Enabled  := True;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
   R_DisConnect(TDX);
end;

procedure TForm1.WM_TDX_DEPACKDATA(var Msg: TWM_TDX_DEPACKDATA);
var
   i, k, n  :integer;
   p  :PTTDX_STOCKINFO;  //TDX_MSG_INITDATA ������Ӧ�����ݽṹ
   p2 :PTTDX_PKDAT;      //TDX_MSG_GETPK    ������Ӧ�����ݽṹ
   p3 :PTTDX_DAYInfo;
   p4 :PTTDX_MIN;
   p5 :PTTDX_DEALInfo;
   p6 :PTTDX_FUTURES_PK;
   fstr, str, stkcode, stkname  :string;
begin
   //ShowMessage (Format ('WM_TDX_DEPACKDATA =>TDX_MSG:%X LParam:%P',[msg.TDX_MSG, msg.Data]));
   Case Msg.TDX_MSG of
      TDX_MSG_INITDATA:
      begin

         p  := @msg.Data^.buf;
         boMarketInit[msg.Data.stockinfo.Market] := True;
         memo1.Lines.BeginUpdate;
         Case msg.Data.stockinfo.Market of
            0: Memo1.Lines.Add('���ڳ�ʼ�����ݣ�');
            1: Memo1.Lines.Add('�Ϻ���ʼ�����ݣ�');
         end;
         n  := length (InitDatas);
         SetLength (InitDatas, n + msg.data.count);
         Memo1.Lines.Add('================================');
         for i  := 0 to msg.data.count - 1 do begin
            fstr  := Format('%%.0%df', [p.PriceMag]);
            stkcode := p.code;
            stkname := p.Name;

            str := Format ('%s %s '+fstr,[stkcode, stkName, p.YClose]);
            Memo1.Lines.Add(str);

            Move (PChar (stkcode)^, InitDatas[n+i].Code, 6);
            Move (PChar (stkname)^, InitDatas[n+i].Name, 8);

            p := Pointer (Integer(p) + SizeOf (TTDX_STOCKINFO));
         end;
         Memo1.Lines.EndUpdate;
         Memo1.Lines.Add('=========================================');

         //if boMarketInit[0] and boMarketInit[1] then

      end;
      TDX_MSG_GETPK:
      begin
         p2  := @msg.Data^.buf;
         memo1.Lines.BeginUpdate;
         for i  := 0 to msg.data.count - 1 do begin
               Memo1.Lines.Add('֤ȯ���룺'+p2.D.code + ' ' + DateTimeToStr (NOW));
               Memo1.Lines.Add('==========================================');
               str  := Format('����:%.02f ����:%.02f ���:%.02f ���:%.02f �ּ�:%.02f',
                  [

                  p2.D.Yclose,
                  p2.D.Open,
                  p2.D.High,
                  p2.D.Low,
                  p2.D.Close
                  ]);
               Memo1.Lines.Add(str);

               str  := Format ('�ɽ���:%d ����:%d ����:%d',
                  [
                  p2.D.Volume,
                  p2.D.Inside,
                  p2.D.Outside
                  ]);
               Memo1.Lines.Add(str);

               Memo1.Lines.Add('--------------------');

               for k := 5 downto 1 do begin
                  Memo1.Lines.Add(Format('��%d�� %.02f  %d',[k, p2.D.Sellp[k], p2.D.Sellv[k]]));
               end;
               Memo1.Lines.Add('--------------------');
               for k := 1 to 5 do begin
                  Memo1.Lines.Add(Format('��%d�� %.02f  %d',[k, p2.D.buyp[k], p2.D.buyv[k]]));
               end;
               Memo1.Lines.Add('');
               Inc (PKCount);
               StatusBar1.Panels[0].Text  := Format ('(%d) %s',[PKCount, p2.D.code]);
               Application.ProcessMessages;

               p2 := Pointer (Integer(p2) + SizeOf (TTDX_PKDAT));
         end;

         memo1.Lines.EndUpdate;
         Memo1.Lines.Add('-------------------------');
      end;

      TDX_MSG_GET_FUTURES:
      begin
         p6  := @msg.Data^.buf;
         memo1.Lines.BeginUpdate;
         for i  := 0 to msg.data.count - 1 do begin
               Memo1.Lines.Add('֤ȯ���룺'+p6.Code + ' ' + DateTimeToStr (NOW));
               Memo1.Lines.Add('==========================================');
               str  := Format('����:%.02f ����:%.02f ���:%.02f ���:%.02f �ּ�:%.02f',
                  [

                  p6.Yclose,
                  p6.Open,
                  p6.High,
                  p6.Low,
                  p6.Close
                  ]);
               Memo1.Lines.Add(str);

               str  := Format ('�ɽ���:%d ����:%d ����:%d',
                  [
                  p6.Volume,
                  p6.Inside,
                  p6.Outside
                  ]);
               Memo1.Lines.Add(str);

               Memo1.Lines.Add('--------------------');

               for k := 5 downto 1 do begin
                  Memo1.Lines.Add(Format('��%d�� %.02f  %d',[k, p6.Sellp[k], p6.Sellv[k]]));
               end;
               Memo1.Lines.Add('--------------------');
               for k := 1 to 5 do begin
                  Memo1.Lines.Add(Format('��%d�� %.02f  %d',[k, p6.buyp[k], p6.buyv[k]]));
               end;
               Memo1.Lines.Add('');
               Inc (PKCount);
               StatusBar1.Panels[0].Text  := Format ('(%d) %s',[PKCount, p6.code]);
               Application.ProcessMessages;

               p6 := Pointer (Integer(p6) + SizeOf (TTDX_FUTURES_PK));
         end;

         memo1.Lines.EndUpdate;
         Memo1.Lines.Add('-------------------------');
      end;

      TDX_MSG_GET_K_DAY:
      begin
         p3  := @msg.Data^.buf;
         memo1.Lines.BeginUpdate;
         Memo1.Lines.Add('֤ȯ���룺'+msg.Data.stockinfo.code + ' ' + DateTimeToStr (NOW));
         Memo1.Lines.Add('==========================================');
         for i  := 0 to msg.data.count - 1 do begin

            Str := Format ('%d Open:%.02f Close:%.02f High:%.02f Low:%.02f',[
              p3.DAY, p3.Open, p3.Close, p3.High, p3.Low]);
            Memo1.Lines.Add(str);
            p3 := Pointer (Integer(p3) + SizeOf (TTDX_DAYInfo));
         end;
         memo1.Lines.EndUpdate;
         Memo1.Lines.Add('-------------------------');
      end;

      TDX_MSG_GET_MINS:
      begin
        p4  := @msg.Data^.buf;
        memo1.Lines.BeginUpdate;
         Memo1.Lines.Add('֤ȯ���룺'+msg.Data.stockinfo.code + ' ' + DateTimeToStr (NOW));
         Memo1.Lines.Add('==========================================');
         for i  := 0 to msg.data.count - 1 do begin

            Str := Format ('Close:%.02f Volume:%d',[
              p4.Close, p4.Volume]);
            Memo1.Lines.Add(str);
            p4 := Pointer (Integer(p4) + SizeOf (TTDX_MIN));
         end;
         memo1.Lines.EndUpdate;
         Memo1.Lines.Add('-------------------------');
      end;

      TDX_MSG_GET_DEALS:
      begin
         p5  := @msg.Data^.buf;
        memo1.Lines.BeginUpdate;
         Memo1.Lines.Add('֤ȯ���룺'+msg.Data.stockinfo.code + ' ' + DateTimeToStr (NOW));
         Memo1.Lines.Add('==========================================');
         for i  := 0 to msg.data.count - 1 do begin

            Str := Format ('%.02d:%.02d Close:%.02f Volume:%d',[
              p5.Min Div 60, p5.Min mod 60, p5.value/1000, p5.Volume]);
            Memo1.Lines.Add(str);
            p5 := Pointer (Integer(p5) + SizeOf (TTDX_DEALInfo));
         end;
         memo1.Lines.EndUpdate;
         Memo1.Lines.Add('-------------------------');
      end;
   end;
end;

procedure TForm1.WM_TDX_NOTIFYEVENT(var Msg: TWM_TDX_NOTIFYEVENT);
begin
   //ShowMessage (Format ('WM_TDX_NOTIFYEVENT =>WParam:%X LParam:%X',[msg.EventCode, msg.TDXManager]));
   Case msg.EventCode of
      TNE_CONNECTED :OnConnect;
      TNE_DISCONNECTED  :OnDisConnect;
   end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
   if not BoQH then
      R_GetKDays (TDX, PChar (Edit1.Text), R_GetMarket(PChar(Edit1.Text), PChar (Edit2.Text)), 0, 280)
   else
      R_Get_QH_KDays (TDX, PChar (Edit1.Text), 0, 280);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
   if not BoQH then
      R_GetMins (TDX, PChar (Edit1.Text),  R_GetMarket(PChar(Edit1.Text), PChar (Edit2.Text)), 0)
   else
      R_Get_QH_Mins (TDX, PChar (Edit1.Text));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
   if not BoQH then
      R_GetDeals (TDX, PChar (Edit1.Text),  R_GetMarket(PChar(Edit1.Text), PChar (Edit2.Text)), 0, 5000)
   else
      R_Get_QH_Deals (TDX, PChar (Edit1.Text), 0, 180);
end;

procedure TForm1.GetAllPK;
var i: integer;
begin
   if not BoQH then
      for i  := Low (InitDatas) to High (InitDatas) do
        R_GetPK (TDX, InitDatas[i].Code, InitDatas[i].Name); 
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
   PKCount  := 0;
   GetAllPK;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
   if DLL <> 0 then begin
      FreeLibrary (DLL);
      DLL := 0;
   end;
   DLL  := LoadLibrary ('RSRStock.dll');
   if DLL <> 0 then begin
      GetDLLVER := GetProcAddress (DLL, 'DLLVER');
      if not Assigned (GetDLLVER) then
         ShowMessage ('No Function DLLVER.')
      else
         Caption  := Caption + ' RSRStock.dll Ver:' + StrPas (GetDLLVER());

      R_Open  := GetProcAddress (DLL, 'R_Open');
      if not Assigned (R_Open) then
         ShowMessage ('No Function R_Open.')
      else begin
         if RG.ItemIndex = 0 then
            TDX  := R_Open (Handle, nil)
         else begin
            //��ע�ᴰ�ڣ�ʹ�ûص�����ģʽ
            TDX := R_Open (0, nil);
            S_Connected := GetProcAddress (DLL, 'S_Connected');
            if Assigned (S_Connected) then
               //ע�������¼��ص�����
               S_Connected (TDX, OnConnect);
            S_DisConnected  := GetProcAddress (DLL, 'S_DisConnected');
            if Assigned (S_DisConnected) then
               S_DisConnected (TDX, OnDisConnect);
            S_Get_QH_TestRealPK := GetProcAddress (DLL, 'S_Get_QH_TestRealPK');
            if Assigned (S_Get_QH_TestRealPK) then
               S_Get_QH_TestRealPK (TDX, OnGetFuturesPK);
            S_Get_QH_KDays  := GetProcAddress (DLL, 'S_Get_QH_KDays');
            if Assigned (S_Get_QH_KDays) then
               S_Get_QH_KDays (TDX, OnGetFuturesKDays);
            S_Get_QH_Mins  := GetProcAddress (DLL, 'S_Get_QH_Mins');
            if Assigned (S_Get_QH_Mins) then
               S_Get_QH_Mins (TDX, OnGetFuturesMins);
            S_Get_QH_Deals  := GetProcAddress (DLL, 'S_Get_QH_Deals');
            if Assigned (S_Get_QH_Deals) then
               S_Get_QH_Deals (TDX, OnGetFuturesDeals);

         end;
      end;

      R_Close := GetProcAddress (DLL, 'R_Close');
      if not Assigned (R_Close) then
         ShowMessage ('No Function R_Close.');

      R_Connect := GetProcAddress (DLL, 'R_Connect');
      if not Assigned (R_Connect) then
         ShowMessage ('No Function R_Connect.');

      R_DisConnect := GetProcAddress (DLL, 'R_DisConnect');
      if not Assigned (R_DisConnect) then
         ShowMessage ('No Function R_DisConnect.');

      R_InitMarketData  := GetProcAddress (DLL, 'R_InitMarketData');
      if not Assigned (R_InitMarketData) then
         ShowMessage ('No Function R_InitMarketData.');

      R_GetPK  := GetProcAddress (DLL, 'R_GetPK');
      if not Assigned (R_GetPK) then
         ShowMessage ('No Function R_GetPK.');
      R_GetMarket := GetProcAddress (DLL, 'R_GetMarket');
      if not Assigned (R_GetMarket) then
         ShowMessage ('No Function R_GetMarket.');

      R_GetTestRealPK := GetProcAddress (DLL, 'R_GetTestRealPK');
      if not Assigned (R_GetTestRealPK) then
         ShowMessage ('No Function R_GetTestRealPK.');

      R_GetKDays := GetProcAddress (DLL, 'R_GetKDays');
      if not Assigned (R_GetKDays) then
         ShowMessage ('No Function R_GetKDays.');

      R_GetDeals := GetProcAddress (DLL, 'R_GetDeals');
      if not Assigned (R_GetDeals) then
         ShowMessage ('No Function R_GetDeals.');

      R_GetMins := GetProcAddress (DLL, 'R_GetMins');
      if not Assigned (R_GetMins) then
         ShowMessage ('No Function R_GetMins.');

      R_GetMarketByStockCode := GetProcAddress (DLL, 'R_GetMarketByStockCode');
      if not Assigned (R_GetMarketByStockCode) then
         ShowMessage ('No Function R_GetMarketByStockCode.');

      R_GetMarketByStockName := GetProcAddress (DLL, 'R_GetMarketByStockName');
      if not Assigned (R_GetMarketByStockName) then
         ShowMessage ('No Function R_GetMarketByStockName.');

      R_GetStockName := GetProcAddress (DLL, 'R_GetStockName');
      if not Assigned (R_GetStockName) then
         ShowMessage ('No Function R_GetStockName.');

      R_GetStockCode := GetProcAddress (DLL, 'R_GetStockCode');
      if not Assigned (R_GetStockCode) then
         ShowMessage ('No Function R_GetStockCode.');


      R_Get_QH_TestRealPK := GetProcAddress (DLL, 'R_Get_QH_TestRealPK');
      if not Assigned (R_Get_QH_TestRealPK) then
         ShowMessage ('No Function R_Get_QH_TestRealPK.');

      R_Get_QH_KDays  := GetProcAddress (DLL, 'R_Get_QH_KDays');
      if not Assigned (R_Get_QH_KDays) then
         ShowMessage ('No Function R_Get_QH_KDays.');

      R_Get_QH_Mins  := GetProcAddress (DLL, 'R_Get_QH_Mins');
      if not Assigned (R_Get_QH_Mins) then
         ShowMessage ('No Function R_Get_QH_Mins.');

      R_Get_QH_Deals  := GetProcAddress (DLL, 'R_Get_QH_Deals');
      if not Assigned (R_Get_QH_Deals) then
         ShowMessage ('No Function R_Get_QH_Deals.');
   end;
end;

procedure TForm1.OnGetFuturesPK(data: array of TTDX_FUTURES_PK;
  StockCount: integer);
  var i: integer;
      str :string;
      code  :string;
begin
   for i  := 0 to StockCount -1 do begin
      code  := data[i].Code;
      Delete (code, 1, 1);
      Memo1.Lines.Add(Format ('Code: %s %s', [code, TimeToStr(NOW)]));
      Memo1.Lines.Add('---------------');
      str := (Format ('YClose:%.02f Open:%.02f High:%.02f Low:%.02f Close:%.02f', [// InSide:%d OutSide:%d Volume:%d', [
        data[i].YClose, data[i].Open,
        data[i].High, data[i].Low, data[i].Close
        ]));
      Memo1.Lines.Add(str);
      //Memo1.Lines.Add()
   end;
end;

procedure TForm1.RGClick(Sender: TObject);
begin
   Case TRadioGroup (Sender).ItemIndex of
      0:
      begin
         Edit1.Text := '999999';
         Edit2.Text := '';
      end;
      1:
      begin
         Edit1.Text := 'IF1011';
         Edit2.Text := '';
      end;
   end;
end;

procedure TForm1.OnGetFuturesDeals(StockInfo: TCallBackStockInfo;
  data: array of TTDX_FUTURES_DEALINFO; start, Count: integer);
  var i: integer;
      wHour, wMin: word;
begin
   for i  := 0 to count -1 do begin
      wHour := data[i].Min div 60;
      wMin  := data[i].Min mod 60;
      Memo1.Lines.Add(Format ('ʱ��:%.02d:%.02d �۸�:%.02f ����:%d ����:%d ����:%d',[
            wHour, wMin,
            data[i].value/1000,
            data[i].Volume,
            data[i].DealCount,
            data[i].DealType]));
   end;
end;

procedure TForm1.OnGetFuturesMins(StockInfo: TCallBackStockInfo;
  data: array of TTDX_FUTURES_MIN; Count: integer);
  var i: integer;
      wHour, wMin: word;
begin
   for i  := 0 to count -1 do begin
      wHour := data[i].Min div 60;
      wMin  := data[i].Min mod 60;
      Memo1.Lines.Add(Format ('ʱ��:%.02d:%.02d �۸�:%.02f ����:%.02f ����:%d �ֲ�:%d',[
            wHour, wMin,
            data[i].Close,
            data[i].Arg,
            data[i].Volume,
            data[i].ChiCang]));
   end;
end;

procedure TForm1.OnGetFuturesKDays(StockInfo: TCallBackStockInfo;
  data: array of TTDX_FUTURES_DAYInfo; start, daysCount: integer);
var i: integer;
      wHour, wMin: word;
begin
   for i  := 0 to dayscount -1 do begin

      Memo1.Lines.Add(Format ('ʱ��:%d ��:%.02f ��:%.02f ��:%.02f ��:%.02f ��:%d �ֲ�:%d ����:%.02f',[
            data[i].DAY,
            data[i].Open,
            data[i].High,
            data[i].Low,
            data[i].Close,
            data[i].Volume,
            data[i].ChiCang,
            data[i].settlement]));
   end;
end;

end.
