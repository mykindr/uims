unit var_;

interface

uses                          
  Windows, Messages,
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

var
  MyDir, TempDir: String;

  FCaption: string;

  firstrun: Boolean;
  //InstallOn: Boolean = false;

  WindowMax: Boolean;

  NoClose: Boolean;   //�������Ĺرհ�ť���˳�?

  DBIndex, DGIndex: Boolean; //����ٶ���ҳ?
  SearchChange: word;   //Change�Ƿ�OK?
  //SearchSet: Boolean;  //�û��Ƿ�����ѡ�����ù���������?

  BossKey: string;   //�ϰ��
  BossKeyKey: word;
  //BossKeyShift: TShiftState;
  Modifiers: Integer;     
  //sarray: array[0..128] of array[0..99] of string;

  bfState: word = 0;  //ǰ���ͺ��˰�ť��״̬
  CurrBack: Boolean;
  CurrForward: Boolean;

  TabNull: word = 0;  //��ǩ����λ��

  AutoMenuShow: Boolean = true;
  Auto: Boolean; 

  OneTowz: Boolean;
  OneTowz2: Boolean = true;
  DGIndex2: boolean = true;

  ShowGroup: Boolean;

  TabX, NewTabX: Integer;

  CloseUpdate: Boolean; //�Ƿ�����ر�С��ť����

  eKeyWord: string;

  tcno: Boolean;
  tcMainUrl: String;
  tcUrl: String;
  tcClick: integer;
  tcFlag: word;
  tctFlag: word;
  wbClick_Url: String;
  nilAll: Boolean;

  ZoomStr: string = '100%';  //�������ŵ�ֵ

  ImgSaveDir: string;
  NoSaveNewly: Boolean;

  //
  TimerIPVI: Word = 0;
  enableClick: Boolean = true;

  NeedUpdate: Boolean;
  HintUpdate: Boolean = true;
  UpdateAtOne: Boolean;

  EnabledShowPageLogo: Boolean; //

  AddressFocus: Boolean;

  IsWhite: Boolean; //�Ƿ��������,�ǵĻ�����ģʽ
  NoImage: Boolean;
  NoVideo: Boolean;
  NoBgsound: Boolean;
  //NoFlash: Boolean; as ActiveX
  NoJava: Boolean;
  NoScript: Boolean;
  NoActivex: Boolean;

  PageUnLock: Boolean; //ҳ�����������Ҽ�
  TabRClickNewPage: Boolean;  //��ǩ���һ�����½���ǩ?

  //HotArea: Boolean;
  ButtonIndex: Integer;
  //FaceStyle: Word = 2;
  BackEnabled, ForwardEnabled: Boolean;

  AutoRefresh: Boolean = true; //�Ƿ����Զ�ˢ��?
  AutoRefreshTxt: String; //�Զ���ʱ��ʾ������

  AlwaysNewTab: Boolean; //�Զ������±�ǩ?
  WeatherSource: Word; //�鿴����Ԥ����Դ

  SearchShow: Boolean; //��������ʾ?

  AppToExit: Boolean; //���������˳�?
  //GoRefresh: Boolean;

  CurrentUrl: String;  //��ǰURL
  HideBorder: Boolean = true; //������Ƿ����ر߿�
  //FaceNeedLine: Boolean = true;  //�����Ƿ���Ҫ����? 

  ShowMenu: Boolean = true;
  //ShowButton: Boolean = true;
  StatusBarV: Boolean; //�Ƿ���ʾ״̬��
  StatusBarExtend: Boolean; //�Ƿ���ʾ״̬����չ

  MenuImage: Boolean = true;  //�˵��Ƿ���Сͼ��?
  TBTabNewShow: Boolean;  //����ʾ��ǩ��ǰ���?  //��ǩ����ǰ���"�½�"С��ť�Ƿ���ʾ

  DisDblClick: Boolean;  //��ֹ���˫���رձ�ǩ?

  EnableTitle: Boolean = true;  //�Ƿ�������������ı�������ʾ��վ�ı���  noread

  //TabNewBtn: TToolButton;
  //CreateTabNewBtnOK: Boolean;

  //SkinStyle: String = '0'; //��������
  //ImageStandardButton: Word = 0;

  //FormsAutoComplete: Boolean = false; //��ҳ�Ƿ��Զ����

  Replace10, Replace11: ShortString;

  LoadLastOpenFlag: Boolean = true;
  //LastOpenPageClose: Boolean = false;
  LoadLastOpenI: Word;
  LoadLastOpenOK: Boolean;

  //{
  wbList: TList;
  PageIndex: Integer = 0;                           
  WhiteList: TStringList;  //�������ַ����б�
  BlackList: TStringList;  //�������ַ����б�
  //GISPop: Boolean;  //ȫ�ֵ�,�ǵ���?

  LANGUAGE: Word = 0; //����

  //TabStyle: Word;  //��ǩ��ʽ
  TabAt: Word;  //��ǩ����

  //ShowTabHint: Boolean = true; //�Ƿ���ʾ��ǩ����ʾ

  //MainMenuDraw: Boolean = true;

  CheckDefaultBrowser: Boolean = true; //���Ĭ�����������
  AutoUpdateHint: Boolean = true; //�Զ�������ʾ

  //AllCloseIng: Boolean; //ҳ��ȫ���ر���

  ProBar:TProgressBar;  //״̬������
  LabelPro:TLabel;  //״̬�������ٷֱ�

  ButtonMoveO: Word = 1;  //����ƹ��ĸ���׼��ť
  FaceStyle: Word;  //����Ƥ����ʽ
  TabStyle: Word = 0;  //��ǩ��ʽ
  ButtonStyle: Word = 0; //��׼��ť��ʽ

  StatusTextEnabled: Boolean = true; //�Ƿ������ַ����ʾ�ַ���

  WindowStateI: Word;  //��¼����״̬
  WindowStateII: Word = 0;  //��¼��������󻯻�������״̬
  WindowStateOK: Boolean;  //����״̬�����Ƿ�OK
  ShowRunOK: Boolean = false; //��������ʾʱֻ����һ��
  MainFormTop, MainFormHeight, MainFormLeft, MainFormWidth: Integer;

  TabWidth: Integer;   //��ǩ���  120
  HopeTabWidth:Integer;   //������ǩ�Ŀ��  180

  //OnlyCurrentPage: Boolean; //���õ�ǰҳ��

  TabAutoWidth: Boolean = true;  //�Ƿ�����Ӧ��ǩ
  //TabRigthClickEnableClose : Boolean = false; //�һ���ǩ��Ϣ�б�
  //TabParentDblClick: Word = 0;    //��ǩ�հ״�˫����Ҫ����
  NewlyUrl: string;   //������������һ��URL��ַ
  B_UseProxy: Boolean;  //ʹ���Լ��Ĵ���
  B_UseIEProxy: Boolean;  //ʹ��IE����
  //DocumentFocusEnable: Boolean = true;  //�Ƿ������ĵ��н���
  MoreUrlOpen: Boolean = false;  //�򿪶�URL

  TimerRunOne :Boolean = false; //ֻ����һ�ε�

  RunOne: Boolean = true; //�Ƿ�ֻ����һ��ʵ����־

  CloseApp: Boolean=false; //�Ƿ��ڹرճ���
  AppCloseHint: Boolean = false;  //�˳�����ʱ�Ƿ���ʾ

  NickName, UserName, PassWord, Answer, Email, RealName: String; //�Զ����

  FavDirMe: Boolean;  //���Լ����ղؼ�?
  FavoritFolder, SFavoritFolder: string; //�ղؼ�Ŀ¼
  //FavoritDir: String;
  //B_NFavoritFolder: Boolean = false; //�ղؼз�ϵͳ
  FavoritCote: Boolean = false; //�������ղؼ�
  ShowSideCote: Boolean = false; //��ʾ���
  SideCoteWidth: Integer = 233;
  SideStatShape: Boolean = false; //������Ƿ��Զ�����
  //SideCoteAllHide: Boolean = true; //������Ƿ���ȫ����

  SideAt: Word = 1;  //��������λ���ղؼл��Ǹ������ŵ�λ��?
  MusicPlayType: Word = 0;   //�����������
  MusicPlayOrder: Word = 1;  //��������˳��
  OnlyPlayOne: Boolean;  //��������?

  MemoryThrift: Boolean; //�ڴ��Ƿ��Լģʽ
  MemoryThrift2: Boolean = true; //�Ƿ��ڴ�����
  CloseTabCount: Word = 0;  //ҳ��رյ�����
  CallBackMemory: Boolean = true;  //�Ƿ����ƵĻ����ڴ�
  //CBMemoryShow: Boolean; //��Ч�����ڴ����Ƿ���ʾ 
  Win32_NT: Boolean;

  StopPopup2, StopPopupO2, ShowWebIcon2: Boolean;
  //StopPopup: Boolean = false; //�Ƿ����ι��
  //IsPopup:Boolean = true; //�������
  //StopPopupMode1: Boolean = true; //�������
  StopPopupMode2: Boolean = true; //�������
  ClickSleepTime: Integer;   //����ӳ�ʱ��
  LClickSleepTime:Integer = 500; //�����������ʱֵ
  RClickSleepTime: Integer = 3000; //�Ҽ���������ʱֵ
  LButtonDown: Boolean = false; //��¼�����ҳ����������״̬
  LButtonX, LButtonY: integer;  //����������ҳ�н��е����λ��

  ThreadI:Byte; //integer; //�̸߳��ݴ�ִֵ�в�ͬ�Ĵ���
  FormsAutoComplete: Boolean = false; //��ҳ�Ƿ��Զ����

  SearchOn: Word = 0;   //��������Ϊ�ĸ�
  //GlobalOn: Word = 0;   //ȫ�ֿ���

  GetScreenSave: Boolean;  //����ץͼ�����Զ�COPY�������廹�����Ϊ...

  DocRoll: Boolean = true;   //˫����ҳ�ĵ��Ƿ��Զ�����
  ShowWebIcon: Boolean = true;   //�Ƿ���ʾ��վͼ��
  //UpdateButtonIcon: Boolean = true;  //�Ƿ����ͼ��
  ShowOptionOK: Boolean = false;   //ѡ���������
  //WebIconFile: String;  //��վͼ���ļ���ICO
  WebIconNeedBlankCount: Word = 3;   //��ʾ��վͼ������ո�
  ShowCloseHint: Boolean = false;  //��ʾ��ǩ�ر�С��ť
  CloseHintCur: Integer = 999;
  ShowCloseOK: Boolean = false;  //��ʾ��ǩ�ر�С��ť�Ƿ�OK
  //CloseHintUpdate: Boolean;
  //==
  SetRunOne: Boolean = false; //���ô����Ƿ�ȡֵ��־
  LoadUrlHistory: Boolean = true; //���������ʷ
  FavoritMenu: Boolean = false; //�ղؼв˵�
  LoadLastTime: Boolean = true; //�����ϴ��������
  CreateOneTab: Boolean = true; //�����󴴽�һ����ǩ
  InitForce: Boolean; //��ʼ����2

  OpenToUrl: String;
  StartPageTo : Word = 99; //��ʼҳָ��
  ExitCleanAllHistory: Boolean = false; //�˳�ʱ��������������¼
  CleanAddress: Boolean = false;
  CleanHistory: Boolean = false;
  CleanCache: Boolean = false;
  CleanCookies: Boolean = false;
  CleanRecent: Boolean = false;
  //ShowSideCoteInit: Boolean = false;  //��һ����ʾ�����
  GoToNewPage: Boolean = true; //����ҳ��ʱ�Ƿ�ת����ҳ��
  InstallTrayIcon: Boolean = true; //��װ����ͼ��   noread
  AppendTab: Boolean = true;   //�Ƿ��ڵ�ǰҳ����׷�ӱ�ǩ
  NewTabAtEnd: Boolean;  //�½��ı�ǩλ�������  
  CloseGoTab: Boolean = false;  //�ر�ҳ����Ƿ�ת����һ��ǩ
  HoldOneTab: Boolean = true; //�رձ�ǩ�Ƿ������һ����ǩ
  RightClick: Boolean;  //�Ƿ��ڱ�ǩ������һ�?
  RightClickClose: Boolean = true; //��ǩ������Ҽ��Ƿ�ر�ҳ��
  StatusBarStrDT: String = '';  //״̬����ʾ.
  UseMouseSS: Boolean = false; //�Ƿ������������
  SSTop,SSButtom,SSLeft,SSRight,SSRightTop,SSRightButtom: Byte;
  WeatherCityName: String = ''; //����Ԥ������
  //==

  CanShowContextMenu: Boolean = true; //�Ƿ���������ҳ�Ҽ��˵�
  ZoomFlag:Word=0;  //��ҳ���Ŵ�С��־
  FontZoom:Word=2;  //��ҳ���ִ�С��־ 

  QuickLiniStr:Array [0..3] of string;  //�����ַ�б�
  
  EXOK: Boolean;
  AlexaUrl: String;
  AlexaEx: Boolean = true;
  
  AutoHintFile, HintStaticFile: String;
  AutoHintReadOK: Boolean;
  FormAutoHintCreateOK: Boolean;
  HintTabOK1, HintTabOK2, HintTabOK3, HintTabOK4, HintTabOK5, HintTabOK6, HintTabOK7: Boolean;

implementation

end.