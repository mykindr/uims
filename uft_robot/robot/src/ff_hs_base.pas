unit ff_hs_base;

{
//ff_300m_ex for ���˻�һ���µ�

//
}
interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DateUtils,
  Dialogs, uFutuDataTypes, uFutuMessageInterface, uFutuSdkInterface, fm_main, s_lib_pas_unit,
  do_beep_thread;

const
  HSFUSDKDLL = 'HsFutuSDK.DLL';


type
  ////////////////////////�̳лص��ӿ�//////////////////////////////////
  TMyFuCallBack = class(IFuCallBack)
  public
        //��ѯ
    function QueryInterface(const iid: PChar; ppv: Pointer): Integer; override; stdcall;

        //���ýӿڣ����ü�����һ
    function AddRef(): Integer; override; stdcall;

        //�ͷŽӿڣ����ü�����һ������Ϊ0ʱ�ͷŽӿڵ�ʵ�ֶ���
    function Release(): Integer; override; stdcall;

 //����״̬�ĸı�
    procedure OnConnStateNotify(lpInst: Pointer; iType: Integer; iRet: Integer;
      const szNotifyTime: PChar;
      const szMsg: PChar); override; stdcall;

 //��½Ӧ����Ϣ
    procedure OnRspLogin(lpInst: Pointer; lpMsg: IFuMessage); override; stdcall;

 //�ǳ�����
    procedure OnRspLogout(lpInst: Pointer; lpMsg: IFuMessage); override; stdcall;

        //����\�˶�������߻ر��Ľ��
    procedure OnRspSubResult(lpInst: Pointer; sType: REGType;
      aAction: REGAction; iResult: Integer;
      const lpParam: PChar; const szMsg: PChar); override; stdcall;

 //ҵ����յ�ҵ��Ӧ����Ϣ
    procedure OnReceivedBiz(lpInst: Pointer; lpAnsData: IFuMessage; iRet: Integer; iKeyID: Integer); override; stdcall;

 //���յ������г�����
    procedure OnRspMarketInfo(lpInst: Pointer; const lpData: LPCMarketInfo; rAction: REGAction); override; stdcall;

 //���յ�����г�����
    procedure OnRspArgMaketInfo(lpInst: Pointer; const lpData: LPCArgMarketInfo; rAction: REGAction); override; stdcall;

        //���յ�ί�з�����Ϣ
    procedure OnRecvOrderInfo(lpInst: Pointer; const lpInfo: LPCOrderRspInfo); override; stdcall;

 //���յ������ɽ�����
    procedure OnRecvOrderRealInfo(lpInst: Pointer; const lpInfo: LPCRealRspInfo); override; stdcall;

 //���߸�����Ϣ
    procedure OnRspOnlineMsg(lpInst: Pointer; szUsrID: PChar; szMessage: PChar); override; stdcall;
  end;
  /////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////SDK�����ӿ�////////////////////////////////////////
  { /**
    * ����һ���µ���Ϣ
    *@param iMsgType ��Ϣ����,��ο���Ч����Ϣ���Ͷ���
    *return ��NULL��ʾһ����Ч����Ϣ,NULL��ʾ�����ڴ�ʧ��
    [�̰߳�ȫ]
   */}
function NewFuMessage(iMsgType: Integer = -1; iMsgMode: Integer = -1): IFuMessage; stdcall; external HSFUSDKDLL;

  {/**
    * �����µ�ϵͳ���Ӷ���
    *@param lpReserved ��������,V1�汾������ΪNULL
    *@return ����ӿڶ���ָ��(���Ե������ڵĺ���ʵ��)
    [�̰߳�ȫ]
    */}
function NewFuCommObj(lpReserved: Pointer = nil): Pointer; stdcall;
external HSFUSDKDLL name 'NewFuCommObj';

  {/**
    * ��ȡ�汾��
    @return �汾��,ʮ����������,����0x10000000,��ʾ�汾Ϊ1.0.0.0
    [�̰߳�ȫ]
  */}
function GetSDKVersion(): Integer; stdcall; external HSFUSDKDLL;
  /////////////////////////////////////////SDK�����ӿ�////////////////////////////////////////

const
  m_ma_max_index = 11; //for 12 :0..11

type
 //Ϊ������ͳһ��4�ֽڶ���,���������ݶ��������
{$A4}
  // ��������
  LP_s_k_line_data = ^s_k_line_data;
  s_k_line_data = record
    i_date: Cardinal;
    i_open: Cardinal;
    i_high: Cardinal;
    i_low: Cardinal;
    i_close: Cardinal;
    f_amount: Single;
    i_vol: Cardinal;
    i_pre_close: Cardinal;
  end;

  LP_s_k_line_ma_rsi = ^s_k_line_ma_rsi;
  s_k_line_ma_rsi = record
    ai_ma: array[0..m_ma_max_index] of Cardinal;
    ai_rsi: array[0..5] of Cardinal;
  end;


  LP_s_fc_data = ^s_fc_data;

  s_fc_data = record
    pc_username: PChar;
    pc_xxx_name: PChar;
    pc_fcpwd: PChar;

    i_VOL: Integer;
    i_long_max: Integer;
    i_short_max: Integer;

    i_got_it_mark: Integer;
    i_short_mark: Integer;
    i_rights_balance: Integer;

    f_rights_balance: Single;
    f_short_price: Single;
    f_business_price: Single;

  end;

  LP_s_vol_data = ^s_vol_data;

  s_vol_data = record
    tm_0: TDateTime;
    i_business_amount: Integer;
    i_VOL: Integer;
  end;

const
  m_i_max_chg_kline_in_mem = 18888;

  //for F9
  m_bsk_ask_long = 1;
  //for F10
  m_bsk_bid_long = 2;
  //for F11
  m_bsk_bid_short = 3;
  //for F12
  m_bsk_ask_short = 4;

  m_bsk_clear_long = 5;
  m_bsk_clear_short = 6;

  m_mairu = '1';
  m_maichu = '2';
  m_kaicang = '1';
  m_pingcang = '2';
  m_jiaoge = '3';
  m_pingjin = '4';

  m_i_long = 1;
  m_i_short = 2;

  m_k_line_file_name = 'sh600328.day';
  m_USER_NAME = 'XXXXXXX';
  m_USER_PWD = 'XXXXXXX';

  m_ff_main_ini = '../conf/ff_main.ini';
  m_ff_rsi_ini = '../conf/ff_rsi.ini';
  m_ff_local_ini = '../conf/ff_local.ini';
  m_ff_ma120_ini = '../conf/ff_ma_bb.ini';
  m_ff_bb100_ini = '../conf/ff_bb_100.ini';
  m_ff_m30_short_ini = '../conf/ff_m30_short.ini';
  m_ff_m30_long_ini = '../conf/ff_m30_long.ini';
  m_ff_short_1_ini = '../conf/ff_short_1.ini';
  m_ff_action_ini = '../conf/ff_action.ini';

var
  i_show_string_grid: Integer = 0;
  i_do_ff_qty_loop: Integer = 0;

  i_open_price: Integer = 0;
  i_open_vol: Integer = 0;
  i_open_vol_wk: Integer = 0;

  c_open_price: array[0..88] of Char;
  c_open_price_0: array[0..88] of Char;
  c_open_price_1: array[0..88] of Char;

  //for vol ,up power
  i_chk_power_vol_set: Integer = 5000;

  i_chk_power_vol_wk: Integer = 5000;

  i_up_count_ex: Integer = 0;
  i_down_count_ex: Integer = 0;
  i_up_vol_sum: Integer = 0;
  i_down_vol_sum: Integer = 0;


  //for vol display
  i_vol_start: Integer = 0;
  i_vol_reset: Integer = 0;
  i_vol_stop: Integer = 0;

  i_vol_0: Integer = 0;

  tdt_vol_0: TDateTime;
  i_vol_1: Integer = 0;

  tdt_vol_1: TDateTime;


  as_vol_data: array[0..88] of s_vol_data;

  i_clr_long_1_mark: Integer = 0;
  i_clr_short_1_mark: Integer = 0;

  i_clr_long_to_001_mark: Integer = 0;
  i_clr_short_to_001_mark: Integer = 0;

  //for stop
  i_stp_long: Integer = 0;
  i_stp_short: Integer = 0;

  i_act_stp_long: Integer = 0;
  i_act_stp_short: Integer = 0;

  i_set_stp_long: Integer = 0;
  i_set_stp_short: Integer = 0;

  i_set_stp_long_wk: Integer = 0;
  i_set_stp_short_wk: Integer = 0;

  i_act_stp_long_mark: Integer = 0;
  i_act_stp_short_mark: Integer = 0;

  i_stp_delta: Integer = 3;




  i_lock_long: Integer = 0;
  i_lock_short: Integer = 0;

  i_cut_lock_long: Integer = 0;
  i_cut_lock_short: Integer = 0;

  i_set_lock_long: Integer = 0;
  i_set_lock_short: Integer = 0;

  i_set_lock_long_wk: Integer = 0;
  i_set_lock_short_wk: Integer = 0;

  i_cut_lock_long_mark: Integer = 0;
  i_cut_lock_short_mark: Integer = 0;

  i_delta: Integer = 12;

  i_open_delta: Integer = 12;
  i_close_delta: Integer = 12;


  i_only_1: Integer = 0;
  i_fc_count: Integer = 0;
  i_fc_wk_index: Integer = 0;
  i_fc_wk_index_bak: Integer = 88;
  as_fc_data: array[0..88] of s_fc_data;

  c_error_no: array[0..88] of Char;
  c_error_info: array[0..888] of Char;

  pc_open_long_time: PChar = nil;
  pc_open_short_time: PChar = nil;
  pc_close_long_time: PChar = nil;
  pc_close_short_time: PChar = nil;

  //<0 for disable
  //=0 for enable ,just wait to do it
  //>0 for had did
  i_open_long_timer: Integer = -8;
  i_open_short_timer: Integer = -8;
  i_close_long_timer: Integer = -8;
  i_close_short_timer: Integer = -8;

var
  i_lock_for_main_loop: Integer = 0;

  s_edit_text_1: string = '    ';
  s_edit_text_2: string = '    ';

  s_caption_1: string = '    ';
  s_caption_2: string = '    ';
  s_caption_3: string = '    ';
  s_caption_4: string = '    ';
  s_caption_5: string = '    ';
  s_caption_6: string = '    ';
  s_caption_7: string = '    ';
  s_caption_8: string = '    ';
  s_caption_9: string = '    ';
  s_caption_10: string = '    ';
  s_caption_11: string = '    ';
  s_caption_12: string = '    ';
  s_caption_13: string = '    ';
  s_caption_14: string = '    ';
  s_caption_15: string = '    ';
  s_caption_16: string = '    ';

  s_caption_vol: string = '    ';
  s_caption_long_stp: string = '    ';
  s_caption_short_stp: string = '    ';
  s_caption_status: string = '    ';

var
  i_line_no_001: Integer;
  i_line_no_002: Integer;
  i_line_no_003: Integer;
  i_line_no_004: Integer;
  i_line_no_005: Integer;
  i_line_no_006: Integer;
  i_line_no_007: Integer;
  i_line_no_008: Integer;

  i_loop_count_001: Integer = 0;


var
  ai_ma_set: array[0..11] of Integer = (5, 10, 20, 30, 50, 60, 120, 200, 250, 600, 1200, 2400);
  ai_rsi_set: array[0..5] of Integer = (6, 12, 24, 9, 18, 36);

  m_lpComm: IHsFutuComm;
  m_lpCallBack: TMyFuCallBack;

  i_comm_ok: Integer = 0;

  i_ff_get_qty_88: Integer = 0;
  i_ff_get_qty_flag: Integer = 0;

  th_beep: Tth_beep;
  th_main_loop: Tth_beep;
  i_beeping: Integer = 0;

  g_hEvent: THANDLE;
  g_iType: Integer = 0;
  g_bStop: Boolean = False;

  tm_0: TDateTime;
  tm_1: TDateTime;
  tm_2: TDateTime;

  i_as_k_chg_init_flag: Integer = 0;
  i_s_k_chg_index_wk: Integer = 0;
  i_s_k_chg_index_wk_bak: Integer = 0;
  i_s_k_chg_index_load: Integer = 0;
  i_as_k_base_init_flag: Integer = 0;

  as_k_chg: array[0..m_i_max_chg_kline_in_mem] of s_k_line_data;
  as_k_chg_ma_rsi: array[0..m_i_max_chg_kline_in_mem] of s_k_line_ma_rsi;
  i_get_price_count: Integer = 0;

  iFileHandle: Integer;

  i_will_close_market: Integer = 0;

var
  i_no_trade: Integer = 0;

  i_only_short: Integer = 0;

  i_only_long: Integer = 0;
  i_mbm_only: Integer = 0;

  i_short_stop_index: Integer = 0;
  i_long_stop_index: Integer = 0;

  i_sum_short_mbm_count: Integer = 0;
  i_sum_long_mbm_count: Integer = 0;

  i_sum_4ma_short_mbm_count: Integer = 0;
  i_sum_4ma_long_mbm_count: Integer = 0;

  //for Big Money
  i_mbm_long: Integer = 888;
  i_mbm_short: Integer = 888;

  i_4ma_mbm_long: Integer = 888;
  i_4ma_mbm_short: Integer = 888;

  i_short_mbm_mark: Integer = 0;
  i_long_mbm_mark: Integer = 0;

  i_4ma_short_mbm_mark: Integer = 0;
  i_4ma_long_mbm_mark: Integer = 0;

  i_short_mbm_count: Integer = 0;
  i_long_mbm_count: Integer = 0;

  i_4ma_short_mbm_count: Integer = 0;
  i_4ma_long_mbm_count: Integer = 0;

  i_long_mbm_count_action_1: Integer = 0;
  i_short_mbm_count_action_1: Integer = 0;

  i_short_mbm_count_bak: Integer = 0;
  i_long_mbm_count_bak: Integer = 0;

  i_4ma_short_mbm_count_bak: Integer = 0;
  i_4ma_long_mbm_count_bak: Integer = 0;

  i_short_mbm_index: Integer = 0;
  i_long_mbm_index: Integer = 0;

  i_short_mbm_index_1: Integer = 0;
  i_long_mbm_index_1: Integer = 0;

  i_last_120ma250eq_index: Integer = 0;

  f_mbm_cut_long: Single = 0.0;
  f_mbm_stop_long: Single = 0.0;

  f_mbm_cut_short: Single = 0.0;
  f_mbm_stop_short: Single = 0.0;

  i_short_long_01: Integer = 888;
  i_short_long_date: Integer = 0;
  i_short_long_index: Integer = 888;

  i_wk_log: Integer = 8;
  i_debug_log: Integer = 0;
  i_tmp_log: Integer = -1;
  i_mbm_log: Integer = 28;

  i_make_log_ex: Integer = -1;

  i_make_ex_test: Integer = 0;
  i_make_k_only: Integer = 0;

  i_long_short_ctrl: Integer = 0;

  i_make_long_mark: Integer = 0;
  i_got_it_mark: Integer = 0;

  i_long_act_flag: Integer = -1;
  i_short_act_flag: Integer = -1;

  i_make_short_mark: Integer = 0;

  i_short_mark: Integer = 0;
  f_short_price: Single;
  f_business_price: Single;

  i_got_it_mark_ex: Integer = 0;
  i_short_mark_ex: Integer = 0;
  f_short_price_ex: Single;
  f_business_price_ex: Single;


  f_last_price_wk: Single = 0.0;
  f_last_price_1: Single = 0.0;
  f_price_A: Single = 0.0;

  f_buy_1: Single = 0.0;
  f_sale_1: Single = 0.0;

  i_BSK: Integer = 0;

  i_stop_check_count: Integer = 0;
  i_stop_short_count: Integer = 0;

  c_entrust_no: array[0..88] of Char;
  c_batch_no: array[0..88] of Char;

  c_rights_balance: array[0..88] of Char;
  i_rights_balance: Integer = 0;
  f_rights_balance: Single = 0.0;

  i_entrust_no_mark: Integer = 0;

var
  pc_username: PChar;
  pc_user_pwd: PChar;

  pc_what_wk: PChar;

  pc_IP: PChar;
  pc_BLS: PChar;
  pc_CLF: Pchar;
  pc_ENT: Pchar;

  i_rsi_A: Integer = 1800;
  i_rsi_B: Integer = 2800;
  i_rsi_C: Integer = 1800;

  i_rsi_AB: Integer = 6;
  i_rsi_BC: Integer = 6;
  i_rsi_IA_min: Integer = 8;
  i_rsi_IA_max: Integer = 18;

  f_rsi_stop: Single = 18.0;
  f_rsi_cut: Single = 12.0;

  f_rsi_stop_long: Single = 18.0;
  f_rsi_stop_short: Single = 18.0;

  f_rsi_cut_long: Single = 0.0;
  f_rsi_cut_short: Single = 0.0;

  f_rsi_add: Single = 8.0;
  i_F: Integer = 1;
  i_S: Integer = 1;
  i_T: Integer = 1;
  i_A: Integer = 1;

  i_M30: Integer = 30;
  i_M30_stop: Integer = 0;

  i_M120: Integer = 0;
  i_M120_stop: Integer = 0;

  i_BOX_Y: Integer = 8;

  i_get_S_mark: Integer = 0;
  i_get_T_mark: Integer = 0;
  i_short_S_mark: Integer = 0;
  i_short_T_mark: Integer = 0;

  i_w20_mark: Integer = 0;
  i_w20_A_index: Integer = 0;
  i_w20_B_index: Integer = 0;
  i_w20_C_index: Integer = 0;

  i_MA120_BB_mark: Integer = 0;
  i_MA120_BB_n: Integer = 0;
  i_MA120_BB_c: Integer = 0;
  i_MA120_BB_i: Integer = 0;

  i_BB_BOX_X: Integer = 8;
  i_BB_BOX_Y: Integer = 800;

  i_M30_short_mark: Integer = 0;
  i_M30_short_n: Integer = 0;
  i_M30_short_c: Integer = 0;
  i_M30_short_i: Integer = 0;

  i_M30_short_BOX_X: Integer = 8;
  i_M30_short_BOX_Y: Integer = 2800;



var
  i_BB_100_BOX_X: Integer = 8;
  i_BB_100_BOX_Y: Integer = 3800;
  i_BB_100_mark: Integer = 0;
  i_BB_100_n: Integer = 0;
  i_BB_100_c: Integer = 0;
  i_BB_100_i: Integer = 0;

  i_MA120_120_chg: Integer = 0;
  i_make_long: integer = 0;
  i_make_short: Integer = 0;

  i_short_1_mark: Integer = 0;
  i_short_250_mark: Integer = 0;
  i_short_30_mark: Integer = 0;
  i_short_120_mark: Integer = 0;

  i_pass3_short_120_mark: Integer = 0;

  i_pass_3_mark: Integer = 0;
  i_pass_3_mark_ex: Integer = 0;

  i_act_rsi: Integer = 10;
  i_act_m120: Integer = 10;
  i_act_bb_100: Integer = 10;
  i_act_short: Integer = 10;

  i_B_S_Flag: Integer = 0;
  i_B_S_Flag_10: Integer = 0;
  i_B_S_Flag_18: Integer = 0;

  i_B_Flag: Integer = 0;
  i_S_Flag: Integer = 0;

  i_short_pass3_mark: Integer = 0;

  i_ADD_FLOSS_MAX: Integer = 0;
  i_long_FLOSS_MAX: Integer = 0;
  i_short_FLOSS_MAX: Integer = 0;

var
  MAINFORM: TMAINFORM;

function ff_chk_power_vol(i: Integer): Integer;

function ff_set_caption(): Integer;

function ff_load_k_base(): Integer;

function ff_rsi_w20_init(): Boolean;

function FF_creat_comm_obj(): Boolean;
function FF_release_comm_obj(): Boolean;
function FF_comm_obj_init(): Boolean;
function FF_do_logout(pc_fund_account: PChar): Boolean;

function ff_make_ma_rsi_ex(ii: Integer): Integer;
function ff_make_ma_rsi(): Integer;
function ff_get_ma(i: Integer; j: Integer): Integer;
function ff_get_rsi(ii: Integer; jj: Integer): Integer;
function ff_get_max_ij_high(i: Integer; j: Integer): Integer;
function ff_get_min_ij_low(i: Integer; j: Integer): Integer;
function ff_get_max_ij_index(i: Integer; j: Integer): Integer;
function ff_get_min_ij_index(i: Integer; j: Integer): Integer;

function ff_check_rsi_w20(i: Integer): Integer;
function ff_check_rsi_w20_ex(i: Integer): Integer;
function ff_check_MA120_BB(i: Integer; i_ma_index: Integer): Integer;
function ff_check_MA120_BB_ex(i: Integer): Integer;

function ff_check_BB_100(i: Integer; i_ma_index: Integer): Integer;
function ff_check_BB_100_ex(i: Integer): Integer;

function ff_get_S_L_Mark(i: Integer): Integer;
function ff_get_BS_Mark(i: Integer): Integer;
function ff_get_long_mark_8(i: Integer): Integer;
function ff_get_ma600_mark(i: Integer): Integer;
function ff_get_ma600_mark_long(i: Integer): Integer;

function ff_check_M30_short(i: Integer): Integer;
function ff_check_M30_short_ex(i: Integer): Integer;



function ff_check_short_1(i: Integer): Integer;
function ff_check_short_1_ex(i: Integer): Integer;

function ff_check_short_250(i: Integer): Integer;
function ff_check_short_30(i: Integer): Integer;
function ff_check_short_120(i: Integer): Integer;
function ff_check_long_pass_3(i: Integer): Integer;
function ff_long_pass_3_ex(i: Integer): Integer;

function ff_make_long_MA30(i: Integer): Integer;
function ff_make_long_MA60(i: Integer): Integer;
function ff_make_long_MA250(i: Integer): Integer;

function ff_short_pass3_mark(i: Integer): Integer;
//function ff_pass3_short_250(i:Integer):Integer;
function ff_pass3_short_120(i: Integer): Integer;


function ff_make_mbm_long(i: Integer): Integer;
function ff_make_mbm_short(i: Integer): Integer;

function ff_4ma_make_mbm_long(i: Integer): Integer;
function ff_4ma_make_mbm_short(i: Integer): Integer;

function ff_main_wk_loop(): Integer;
function ff_get_qty(): Integer;
function ff_get_qty_ex(): Integer;

function ff_get_profit(): Integer;

function ff_cancel_entrust_no(): Integer;
function ff_entrust_no(pc_contract_code: PChar): Integer;
function ff_order_ex(
  pc_contract_code: PChar;
  pc_entrust_price: PChar;
  pc_entrust_amount: PChar;
  pc_entrust_bs: PChar;
  pc_direction: PChar): Integer;

function ff_passwd_chg(
  pc_account: PChar;
  pc_password_type: PChar;
  pc_old_password: PChar;
  pc_new_password: PChar): Integer;


function do_beep(): Boolean;
function ff_stop_do_beep(): Boolean;

function ff_do_main_loop(): Integer;


implementation

//��ʼ��ͨ�Ŷ���

function FF_creat_comm_obj(): Boolean;
var
  i, j, i_count, j_count, k_count: Integer;
  i_tmp, j_tmp, k_tmp: Integer;
  i_index, j_index, k_index: Integer;


  i_count_1, j_count_1, k_count_1: Integer;
  i_tmp_1, j_tmp_1, k_tmp_1: Integer;
  i_index_1, j_index_1, k_index_1: Integer;
  s_tmp_log: string;

begin
  Result := False;

  FF_load_allconf();
  ff_rsi_w20_init();
  ff_load_k_base();


  //only for test
  i_make_ex_test := 0;
  i_count := 0;
  j_count := 0;
  k_count := 0;

  i_count_1 := 0;
  j_count_1 := 0;
  k_count_1 := 0;

  //Assert(false,s_tmp_log);

  if i_make_ex_test > 0 then for j := 80 to i_s_k_chg_index_wk - 2 do
    begin

      f_last_price_wk := as_k_chg[j].i_close / 100;

      if (Round(as_k_chg[j].i_date / 10000) > Round(as_k_chg[j - 1].i_date / 10000)) then
      begin
        W_Log('MBM long sum', as_k_chg[j].i_date, i_mbm_log + 6, PChar('4MA OK! Count:' + IntToStr(i_sum_long_mbm_count) +
          '    short:  ' + IntToStr(i_sum_short_mbm_count) +
          '    long-short:  ' + IntToStr(i_sum_long_mbm_count - i_sum_short_mbm_count) +
          '    S-L:  ' + IntToStr(i_sum_short_mbm_count - i_sum_long_mbm_count)

          ));
        W_Log('MBM long 4ma sum', as_k_chg[j].i_date, i_mbm_log + 7, PChar('4MA OK! Count:' + IntToStr(i_sum_4ma_long_mbm_count) +
          '    short 4ma:  ' + IntToStr(i_sum_4ma_short_mbm_count) +
          '    4ma L-S:  ' + IntToStr(i_sum_4ma_long_mbm_count - i_sum_4ma_short_mbm_count)));
      end;


      ff_get_BS_Mark(j);

      ff_4ma_make_mbm_long(j);
      ff_4ma_make_mbm_short(j);

      i_tmp_1 := ff_make_mbm_long(j);

      if (i_tmp_1 = 0) then
      begin
        i_tmp_1 := as_k_chg[j].i_close;
        j_tmp_1 := ff_get_max_ij_high(j, j + 240);
        k_tmp_1 := ff_get_min_ij_low(j, j + 240);
        j_index_1 := ff_get_max_ij_index(j, j + 240);
        k_index_1 := ff_get_min_ij_index(j, j + 240);

        if (i_tmp_1 - k_tmp_1 > 1600) or (j_tmp_1 - i_tmp_1 < 1000) then
        begin
          i_count_1 := i_count_1 + 1;
          W_Log('MBM long', as_k_chg[j].i_date, i_mbm_log + 1,
            PChar('Buy:' + IntToStr(i_tmp_1) + '-BAD-' + 'Cut Cut:' + IntToStr(k_tmp_1) + '  i:' + IntToStr(j_index_1 - k_index_1) + ' j:' + IntToStr(j_index_1 - j) + '  k:' + IntToStr(k_index_1 - j)));
        end
        else
        begin
          j_count_1 := j_count_1 + 1;
          W_Log('MBM long', as_k_chg[j].i_date, i_mbm_log + 1,
            PChar('Buy:' + IntToStr(i_tmp_1) + '-GOOD-' + 'Stop Stop:' + IntToStr(j_tmp_1) + '  i:' + IntToStr(j_index_1 - k_index_1) + ' j:' + IntToStr(j_index_1 - j) + '  k:' + IntToStr(k_index_1 - j)));
        end;

      end;

      i_tmp := ff_make_mbm_short(j);

      if (i_tmp = 0) then
      begin
        i_tmp := as_k_chg[j].i_close;
        j_tmp := ff_get_max_ij_high(j, j + 240);
        k_tmp := ff_get_min_ij_low(j, j + 240);
        j_index := ff_get_max_ij_index(j, j + 240);
        k_index := ff_get_min_ij_index(j, j + 240);

        if (j_tmp - i_tmp > 1600) or (i_tmp - k_tmp < 1000) then
      //if(i_tmp-k_tmp >1600 ) or (j_tmp-i_tmp<1000) then
        begin
          i_count := i_count + 1;
          W_Log('MBM short', as_k_chg[j].i_date, i_mbm_log,
            PChar('Buy:' + IntToStr(i_tmp) + '-BAD-' + 'Cut Cut:' + IntToStr(j_tmp) + '  i:' + IntToStr(j_index - k_index) + ' j:' + IntToStr(j_index - j) + '  k:' + IntToStr(k_index - j)));
        end
        else
        begin
          j_count := j_count + 1;
          W_Log('MBM short', as_k_chg[j].i_date, i_mbm_log,
            PChar('Buy:' + IntToStr(i_tmp) + '-GOOD-' + 'Stop Stop:' + IntToStr(k_tmp) + '  i:' + IntToStr(j_index - k_index) + ' j:' + IntToStr(j_index - j) + '  k:' + IntToStr(k_index - j)));
        end;

      end;


    //ff_short_pass3_mark(j);
    //ff_pass3_short_120(j);
    //ff_make_mbm_long(j);
    //ff_make_mbm_short(j);

    //ff_get_BS_Mark(j);
    //ff_make_long_MA30(j);
    //ff_make_long_MA250(j);

    //ff_check_short_1(j);
    //ff_check_short_1_ex(j);
    //ff_check_short_30(j);
    //ff_check_short_250(j);
    //ff_check_short_120(j);

    //ff_long_pass_3_ex(j);
    //ff_check_long_pass_3(j);

      if as_k_chg[j].i_date = 1131314 then
      begin
    //ff_make_mbm_short(j);
    //ff_short_pass3_mark(j);
    //ff_pass3_short_120(j);

    //ff_make_long_MA30(j);

    //ff_check_long_pass_3(j);
    //ff_check_short_250(j);
    //ff_check_long_pass_3(j);
    //ff_check_short_1(j);
    //ff_check_short_1_ex(j);
      end;
    //ff_check_M30_short(j);
    //ff_check_M30_short_ex(j);

    //ff_check_rsi_w20(j);
    //ff_check_rsi_w20_ex(j);

    //ff_check_MA120_BB(j,3);
    //ff_check_MA120_BB_ex(j);
    //ff_check_BB_100(j,3);
    //ff_check_BB_100_ex(j);
    end;

  if i_make_ex_test > 0 then W_Log('MBM long', 88888, i_mbm_log + 1, PChar('Stop:' + IntToStr(j_count_1) + '----------' + 'Cut:' + IntToStr(i_count_1)));
  if i_make_ex_test > 0 then W_Log('MBM short', 888, i_mbm_log, PChar('Stop:' + IntToStr(j_count) + '----------' + 'Cut:' + IntToStr(i_count)));

  //for test
  if i_make_ex_test > 0 then ExitProcess(888);
  //only for test End

  for j := 888 to i_s_k_chg_index_wk - 2 do
  begin
    //for short long lamp
    ff_get_BS_Mark(j);

    ff_4ma_make_mbm_long(j);
    ff_4ma_make_mbm_short(j);

    ff_make_mbm_long(j);
    ff_make_mbm_short(j);
  end;


   //����Ҫ:���һ�°汾�Ƿ����
  if HSFUSDK_VERSION <> GetSDKVersion() then
  begin
    //MessageBox(Self.Handle,'ͷ�ļ��汾����ļ��汾��ƥ��,�����ܵ��¼���������!','�汾����',MB_OK or MB_ICONWARNING);
    Exit;
  end;

   //��һ�� ����һ��ͨ�Ŷ���
  m_lpComm := NewFuCommObj(nil);
  if nil = m_lpComm then
  begin
    //Form1.AddLog('����ͨ�Ŷ���ʧ��');
    Exit;
  end;
   //Form1.AddLog('����ͨ�Ŷ���OK');
   //�����ص�����
  m_lpCallBack := TMyFuCallBack.Create;

  FF_comm_obj_init();

  //
  if (i_comm_ok > 0) then
  begin
    W_Log('create_thread', i_wk_log, i_wk_log, 'call do_beep!');
    do_beep();
  end;
end;

//�ͷ�ͨ�Ŷ���

function FF_release_comm_obj(): Boolean;
begin
  Result := False;
  if Assigned(m_lpComm) then
  begin
    //FileClose(iFileHandle);
    if i_beeping > 0 then ff_stop_do_beep();

    m_lpComm.SubscribeRequest(UnKnownType, CxlAll, 'ALLWWW');
    m_lpComm.DoLogout(pc_username);
    //�ر��Զ������߳�
    g_bStop := true;
    SetEvent(g_hEvent);
    Sleep(2000);
    WaitForSingleObject(th_beep.Handle, 10000);
    CloseHandle(th_beep.Handle);
    WaitForSingleObject(th_main_loop.Handle, 10000);
    CloseHandle(th_main_loop.Handle);

    //�ر�ͨ������
    m_lpComm.Stop();
    m_lpComm.Release();
    m_lpComm := nil;
    m_lpCallBack.Destroy;
  end;
end;

function FF_comm_obj_init(): Boolean;
var
  i_loop, iRet: Integer;
  //szServer:string;
  sLog: string;
begin
  Result := False;

   //����Ҫ:���һ�°汾�Ƿ����
  if HSFUSDK_VERSION <> GetSDKVersion() then
  begin
     //MessageBox(Self.Handle,'ͷ�ļ��汾����ļ��汾��ƥ��,�����ܵ��¼���������!','�汾����',MB_OK or MB_ICONWARNING);
    Exit;
  end;

   //szServer := '222.66.166.146:2800';
  pc_IP := FF_ffconf(m_ff_main_ini, 'Sever', 'IP');
  pc_BLS := FF_ffconf(m_ff_main_ini, 'Sever', 'BLS');
  pc_CLF := FF_ffconf(m_ff_main_ini, 'Sever', 'CLF');
  pc_ENT := FF_ffconf(m_ff_main_ini, 'Sever', 'ENT');

  pc_username := FF_ffconf(m_ff_local_ini, 'Main', 'FC');
  pc_user_pwd := FF_ffconf(m_ff_local_ini, 'Main', 'FCPWD');

   //sBiz:=
   //sDatF:=
   //sL:=
   //�������ò���
  m_lpComm.SetConfig('futu', 'server', pc_IP); //t2��������ַ
   //m_lpComm.SetConfig('futu','biz_license_str','31332263F984F45D4B07689AB3352E19'); //��Ȩҵ��֤�鴮
   //m_lpComm.SetConfig('futu','comm_license_file','fz_3rd.dat');//t2ͨ��֤��
   //m_lpComm.SetConfig('futu','entrust_type','L');//ί�з�ʽ

  m_lpComm.SetConfig('futu', 'biz_license_str', pc_BLS); //��Ȩҵ��֤�鴮
  m_lpComm.SetConfig('futu', 'comm_license_file', pc_CLF); //t2ͨ��֤��

  m_lpComm.SetConfig('futu', 'entrust_type', pc_ENT); //ί�з�ʽ

   //�ڶ��� ��ʼ���ӿڶ���
  iRet := m_lpComm.Init(m_lpCallBack);
  if 0 <> iRet then
  begin
     //sLog := '�ӿڳ�ʼ��ʧ��:'+m_lpComm.GetErrorMsg(iRet);
    Exit;
  end;

   //��ʼ���ɹ�
  sLog := '�ӿڳ�ʼ���ɹ�!';

  iRet := m_lpComm.Start(SERVICE_TYPE_TRADE);
  if 0 <> iRet then
  begin
    sLog := '������������ʧ��:' + m_lpComm.GetErrorMsg(iRet);
    W_Log('m_lpComm.Start', i_wk_log, i_wk_log, PChar(sLog));
    Exit;
  end;
   //Form1.AddLog('����ͨ�Ŷ���OK 999');
   //����ͨ������
  iRet := m_lpComm.Start(SERVICE_TYPE_QUOTE);
  if 0 <> iRet then
  begin
    sLog := '������������ʧ��:' + m_lpComm.GetErrorMsg(iRet);
    W_Log('m_lpComm.Start', i_wk_log, i_wk_log, PChar(sLog));
    Exit;
  end;
   //Form1.AddLog('����ͨ�Ŷ���OK 1000');
   //������ һ�в����ӵ�½��ʼ

  for i_loop := 0 to i_fc_count - 1 do
  begin
    if (as_fc_data[i_loop].pc_fcpwd = nil) then as_fc_data[i_loop].pc_fcpwd := pc_user_pwd;

    iRet := m_lpComm.DoLogin(as_fc_data[i_loop].pc_username, as_fc_data[i_loop].pc_fcpwd, 1);
    if iRet <> 0 then
    begin
      sLog := '��½ʧ��:' + IntToStr(iRet) + ':' + m_lpComm.GetErrorMsg(iRet);
      W_Log('DoLogin', i_wk_log, i_wk_log, PChar(sLog));
      ExitProcess(199);
    end;
    //Form1.AddLog('����ͨ�Ŷ���OK 1888');
  end;

  pc_username := as_fc_data[i_fc_wk_index].pc_username;

  s_caption_12 := pc_what_wk;

  //��������
  m_lpComm.SubscribeRequest(SingleCode, Subscription, pc_what_wk);
  m_lpComm.SubscribeRequest(RspReport, Subscription, pc_username);


  //for password chg
  //ff_passwd_chg(pc_username,'0',pc_user_pwd,'138688');

  i_comm_ok := 888;

  if (i_comm_ok = 0) then
  begin
    s_caption_3 := '�Ͽ�';
  end
  else
  begin
    s_caption_3 := '����';
  end;


end;



function FF_do_logout(pc_fund_account: PChar): Boolean;
var
  iRet: Integer;
begin
   //�ǳ�
  if Assigned(m_lpComm) then
  begin
    iRet := m_lpComm.DoLogout(pc_fund_account);
    if 0 <> iRet then
    begin
        //Form1.AddLog('�ǳ�ʧ��:'+m_lpComm.GetErrorMsg(iRet));
    end;
  end;

  Result := True;

end;




{ TMyFuCallBack }
 ////////////////////////////////////��Ϣ�ص�����ʵ��///////////////////////////////////////////////////

function TMyFuCallBack.QueryInterface(const iid: PChar; ppv: Pointer): Integer;
begin
  Result := 0;
end;

function TMyFuCallBack.AddRef(): Integer;
begin
  Result := 0;
end;

function TMyFuCallBack.Release(): Integer;
begin
  Result := 0;
end;

procedure TMyFuCallBack.OnConnStateNotify(lpInst: Pointer; iType: Integer; iRet: Integer; const szNotifyTime, szMsg: PChar);
begin
 //Form1.Addlog('����״̬�仯:'+szNotifyTime+'-> '+szMsg+':'+IntToStr(iType));
  if iRet = 0 then //���ӶϿ���
  begin
    i_comm_ok := 0;
    g_iType := iType;
    SetEvent(g_hEvent);
  end;
end;

procedure TMyFuCallBack.OnReceivedBiz(lpInst: Pointer; lpAnsData: IFuMessage; iRet: Integer; iKeyID: Integer);
begin
  //Form1.AddLog('�յ��첽Ӧ����Ϣ:type'+IntToStr(lpAnsData.GetMsgType()));
  //Form1.ShowFuMessage(lpAnsData);
end;

procedure TMyFuCallBack.OnRecvOrderInfo(lpInst: Pointer; const lpInfo: LPCOrderRspInfo);
begin
  //Form1.AddLog('�յ�ί�з�����Ϣ:type'+IntToStr(lpInfo.fund_account));
end;

procedure TMyFuCallBack.OnRecvOrderRealInfo(lpInst: Pointer; const lpInfo: LPCRealRspInfo);
var
  c_log: array[0..88] of char;
  s_tmp: string;
begin
  //Form1.AddLog('�յ��ɽ�������Ϣ:type'+IntToStr(lpInfo.fund_account));
  //entrust_bs: array[0..8] of Char;       //5 ������ʶ
  //entrust_direction: array[0..8] of Char;//6 ��ƽ��ʶ
  //business_price: Double;                //7 �ɽ��۸�
  //business_amount: Double;               //8 �ɽ�����

    //for i_got_it_mark,i_short_mark ,etc ,gobal var error
  Exit;

  FillChar(c_log, SizeOf(c_log), 0);

  StrCopy(c_log, lpInfo.entrust_bs);

  if c_log[0] = '2' then
  begin
    FillChar(c_log, SizeOf(c_log), 0);
    StrCopy(c_log, lpInfo.entrust_direction);

      //kaicang
    if c_log[0] = '1' then
    begin
      f_short_price := lpInfo.business_price;
      s_tmp := FloatToStrF(lpInfo.business_price, ffFixed, 8, 2);
      i_short_mark := i_short_mark + Round(lpInfo.business_amount);

      s_caption_9 := '��  ' + Trim(s_tmp);
      s_caption_11 := IntToStr(i_short_mark);

        //MAINFORM.Label9.Caption :='��  '+Trim(s_tmp);
        //MAINFORM.Label11.Caption :=IntToStr(i_short_mark);

      if (i_short_mark > (i_F + i_S - 1)) then i_short_S_mark := 888 else i_short_S_mark := 0;
      if (i_short_mark > (i_F + i_S + i_T - 1)) then i_short_T_mark := 888 else i_short_T_mark := 0;
    end;

      //pingcang
    if c_log[0] = '2' then
    begin
      f_short_price := lpInfo.business_price;
      s_tmp := FloatToStrF(lpInfo.business_price, ffFixed, 8, 2);
      i_got_it_mark := i_got_it_mark - Round(lpInfo.business_amount);

      s_caption_8 := '��  ' + Trim(s_tmp);
      s_caption_10 := IntToStr(i_got_it_mark);
        //MAINFORM.Label8.Caption :='��  '+Trim(s_tmp);
        //MAINFORM.Label10.Caption:=IntToStr(i_got_it_mark);

      if (i_got_it_mark > (i_F + i_S - 1)) then i_get_S_mark := 888 else i_get_S_mark := 0;
      if (i_got_it_mark > (i_F + i_S + i_T - 1)) then i_get_T_mark := 888 else i_get_T_mark := 0;
    end;

  end
  else if c_log[0] = '1' then
  begin
    FillChar(c_log, SizeOf(c_log), 0);
    StrCopy(c_log, lpInfo.entrust_direction);

      //kaicang
    if c_log[0] = '1' then
    begin
      f_business_price := lpInfo.business_price;
      s_tmp := FloatToStrF(lpInfo.business_price, ffFixed, 8, 2);
      i_got_it_mark := i_got_it_mark + Round(lpInfo.business_amount);

      s_caption_8 := '��  ' + Trim(s_tmp);
      s_caption_10 := IntToStr(i_got_it_mark);

        //MAINFORM.Label8.Caption :='��  '+Trim(s_tmp);
        //MAINFORM.Label10.Caption:=IntToStr(i_got_it_mark);

      if (i_got_it_mark > (i_F + i_S - 1)) then i_get_S_mark := 888 else i_get_S_mark := 0;
      if (i_got_it_mark > (i_F + i_S + i_T - 1)) then i_get_T_mark := 888 else i_get_T_mark := 0;
    end;

      //pingcang
    if c_log[0] = '2' then
    begin

      f_short_price := lpInfo.business_price;
      s_tmp := FloatToStrF(lpInfo.business_price, ffFixed, 8, 2);
      i_short_mark := i_short_mark - Round(lpInfo.business_amount);

      s_caption_9 := '��  ' + Trim(s_tmp);
      s_caption_11 := IntToStr(i_short_mark);

        //MAINFORM.Label9.Caption :='��  '+Trim(s_tmp);
        //MAINFORM.Label11.Caption :=IntToStr(i_short_mark);

      if (i_short_mark > (i_F + i_S - 1)) then i_short_S_mark := 888 else i_short_S_mark := 0;
      if (i_short_mark > (i_F + i_S + i_T - 1)) then i_short_T_mark := 888 else i_short_T_mark := 0;
    end;

  end;

    //frmMain2.CalcAll;
    //frmMain2.GRID.Repaint;

end;

procedure TMyFuCallBack.OnRspArgMaketInfo(lpInst: Pointer; const lpData: LPCArgMarketInfo; rAction: REGAction);
begin
  //Form1.AddLog('�յ����������Ϣ.��ϴ���:'+lpData.arbicontract_id);
end;

procedure TMyFuCallBack.OnRspLogin(lpInst: Pointer; lpMsg: IFuMessage);
begin
  //Form1.AddLog('�첽�յ���½Ӧ��:');
  //Form1.ShowFuMessage(lpMsg);
end;

procedure TMyFuCallBack.OnRspLogout(lpInst: Pointer; lpMsg: IFuMessage);
begin
  //Form1.AddLog('�첽�յ��ǳ�Ӧ��:');
  //Form1.ShowFuMessage(lpMsg);
end;

procedure TMyFuCallBack.OnRspMarketInfo(lpInst: Pointer; const lpData: LPCMarketInfo; rAction: REGAction);
var
 //iFileHandle : Integer;
  s_tmp: string;
  i_loop: Integer;
  i_tmp: Integer;
begin
 //cout<<"��������:("<<lpInfo->futu_exch_type<<":"<<lpInfo->contract_code<<")"<<lpInfo->futu_last_price<<"\t"<<lpInfo->sale_low_price<<"\t";
 //cout<<as_k_chg_ma_rsi[i_s_k_chg_index_wk-1].ai_rsi[0]<<"\t";
 //cout<<as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_ma[2]<<"\t"<<as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_rsi[0]<<"\t"<<i_s_k_chg_index_wk<<"\t"<<as_k_chg[i_s_k_chg_index_wk].i_date<<endl;
  {
  Form1.AddLog('�յ�������������:'+lpData.contract_code +'	' +
         FloatToStrF(lpData.futu_last_price,ffFixed,8,2) + '	MA30' +

         IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_ma[3]) + ' MA60' +
         IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_ma[5]) + ' RSI6' +

                IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk-1].ai_rsi[0]) + '	' +
                IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_rsi[0])                );
  }

  //if(i_lock_for_main_loop >0) Then Exit;

  s_tmp := FloatToStrF(lpData.futu_last_price, ffFixed, 8, 2) + '	MA30' +

  IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_ma[3]) + ' MA60' +
    IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_ma[5]) + ' RSI6' +
    IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_rsi[0]) + '	' +
    IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_rsi[0]);
  tm_1 := Now;

  if (lpData.futu_last_price < 10) then Exit;

  f_last_price_wk := lpData.futu_last_price;

  //20120622 add
  if (i_got_it_mark = 0) then i_long_FLOSS_MAX := 0;
  if (i_got_it_mark > 0) and
    (f_last_price_wk - f_business_price < -3) then
  begin
    if i_long_FLOSS_MAX < Round(f_business_price - f_last_price_wk) then
      i_long_FLOSS_MAX := Round(f_business_price - f_last_price_wk);
  end;

  if (i_short_mark = 0) then i_short_FLOSS_MAX := 0;
  if (i_short_mark > 0) and
    (f_last_price_wk - f_business_price > 3) then
  begin
    if i_short_FLOSS_MAX < Round(f_last_price_wk - f_business_price) then
      i_short_FLOSS_MAX := Round(f_last_price_wk - f_business_price);
  end;
  //20120622 add end

  if i_s_k_chg_index_wk > 8 then f_last_price_1 := as_k_chg[i_s_k_chg_index_wk - 1].i_close / 100
  else f_last_price_1 := f_last_price_wk;

  if (i_get_price_count < 1) or (i_get_price_count > m_i_max_chg_kline_in_mem - 8) then
  begin
    i_get_price_count := 0;
  end;

  if i_get_price_count = 0 then
  begin
    s_tmp := FormatDateTime('mmddhhnn', Now);
    as_k_chg[i_s_k_chg_index_wk].i_date := StrToInt(s_tmp);

    as_k_chg[i_s_k_chg_index_wk].i_open := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk].i_close := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk].i_high := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk].i_low := Round(lpData.futu_last_price * 100);

    tm_0 := Now;

    FillChar(as_vol_data, sizeof(as_vol_data), 0);

    for i_loop := 0 to 19 do
    begin
      as_vol_data[i_loop].tm_0 := Now;
      as_vol_data[i_loop].i_business_amount := Round(lpData.business_amount);
    end;

  end;

  //for vol display
  tm_2 := Now;

  if (i_vol_start = 888) and (i_vol_reset = 0) then
  begin
    i_vol_0 := Round(lpData.business_amount);
    i_vol_start := 999;
    tdt_vol_0 := Now;
  end;

  if (i_vol_start = 999) and (i_vol_reset = 0) then
  begin
    i_vol_1 := Round(lpData.business_amount) - i_vol_0;
    i_tmp := SecondsBetween(tdt_vol_0, tm_2);
    if (i_tmp < 59) then
    begin
      s_caption_vol := IntToStr(i_tmp) + ' : ' + IntToStr(Round((60 / (i_tmp + 1)) * i_vol_1));
    end
    else
    begin
      i_vol_0 := Round(lpData.business_amount);
      i_vol_start := 999;
      tdt_vol_0 := Now;
    end;
  end;

  for i_loop := 0 to 19 do
  begin
    if (SecondsBetween(as_vol_data[i_loop].tm_0, tm_2) > ((i_loop + 1) * 3 - 1)) then
    begin
      as_vol_data[i_loop].tm_0 := tm_2;
      as_vol_data[i_loop].i_vol := Round(lpData.business_amount) - as_vol_data[i_loop].i_business_amount;
      as_vol_data[i_loop].i_business_amount := Round(lpData.business_amount);
    end;
  end;

  if (i_vol_start = 0) and (i_vol_reset = 0) then
  begin
    s_caption_vol := IntToStr(as_vol_data[7].i_vol + as_vol_data[2].i_vol * 2 + as_vol_data[1].i_vol * 2 + as_vol_data[0].i_vol * 2);
  end;

  if i_as_k_chg_init_flag = 0 then
  begin
    FillChar(as_k_chg, SizeOf(as_k_chg), 0);
    FillChar(as_k_chg_ma_rsi, sizeof(as_k_chg_ma_rsi), 0);
    i_as_k_chg_init_flag := 888;
    i_s_k_chg_index_wk := 0;

    s_tmp := FormatDateTime('mmddhhnn', Now);

    as_k_chg[i_s_k_chg_index_wk].i_date := StrToInt(s_tmp);
    as_k_chg[i_s_k_chg_index_wk].i_open := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk].i_close := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk].i_high := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk].i_low := Round(lpData.futu_last_price * 100);

    tm_0 := Now;
  end;

  s_tmp := FormatDateTime('hhnn', Now);

  if (SecondsBetween(tm_0, tm_1) > 59) or
    ((SecondsBetween(tm_0, tm_1) > 50) and (i_will_close_market = 888)) then
  begin
  {
  Form1.AddLog('�յ�������������:'+lpData.contract_code +'	' +
         FloatToStrF(lpData.futu_last_price,ffFixed,8,2) + '	MA30' +
         IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_ma[3]) + ' MA60' +
         IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_ma[5]) + ' RSI6' +
                IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk-1].ai_rsi[0]) + '	' +
                IntToStr(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_rsi[0])   +' ' +
                IntTostr(i_got_it_mark) + ' ' +
                FloatToStrF(f_business_price,ffFixed,8,2)             );
  }

    as_k_chg[i_s_k_chg_index_wk].i_close := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk].i_pre_close := Round(lpData.business_amount);

    if as_k_chg[i_s_k_chg_index_wk].i_close > as_k_chg[i_s_k_chg_index_wk].i_high then
      as_k_chg[i_s_k_chg_index_wk].i_high := as_k_chg[i_s_k_chg_index_wk].i_close;
    if as_k_chg[i_s_k_chg_index_wk].i_close < as_k_chg[i_s_k_chg_index_wk].i_low then
      as_k_chg[i_s_k_chg_index_wk].i_low := as_k_chg[i_s_k_chg_index_wk].i_close;

    if i_s_k_chg_index_wk > i_s_k_chg_index_load then
      as_k_chg[i_s_k_chg_index_wk].i_vol := as_k_chg[i_s_k_chg_index_wk].i_pre_close - as_k_chg[i_s_k_chg_index_wk - 1].i_pre_close;

    s_tmp := FormatDateTime('mmddhhnn', Now);
    as_k_chg[i_s_k_chg_index_wk].i_date := StrToInt(s_tmp);

    s_tmp := FormatDateTime('hhnn', Now);
    if (s_tmp = '1514') then i_will_close_market := 888;

    s_tmp := FormatDateTime('nn', Now);

    tm_0 := Now;
    tm_1 := Now;

    iFileHandle := FileOpen(m_k_line_file_name, fmOpenWrite);
    if iFileHandle > 0 then
    begin

      if (as_k_chg[i_s_k_chg_index_wk].i_vol = 0) and (s_tmp = '15') then
        as_k_chg[i_s_k_chg_index_wk].i_vol := Round(lpData.business_amount);

      FileSeek(iFileHandle, 0, 2);
      if (as_k_chg[i_s_k_chg_index_wk].i_close < 100) or
        (as_k_chg[i_s_k_chg_index_wk].i_high < 100) or
        (as_k_chg[i_s_k_chg_index_wk].i_low < 100) or
        (as_k_chg[i_s_k_chg_index_wk].i_vol = 0) or
        (as_k_chg[i_s_k_chg_index_wk].i_open < 100) then
      begin
        FileClose(iFileHandle);
      end
      else
      begin
        FileWrite(iFileHandle, as_k_chg[i_s_k_chg_index_wk], SizeOf(s_k_line_data));
        FileClose(iFileHandle);
          //for FF_300k
          //try

          //frmMain2.StkDataFile.writeStkDataToM(1,@as_k_chg[i_s_k_chg_index_wk]);
          //except
          //  W_Log('try_except_0',1119,999,'StkDataFile.writeStkDataToM exception');
          //end;
      end;
    end;



    ff_make_ma_rsi_ex(i_s_k_chg_index_wk);

    i_s_k_chg_index_wk_bak := i_s_k_chg_index_wk;

    s_tmp := FormatDateTime('mmddhhnn', Now);
    as_k_chg[i_s_k_chg_index_wk + 1].i_date := StrToInt(s_tmp);

    if i_s_k_chg_index_wk > m_i_max_chg_kline_in_mem - 8 then
    begin
      FillChar(as_k_chg, SizeOf(as_k_chg), 0);
      FillChar(as_k_chg_ma_rsi, sizeof(as_k_chg_ma_rsi), 0);
      i_as_k_chg_init_flag := 888;
      i_s_k_chg_index_wk := 0;
    end;

    as_k_chg[i_s_k_chg_index_wk + 1].i_open := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk + 1].i_close := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk + 1].i_high := Round(lpData.futu_last_price * 100);
    as_k_chg[i_s_k_chg_index_wk + 1].i_low := Round(lpData.futu_last_price * 100);
      //try
      //frmMain2.StkDataFile.writeStkDataToM(0,@as_k_chg[i_s_k_chg_index_wk]);
      //except
      //  W_Log('try_except_1',11119,999,'StkDataFile.writeStkDataToM exception');
      //end;
      //frmMain2.CalcAll;
      //frmMain2.GRID.Repaint;

    i_s_k_chg_index_wk := i_s_k_chg_index_wk + 1;
    ff_make_ma_rsi_ex(i_s_k_chg_index_wk);
  end
  else
  begin
    as_k_chg[i_s_k_chg_index_wk].i_close := Round(lpData.futu_last_price * 100);
    ff_make_ma_rsi_ex(i_s_k_chg_index_wk);

    if as_k_chg[i_s_k_chg_index_wk].i_close > as_k_chg[i_s_k_chg_index_wk].i_high then
      as_k_chg[i_s_k_chg_index_wk].i_high := as_k_chg[i_s_k_chg_index_wk].i_close;
    if as_k_chg[i_s_k_chg_index_wk].i_close < as_k_chg[i_s_k_chg_index_wk].i_low then
      as_k_chg[i_s_k_chg_index_wk].i_low := as_k_chg[i_s_k_chg_index_wk].i_close;

   //if i_s_k_chg_index_wk > i_s_k_chg_index_load then
   //	as_k_chg[i_s_k_chg_index_wk].i_vol:= as_k_chg[i_s_k_chg_index_wk].i_pre_close-as_k_chg[i_s_k_chg_index_wk-1].i_pre_close;

      //try
      //  frmMain2.StkDataFile.writeStkDataToM(1,@as_k_chg[i_s_k_chg_index_wk]);
      //except
      //  W_Log('try_except_2',1119,999,'StkDataFile.writeStkDataToM exception');
      //end;


  end;

  if (i_long_mbm_count > 0) then
  begin
    //frmMain2.GRID_S002.Cells[0,0]:='L5    ' + IntToStr(i_long_mbm_count);
    //frmMain2.GRID_S002.Cells[1,0]:='L4    ' + IntToStr(i_4ma_long_mbm_count);
  end;

  if (i_short_mbm_count > 0) then
  begin
    //frmMain2.GRID_S002.Cells[0,0]:='S5    ' + IntToStr(i_short_mbm_count);
    //frmMain2.GRID_S002.Cells[1,0]:='S4    ' + IntToStr(i_4ma_short_mbm_count);
  end;


  //frmMain2.GRID_S002.Cells[0,1]:='RSI';
  //frmMain2.GRID_S002.Cells[1,1]:=FloatToStrF(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_rsi[0]/100,ffFixed,7,2);

  //MAINFORM.Label1.Caption:='��  '+FloatToStrF(lpData.sale_low_price,ffFixed,7,2);
  //MAINFORM.Label2.Caption:=IntToStr(lpData.sale_low_amount);

  //MAINFORM.Label5.Caption:='��  '+FloatToStrF(lpData.buy_high_price,ffFixed,7,2);
  //MAINFORM.Label6.Caption:=IntToStr(lpData.buy_high_amount);

  //MAINFORM.Label7.Caption:=pc_username;

  s_caption_1 := '��  ' + FloatToStrF(lpData.sale_low_price, ffFixed, 7, 2);
  s_caption_2 := IntToStr(lpData.sale_low_amount);

  s_caption_5 := '��  ' + FloatToStrF(lpData.buy_high_price, ffFixed, 7, 2);
  s_caption_6 := IntToStr(lpData.buy_high_amount);

  s_caption_7 := pc_username;

  f_buy_1 := lpData.buy_high_price;
  f_sale_1 := lpData.sale_low_price;

  //for
  if ((i_get_price_count mod 18) = 0) then
  begin
      //frmMain2.CalcAll;
      //frmMain2.GRID.Repaint;
      //frmMain2.GridSxxxRePaint;
  end;

  i_get_price_count := i_get_price_count + 1;

end;

procedure TMyFuCallBack.OnRspOnlineMsg(lpInst: Pointer; szUsrID, szMessage: PChar);
begin
  //Form1.AddLog('�յ�������Ϣ.');
end;

procedure TMyFuCallBack.OnRspSubResult(lpInst: Pointer; sType: REGType; aAction: REGAction; iResult: Integer; const lpParam, szMsg: PChar);
begin
  //Form1.AddLog('�յ����Ľ��Ӧ��.');
end;




//from cpp

function ff_get_rsi(ii: Integer; jj: Integer): Integer;
var
  n: Integer;
  i: Integer;
  j: Integer;
  sum1: Single;
  sum2: Single;
  AX1: Double;
  BX1: Double;
begin
  n := ai_rsi_set[jj];

  for i := 0 to ii do
  begin

    if (i < n + 8) then
    begin
      as_k_chg_ma_rsi[i].ai_rsi[jj] := 5000;
      Continue;
    end;

    sum1 := 0.0;
    sum2 := 0.0;

    for j := 0 to n - 1 do
    begin
      if (as_k_chg[i - j].i_close > as_k_chg[(i - j) - 1].i_close) then
        sum1 := sum1 + as_k_chg[i - j].i_close / 100 - as_k_chg[(i - j) - 1].i_close / 100
      else
        if (as_k_chg[i - j].i_close < as_k_chg[(i - j) - 1].i_close) then
          sum2 := sum2 + as_k_chg[(i - j) - 1].i_close / 100 - as_k_chg[i - j].i_close / 100;

    end;

    AX1 := sum1 / n;
    BX1 := sum2 / n;

    if (sum1 < 0.001) and (sum2 < 0.001) then
    begin
      Result := 0;
      as_k_chg_ma_rsi[i].ai_rsi[jj] := as_k_chg_ma_rsi[i - 1].ai_rsi[jj];
      Exit;
    end;

    BX1 := 10000.0 * 2 * (AX1 / (AX1 + BX1) / 3.0);

    as_k_chg_ma_rsi[i].ai_rsi[jj] := Round(as_k_chg_ma_rsi[i - 1].ai_rsi[jj] / 3) + Round(BX1);
    //as_k_chg_ma_rsi[i].ai_rsi[jj] :=Round(BX1);

  end;

  Result := 0;
end;



function ff_get_ma(i: Integer; j: Integer): Integer;
var
  k: Integer;
  f_tmp: Single;
begin
  f_tmp := 0.0;
  for k := i - ai_ma_set[j] + 1 to i do f_tmp := f_tmp + as_k_chg[k].i_close;
  as_k_chg_ma_rsi[i].ai_ma[j] := Round(f_tmp / ai_ma_set[j]);
  Result := 0;
end;


//from cpp

function ff_get_rsi_ex(i: Integer; jj: Integer): Integer;
var
  n: Integer;
  j: Integer;
  sum1: Single;
  sum2: Single;
  AX1: Double;
  BX1: Double;
begin
  n := ai_rsi_set[jj];
  Result := 0;

  if (i < 88) then
  begin
    as_k_chg_ma_rsi[i].ai_rsi[jj] := 5000;
    Exit;
  end;

  sum1 := 0.0;
  sum2 := 0.0;

  for j := 0 to n - 1 do
  begin
    if (as_k_chg[i - j].i_close > as_k_chg[(i - j) - 1].i_close) then
      sum1 := sum1 + as_k_chg[i - j].i_close / 100 - as_k_chg[(i - j) - 1].i_close / 100
    else
      if (as_k_chg[i - j].i_close < as_k_chg[(i - j) - 1].i_close) then
        sum2 := sum2 + as_k_chg[(i - j) - 1].i_close / 100 - as_k_chg[i - j].i_close / 100;

  end;

  AX1 := sum1 / n;
  BX1 := sum2 / n;

  if (sum1 < 0.001) and (sum2 < 0.001) then
  begin
    Result := 0;
    as_k_chg_ma_rsi[i].ai_rsi[jj] := as_k_chg_ma_rsi[i - 1].ai_rsi[jj];
    Exit;
  end;


  BX1 := 10000.0 * 2 * (AX1 / (AX1 + BX1) / 3.0);

  as_k_chg_ma_rsi[i].ai_rsi[jj] := Round(as_k_chg_ma_rsi[i - 1].ai_rsi[jj] / 3) + Round(BX1);

  Result := 0;
end;



function ff_get_max_ij_high(i: Integer; j: Integer): Integer;
var
  k: Integer;
  i_m: Integer;
begin
  i_m := as_k_chg[i].i_high;
  for k := i to j do if Integer(as_k_chg[k].i_high) > i_m then i_m := as_k_chg[k].i_high;
  Result := i_m;
end;

function ff_get_max_ij_index(i: Integer; j: Integer): Integer;
var
  k: Integer;
  i_m: Integer;
  i_index: Integer;
begin
  i_m := as_k_chg[i].i_high;
  i_index := i;
  for k := i to j do if Integer(as_k_chg[k].i_high) > i_m then
    begin
      i_m := as_k_chg[k].i_high;
      i_index := k;
    end;
  Result := i_index;
end;

function ff_get_min_ij_low(i: Integer; j: Integer): Integer;
var
  k: Integer;
  i_m: Integer;
begin
  i_m := as_k_chg[i].i_low;
  for k := i to j do if Integer(as_k_chg[k].i_low) < i_m then i_m := as_k_chg[k].i_low;
  Result := i_m;
end;

function ff_get_min_ij_index(i: Integer; j: Integer): Integer;
var
  k: Integer;
  i_m: Integer;
  i_index: Integer;
begin
  i_index := i;
  i_m := as_k_chg[i].i_low;
  for k := i to j do if Integer(as_k_chg[k].i_low) < i_m then
    begin
      i_m := as_k_chg[k].i_low;
      i_index := k;
    end;
  Result := i_index;
end;

function ff_make_ma_rsi_ex(ii: Integer): Integer;
var
  j: Integer;
begin
  for j := 0 to m_ma_max_index do if (ii > ai_ma_set[j] - 1) then ff_get_ma(ii, j);
  for j := 0 to 5 do ff_get_rsi_ex(ii, j);
  Result := 0;
end;


function ff_make_ma_rsi(): Integer;
var
  i: Integer;
  j: Integer;
begin

  for i := 0 to i_s_k_chg_index_wk do
  begin
    for j := 0 to m_ma_max_index do if (i > ai_ma_set[j] - 1) then ff_get_ma(i, j);
  end;

  i := i_s_k_chg_index_wk;

  for j := 0 to 5 do ff_get_rsi(i, j);

  Result := 0;
end;

function ff_check_rsi_w20(i: Integer): Integer;
var
  j: Integer;
  k: Integer;
begin

  Result := -1;
  if (i < 88) then Exit;

  if (i_act_rsi = 0) then Exit;

  if (i_w20_mark = 888) then Exit;

  if (as_k_chg_ma_rsi[i].ai_rsi[0] > 6000) or (as_k_chg_ma_rsi[i].ai_rsi[0] < 2100) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_rsi[0] < Cardinal(i_rsi_A)) or
    (as_k_chg_ma_rsi[i - 2].ai_rsi[0] < Cardinal(i_rsi_A)) or
    (as_k_chg_ma_rsi[i - 3].ai_rsi[0] < Cardinal(i_rsi_A)) then
  begin
    for j := 0 to i_rsi_AB do
      if as_k_chg_ma_rsi[i - j - 2].ai_rsi[0] > Cardinal(i_rsi_B) then
      begin
        for k := 0 to i_rsi_BC do
          if as_k_chg_ma_rsi[i - j - k - 2].ai_rsi[0] < Cardinal(i_rsi_C) then
          begin

            W_Log('W20', as_k_chg[i].i_date, i_wk_log, 'RSI W20!');

            Result := -2;
            i_w20_mark := 888;
            i_w20_C_index := i - j - k - 2;
            i_w20_B_index := i - j - 2;
            i_w20_A_index := i - 1;
            Exit;
          end;
      end;
  end;

  Result := -1;

end;

function ff_check_MA120_BB(i: Integer; i_ma_index: Integer): Integer;
var
  j: Integer;
  n: Integer;
  a: Integer;
  b: Integer;
  c: Integer;
begin

  Result := -1;

  if (i_act_m120 = 0) then exit;

  if (i < 888) then Exit;

  if (i - i_MA120_BB_mark > i_BB_BOX_X * 3) then i_MA120_BB_mark := 0;

  if (i_MA120_BB_mark > 888) then Exit;

  //ai_ma[6] for MA120
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6] - 100) then Exit;

  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[6] + 800) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[i_ma_index] < (as_k_chg_ma_rsi[i].ai_ma[6])) then Exit;

  n := ff_get_min_ij_index(i - i_BB_BOX_X - 2, i);

  c := ff_get_max_ij_index(i - 5 * i_BB_BOX_X, n);

  b := ff_get_min_ij_index(c - 8 * i_BB_BOX_X, c);

  a := ff_get_max_ij_index(b - 8 * i_BB_BOX_X, b);

  if (Integer(as_k_chg[a].i_high + 800) < ff_get_max_ij_high(a, n)) then Exit;

  //MA30 < MA120
  for j := a - i_BB_BOX_X * 2 to n - i_BB_BOX_X do
  begin
    if as_k_chg_ma_rsi[j].ai_ma[i_ma_index] > as_k_chg_ma_rsi[j].ai_ma[6] then Exit;
  end;

  if (c > (n - i_BB_BOX_X + 2)) then Exit;

  if as_k_chg[c].i_high > (as_k_chg[n].i_close + 1600) then Exit;

  if (as_k_chg[a].i_high > (as_k_chg[c].i_high + 600)) then Exit;

  if (as_k_chg[c].i_high > (as_k_chg[a].i_high + 600)) then Exit;

  if (as_k_chg[n].i_low < as_k_chg[b].i_low) then Exit;

  if (as_k_chg[n].i_close - as_k_chg[b].i_low) < Round((as_k_chg[c].i_high - as_k_chg[b].i_low) / 3) then Exit;
  if (as_k_chg[n].i_close - as_k_chg[b].i_low) < Round((as_k_chg[a].i_high - as_k_chg[b].i_low) / 3) then Exit;

  if (b - a < i_BB_BOX_X * 2) then Exit;
  if (c - b < i_BB_BOX_X) then Exit;
  if (i - n < 2) then Exit;

  i_MA120_BB_c := c;
  i_MA120_BB_n := n;
  i_MA120_BB_i := i;
  i_MA120_BB_mark := i;

  W_Log('M120 BB', i_tmp_log, i_make_log_ex, 'n !!!');
  W_Log('M120 BB', i_tmp_log, i_make_log_ex, 'c !!!');
  W_Log('M120 BB', i_tmp_log, i_make_log_ex, 'b !!!');
  W_Log('M120 BB', i_tmp_log, i_make_log_ex, 'a !!!');

  Result := -1;

end;

function ff_check_MA120_BB_ex(i: Integer): Integer;
begin
  Result := -1;
  if (i < 888) then Exit;

  if (i - i_MA120_BB_mark > i_BB_BOX_X * 2) then i_MA120_BB_mark := 0;

  if (i_MA120_BB_mark = 0) then Exit;

  W_Log('M120_BB_EX', i_tmp_log, i_make_log_ex, '1 888!!!');

  if (f_last_price_wk < ff_get_min_ij_low(i_MA120_BB_n, i_MA120_BB_i) / 100 - 2.0) then
  begin
    W_Log('M120_BB_EX', i_tmp_log, i_make_log_ex, '2 888!!!');

    i_MA120_BB_mark := 0;
  end;

  if (f_last_price_wk > (as_k_chg[i_MA120_BB_c].i_high / 100 + 5.0)) then
  begin
    W_Log('M120_BB_EX', i_tmp_log, i_make_log_ex, '2.5 f_last_price_wk  888!!!');

    W_Log('M120_BB_EX', i_tmp_log, i_make_log_ex, '3 888!!!');
    i_MA120_BB_mark := 0;
  end;

  W_Log('M120_BB_EX', i_tmp_log, i_make_log_ex, '4 888!!!');

  if (i_MA120_BB_mark = 0) then Exit;

  W_Log('M120_BB_EX', i_tmp_log, i_make_log_ex, '5 f_last_price_wk  888!!!');
  W_Log('M120_BB_EX', i_tmp_log, i_make_log_ex, '6 max high!!');

  if (f_last_price_wk > ff_get_max_ij_high(i_MA120_BB_n, i_MA120_BB_i) / 100) and
    (f_last_price_wk < (ff_get_max_ij_high(i_MA120_BB_n, i_MA120_BB_i) / 100 + 5)) then
  begin
    W_Log('M120_BB_EX', as_k_chg[i].i_date, i_wk_log, '88888888!!!');
    Result := 0;
    i_MA120_BB_mark := 0;
    Exit;
  end;
  Result := -1;

end;



function ff_check_rsi_w20_ex(i: Integer): Integer;
begin

  Result := -1;
  if (i < 88) then Exit;

  if (i_w20_mark = 0) then Exit;

  if i_w20_A_index > i - i_rsi_IA_min then Exit;

  //if i - i_w20_A_index > i_rsi_IA_max Then i_w20_mark :=0;

  if (f_last_price_wk < (ff_get_min_ij_low(i_w20_A_index, i - i_rsi_IA_min) / 100 - 1.0)) then
  begin
    i_w20_mark := 0;
  end;

  if (f_last_price_wk > (ff_get_max_ij_high(i_w20_A_index, i - i_rsi_IA_max) / 100 + 5.0)) then
  begin
    i_w20_mark := 0;
  end;

  if (i_w20_mark = 0) then Exit;

  if (ff_get_max_ij_high(i_w20_A_index, i - 2) - ff_get_min_ij_low(i_w20_A_index, i - 2) < i_BOX_Y) then
  begin
    if (f_last_price_wk > (ff_get_max_ij_high(i_w20_A_index, i_w20_A_index + i_rsi_IA_min) / 100 + 1.0)) and
      (f_last_price_wk < (ff_get_max_ij_high(i_w20_A_index, i_w20_A_index + i_rsi_IA_min) / 100 + 5.0)) then
    begin
      W_Log('W20_EX', as_k_chg[i].i_date, i_wk_log, '888888 !!!');
      Result := 0;
      i_w20_mark := 0;
      Exit;
    end;
  end
  else
  begin
    i_w20_mark := 0;
  end;

  Result := -1;

end;


function ff_check_BB_100(i: Integer; i_ma_index: Integer): Integer;
var
  j: Integer;
  n: Integer;
  a: Integer;
  b: Integer;
  c: Integer;
begin

  Result := -1;

  if (i_act_bb_100 = 0) then exit;

  if (i < 888) then Exit;

  if (i - i_BB_100_mark > i_BB_100_BOX_X * 5) then i_BB_100_mark := 0;

  if (i_BB_100_mark > 888) then Exit;

  //ai_ma[6] for MA120
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6] - 100) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[6] + 1200) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[3] < (as_k_chg_ma_rsi[i].ai_ma[6])) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[5] < (as_k_chg_ma_rsi[i].ai_ma[6])) then Exit;

  n := ff_get_min_ij_index(i - i_BB_100_BOX_X - 2, i);

  c := ff_get_max_ij_index(i - 5 * i_BB_100_BOX_X, n);

  b := ff_get_min_ij_index(c - 12 * i_BB_100_BOX_X, c);

  a := ff_get_max_ij_index(b - 12 * i_BB_100_BOX_X, b);

  if (Integer(as_k_chg[a].i_high + 800) < ff_get_max_ij_high(a, n)) then Exit;

  if (Integer(as_k_chg[a].i_high - as_k_chg[b].i_low) > Round((Integer(as_k_chg[a].i_high) - ff_get_min_ij_low(a - 12 * i_BB_100_BOX_X, a)) / 2)) then Exit;


  //MA30 < MA120
  for j := a - i_BB_100_BOX_X * 2 to n - i_BB_100_BOX_X do
  begin
    if as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[6] then Exit;
    if as_k_chg_ma_rsi[j].ai_ma[5] < (as_k_chg_ma_rsi[j].ai_ma[6] - 200) then Exit;
    if (as_k_chg[j].i_close < as_k_chg_ma_rsi[j - 1].ai_ma[6] - 100) then Exit;
  end;

  if (c > (n - i_BB_100_BOX_X + 2)) then Exit;

  if as_k_chg[c].i_high > (as_k_chg[n].i_close + 2800) then Exit;

  if (as_k_chg[a].i_high > (as_k_chg[c].i_high + 1200)) then Exit;

  if (as_k_chg[c].i_high > (as_k_chg[a].i_high + 1200)) then Exit;

  if (as_k_chg[n].i_low < as_k_chg[b].i_low) then Exit;

  if (as_k_chg[n].i_close - as_k_chg[b].i_low) < Round((as_k_chg[c].i_high - as_k_chg[b].i_low) / 3) then Exit;
  if (as_k_chg[n].i_close - as_k_chg[b].i_low) < Round((as_k_chg[a].i_high - as_k_chg[b].i_low) / 3) then Exit;

  if (b - a < i_BB_100_BOX_X * 2) then Exit;
  if (c - b < i_BB_100_BOX_X) then Exit;
  if (i - n < 2) then Exit;

  i_BB_100_c := c;
  i_BB_100_n := n;
  i_BB_100_i := i;
  i_BB_100_mark := i;

  W_Log('BB_100', i_tmp_log, i_make_log_ex, 'n !!!');
  W_Log('BB_100', i_tmp_log, i_make_log_ex, 'c !!!');
  W_Log('BB_100', i_tmp_log, i_make_log_ex, 'b !!!');
  W_Log('BB_100', i_tmp_log, i_make_log_ex, 'a !!!');

  Result := -1;

end;


function ff_check_BB_100_ex(i: Integer): Integer;
begin
  Result := -1;
  if (i < 888) then Exit;

  if (i_BB_100_mark = 0) then Exit;

  //W_Log('BB_100_EX',as_k_chg[i].i_date,8,'1 888!!!');

  if (f_last_price_wk < ff_get_min_ij_low(i_BB_100_n, i_BB_100_i) / 100 - 2.0) then
  begin
    //W_Log('BB_100_EX',as_k_chg[i].i_date,8,'2 888!!!');
    i_BB_100_mark := 0;
  end;

  if (f_last_price_wk > (as_k_chg[i_BB_100_c].i_high / 100 + 5.0)) then
  begin
  //W_Log('BB_100_EX',as_k_chg[i].i_high,8,'2.5 f_last_price_wk  888!!!');
  //W_Log('BB_100_EX',as_k_chg[i].i_date,8,'3 888!!!');
    i_BB_100_mark := 0;
  end;

  //W_Log('BB_100_EX',as_k_chg[i].i_date,8,'4 888!!!');

  if (i_BB_100_mark = 0) then Exit;

  //W_Log('BB_100_EX',as_k_chg[i].i_high,8,'5 f_last_price_wk  888!!!');
  //W_Log('BB_100_EX',ff_get_max_ij_high(i_BB_100_n,i_BB_100_i),8,'6 max high!!');

  if (f_last_price_wk > ff_get_max_ij_high(i_BB_100_n, i_BB_100_i) / 100) and
    (f_last_price_wk < (ff_get_max_ij_high(i_BB_100_n, i_BB_100_i) / 100 + 5)) then
  begin
    W_Log('BB_100_EX', as_k_chg[i].i_date, i_wk_log, '88888888!!!');
    Result := 0;
    i_BB_100_mark := 0;
    Exit;
  end;
  Result := -1;

end;


function ff_get_S_L_Mark(i: Integer): Integer;
begin
  Result := -1;

  if (i < 888) then Exit;

  i_MA120_120_chg := as_k_chg_ma_rsi[i].ai_ma[6] - as_k_chg_ma_rsi[i - 120].ai_ma[6];

  if (i_MA120_120_chg > 1600) then
  begin
    f_rsi_stop_long := f_rsi_stop * 2;
    i_make_long := 888
  end
  else
  begin
    i_make_long := 0;
    f_rsi_stop_long := f_rsi_stop;
  end;

  if (i_MA120_120_chg < -1600) then
  begin
    f_rsi_stop_short := f_rsi_stop * 2;
    i_make_short := 888
  end
  else
  begin
    f_rsi_stop_short := f_rsi_stop;
    i_make_short := 0;
  end;

  if (f_mbm_stop_short > 1.0) then
    f_rsi_stop_short := f_mbm_stop_short;

  if (f_mbm_stop_long > 1.0) then
    f_rsi_stop_long := f_mbm_stop_long;

  if (f_mbm_cut_short > 1.0) then
    f_rsi_cut_short := f_mbm_cut_short
  else
    f_rsi_cut_short := f_rsi_cut;

  if (f_mbm_stop_long > 1.0) then
    f_rsi_cut_long := f_mbm_cut_long
  else
    f_rsi_cut_long := f_rsi_cut;

end;







function ff_check_M30_short(i: Integer): Integer;
var
  j: Integer;
  n: Integer;
  a: Integer;
  b: Integer;
  c: Integer;
begin

  Result := -1;

  if (i < 288) then Exit;

  if (i - i_M30_short_mark > i_M30_short_BOX_X * 2) then i_M30_short_mark := 0;

  if (i_M30_short_mark > 288) then Exit;

  //ai_ma[6] for MA120
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[5] - 100) then Exit;

  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[5] - 1200) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[3] < (as_k_chg_ma_rsi[i].ai_ma[6])) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[5] < (as_k_chg_ma_rsi[i].ai_ma[6])) then Exit;

  n := ff_get_max_ij_index(i - i_M30_short_BOX_X - 2, i);

  c := ff_get_min_ij_index(i - 5 * i_M30_short_BOX_X, n);

  b := ff_get_max_ij_index(c - 8 * i_M30_short_BOX_X, c);

  a := ff_get_min_ij_index(b - 8 * i_M30_short_BOX_X, b);

  if (Integer(as_k_chg[a].i_low + 800) < ff_get_min_ij_low(a, n)) then Exit;

  //MA30 < MA120
  for j := a to n - i_M30_short_BOX_X do
  begin
    if as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[6] then Exit;
  end;

  if (c > (n - i_M30_short_BOX_X + 2)) then Exit;

  //if ((as_k_chg[c].i_low +1600) < as_k_chg[n].i_close) Then Exit;

  //if (as_k_chg[a].i_low  > (as_k_chg[c].i_low + 800) ) Then Exit;

  //if (as_k_chg[c].i_low > (as_k_chg[a].i_low + 800) ) Then Exit;

  if (as_k_chg[n].i_high > as_k_chg[b].i_high) then Exit;

  if (b - a < i_M30_short_BOX_X * 2) then Exit;
  if (c - b < i_M30_short_BOX_X) then Exit;
  if (i - n < 2) then Exit;

  i_M30_short_c := c;
  i_M30_short_n := n;
  i_M30_short_i := i;
  i_M30_short_mark := i;

  //W_Log('M30_short',as_k_chg[n].i_date,8,'n !!!');
  //W_Log('M30_short',as_k_chg[c].i_date,8,'c !!!');
  //W_Log('M30_short',as_k_chg[b].i_date,8,'b !!!');
  //W_Log('M30_short',as_k_chg[a].i_date,8,'a !!!');

  Result := -1;

end;

function ff_check_M30_short_ex(i: Integer): Integer;
begin
  Result := -1;
  if (i < 288) then Exit;

  if (i_M30_short_mark = 0) then Exit;

  //W_Log('M30_short_EX',as_k_chg[i].i_date,8,'1 888!!!');

  if (f_last_price_wk > ff_get_max_ij_high(i_M30_short_n, i_M30_short_i) / 100 - 2.0) then
  begin
    //W_Log('M30_short_EX',as_k_chg[i].i_date,8,'2 888!!!');
    i_M30_short_mark := 0;
  end;

  if (f_last_price_wk < (as_k_chg[i_M30_short_c].i_low / 100 - 15.0)) then
  begin
  //W_Log('M30_short_EX',as_k_chg[i].i_high,8,'2.5 f_last_price_wk  888!!!');

  //W_Log('M30_short_EX',as_k_chg[i].i_date,8,'3 888!!!');
    i_M30_short_mark := 0;
  end;

  //W_Log('M120_BB_EX',as_k_chg[i].i_date,8,'4 888!!!');

  if (i_M30_short_mark = 0) then Exit;

  //W_Log('M30_short_EX',as_k_chg[i].i_low,8,'5 f_last_price_wk  888!!!');
  //W_Log('M30_short_EX',ff_get_min_ij_low(i_M30_short_n,i_M30_short_i),8,'6 min low!!');

  if (f_last_price_wk > as_k_chg_ma_rsi[i - 1].ai_ma[6] / 100) then Exit;

  if (f_last_price_wk < ff_get_min_ij_low(i_M30_short_n, i_M30_short_i) / 100) and
    (f_last_price_wk > (ff_get_min_ij_low(i_M30_short_n, i_M30_short_i) / 100 - 15)) then
  begin
    W_Log('M30_short_EX', as_k_chg[i].i_date, i_wk_log, '88888888!!');
    Result := 0;
    i_M30_short_mark := 0;
    Exit;
  end;
  Result := -1;

end;

function ff_check_short_1(i: Integer): Integer;
var
  j: Integer;
  a: Integer;
  b: Integer;
  k: Integer;
  m: Cardinal;
begin

  Result := -1;

  if (i_act_short = 0) then Exit;

  if (i < 888) then Exit;

  if (i - i_short_1_mark > i_BB_BOX_X * 3) then i_short_1_mark := 0;

  if (i_short_1_mark > 888) then Exit;

  //ai_ma[6] for MA120
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[3]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[8] + 30) then Exit;
  m := 400;
  a := 0;
  k := i;
  for j := k downto k - i_BB_BOX_X * 8 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[3] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[6] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[8] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[8] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[3] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[5] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[6] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[5] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[8] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[5] + m) and
      (as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[3] + m)) then
    begin
      a := j;
      Break;
    end;
  end;

  if (a = 0) then Exit;

  if (ff_get_max_ij_high(i - i_BB_BOX_X * 8, i) < integer(as_k_chg_ma_rsi[a].ai_ma[6])) then Exit;

  if (ff_get_max_ij_high(i - 3, i) < integer(as_k_chg_ma_rsi[i].ai_ma[3])) then Exit;


  b := 0;
  k := i;
  for j := k downto k - i_BB_BOX_X * 8 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[8] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6] + 20)) then
    begin
      b := j;
      Break;
    end;
  end;

  if ((b = 0) or (b < a - i_BB_BOX_X * 2)) then Exit;

  if (as_k_chg[b].i_high + 1200 < as_k_chg_ma_rsi[b].ai_ma[6]) then exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[3] > as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[6] > as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[3] > as_k_chg_ma_rsi[a].ai_ma[3]) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[a].ai_ma[5]) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[6] > as_k_chg_ma_rsi[a].ai_ma[6]) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[8] > as_k_chg_ma_rsi[a].ai_ma[8]) then Exit;

  if (ff_get_max_ij_high(i - 3, i) > integer(as_k_chg_ma_rsi[i].ai_ma[6])) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[5]) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[3]) and
    (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6]) then
  begin
    i_short_1_mark := i;
    W_Log('short_1', as_k_chg[i].i_date, i_wk_log, 'Down Under M120, SET i_short_1_mark');
    Result := 0;
    Exit;
  end;


  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[3]) then
  begin
    i_short_1_mark := i;
    W_Log('Short_1', as_k_chg[i].i_date, i_wk_log, 'SET i_short_1_mark!');
    Result := 0;
    Exit;
  end;

  Result := -1;

end;


function ff_check_short_1_ex(i: Integer): Integer;
begin
  Result := -1;
  if (i < 288) then Exit;

  if (i_short_1_mark = 0) then Exit;

  if (f_last_price_wk > ff_get_max_ij_high(i - 5, i - 1) / 100 + 2.0) then
  begin
    i_short_1_mark := 0;
  end;

  if (f_last_price_wk < (ff_get_min_ij_low(i - i_BB_BOX_X * 2, i - 1) / 100 - 3.0)) then
  begin
    i_short_1_mark := 0;
  end;

  if (i_short_1_mark = 0) then Exit;

  if (f_last_price_wk < as_k_chg_ma_rsi[i - 1].ai_ma[3] / 100) and
    (f_last_price_wk > (as_k_chg_ma_rsi[i - 1].ai_ma[3] / 100 - 5)) then
  begin
    W_Log('Short_1', as_k_chg[i].i_date, i_wk_log, '88888888!!');
    i_short_1_mark := 0;
    Result := 0;
    Exit;
  end;
  Result := -1;
end;


function ff_get_BS_Mark(i: Integer): Integer;
begin
  Result := -1;

  if (i < 888) then Exit;

  i_B_S_Flag_10 := as_k_chg_ma_rsi[i - 10].ai_ma[6] - as_k_chg_ma_rsi[i - 10].ai_ma[8];
  i_B_S_Flag_18 := as_k_chg_ma_rsi[i - 18].ai_ma[6] - as_k_chg_ma_rsi[i - 18].ai_ma[8];

  i_B_S_Flag := as_k_chg_ma_rsi[i].ai_ma[6] - as_k_chg_ma_rsi[i].ai_ma[8];

  if i_B_S_Flag > 0 then
  begin
    //i_act_rsi:=10;
    //i_act_m120:=10;
    //i_act_bb_100:=10;
    //i_act_short:=0;
  end
  else
  begin
    //i_act_short:=10;
    //i_act_rsi:=0;
    //i_act_m120:=0;
    //i_act_bb_100:=0;
  end;

  if (Integer(as_k_chg_ma_rsi[i].ai_ma[8] - as_k_chg_ma_rsi[i].ai_ma[3]) > 700) and
    (i_short_long_01 = 888) then
  begin
    if (as_k_chg_ma_rsi[i].ai_ma[8] > as_k_chg_ma_rsi[i].ai_ma[6] + 100) and
      (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[5] + 50) and
      (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[3] + 100) then
    begin
      //for short
      i_short_long_01 := 0;
      i_short_long_date := as_k_chg[i].i_date mod 10000;
      i_short_long_index := i;
      W_Log(PChar(IntToStr(as_k_chg[i].i_date)), i_wk_log, i_wk_log, 'DO SHORT ONLY!');
    end;
  end;

  if (Integer(as_k_chg_ma_rsi[i].ai_ma[8]) < as_k_chg[i].i_high) and
    (i_short_long_01 = 0) then
  begin
    i_short_long_01 := 888;
    W_Log(PChar(IntToStr(as_k_chg[i].i_date)), i_wk_log, i_wk_log, 'DO SHORT END!');
  end;


  if (Integer(as_k_chg_ma_rsi[i].ai_ma[3] - as_k_chg_ma_rsi[i].ai_ma[8]) > 700) and
    (i_short_long_01 = 888) then
  begin
    if (as_k_chg_ma_rsi[i].ai_ma[3] > as_k_chg_ma_rsi[i].ai_ma[5] + 100) and
      (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[6] + 50) and
      (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[8] + 100) then
    begin
      //for short
      i_short_long_01 := 1;
      i_short_long_index := i;
      i_short_long_date := as_k_chg[i].i_date mod 10000;
      W_Log(PChar(IntToStr(as_k_chg[i].i_date)), i_wk_log, i_wk_log, 'DO LONG ONLY!');
    end;
  end;

  if (Integer(as_k_chg_ma_rsi[i].ai_ma[8]) > as_k_chg[i].i_low) and
    (i_short_long_01 = 1) then
  begin
    i_short_long_01 := 888;
    W_Log(PChar(IntToStr(as_k_chg[i].i_date)), i_wk_log, i_wk_log, 'DO LONG END!');
  end;

  if (i_short_long_01 = 0) then
  begin
    //frmMain2.GRID_S008.Cells[0,0]:='SHORT';
    //frmMain2.Header.Cells[12,0] := IntToStr(i_short_long_date);
    //frmMain2.Header.Cells[13,0] := 'SHORT!';
  end
  else if (i_short_long_01 = 1) then
  begin
    //frmMain2.GRID_S008.Cells[0,0]:='LONG';
    //frmMain2.Header.Cells[12,0] := IntToStr(i_short_long_date);
    //frmMain2.Header.Cells[13,0] := 'LONG!';
  end
  else
  begin
    //frmMain2.GRID_S008.Cells[0,0]:='NOTRADE';
    //frmMain2.Header.Cells[12,0] := ' ';
    //frmMain2.Header.Cells[13,0] := 'NO TRADE!';
  end;

end;

function ff_get_long_mark_8(i: Integer): Integer;
var
  i_B_S_Flag_tmp: Integer;
  i_B_S_Flag_10_tmp: Integer;
  i_B_S_Flag_18_tmp: Integer;
begin
  Result := -1;

  if (i < 888) then Exit;

  i_B_S_Flag_10_tmp := as_k_chg_ma_rsi[i - 10].ai_ma[6] - as_k_chg_ma_rsi[i - 10].ai_ma[8];
  i_B_S_Flag_18_tmp := as_k_chg_ma_rsi[i - 18].ai_ma[6] - as_k_chg_ma_rsi[i - 18].ai_ma[8];
  i_B_S_Flag_tmp := as_k_chg_ma_rsi[i].ai_ma[6] - as_k_chg_ma_rsi[i].ai_ma[8];

  //if(  i_B_S_Flag_18_tmp>0  ) and (  i_B_S_Flag_10_tmp>0  ) Then
  //if (i_B_S_Flag_tmp < 0 ) Then
  //begin
  //  Result :=i;
  //end;

  if (i_B_S_Flag_18_tmp < 0) and (i_B_S_Flag_10_tmp < 0) then
    if (i_B_S_Flag_tmp > 0) then
    begin
      Result := i;
    end;

end;

function ff_get_ma600_mark(i: Integer): Integer;
var
  i_low_600: Integer;
  i_high_600: Integer;
  i_check_count: Integer;
begin
  Result := -1;

  if (i < 888) then Exit;

  i_check_count := 38;

  i_low_600 := ff_get_min_ij_low(i - i_check_count, i);
  i_high_600 := ff_get_max_ij_high(i - i_check_count, i);

  if (i_low_600 < as_k_chg_ma_rsi[i - i_check_count].ai_ma[9]) and
    (i_low_600 < as_k_chg_ma_rsi[i].ai_ma[9]) and
    (as_k_chg_ma_rsi[i].ai_ma[0] > as_k_chg_ma_rsi[i - i_check_count].ai_ma[9] - 1000) and
    (as_k_chg_ma_rsi[i].ai_ma[0] > as_k_chg_ma_rsi[i].ai_ma[9] - 1000) and
    (i_low_600 > as_k_chg_ma_rsi[i - i_check_count].ai_ma[9] - 1200) and
    (i_low_600 > as_k_chg_ma_rsi[i].ai_ma[9] - 1200) and

      //( as_k_chg_ma_rsi[i-300].ai_ma[9] < as_k_chg_ma_rsi[i].ai_ma[9] ) and

  (as_k_chg_ma_rsi[i].ai_ma[6] < as_k_chg_ma_rsi[i].ai_ma[9]) and

  (i_high_600 < as_k_chg_ma_rsi[i - i_check_count].ai_ma[9]) and
    (i_high_600 < as_k_chg_ma_rsi[i].ai_ma[9])
      //( i_high_600 > as_k_chg_ma_rsi[i-10].ai_ma[9] - 500  ) and
      //( i_high_600 > as_k_chg_ma_rsi[i].ai_ma[9] -500 )
  then
  begin

    if ((as_k_chg_ma_rsi[i - 1].ai_ma[8] > as_k_chg_ma_rsi[i - 1].ai_ma[6]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[6] > as_k_chg_ma_rsi[i - 1].ai_ma[5]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[i - 1].ai_ma[4]) and

      (as_k_chg_ma_rsi[i - 1].ai_ma[3] < as_k_chg_ma_rsi[i - 5].ai_ma[3]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[4] < as_k_chg_ma_rsi[i - 5].ai_ma[4]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[5] < as_k_chg_ma_rsi[i - 5].ai_ma[5]) and

      (as_k_chg_ma_rsi[i - 1].ai_ma[4] > as_k_chg_ma_rsi[i - 1].ai_ma[3])) then

      Result := i;

  end;

end;

function ff_get_ma600_mark_long(i: Integer): Integer;
var
  i_low_600: Integer;
  i_high_600: Integer;
  i_check_count: Integer;
begin
  Result := -1;

  if (i < 888) then Exit;

  i_check_count := 28;

  i_low_600 := ff_get_min_ij_low(i - i_check_count, i);
  i_high_600 := ff_get_max_ij_high(i - i_check_count, i);

  if (i_low_600 > as_k_chg_ma_rsi[i - i_check_count].ai_ma[9]) and
    (i_low_600 > as_k_chg_ma_rsi[i].ai_ma[9]) and
    (as_k_chg_ma_rsi[i].ai_ma[1] < as_k_chg_ma_rsi[i - i_check_count].ai_ma[9] + 1000) and
    (as_k_chg_ma_rsi[i].ai_ma[1] < as_k_chg_ma_rsi[i].ai_ma[9] + 1000) and
    (i_high_600 < as_k_chg_ma_rsi[i - i_check_count].ai_ma[9] + 1200) and
    (i_high_600 < as_k_chg_ma_rsi[i].ai_ma[9] + 1200) and

  (as_k_chg_ma_rsi[i - 300].ai_ma[9] > as_k_chg_ma_rsi[i].ai_ma[9]) and

      //( as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[9] ) and

  (i_high_600 > as_k_chg_ma_rsi[i - i_check_count].ai_ma[9]) and
    (i_high_600 > as_k_chg_ma_rsi[i].ai_ma[9])
    then
  begin

    if ((as_k_chg_ma_rsi[i - 1].ai_ma[8] < as_k_chg_ma_rsi[i - 1].ai_ma[6]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[6] < as_k_chg_ma_rsi[i - 1].ai_ma[5]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[5] < as_k_chg_ma_rsi[i - 1].ai_ma[4]) and

      (as_k_chg_ma_rsi[i - 1].ai_ma[3] > as_k_chg_ma_rsi[i - 5].ai_ma[3]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[4] > as_k_chg_ma_rsi[i - 5].ai_ma[4]) and
      (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[i - 5].ai_ma[5]) and

      (as_k_chg_ma_rsi[i - 1].ai_ma[4] < as_k_chg_ma_rsi[i - 1].ai_ma[3])) then

      Result := i;

  end;

end;





function ff_check_short_250(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  k: Integer;
  i_high: Integer;
  i_low: Integer;

begin

  Result := -1;

  if (i_act_short = 0) then Exit;

  if (i < 888) then Exit;

  if (i - i_short_250_mark > i_BB_BOX_X) then i_short_250_mark := 0;

  if (i_short_250_mark > 888) then Exit;

  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  b := 0;
  k := i;
  for j := k - 120 to i - i_BB_BOX_X do
  begin
    if (as_k_chg[j].i_high > as_k_chg_ma_rsi[j].ai_ma[8] + 20) then
    begin
      Exit;
    end;
  end;


  b := 0;
  k := i;
  for j := k downto 888 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[8] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6] + 20)) then
    begin
      b := j;
      Break;
    end;
  end;

  if b = 0 then Exit;

  i_high := ff_get_max_ij_high(b, i);
  i_low := ff_get_min_ij_low(b, i);

  if (i_high < integer(as_k_chg[i].i_close)) then Exit;

  if (i_low > integer(as_k_chg[i].i_low - 800)) then Exit;

  if ((i_high - i_low) > integer(3 * (integer(as_k_chg[i].i_high) - i_low))) then Exit;

  if ((100 * (i_high - i_low) / (i_high + 100)) < 1) then Exit;

  if (as_k_chg[b].i_close < as_k_chg[i].i_close + 800) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[6] > as_k_chg_ma_rsi[b].ai_ma[6]) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[8] > as_k_chg_ma_rsi[b].ai_ma[8]) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[3] > as_k_chg_ma_rsi[i].ai_ma[8]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[8]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[8]) then Exit;

  if (ff_get_max_ij_high(i - 3, i) > integer(as_k_chg_ma_rsi[i].ai_ma[8])) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[6]) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[3]) and
    (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[8]) then
  begin
    i_short_250_mark := i;
    W_Log('Short_1', as_k_chg[i].i_date, i_wk_log, 'SET i_short_250_mark!');
    Result := 0;
    Exit;
  end;

  Result := -1;

end;





function ff_check_short_30(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  k: Integer;
  i_high: Integer;
begin

  Result := -1;

  if (i_act_short = 0) then Exit;

  if (i < 888) then Exit;

  if (i - i_short_30_mark > i_BB_BOX_X) then i_short_30_mark := 0;

  if (i_short_30_mark > 888) then Exit;

  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;

  k := i;
  for j := k - 5 downto k - i_BB_BOX_X - 5 do
  begin
    if (as_k_chg[j].i_high > as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
  end;

  b := 0;
  k := i;
  for j := k downto 888 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[8] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6] + 20)) then
    begin
      b := j;
      Break;
    end;
  end;

  if b = 0 then Exit;

  //for 1.5 hour
  if ((i - b) > 58) then Exit;

  i_high := ff_get_max_ij_high(b, i);

  if (i_high < integer(as_k_chg[i].i_close)) then Exit;
  if (as_k_chg[b].i_close < as_k_chg[i].i_close + 800) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[6] > as_k_chg_ma_rsi[b].ai_ma[6] + 100) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[8] > as_k_chg_ma_rsi[b].ai_ma[8] + 100) then Exit;

  if (ff_get_max_ij_high(i - 6, i) > integer(as_k_chg_ma_rsi[i].ai_ma[3])) and
    (as_k_chg[i - 1].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[3]) and
    (as_k_chg[i].i_close < as_k_chg[i - 1].i_close) and
    ((as_k_chg[i - 2].i_high > as_k_chg_ma_rsi[i - 2].ai_ma[3]) or
    (as_k_chg[i - 3].i_high > as_k_chg_ma_rsi[i - 3].ai_ma[3]) or
    (as_k_chg[i - 4].i_high > as_k_chg_ma_rsi[i - 4].ai_ma[3]) or
    (as_k_chg[i - 1].i_high > as_k_chg_ma_rsi[i - 1].ai_ma[3]) or
    (as_k_chg[i - 6].i_high > as_k_chg_ma_rsi[i - 6].ai_ma[3]) or
    (as_k_chg[i - 5].i_high > as_k_chg_ma_rsi[i - 5].ai_ma[3])) then
  begin
    i_short_30_mark := i;
    W_Log('short_30', as_k_chg[i].i_date, i_wk_log, 'short 30!!!');
    Result := 0;
    Exit;
  end;

  Result := -1;

end;

function ff_check_short_120(i: Integer): Integer;
var
  j: Integer;
  k: Integer;
  i_high: Integer;
  i_low: Integer;
begin

  Result := -1;

  if (i_act_short = 0) then Exit;

  if (i < 888) then Exit;

  if (i - i_short_120_mark > i_BB_BOX_X) then i_short_120_mark := 0;


  if (i_short_120_mark > 888) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[8]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  k := i;
  for j := k - 5 downto k - 128 do
  begin
    if (as_k_chg[j].i_high > as_k_chg_ma_rsi[j].ai_ma[6]) then Exit;
  end;

  i_low := ff_get_min_ij_low(i - i_BB_BOX_X * 8, i);

  if (i_low > integer(as_k_chg[i].i_close)) then Exit;

  i_high := ff_get_max_ij_high(i - i_BB_BOX_X * 3, i - 5);
  if (i_high > integer(as_k_chg_ma_rsi[i].ai_ma[6])) then Exit;

  if (ff_get_max_ij_high(i - 3, i) > integer(as_k_chg_ma_rsi[i].ai_ma[6])) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[3]) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[5]) and
    (as_k_chg[i].i_close < as_k_chg_ma_rsi[i].ai_ma[6]) then
  begin
    i_short_120_mark := i;
    W_Log('short_120', as_k_chg[i].i_date, 8, 'short 120!!!');
    Result := 0;
    Exit;
  end;

  Result := -1;

end;


function ff_short_pass3_mark(i: Integer): Integer;
var
  j: Integer;
  c: Integer;
  b: Integer;
  a: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (i - i_short_pass3_mark > 58) then i_short_pass3_mark := 0;

  if (i_short_pass3_mark > 888) then Exit;

  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;
  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  k := i;
  for j := k - 8 downto k - 38 do
  begin
  //  if( as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6] ) Then Exit;
  end;

  k := i;
  c := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[3] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[8] + 20)) then
    begin
      c := j;
      Break;
    end;
  end;

  if (c = 0) then Exit;

  k := i;
  b := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[3] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[6] + 20)) then
    begin
      b := j;
      Break;
    end;
  end;

  if (b = 0) then Exit;

  a := 0;
  k := i;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[3] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[5] + 20)) then
    begin
      a := j;
      Break;
    end;
  end;

  if (a = 0) then Exit;

  if ((i - a) > i_BB_BOX_X) and ((i - b) > i_BB_BOX_X) and ((i - c) > i_BB_BOX_X) then Exit;


  for j := a - 2 downto a - i_BB_BOX_X do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[5] > as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
  end;

  for j := b - 2 downto b - i_BB_BOX_X do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[6] > as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
  end;

  for j := c - 2 downto c - i_BB_BOX_X do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[8] > as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
  end;

  i_short_pass3_mark := i;
  W_Log('short_pass3_mark', as_k_chg[i].i_date, i_wk_log, 'SET short pass3_mark!!!');

  Result := 0;

end;



function ff_pass3_short_120(i: Integer): Integer;
var
  j: Integer;
  k: Integer;
  i_high: Integer;
  i_low: Integer;
begin

  Result := -1;

  if (i_act_short = 0) then Exit;

  if (i_short_pass3_mark = 0) then Exit;

  if (i - i_pass3_short_120_mark > i_BB_BOX_X) then i_pass3_short_120_mark := 0;

  if (i_pass3_short_120_mark > 888) then Exit;

  if (i < 888) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[8]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[8]) then Exit;

  if (as_k_chg[i].i_close > as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  if (ff_get_max_ij_high(i - 3, i) > integer(as_k_chg_ma_rsi[i].ai_ma[6])) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[3]) and
    (as_k_chg[i].i_close < as_k_chg_ma_rsi[i].ai_ma[6]) then
  begin
    i_pass3_short_120_mark := i;
    W_Log('pass3_short120', as_k_chg[i].i_date, i_wk_log, 'pass3_short120!!!');
    Result := 0;
    Exit;
  end;

  Result := -1;

end;




function ff_check_long_pass_3(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  a: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (i - i_pass_3_mark > i_BB_BOX_X) then i_pass_3_mark := 0;

  if (i_pass_3_mark > 888) then Exit;

  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  k := i;
  for j := k - 8 downto k - 188 do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6]) then Exit;
    if (as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[5]) then Exit;
  end;

  k := i;
  b := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;

    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[3] + 30) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[6] + 30)) then
    begin
      b := j;
      Break;
    end;
  end;

  if (b = 0) then Exit;

  a := 0;
  k := i;
  for j := b - 2 downto k - i_BB_BOX_X * 5 do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
    if (as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;

    if ((as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[3] + 30) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[5] + 30)) then
    begin
      a := j;
      Break;
    end;
  end;

  if (a = 0) then Exit;

  for j := a - 2 downto a - i_BB_BOX_X do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
  end;

  if (as_k_chg_ma_rsi[i].ai_ma[8] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;

  i_pass_3_mark := i;
  W_Log('pass_3', as_k_chg[i].i_date, 8, 'long pass_3!!!');

  Result := 0;

end;


function ff_long_pass_3_ex(i: Integer): Integer;
var
  j: Integer;
  c: Integer;
  b: Integer;
  a: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (i - i_pass_3_mark_ex > i_BB_BOX_X) then i_pass_3_mark_ex := 0;

  if (i_pass_3_mark_ex > 888) then Exit;

  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[8] > as_k_chg_ma_rsi[i].ai_ma[6] + 50) then Exit;

  if (as_k_chg_ma_rsi[i].ai_ma[6] < as_k_chg_ma_rsi[i - 20].ai_ma[6] + 50) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[8] + 100 < as_k_chg_ma_rsi[i - 20].ai_ma[8]) then Exit;

  k := i;
  c := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[3] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[8] + 20)) then
    begin
      c := j;
      Break;
    end;
  end;

  if (c = 0) then Exit;

  k := i;
  b := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[3] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[6] + 20)) then
    begin
      b := j;
      Break;
    end;
  end;

  if (b = 0) then Exit;

  a := 0;
  k := i;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[3] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[5] + 20)) then
    begin
      a := j;
      Break;
    end;
  end;

  if (a = 0) then Exit;

  if ((i - a) > i_BB_BOX_X) and ((i - b) > i_BB_BOX_X) and ((i - c) > i_BB_BOX_X) then Exit;


  if (as_k_chg_ma_rsi[i].ai_ma[8] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;

  i_pass_3_mark_ex := i;
  W_Log('pass_3_ex', as_k_chg[i].i_date, i_wk_log, 'long pass_3_ex!!!');

  Result := 0;

end;

function ff_short_pass_3_ex(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  a: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (i - i_pass_3_mark > i_BB_BOX_X) then i_pass_3_mark := 0;

  if (i_pass_3_mark > 888) then Exit;

  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  k := i;
  for j := k - 8 downto k - 188 do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6]) then Exit;
    if (as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[5]) then Exit;
  end;

  k := i;
  b := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 6 do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;

    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[3] + 30) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[6] + 30)) then
    begin
      b := j;
      Break;
    end;
  end;

  if (b = 0) then Exit;

  a := 0;
  k := i;
  for j := b - 2 downto k - i_BB_BOX_X * 5 do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
    if (as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;

    if ((as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[3] + 30) and
      (as_k_chg_ma_rsi[j].ai_ma[3] < as_k_chg_ma_rsi[j].ai_ma[5] + 30)) then
    begin
      a := j;
      Break;
    end;
  end;

  if (a = 0) then Exit;

  for j := a - 2 downto a - i_BB_BOX_X do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[5] < as_k_chg_ma_rsi[j].ai_ma[3]) then Exit;
  end;

  if (as_k_chg_ma_rsi[i].ai_ma[8] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[6] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;
  if (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[i].ai_ma[3]) then Exit;

  i_pass_3_mark := i;
  W_Log('pass_3', as_k_chg[i].i_date, 8, 'long pass_3!!!');

  Result := 0;

end;



function ff_make_long_MA30(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  a: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (i_short_long_01 <> 1) then Exit;
  if (i > i_short_long_index + 38) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[6] < as_k_chg_ma_rsi[i - 8].ai_ma[6]) then Exit;

  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[3] < as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;

  k := i;
  b := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 2 do
  begin
    if (as_k_chg[j].i_low > as_k_chg_ma_rsi[j].ai_ma[3]) then
    begin
      b := j;
      Break;
    end;
  end;

  if (b = 0) then Exit;

  if (ff_get_min_ij_low(b, i) < as_k_chg_ma_rsi[i].ai_ma[3]) and
    (ff_get_min_ij_low(b, i) > as_k_chg_ma_rsi[i].ai_ma[5]) and
    (as_k_chg_ma_rsi[i].ai_ma[3] > as_k_chg_ma_rsi[b].ai_ma[3]) and
    (as_k_chg[i].i_close > ff_get_max_ij_high(i - 3, i - 1)) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[3]) then
  begin
    W_Log('LONY_MA30', as_k_chg[i].i_date, i_tmp_log, 'MAKE LONG_MA30!!!');
    Result := 0;
  end;

end;


function ff_make_long_MA60(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  a: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (i_short_long_01 <> 1) then Exit;
  if (i > i_short_long_index + 38) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[8] < as_k_chg_ma_rsi[i - 8].ai_ma[8]) then Exit;
  if (as_k_chg_ma_rsi[i - 1].ai_ma[6] < as_k_chg_ma_rsi[i - 8].ai_ma[6]) then Exit;

  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[8]) then Exit;
  if (as_k_chg[i].i_close < as_k_chg_ma_rsi[i - 1].ai_ma[6]) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[3] < as_k_chg_ma_rsi[i - 1].ai_ma[5]) then Exit;

  k := i;
  b := 0;
  for j := k - 1 downto k - i_BB_BOX_X * 2 do
  begin
    if (as_k_chg[j].i_low > as_k_chg_ma_rsi[j].ai_ma[5]) then
    begin
      b := j;
      Break;
    end;
  end;

  if (b = 0) then Exit;

  if (ff_get_min_ij_low(b, i) < as_k_chg_ma_rsi[i].ai_ma[5]) and
    (ff_get_min_ij_low(b, i) > as_k_chg_ma_rsi[i].ai_ma[6]) and
    (as_k_chg_ma_rsi[i].ai_ma[5] > as_k_chg_ma_rsi[b].ai_ma[5]) and

  (as_k_chg[i].i_close > ff_get_max_ij_high(i - 3, i - 1)) and

  (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[5]) then
  begin
    W_Log('LONY_MA60', as_k_chg[i].i_date, i_tmp_log, 'MAKE LONG_MA60!!!');
    Result := 0;
  end;

end;

function ff_make_long_MA250(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  a: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  //if ( i_short_long_01 <> 1 ) Then Exit;
  //if ( i > i_short_long_index +38) Then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[8] < as_k_chg_ma_rsi[i - 8].ai_ma[8]) then Exit;

  b := 0;
  k := i;
  for j := k downto k - 288 do
  begin
    if ((as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[8] + 20) and
      (as_k_chg_ma_rsi[j].ai_ma[8] < as_k_chg_ma_rsi[j].ai_ma[6] + 20)) then
    begin
      b := j;
      Break;
    end;
  end;

  if (b = 0) then Exit;

  if (as_k_chg_ma_rsi[i - 1].ai_ma[8] < as_k_chg_ma_rsi[b].ai_ma[8]) then Exit;

  if (i - b < 58) then Exit;

  for j := b + 8 to b + 58 do
  begin
    if (as_k_chg_ma_rsi[j].ai_ma[6] < as_k_chg_ma_rsi[j].ai_ma[8]) then Exit;
    if (as_k_chg[j].i_close < as_k_chg_ma_rsi[j].ai_ma[8]) then Exit;
  end;

  if (as_k_chg[i].i_close > ff_get_max_ij_high(i - 8, i - 2)) and
    (ff_get_max_ij_high(i - 8, i - 2) < as_k_chg_ma_rsi[i].ai_ma[8]) and
    (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[8]) then
  begin
    W_Log('LONY_MA250', as_k_chg[i].i_date, i_tmp_log, 'MAKE LONG_MA250!!!');
    Result := 0;
  end;

end;


function ff_chk_power_vol(i: Integer): Integer;
var
  j: Integer;
  k: Integer;
  i_tmp: Integer;
  i_tmp_1: Integer;
  i_up_count_wk: Integer;
  i_down_count_wk: Integer;
  i_up_sum_wk: Integer;
  i_down_sum_wk: Integer;

begin

  Result := -1;

  k := i - 1;

  i_up_count_wk := 0;
  i_down_count_wk := 0;

  i_up_sum_wk := 0;
  i_down_sum_wk := 0;

  for j := k downto 8 do
  begin
    i_tmp := Round(as_k_chg[j].i_date / 10000);
    i_tmp_1 := Round(as_k_chg[j - 1].i_date / 10000);


    if (i_tmp <> i_tmp_1) then
    begin
      Break;
    end;

    if (as_k_chg[j].i_open < as_k_chg[j].i_close) and (as_k_chg[j].i_vol > i_chk_power_vol_wk) then
    begin
      i_up_count_wk := i_up_count_wk + 1;
      i_up_sum_wk := i_up_sum_wk + as_k_chg[j].i_vol;
    end;

    if (as_k_chg[j].i_open > as_k_chg[j].i_close) and (as_k_chg[j].i_vol > i_chk_power_vol_wk) then
    begin
      i_down_count_wk := i_down_count_wk + 1;
      i_down_sum_wk := i_down_sum_wk + as_k_chg[j].i_vol;
    end;

  end;

  i_up_count_ex := i_up_count_wk;
  i_down_count_ex := i_down_count_wk;
  i_up_vol_sum := i_up_sum_wk;
  i_down_vol_sum := i_down_sum_wk;

end;



//start for big money

function ff_4ma_make_mbm_long(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (
    (as_k_chg_ma_rsi[i - 1].ai_ma[6] < as_k_chg_ma_rsi[i - 1].ai_ma[5]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] < as_k_chg_ma_rsi[i - 1].ai_ma[4]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[3] > as_k_chg_ma_rsi[i - 3].ai_ma[3]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[4] > as_k_chg_ma_rsi[i - 3].ai_ma[4]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[i - 3].ai_ma[5]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[4] < as_k_chg_ma_rsi[i - 1].ai_ma[3])) then
  begin
    if (i_4ma_mbm_long = 888) then
    begin
      //check how long
      k := i;
      b := 0;
      for j := k - 888 to k do
      begin
        if (not (
          (as_k_chg_ma_rsi[j - 1].ai_ma[6] > as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[5] > as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[4] > as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
        begin
          if (not (
            (as_k_chg_ma_rsi[j - 1].ai_ma[6] < as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[5] < as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[4] < as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
          begin
            b := j;
            Break;
          end;
        end;
      end;

      if (b = 0) then Exit;
      if (i - b < 18) then Exit;

      i_4ma_long_mbm_mark := i;

      i_4ma_long_mbm_count_bak := i_4ma_long_mbm_count;
      i_4ma_long_mbm_count := i_4ma_long_mbm_count + 1;

      i_sum_4ma_long_mbm_count := i_sum_4ma_long_mbm_count + 1;

      if (i_4ma_long_mbm_count < 0) then W_Log('MBM 4ma long', as_k_chg[i].i_date, i_mbm_log + 1, PChar('4MA OK! Count:' + IntToStr(i_4ma_long_mbm_count)));

      if ((i_sum_4ma_long_mbm_count mod 5) = 0) then W_Log('MBM 4ma long sum', as_k_chg[i].i_date, i_mbm_log + 2, PChar('4MA OK! Count:' + IntToStr(i_sum_4ma_long_mbm_count) + ' vs 4ma short ' + IntToStr(i_sum_4ma_short_mbm_count)));

      i_4ma_mbm_long := m_i_long;
    end;

    i_4ma_mbm_long := m_i_long;
    i_4ma_short_mbm_count := 0;

    i_4ma_short_mbm_mark := 0;
    i_4ma_mbm_short := 888;

  end
  else
  begin
    i_4ma_long_mbm_mark := 0;
    i_4ma_mbm_long := 888;
  end;

end;

function ff_4ma_make_mbm_short(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  k: Integer;
begin

  Result := -1;

  if (i < 888) then Exit;

  if (
    (as_k_chg_ma_rsi[i - 1].ai_ma[6] > as_k_chg_ma_rsi[i - 1].ai_ma[5]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[i - 1].ai_ma[4]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[3] < as_k_chg_ma_rsi[i - 5].ai_ma[3]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[4] < as_k_chg_ma_rsi[i - 5].ai_ma[4]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] < as_k_chg_ma_rsi[i - 5].ai_ma[5]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[4] > as_k_chg_ma_rsi[i - 1].ai_ma[3])) then
  begin
    if (i_4ma_mbm_short = 888) then
    begin
      //check how long
      k := i;
      b := 0;
      for j := k - 888 to k do
      begin
        if (not (
          (as_k_chg_ma_rsi[j - 1].ai_ma[6] < as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[5] < as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[4] < as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
        begin
          if (not (
            (as_k_chg_ma_rsi[j - 1].ai_ma[6] > as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[5] > as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[4] > as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
          begin
            b := j;
            Break;
          end;
        end;
      end;

      if (b = 0) then Exit;
      if (i - b < 18) then Exit;



      i_4ma_short_mbm_mark := i;

      i_4ma_short_mbm_count_bak := i_4ma_short_mbm_count;

      i_4ma_short_mbm_count := i_4ma_short_mbm_count + 1;

      i_sum_4ma_short_mbm_count := i_sum_4ma_short_mbm_count + 1;

      if (i_4ma_short_mbm_count < 0) then W_Log('MBM 4ma_short', as_k_chg[i].i_date, i_mbm_log, PChar('4MA OK! Count:' + IntToStr(i_4ma_short_mbm_count)));

      if ((i_sum_4ma_short_mbm_count mod 5) = 0) then W_Log('MBM short 4ma sum', as_k_chg[i].i_date, i_mbm_log + 3, PChar('4MA OK! Count:' + IntToStr(i_sum_4ma_short_mbm_count) + ' vs 4ma long ' + IntToStr(i_sum_4ma_long_mbm_count)));

      i_4ma_mbm_short := m_i_short;
    end;

    i_4ma_mbm_short := m_i_short;

    i_4ma_long_mbm_count := 0;
    i_4ma_long_mbm_mark := 0;
    i_4ma_mbm_long := 888;

  end
  else
  begin
    i_4ma_short_mbm_mark := 0;
    i_4ma_mbm_short := 888;
  end;

end;




function ff_make_mbm_long(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  k: Integer;
begin

  Result := -1;

  if ((as_k_chg_ma_rsi[i].ai_ma[8] < as_k_chg_ma_rsi[i].ai_ma[6] + 40) and
    (as_k_chg_ma_rsi[i].ai_ma[6] < as_k_chg_ma_rsi[i].ai_ma[8] + 40)) then
  begin
    i_last_120ma250eq_index := i;
  end;

  if (i < 888) then Exit;

  if ((as_k_chg_ma_rsi[i - 1].ai_ma[8] < as_k_chg_ma_rsi[i - 1].ai_ma[6]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[6] < as_k_chg_ma_rsi[i - 1].ai_ma[5]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] < as_k_chg_ma_rsi[i - 1].ai_ma[4]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[3] > as_k_chg_ma_rsi[i - 5].ai_ma[3]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[4] > as_k_chg_ma_rsi[i - 5].ai_ma[4]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[i - 5].ai_ma[5]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[4] < as_k_chg_ma_rsi[i - 1].ai_ma[3])) then
  begin
    if (i_mbm_long = 888) then
    begin
      //check how long
      k := i;
      b := 0;
      for j := k - 888 to k do
      begin
        if (not ((as_k_chg_ma_rsi[j - 1].ai_ma[8] > as_k_chg_ma_rsi[j - 1].ai_ma[6]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[6] > as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[5] > as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[4] > as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
        begin
          if (not ((as_k_chg_ma_rsi[j - 1].ai_ma[8] < as_k_chg_ma_rsi[j - 1].ai_ma[6]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[6] < as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[5] < as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[4] < as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
          begin
            b := j;
            Break;
          end;
        end;
      end;

      if (b = 0) then Exit;
      if (i - b < 58) then Exit;


      if (i_long_mbm_count > 0) then
      begin
        if ((i - i_long_mbm_index) < 18) then Exit;
      end;


      i_long_mbm_mark := i;

      i_long_mbm_count_bak := i_long_mbm_count;
      i_long_mbm_count := i_long_mbm_count + 1;

      i_sum_long_mbm_count := i_sum_long_mbm_count + 1;

      if ((i_sum_long_mbm_count mod 5) = 0) then W_Log('MBM long sum', as_k_chg[i].i_date, i_mbm_log + 4, PChar('4MA OK! Count:' + IntToStr(i_sum_long_mbm_count) + ' vs short ' + IntToStr(i_sum_short_mbm_count)));

      if (i_long_mbm_count = 1) then i_long_mbm_count_action_1 := 1 else i_long_mbm_count_action_1 := 0;

      if (i_long_mbm_count < 3) and (i_long_mbm_count > 0) then
      begin

        Result := 0;

        if (i_long_mbm_count = 2) then Result := 0 else Result := 1;

        if (i_4ma_long_mbm_count > 4) and (i_long_mbm_count = 1) then Result := 0;

        //if( i_4ma_long_mbm_count <3 ) and ( i_long_mbm_count=2 ) Then Result :=1;

        //if( i_4ma_long_mbm_count >2 ) and ( i_long_mbm_count=3 ) Then Result :=0;

        {
        if(i_short_mbm_count >5) and ( i_long_mbm_count=1 ) Then Result :=1;
        //20120918 for test //
        if(i_short_mbm_count_bak >5) and ( i_long_mbm_count=2 ) Then Result :=1;

        if(i_short_mbm_count_bak >5) Then Result :=1;

        if(i_long_mbm_count_bak >5) and ( i_long_mbm_count=1 ) Then Result :=1;
        if(i_long_mbm_count_bak >5) and ( i_long_mbm_count=2 ) Then Result :=1;

        if(Result =0) Then W_Log('MBM long',as_k_chg[i].i_date,i_wk_log,PChar('MA OK! Count:'+IntToStr(i_long_mbm_count)) );
        }
        i_long_mbm_index := i;

      end;

      if (i_long_mbm_count < 88) then W_Log('MBM long', as_k_chg[i].i_date, i_mbm_log + 1, PChar('MA OK! Count:' + IntToStr(i_long_mbm_count)));

      i_mbm_long := m_i_long;
    end;

    i_mbm_long := m_i_long;
    f_mbm_cut_long := f_rsi_cut * 1.5;
    f_mbm_stop_long := f_rsi_stop * 2;

    i_long_mbm_index_1 := i;

    i_short_mbm_count := 0;

    i_short_mbm_mark := 0;
    i_mbm_short := 888;
    f_mbm_cut_short := 0.0;
    f_mbm_stop_short := 0.0;

  end
  else
  begin
    i_long_mbm_mark := 0;
    i_mbm_long := 888;
    f_mbm_cut_long := 0.0;
    f_mbm_stop_long := 0.0;
  end;

  if (i_mbm_long = m_i_long) and (as_k_chg[i].i_close < as_k_chg_ma_rsi[i].ai_ma[4]) then
  begin
    f_mbm_cut_long := 0.0;
    f_mbm_stop_long := 0.0;
  end;

  if (i_long_mbm_count_action_1 = 1) then
  begin
    //i_long_mbm_count_action_1:=0;
    //i_long_mbm_index :=i;
    //W_Log('MBM Action_1',as_k_chg[i].i_date,i_tmp_log,'MBM do long!!!' );
    //Result :=0;
    //Exit;
  end;


  if (i < i_short_mbm_index_1 + 168) then Exit;

  if (i - i_long_mbm_index < i_BB_BOX_X * 2) then Exit;

  if (i > i_long_mbm_mark + 58) then Exit;

  //if (i < i_long_mbm_mark + 3 ) Then Exit;
  //if (i > i_last_120ma250eq_index +78 ) Then Exit;

  if (i_long_mbm_count > 3) then Exit;

  if (i_mbm_long = m_i_long) and
     //(as_k_chg[i].i_close > ff_get_max_ij_high(i-3,i-1) ) and
  (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[3]) then
  begin
    //i_long_mbm_index :=i;
    //W_Log('MBM Action',as_k_chg[i].i_date,i_tmp_log,'Set MBM long lamp!!!' );
    //Result :=0;
  end;

end;


function ff_make_mbm_short(i: Integer): Integer;
var
  j: Integer;
  b: Integer;
  k: Integer;
begin

  Result := -1;

  if ((as_k_chg_ma_rsi[i].ai_ma[8] < as_k_chg_ma_rsi[i].ai_ma[6] + 40) and
    (as_k_chg_ma_rsi[i].ai_ma[6] < as_k_chg_ma_rsi[i].ai_ma[8] + 40)) then
  begin
    i_last_120ma250eq_index := i;
  end;

  if (i < 888) then Exit;

  if ((as_k_chg_ma_rsi[i - 1].ai_ma[8] > as_k_chg_ma_rsi[i - 1].ai_ma[6]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[6] > as_k_chg_ma_rsi[i - 1].ai_ma[5]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] > as_k_chg_ma_rsi[i - 1].ai_ma[4]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[3] < as_k_chg_ma_rsi[i - 5].ai_ma[3]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[4] < as_k_chg_ma_rsi[i - 5].ai_ma[4]) and
    (as_k_chg_ma_rsi[i - 1].ai_ma[5] < as_k_chg_ma_rsi[i - 5].ai_ma[5]) and

    (as_k_chg_ma_rsi[i - 1].ai_ma[4] > as_k_chg_ma_rsi[i - 1].ai_ma[3])) then
  begin
    if (i_mbm_short = 888) then
    begin
      //check how long
      k := i;
      b := 0;
      for j := k - 888 to k do
      begin
        if (not ((as_k_chg_ma_rsi[j - 1].ai_ma[8] < as_k_chg_ma_rsi[j - 1].ai_ma[6]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[6] < as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[5] < as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
          (as_k_chg_ma_rsi[j - 1].ai_ma[4] < as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
        begin
          if (not ((as_k_chg_ma_rsi[j - 1].ai_ma[8] > as_k_chg_ma_rsi[j - 1].ai_ma[6]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[6] > as_k_chg_ma_rsi[j - 1].ai_ma[5]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[5] > as_k_chg_ma_rsi[j - 1].ai_ma[4]) and
            (as_k_chg_ma_rsi[j - 1].ai_ma[4] > as_k_chg_ma_rsi[j - 1].ai_ma[3]))) then
          begin
            b := j;
            Break;
          end;
        end;
      end;

      if (b = 0) then Exit;
      if (i - b < 58) then Exit;

      if (i_short_mbm_count > 0) then
      begin
        if ((i - i_short_mbm_index) < 18) then Exit;
      end;

      i_short_mbm_mark := i;

      i_short_mbm_count_bak := i_short_mbm_count;

      i_short_mbm_count := i_short_mbm_count + 1;

      i_sum_short_mbm_count := i_sum_short_mbm_count + 1;
      if ((i_sum_short_mbm_count mod 5) = 0) then W_Log('MBM short sum', as_k_chg[i].i_date, i_mbm_log + 5, PChar('4MA OK! Count:' + IntToStr(i_sum_short_mbm_count) + ' vs 4ma long ' + IntToStr(i_sum_long_mbm_count)));

      if (i_short_mbm_count = 1) then i_short_mbm_count_action_1 := 1 else i_short_mbm_count_action_1 := 0;

      if (i_short_mbm_count < 3) and (i_short_mbm_count > 0) then
      begin
        Result := 0;

        if (i_short_mbm_count = 2) then Result := 0 else Result := 1;
        if (i_4ma_short_mbm_count > 4) and (i_short_mbm_count = 1) then Result := 0;
        //if( i_4ma_short_mbm_count <3 ) and ( i_short_mbm_count=2 ) Then Result :=1;
        //if( i_4ma_short_mbm_count >2 ) and ( i_short_mbm_count=3 ) Then Result :=0;

        {
        if(i_long_mbm_count >3) and ( i_short_mbm_count=1 ) Then Result :=1;
        //20120918 for test //
        if(i_long_mbm_count_bak >3) and ( i_short_mbm_count=2 ) Then Result :=1;
        if(i_short_mbm_count_bak >3) and ( i_short_mbm_count=1 ) Then Result :=1;
        if(i_short_mbm_count_bak >3) and ( i_short_mbm_count=2 ) Then Result :=1;
        if(Result =0) Then W_Log('MBM short',as_k_chg[i].i_date,i_wk_log,PChar('MA OK! Count:'+IntToStr(i_short_mbm_count)) );
        }
        i_short_mbm_index := i;

      end;


      if (i_short_mbm_count < 88) then W_Log('MBM short', as_k_chg[i].i_date, i_mbm_log, PChar('MA OK! Count:' + IntToStr(i_short_mbm_count)));

      i_mbm_short := m_i_short;
    end;

    i_mbm_short := m_i_short;
    f_mbm_cut_short := f_rsi_cut * 1.5;
    f_mbm_stop_short := f_rsi_stop * 2;

    i_short_mbm_index_1 := i;


    i_long_mbm_count := 0;
    i_long_mbm_mark := 0;
    i_mbm_long := 888;
    f_mbm_cut_long := 0.0;
    f_mbm_stop_long := 0.0;


  end
  else
  begin
    i_short_mbm_mark := 0;
    i_mbm_short := 888;
    f_mbm_cut_short := 0.0;
    f_mbm_stop_short := 0.0;

  end;

  if (i_mbm_short = m_i_short) and (as_k_chg[i].i_close > as_k_chg_ma_rsi[i].ai_ma[4]) then
  begin
    f_mbm_cut_short := 0.0;
    f_mbm_stop_short := 0.0;
  end;

  if (i_short_mbm_count_action_1 = 1) then
  begin
    //i_short_mbm_count_action_1:=0;
    //i_short_mbm_index :=i;
    //W_Log('MBM Action_1',as_k_chg[i].i_date,i_tmp_log,'MBM do short!' );
    //Result :=0;
    //Exit;
  end;

  if (i < i_long_mbm_index_1 + 168) then Exit;

  if (i - i_short_mbm_index < i_BB_BOX_X * 2) then Exit;

  if (i > i_short_mbm_mark + 58) then Exit;
  //if (i < i_short_mbm_mark +3 ) Then Exit;

  //if (i > i_last_120ma250eq_index +68 ) Then Exit;

  if (i_short_mbm_count > 3) then Exit;


  if (i_mbm_short = m_i_short) and
     //(as_k_chg[i].i_close < ff_get_min_ij_low(i-3,i-1) ) and
  (as_k_chg[i].i_close < as_k_chg_ma_rsi[i].ai_ma[3]) then
  begin
    //i_short_mbm_index :=i;
    //W_Log('MBM Action',as_k_chg[i].i_date,i_tmp_log,'Set MBM short lamp!!!' );
    //Result :=0;
  end;

end;


//end for big money


function ff_set_caption(): Integer;
var
  p, q: PChar;
  i_loop_wk: Integer;
begin
  MAINFORM.Label1.Caption := s_caption_1;
  MAINFORM.Label2.Caption := s_caption_2;
  MAINFORM.Label3.Caption := s_caption_3;
  MAINFORM.Label4.Caption := s_caption_4;
  MAINFORM.Label5.Caption := s_caption_5;
  MAINFORM.Label6.Caption := s_caption_6;
  MAINFORM.Label7.Caption := s_caption_7;
  MAINFORM.Label8.Caption := s_caption_8;
  MAINFORM.Label9.Caption := s_caption_9;
  MAINFORM.Label10.Caption := s_caption_10;
  MAINFORM.Label11.Caption := s_caption_11;
  MAINFORM.Label12.Caption := s_caption_12;
  MAINFORM.Label13.Caption := s_caption_13;
  MAINFORM.Label14.Caption := s_caption_14;
  MAINFORM.Label15.Caption := s_caption_15;
  MAINFORM.Label16.Caption := s_caption_16;
  MAINFORM.Label_status.Caption := s_caption_status;

  MAINFORM.Label_Vol.Caption := s_caption_vol;
  MAINFORM.Label_long_stp.Caption := s_caption_long_stp;
  MAINFORM.Label_short_stp.Caption := s_caption_short_stp;

  if (i_lock_short = 0) then MAINFORM.N5.Checked := False;
  if (i_lock_long = 0) then MAINFORM.N4.Checked := False;
  if (i_lock_short > 0) then MAINFORM.N5.Checked := True;
  if (i_lock_long > 0) then MAINFORM.N4.Checked := True;

  if MAINFORM.N4.Checked = True then s_caption_15 := '��' else s_caption_15 := ' ';
  if MAINFORM.N5.Checked = True then s_caption_16 := '��' else s_caption_16 := ' ';

  if (i_stp_short = 0) then MAINFORM.Short_STP.Checked := False;
  if (i_stp_long = 0) then MAINFORM.Long_STP.Checked := False;
  if (i_stp_short > 0) then MAINFORM.Short_STP.Checked := True;
  if (i_stp_long > 0) then MAINFORM.Long_STP.Checked := True;

  if MAINFORM.Short_STP.Checked = True then s_caption_short_stp := '+' else s_caption_short_stp := ' ';
  if MAINFORM.Long_STP.Checked = True then s_caption_long_stp := '+' else s_caption_long_stp := ' ';

  if (StrLen(PChar(MAINFORM.Edit_vol_chk.Text)) > 2) then i_chk_power_vol_wk := StrToInt(MAINFORM.Edit_vol_chk.Text)
  else i_chk_power_vol_wk := 1000;

  MAINFORM.Label_up_power.Caption := '�෽���� ' + IntToStr(i_up_count_ex) + ' : ' + IntToStr(i_up_vol_sum);
  MAINFORM.Label_down_power.Caption := '�շ����� ' + IntToStr(i_down_count_ex) + ' : ' + IntToStr(i_down_vol_sum);

  if i_show_string_grid < 1 then
  begin
    MAINFORM.Height := 418;
  end
  else
  begin
    MAINFORM.ff_sg.Height := 558;
    MAINFORM.Height := 988;
    MAINFORM.Top := 1;
    MAINFORM.Left := 1;

    for i_loop_wk := 0 to i_fc_count - 1 do
    begin
      MAINFORM.ff_sg.Cells[0, i_loop_wk + 1] := as_fc_data[i_loop_wk].pc_username;
      MAINFORM.ff_sg.Cells[1, i_loop_wk + 1] := as_fc_data[i_loop_wk].pc_xxx_name;
      MAINFORM.ff_sg.Cells[2, i_loop_wk + 1] := IntToStr(as_fc_data[i_loop_wk].i_got_it_mark);

      if (as_fc_data[i_loop_wk].i_got_it_mark > 0) then
      begin
        MAINFORM.ff_sg.Cells[2, i_loop_wk + 1] := FloatToStrF(as_fc_data[i_loop_wk].f_business_price, ffFixed, 8, 2);
        MAINFORM.ff_sg.Cells[3, i_loop_wk + 1] := IntToStr(as_fc_data[i_loop_wk].i_got_it_mark);
      end
      else
      begin
        MAINFORM.ff_sg.Cells[2, i_loop_wk + 1] := ' ';
        MAINFORM.ff_sg.Cells[3, i_loop_wk + 1] := ' ';
      end;

      if (as_fc_data[i_loop_wk].i_short_mark > 0) then
      begin
        MAINFORM.ff_sg.Cells[4, i_loop_wk + 1] := FloatToStrF(as_fc_data[i_loop_wk].f_short_price, ffFixed, 8, 2);
        MAINFORM.ff_sg.Cells[5, i_loop_wk + 1] := IntToStr(as_fc_data[i_loop_wk].i_short_mark);
      end
      else
      begin
        MAINFORM.ff_sg.Cells[4, i_loop_wk + 1] := ' ';
        MAINFORM.ff_sg.Cells[5, i_loop_wk + 1] := ' ';
      end;
      MAINFORM.ff_sg.Cells[6, i_loop_wk + 1] := FloatToStrF(as_fc_data[i_loop_wk].f_rights_balance, ffFixed, 11, 2);
    end;
  end;

  if (StrLen(PChar(MAINFORM.Edit_open_price.Text)) > 3) then
  begin
    FillChar(c_open_price, SizeOf(c_open_price), 0);
    StrCopy(c_open_price, PChar(MAINFORM.Edit_open_price.Text));
  end;

  if (StrLen(c_open_price) > 3) then
  begin
    i_open_vol := 0;
    q := StrPos(c_open_price, ':');
    if (q <> nil) then
    begin
      q[0] := #0;
      p := @q[1];
      i_open_price := StrToInt(c_open_price);
      if (StrLen(p) > 0) then i_open_vol := StrToInt(p);
    end
    else
      i_open_price := StrToInt(c_open_price)
  end
  else i_open_price := 0;

end;



function ff_load_k_base(): Integer;
var
 //iFileHandle : Integer;
  iFileLength: Integer;
  iBytesRead: Integer;
  i: Integer;
  k_line_file_name: string;
  pc_Buffer: PChar;

begin

  Result := 0;

  FillChar(as_k_chg, SizeOf(as_k_chg), 0);
  FillChar(as_k_chg_ma_rsi, sizeof(as_k_chg_ma_rsi), 0);

  pc_Buffer := @as_k_chg[0];

  tm_0 := Now;
  tm_1 := Now;

  k_line_file_name := m_k_line_file_name;

  if not FileExists(k_line_file_name) then
  begin
    iFileHandle := FileCreate(k_line_file_name);
    FileClose(iFileHandle);
  end;

  iFileHandle := FileOpen(k_line_file_name, fmOpenRead);
  if iFileHandle > -1 then
  begin
    iFileLength := FileSeek(iFileHandle, 0, 2);
    FileSeek(iFileHandle, 0, 0);

    if (iFileLength > (m_i_max_chg_kline_in_mem - 5888) * SizeOf(s_k_line_data)) then
      FileSeek(iFileHandle,
        iFileLength - (m_i_max_chg_kline_in_mem - 5888) * SizeOf(s_k_line_data), 0);

    iBytesRead := FileRead(iFileHandle, pc_Buffer^, iFileLength);
    FileClose(iFileHandle);
  end
  else Exit;

  DeleteFile(k_line_file_name);
  iFileHandle := FileCreate(k_line_file_name);


  if iBytesRead > 0 then
  begin

    for i := 0 to Round(iBytesRead / SizeOf(s_k_line_data) - 1) do
    begin
      if (as_k_chg[i].i_open > 0) and (as_k_chg[i].i_low > 0) then
        FileWrite(iFileHandle, as_k_chg[i], SizeOf(s_k_line_data));
    end;
    i_s_k_chg_index_wk := Round(iBytesRead / SizeOf(s_k_line_data)) - 1 + 1;
    i_s_k_chg_index_load := Round(iBytesRead / SizeOf(s_k_line_data));
    i_as_k_base_init_flag := 888;
    i_as_k_chg_init_flag := 888;

    as_k_chg[i_s_k_chg_index_wk].i_open := as_k_chg[i_s_k_chg_index_wk - 1].i_open;
    as_k_chg[i_s_k_chg_index_wk].i_close := as_k_chg[i_s_k_chg_index_wk - 1].i_close;
    as_k_chg[i_s_k_chg_index_wk].i_high := as_k_chg[i_s_k_chg_index_wk - 1].i_high;
    as_k_chg[i_s_k_chg_index_wk].i_low := as_k_chg[i_s_k_chg_index_wk - 1].i_low;

    for i := 0 to i_s_k_chg_index_wk do ff_make_ma_rsi_ex(i);

  end
  else i_s_k_chg_index_wk := 0;

  FileClose(iFileHandle);

end;

function ff_passwd_chg(
  pc_account: PChar;
  pc_password_type: PChar;
  pc_old_password: PChar;
  pc_new_password: PChar): Integer;
var
  iRet: Integer;
  lpReqMsg, lpAnsMsg: IFuMessage;
  lpRecord, lpAnsRecord: IFuRecord;
  c_log: array[0..88] of char;

begin
  Result := 0;

  if not Assigned(m_lpComm) then Exit;
  if (i_comm_ok = 0) then Exit;

 //ҵ�����ί���µ�
  lpReqMsg := NewFuMessage(MSG_TYPE_MODIFY_PASSWORD, Integer(MSG_MODE_REQUEST)); //�ͻ��޸�����
  lpAnsMsg := NewFuMessage(MSG_TYPE_UNKNOWN, Integer(MSG_MODE_ANSWER)); //������Ϣ(�޹���Ϣ����)

 //����������(�ֶ�˳���޹�,�ظ������ֶ��򸲸���ֵ)
  lpRecord := lpReqMsg.AddRecord();


  lpRecord.SetString('fund_account', pc_account);
  lpRecord.SetString('password_type', pc_password_type);
  lpRecord.SetString('password', pc_old_password);
  lpRecord.SetString('new_password', pc_new_password);

 //ͬ��������Ϣ
  iRet := m_lpComm.SyncSendRecv(lpReqMsg, lpAnsMsg);
  if iRet <> 0 then
  begin
  //cout<<"ͬ��ί��ʧ��:iRet="<<iRet<<" msg:"<<lpComm->GetErrorMsg(iRet)<<endl;
    W_Log('ff_passwd_chg', iRet, i_wk_log, PChar(m_lpComm.GetErrorMsg(iRet)));
    lpReqMsg.Release();
    lpAnsMsg.Release();
    Exit;
  end
  else
  begin
  //cout<<"ͬ��ί�гɹ�!"<<endl;
  end;
 //Form1.ShowFuMessage(lpAnsMsg);


  if lpAnsMsg.GetCount() > 0 then
  begin
    lpAnsRecord := lpAnsMsg.GetRecord(0);
    FillChar(c_log, SizeOf(c_log), 0);
    StrCopy(c_log, lpAnsRecord.GetString('result'));

    W_Log(pc_new_password, i_tmp_log, i_wk_log, c_log);
  end;

  lpReqMsg.Release();
  lpAnsMsg.Release();
end;






function ff_order_ex(
  pc_contract_code: PChar;
  pc_entrust_price: PChar;
  pc_entrust_amount: PChar;
  pc_entrust_bs: PChar;
  pc_direction: PChar): Integer;
var
  iRet: Integer;
  lpReqMsg, lpAnsMsg: IFuMessage;
  lpRecord, lpAnsRecord: IFuRecord;
begin
  Result := 0;

  if not Assigned(m_lpComm) then Exit;
  if (i_comm_ok = 0) then Exit;

 //ҵ�����ί���µ�
  lpReqMsg := NewFuMessage(MSG_TYPE_NEW_SINGLE_ORDER, Integer(MSG_MODE_REQUEST)); //ί���µ�
  lpAnsMsg := NewFuMessage(MSG_TYPE_UNKNOWN, Integer(MSG_MODE_ANSWER)); //������Ϣ(�޹���Ϣ����)

 //����������(�ֶ�˳���޹�,�ظ������ֶ��򸲸���ֵ)
  lpRecord := lpReqMsg.AddRecord();


  lpRecord.SetString('fund_account', pc_username);
 //lpRecord.SetString('password',pc_user_pwd);
  lpRecord.SetString('futu_exch_type', 'F4');
  lpRecord.SetString('futures_account', '');
  lpRecord.SetString('contract_code', pc_contract_code);
 //buy
  lpRecord.SetString('entrust_bs', pc_entrust_bs);
 //long,open
  lpRecord.SetString('futures_direction', pc_direction);

  lpRecord.SetString('hedge_type', '0');
  lpRecord.SetString('futu_entrust_prop', '0');


  lpRecord.SetString('futu_entrust_price', pc_entrust_price);

  lpRecord.SetString('entrust_amount', pc_entrust_amount);

  lpRecord.SetString('entrust_kind', '0');

 //ͬ��������Ϣ
  iRet := m_lpComm.SyncSendRecv(lpReqMsg, lpAnsMsg);
  if iRet <> 0 then
  begin

    if lpAnsMsg.GetCount() > 0 then
    begin

      lpAnsRecord := lpAnsMsg.GetRecord(0);
      FillChar(c_error_no, SizeOf(c_error_no), 0);
      FillChar(c_error_info, SizeOf(c_error_info), 0);

      StrCopy(c_error_no, lpAnsRecord.GetString('error_no'));
      StrCopy(c_error_info, lpAnsRecord.GetString('error_info'));

      W_Log('order_ex_error', iRet, i_wk_log, c_error_no);
      W_Log('order_ex_error', iRet, i_wk_log, c_error_info);

    end;


  //cout<<"ͬ��ί��ʧ��:iRet="<<iRet<<" msg:"<<lpComm->GetErrorMsg(iRet)<<endl;
    W_Log('order_ex', iRet, i_wk_log, PChar(m_lpComm.GetErrorMsg(iRet)));
    lpReqMsg.Release();
    lpAnsMsg.Release();
    Exit;
  end
  else
  begin
  //cout<<"ͬ��ί�гɹ�!"<<endl;
    W_Log('order_ex', 8888, i_wk_log, 'ͬ��ί�гɹ�!!');
  end;
 //Form1.ShowFuMessage(lpAnsMsg);


  if lpAnsMsg.GetCount() > 0 then
  begin
    lpAnsRecord := lpAnsMsg.GetRecord(0);
    FillChar(c_batch_no, SizeOf(c_batch_no), 0);
    FillChar(c_entrust_no, SizeOf(c_entrust_no), 0);

    StrCopy(c_entrust_no, lpAnsRecord.GetString('entrust_no'));
    StrCopy(c_entrust_no, lpAnsRecord.GetString('batch_no'));
  end;

  lpReqMsg.Release();
  lpAnsMsg.Release();
end;



function ff_entrust_no(pc_contract_code: PChar): Integer;
var
  iRet: Integer;
  lpReqMsg, lpAnsMsg: IFuMessage;
  lpRecord, lpAnsRecord: IFuRecord;
begin
  Result := 0;

  if not Assigned(m_lpComm) then Exit;
  if (i_comm_ok = 0) then Exit;

  FillChar(c_batch_no, SizeOf(c_batch_no), 0);
  FillChar(c_entrust_no, SizeOf(c_entrust_no), 0);


 //ҵ�����ί���µ�
  lpReqMsg := NewFuMessage(MSG_TYPE_GET_ENTRUST_ORDERS, Integer(MSG_MODE_REQUEST)); //ί���µ�
  lpAnsMsg := NewFuMessage(MSG_TYPE_UNKNOWN, Integer(MSG_MODE_ANSWER)); //������Ϣ(�޹���Ϣ����)

 //����������(�ֶ�˳���޹�,�ظ������ֶ��򸲸���ֵ)
  lpRecord := lpReqMsg.AddRecord();


  lpRecord.SetString('fund_account', pc_username);
 //lpRecord.SetString('password',pc_user_pwd);
  lpRecord.SetString('futu_exch_type', 'F4');
  lpRecord.SetString('futures_account', '');
  lpRecord.SetString('contract_code', pc_contract_code);

  lpRecord.SetString('en_entrust_status', '012347C');
  lpRecord.SetString('query_direction', '0');

  lpRecord.SetString('futu_entrust_type', '0');

 //ͬ��������Ϣ
  iRet := m_lpComm.SyncSendRecv(lpReqMsg, lpAnsMsg);
  if iRet <> 0 then
  begin
  //cout<<"ͬ��ί��ʧ��:iRet="<<iRet<<" msg:"<<lpComm->GetErrorMsg(iRet)<<endl;
    W_Log('ff_entrust_no', iRet, i_wk_log, PChar(m_lpComm.GetErrorMsg(iRet)));
    lpReqMsg.Release();
    lpAnsMsg.Release();
    Exit;
  end
  else
  begin
  //cout<<"ͬ��ί�гɹ�!"<<endl;
  end;
 //Form1.ShowFuMessage(lpAnsMsg);

  iRet := lpAnsMsg.GetCount;

  if lpAnsMsg.GetCount() > 0 then
  begin

    lpAnsRecord := lpAnsMsg.GetRecord(0);
    FillChar(c_batch_no, SizeOf(c_batch_no), 0);
    FillChar(c_entrust_no, SizeOf(c_entrust_no), 0);

    StrCopy(c_entrust_no, lpAnsRecord.GetString('entrust_no'));
    StrCopy(c_entrust_no, lpAnsRecord.GetString('batch_no'));

    i_entrust_no_mark := 888;

  end;

  lpReqMsg.Release();
  lpAnsMsg.Release();

end;


function ff_cancel_entrust_no(): Integer;
var
  iRet: Integer;
  lpReqMsg, lpAnsMsg: IFuMessage;
  lpRecord: IFuRecord;
  lpAnsRecord: IFuRecord;

begin
  Result := 0;

  iRet := StrLen(c_entrust_no);
  if (iRet = 0) then Exit;

  if not Assigned(m_lpComm) then Exit;
  if (i_comm_ok = 0) then Exit;

 //ҵ�����ί���µ�
  lpReqMsg := NewFuMessage(MSG_TYPE_CANCEL_ORDER, Integer(MSG_MODE_REQUEST));
  lpAnsMsg := NewFuMessage(MSG_TYPE_UNKNOWN, Integer(MSG_MODE_ANSWER)); //������Ϣ(�޹���Ϣ����)

 //����������(�ֶ�˳���޹�,�ظ������ֶ��򸲸���ֵ)
  lpRecord := lpReqMsg.AddRecord();

  lpRecord.SetString('fund_account', pc_username);
 //lpRecord.SetString('password',pc_user_pwd);
  lpRecord.SetString('futu_exch_type', 'F4');
  lpRecord.SetString('entrust_no', c_entrust_no); //ί�к�

 //ͬ��������Ϣ
  iRet := m_lpComm.SyncSendRecv(lpReqMsg, lpAnsMsg);
  if iRet <> 0 then
  begin

    if lpAnsMsg.GetCount() > 0 then
    begin

      lpAnsRecord := lpAnsMsg.GetRecord(0);
      FillChar(c_error_no, SizeOf(c_error_no), 0);
      FillChar(c_error_info, SizeOf(c_error_info), 0);

      StrCopy(c_error_no, lpAnsRecord.GetString('error_no'));
      StrCopy(c_error_info, lpAnsRecord.GetString('error_info'));

      W_Log('cancel_error', iRet, i_wk_log, c_error_no);
      W_Log('cancel_error', iRet, i_wk_log, c_error_info);

    end;


  //cout<<"ͬ��ί��ʧ��:iRet="<<iRet<<" msg:"<<lpComm->GetErrorMsg(iRet)<<endl;
    W_Log('ff_cancel_entrust_no', iRet, i_wk_log, PChar(m_lpComm.GetErrorMsg(iRet)));
    lpReqMsg.Release();
    lpAnsMsg.Release();
    Exit;
  end
  else
  begin
  //cout<<"ͬ��ί�гɹ�!"<<endl;
  end;
 //Form1.ShowFuMessage(lpAnsMsg);

  lpReqMsg.Release();
  lpAnsMsg.Release();

end;


function ff_get_qty(): Integer;
var
  iRet: Integer;
  lpReqMsg, lpAnsMsg: IFuMessage;
  lpRecord, lpAnsRecord: IFuRecord;
  c_log: array[0..88] of char;
  s_tmp: string;
  s_tmp1: string;

  I, i_get_count: Integer;

begin
  Result := 0;

  if not Assigned(m_lpComm) then Exit;

  if (i_comm_ok = 0) then Exit;

  //for
  i_short_mark := 0;
  i_got_it_mark := 0;

 //ҵ�����ί���µ�
  lpReqMsg := NewFuMessage(MSG_TYPE_GET_HOLDSINFO, Integer(MSG_MODE_REQUEST)); //ί���µ�
  lpAnsMsg := NewFuMessage(MSG_TYPE_UNKNOWN, Integer(MSG_MODE_ANSWER)); //������Ϣ(�޹���Ϣ����)

 //����������(�ֶ�˳���޹�,�ظ������ֶ��򸲸���ֵ)
  lpRecord := lpReqMsg.AddRecord();


  lpRecord.SetString('fund_account', pc_username);
 //lpRecord.SetString('password',pc_user_pwd);
  lpRecord.SetString('futu_exch_type', '');

  lpRecord.SetString('futures_account', '');
  lpRecord.SetString('contract_code', '');
  lpRecord.SetString('entrust_bs', '');
  lpRecord.SetString('query_direction', '0');
  lpRecord.SetString('query_mode', '1');
  lpRecord.SetString('request_num', '50');
  lpRecord.SetString('action_in', '');
  lpRecord.SetString('position_str', '0');
  lpRecord.SetString('switch_type', '1');

  iRet := m_lpComm.SyncSendRecv(lpReqMsg, lpAnsMsg);

 //Form1.ShowFuMessage(lpAnsMsg);

  i_get_count := 0;
  if (iRet = 0) then i_get_count := lpAnsMsg.GetCount;

  if (iRet = 0) and (i_get_count > 0) then
  begin
    for I := 0 to i_get_count - 1 do
    begin
      lpAnsRecord := lpAnsMsg.GetRecord(I);
      FillChar(c_log, SizeOf(c_log), 0);

      StrCopy(c_log, lpAnsRecord.GetString('contract_code'));
      s_tmp := c_log;
      s_tmp1 := pc_what_wk;

      FillChar(c_log, SizeOf(c_log), 0);

      StrCopy(c_log, lpAnsRecord.GetString('entrust_bs'));
      if c_log[0] = '2' then
      begin
        if (s_tmp = s_tmp1) then
        begin

          StrCopy(c_log, lpAnsRecord.GetString('futu_average_price'));
          f_short_price := StrToFloat(c_log);


          s_caption_9 := '��  ' + Trim(c_log);

          FillChar(c_log, SizeOf(c_log), 0);
          StrCopy(c_log, lpAnsRecord.GetString('real_amount'));


          i_short_mark := Round(StrToFloat(c_log));

          s_caption_11 := Trim(c_log);

          if (i_short_mark > (i_F + i_S - 1)) then i_short_S_mark := 888 else i_short_S_mark := 0;
          if (i_short_mark > (i_F + i_S + i_T - 1)) then i_short_T_mark := 888 else i_short_T_mark := 0;
        end
      end
      else if c_log[0] = '1' then
      begin
        if (s_tmp = s_tmp1) then
        begin

          StrCopy(c_log, lpAnsRecord.GetString('futu_average_price'));

          f_business_price := StrToFloat(c_log);

          s_caption_8 := '��  ' + Trim(c_log);

          FillChar(c_log, SizeOf(c_log), 0);

          StrCopy(c_log, lpAnsRecord.GetString('real_amount'));

          s_caption_10 := Trim(c_log);

          i_got_it_mark := Round(StrToFloat(c_log));

          if (i_got_it_mark > (i_F + i_S - 1)) then i_get_S_mark := 888 else i_get_S_mark := 0;
          if (i_got_it_mark > (i_F + i_S + i_T - 1)) then i_get_T_mark := 888 else i_get_T_mark := 0;
        end;
      end;
    end;
  end
  else
  begin

    i_got_it_mark := 0;
    i_get_S_mark := 0;
    i_get_T_mark := 0;
    i_short_mark := 0;
    i_short_S_mark := 0;
    i_short_T_mark := 0;

    //frmMain2.GRID_S001.Cells[0,0]:=pc_what_wk;

  end;

  lpReqMsg.Release();
  lpAnsMsg.Release();

  if (i_long_act_flag = -1) and (i_got_it_mark = 0) then i_long_act_flag := 1;
  if (i_short_act_flag = -1) and (i_short_mark = 0) then i_short_act_flag := 1;

end;


function ff_get_qty_ex(): Integer;
var
  iRet: Integer;
  lpReqMsg, lpAnsMsg: IFuMessage;
  lpRecord, lpAnsRecord: IFuRecord;
  c_log: array[0..88] of char;
  s_tmp: string;
  s_tmp1: string;

  I, i_get_count: Integer;

begin
  Result := 0;

  if not Assigned(m_lpComm) then Exit;

  if (i_comm_ok = 0) then Exit;

  //for
  i_short_mark_ex := 0;
  i_got_it_mark_ex := 0;
  f_short_price_ex := 0.0;
  f_business_price_ex := 0.0;

 //ҵ�����ί���µ�
  lpReqMsg := NewFuMessage(MSG_TYPE_GET_HOLDSINFO, Integer(MSG_MODE_REQUEST)); //ί���µ�
  lpAnsMsg := NewFuMessage(MSG_TYPE_UNKNOWN, Integer(MSG_MODE_ANSWER)); //������Ϣ(�޹���Ϣ����)

 //����������(�ֶ�˳���޹�,�ظ������ֶ��򸲸���ֵ)
  lpRecord := lpReqMsg.AddRecord();


  lpRecord.SetString('fund_account', pc_username);
 //lpRecord.SetString('password',pc_user_pwd);
  lpRecord.SetString('futu_exch_type', '');

  lpRecord.SetString('futures_account', '');
  lpRecord.SetString('contract_code', '');
  lpRecord.SetString('entrust_bs', '');
  lpRecord.SetString('query_direction', '0');
  lpRecord.SetString('query_mode', '1');
  lpRecord.SetString('request_num', '50');
  lpRecord.SetString('action_in', '');
  lpRecord.SetString('position_str', '0');
  lpRecord.SetString('switch_type', '1');

  iRet := m_lpComm.SyncSendRecv(lpReqMsg, lpAnsMsg);

 //Form1.ShowFuMessage(lpAnsMsg);

  i_get_count := 0;
  if (iRet = 0) then i_get_count := lpAnsMsg.GetCount;

  if (iRet = 0) and (i_get_count > 0) then
  begin
    for I := 0 to i_get_count - 1 do
    begin
      lpAnsRecord := lpAnsMsg.GetRecord(I);
      FillChar(c_log, SizeOf(c_log), 0);

      StrCopy(c_log, lpAnsRecord.GetString('contract_code'));
      s_tmp := c_log;
      s_tmp1 := pc_what_wk;

      FillChar(c_log, SizeOf(c_log), 0);

      StrCopy(c_log, lpAnsRecord.GetString('entrust_bs'));
      if c_log[0] = '2' then
      begin
        if (s_tmp = s_tmp1) then
        begin

          StrCopy(c_log, lpAnsRecord.GetString('futu_average_price'));

          f_short_price_ex := StrToFloat(c_log);

          FillChar(c_log, SizeOf(c_log), 0);
          StrCopy(c_log, lpAnsRecord.GetString('real_amount'));

          i_short_mark_ex := Round(StrToFloat(c_log));
        end
      end
      else if c_log[0] = '1' then
      begin
        if (s_tmp = s_tmp1) then
        begin

          StrCopy(c_log, lpAnsRecord.GetString('futu_average_price'));

          f_business_price_ex := StrToFloat(c_log);

          FillChar(c_log, SizeOf(c_log), 0);

          StrCopy(c_log, lpAnsRecord.GetString('real_amount'));

          i_got_it_mark_ex := Round(StrToFloat(c_log));
        end;
      end;
    end;
  end
  else
  begin
    i_short_mark_ex := 0;
    i_got_it_mark_ex := 0;
    f_short_price_ex := 0.0;
    f_business_price_ex := 0.0;
  end;

  lpReqMsg.Release();
  lpAnsMsg.Release();
end;


//20130221

function ff_get_profit(): Integer;
var
  iRet: Integer;
  lpReqMsg, lpAnsMsg: IFuMessage;
  lpRecord, lpAnsRecord: IFuRecord;
begin
  Result := 0;

  if not Assigned(m_lpComm) then Exit;
  if (i_comm_ok = 0) then Exit;

  FillChar(c_batch_no, SizeOf(c_batch_no), 0);
  FillChar(c_entrust_no, SizeOf(c_entrust_no), 0);


 //ҵ�����ί���µ�
  lpReqMsg := NewFuMessage(MSG_TYPE_GET_PROFIT, Integer(MSG_MODE_REQUEST)); //ί���µ�
  lpAnsMsg := NewFuMessage(MSG_TYPE_UNKNOWN, Integer(MSG_MODE_ANSWER)); //������Ϣ(�޹���Ϣ����)

 //����������(�ֶ�˳���޹�,�ظ������ֶ��򸲸���ֵ)
  lpRecord := lpReqMsg.AddRecord();


  lpRecord.SetString('fund_account', pc_username);
 //lpRecord.SetString('password',pc_user_pwd);
  lpRecord.SetString('money_type', '0');

 //ͬ��������Ϣ
  iRet := m_lpComm.SyncSendRecv(lpReqMsg, lpAnsMsg);
  if iRet <> 0 then
  begin
  //cout<<"ͬ��ί��ʧ��:iRet="<<iRet<<" msg:"<<lpComm->GetErrorMsg(iRet)<<endl;
    W_Log('ff_get_profit', iRet, i_wk_log, PChar(m_lpComm.GetErrorMsg(iRet)));
    lpReqMsg.Release();
    lpAnsMsg.Release();
    Exit;
  end
  else
  begin
  //cout<<"ͬ��ί�гɹ�!"<<endl;
  end;
 //Form1.ShowFuMessage(lpAnsMsg);

  i_rights_balance := 0;
  f_rights_balance := 0.0;

  if lpAnsMsg.GetCount() > 0 then
  begin
    lpAnsRecord := lpAnsMsg.GetRecord(0);
    FillChar(c_rights_balance, SizeOf(c_rights_balance), 0);
    StrCopy(c_rights_balance, lpAnsRecord.GetString('rights_balance'));
    f_rights_balance := StrToFloat(c_rights_balance);
    i_rights_balance := Round(StrToFloat(c_rights_balance) / 10000);
  end;

  lpReqMsg.Release();
  lpAnsMsg.Release();


end;

//20130221 end



function ff_main_wk_loop(): Integer;
var
  i_loop_wk, i_loop, i_tmp: Integer;
  i_tmp_1: Integer;
  i_tmp_2: Integer;
  i_tmp_3: Integer;
  i_tmp_4: Integer;
  i_tmp_5: Integer;
  i_tmp_6: Integer;
  i_tmp_7: Integer;
  i_tmp_8: Integer;
  i_index_8: Integer;

  i_tmp_9: Integer;

  s_tmp, s_tmp1: string;

  pc_username_bak: PChar;


begin
  Result := 0;

  i_line_no_001 := 1;
  i_line_no_001 := i_line_no_001 + 1;

  if i_only_1 = 1 then s_caption_14 := '����' else s_caption_14 := 'Ⱥ��';

  if (i_comm_ok = 0) then
  begin
    //frmMain2.GRID_S006.Cells[0,0]:='�Ͽ�';
    s_caption_3 := '�Ͽ�';
    Exit;
  end
  else
  begin
    //frmMain2.GRID_S006.Cells[0,0]:='����';
    s_caption_3 := '����';
  end;

  if i_do_ff_qty_loop > 0 then
  begin
    i_do_ff_qty_loop := 0;
    for i_loop_wk := 0 to i_fc_count - 1 do
    begin
      pc_username := as_fc_data[i_loop_wk].pc_username;
      ff_get_qty_ex();
      ff_get_profit();
      as_fc_data[i_loop_wk].i_short_mark := i_short_mark_ex;
      as_fc_data[i_loop_wk].i_got_it_mark := i_got_it_mark_ex;
      as_fc_data[i_loop_wk].i_rights_balance := i_rights_balance;
      as_fc_data[i_loop_wk].f_short_price := f_short_price_ex;
      as_fc_data[i_loop_wk].f_business_price := f_business_price_ex;
      as_fc_data[i_loop_wk].f_rights_balance := f_rights_balance;
    end;
  end;

  pc_username := as_fc_data[i_fc_wk_index].pc_username;
  s_caption_7 := pc_username;
  s_caption_13 := as_fc_data[i_fc_wk_index].pc_xxx_name;

  i_line_no_001 := i_line_no_001 + 1;

  if (i_no_trade = 0) then
  begin
    //s_caption_4:='�Զ�';
  end
  else
  begin
    //s_caption_4:='�ֶ�';
  end;
  i_line_no_001 := i_line_no_001 + 1;


  if (i_long_mbm_count > 0) then
  begin
    //frmMain2.GRID_S002.Cells[0,0]:='L5    ' + IntToStr(i_long_mbm_count);
    //frmMain2.GRID_S002.Cells[1,0]:='L4    ' + IntToStr(i_4ma_long_mbm_count);
  end;
  i_line_no_001 := i_line_no_001 + 1;

  if (i_short_mbm_count > 0) then
  begin
    //frmMain2.GRID_S002.Cells[0,0]:='S5    ' + IntToStr(i_short_mbm_count);
    //frmMain2.GRID_S002.Cells[1,0]:='S4    ' + IntToStr(i_4ma_short_mbm_count);
  end;

  i_line_no_001 := i_line_no_001 + 1;

  //for i_sum_long_mbm_count ... ...
  if (1 > 0) then
  begin
    //frmMain2.GRID_S003.Cells[0,0]:='SL5    ';
    //frmMain2.GRID_S003.Cells[1,0]:=IntToStr(i_sum_long_mbm_count);
    //frmMain2.GRID_S003.Cells[0,1]:='SS5    ';
    //frmMain2.GRID_S003.Cells[1,1]:=IntToStr(i_sum_short_mbm_count);
    //frmMain2.GRID_S003.Cells[0,2]:='SD5    ';
    //frmMain2.GRID_S003.Cells[1,2]:=IntToStr(i_sum_long_mbm_count-i_sum_short_mbm_count);

    //frmMain2.GRID_S003.Cells[0,3]:='SL4    ';
    //frmMain2.GRID_S003.Cells[1,3]:=IntToStr(i_sum_4ma_long_mbm_count);
    //frmMain2.GRID_S003.Cells[0,4]:='SS4    ';
    //frmMain2.GRID_S003.Cells[1,4]:=IntToStr(i_sum_4ma_short_mbm_count);
    //frmMain2.GRID_S003.Cells[0,5]:='SD4    ';
    //frmMain2.GRID_S003.Cells[1,5]:=IntToStr(i_sum_4ma_long_mbm_count-i_sum_4ma_short_mbm_count);

  end;

  i_line_no_001 := i_line_no_001 + 1;


  //frmMain2.GRID_S002.Cells[0,1]:='RSI';
  //frmMain2.GRID_S002.Cells[1,1]:=FloatToStrF(as_k_chg_ma_rsi[i_s_k_chg_index_wk].ai_rsi[0]/100,ffFixed,7,2);
  i_line_no_001 := i_line_no_001 + 1;

  if not Assigned(m_lpComm) then Exit;
  if (i_comm_ok = 0) then Exit;


  ff_chk_power_vol(i_s_k_chg_index_wk);


  i_line_no_001 := i_line_no_001 + 1;
  //for get K line Only
  if (i_make_k_only > 0) then Exit;
  i_line_no_001 := i_line_no_001 + 1;


  if i_do_ff_qty_loop > 0 then
  begin
    i_do_ff_qty_loop := 0;
    for i_loop_wk := 0 to i_fc_count - 1 do
    begin
      ff_get_qty();
      ff_get_profit();
      as_fc_data[i_loop_wk].i_short_mark := i_short_mark;
      as_fc_data[i_loop_wk].i_got_it_mark := i_got_it_mark;
      as_fc_data[i_loop_wk].i_rights_balance := i_rights_balance;
    end;
  end;


  if (i_fc_wk_index_bak <> i_fc_wk_index) then
  begin
    s_caption_8 := '    ';
    s_caption_9 := '    ';
    s_caption_10 := '    ';
    s_caption_11 := '    ';

    i_fc_wk_index_bak := i_fc_wk_index;
    ff_get_qty();
    ff_get_profit();
    as_fc_data[i_fc_wk_index].i_rights_balance := i_rights_balance;
    s_caption_4 := c_rights_balance;
  end;

  if (i_short_mark = 0) then i_lock_short := 0;
  if (i_got_it_mark = 0) then i_lock_long := 0;

  if (i_ff_get_qty_flag > 1) then
  begin
    i_ff_get_qty_flag := i_ff_get_qty_flag - 1;
    ff_get_qty();
  end;

  //for ff_action.ini
  s_tmp := FormatDateTime('yyyymmddhhnnss', Now);

  if (i_open_long_timer = 0) and
    (pc_open_long_time <> nil) and (StrLen(pc_open_long_time) = StrLen(PChar(s_tmp))) then
  begin
    s_tmp1 := pc_open_long_time;
    if (s_tmp > s_tmp1) then
    begin
      i_BSK := 1;
      i_open_long_timer := 888;
    end;
  end;

  if (i_open_short_timer = 0) and
    (pc_open_short_time <> nil) and (StrLen(pc_open_short_time) = StrLen(PChar(s_tmp))) then
  begin
    s_tmp1 := pc_open_short_time;
    if (s_tmp > s_tmp1) then
    begin
      i_BSK := 3;
      i_open_short_timer := 888;
    end;
  end;


  if (i_close_long_timer = 0) and
    (pc_close_long_time <> nil) and (StrLen(pc_close_long_time) = StrLen(PChar(s_tmp))) then
  begin
    s_tmp1 := pc_close_long_time;
    if (s_tmp > s_tmp1) then
    begin
      i_BSK := 5;
      i_close_long_timer := 888;
    end;
  end;


  if (i_close_short_timer = 0) and
    (pc_close_short_time <> nil) and (StrLen(pc_close_short_time) = StrLen(PChar(s_tmp))) then
  begin
    s_tmp1 := pc_close_short_time;
    if (s_tmp > s_tmp1) then
    begin
      i_BSK := 6;
      i_close_short_timer := 888;
    end;
  end;



  if (i_BSK = 1) or (i_BSK = 2) and (f_last_price_wk > 8.0) then
  begin

    i_ff_get_qty_flag := 18;

   //for loop add
    for i_loop_wk := 0 to i_fc_count - 1 do
    begin

      if i_only_1 = 1 then i_loop := i_fc_wk_index else i_loop := i_loop_wk;

      if as_fc_data[i_loop].pc_username = nil then Break;
      pc_username := as_fc_data[i_loop].pc_username;

    //ff_entrust_no(pc_what_wk);
    //ff_cancel_entrust_no();
      ff_get_qty();

      if (i_BSK = 1) then s_tmp := FloatToStrF(f_sale_1 + i_open_delta, ffFixed, 8, 2);
      if (i_BSK = 2) then s_tmp := FloatToStrF(f_buy_1 - 1.0, ffFixed, 8, 2);
      if (i_BSK = 2) and (i_open_price > 0) then s_tmp := IntToStr(i_open_price);

      i_BSK := 0;

      if (i_got_it_mark > (as_fc_data[i_loop].i_long_max - 1)) then Continue;

    //ff_order_ex(pc_what_wk,PChar(s_tmp),PChar(IntToStr(i_F)),m_mairu,m_kaicang);
      ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(as_fc_data[i_loop].i_VOL)), m_mairu, m_kaicang);

      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'BSK,make long position!');
    //Sleep(2000);
    //ff_get_qty();

      if i_only_1 = 1 then Break;

    end
  end
  else if (i_BSK = 1) or (i_BSK = 2) then i_BSK := 0;

  if (i_BSK = 3) or (i_BSK = 4) and (f_last_price_wk > 8.0) then
  begin

    i_ff_get_qty_flag := 18;
   //for loop add
    for i_loop_wk := 0 to i_fc_count - 1 do
    begin

      if i_only_1 = 1 then i_loop := i_fc_wk_index else i_loop := i_loop_wk;

      if as_fc_data[i_loop].pc_username = nil then Break;
      pc_username := as_fc_data[i_loop].pc_username;

    //ff_entrust_no(pc_what_wk);
    //ff_cancel_entrust_no();
      ff_get_qty();

      if (i_BSK = 3) then s_tmp := FloatToStrF(f_buy_1 - i_open_delta, ffFixed, 8, 2);
      if (i_BSK = 4) then s_tmp := FloatToStrF(f_sale_1 + 1.0, ffFixed, 8, 2);
      if (i_BSK = 4) and (i_open_price > 0) then s_tmp := IntToStr(i_open_price);

      i_BSK := 0;

      if (i_short_mark > (as_fc_data[i_loop].i_short_max - 1)) then Continue;

    //ff_order_ex(pc_what_wk,PChar(s_tmp),PChar(IntToStr(i_F)),m_maichu,m_kaicang);

      ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(as_fc_data[i_loop].i_VOL)), m_maichu, m_kaicang);

      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'BSK,make short position!');
    //Sleep(2000);
    //ff_get_qty();
    //frmMain2.GRID_S002.Repaint;

      if i_only_1 = 1 then Break;

    end
  end
  else if (i_BSK = 3) or (i_BSK = 4) then i_BSK := 0;

  //for stp, auto_trade

  if (i_stp_long > 0) and (i_BSK = 0) and (i_act_stp_long_mark = 0) then
    if (i_got_it_mark > -1) and (f_last_price_wk > 8.0) then
    begin
    //if( i_set_stp_long_wk =0 ) Then i_set_stp_long_wk := Round(f_business_price+0.49);
      if (i_set_stp_long_wk > 0) and (i_set_stp_long_wk < Round(f_last_price_wk + 0.49)) then
      begin
        i_stp_long := 0;
        i_act_stp_long_mark := 888;
        i_ff_get_qty_flag := 18;
        i_act_stp_long := 888;
        i_BSK := m_bsk_ask_long;
        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'Long STP!');
      end;
    end;

  if (i_stp_short > 0) and (i_BSK = 0) and (i_act_stp_short_mark = 0) then
    if (i_got_it_mark > -1) and (f_last_price_wk > 8.0) then
    begin
    //if( i_set_stp_short_wk =0 ) Then i_set_stp_short_wk := Round(f_business_price+0.49);
      if (i_set_stp_short_wk > 0) and (i_set_stp_short_wk > Round(f_last_price_wk - 0.49)) then
      begin
        i_stp_short := 0;
        i_act_stp_short_mark := 888;
        i_ff_get_qty_flag := 18;
        i_act_stp_short := 888;
        i_BSK := m_bsk_bid_short;
        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'Short STP!');
      end;
    end;
  //end stp

  //for locked, auto_clear

  if (i_lock_long > 0) and (i_BSK = 0) and (i_cut_lock_long_mark = 0) then
  //if(i_got_it_mark >0) and (f_last_price_wk >8.0) and (f_last_price_wk - f_business_price < 0.50 ) Then
    if (i_got_it_mark > 0) and (f_last_price_wk > 8.0) then
    begin
      if (i_set_lock_long_wk = 0) then i_set_lock_long_wk := Round(f_business_price + 0.49);
      if (i_set_lock_long_wk > 0) and (i_set_lock_long_wk > Round(f_last_price_wk - 0.49)) then
      begin
        i_lock_long := 0;
        i_cut_lock_long_mark := 888;
        i_ff_get_qty_flag := 18;
        i_cut_lock_long := 888;
        i_BSK := m_bsk_clear_long;
        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'Locked Long Clear!');
      end;
    end;

  if (i_lock_short > 0) and (i_BSK = 0) and (i_cut_lock_short_mark = 0) then
  //if(i_short_mark >0) and (f_last_price_wk >8.0) and ( f_short_price - f_last_price_wk <0.50 ) Then
    if (i_short_mark > 0) and (f_last_price_wk > 8.0) then
    begin
      if (i_set_lock_short_wk = 0) then i_set_lock_short_wk := Round(f_short_price - 0.49);
      if (i_set_lock_short_wk > 0) and (i_set_lock_short_wk < Round(f_last_price_wk + 0.49)) then
      begin
        i_lock_short := 0;
        i_cut_lock_short_mark := 888;
        i_ff_get_qty_flag := 18;
        i_cut_lock_short := 888;
        i_BSK := m_bsk_clear_short;
        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'Locked Short Clear!');
      end;
    end;

  //for locked, auto_clear_end

  i_line_no_001 := i_line_no_001 + 1;

  //if (i_BSK = 5 ) and (i_got_it_mark >0) and (f_last_price_wk >8.0) Then
  if (i_BSK = 5) and (f_last_price_wk > 8.0) then
  begin
    i_ff_get_qty_flag := 18;

    i_BSK := 0;

    if (i_lock_long > 0) and (i_cut_lock_long = 0) then
    begin
      s_caption_status := '������֣����ý��г嶯��ƽ�������';
    end
    else
    begin
    //for loop add
      for i_loop_wk := 0 to i_fc_count - 1 do
      begin

    //for reset
        if (i_lock_long > 0) and (i_cut_lock_long > 0) then
        begin
          i_cut_lock_long := 0;
        end;

        if i_only_1 = 1 then i_loop := i_fc_wk_index else i_loop := i_loop_wk;

        if as_fc_data[i_loop].pc_username = nil then Break;
        pc_username := as_fc_data[i_loop].pc_username;

        s_tmp := FloatToStrF(f_last_price_wk - i_close_delta, ffFixed, 8, 2);

    //ff_entrust_no(pc_what_wk);
    //ff_cancel_entrust_no();
        ff_get_qty();

        if (i_clr_long_1_mark > 0) then
    //if (i_loop <> i_fc_wk_index ) Then
          i_got_it_mark := as_fc_data[i_loop].i_VOL;

        if (i_clr_long_to_001_mark > 0) then
        begin
          if (i_got_it_mark < 2) then
            ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_got_it_mark)), m_maichu, m_pingcang)
          else
            ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_got_it_mark - 1)), m_maichu, m_pingcang);
        end
        else
          ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_got_it_mark)), m_maichu, m_pingcang);


        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '-12,BSK,long clear!');
    //Sleep(2000);
    //ff_get_qty();
    //frmMain2.GRID_S002.Repaint;

        if i_only_1 = 1 then Break;

      end
    end;

    if (i_clr_long_1_mark > 0) then i_clr_long_1_mark := 0;
    if (i_clr_long_to_001_mark > 0) then i_clr_long_to_001_mark := 0;

  end
  else if (i_BSK = 5) then i_BSK := 0;

  i_line_no_001 := i_line_no_001 + 1;

  if (i_BSK = 7) and (f_last_price_wk > 8.0) then
  //if (i_BSK = 7 ) and (i_got_it_mark >0) and (f_last_price_wk >8.0) Then
  begin
   //i_ff_get_qty_flag := 18;

    for i_loop_wk := 0 to i_fc_count - 1 do
    begin

      if i_only_1 = 1 then i_loop := i_fc_wk_index else i_loop := i_loop_wk;

      if as_fc_data[i_loop].pc_username = nil then Break;
      pc_username := as_fc_data[i_loop].pc_username;

      i_got_it_mark := as_fc_data[i_loop].i_VOL;

    //ff_entrust_no(pc_what_wk);
    //ff_cancel_entrust_no();

      ff_get_qty();

      i_BSK := 0;
      s_tmp := FloatToStrF(f_last_price_wk + 2.0, ffFixed, 8, 2);
      if (i_open_price > 0) then s_tmp := IntToStr(i_open_price);

      if (i_open_price > 0) and (i_open_vol > 0) then
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_open_vol)), m_maichu, m_pingcang)
      else
      //20120309 chg
      //if(i_got_it_mark <2) Then
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_got_it_mark)), m_maichu, m_pingcang);
      //else
      //  ff_order_ex(pc_what_wk,PChar(s_tmp),PChar(IntToStr(i_got_it_mark-1)),m_maichu,m_pingcang);

      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '+2,BSK,long clear!');
    //Sleep(2000);
    //ff_get_qty();
    //frmMain2.GRID_S002.Repaint;
      if i_only_1 = 1 then Break;
    end
  end
  else if (i_BSK = 7) then i_BSK := 0;


  i_line_no_001 := i_line_no_001 + 1;


  if (i_BSK = 6) and (i_short_mark > 0) and (f_last_price_wk > 8.0) then
  begin
    i_ff_get_qty_flag := 18;

    i_BSK := 0;

    if (i_lock_short > 0) and (i_cut_lock_short = 0) then
    begin
      s_caption_status := '������֣����ý��г嶯��ƽ�������';
    end
    else
    begin

      for i_loop_wk := 0 to i_fc_count - 1 do
      begin

        if (i_lock_short > 0) and (i_cut_lock_short > 0) then
        begin
          i_cut_lock_short := 0;
        end;

        if i_only_1 = 1 then i_loop := i_fc_wk_index else i_loop := i_loop_wk;

        if as_fc_data[i_loop].pc_username = nil then Break;
        pc_username := as_fc_data[i_loop].pc_username;
        i_short_mark := as_fc_data[i_loop].i_VOL;

    //ff_entrust_no(pc_what_wk);
    //ff_cancel_entrust_no();

        ff_get_qty();

        if (i_clr_short_1_mark > 0) then
          i_short_mark := as_fc_data[i_loop].i_VOL;

        s_tmp := FloatToStrF(f_last_price_wk + i_close_delta, ffFixed, 8, 2);

        if (i_clr_short_to_001_mark > 0) then
        begin
          if (i_short_mark < 2) then
            ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_pingcang)
          else
            ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark - 1)), m_mairu, m_pingcang);
        end
        else
    //if(i_short_mark <2) Then
          ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_pingcang);
    //else
    //  ff_order_ex(pc_what_wk,PChar(s_tmp),PChar(IntToStr(i_short_mark-1)),m_mairu,m_pingcang);

        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '+12 BSK,short clear!');
    //Sleep(2000);
    //ff_get_qty();
    //frmMain2.GRID_S002.Repaint;
        if i_only_1 = 1 then Break;
      end
    end;

    if (i_clr_short_1_mark > 0) then i_clr_short_1_mark := 0;
    if (i_clr_short_to_001_mark > 0) then i_clr_short_to_001_mark := 0;

  end
  else if (i_BSK = 6) then i_BSK := 0;

  i_line_no_001 := i_line_no_001 + 1;

  if (i_BSK = 8) and (i_short_mark > 0) and (f_last_price_wk > 8.0) then
  begin
   //i_ff_get_qty_flag := 18;

    i_BSK := 0;
    for i_loop_wk := 0 to i_fc_count - 1 do
    begin
      if i_only_1 = 1 then i_loop := i_fc_wk_index else i_loop := i_loop_wk;

      if as_fc_data[i_loop].pc_username = nil then Break;
      pc_username := as_fc_data[i_loop].pc_username;
      i_short_mark := as_fc_data[i_loop].i_VOL;

    //ff_entrust_no(pc_what_wk);
    //ff_cancel_entrust_no();

      ff_get_qty();

      s_tmp := FloatToStrF(f_last_price_wk - 2.0, ffFixed, 8, 2);
      if (i_open_price > 0) then s_tmp := IntToStr(i_open_price);
    //ff_entrust_no(pc_what_wk);
    //ff_cancel_entrust_no();

    //if(i_short_mark <2) Then
      if (i_open_price > 0) and (i_open_vol > 0) then
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_open_vol)), m_mairu, m_pingcang)
      else
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_pingcang);
    //else
      //ff_order_ex(pc_what_wk,PChar(s_tmp),PChar(IntToStr(i_short_mark-1)),m_mairu,m_pingcang);

      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '-2,BSK,short clear!');
    //Sleep(2000);
    //ff_get_qty();
    //frmMain2.GRID_S002.Repaint;
      if i_only_1 = 1 then Break;
    end
  end
  else if (i_BSK = 8) then i_BSK := 0;

  if (i_BSK = 9) and (f_last_price_wk > 8.0) then
  begin
    i_BSK := 0;

    for i_loop_wk := 0 to i_fc_count - 1 do
    begin
      if i_only_1 = 1 then i_loop := i_fc_wk_index else i_loop := i_loop_wk;

      if as_fc_data[i_loop].pc_username = nil then Break;
      pc_username := as_fc_data[i_loop].pc_username;

      ff_entrust_no(pc_what_wk);
      ff_cancel_entrust_no();

      if i_only_1 = 1 then Break;
    end
  end
  else if (i_BSK = 9) then i_BSK := 0;

  //for ff_300m_ex : Exit Here!
  Exit;


  i_line_no_001 := i_line_no_001 + 1;

  ff_short_pass3_mark(i_s_k_chg_index_wk - 1);

  i_line_no_001 := i_line_no_001 + 1;

  ff_get_BS_Mark(i_s_k_chg_index_wk - 1);

  i_line_no_001 := i_line_no_001 + 1;

  ff_get_S_L_Mark(i_s_k_chg_index_wk - 1);

  i_line_no_001 := i_line_no_001 + 1;

  if (f_last_price_wk < 1) then Exit;

  i_line_no_001 := i_line_no_001 + 1;
  //for auto_clear
  i_tmp := i_B_S_Flag;
  if (i_B_S_Flag_18 > 0) and (i_B_S_Flag_10 > 0) then
    if (i_tmp < 0) and (i_got_it_mark > 0) and (f_last_price_wk > 8.0) then
    begin
      s_tmp := FloatToStrF(f_last_price_wk - 2.0, ffFixed, 8, 2);
      ff_entrust_no(pc_what_wk);
      ff_cancel_entrust_no();
      ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_got_it_mark)), m_maichu, m_pingcang);
      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'Auto_Clear_Long!');
      Sleep(2000);
      ff_get_qty();
    //frmMain2.GRID_S002.Repaint;
    end;
  i_line_no_001 := i_line_no_001 + 1;

  i_tmp := i_B_S_Flag;
  if (i_B_S_Flag_18 < 0) and (i_B_S_Flag_10 < 0) then
    if (i_tmp > 0) and (i_short_mark > 0) and (f_last_price_wk > 8.0) then
    begin
      s_tmp := FloatToStrF(f_last_price_wk + 2.0, ffFixed, 8, 2);
      ff_entrust_no(pc_what_wk);
      ff_cancel_entrust_no();

      ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_pingcang);

      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'auto_clear_short!');
      Sleep(2000);
      ff_get_qty();
    //frmMain2.GRID_S002.Repaint;
    end;

  //for auto_clear_end
  i_line_no_001 := i_line_no_001 + 1;

  if (i_get_S_mark = 0) and (i_S > 0) and
    (f_last_price_wk > f_last_price_1 + i_A) and
    (i_got_it_mark > 0) and

    //(i_ADD_FLOSS_MAX > i_long_FLOSS_MAX) and

  (f_last_price_wk - f_business_price > f_rsi_add) and
    (f_last_price_wk - f_business_price < f_rsi_add * 2) then
  begin
    if i_B_S_Flag > 0 then
    begin
      i_get_S_mark := 888;
      s_tmp := FloatToStrF(f_last_price_wk + 1, ffFixed, 8, 2);
      ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_S)), '1', '1');

      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '8,add long position!');

      Sleep(2000);
      ff_get_qty();
    end;

  end;

  i_line_no_001 := i_line_no_001 + 1;

  if (i_short_S_mark = 0) and (i_S > 0) and
    (f_last_price_wk < f_last_price_1 - i_A) and
    (i_short_mark > 0) and

    //(i_ADD_FLOSS_MAX > i_short_FLOSS_MAX) and

  (f_short_price - f_last_price_wk > f_rsi_add) and
    (f_short_price - f_last_price_wk < f_rsi_add * 2) then
  begin
    if i_B_S_Flag < 0 then
    begin
      i_short_S_mark := 888;
      s_tmp := FloatToStrF(f_last_price_wk - 2.0, ffFixed, 8, 2);
      ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_S)), '2', '1');

      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '8,add short position!');

      Sleep(2000);
      ff_get_qty();
    end;
  end;

  i_line_no_001 := i_line_no_001 + 1;

  if (i_make_short_mark > 0) and
    (i_s_k_chg_index_wk - i_make_short_mark > 0) then i_make_short_mark := 0;

  i_tmp_1 := ff_check_short_250(i_s_k_chg_index_wk);

  i_line_no_001 := i_line_no_001 + 1;


  i_tmp_2 := ff_check_short_30(i_s_k_chg_index_wk);

  i_line_no_001 := i_line_no_001 + 1;

  i_tmp_3 := ff_check_short_120(i_s_k_chg_index_wk);

  i_line_no_001 := i_line_no_001 + 1;

  //for No MA120 Short
  i_tmp_3 := 1;

  i_tmp_4 := ff_pass3_short_120(i_s_k_chg_index_wk);

  i_line_no_001 := i_line_no_001 + 1;

  i_tmp_7 := ff_make_mbm_short(i_s_k_chg_index_wk);

  i_line_no_001 := i_line_no_001 + 1;

  ff_check_short_1(i_s_k_chg_index_wk - 1);

  i_tmp := ff_check_short_1_ex(i_s_k_chg_index_wk - 1);

  if i_mbm_only = 1 then
  begin
    i_tmp_1 := 1;
    i_tmp_2 := 1;
    i_tmp_3 := 1;
    i_tmp_4 := 1;
    i_tmp := 1;
    i_tmp_7 := 1;
  end;

  i_tmp_9 := ff_get_ma600_mark(i_s_k_chg_index_wk - 1);
  if (i_tmp_9 > 0) then
  begin
    if (i_short_act_flag > 0) then
    begin
      i_short_act_flag := i_short_act_flag - 1;
      i_tmp_7 := 0;
      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'i_tmp_9,make a short position!');
    end;
  end;

  i_line_no_001 := i_line_no_001 + 1;

  if ((i_tmp = 0) or (i_tmp_1 = 0) or (i_tmp_2 = 0) or (i_tmp_3 = 0) or (i_tmp_4 = 0) or
    ((i_tmp_7 = 0) and (i_s_k_chg_index_wk - i_short_stop_index > 28))) then
  begin
    if (i_no_trade = 0) then if ((i_only_short = 1) or (i_long_short_ctrl = 0)) then
      begin
        if i_B_S_Flag < 0 then
        begin
          s_tmp := FloatToStrF(f_last_price_wk - 2.0, ffFixed, 8, 2);
          if (i_short_mark = 0) and (i_make_short_mark = 0) then
          begin
            ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_F)), '2', '1');

            W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '8,make a short position!');

            Sleep(2000);
            ff_get_qty();
            i_make_short_mark := i_s_k_chg_index_wk;
          end;
        end;
      end;
  end;

  i_line_no_001 := i_line_no_001 + 1;
  ff_4ma_make_mbm_short(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;
  ff_4ma_make_mbm_long(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;

  i_tmp_7 := ff_make_mbm_long(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;

  i_tmp_6 := ff_long_pass_3_ex(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;

  i_tmp_4 := ff_make_long_MA30(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;
  i_tmp_4 := 1;

  i_tmp_5 := ff_make_long_MA60(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;
  i_tmp_5 := 1;
  i_tmp_5 := ff_make_long_MA250(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;
  //i_tmp_5 :=1;

  i_tmp_3 := ff_check_long_pass_3(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;

  ff_check_BB_100(i_s_k_chg_index_wk, 3);
  i_line_no_001 := i_line_no_001 + 1;
  i_tmp_2 := ff_check_BB_100_ex(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;

  ff_check_MA120_BB(i_s_k_chg_index_wk, 3);
  i_line_no_001 := i_line_no_001 + 1;
  i_tmp_1 := ff_check_MA120_BB_ex(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;

  if (i_make_long_mark > 0) and
    (i_s_k_chg_index_wk - i_make_long_mark > 0) then i_make_long_mark := 0;

  ff_check_rsi_w20(i_s_k_chg_index_wk - 1);
  i_line_no_001 := i_line_no_001 + 1;
  i_tmp := ff_check_rsi_w20_ex(i_s_k_chg_index_wk);
  i_line_no_001 := i_line_no_001 + 1;

  if i_mbm_only = 1 then
  begin
    i_tmp_1 := 1;
    i_tmp_2 := 1;
    i_tmp_3 := 1;
    i_tmp_4 := 1;
    i_tmp_5 := 1;
    i_tmp_6 := 1;
    i_tmp_7 := 1;
    i_tmp := 1;
  end;

  i_tmp_9 := ff_get_ma600_mark_long(i_s_k_chg_index_wk - 1);
  if (i_tmp_9 > 0) then
  begin
    if (i_long_act_flag > 0) then
    begin
      i_long_act_flag := i_long_act_flag - 1;
      i_tmp_7 := 0;
      W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, 'i_tmp_9,make a long position!');
    end
  end;

  i_line_no_001 := i_line_no_001 + 1;

  if ((i_tmp = 0) or (i_tmp_1 = 0) or (i_tmp_2 = 0) or (i_tmp_3 = 0) or (i_tmp_4 = 0) or (i_tmp_5 = 0) or (i_tmp_6 = 0) or (i_tmp_7 = 0)) then
  begin
    if (i_no_trade = 0) then if ((i_only_long = 1) or (i_long_short_ctrl = 0)) then
      begin
        if (i_B_S_Flag > 0) or ((i_s_k_chg_index_wk - i_short_stop_index < 28) and (i_tmp = 0)) or
          (i_tmp_3 = 0) or (i_tmp_4 = 0) or (i_tmp_5 = 0) or (i_tmp_6 = 0) or (i_tmp_2 = 0) or
          (i_tmp_1 = 0) or (i_tmp_7 = 0) then
        begin
          s_tmp := FloatToStrF(f_last_price_wk + 1, ffFixed, 8, 2);
          if (i_got_it_mark = 0) and (i_make_long_mark = 0) then
          begin
            ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_F)), '1', '1');

            W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '8,make a long position!');

            Sleep(2000);
            ff_get_qty();
            i_make_long_mark := i_s_k_chg_index_wk;
          end;
        end;
      end;
  end;
  i_line_no_001 := i_line_no_001 + 1;

 //for short Stop
  if (i_short_mark > 0) and (f_last_price_wk > (f_short_price + f_rsi_cut_short)) then
  begin
    i_stop_short_count := i_stop_short_count + 1;
    if (i_stop_short_count > 1) then
    begin
      i_stop_short_count := 0;

      //for OPEN, NO CUT!
      s_tmp := FormatDateTime('hhnn', Now);
      if ((s_tmp <> '0915') and (s_tmp <> '0916') and (s_tmp <> '0916') and (s_tmp <> '0916') and
        (s_tmp <> '915') and (s_tmp <> '916') and (s_tmp <> '916') and (s_tmp <> '916')) then
      begin

        s_tmp := FloatToStrF(f_last_price_wk + 2.0, ffFixed, 8, 2);
        ff_entrust_no(pc_what_wk);
        ff_cancel_entrust_no();
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_pingcang);
        i_stop_short_count := 0;

        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '99,Cut Short!');

        //for make a long
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_pingcang);

        if (as_k_chg[i_s_k_chg_index_wk].i_close > as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[6]) and
          (as_k_chg[i_s_k_chg_index_wk].i_close > as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[3]) and
          (as_k_chg[i_s_k_chg_index_wk].i_close < as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[8]) and
          (as_k_chg[i_s_k_chg_index_wk].i_close > as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[5]) then
        begin
          ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_kaicang);
          W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '88,Make Long!');
        end;

        Sleep(2000);
        ff_get_qty();

      end;
    end;
  end
  else if (i_short_mark > 0) and (f_short_price > f_last_price_wk + f_rsi_stop_short) then
  begin
    i_stop_short_count := i_stop_short_count + 1;

    if (i_M120 > 0) and
      ((Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[6]) + i_M120) <
      (Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 2].ai_ma[6]))) then
    begin
      i_M120_stop := 888;
    end
    else if i_M120 > 0 then
    begin
      i_M120_stop := 8;
    end
    else i_M120_stop := 0;

    if (i_M30 > 0) and
      ((Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[3]) + i_M30) <
      (Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 2].ai_ma[3]))) then
    begin
      i_M30_stop := 888;
    end
    else if i_M30 > 0 then
    begin
      i_M30_stop := 8;
    end
    else i_M30_stop := 0;

    if (i_M120_stop = 888) or (i_M30_stop = 888) or
      ((i_M30_stop = 0) and (i_M120_stop = 0)) then
    begin

    //M30 delta check
    //if ( (Integer(as_k_chg_ma_rsi[ i_s_k_chg_index_wk-1 ].ai_ma[3]) + i_M30 ) >
    //    Integer(as_k_chg_ma_rsi[ i_s_k_chg_index_wk-2 ].ai_ma[3])  ) Then
    //begin

      if (i_stop_short_count > 1) then
      begin
        s_tmp := FloatToStrF(f_last_price_wk + 2.0, ffFixed, 8, 2);
        ff_entrust_no(pc_what_wk);
        ff_cancel_entrust_no();
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_short_mark)), m_mairu, m_pingcang);
        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '888,Stop Short Profit!');
        i_stop_short_count := 0;

        i_short_stop_index := i_s_k_chg_index_wk;

        Sleep(2000);
        ff_get_qty();
      end;

    end;
  end;

  i_line_no_001 := i_line_no_001 + 1;

 //for Stop
  if (i_got_it_mark > 0) and (f_last_price_wk - f_business_price > f_rsi_stop_long) then
  begin

    i_stop_check_count := i_stop_check_count + 1;

    if (i_M120 > 0) and
      (Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[6]) <
      (Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 2].ai_ma[6]) + i_M120)) then
    begin
      i_M120_stop := 888;
    end
    else if i_M120 > 0 then
    begin
      i_M120_stop := 8;
    end
    else i_M120_stop := 0;

    if (i_M30 > 0) and
      (Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 1].ai_ma[3]) <
      (Integer(as_k_chg_ma_rsi[i_s_k_chg_index_wk - 2].ai_ma[3]) + i_M30)) then
    begin
      i_M30_stop := 888;
    end
    else if i_M30 > 0 then
    begin
      i_M30_stop := 8;
    end
    else i_M30_stop := 0;

    if (i_M120_stop = 888) or (i_M30_stop = 888) or
      ((i_M30_stop = 0) and (i_M120_stop = 0)) then
    begin

      if (i_stop_check_count > 1) then
      begin
        s_tmp := FloatToStrF(f_last_price_wk - 1.0, ffFixed, 8, 2);
        ff_entrust_no(pc_what_wk);
        ff_cancel_entrust_no();
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_got_it_mark)), m_maichu, m_pingcang);
        i_stop_check_count := 0;
        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '888,Stop Long Profit!');

        i_long_stop_index := i_s_k_chg_index_wk;

        Sleep(2000);
        ff_get_qty();
      end;

    end;

  end
  else if (i_got_it_mark > 0) and (f_business_price - f_last_price_wk > f_rsi_cut_long) then
  begin

    s_tmp := FormatDateTime('hhnn', Now);
    if ((s_tmp <> '0915') and (s_tmp <> '0916') and (s_tmp <> '0917') and (s_tmp <> '0918') and
      (s_tmp <> '915') and (s_tmp <> '916') and (s_tmp <> '917') and (s_tmp <> '918')) then
    begin

      i_stop_check_count := i_stop_check_count + 1;
      if (i_stop_check_count > 1) then
      begin
        i_stop_check_count := 0;
        s_tmp := FloatToStrF(f_last_price_wk - 2.0, ffFixed, 8, 2);
        ff_entrust_no(pc_what_wk);
        ff_cancel_entrust_no();
        ff_order_ex(pc_what_wk, PChar(s_tmp), PChar(IntToStr(i_got_it_mark)), m_maichu, m_pingcang);
        W_Log('main_loop', as_k_chg[i_s_k_chg_index_wk].i_date, i_wk_log, '999,Cut loss!');
        i_stop_check_count := 0;
        Sleep(2000);
        ff_get_qty();
      end;

    end;
  end;

end;

function do_beep(): Boolean;
begin
  Result := False;
  if i_beeping = 1 then Exit;
  i_beeping := 1;
  g_hEvent := CreateEvent(nil, TRUE, FALSE, nil);
  //Application.ProcessMessages;
  th_beep := Tth_beep.Create(false);
  th_beep.i_do_main_loop_mark := 0;

  th_main_loop := Tth_beep.Create(false);
  th_main_loop.i_do_main_loop_mark := 888;

  Result := True;
end;

function ff_stop_do_beep(): Boolean;
begin
  Result := True;
  if i_beeping = 0 then Exit;
  th_main_loop.Terminate;
  th_beep.Terminate;
  sleep(3000);
  //for not need
 //th_main_loop.Destroy;
 //th_beep.Destroy;
  i_beeping := 0;
end;

function ff_rsi_w20_init(): Boolean;
var
  pc_tmp: PChar;
  s_tmp: string;
  i_loop: Integer;
  s_tmp1: string;

begin

  FillChar(as_fc_data, sizeof(as_fc_data), 0);

  FillChar(c_batch_no, SizeOf(c_batch_no), 0);
  FillChar(c_entrust_no, SizeOf(c_entrust_no), 0);

  s_tmp := FormatDateTime('yyyymmddhhnnss', Now);

  pc_tmp := FF_ffconf(m_ff_action_ini, 'LONG', 'OPEN_TIME');
  if pc_tmp <> nil then pc_open_long_time := pc_tmp;

  s_tmp1 := pc_open_long_time;
  if (pc_open_long_time <> nil) and (StrLen(pc_open_long_time) = StrLen(PChar(s_tmp))) then
  begin
    if (s_tmp >= s_tmp1) then i_open_long_timer := -888 else i_open_long_timer := 0;
  end;

  pc_tmp := FF_ffconf(m_ff_action_ini, 'SHORT', 'OPEN_TIME');
  if pc_tmp <> nil then pc_open_short_time := pc_tmp;

  s_tmp1 := pc_open_short_time;
  if (pc_open_short_time <> nil) and (StrLen(pc_open_short_time) = StrLen(PChar(s_tmp))) then
  begin
    if (s_tmp >= s_tmp1) then i_open_short_timer := -888 else i_open_short_timer := 0;
  end;

  pc_tmp := FF_ffconf(m_ff_action_ini, 'LONG', 'CLOSE_TIME');
  if pc_tmp <> nil then pc_close_long_time := pc_tmp;

  s_tmp1 := pc_close_long_time;
  if (pc_close_long_time <> nil) and (StrLen(pc_close_long_time) = StrLen(PChar(s_tmp))) then
  begin
    if (s_tmp >= s_tmp1) then i_close_long_timer := -888 else i_close_long_timer := 0;
  end;

  pc_tmp := FF_ffconf(m_ff_action_ini, 'SHORT', 'CLOSE_TIME');
  if pc_tmp <> nil then pc_close_short_time := pc_tmp;

  s_tmp1 := pc_close_short_time;
  if (pc_close_long_time <> nil) and (StrLen(pc_close_short_time) = StrLen(PChar(s_tmp))) then
  begin
    if (s_tmp >= s_tmp1) then i_close_short_timer := -888 else i_close_short_timer := 0;
  end;

  for i_loop := 0 to 78 do
  begin
    s_tmp := 'FC.' + IntToStr(i_loop);
    pc_tmp := FF_ffconf(m_ff_local_ini, 'FC', PChar(s_tmp));
    i_fc_count := i_loop;
    if pc_tmp <> nil then as_fc_data[i_loop].pc_username := pc_tmp else Break;

    s_tmp := 'FCPWD.' + IntToStr(i_loop);
    pc_tmp := FF_ffconf(m_ff_local_ini, 'FC', PChar(s_tmp));
    i_fc_count := i_loop;
    if pc_tmp <> nil then as_fc_data[i_loop].pc_fcpwd := pc_tmp;

    s_tmp := 'NAME.' + IntToStr(i_loop);
    pc_tmp := FF_ffconf(m_ff_local_ini, 'FC', PChar(s_tmp));
    i_fc_count := i_loop;
    if pc_tmp <> nil then as_fc_data[i_loop].pc_xxx_name := pc_tmp else Break;

    s_tmp := 'VOL.' + IntToStr(i_loop);
    pc_tmp := FF_ffconf(m_ff_local_ini, 'FC', PChar(s_tmp));
    i_fc_count := i_loop;
    if pc_tmp <> nil then as_fc_data[i_loop].i_VOL := StrToInt(pc_tmp) else Break;

    s_tmp := 'LONG_MAX.' + IntToStr(i_loop);
    pc_tmp := FF_ffconf(m_ff_local_ini, 'FC', PChar(s_tmp));
    i_fc_count := i_loop;
    if pc_tmp <> nil then as_fc_data[i_loop].i_long_max := StrToInt(pc_tmp) else Break;

    s_tmp := 'SHORT_MAX.' + IntToStr(i_loop);
    pc_tmp := FF_ffconf(m_ff_local_ini, 'FC', PChar(s_tmp));
    i_fc_count := i_loop;
    if pc_tmp <> nil then as_fc_data[i_loop].i_short_max := StrToInt(pc_tmp) else Break;

  end;

  Result := True;

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'A_min');
  if pc_tmp <> nil then i_rsi_A := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'B_min');
  if pc_tmp <> nil then i_rsi_B := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'C_min');
  if pc_tmp <> nil then i_rsi_C := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'AB_max');
  if pc_tmp <> nil then i_rsi_AB := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'BC_max');
  if pc_tmp <> nil then i_rsi_BC := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'IA_min');
  if pc_tmp <> nil then i_rsi_IA_min := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'IA_max');
  if pc_tmp <> nil then i_rsi_IA_max := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'CUT');
  if pc_tmp <> nil then f_rsi_cut := StrToFloat(pc_tmp);

  //f_mbm_cut_all :=f_rsi_cut*3;

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'STOP');
  if pc_tmp <> nil then f_rsi_stop := StrToFloat(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'ADD');
  if pc_tmp <> nil then f_rsi_add := StrToFloat(pc_tmp);


  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'F');
  if pc_tmp <> nil then i_F := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'S');
  if pc_tmp <> nil then i_S := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'T');
  if pc_tmp <> nil then i_T := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'A');
  if pc_tmp <> nil then i_A := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'M30');
  if pc_tmp <> nil then i_M30 := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'M120');
  if pc_tmp <> nil then i_M120 := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'BOX_Y');
  if pc_tmp <> nil then i_BOX_Y := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'KONLY');
  if pc_tmp <> nil then i_make_k_only := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'LS_CTRL');
  if pc_tmp <> nil then i_long_short_ctrl := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'CODE');
  if pc_tmp <> nil then pc_what_wk := pc_tmp;

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'MBM_ONLY');
  if pc_tmp <> nil then i_mbm_only := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'LONG_ONLY');
  if pc_tmp <> nil then i_only_long := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'SHORT_ONLY');
  if pc_tmp <> nil then i_only_short := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_ma120_ini, 'M120BB', 'BOX_Y');
  if pc_tmp <> nil then i_BB_BOX_Y := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_ma120_ini, 'M120BB', 'BOX_X');
  if pc_tmp <> nil then i_BB_BOX_X := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_bb100_ini, 'BB_100', 'BOX_X');
  if pc_tmp <> nil then i_BB_100_BOX_X := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_bb100_ini, 'BB_100', 'BOX_Y');
  if pc_tmp <> nil then i_BB_100_BOX_Y := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_m30_short_ini, 'M30', 'BOX_X');
  if pc_tmp <> nil then i_M30_short_BOX_X := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_m30_short_ini, 'M30', 'BOX_Y');
  if pc_tmp <> nil then i_M30_short_BOX_Y := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_short_1_ini, 'Main', 'ACT');
  if pc_tmp <> nil then i_act_short := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'ACT');
  if pc_tmp <> nil then i_act_rsi := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_rsi_ini, 'W20', 'ADD_FLOSS_MAX');
  if pc_tmp <> nil then i_ADD_FLOSS_MAX := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_ma120_ini, 'M120BB', 'ACT');
  if pc_tmp <> nil then i_act_m120 := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_bb100_ini, 'BB_100', 'ACT');
  if pc_tmp <> nil then i_act_bb_100 := StrToInt(pc_tmp);

  f_rsi_stop_long := f_rsi_stop;
  f_rsi_stop_short := f_rsi_stop;

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'OPEN_DELTA');
  if pc_tmp <> nil then i_open_delta := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'CLOSE_DELTA');
  if pc_tmp <> nil then i_close_delta := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'STP_DELTA');
  if pc_tmp <> nil then i_stp_delta := StrToInt(pc_tmp);

  pc_tmp := FF_ffconf(m_ff_local_ini, 'What', 'CHK_POWER_VOL');
  if pc_tmp <> nil then i_chk_power_vol_set := StrToInt(pc_tmp);

end;

function ff_do_main_loop(): Integer;
var
  s_tmp_log: string;
begin

  i_lock_for_main_loop := 1;

  Result := 0;

  i_loop_count_001 := i_loop_count_001 + 1;
  if (i_loop_count_001 > 88888888) then i_loop_count_001 := 0;

  try

    if (i_loop_count_001 mod 100 = 0) then ff_get_qty();

    if (i_ff_get_qty_88 > 0) then
    begin
      i_ff_get_qty_88 := i_ff_get_qty_88 - 2;
      ff_get_qty();
    end;

  except
    on E: Exception do
    begin
        //Assert(false,s_tmp_log);
        //W_Log('ff_do_main_loop ff_get_qty',19,999,PChar(s_tmp_log));
      W_Log('ff_do_main_loop ff_get_qty', 19, 999, PChar(E.Message));
      ExitProcess(999);
    end;
  end;

  try
    ff_main_wk_loop();
  except
    on E: Exception do
    begin
        //Assert(false,s_tmp_log);
        //W_Log('ff_do_main_loop ff_main_wk_loop',i_line_no_001,999,PChar(s_tmp_log));
      W_Log('ff_do_main_loop ff_main_wk_loop', i_line_no_001, 999, PChar(E.Message));
      ExitProcess(999);
    end;
  end;

  i_lock_for_main_loop := 0;

end;


end.
