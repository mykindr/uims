{
������������������������������������������������������
��WindowsOPT v1.12                                  ��
�ĩ���������������������������������������������������
������ ѧϰ������                                   ��
�ĩ���������������������������������������������������
���ҵ�BLOG: http://hi.baidu.com/ddstrg              ��
�ĩ���������������������������������������������������
������Ӳ��: http://ddstrg.ys168.com                 ��
�ĩ���������������������������������������������������
����������������ڹ���                              ��
������������������������������������������������������
}

unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls,
  StdCtrls, ImgList, ExtCtrls, ActnList, ShellApi,
  ShlObj, Registry, Menus, ComObj, mmsystem,
  RzLabel, RzCommon, RzStatus, RzPanel, RzGroupBar, RzEdit, RzTabs, RzButton,
  RzRadGrp, RzRadChk, jpeg, UWaterEffect, Dialogs;

Const
  CM_Restore=WM_User+$1000;{�Զ����"�ָ�"��Ϣ}
  MyAppName='MyDelphiProgram';

type
  TFrmMain = class(TForm)
    ImageListMain: TImageList;
    RzPgWorkArea: TRzPageControl;
    Tab02000XP: TRzTabSheet;
    Tab1Ser: TRzTabSheet;
    Tab2Net: TRzTabSheet;
    Tab3Media: TRzTabSheet;
    Tab4XP: TRzTabSheet;
    Tab5SysInfo: TRzTabSheet;
    RzGroupBarMain: TRzGroupBar;
    RzGroup1: TRzGroup;
    RzGroup2: TRzGroup;
    RzGroup3: TRzGroup;
    Tab6Tools: TRzTabSheet;
    Tab7About: TRzTabSheet;
    RzStatusBarMain: TRzStatusBar;
    RzClockStatus1: TRzClockStatus;
    RzKeyStatus1: TRzKeyStatus;
    RzKeyStatus2: TRzKeyStatus;
    RzKeyStatus3: TRzKeyStatus;
    RzKeyStatus4: TRzKeyStatus;
    ActListMain: TActionList;
    act2000XP: TAction;
    actExit: TAction;
    actAbout: TAction;
    actServer: TAction;
    actNetwork: TAction;
    actSysinfo: TAction;
    actOthers: TAction;
    actXP: TAction;
    actMedia: TAction;
    RzMemo1: TRzMemo;
    RzMenuControllerMain: TRzMenuController;
    RzPgOtherTools: TRzPageControl;
    tabSysDirCompent: TRzTabSheet;
    tabUtility: TRzTabSheet;
    RzMBtnSysDir: TRzMenuButton;
    RzMBtnSetFile: TRzMenuButton;
    RzMBtnHideDir: TRzMenuButton;
    PopMenuSysDir: TPopupMenu;
    PopMenuSetFile: TPopupMenu;
    PopMenuHideDir: TPopupMenu;
    AppPatch1: TMenuItem;
    config1: TMenuItem;
    DownloadedProgramFiles1: TMenuItem;
    DownloadedProgramFiles2: TMenuItem;
    drivers1: TMenuItem;
    DriverCache1: TMenuItem;
    Media1: TMenuItem;
    OfflineWebPages1: TMenuItem;
    Prefetch1: TMenuItem;
    ProgramFiles1: TMenuItem;
    System1: TMenuItem;
    Wallpaper1: TMenuItem;
    Windows1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    CSC1: TMenuItem;
    dllcache1: TMenuItem;
    GroupPolicy1: TMenuItem;
    inf1: TMenuItem;
    Installer1: TMenuItem;
    InstallShieldInstallationInformation1: TMenuItem;
    msdownldtmp1: TMenuItem;
    PIF1: TMenuItem;
    UninstallInformation1: TMenuItem;
    WindowsUpdate1: TMenuItem;
    ApplicationData1: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    CDBurning1: TMenuItem;
    Cookie1: TMenuItem;
    Favorites1: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    History1: TMenuItem;
    Internet1: TMenuItem;
    LocalSettingsApplicationData1: TMenuItem;
    MyMusic1: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    MyPictures1: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    MyVideos1: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    NetHood1: TMenuItem;
    PrintHood1: TMenuItem;
    Recent1: TMenuItem;
    SendTo1: TMenuItem;
    emplates1: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    PopMenuOffice: TPopupMenu;
    PopMenuAdminTool: TPopupMenu;
    PopMenuCtrlPanel: TPopupMenu;
    PopMenuOthers: TPopupMenu;
    Access1: TMenuItem;
    DrWatson1: TMenuItem;
    Internet2: TMenuItem;
    InternetExplorer1: TMenuItem;
    Excel1: TMenuItem;
    FrontPage1: TMenuItem;
    InfoPath1: TMenuItem;
    OneNote1: TMenuItem;
    Outlook1: TMenuItem;
    PictureManager1: TMenuItem;
    PowerPoint1: TMenuItem;
    Project1: TMenuItem;
    Publisher1: TMenuItem;
    Visio1: TMenuItem;
    Word1: TMenuItem;
    DxDiag1: TMenuItem;
    MsConfig1: TMenuItem;
    RegEdt321: TMenuItem;
    RegEdit1: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    N45: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    N48: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N56: TMenuItem;
    N57: TMenuItem;
    N58: TMenuItem;
    N59: TMenuItem;
    Java1: TMenuItem;
    ODBC1: TMenuItem;
    N60: TMenuItem;
    N61: TMenuItem;
    N62: TMenuItem;
    N63: TMenuItem;
    N64: TMenuItem;
    N65: TMenuItem;
    N66: TMenuItem;
    N67: TMenuItem;
    N68: TMenuItem;
    N69: TMenuItem;
    N70: TMenuItem;
    N71: TMenuItem;
    N72: TMenuItem;
    N73: TMenuItem;
    N74: TMenuItem;
    N75: TMenuItem;
    N76: TMenuItem;
    N77: TMenuItem;
    N78: TMenuItem;
    RzMBtnOffice: TRzMenuButton;
    RzMBtnAdminTool: TRzMenuButton;
    RzMBtnCtrlPanel: TRzMenuButton;
    RzMBtnOthers: TRzMenuButton;
    N79: TMenuItem;
    Windows2: TMenuItem;
    N80: TMenuItem;
    N81: TMenuItem;
    N82: TMenuItem;
    N83: TMenuItem;
    N84: TMenuItem;
    N85: TMenuItem;
    N86: TMenuItem;
    N87: TMenuItem;
    N88: TMenuItem;
    N89: TMenuItem;
    N90: TMenuItem;
    N91: TMenuItem;
    N92: TMenuItem;
    N93: TMenuItem;
    N94: TMenuItem;
    N95: TMenuItem;
    N96: TMenuItem;
    N97: TMenuItem;
    N98: TMenuItem;
    WindowsMediaPlayer1: TMenuItem;
    WindowsMediaPlayer641: TMenuItem;
    WindowsMovieMaker1: TMenuItem;
    N99: TMenuItem;
    N100: TMenuItem;
    N101: TMenuItem;
    InternetExplorer2: TMenuItem;
    OutlookExpress1: TMenuItem;
    SQLServer1: TMenuItem;
    N102: TMenuItem;
    N103: TMenuItem;
    N104: TMenuItem;
    N105: TMenuItem;
    N106: TMenuItem;
    N107: TMenuItem;
    N108: TMenuItem;
    N109: TMenuItem;
    N110: TMenuItem;
    N111: TMenuItem;
    N112: TMenuItem;
    N113: TMenuItem;
    IExpress1: TMenuItem;
    Internet3: TMenuItem;
    N114: TMenuItem;
    N115: TMenuItem;
    N116: TMenuItem;
    N117: TMenuItem;
    N118: TMenuItem;
    N119: TMenuItem;
    N120: TMenuItem;
    CD1: TMenuItem;
    DVD1: TMenuItem;
    Label1: TLabel;
    N121: TMenuItem;
    N122: TMenuItem;
    GroupBoxNew: TGroupBox;
    LabEditNew: TLabeledEdit;
    RzBtnNew: TRzButton;
    PopMenuCDRom: TPopupMenu;
    PopMenuTaskBar: TPopupMenu;
    PopMenuShutdown: TPopupMenu;
    N123: TMenuItem;
    N124: TMenuItem;
    N125: TMenuItem;
    N126: TMenuItem;
    N127: TMenuItem;
    N128: TMenuItem;
    N129: TMenuItem;
    GroupBoxMini: TGroupBox;
    RzBtnStartMana: TRzButton;
    RzBtnTaskMana: TRzButton;
    GroupBoxSystem: TGroupBox;
    RzBtnClearHis: TRzButton;
    RzBtnColor: TRzButton;
    RzBtnIconCache: TRzButton;
    RzBtnUnHard: TRzButton;
    RzBtnUnMouKob: TRzButton;
    TabDOS: TRzTabSheet;
    MemoDOS: TMemo;
    LabEditDOS: TLabeledEdit;
    RzBtnDOS: TRzButton;
    PopMenuPageView: TPopupMenu;
    PopMenuSP4Jian: TPopupMenu;
    N130: TMenuItem;
    N131: TMenuItem;
    N132: TMenuItem;
    N133: TMenuItem;
    PopMenuZIP: TPopupMenu;
    N134: TMenuItem;
    N135: TMenuItem;
    PopMenuMediaView: TPopupMenu;
    N136: TMenuItem;
    N137: TMenuItem;
    PopMenuPhotoView: TPopupMenu;
    N138: TMenuItem;
    N139: TMenuItem;
    PopMenuScrrun: TPopupMenu;
    PopMenuUpdate: TPopupMenu;
    N140: TMenuItem;
    N141: TMenuItem;
    N142: TMenuItem;
    N143: TMenuItem;
    PopMenuChkntfs: TPopupMenu;
    N510: TMenuItem;
    N1010: TMenuItem;
    PopMenuFix: TPopupMenu;
    N144: TMenuItem;
    N145: TMenuItem;
    Excel2: TMenuItem;
    Word2: TMenuItem;
    InternetExplorer3: TMenuItem;
    MemoHotfix: TMemo;
    LabOS: TLabel;
    LabSysdir: TLabel;
    LabMemorySize: TLabel;
    LabIEVer: TLabel;
    LabIP: TLabel;
    LabEditIEHotfix: TLabeledEdit;
    LabUser: TLabel;
    LabRunTime: TLabel;
    GroupBoxRegInfo: TGroupBox;
    Timer1: TTimer;
    RzBtnComName: TRzButton;
    LabEditComName: TLabeledEdit;
    LabEditOwner: TLabeledEdit;
    LabEditOrgan: TLabeledEdit;
    RzBtnRegInfo: TRzButton;
    LabEditSourPath: TLabeledEdit;
    RzBtnSourcePath: TRzButton;
    RzBitBtnSourcePath: TRzBitBtn;
    TabBAT: TRzTabSheet;
    GroupBox2000: TGroupBox;
    RzMenuBtnPageView: TRzMenuButton;
    RzMenuBtnSP4Jian: TRzMenuButton;
    GroupBoxXP: TGroupBox;
    RzMenuBtnZIP: TRzMenuButton;
    RzMenuBtnMediaView: TRzMenuButton;
    RzMenuBtnPhotoView: TRzMenuButton;
    RzBtnXPJiHuo: TRzButton;
    GroupBoxUnName: TGroupBox;
    RzMenuBtnScrrun: TRzMenuButton;
    RzMenuBtnUpdate: TRzMenuButton;
    RzMenuBtnChkntfs: TRzMenuButton;
    N146: TMenuItem;
    N147: TMenuItem;
    RzMenuBtnCDRom: TRzMenuButton;
    RzMenuBtnTaskBar: TRzMenuButton;
    RzMenuBtnShutdown: TRzMenuButton;
    RzMenuBtnFix: TRzMenuButton;
    ComboBoxHint: TComboBox;
    Label2: TLabel;
    N148: TMenuItem;
    RzChkGroupXP: TRzCheckGroup;
    RzChkGroupXPSP2: TRzCheckGroup;
    Label3: TLabel;
    ComBoxXP: TComboBox;
    RzBitBtnXPOK: TRzBitBtn;
    RzChkGroupMedia: TRzCheckGroup;
    RzBitBtnMediaOK: TRzBitBtn;
    Label4: TLabel;
    ComBoxMedia: TComboBox;
    RzBitBtn1: TRzBitBtn;
    Label5: TLabel;
    ComBoxNet: TComboBox;
    RzChkGroupNet: TRzCheckGroup;
    RzChkGroupIE: TRzCheckGroup;
    RzBitBtnSer: TRzBitBtn;
    Label6: TLabel;
    ComBoxSer: TComboBox;
    RzChkGroupSer: TRzCheckGroup;
    RzRdiGroupSer: TRzRadioGroup;
    N149: TMenuItem;
    RzBitBtn2000XPOK: TRzBitBtn;
    Label7: TLabel;
    ComBox2000XP: TComboBox;
    RzPg2000XP: TRzPageControl;
    TabSheet1: TRzTabSheet;
    TabSheet2: TRzTabSheet;
    RzChkBoxMenuDelay: TRzCheckBox;
    EditMenuDelay: TEdit;
    RzChkGroupSystem: TRzCheckGroup;
    RzChkGroupHardware: TRzCheckGroup;
    RzChkGroupExplorer: TRzCheckGroup;
    RzChkGroupStartMenu: TRzCheckGroup;
    N150: TMenuItem;
    N151: TMenuItem;
    Internet4: TMenuItem;
    N152: TMenuItem;
    USB1: TMenuItem;
    RzChkGroupStartMenuItemCheckeditrue1: TMenuItem;
    N153: TMenuItem;
    MainMenu1: TMainMenu;
    N2000XP1: TMenuItem;
    N2000XP2: TMenuItem;
    N154: TMenuItem;
    N155: TMenuItem;
    MediaPlayer1: TMenuItem;
    XP1: TMenuItem;
    N156: TMenuItem;
    N157: TMenuItem;
    N158: TMenuItem;
    N159: TMenuItem;
    N160: TMenuItem;
    N161: TMenuItem;
    N162: TMenuItem;
    N163: TMenuItem;
    N164: TMenuItem;
    N165: TMenuItem;
    OpenDiaLoad: TOpenDialog;
    SaveDiaSave: TSaveDialog;
    Windows3: TMenuItem;
    NetMeeting1: TMenuItem;
    Windows4: TMenuItem;
    N166: TMenuItem;
    N167: TMenuItem;
    N168: TMenuItem;
    N170: TMenuItem;
    N171: TMenuItem;
    DDE1: TMenuItem;
    DriverVerifierManager1: TMenuItem;
    N169: TMenuItem;
    N172: TMenuItem;
    elnet1: TMenuItem;
    N173: TMenuItem;
    N174: TMenuItem;
    N175: TMenuItem;
    WindowsMediaPlayer2: TMenuItem;
    N176: TMenuItem;
    tmr1: TTimer;
    img1: TImage;
    N179: TMenuItem;
    mMenuCheck: TMenuItem;
    RzMenuBtnIntelVGA: TRzMenuButton;
    PopMenuVGA: TPopupMenu;
    N180: TMenuItem;
    N181: TMenuItem;
    Label8: TLabel;
    N177: TMenuItem;
    RzPanel1: TRzPanel;
    RzURLLabHanzify: TRzURLLabel;
    RzURLLabel1: TRzURLLabel;
    RzURLLabel2: TRzURLLabel;
    RzURLLabHomePage: TRzURLLabel;
    RzURLLabNetDisk: TRzURLLabel;
    Intel1: TMenuItem;
    nVIDIA1: TMenuItem;
    ATi1: TMenuItem;
    N178: TMenuItem;
    N182: TMenuItem;
    N183: TMenuItem;
    N184: TMenuItem;
    procedure actAboutExecute(Sender: TObject);    
    procedure actExitExecute(Sender: TObject);
    procedure act2000XPExecute(Sender: TObject);
    procedure actServerExecute(Sender: TObject);
    procedure actNetworkExecute(Sender: TObject);
    procedure actXPExecute(Sender: TObject);
    procedure actMediaExecute(Sender: TObject);
    procedure actSysinfoExecute(Sender: TObject);
    procedure actOthersExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrWatson1Click(Sender: TObject);
    procedure DxDiag1Click(Sender: TObject);
    procedure MsConfig1Click(Sender: TObject);
    procedure RegEdt321Click(Sender: TObject);
    procedure RegEdit1Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure N44Click(Sender: TObject);
    procedure N45Click(Sender: TObject);
    procedure N46Click(Sender: TObject);
    procedure N47Click(Sender: TObject);
    procedure N48Click(Sender: TObject);
    procedure N49Click(Sender: TObject);
    procedure N50Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N54Click(Sender: TObject);
    procedure N55Click(Sender: TObject);
    procedure N56Click(Sender: TObject);
    procedure N57Click(Sender: TObject);
    procedure N58Click(Sender: TObject);
    procedure N59Click(Sender: TObject);
    procedure Internet2Click(Sender: TObject);
    procedure Java1Click(Sender: TObject);
    procedure ODBC1Click(Sender: TObject);
    procedure Windows2Click(Sender: TObject);
    procedure N60Click(Sender: TObject);
    procedure N79Click(Sender: TObject);
    procedure N61Click(Sender: TObject);
    procedure N62Click(Sender: TObject);
    procedure N63Click(Sender: TObject);
    procedure N64Click(Sender: TObject);
    procedure N65Click(Sender: TObject);
    procedure N66Click(Sender: TObject);
    procedure N67Click(Sender: TObject);
    procedure N68Click(Sender: TObject);
    procedure N69Click(Sender: TObject);
    procedure N70Click(Sender: TObject);
    procedure N71Click(Sender: TObject);
    procedure N72Click(Sender: TObject);
    procedure N73Click(Sender: TObject);
    procedure N74Click(Sender: TObject);
    procedure N75Click(Sender: TObject);
    procedure N76Click(Sender: TObject);
    procedure N77Click(Sender: TObject);
    procedure N78Click(Sender: TObject);
    procedure CSC1Click(Sender: TObject);
    procedure dllcache1Click(Sender: TObject);
    procedure GroupPolicy1Click(Sender: TObject);
    procedure inf1Click(Sender: TObject);
    procedure Installer1Click(Sender: TObject);
    procedure InstallShieldInstallationInformation1Click(Sender: TObject);
    procedure msdownldtmp1Click(Sender: TObject);
    procedure PIF1Click(Sender: TObject);
    procedure UninstallInformation1Click(Sender: TObject);
    procedure WindowsUpdate1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Access1Click(Sender: TObject);
    procedure Excel1Click(Sender: TObject);
    procedure FrontPage1Click(Sender: TObject);
    procedure InfoPath1Click(Sender: TObject);
    procedure OneNote1Click(Sender: TObject);
    procedure Outlook1Click(Sender: TObject);
    procedure PictureManager1Click(Sender: TObject);
    procedure PowerPoint1Click(Sender: TObject);
    procedure Project1Click(Sender: TObject);
    procedure Publisher1Click(Sender: TObject);
    procedure Visio1Click(Sender: TObject);
    procedure Word1Click(Sender: TObject);
    procedure InternetExplorer1Click(Sender: TObject);
    procedure N80Click(Sender: TObject);
    procedure N81Click(Sender: TObject);
    procedure N82Click(Sender: TObject);
    procedure N83Click(Sender: TObject);
    procedure N84Click(Sender: TObject);
    procedure N85Click(Sender: TObject);
    procedure N86Click(Sender: TObject);
    procedure N87Click(Sender: TObject);
    procedure N88Click(Sender: TObject);
    procedure N89Click(Sender: TObject);
    procedure N90Click(Sender: TObject);
    procedure N91Click(Sender: TObject);
    procedure N92Click(Sender: TObject);
    procedure N93Click(Sender: TObject);
    procedure N94Click(Sender: TObject);
    procedure N95Click(Sender: TObject);
    procedure N96Click(Sender: TObject);
    procedure N97Click(Sender: TObject);
    procedure CD1Click(Sender: TObject);
    procedure DVD1Click(Sender: TObject);
    procedure WindowsMediaPlayer1Click(Sender: TObject);
    procedure WindowsMediaPlayer641Click(Sender: TObject);
    procedure WindowsMovieMaker1Click(Sender: TObject);
    procedure N99Click(Sender: TObject);
    procedure N100Click(Sender: TObject);
    procedure InternetExplorer2Click(Sender: TObject);
    procedure OutlookExpress1Click(Sender: TObject);
    procedure SQLServer1Click(Sender: TObject);
    procedure N102Click(Sender: TObject);
    procedure N103Click(Sender: TObject);
    procedure N104Click(Sender: TObject);
    procedure N105Click(Sender: TObject);
    procedure N107Click(Sender: TObject);
    procedure N108Click(Sender: TObject);
    procedure N109Click(Sender: TObject);
    procedure N110Click(Sender: TObject);
    procedure N111Click(Sender: TObject);
    procedure N112Click(Sender: TObject);
    procedure IExpress1Click(Sender: TObject);
    procedure Internet3Click(Sender: TObject);
    procedure N114Click(Sender: TObject);
    procedure N120Click(Sender: TObject);
    procedure N115Click(Sender: TObject);
    procedure N116Click(Sender: TObject);
    procedure N117Click(Sender: TObject);
    procedure N118Click(Sender: TObject);
    procedure N119Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure CDBurning1Click(Sender: TObject);
    procedure Cookie1Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure History1Click(Sender: TObject);
    procedure Internet1Click(Sender: TObject);
    procedure LocalSettingsApplicationData1Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure NetHood1Click(Sender: TObject);
    procedure PrintHood1Click(Sender: TObject);
    procedure Recent1Click(Sender: TObject);
    procedure SendTo1Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure N38Click(Sender: TObject);
    procedure N40Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure AppPatch1Click(Sender: TObject);
    procedure config1Click(Sender: TObject);
    procedure DownloadedProgramFiles1Click(Sender: TObject);
    procedure DownloadedProgramFiles2Click(Sender: TObject);
    procedure drivers1Click(Sender: TObject);
    procedure DriverCache1Click(Sender: TObject);
    procedure Media1Click(Sender: TObject);
    procedure OfflineWebPages1Click(Sender: TObject);
    procedure Prefetch1Click(Sender: TObject);
    procedure ProgramFiles1Click(Sender: TObject);
    procedure System1Click(Sender: TObject);
    procedure Wallpaper1Click(Sender: TObject);
    procedure Windows1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N123Click(Sender: TObject);
    procedure N124Click(Sender: TObject);
    procedure N125Click(Sender: TObject);
    procedure N126Click(Sender: TObject);
    procedure N127Click(Sender: TObject);
    procedure N128Click(Sender: TObject);
    procedure N129Click(Sender: TObject);
    procedure RzBtnNewClick(Sender: TObject);
    procedure RzBtnIconCacheClick(Sender: TObject);
    procedure RzBtnUnHardClick(Sender: TObject);
    procedure RzBtnUnMouKobClick(Sender: TObject);
    procedure RzBtnClearHisClick(Sender: TObject);
    procedure RzBtnColorClick(Sender: TObject);
    procedure RzBtnStartManaClick(Sender: TObject);
    procedure RzBtnTaskManaClick(Sender: TObject);
    procedure RzBtnDOSClick(Sender: TObject);
    procedure LabEditDOSKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure N130Click(Sender: TObject);
    procedure N131Click(Sender: TObject);
    procedure N132Click(Sender: TObject);
    procedure N133Click(Sender: TObject);
    procedure N134Click(Sender: TObject);
    procedure N135Click(Sender: TObject);
    procedure N136Click(Sender: TObject);
    procedure N137Click(Sender: TObject);
    procedure N138Click(Sender: TObject);
    procedure N139Click(Sender: TObject);
    procedure RzBtnXPJiHuoClick(Sender: TObject);
    procedure N140Click(Sender: TObject);
    procedure N141Click(Sender: TObject);
    procedure N142Click(Sender: TObject);
    procedure N143Click(Sender: TObject);
    procedure N510Click(Sender: TObject);
    procedure N1010Click(Sender: TObject);
    procedure N144Click(Sender: TObject);
    procedure N145Click(Sender: TObject);
    procedure Excel2Click(Sender: TObject);
    procedure Word2Click(Sender: TObject);
    procedure ComboBoxHintChange(Sender: TObject);
    procedure LabeEditHintDblClick(Sender: TObject);
    procedure InternetExplorer3Click(Sender: TObject);
    procedure MemoHotfixDblClick(Sender: TObject);
    procedure RzBtnComNameClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RzBtnSourcePathClick(Sender: TObject);
    procedure RzBtnRegInfoClick(Sender: TObject);
    procedure RzBitBtnSourcePathClick(Sender: TObject);
    procedure N146Click(Sender: TObject);
    procedure N147Click(Sender: TObject);
    procedure LabEditNewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure N148Click(Sender: TObject);
    procedure ComBoxXPChange(Sender: TObject);
    procedure RzBitBtnXPOKClick(Sender: TObject);
    procedure ComBoxMediaChange(Sender: TObject);
    procedure RzBitBtnMediaOKClick(Sender: TObject);
    procedure ComBoxNetChange(Sender: TObject);
    procedure RzBitBtn1Click(Sender: TObject);
    procedure ComBoxSerChange(Sender: TObject);
    procedure RzBitBtnSerClick(Sender: TObject);
    procedure N149Click(Sender: TObject);
    procedure RzChkGroupXPChange(Sender: TObject; Index: Integer; NewState: TCheckBoxState);
    procedure EditMenuDelayKeyPress(Sender: TObject; var Key: Char);
    procedure ComBox2000XPChange(Sender: TObject);
    procedure RzBitBtn2000XPOKClick(Sender: TObject);
    procedure N150Click(Sender: TObject);
    procedure N151Click(Sender: TObject);
    procedure Internet4Click(Sender: TObject);
    procedure N152Click(Sender: TObject);
    procedure USB1Click(Sender: TObject);
    procedure RzChkGroupStartMenuItemCheckeditrue1Click(Sender: TObject);
    procedure N153Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure N163Click(Sender: TObject);
    procedure N164Click(Sender: TObject);
    procedure EditMenuDelayEnter(Sender: TObject);
    procedure EditMenuDelayExit(Sender: TObject);
    procedure Windows3Click(Sender: TObject);
    procedure NetMeeting1Click(Sender: TObject);
    procedure Windows4Click(Sender: TObject);
    procedure N166Click(Sender: TObject);
    procedure N167Click(Sender: TObject);
    procedure N170Click(Sender: TObject);
    procedure N171Click(Sender: TObject);
    procedure DDE1Click(Sender: TObject);
    procedure DriverVerifierManager1Click(Sender: TObject);
    procedure N169Click(Sender: TObject);
    procedure N172Click(Sender: TObject);
    procedure elnet1Click(Sender: TObject);
    procedure N173Click(Sender: TObject);
    procedure N174Click(Sender: TObject);
    procedure N175Click(Sender: TObject);
    procedure WindowsMediaPlayer2Click(Sender: TObject);
    procedure N176Click(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure img1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Tab7AboutExit(Sender: TObject);
    procedure img1Click(Sender: TObject);
    procedure mMenuCheckClick(Sender: TObject);
    procedure N180Click(Sender: TObject);
    procedure N181Click(Sender: TObject);
    procedure N177Click(Sender: TObject);
    procedure N178Click(Sender: TObject);
    procedure N183Click(Sender: TObject);
    procedure N182Click(Sender: TObject);
    procedure N184Click(Sender: TObject);
  private
    { Private declarations }
    Water: TWaterEffect;
    Bmp: TBitmap;
  public
    { Public declarations }
    Procedure CreateParams(var Params:TCreateParams);override;
    Procedure RestoreRequest(var message:TMessage);message CM_Restore;
    procedure WndProc(var Message: TMessage); override;
  end;

var
  FrmMain: TFrmMain;
  shellapp: variant;
  windir,sysdir :array[1..50] of char;
  reg1, reg2, reg3, reg4:TRegistry;
  os, sp, ProgramFilesDir:string;
  x:integer;

//���������������� stdcall;external 'uncon.dll';
function RegSetDword(RootKey: HKEY; Name: String; Value: Cardinal): boolean;stdcall;external 'uncon.dll';
function RefreshScreenIcons : Boolean;stdcall;external 'uncon.dll';
procedure ClearHistory;stdcall;external 'uncon.dll';
procedure ColorSet;stdcall;external 'uncon.dll';
procedure StartMana;stdcall;external 'uncon.dll';
procedure TaskMana;stdcall;external 'uncon.dll';

implementation

uses
inifiles, UMainFunc, URunDosThrd;

var
  myini, CustomIni:TInifile;
  Bufor: array[0..3] of Byte; //׼��00 00 00 00 �ĸ�ֵλ
  Bufor2: Byte;
{$R *.dfm}

{ָ����������}
Procedure TFrmMain.CreateParams(var Params:TCreateParams);
begin
  Inherited CreateParams(Params);
  Params.WinClassName:=MyAppName;
end;

{�����ָ�����Ϣ}
Procedure TFrmMain.RestoreRequest(var message:TMessage);
begin
  if IsIconic(Application.Handle)=TRUE
  then Application.Restore
  else Application.BringToFront;
end;

procedure TFrmMain.actExitExecute(Sender: TObject);
begin //�˳�
  Application.terminate;
end;

procedure TFrmMain.act2000XPExecute(Sender: TObject);
begin //2000 / XP
  RzPgWorkArea.ActivePageIndex:=0;
  N2000XP2.Checked:=true;
  N154.Checked:=false;
  N155.Checked:=false;
  MediaPlayer1.Checked:=false;
  XP1.Checked:=false;
  N157.Checked:=false;
  N158.Checked:=false;
  N160.Checked:=false;
end;

procedure TFrmMain.actServerExecute(Sender: TObject);
begin //����
  RzPgWorkArea.ActivePageIndex:=1;
  N2000XP2.Checked:=false;
  N154.Checked:=true;
  N155.Checked:=false;
  MediaPlayer1.Checked:=false;
  XP1.Checked:=false;
  N157.Checked:=false;
  N158.Checked:=false;
  N160.Checked:=false;
end;

procedure TFrmMain.actNetworkExecute(Sender: TObject);
begin //����
  RzPgWorkArea.ActivePageIndex:=2;
  N2000XP2.Checked:=false;
  N154.Checked:=false;
  N155.Checked:=true;
  MediaPlayer1.Checked:=false;
  XP1.Checked:=false;
  N157.Checked:=false;
  N158.Checked:=false;
  N160.Checked:=false;
end;

procedure TFrmMain.actMediaExecute(Sender: TObject);
begin //Windows Media Player
  RzPgWorkArea.ActivePageIndex:=3;
  N2000XP2.Checked:=false;
  N154.Checked:=false;
  N155.Checked:=false;
  MediaPlayer1.Checked:=true;
  XP1.Checked:=false;
  N157.Checked:=false;
  N158.Checked:=false;
  N160.Checked:=false;
end;

procedure TFrmMain.actXPExecute(Sender: TObject);
begin //XP
  RzPgWorkArea.ActivePageIndex:=4;
  N2000XP2.Checked:=false;
  N154.Checked:=false;
  N155.Checked:=false;
  MediaPlayer1.Checked:=false;
  XP1.Checked:=true;
  N157.Checked:=false;
  N158.Checked:=false;
  N160.Checked:=false;
end;

procedure TFrmMain.actSysinfoExecute(Sender: TObject);
begin //ϵͳ��Ϣ
  RzPgWorkArea.ActivePageIndex:=5;
  N2000XP2.Checked:=false;
  N154.Checked:=false;
  N155.Checked:=false;
  MediaPlayer1.Checked:=false;
  XP1.Checked:=false;
  N157.Checked:=true;
  N158.Checked:=false;
  N160.Checked:=false;
end;

procedure TFrmMain.actOthersExecute(Sender: TObject);
begin //����
  RzPgWorkArea.ActivePageIndex:=6;
  N2000XP2.Checked:=false;
  N154.Checked:=false;
  N155.Checked:=false;
  MediaPlayer1.Checked:=false;
  XP1.Checked:=false;
  N157.Checked:=false;
  N158.Checked:=true;
  N160.Checked:=false;
  //LabEditNew.SetFocus;
end;

procedure TFrmMain.actAboutExecute(Sender: TObject);
begin //����
  RzPgWorkArea.ActivePageIndex:=7;
  N2000XP2.Checked:=false;
  N154.Checked:=false;
  N155.Checked:=false;
  MediaPlayer1.Checked:=false;
  XP1.Checked:=false;
  N157.Checked:=false;
  N158.Checked:=false;
  N160.Checked:=true;
  //���롰���ڡ���ǩʱ��ʾ��־ͼƬ
  Water.Render(Bmp,img1.Picture.Bitmap);
  img1.Repaint;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  ComBox2000XP.SetFocus
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var i:byte; filename:string;
const Uhint = '�˲��������棡';
begin
  for i:=0 to RzChkGroupSystem.Items.Count-1 do RzChkGroupSystem.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupHardware.Items.Count-1 do RzChkGroupHardware.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupExplorer.Items.Count-1 do RzChkGroupExplorer.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupStartMenu.Items.Count-1 do RzChkGroupStartMenu.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupSer.Items.Count-1 do RzChkGroupSer.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupNet.Items.Count-1 do RzChkGroupNet.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupIE.Items.Count-1 do RzChkGroupIE.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupMedia.Items.Count-1 do RzChkGroupMedia.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupXP.Items.Count-1 do RzChkGroupXP.Checks[i].ShowHint:=true;
  for i:=0 to RzChkGroupXPSP2.Items.Count-1 do RzChkGroupXPSP2.Checks[i].ShowHint:=true;

  RzChkGroupSystem.Checks[4].Hint:=Uhint;
  RzChkGroupSystem.Checks[10].Hint:=Uhint;
  RzChkGroupIE.Checks[5].Hint:=Uhint;
  RzChkGroupIE.Checks[6].Hint:=Uhint;
  RzChkGroupXP.Checks[6].Hint := '��Ҫ��ʾ��'#13'��ֹԶ�����ӵ�ͬʱҲ����ʹ�õ��Եĺ���ӿ���������';
  RzChkGroupXP.Checks[7].Hint := '��Ҫ��ʾ�������ʹ�� Administrator �ʻ����������ʻ�����'#13'һ��Ҫ�ڵ�½��Ļ����ʾ����Ա�ʻ��������޷�����ϵͳ������';

  filename:=ExtractFilePath(paramstr(0))+'WindowsOPT.ini'; //ini�ļ���
  myini:=TInifile.Create(filename); //����ini�ļ�
//ϵͳ���
  for i:=0 to RzChkGroupSystem.Items.Count-1 do RzChkGroupSystem.ItemChecked[i]:=myini.ReadBool('System',inttostr(i),false);
//Ӳ�����
  for i:=0 to RzChkGroupHardware.Items.Count-1 do RzChkGroupHardware.ItemChecked[i]:=myini.ReadBool('Hardware',inttostr(i),false);
//��Դ������
  for i:=0 to RzChkGroupExplorer.Items.Count-1 do RzChkGroupExplorer.ItemChecked[i]:=myini.ReadBool('Explorer',inttostr(i),false);
//��ʼ�˵�
  for i:=0 to RzChkGroupStartMenu.Items.Count-1 do RzChkGroupStartMenu.ItemChecked[i]:=myini.ReadBool('StartMenu',inttostr(i),false);
  RzChkBoxMenuDelay.Checked:=myini.ReadBool('StartMenu','MenuShowDelay',true);
//����
  RzRdiGroupSer.ItemIndex:=myini.ReadInteger('Service','options',0);
  for i:=0 to RzChkGroupSer.Items.Count-1 do RzChkGroupSer.ItemChecked[i]:=myini.ReadBool('Service',inttostr(i),false);
//����
  for i:=0 to RzChkGroupNet.Items.Count-1 do RzChkGroupNet.ItemChecked[i]:=myini.ReadBool('Network',inttostr(i),false);
//IE
  for i:=0 to RzChkGroupIE.Items.Count-1 do RzChkGroupIE.ItemChecked[i]:=myini.ReadBool('IE',inttostr(i),false);
//Media
  for i:=0 to RzChkGroupMedia.Items.Count-1 do RzChkGroupMedia.ItemChecked[i]:=myini.ReadBool('Media',inttostr(i),false);
//XP
  for i:=0 to RzChkGroupXP.Items.Count-1 do RzChkGroupXP.ItemChecked[i]:=myini.ReadBool('XP',inttostr(i),false);
//XPSP2
  for i:=0 to RzChkGroupXPSP2.Items.Count-1 do RzChkGroupXPSP2.ItemChecked[i]:=myini.ReadBool('XPSP2',inttostr(i),false);
//�л��˵���ɫ
  mMenuCheck.Checked:=myini.ReadBool('MenuIni','MenuCheck',false);
  RzMenuControllerMain.GradientColorDefault:=myini.ReadBool('MenuIni','MenuStyle',false);

  screen.HintFont.size:=10; //����hint������
  Application.HintHidePause:=600000;  //hintͣ��ʱ��
  shellapp:=CreateOleObject('Shell.Application');
  GetWindowsDirectory(@windir,50); //���WindowsĿ¼
  GetSystemDirectory(@sysdir,50); //���SystemĿ¼
  Reg1:=TRegistry.Create; Reg1.RootKey:=HKEY_LOCAL_MACHINE;
  Reg2:=TRegistry.Create; Reg2.RootKey:=HKEY_CURRENT_USER;
  Reg3:=TRegistry.Create; Reg3.RootKey:=HKEY_USERS;
  Reg4:=TRegistry.Create; Reg4.RootKey:=HKEY_CLASSES_ROOT;
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion',false) then ProgramFilesDir:=reg1.ReadString('ProgramFilesDir'); //���ProgramFilesĿ¼

  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then
  begin
    os:=reg1.ReadString('ProductName');  sp:=reg1.ReadString('CSDVersion');
  end;

  ComBoxXP.Enabled:= os='Microsoft Windows XP';
  RzChkGroupXP.Enabled:= os='Microsoft Windows XP';
  RzChkGroupXPSP2.Enabled:= ( os='Microsoft Windows XP' ) and ( sp='Service Pack 2' ) ;

  Bmp := TBitmap.Create;
  Bmp.Assign(img1.Picture.Graphic);
  img1.Picture.Graphic := nil;
  img1.Picture.Bitmap.Height := Bmp.Height;
  img1.Picture.Bitmap.Width := Bmp.Width;
  Water := TWaterEffect.Create;
  Water.SetSize(Bmp.Width,Bmp.Height);

  x:=img1.Height;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var i:byte;
begin
//ϵͳ���
  for i:=0 to RzChkGroupSystem.Items.Count-1 do myini.WriteBool('System',inttostr(i),RzChkGroupSystem.ItemChecked[i]);
//Ӳ�����
  for i:=0 to RzChkGroupHardware.Items.Count-1 do myini.WriteBool('Hardware',inttostr(i),RzChkGroupHardware.ItemChecked[i]);
//��Դ������
  for i:=0 to RzChkGroupExplorer.Items.Count-1 do myini.WriteBool('Explorer',inttostr(i),RzChkGroupExplorer.ItemChecked[i]);
//��ʼ�˵�
  for i:=0 to RzChkGroupStartMenu.Items.Count-1 do myini.WriteBool('StartMenu',inttostr(i),RzChkGroupStartMenu.ItemChecked[i]);
  myini.WriteBool('StartMenu','MenuShowDelay',RzChkBoxMenuDelay.Checked);
//����
  myini.WriteInteger('Service','options',RzRdiGroupSer.ItemIndex);
  for i:=0 to RzChkGroupSer.Items.Count-1 do myini.WriteBool('Service',inttostr(i),RzChkGroupSer.ItemChecked[i]);
//����
  for i:=0 to RzChkGroupNet.Items.Count-1 do myini.WriteBool('Network',inttostr(i),RzChkGroupNet.ItemChecked[i]);
//IE
  for i:=0 to RzChkGroupIE.Items.Count-1 do myini.WriteBool('IE',inttostr(i),RzChkGroupIE.ItemChecked[i]);
//Media
  for i:=0 to RzChkGroupMedia.Items.Count-1 do myini.WriteBool('Media',inttostr(i),RzChkGroupMedia.ItemChecked[i]);
//XP
  for i:=0 to RzChkGroupXP.Items.Count-1 do myini.WriteBool('XP',inttostr(i),RzChkGroupXP.ItemChecked[i]);
//XPSP2
  for i:=0 to RzChkGroupXPSP2.Items.Count-1 do myini.WriteBool('XPSP2',inttostr(i),RzChkGroupXPSP2.ItemChecked[i]);
//�л��˵���ɫ
  myini.WriteBool('MenuIni','MenuCheck',mMenuCheck.Checked);
  myini.WriteBool('MenuIni','MenuStyle',RzMenuControllerMain.GradientColorDefault);

  myini.Destroy;
  Reg1.CloseKey; Reg1.Free;
  Reg2.CloseKey; Reg2.Free;
  Reg3.CloseKey; Reg3.Free;
  Reg4.CloseKey; Reg4.Free;
end;

procedure TFrmMain.N163Click(Sender: TObject);
var i:byte; filename:string;
begin  //���������ļ�
  SaveDiaSave.InitialDir:=ExtractFilePath(paramstr(0)); //���öԻ����ʼ��Ŀ¼Ϊ��������Ŀ¼
  if SaveDiaSave.Execute then
  begin
    filename:=SaveDiaSave.FileName; //ini�ļ���
    Customini:=TInifile.Create(filename); //����ini�ļ�
//ϵͳ���
    for i:=0 to RzChkGroupSystem.Items.Count-1 do Customini.WriteBool('System',inttostr(i),RzChkGroupSystem.ItemChecked[i]);
//Ӳ�����
    for i:=0 to RzChkGroupHardware.Items.Count-1 do Customini.WriteBool('Hardware',inttostr(i),RzChkGroupHardware.ItemChecked[i]);
//��Դ������
    for i:=0 to RzChkGroupExplorer.Items.Count-1 do Customini.WriteBool('Explorer',inttostr(i),RzChkGroupExplorer.ItemChecked[i]);
//��ʼ�˵�
    for i:=0 to RzChkGroupStartMenu.Items.Count-1 do Customini.WriteBool('StartMenu',inttostr(i),RzChkGroupStartMenu.ItemChecked[i]);
    Customini.WriteBool('StartMenu','MenuShowDelay',RzChkBoxMenuDelay.Checked);
//����
    Customini.WriteInteger('Service','options',RzRdiGroupSer.ItemIndex);
    for i:=0 to RzChkGroupSer.Items.Count-1 do Customini.WriteBool('Service',inttostr(i),RzChkGroupSer.ItemChecked[i]);
//����
    for i:=0 to RzChkGroupNet.Items.Count-1 do Customini.WriteBool('Network',inttostr(i),RzChkGroupNet.ItemChecked[i]);
//IE
    for i:=0 to RzChkGroupIE.Items.Count-1 do Customini.WriteBool('IE',inttostr(i),RzChkGroupIE.ItemChecked[i]);
//Media
    for i:=0 to RzChkGroupMedia.Items.Count-1 do Customini.WriteBool('Media',inttostr(i),RzChkGroupMedia.ItemChecked[i]);
//XP
    for i:=0 to RzChkGroupXP.Items.Count-1 do Customini.WriteBool('XP',inttostr(i),RzChkGroupXP.ItemChecked[i]);
//XPSP2
    for i:=0 to RzChkGroupXPSP2.Items.Count-1 do Customini.WriteBool('XPSP2',inttostr(i),RzChkGroupXPSP2.ItemChecked[i]);
//�л��˵���ɫ
    myini.WriteBool('MenuIni','MenuCheck',mMenuCheck.Checked);
    myini.WriteBool('MenuIni','MenuStyle',RzMenuControllerMain.GradientColorDefault);

    Customini.Destroy;
  end;
end;

procedure TFrmMain.N164Click(Sender: TObject);
var i:byte; filename:string;
begin //���������ļ�
  OpenDiaLoad.InitialDir:=ExtractFilePath(paramstr(0));
  if OpenDiaLoad.Execute then
  begin
    filename:=OpenDiaLoad.FileName;
    Customini:=TInifile.Create(filename);
//ϵͳ���
    for i:=0 to RzChkGroupSystem.Items.Count-1 do RzChkGroupSystem.ItemChecked[i]:=Customini.ReadBool('System',inttostr(i),false);
//Ӳ�����
    for i:=0 to RzChkGroupHardware.Items.Count-1 do RzChkGroupHardware.ItemChecked[i]:=Customini.ReadBool('Hardware',inttostr(i),false);
//��Դ������
    for i:=0 to RzChkGroupExplorer.Items.Count-1 do RzChkGroupExplorer.ItemChecked[i]:=Customini.ReadBool('Explorer',inttostr(i),false);
//��ʼ�˵�
    for i:=0 to RzChkGroupStartMenu.Items.Count-1 do RzChkGroupStartMenu.ItemChecked[i]:=Customini.ReadBool('StartMenu',inttostr(i),false);
    RzChkBoxMenuDelay.Checked:=Customini.ReadBool('StartMenu','MenuShowDelay',true);
//����
    RzRdiGroupSer.ItemIndex:=Customini.ReadInteger('Service','options',0);
    for i:=0 to RzChkGroupSer.Items.Count-1 do RzChkGroupSer.ItemChecked[i]:=Customini.ReadBool('Service',inttostr(i),false);
//����
    for i:=0 to RzChkGroupNet.Items.Count-1 do RzChkGroupNet.ItemChecked[i]:=Customini.ReadBool('Network',inttostr(i),false);
//IE
    for i:=0 to RzChkGroupIE.Items.Count-1 do RzChkGroupIE.ItemChecked[i]:=Customini.ReadBool('IE',inttostr(i),false);
//Media
    for i:=0 to RzChkGroupMedia.Items.Count-1 do RzChkGroupMedia.ItemChecked[i]:=Customini.ReadBool('Media',inttostr(i),false);
//XP
    for i:=0 to RzChkGroupXP.Items.Count-1 do RzChkGroupXP.ItemChecked[i]:=Customini.ReadBool('XP',inttostr(i),false);
//XPSP2
    for i:=0 to RzChkGroupXPSP2.Items.Count-1 do RzChkGroupXPSP2.ItemChecked[i]:=Customini.ReadBool('XPSP2',inttostr(i),false);
//�л��˵���ɫ
    mMenuCheck.Checked:=myini.ReadBool('MenuIni','MenuCheck',false);
    RzMenuControllerMain.GradientColorDefault:=myini.ReadBool('MenuIni','MenuStyle',false);

    Customini.Destroy;

    ComBox2000XP.ItemIndex:=-1;  ComBoxSer.ItemIndex:=-1; ComBoxNet.ItemIndex:=-1;
    ComBoxMedia.ItemIndex:=-1;   ComBoxXP.ItemIndex:=-1;  //�������ú�ComBox����ʾ��Ϊ��
  end;
end;

procedure TFrmMain.N170Click(Sender: TObject);
begin //������ݷ�ʽ������
  CreateLnkToDesktop
end;

procedure TFrmMain.N171Click(Sender: TObject);
begin //������ݷ�ʽ����ʼ�˵�
  CreateLnkToStartMenu
end;

procedure TFrmMain.mMenuCheckClick(Sender: TObject);
begin //�л��˵���ɫ
  RzMenuControllerMain.GradientColorDefault
  := not RzMenuControllerMain.GradientColorDefault;
end;

procedure TFrmMain.DrWatson1Click(Sender: TObject);
begin //Dr.Watson
  ShellExecute(Handle,'open','drwtsn32',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.DxDiag1Click(Sender: TObject);
begin //DxDiag
  ShellExecute(Handle,'open','dxdiag',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.MsConfig1Click(Sender: TObject);
begin //Msconfig
  ShellExecute(Handle,'open','msconfig',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.RegEdit1Click(Sender: TObject);
begin //Regedit
  ShellExecute(Handle,'open','regedit',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.RegEdt321Click(Sender: TObject);
begin //RegEdt32
  ShellExecute(Handle,'open','regedt32',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N174Click(Sender: TObject);
begin //syskey
  ShellExecute(Handle,'open','syskey',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.Windows3Click(Sender: TObject);
begin //Windows ������ϵ�ṹ(WMI)
  ShellExecute(Handle,'open','wmimgmt.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N175Click(Sender: TObject);
begin //�洢�û���������
  winexec('rundll32.exe keymgr.dll,KRShowKeyMgr',SW_SHOWNORMAL)
end;

procedure TFrmMain.N43Click(Sender: TObject);
begin //���ذ�ȫ����
  ShellExecute(Handle,'open','secpol.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N44Click(Sender: TObject);
begin //�����û�����
  ShellExecute(Handle,'open','lusrmgr.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N45Click(Sender: TObject);
begin //����������
  ShellExecute(Handle,'open','faxserv.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N46Click(Sender: TObject);
begin //���̹���
  ShellExecute(Handle,'open','diskmgmt.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N47Click(Sender: TObject);
begin //������Ƭ����
  ShellExecute(Handle,'open','dfrg.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N48Click(Sender: TObject);
begin //����
  ShellExecute(Handle,'open','services.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N49Click(Sender: TObject);
begin //�����ļ���
  ShellExecute(Handle,'open','fsmgmt.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N50Click(Sender: TObject);
begin //���ƶ��洢������
  ShellExecute(Handle,'open','ntmsoprq.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N51Click(Sender: TObject);
begin //���������
  ShellExecute(Handle,'open','compmgmt.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N52Click(Sender: TObject);
begin //�¼��鿴��
  ShellExecute(Handle,'open','eventvwr.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N53Click(Sender: TObject);
begin //��������
  ShellExecute(Handle,'open','ciadv.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N54Click(Sender: TObject);
begin //����
  ShellExecute(Handle,'open','perfmon.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N55Click(Sender: TObject);
begin //�豸������
  ShellExecute(Handle,'open','devmgmt.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N56Click(Sender: TObject);
begin //֤��
  ShellExecute(Handle,'open','certmgr.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N57Click(Sender: TObject);
begin //�����
  ShellExecute(Handle,'open','gpedit.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N58Click(Sender: TObject);
begin //����ԵĽ����
  ShellExecute(Handle,'open','rsop.msc',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N59Click(Sender: TObject);
var x,y,z,t:byte;
begin //�������
  x:=ShellExecute(Handle,'open','comexp.msc',nil,nil,SW_SHOWMAXIMIZED);
  if x=2 then
  begin
    y:=ShellExecute(Handle,'open','C:\WINNT\system32\Com\comexp.msc',nil,nil,SW_SHOWMAXIMIZED);
    if y=2 then
    begin
      z:=ShellExecute(Handle,'open','C:\WINDOWS\system32\Com\comexp.msc',nil,nil,SW_SHOWMAXIMIZED);
      if z=2 then
      begin
        t:=ShellExecute(Handle,'open','D:\WINNT\system32\Com\comexp.msc',nil,nil,SW_SHOWMAXIMIZED);
        if t=2 then ShellExecute(Handle,'open','D:\WINDOWS\system32\Com\comexp.msc',nil,nil,SW_SHOWMAXIMIZED);
      end;  
    end;
  end;
end;

procedure TFrmMain.Internet2Click(Sender: TObject);
begin //Internet ѡ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.Java1Click(Sender: TObject);
begin //Java �������
  winexec('rundll32.exe shell32.dll,Control_RunDLL jpicpl32.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.ODBC1Click(Sender: TObject);
begin //ODBC ����Դ������
  winexec('rundll32.exe shell32.dll,Control_RunDLL odbccp32.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.Windows2Click(Sender: TObject);
begin //Windows ����ǽ
  winexec('rundll32.exe shell32.dll,Control_RunDLL firewall.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N60Click(Sender: TObject);
begin //�绰�͵��ƽ����ѡ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL telephon.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N79Click(Sender: TObject);
begin //��ȫ����
  winexec('rundll32.exe shell32.dll,Control_RunDLL wscui.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N61Click(Sender: TObject);
begin //��Դѡ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL powercfg.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N62Click(Sender: TObject);
begin //��������ѡ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL access.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N63Click(Sender: TObject);
begin //����
  winexec('rundll32.exe shell32.dll,Control_RunDLL main.cpl @1',SW_SHOWNORMAL)
end;

procedure TFrmMain.N64Click(Sender: TObject);
begin //���������ѡ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL intl.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N65Click(Sender: TObject);
begin //�������Ϳ�ʼ�˵�
  shellapp.TrayProperties
end;

procedure TFrmMain.N66Click(Sender: TObject);
begin //���ں�ʱ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL timedate.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N67Click(Sender: TObject);
var windowhld:hwnd;
begin //ɨ���Ǻ������
  winexec('explorer ::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{E211B736-43FD-11D1-9EFB-0000F8757FCD}',SW_SHOWNORMAL);
  windowhld:=FindWindow(nil,'Windows ��Դ������');
  if windowhld <> 0 then
  begin
    SendMessage(windowhld,WM_CLOSE,0,0);
    winexec('rundll32.exe shell32.dll,Control_RunDLL sticpl.cpl',SW_SHOWNORMAL);
  end;
end;

procedure TFrmMain.N68Click(Sender: TObject);
begin //�����Ͷ�ý��
  winexec('rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N69Click(Sender: TObject);
begin //���
  winexec('rundll32.exe shell32.dll,Control_RunDLL main.cpl @0',SW_SHOWNORMAL)
end;

procedure TFrmMain.N70Click(Sender: TObject);
begin //���/ɾ������
  winexec('rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N71Click(Sender: TObject);
begin //���/ɾ��Ӳ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL hdwwiz.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N72Click(Sender: TObject);
var windowhld:hwnd;
begin //�ļ���ѡ��
  winexec('rundll32.exe shell32.dll,Options_RunDLL',SW_SHOWNORMAL);
  windowhld:=FindWindow(nil,'�ļ���ѡ��');
  ShowWindow(windowhld,SW_SHOW);
  //windowhld:=GetForegroundWindow;
  windowhld:=FindWindow(nil,'RUNDLL');
  if windowhld <> 0 then
  begin
    SendMessage(windowhld,WM_CLOSE,0,0);
    winexec('rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,@1',SW_SHOWNORMAL);
    windowhld:=FindWindow(nil,'�ļ���ѡ��');
    ShowWindow(windowhld,SW_SHOW);
  end;
end;

procedure TFrmMain.N73Click(Sender: TObject);
begin //ϵͳ
  winexec('rundll32.exe shell32.dll,Control_RunDLL Sysdm.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N74Click(Sender: TObject);
begin //��ʾ
  winexec('rundll32.exe shell32.dll,Control_RunDLL desk.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N75Click(Sender: TObject);
begin //�û�������
  winexec('rundll32.exe netplwiz.dll,UsersRunDll',SW_SHOWNORMAL)
end;

procedure TFrmMain.N76Click(Sender: TObject);
begin //�û��ʻ�
  winexec('rundll32.exe shell32.dll,Control_RunDLL nusrmgr.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N77Click(Sender: TObject);
begin //��Ϸ������
  winexec('rundll32.exe shell32.dll,Control_RunDLL joy.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N78Click(Sender: TObject);
begin //�Զ�����
  winexec('rundll32.exe shell32.dll,Control_RunDLL wuaucpl.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.CSC1Click(Sender: TObject);
begin //����Ŀ¼ CSC
  Label1.Caption:=windir; shellapp.Explore(Label1.Caption + '\CSC');
end;

procedure TFrmMain.dllcache1Click(Sender: TObject);
begin //����Ŀ¼ dllcache
  Label1.Caption:=sysdir; shellapp.Explore(Label1.Caption + '\dllcache');
end;

procedure TFrmMain.GroupPolicy1Click(Sender: TObject);
begin //����Ŀ¼ GroupPolicy
  Label1.Caption:=sysdir; shellapp.Explore(Label1.Caption + '\GroupPolicy');
end;

procedure TFrmMain.inf1Click(Sender: TObject);
begin //����Ŀ¼ inf
  Label1.Caption:=windir; shellapp.Explore(Label1.Caption + '\inf');
end;

procedure TFrmMain.Installer1Click(Sender: TObject);
begin //����Ŀ¼ Installer
  Label1.Caption:=windir; shellapp.Explore(Label1.Caption + '\Installer');
end;

procedure TFrmMain.InstallShieldInstallationInformation1Click( Sender: TObject);
begin //����Ŀ¼ InstallShield Installation Information
  shellapp.Explore(ProgramFilesDir + '\InstallShield Installation Information')
end;

procedure TFrmMain.msdownldtmp1Click(Sender: TObject);
begin //����Ŀ¼ msdownld.tmp
  Label1.Caption:=windir; shellapp.Explore(Label1.Caption + '\msdownld.tmp');
end;

procedure TFrmMain.PIF1Click(Sender: TObject);
begin //����Ŀ¼ PIF
  Label1.Caption:=windir; shellapp.Explore(Label1.Caption + '\PIF');
end;

procedure TFrmMain.UninstallInformation1Click(Sender: TObject);
begin //����Ŀ¼ Uninstall Information
  shellapp.Explore(ProgramFilesDir + '\Uninstall Information')
end;

procedure TFrmMain.WindowsUpdate1Click(Sender: TObject);
begin //����Ŀ¼ WindowsUpdate
  shellapp.Explore(ProgramFilesDir + '\WindowsUpdate')
end;

procedure TFrmMain.Access1Click(Sender: TObject);
begin //Access
  ShellExecute(Handle,'open','MsAccess',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.Excel1Click(Sender: TObject);
begin //Excel
  ShellExecute(Handle,'open','Excel',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.FrontPage1Click(Sender: TObject);
begin //FrontPage
  ShellExecute(Handle,'open','FRONTPG',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.InfoPath1Click(Sender: TObject);
begin //InfoPath
  ShellExecute(Handle,'open','INFOPATH',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.OneNote1Click(Sender: TObject);
begin //OneNote
  ShellExecute(Handle,'open','ONENOTE',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.Outlook1Click(Sender: TObject);
begin //Outlook
  ShellExecute(Handle,'open','OUTLOOK',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.PictureManager1Click(Sender: TObject);
begin //Picture Manager
  ShellExecute(Handle,'open','OIS',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.PowerPoint1Click(Sender: TObject);
begin //PowerPoint
  ShellExecute(Handle,'open','PowerPnt',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.Project1Click(Sender: TObject);
begin //Project
  ShellExecute(Handle,'open','WINPROJ',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.Publisher1Click(Sender: TObject);
begin //Publisher
  ShellExecute(Handle,'open','MSPUB',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.Visio1Click(Sender: TObject);
begin //Visio
  ShellExecute(Handle,'open','VISIO',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.Word1Click(Sender: TObject);
begin //Word
  ShellExecute(Handle,'open','WinWord',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.InternetExplorer1Click(Sender: TObject);
begin //TrueType ���ֳ���
  ShellExecute(Handle,'open','eudcedit',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N80Click(Sender: TObject);
begin //����
  ShellExecute(Handle,'open','ntbackup',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N167Click(Sender: TObject);
begin //���������
  ShellExecute(Handle,'open','progman',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N81Click(Sender: TObject);
begin //��������
  ShellExecute(Handle,'open','cleanmgr',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N149Click(Sender: TObject);
begin //�����װ����
  ShellExecute(Handle,'open','Packager',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N82Click(Sender: TObject);
begin //�Ŵ�
  ShellExecute(Handle,'open','magnify',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N83Click(Sender: TObject);
begin //���ƴ���
  winexec('rundll32 diskcopy.dll,DiskCopyRunDll',SW_SHOWNORMAL)
end;

procedure TFrmMain.N84Click(Sender: TObject);
begin //��ͼ
  ShellExecute(Handle,'open','mspaint.exe',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N85Click(Sender: TObject);
begin //������ʾ��
  ShellExecute(Handle,'open','cmd',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N86Click(Sender: TObject);
begin //���±�
  ShellExecute(Handle,'open','notepad',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N87Click(Sender: TObject);
begin //������
  ShellExecute(Handle,'open','calc',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N88Click(Sender: TObject);
begin //�������鿴��
  ShellExecute(Handle,'open','clipbrd',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N89Click(Sender: TObject);
begin //��Ļ����
  ShellExecute(Handle,'open','osk',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N90Click(Sender: TObject);
begin //���������
  ShellExecute(Handle,'open','taskmgr',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N91Click(Sender: TObject);
begin //ͼ����
  ShellExecute(Handle,'open','kodakimg',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N173Click(Sender: TObject);
begin //΢ܛ�}�R���뷨����
  ShellExecute(Handle,'open','C:\WINDOWS\system32\IME\CINTLGNT\CINTSETP.EXE',nil,nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','D:\WINDOWS\system32\IME\CINTLGNT\CINTSETP.EXE',nil,nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','E:\WINDOWS\system32\IME\CINTLGNT\CINTSETP.EXE',nil,nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N92Click(Sender: TObject);
begin //�ļ�ǩ����֤
  ShellExecute(Handle,'open','sigverif',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N93Click(Sender: TObject);
begin //ϵͳ���ñ༭��
  ShellExecute(Handle,'open','sysedit',nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.N94Click(Sender: TObject);
begin //ϵͳ��Ϣ
  ShellExecute(Handle,'open','msinfo32',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N95Click(Sender: TObject);
begin //д�ְ�
  ShellExecute(Handle,'open','wordpad',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N96Click(Sender: TObject);
begin //�ַ�ӳ���
  ShellExecute(Handle,'open','charmap',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N97Click(Sender: TObject);
begin //��Դ������
  ShellExecute(Handle,'open','explorer','/e',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.CD1Click(Sender: TObject);
begin //CD ����
  ShellExecute(Handle,'open','cdplayer',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.DVD1Click(Sender: TObject);
begin //DVD ������
  ShellExecute(Handle,'open','dvdplay',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.WindowsMediaPlayer1Click(Sender: TObject);
begin //Windows Media Player 9.0
  ShellExecute(Handle,'open','wmplayer',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.WindowsMediaPlayer641Click(Sender: TObject);
begin //Windows Media Player 6.4
  ShellExecute(Handle,'open','mplayer2',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.WindowsMovieMaker1Click(Sender: TObject);
begin //Windows Movie Maker
  ShellExecute(Handle,'open','moviemk',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N99Click(Sender: TObject);
begin //¼����
  ShellExecute(Handle,'open','sndrec32',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N100Click(Sender: TObject);
begin //��������
  ShellExecute(Handle,'open','sndvol32',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.DDE1Click(Sender: TObject);
begin //DDE ����
  ShellExecute(Handle,'open','DDEShare',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.InternetExplorer2Click(Sender: TObject);
begin //Internet Explorer������nohome����������ʱ����ҳ��
  ShellExecute(Handle,'open','iexplore','-nohome',nil,SW_SHOWMAXIMIZED)
end;

procedure TFrmMain.NetMeeting1Click(Sender: TObject);
begin //NetMeeting
  ShellExecute(Handle,'open','conf',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.OutlookExpress1Click(Sender: TObject);
begin //Outlook Express
  ShellExecute(Handle,'open','msimn',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.SQLServer1Click(Sender: TObject);
begin //SQL Server �ͻ�������ʵ�ù���
  ShellExecute(Handle,'open','cliconfg',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.elnet1Click(Sender: TObject);
begin //Telnet
  ShellExecute(Handle,'open','telnet',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.Windows4Click(Sender: TObject);
begin //Windows �ű���������
  ShellExecute(Handle,'open','wscript',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N102Click(Sender: TObject);
begin //�����ն�
  ShellExecute(Handle,'open','hypertrm',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N166Click(Sender: TObject);
begin //����
  ShellExecute(Handle,'open','winchat',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N103Click(Sender: TObject);
begin //ͬ��
  ShellExecute(Handle,'open','mobsync',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N104Click(Sender: TObject);
begin //ͨѶ��
  ShellExecute(Handle,'open','wab',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N105Click(Sender: TObject);
begin //�½�����
  winexec('rundll32 ntlanui.dll,ShareCreate',SW_SHOWNORMAL)
end;

procedure TFrmMain.N172Click(Sender: TObject);
begin //Զ����������
  ShellExecute(Handle,'open','mstsc',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N107Click(Sender: TObject);
begin //����
  shellapp.Help
  //shellapp.SetTime;//���ں�ʱ������
end;

procedure TFrmMain.N108Click(Sender: TObject);
begin //�ػ�
  shellapp.ShutDownWindows
end;

procedure TFrmMain.N109Click(Sender: TObject);
begin //����
  ShellAbout(0,'WindowsOPT','��Ȩ���� (C) 2004-2006 HTSoft',1)
  //ShellExecute(Handle,'open','winver',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N110Click(Sender: TObject);
begin //���������
  shellapp.FindComputer
end;

procedure TFrmMain.N111Click(Sender: TObject);
begin //�����ļ����ļ���
  shellapp.FindFiles
end;

procedure TFrmMain.N112Click(Sender: TObject);
begin //����
  shellapp.FileRun
end;

procedure TFrmMain.DriverVerifierManager1Click(Sender: TObject);
begin //Driver Verifier Manager
  ShellExecute(Handle,'open','verifier',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.IExpress1Click(Sender: TObject);
begin //IExpress ѹ���ļ���
  ShellExecute(Handle,'open','iexpress',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.Internet3Click(Sender: TObject);
begin //Internet ������
  ShellExecute(Handle,'open','icwconn1',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N114Click(Sender: TObject);
begin //���������ļ�����
  ShellExecute(Handle,'open','icwconn1',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N120Click(Sender: TObject);
begin //����������
  ShellExecute(Handle,'open','accwiz',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N169Click(Sender: TObject);
begin //�����ļ�������
  ShellExecute(Handle,'open','fsquirt',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N115Click(Sender: TObject);
begin //ɨ���Ǻ��������
  ShellExecute(Handle,'open','wiaacmgr',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N116Click(Sender: TObject);
var windowhld:hwnd;
begin //���簲װ��
  winexec('rundll32.exe hnetwiz.dll,HomeNetWizardRunDll',SW_SHOWNORMAL);
  windowhld:=FindWindow(nil,'RUNDLL');
  if windowhld <> 0
  then SendMessage(windowhld,WM_CLOSE,0,0);
end;

procedure TFrmMain.N117Click(Sender: TObject);
begin //�ļ�������ת����
  ShellExecute(Handle,'open','migwiz',nil,nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N118Click(Sender: TObject);
begin //�������簲װ��
  winexec('rundll32 shell32.dll,Control_RunDLL NetSetup.cpl,@0,WNSW',SW_SHOWNORMAL)
end;

procedure TFrmMain.N119Click(Sender: TObject);
var windowhld:hwnd;
begin //�½�������
  winexec('rundll32.exe netshell.dll,StartNCW',SW_SHOWNORMAL);
  windowhld:=FindWindow(nil,'RUNDLL');
  if windowhld <> 0
  then SendMessage(windowhld,WM_CLOSE,0,0);
end;

procedure TFrmMain.N10Click(Sender: TObject);
begin //Application Data ��ǰ�û�
  OpenSpecialFolder(CSIDL_APPDATA)
end;

procedure TFrmMain.N11Click(Sender: TObject);
begin //Application Data �����û�
  OpenSpecialFolder($23)
end;

procedure TFrmMain.CDBurning1Click(Sender: TObject);
begin //CD Burning
  OpenSpecialFolder($3B)
end;

procedure TFrmMain.Cookie1Click(Sender: TObject);
begin //Cookie
  OpenSpecialFolder(CSIDL_COOKIES)
end;

procedure TFrmMain.N12Click(Sender: TObject);
begin //Favorites ��ǰ�û�
  OpenSpecialFolder(CSIDL_FAVORITES)
end;

procedure TFrmMain.N13Click(Sender: TObject);
begin //Favorites �����û�
  OpenSpecialFolder(CSIDL_COMMON_FAVORITES)
end;

procedure TFrmMain.History1Click(Sender: TObject);
begin //History
  OpenSpecialFolder(CSIDL_HISTORY)
end;

procedure TFrmMain.Internet1Click(Sender: TObject);
begin //Internet ��ʱĿ¼
  OpenSpecialFolder(CSIDL_INTERNET_CACHE)
end;

procedure TFrmMain.LocalSettingsApplicationData1Click(Sender: TObject);
begin //Local Settings\Application Data
  OpenSpecialFolder($1C)
end;

procedure TFrmMain.N14Click(Sender: TObject);
begin //My Music ��ǰ�û�
  OpenSpecialFolder($D)
end;

procedure TFrmMain.N15Click(Sender: TObject);
begin //My Music �����û�
  OpenSpecialFolder($35)
end;

procedure TFrmMain.N16Click(Sender: TObject);
begin //My Pictures ��ǰ�û�
  OpenSpecialFolder($27)
end;

procedure TFrmMain.N17Click(Sender: TObject);
begin //My Pictures �����û�
  OpenSpecialFolder($36)
end;

procedure TFrmMain.N18Click(Sender: TObject);
begin //My Videos ��ǰ�û�
  OpenSpecialFolder($E)
end;

procedure TFrmMain.N19Click(Sender: TObject);
begin //My Videos �����û�
  OpenSpecialFolder($37)
end;

procedure TFrmMain.NetHood1Click(Sender: TObject);
begin //NetHood
  OpenSpecialFolder(CSIDL_NETHOOD)
end;

procedure TFrmMain.PrintHood1Click(Sender: TObject);
begin //PrintHood
  OpenSpecialFolder(CSIDL_PRINTHOOD)
end;

procedure TFrmMain.Recent1Click(Sender: TObject);
begin //Recent
  OpenSpecialFolder(CSIDL_RECENT)
end;

procedure TFrmMain.SendTo1Click(Sender: TObject);
begin //SendTo
  OpenSpecialFolder(CSIDL_SENDTO)
end;

procedure TFrmMain.N20Click(Sender: TObject);
begin //Templates ��ǰ�û�
  OpenSpecialFolder(CSIDL_TEMPLATES)
end;

procedure TFrmMain.N21Click(Sender: TObject);
begin //Templates �����û�
  OpenSpecialFolder($2D)
end;

procedure TFrmMain.N23Click(Sender: TObject);
begin //���� ��ǰ�û�
  OpenSpecialFolder(CSIDL_PROGRAMS)
end;

procedure TFrmMain.N24Click(Sender: TObject);
begin //���� �����û�
  OpenSpecialFolder(CSIDL_COMMON_PROGRAMS)
end;

procedure TFrmMain.N25Click(Sender: TObject);
begin //�����ļ� ��ǰ�û�
  OpenSpecialFolder($28)
end;

procedure TFrmMain.N27Click(Sender: TObject);
begin //������ ��ǰ�û�
  OpenSpecialFolder($30)
end;

procedure TFrmMain.N28Click(Sender: TObject);
begin //������ �����û�
  OpenSpecialFolder($2F)
end;

procedure TFrmMain.N30Click(Sender: TObject);
begin //��ʼ�˵� ��ǰ�û�
  OpenSpecialFolder(CSIDL_STARTMENU)
end;

procedure TFrmMain.N31Click(Sender: TObject);
begin //��ʼ�˵� �����û�
  OpenSpecialFolder(CSIDL_COMMON_STARTMENU)
end;

procedure TFrmMain.N32Click(Sender: TObject);
var //��ʱĿ¼
  tempdir : array[1..100] of char;
  temp : string;
begin
  GetTempPath(100,@tempdir);
  temp:=tempdir;
  ShellExecute(Handle,'open',pchar(temp),nil,nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N34Click(Sender: TObject);
begin //���� ��ǰ�û�
  OpenSpecialFolder(CSIDL_STARTUP)
end;

procedure TFrmMain.N35Click(Sender: TObject);
begin //���� �����û�
  OpenSpecialFolder(CSIDL_COMMON_STARTUP)
end;

procedure TFrmMain.N37Click(Sender: TObject);
begin //�ҵ��ĵ� ��ǰ�û�
  OpenSpecialFolder(CSIDL_PERSONAL)
end;

procedure TFrmMain.N38Click(Sender: TObject);
begin //�ҵ��ĵ� �����û�
  OpenSpecialFolder($2E)
end;

procedure TFrmMain.N40Click(Sender: TObject);
begin //���� ��ǰ�û�
  OpenSpecialFolder(CSIDL_DESKTOPDIRECTORY)
end;

procedure TFrmMain.N41Click(Sender: TObject);
begin //���� �����û�
  OpenSpecialFolder(CSIDL_COMMON_DESKTOPDIRECTORY)
end;

procedure TFrmMain.AppPatch1Click(Sender: TObject);
begin //AppPatch
  Label1.Visible:=false; Label1.Caption:=windir;
  shellapp.Explore(Label1.Caption + '\AppPatch');
end;

procedure TFrmMain.config1Click(Sender: TObject);
begin //Common Files
  OpenSpecialFolder($2B)
end;

procedure TFrmMain.DownloadedProgramFiles1Click(Sender: TObject);
begin //config
  Label1.Visible:=false; Label1.Caption:=sysdir;
  shellapp.Explore(Label1.Caption + '\config');
end;

procedure TFrmMain.DownloadedProgramFiles2Click(Sender: TObject);
begin //Downloaded Program Files
  Label1.Visible:=false; Label1.Caption:=windir;
  shellapp.Explore(Label1.Caption + '\Downloaded Program Files');
end;

procedure TFrmMain.drivers1Click(Sender: TObject);
begin //drivers
  Label1.Visible:=false; Label1.Caption:=sysdir;
  shellapp.Explore(Label1.Caption + '\drivers');
end;

procedure TFrmMain.DriverCache1Click(Sender: TObject);
begin //Driver Cache
  Label1.Visible:=false; Label1.Caption:=windir;
  shellapp.Explore(Label1.Caption + '\Driver Cache');
end;

procedure TFrmMain.Media1Click(Sender: TObject);
begin //Media
  Label1.Visible:=false; Label1.Caption:=windir;
  shellapp.Explore(Label1.Caption + '\Media');
end;

procedure TFrmMain.OfflineWebPages1Click(Sender: TObject);
begin //Offline Web Pages
  Label1.Visible:=false; Label1.Caption:=windir;
  shellapp.Explore(Label1.Caption + '\Offline Web Pages');
end;

procedure TFrmMain.Prefetch1Click(Sender: TObject);
begin //Prefetch
  Label1.Visible:=false; Label1.Caption:=windir;
  shellapp.Explore(Label1.Caption + '\Prefetch');
end;

procedure TFrmMain.ProgramFiles1Click(Sender: TObject);
begin //Program Files
  OpenSpecialFolder($26)
end;

procedure TFrmMain.System1Click(Sender: TObject);
begin //SystemĿ¼
  OpenSpecialFolder($25)
end;

procedure TFrmMain.Wallpaper1Click(Sender: TObject);
begin //Wallpaper
  Label1.Visible:=false; Label1.Caption:=windir;
  shellapp.Explore(Label1.Caption + '\Web\Wallpaper');
end;

procedure TFrmMain.Windows1Click(Sender: TObject);
begin //Windows Ŀ¼
  OpenSpecialFolder($24)
end;

procedure TFrmMain.N1Click(Sender: TObject);
begin //��ӡ��
  OpenSpecialFolder(CSIDL_PRINTERS)
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin //����վ
  OpenSpecialFolder(CSIDL_BITBUCKET)
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin //�������
  OpenSpecialFolder(CSIDL_CONTROLS)
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin //����ƻ�
  ShellExecute(Handle,'open','explorer','::{20D04FE0-3AEA-1069-A2D8-08002B30309D}\::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{D6277990-4C6A-11CF-8D87-00AA0060F5BF}',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N5Click(Sender: TObject);
begin //��������
  winexec('rundll32.exe shell32.dll,Control_RunDLL ncpa.cpl',SW_SHOWNORMAL)
end;

procedure TFrmMain.N6Click(Sender: TObject);
begin //�����ھ�
  OpenSpecialFolder(CSIDL_NETWORK)
end;

procedure TFrmMain.N7Click(Sender: TObject);
begin //�ҵĵ���
  OpenSpecialFolder(CSIDL_DRIVES)
end;

procedure TFrmMain.N8Click(Sender: TObject);
begin //����
  //winexec('rundll32.exe shell32.dll SHHelpShortcuts_RunDLL FontsFolder',SW_SHOWNORMAL)
  OpenSpecialFolder(CSIDL_FONTS)
end;

procedure TFrmMain.N9Click(Sender: TObject);
begin //����
  OpenSpecialFolder($00)
end;

procedure TFrmMain.N123Click(Sender: TObject);
begin //��������
  mciSendString('Set cdaudio door open wait', nil, 0, handle)
end;

procedure TFrmMain.N124Click(Sender: TObject);
begin  //�رչ���
  mciSendString('Set cdaudio door closed wait', nil, 0, handle)
end;

procedure TFrmMain.N125Click(Sender: TObject);
var //��ʾ������������ͼ��
  Hwnd, hDesktop :THandle;
begin
  Hwnd:=FindWindow('Shell_TrayWnd',nil);
  EnableWindow(Hwnd,true);
  ShowWindow(Hwnd,SW_SHOW); //�ָ�������
  hDesktop := FindWindow('Progman', nil);
  EnableWindow(hDesktop,true);
  ShowWindow(hDesktop, SW_SHOW); //�ָ�����ͼ��
end;

procedure TFrmMain.N126Click(Sender: TObject);
var //����������������ͼ��
  Hwnd, hDesktop :THandle;
begin
  Hwnd:=FindWindow('Shell_TrayWnd',nil);
  if Hwnd<>0 then
  begin
    EnableWindow(Hwnd,false);
    ShowWindow(Hwnd,SW_HIDE); //����������
  end;
  hDesktop := FindWindow('Progman', nil);
  if hDesktop<>0 then
  begin
    EnableWindow(hDesktop,false);
    ShowWindow(hDesktop, SW_HIDE); //��������ͼ��
  end;
end;

procedure TFrmMain.N127Click(Sender: TObject);
var //����
  hToken:THANDLE; Rl:Dword;
  tkp:TTokenPrivileges;
begin    
  if MessageBox(Handle, '��������������� ', '����', MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = IDOK then
  begin
    if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,hToken) then
    begin
      LookupPrivilegeValue(nil,'SeShutdownPrivilege',tkp.Privileges[0].Luid);
      tkp.PrivilegeCount:= 1;
      tkp.Privileges[0].Attributes:= SE_PRIVILEGE_ENABLED;
      AdjustTokenPrivileges(hToken,FALSE,tkp,SizeOf(tkp),tkp,Rl);
      ExitWindowsEx(EWX_REBOOT,0);
    end;  
  end;
end;

procedure TFrmMain.N128Click(Sender: TObject);
var //�ػ�
  hToken:THANDLE; Rl:Dword;
  tkp:TTokenPrivileges;
begin
  if MessageBox(Handle, '�رռ������ ', '�ػ�', MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = IDOK then
  begin
    if OpenProcessToken(GetCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,hToken) then
    begin
      LookupPrivilegeValue(nil,'SeShutdownPrivilege',tkp.Privileges[0].Luid);
      tkp.PrivilegeCount:= 1;
      tkp.Privileges[0].Attributes:= SE_PRIVILEGE_ENABLED;
      AdjustTokenPrivileges(hToken,FALSE,tkp,SizeOf(tkp),tkp,Rl);
      ExitWindowsEx(EWX_SHUTDOWN, 0);
    end;  
  end;
end;

procedure TFrmMain.N129Click(Sender: TObject);
begin //ע��
  if MessageBox(Handle, 'ע����ǰ�û��� ', 'ע��', MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = IDOK
  then ExitWindowsEx(EWX_LOGOFF,0)
end;

procedure TFrmMain.N177Click(Sender: TObject);
begin //ϵͳ�ػ��Ի���
  shellapp.ShutDownWindows
end;

procedure TFrmMain.RzBtnNewClick(Sender: TObject);
var  j:string; // ����Ҽ��½��ļ�
begin
  if LabEditNew.Text<>'' then
  begin
    j:='\.' + LabEditNew.Text + '\shellnew';
    if reg4.OpenKey(j,true) then reg4.writestring('NullFile','');
    LabEditNew.Text:='';
    SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, NiL, NiL); //ˢ��
  end
  else MessageBox(Handle, '�ļ���չ������Ϊ�գ� ', '����', MB_ICONHAND);
end;

procedure TFrmMain.LabEditNewKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin //�Ҽ��½��ļ��༭����ܻس�����
  if Key = VK_RETURN then RzBtnNew.Click;
end;

procedure TFrmMain.RzBtnIconCacheClick(Sender: TObject);
begin //�ؽ�ͼ�껺��
  if MessageBox(Handle, '�ؽ�ϵͳ��ͼ�껺�棿 ', '�ؽ�ͼ�껺��', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON1) = IDYES
  then RefreshScreenIcons
end;

procedure TFrmMain.RzBtnUnHardClick(Sender: TObject);
begin //��ȫɾ��Ӳ��
  winexec('rundll32.exe shell32.dll,Control_RunDLL hotplug.dll',SW_SHOWNORMAL)
end;

procedure TFrmMain.RzBtnUnMouKobClick(Sender: TObject);
var rtScreen: TRect; tmp:integer;
begin //���ͼ��̽���
  rtScreen := Rect(0, 0, Screen.Width, Screen.Height);
  ClipCursor(@rtScreen);
  KM_UnLockMouse;
  EnableKeyboard;
//�ָ�ϵͳ�ȼ�(��9X,����:�����е�0��Ϊ1)  
  SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@tmp,0); // Ctrl-Alt-Del
  SystemParametersInfo(SPI_SETFASTTASKSWITCH, 0,@tmp,0); // Alt-Tab  
end;

procedure TFrmMain.RzBtnClearHisClick(Sender: TObject);
begin //�����ʷ��¼
  ClearHistory
end;

procedure TFrmMain.RzBtnColorClick(Sender: TObject);
begin //�˵�����¼����ɫ
  ColorSet
end;

procedure TFrmMain.RzBtnStartManaClick(Sender: TObject);
begin //��������������
  StartMana
end;

procedure TFrmMain.RzBtnTaskManaClick(Sender: TObject);
begin //�������������
  TaskMana
end;

procedure TFrmMain.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_CREATEPIPE_ERROR    : MessageBox(Handle, '�����ܵ�����'#13''#13'���������װĿ¼���Ƿ�û�� spawn.exe ', 'DOS ����', MB_ICONHAND);
    WM_CREATEPROCESS_ERROR : MessageBox(Handle, '�������̴���'#13''#13'���������װĿ¼���Ƿ�û�� spawn.exe ', 'DOS ����', MB_ICONHAND);
    WM_READPIPE_ERROR      : MessageBox(Handle, '���ܵ�����'#13''#13'���������װĿ¼���Ƿ�û�� spawn.exe ', 'DOS ����', MB_ICONHAND);
    WM_FINISHED_COMMAND    : MessageBox(Handle, '����ִ����ϣ� ', 'DOS ����', MB_ICONASTERISK);
  end;
  inherited WndProc(Message);
end;

procedure TFrmMain.ComboBoxHintChange(Sender: TObject);
begin //��������ʾ
  LabEditDOS.SetFocus;
  case ComboBoxHint.ItemIndex of
  0: //ע��ϵͳĿ¼���е� dll �ļ�
    begin
      LabEditDOS.Text:='for %i in (%windir%\system32\*.dll) do regsvr32 /s %i';
      LabEditDOS.Hint:='ע��ϵͳĿ¼���е� dll �ļ����ɽ������ϵͳ���ϡ�'#13'������ʹ����ʧȥ��Ӧ��������������ʾ�����д����';
      ComboBoxHint.Hint:='ע��ϵͳĿ¼���е� dll �ļ����ɽ������ϵͳ���ϡ�'#13'������ʹ����ʧȥ��Ӧ��������������ʾ�����д����';
    end;
  1: //��װ���ϻָ�����̨
    begin
      LabEditDOS.Text:='X:\i386\winnt32.exe /cmdcons';
      LabEditDOS.Hint:='X Ϊ 2000 �� XP ���ڹ����̷����������޸ġ�';
      ComboBoxHint.Hint:='X Ϊ 2000 �� XP ���ڹ����̷����������޸ġ�';
    end;
  2: //���ԤȡĿ¼
    begin
      LabEditDOS.Text:='del %windir%\Prefetch\*.* /Q';
      LabEditDOS.Hint:='��� Windows XP ��ԤȡĿ¼���ɼӿ�ϵͳ�����ٶȡ�';
      ComboBoxHint.Hint:='��� Windows XP ��ԤȡĿ¼���ɼӿ�ϵͳ�����ٶȡ�';
    end;
  3: //�ļ�������֤
    begin
      LabEditDOS.Text:='sfc /scannow';
      LabEditDOS.Hint:='��Ҫϵͳ��װ���̡�';
      ComboBoxHint.Hint:='��Ҫϵͳ��װ���̡�';
    end;
  4: //��װ IE
    begin
      LabEditDOS.Text:='Rundll32 setupapi,InstallHinfSection DefaultInstall 132 %windir%\inf\ie.inf';
      LabEditDOS.Hint:='��Ҫϵͳ��װ���̡�';
      ComboBoxHint.Hint:='��Ҫϵͳ��װ���̡�';
    end;
  5: //ж�� Windows Messenger
    begin
      LabEditDOS.Text:='RunDll32 advpack.dll,LaunchINFSection %windir%\inf\msmsgs.inf,BLC.Remove';
      LabEditDOS.Hint:='˫��ʱ�Զ������ݿ��������';
      ComboBoxHint.Hint:='';
    end;
  6: //��װ�ļ��������
    begin
      LabEditDOS.Text:='Rundll32 setupapi,InstallHinfSection DefaultInstall 132 %windir%\Inf\Srchasst.inf';
      LabEditDOS.Hint:='��Ҫϵͳ��װ���̡�';
      ComboBoxHint.Hint:='��Ҫϵͳ��װ���̡�';
    end;
  7: //�鿴 IP ��ַ��Ϣ
    begin
      LabEditDOS.Text:='ipconfig /all';
      LabEditDOS.Hint:='˫��ʱ�Զ������ݿ��������';
      ComboBoxHint.Hint:='';
    end;
  8: //ǿ�ƽ�������
    begin
      LabEditDOS.Text:='ntsd -c q -p ';
      LabEditDOS.Hint:='������������̵�PID';
      ComboBoxHint.Hint:='';
    end;
  end;
end;

procedure TFrmMain.RzBtnDOSClick(Sender: TObject);
begin //ִ��DOS����
  MemoDOS.Lines.Clear;
  aRunDosThread := TRunDosThread.Create(False, LabEditDOS.Text);
end;

procedure TFrmMain.LabEditDOSKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin //DOS����༭����ܻس�����
  if Key = VK_RETURN then RzBtnDOS.Click;
end;

procedure TFrmMain.N130Click(Sender: TObject);
begin //����2000����ҳԤ��
  ShellExecute(Handle,'open','regsvr32','/s thumbvw.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N131Click(Sender: TObject);
begin //ͣ��2000����ҳԤ��
  ShellExecute(Handle,'open','regsvr32','/u /s thumbvw.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N132Click(Sender: TObject);
begin //2000 SP4 ���á�����ģʽ��
  ShellExecute(Handle,'open','regsvr32','/s C:\WINNT\AppPatch\slayerui.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s D:\WINNT\AppPatch\slayerui.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s E:\WINNT\AppPatch\slayerui.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N133Click(Sender: TObject);
begin //2000 SP4 ͣ�á�����ģʽ��
  ShellExecute(Handle,'open','regsvr32','/u /s C:\WINNT\AppPatch\slayerui.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/u /s D:\WINNT\AppPatch\slayerui.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/u /s E:\WINNT\AppPatch\slayerui.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N134Click(Sender: TObject);
begin //����XP��zip��cab ����
  ShellExecute(Handle,'open','regsvr32','/s zipfldr.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s cabview.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N135Click(Sender: TObject);
begin //ͣ��XP��zip��cab ����
  ShellExecute(Handle,'open','regsvr32','/u /s zipfldr.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/u /s cabview.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N136Click(Sender: TObject);
begin //����XP��ý��Ԥ������
  ShellExecute(Handle,'open','regsvr32','/s shmedia.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N137Click(Sender: TObject);
begin //ͣ��XP��ý��Ԥ������
  ShellExecute(Handle,'open','regsvr32','/u /s shmedia.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N138Click(Sender: TObject);
begin //����XP��ͼƬ�ʹ���Ԥ��
  ShellExecute(Handle,'open','regsvr32','/s shimgvw.dll',nil,SW_SHOWNORMAL)
end;


procedure TFrmMain.N139Click(Sender: TObject);
begin //ͣ��XP��ͼƬ�ʹ���Ԥ��
  ShellExecute(Handle,'open','regsvr32','/u /s shimgvw.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.RzBtnXPJiHuoClick(Sender: TObject);
begin //�鿴 XP �Ƿ񼤻�
  ShellExecute(Handle,'open','oobe/msoobe','/a',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N140Click(Sender: TObject);
begin //ע�� scrrun.dll
  ShellExecute(Handle,'open','regsvr32','/s scrrun.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N141Click(Sender: TObject);
begin //��ע�� scrrun.dll
  ShellExecute(Handle,'open','regsvr32','/u /s scrrun.dll',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N142Click(Sender: TObject);
begin //���� Windows Update
  ShellExecute(Handle,'open','regsvr32','/s wupdinfo.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s wuaueng.dll',nil,SW_SHOWNORMAL);
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wuauserv\Start', 2); //������Ϊ�Զ�
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\BITS\Start', 2); //������Ϊ�Զ�
  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\AUOptions', 4);
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutoUpdate', 0);
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWindowsUpdate', 0);
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate\DisableWindowsUpdateAccess', 0);
  RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate', 0);
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then reg1.writestring('RegDone','1');
  if reg1.OpenKey('\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility',false) then
  begin
    reg1.DeleteKey('{3E68E405-C6DE-49FF-83AE-41EE9F4C36CE}');  reg1.DeleteKey('{6414512B-B978-451D-A0D8-FCFDF33E833C}');
    reg1.DeleteKey('{9F1C11AA-197B-4942-BA54-47A8489BB47F}');
  end;
end;

procedure TFrmMain.N143Click(Sender: TObject);
begin //ͣ�� Windows Update
  ShellExecute(Handle,'open','regsvr32','/u /s wupdinfo.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/u /s wuaueng.dll',nil,SW_SHOWNORMAL);
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wuauserv\Start', 3); //������Ϊ�ֶ�
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\BITS\Start', 3); //������Ϊ�Զ�
  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\AUOptions', 1);   
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutoUpdate', 1);
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWindowsUpdate', 1);
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate\DisableWindowsUpdateAccess', 1);
  RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate', 1);
  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{3E68E405-C6DE-49FF-83AE-41EE9F4C36CE}\Compatibility Flags', 1024);
  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{6414512B-B978-451D-A0D8-FCFDF33E833C}\Compatibility Flags', 1024);
  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{9F1C11AA-197B-4942-BA54-47A8489BB47F}\Compatibility Flags', 1024);
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then reg1.writestring('RegDone','0');
end;

procedure TFrmMain.N510Click(Sender: TObject);
begin //���Ĵ���ɨ��ȴ�ʱ��Ϊ5��
  ShellExecute(Handle,'open','chkntfs','/T:5',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N1010Click(Sender: TObject);
begin    //����ɨ��ĵȴ�ʱ��Ĭ�ϣ�10��
  ShellExecute(Handle,'open','chkntfs','/T:10',nil,SW_SHOWNORMAL)
end;

procedure TFrmMain.N180Click(Sender: TObject);
begin //Intel�����Կ��������Ҽ��˵� ����
  ShellExecute(Handle,'open','regsvr32','/s igfxpph.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s igfxsrvc.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N181Click(Sender: TObject);
begin //Intel�����Կ��������Ҽ��˵� ͣ��
  ShellExecute(Handle,'open','regsvr32','/s /u igfxpph.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s /u igfxsrvc.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N178Click(Sender: TObject);
begin //nVIDIA�����Կ��������Ҽ��˵� ����
  ShellExecute(Handle,'open','regsvr32','/s nvcpl.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N183Click(Sender: TObject);
begin //nVIDIA�����Կ��������Ҽ��˵� ͣ��
  ShellExecute(Handle,'open','regsvr32','/s /u nvcpl.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N182Click(Sender: TObject);
begin //ATi�����Կ��������Ҽ��˵� ����
  ShellExecute(Handle,'open','regsvr32','/s atiacmxx.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N184Click(Sender: TObject);
begin //ATi�����Կ��������Ҽ��˵� ͣ��
  ShellExecute(Handle,'open','regsvr32','/s /u atiacmxx.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N144Click(Sender: TObject);
begin //�޸�����ʾ���桱�͡����͵���
  ShellExecute(Handle,'open','regsvr32','/s /n /i:U shell32.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s /i shell32.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s ole32.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s sendmail.dll',nil,SW_SHOWNORMAL);
  if reg1.OpenKey('\SOFTWARE\Classes\AllFilesystemObjects\shellex\ContextMenuHandlers\Send To',true)
  then reg1.writestring('','{7BA4C740-9E81-11CF-99D3-00AA004AE837}');
end;

procedure TFrmMain.N148Click(Sender: TObject);
begin //�޸��Ҽ��˵����½���
  if reg1.OpenKey('\SOFTWARE\Classes\Directory\Background\shellex\ContextMenuHandlers\New',true)
  then reg1.writestring('','{D969A300-E7FF-11d0-A93B-00A0C90F2719}');
end;

procedure TFrmMain.N145Click(Sender: TObject);
begin //�޸������/ɾ������
  ShellExecute(Handle,'open','regsvr32','/s mshtml.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s /i shdocvw.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s /i shell32.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.Excel2Click(Sender: TObject);
begin //�޸�Excel
  ShellExecute(Handle,'open','excel','/s',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.Word2Click(Sender: TObject);
begin //�޸�Word
  ShellExecute(Handle,'open','winword','/a',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.WindowsMediaPlayer2Click(Sender: TObject);
begin //�޸� Windows Media Player
  ShellExecute(Handle,'open','regsvr32','/s msdxm.ocx',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s wmp.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s wmpdxm.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s wmpshell.dll',nil,SW_SHOWNORMAL);  
end;

procedure TFrmMain.N146Click(Sender: TObject);
begin //�޸� �����û�����
  if reg4.OpenKey('\TypeLib\{97d25db0-0363-11cf-abc4-02608c9e7553}\1.0',true)
  then reg4.WriteString('','Active DS Type Library');
  if reg4.OpenKey('\TypeLib\{97d25db0-0363-11cf-abc4-02608c9e7553}\1.0\0\win32',true)
  then reg4.WriteString('','%windir%\\system32\\activeds.tlb');
  if reg4.OpenKey('\TypeLib\{97d25db0-0363-11cf-abc4-02608c9e7553}\1.0\FLAGS',true)
  then reg4.WriteString('','0');
  if reg4.OpenKey('\TypeLib\{97d25db0-0363-11cf-abc4-02608c9e7553}\1.0\HELPDIR',true)
  then reg4.WriteString('','%windir%\\system32');
end;

procedure TFrmMain.N147Click(Sender: TObject);
begin //�޸� �������
  ShellExecute(Handle,'open','regsvr32','/s C:\WINDOWS\system32\Com\comadmin.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s D:\WINDOWS\system32\Com\comadmin.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s E:\WINDOWS\system32\Com\comadmin.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s C:\WINNT\system32\Com\comadmin.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s D:\WINNT\system32\Com\comadmin.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s E:\WINNT\system32\Com\comadmin.dll',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.N150Click(Sender: TObject);
begin //�޸���ʾ����
  if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\System',false) then
  begin
    reg2.DeleteValue('NoDispAppearancePage'); reg2.DeleteValue('NoDispBackgroundPage');
    reg2.DeleteValue('NoDispScrSavPage');     reg2.DeleteValue('NoDispSettingsPage');
    reg2.DeleteValue('NoColorChoice');        reg2.DeleteValue('NoSizeChoice');
    reg2.DeleteValue('NoVisualStyleChoice');  reg2.DeleteValue('NoDispCPL');
  end;
  if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false) then
  begin
    reg2.DeleteValue('NoThemesTab'); reg2.DeleteValue('NoHardwareTab');
  end;
end;

procedure TFrmMain.N151Click(Sender: TObject);
begin //�޸��ļ���ѡ��
  if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false)
  then reg2.DeleteValue('NoFolderOptions');
end;

procedure TFrmMain.Internet4Click(Sender: TObject);
begin //�޸�Internetѡ��Ҽ��˵�
  RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3\1803', 0);//���������صĽ��
  if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false) then
  begin
    reg2.DeleteValue('NoBandCustomize');          reg2.DeleteValue('NoToolbarCustomize');
    reg2.DeleteValue('NoTrayContextMenu');        reg2.DeleteValue('NoBrowserContextMenu');
    reg2.DeleteValue('NoViewContextMenu');        reg2.DeleteValue('NoShellSearchButton');
    reg2.DeleteValue('NoChangeStartMenu');        reg2.DeleteValue('NoSetTaskbar');
    reg2.DeleteValue('NoFolderOptions');          reg2.DeleteValue('NoFileMenu');
    reg2.DeleteValue('NoToolbarsOnTaskbar');      reg2.DeleteValue('NoSetFolders');
    reg2.DeleteValue('DisablePersonalDirChange'); reg2.DeleteValue('LockTaskbar');
    reg2.DeleteValue('NoCloseDragDropBands');     reg2.DeleteValue('NoDesktop');
    reg2.DeleteValue('NoMovingBands');            reg2.DeleteValue('NoPropertiesMyComputer');
    reg2.DeleteValue('NoPropertiesMyDocuments');
  end;
  if reg2.OpenKey('\Software\Policies\Microsoft\Internet Explorer\Infodelivery',false) then reg2.DeleteKey ('Restrictions') ;
  if reg2.OpenKey('\Software\Policies\Microsoft\Internet Explorer',false) then reg2.DeleteKey('Restrictions') ;
  if reg2.OpenKey('\Software\Policies\Microsoft\Internet Explorer',false) then reg2.DeleteKey('Control Panel') ;
  if reg2.OpenKey('\Software\Microsoft\Internet Explorer\Main',false) then
  begin
    reg2.writestring('FavIntelliMenus','no'); reg2.writestring('FullScreen','no');
    reg2.writestring('Show_ChannelBand','no'); reg2.writestring('Show_FullURL','yes');
    reg2.writestring('Show_StatusBar','yes'); reg2.writestring('Show_ToolBar','yes');
    reg2.writestring('Show_URLinStatusBar','yes'); reg2.writestring('Show_URLToolBar','yes');
    reg2.writestring('ShowGoButton','yes'); reg2.writestring('Use_DlgBox_Colors','yes');
    reg2.writestring('Print_Background','no'); reg2.writestring('Save_Session_History_On_Exit','no');
    reg2.writestring('Use_DlgBox_Colors','yes'); reg2.writestring('Window Title','');
    reg2.writestring('NotifyDownloadComplete','no');
  end;
end;

procedure TFrmMain.USB1Click(Sender: TObject);
begin //�޸�USB�ӿ�
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\usbhub\Start',3); //����USB
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\USBSTOR\Start',3);
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\usbuhci\Start',3);
  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\StorageDevicePolicies\WriteProtect',0);  
end;

procedure TFrmMain.RzChkGroupStartMenuItemCheckeditrue1Click(
  Sender: TObject);
begin //�޸����������
  if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\system',false) then
  begin
    reg2.DeleteValue('DisableTaskMgr') ;       reg2.DeleteValue('DisableLockWorkstation') ;
    reg2.DeleteValue('DisableChangePassword') ;
  end;
end;

procedure TFrmMain.N153Click(Sender: TObject);
begin //�޸�ע�����ػ�������
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\StartMenuLogoff', 1);
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\StartMenuRun', 1);
  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun', 0);
  RegSetDword(Reg1.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\RestrictRun', 0);
  if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false) then
  begin
    reg2.DeleteValue('NoLogoff') ; reg2.DeleteValue('StartMenuLogOff') ;
    reg2.DeleteValue('NoClose') ;  reg2.DeleteValue('NoRun') ;
    reg2.DeleteValue('NoFind') ;
  end;
end;

procedure TFrmMain.N152Click(Sender: TObject);
begin //ȡ����������Ӳ��
  if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false)
  then reg2.DeleteValue('NoDrives') ;
end;

procedure TFrmMain.N176Click(Sender: TObject);
begin //�ڴ治�ܶ�д
  ShellExecute(Handle,'open','regsvr32','/s jscript.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s vbscript.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s wshext.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s wshom.ocx',nil,SW_SHOWNORMAL);
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer',false)
  then reg1.DeleteKey('ShellExecuteHooks');
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks',true)
  then reg1.writestring('{AEB6717E-7E19-11d0-97EE-00C04FD91972}','');
end;

procedure TFrmMain.LabeEditHintDblClick(Sender: TObject);
begin //˫���༭��ʱ�Զ������ݿ��������
  TLabeledEdit(sender).SelectAll;
  TLabeledEdit(sender).CopyToClipboard
end;

procedure TFrmMain.InternetExplorer3Click(Sender: TObject);
begin //�޸�Internet Explorer
  //��ʼ���������IE������󻯵�����
  if reg2.OpenKey('\Software\Microsoft\Internet Explorer\Desktop\Old WorkAreas',false) then reg2.DeleteValue('OldWorkAreaRects');
  if reg2.OpenKey('\Software\Microsoft\Internet Explorer\Main',false) then reg2.DeleteValue('Window_Placement');
  ShellExecute(Handle,'open','regsvr32','/s actxprxy.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s asctrls.ocx',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s browseui.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s comcat.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s corpol.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s cryptdlg.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s cryptext.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s dispex.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s hhctrl.ocx',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s hlink.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s iepeers.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s imgutil.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s inseng.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s isetup.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s jscript.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s mlang.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s mobsync.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s mshtmled.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s mshtml.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s msjava.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s msoeacct.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s msrating.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s msxml.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s occache.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s oleaut32.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s plugin.ocx',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s pngfilt.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s scrobj.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s setupwbv.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s sendmail.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s shdocvw.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s shell32.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s urlmon.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s vbscript.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s webcheck.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s wininet.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s urlmon.dll',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s C:\PROGRA~1\INTERN~1\HMMAPI.DLL',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s D:\PROGRA~1\INTERN~1\HMMAPI.DLL',nil,SW_SHOWNORMAL);
  ShellExecute(Handle,'open','regsvr32','/s E:\PROGRA~1\INTERN~1\HMMAPI.DLL',nil,SW_SHOWNORMAL);  
  ShellExecute(Handle,'open','iexplore','/rereg',nil,SW_SHOWNORMAL);
end;

procedure TFrmMain.MemoHotfixDblClick(Sender: TObject);
var
  i:word; straddr:string; list:Tstrings;
  MemInfo:MemoryStatus;  len:dword;
  username:array[0..50] of char;
begin //��ʾϵͳ��Ϣ
  //MemoHotfix.Color:=$00FFEBDE;
  MemoHotfix.Font.Height:=-12;  MemoHotfix.Font.Color:=clBlack;
  list:=Tstringlist.Create;
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\HotFix',false) then
  begin
    reg1.GetkeyNames(list); //����������
    MemoHotfix.Clear;
    //Memo1.Lines.BeginUpdate;
    if list.Count>0 then for i:=0 to list.Count-1 do MemoHotfix.Lines.Add(list.Strings[i]);
    //Memo1.Lines.EndUpdate;
    MemoHotfix.Lines.Insert(0,'�Ѱ�װ�Ĳ����� ' + inttostr(list.Count) + ' ��');
    MemoHotfix.Lines.Insert(1,'')
  end;
  list.Free;
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion',false)
  then LabOS.Caption:='����ϵͳ�� ' + reg1.ReadString('ProductName');
  if LabOS.Caption = '����ϵͳ�� ' then
    if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then
      LabOS.Caption:='����ϵͳ�� ' + reg1.ReadString('ProductName') + '  ' + reg1.ReadString('CSDVersion');
  if reg1.OpenKey('\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName',false)
  then LabEditComName.Text:=reg1.ReadString('ComputerName');
  if reg1.OpenKey('\SOFTWARE\Microsoft\Internet Explorer',false)
  then LabIEVer.Caption:='IE �汾�� ' +  reg1.ReadString('Version');
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings',false)
  then LabEditIEHotfix.Text:=reg1.ReadString('MinorVersion');
  len:=50;
  if getusername(username,len) then LabUser.Caption:='��ǰ�û��� ' + username;
  if GetLocalIP(straddr) then LabIP.Caption:='IP ��ַ�� ' + straddr;
  LabSysdir.Caption:='ϵͳĿ¼�� ' + sysdir;
  MemInfo.dwLength:=sizeof(MemoryStatus);
  GlobalMemoryStatus(MemInfo);
  LabMemorySize.Caption:='�ڴ��С�� ' + IntToStr(MemInfo.dwTotalPhys div 1048576) + ' MB';
  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then
  begin
    LabEditSourPath.Text:=reg1.ReadString('SourcePath');
    LabEditOwner.Text:=reg1.ReadString('RegisteredOwner');
    LabEditOrgan.Text:=reg1.ReadString('RegisteredOrganization');
  end;  
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var h:word; m:byte;
begin //��ʾϵͳ����ʱ��
  //LabRunTime.Caption:=timetostr(time); //��ʾ��ǰʱ��
  h:=timeGetTime div 3600000; //timeGetTime:���ϵͳ������ʱ��,��λ����
  m:=( timeGetTime mod 3600000 ) div 60000;
  LabRunTime.Caption:='ϵͳ����ʱ�䣺 ' + inttostr(h) + 'Сʱ' + inttostr(m) + '��';
  ClearMemory; //����ClearMemory���̣���С������ڴ�ռ��
end;

procedure TFrmMain.RzBtnComNameClick(Sender: TObject);
begin //�ļ������
  if LabEditComName.Text='' then MessageBox(Handle, '�����������Ϊ�գ� ', '����', MB_ICONHAND)
  else
    begin
      if MessageBox(Handle, 'ȷʵҪ�޸ļ��������'#13''#13'�� ���������ò�Ҫ�����Ǳ�׼�ַ� ��'#13'�� ��׼�ַ�������ĸ(A-Z��a-z)������(0-9)�����ַ�(-) ��', '�������', MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = IDOK then
      begin
        SetComputerName(pchar(LabEditComName.Text));
        if reg1.OpenKey('\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters',false) then
        begin
          reg1.writestring('NV Hostname',LabEditComName.Text);
          MessageBox(Handle, '�޸ĳɹ�������Ҫ��������������� ', '�������', MB_ICONASTERISK);
        end
        else MessageBox(Handle, '�޸ļ��������ʧ�ܣ� ', '����', MB_ICONHAND);
      end;
    end;
end;

procedure TFrmMain.RzBitBtnSourcePathClick(Sender: TObject);
var sdir:string;
begin //ѡ��װ��·��
  if SelectDirectory('��ѡ��װ��·����' , '' , Handle, sdir) then LabEditSourPath.Text:=sdir;
end;

procedure TFrmMain.RzBtnSourcePathClick(Sender: TObject);
begin //�İ�װ��·��
  if LabEditSourPath.Text='' then MessageBox(Handle, '��װ��·������Ϊ�գ� ', '����', MB_ICONHAND)
  else
    begin
      if MessageBox(Handle, 'ȷʵҪ�޸İ�װ��·���� ', '��װ��·��', MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = IDOK then
        if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then
        begin
          reg1.writestring('SourcePath',LabEditSourPath.Text);
          MessageBox(Handle, '�޸ĳɹ��� ', '��װ��·��', MB_ICONASTERISK);
        end
        else MessageBox(Handle, '�޸İ�װ��·��ʧ�ܣ� ', '����', MB_ICONHAND);
    end;
end;

procedure TFrmMain.RzBtnRegInfoClick(Sender: TObject);
begin //���û�����֯
  if MessageBox(Handle, 'ȷʵҪ�޸�ע����Ϣ�� ', 'ע����Ϣ', MB_ICONQUESTION or MB_OKCANCEL or MB_DEFBUTTON2) = IDOK then
  begin
    if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion',false) then
    begin
      reg1.writestring('RegisteredOwner',LabEditOwner.Text);
      reg1.writestring('RegisteredOrganization',LabEditOrgan.Text);
      MessageBox(Handle, '�޸ĳɹ��� ', 'ע����Ϣ', MB_ICONASTERISK);
    end
    else MessageBox(Handle, '�޸�ע����Ϣʧ�ܣ� ', '����', MB_ICONHAND);
  end;
end;

procedure TFrmMain.RzChkGroupXPChange(Sender: TObject; Index: Integer;
  NewState: TCheckBoxState);
begin //��̬�ظı������򵼵��������
  RzChkGroupXP.ItemEnabled[12] := not RzChkGroupXP.ItemChecked[11]
end;

procedure TFrmMain.ComBoxXPChange(Sender: TObject);
var i:byte;
begin //XP ����
  case ComBoxXP.ItemIndex of
    0: //һ�����
    begin
      for i:=0 to 1 do RzChkGroupXPSP2.ItemChecked[i]:=true;
      for i:=0 to 7 do RzChkGroupXP.ItemChecked[i]:=true;
      for i:=8 to 11 do RzChkGroupXP.ItemChecked[i]:=false;
      for i:=12 to 13 do RzChkGroupXP.ItemChecked[i]:=true;
    end;
    1: //��������
    begin
      for i:=0 to 1 do RzChkGroupXPSP2.ItemChecked[i]:=true;
      RzChkGroupXP.ItemChecked[0]:=true;
      RzChkGroupXP.ItemChecked[1]:=false;
      RzChkGroupXP.ItemChecked[2]:=false;
      for i:=3 to 7 do RzChkGroupXP.ItemChecked[i]:=true;
      for i:=8 to 13 do RzChkGroupXP.ItemChecked[i]:=false;
    end;
  end; //endcase
end;

procedure TFrmMain.RzBitBtnXPOKClick(Sender: TObject);
begin //XP Ӧ��
  if os<>'Microsoft Windows XP' then MessageBox(Handle, '��û�а�װ Windows XP ', '����ϵͳ', MB_ICONASTERISK)
  else
  begin
    case RzChkGroupXP.ItemChecked[0] of //�л��û�ʱ���粻����
    true:  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',true) then reg1.writestring('KeepRASConnections','1');
    false: if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',true) then reg1.writestring('KeepRASConnections','0');
    end;

    case RzChkGroupXP.ItemChecked[1] of //����ϵͳ�������ͼ��
    true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\EnableAutoTray', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutoTrayNotify', 0);//��Ϊ1����ֹ���á����ز����ͼ�ꡱ
      end;
    false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\EnableAutoTray', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoAutoTrayNotify', 0);
      end;
    end;

    case RzChkGroupXP.ItemChecked[2] of //����������������ť
    true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarGlomming', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoTaskGrouping', 0);//��Ϊ1����ֹ���á�����������������
      end;
    false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarGlomming', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoTaskGrouping', 0);
      end;
    end;

    case RzChkGroupXP.ItemChecked[3] of //���ء��ҵĵ��ԡ��µĹ����ĵ�
    true: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoSharedDocuments', 1);
    false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoSharedDocuments', 0);
    end;

    case RzChkGroupXP.ItemChecked[4] of //��ֹ���󱨸�
    true:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ERSvc\Start', 3); //���÷���Ϊ�ֶ�
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\PCHealth\ErrorReporting\DoReport', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\PCHealth\ErrorReporting\ShowUI', 0);    
      end;
    false:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ERSvc\Start', 2); //���÷���Ϊ�Զ�
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\PCHealth\ErrorReporting\DoReport', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\PCHealth\ErrorReporting\ShowUI', 1);
      end;
    end;

    case RzChkGroupXP.ItemChecked[5] of //��ֹϵͳ��ԭ
    true:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\srservice\Start', 3); //���÷���Ϊ�ֶ�
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore\DisableSR', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore\DisableConfig', 1);
      end;
    false:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\srservice\Start', 2); //���÷���Ϊ�Զ�
      if reg1.OpenKey('\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore',false) then
      begin
        reg1.DeleteValue('DisableSR') ;  reg1.DeleteValue('DisableConfig') ;
        end;
      end;
    end;

    case RzChkGroupXP.ItemChecked[6] of //��ֹ����Զ��Э������
    true:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Terminal Server\TSEnabled', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Terminal Server\TSUserEnabled', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Terminal Server\fAllowToGetHelp', 0);
      if reg1.OpenKey('\SOFTWARE\Microsoft\Ole',true) then reg1.writestring('EnableRemoteConnect','N');
      end;
    false:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Terminal Server\TSEnabled', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Terminal Server\TSUserEnabled', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Terminal Server\fAllowToGetHelp', 1);
      if reg1.OpenKey('\SOFTWARE\Microsoft\Ole',true) then reg1.writestring('EnableRemoteConnect','Y');    
      end;
    end;

    case RzChkGroupXP.ItemChecked[7] of //��½��Ļ����ʾ����Ա�ʻ�
    true:  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList\Administrator', 1);
    false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList\Administrator', 0);
    end;

    case RzChkGroupXP.ItemChecked[8] of //ʹ�� Windows ��ͳ��½����
    true:  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\LogonType', 0);
    false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\LogonType', 1);
    end;

    case RzChkGroupXP.ItemChecked[9] of //�Զ���������������
    true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz\NoRun', 0);
    false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\CleanupWiz\NoRun', 1);
    end;

    case RzChkGroupXP.ItemChecked[10] of //�Զ�����Windows Messenger
    true:  RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Messenger\Client\PreventAutoRun', 0);
    false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Messenger\Client\PreventAutoRun', 1);
    end;

    case RzChkGroupXP.ItemChecked[11] of //ʹ��2000����������
    true:  if reg2.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState',true) then reg2.WriteExpandString('Use Search Asst','no');
    false: if reg2.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState',false) then reg2.DeleteValue('Use Search Asst');
    end;

    case RzChkGroupXP.ItemChecked[12] of //ʹ��������
    true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\SocialUI', 1); //ʹ�ö�����ɫ
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\UseAdvancedSearchAlways', 0); //��ʹ�ø߼�����
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\AutoComplete', 1); //�Զ����
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\BalloonTips', 1); //������ʾ
      end;
    false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\SocialUI', 0); //��ʹ�ö�����ɫ
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\UseAdvancedSearchAlways', 1); //ʹ�ø߼�����
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\AutoComplete', 1); //�Զ����
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\BalloonTips', 1); //������ʾ
      end;
    end;

    case RzChkGroupXP.ItemChecked[13] of //�Զ�ʱ��ͬ��
    true:  if reg1.OpenKey('\SYSTEM\CurrentControlSet\Services\W32Time\Parameters',true) then reg1.writestring('Type','NTP');
    false: if reg1.OpenKey('\SYSTEM\CurrentControlSet\Services\W32Time\Parameters',true) then reg1.writestring('Type','NoSync');
    end;

    case RzChkGroupXPSP2.ItemChecked[0] of //SP2��ʾ��վ����֤��ͼƬ
    true:  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Security\BlockXBM', 0);
    false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Security\BlockXBM', 1);
    end;

    case RzChkGroupXPSP2.ItemChecked[1] of //SP2���ɵ��� IE �İ�ȫ����
    true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3\MinLevel', 65536);
    false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3\MinLevel', 69632);
    end;

    SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, NiL, NiL); //ˢ��
  end;
end;

procedure TFrmMain.ComBoxMediaChange(Sender: TObject);
var i:byte;
begin //Media Player ����
  case ComBoxMedia.ItemIndex of
    0: //һ�����
    begin
      for i:=0 to 5 do RzChkGroupMedia.ItemChecked[i]:=true;
      RzChkGroupMedia.ItemChecked[6]:=false;
      for i:=7 to 9 do RzChkGroupMedia.ItemChecked[i]:=true;
      for i:=10 to 13 do RzChkGroupMedia.ItemChecked[i]:=false;
    end;
    1: //��������
    begin
      for i:=0 to 5 do RzChkGroupMedia.ItemChecked[i]:=true;
      for i:=6 to 13 do RzChkGroupMedia.ItemChecked[i]:=false;
    end;
  end; //endcase
end;

procedure TFrmMain.RzBitBtnMediaOKClick(Sender: TObject);
begin //Media Player Ӧ��
  case RzChkGroupMedia.ItemChecked[0] of //ʶ�� dat��rm��rmvb ���ļ�
  true:
    begin
      if reg1.OpenKey('\SOFTWARE\Microsoft\MediaPlayer\Player\Extensions\Descriptions',true)
      then reg1.writestring('9','�����ļ� (*.dat;*.rm;*.rmvb;*.ra;*.rv;*.ram;*.ape;*.mp4)');
      if reg1.OpenKey('\SOFTWARE\Microsoft\MediaPlayer\Player\Extensions\MUIDescriptions',true)
      then reg1.writestring('9','�����ļ�');
      if reg1.OpenKey('\SOFTWARE\Microsoft\MediaPlayer\Player\Extensions\Types',true)
      then reg1.writestring('9','*.dat;*.rm;*.rmvb;*.ra;*.rv;*.ram;*.ape;*.mp4');    
    end;
  //false:
  end;

  case RzChkGroupMedia.ItemChecked[1] of //��ֹ���Žű�
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\MediaPlayer\Preferences\PlayerScriptCommandsEnabled', 0);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\MediaPlayer\Preferences\PlayerScriptCommandsEnabled', 0);
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\MediaPlayer\Preferences\PlayerScriptCommandsEnabled', 1);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\MediaPlayer\Preferences\PlayerScriptCommandsEnabled', 1);
    end;
  end;

  case RzChkGroupMedia.ItemChecked[2] of //���� DVD ����
  true:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Settings',true) then reg2.writestring('EnableDVDUI','yes');
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Player\Settings',true) then reg2.writestring('EnableDVDUI','yes');
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Settings',true) then reg2.writestring('EnableDVDUI','no');
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Player\Settings',true) then reg2.writestring('EnableDVDUI','no');
    end;
  end;

  case RzChkGroupMedia.ItemChecked[3] of //ʼ����ʾ�˵���
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\ShowAppTitlebar', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\ShowAppTitlebar', 0);
  end;

  case RzChkGroupMedia.ItemChecked[4] of //��ʾ���ӻ�Ч��
  true:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor[0]:=255; Bufor[1]:=255; Bufor[2]:=0; Bufor[3]:=0;
        reg2.WriteBinaryData('ShowEffects',Bufor,SizeOf(Bufor));
      end;
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor[0]:=0; Bufor[1]:=0; Bufor[2]:=0; Bufor[3]:=0;
        reg2.WriteBinaryData('ShowEffects',Bufor,SizeOf(Bufor));
      end;    
    end;
  end;

  case RzChkGroupMedia.ItemChecked[5] of //��ʾ���硢��ȫ����˽ѡ�
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Policies\Microsoft\WindowsMediaPlayer\HideNetworkTab', 0);
      RegSetDword(Reg2.RootKey, 'Software\Policies\Microsoft\WindowsMediaPlayer\HideSecurityTab', 0);
      RegSetDword(Reg2.RootKey, 'Software\Policies\Microsoft\WindowsMediaPlayer\HidePrivacyTab', 0);
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Policies\Microsoft\WindowsMediaPlayer\HideNetworkTab', 1);
      RegSetDword(Reg2.RootKey, 'Software\Policies\Microsoft\WindowsMediaPlayer\HideSecurityTab', 1);
      RegSetDword(Reg2.RootKey, 'Software\Policies\Microsoft\WindowsMediaPlayer\HidePrivacyTab', 1);
    end;
  end;

  case RzChkGroupMedia.ItemChecked[6] of //�����ʾ
  true:  if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then reg2.writestring('Maximized','1');
  false: if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then reg2.writestring('Maximized','0');
  end;

  case RzChkGroupMedia.ItemChecked[7] of //������ʷ��¼
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\DisableMRU', 0);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\DisableMRU', 1);
  end;

  case RzChkGroupMedia.ItemChecked[8] of //�Զ����ر��������
  true:
    begin
      if reg2.OpenKey('\Software\Policies\Microsoft\WindowsMediaPlayer',false) then
      begin
        reg2.DeleteValue('PreventCodecDownload');  reg2.DeleteValue('NoCodecDownload');
      end;
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor2:=1;  reg2.WriteBinaryData('UpgradeCodecPrompt',Bufor2,SizeOf(Bufor2));
      end;
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Policies\Microsoft\WindowsMediaPlayer',false) then
      begin
        reg2.DeleteValue('PreventCodecDownload');  reg2.DeleteValue('NoCodecDownload');
      end;
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor2:=0;  reg2.WriteBinaryData('UpgradeCodecPrompt',Bufor2,SizeOf(Bufor2));
      end;
    end;
  end;

  case RzChkGroupMedia.ItemChecked[9] of //�Զ����²�����
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\WindowsMediaPlayer\DisableAutoUpdate', 0);
      if reg1.OpenKey('\SOFTWARE\Microsoft\MediaPlayer',true) then reg1.writestring('EnableAutoUpgrade','yes');
      if reg1.OpenKey('\SOFTWARE\Microsoft\MediaPlayer\PlayerUpgrade',true) then
      begin
        reg1.writestring('AskMeAgain','yes');  reg1.writestring('EnableAutoUpgrade','yes');
      end;
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\WindowsMediaPlayer\DisableAutoUpdate', 1);
      if reg1.OpenKey('\SOFTWARE\Microsoft\MediaPlayer',true) then reg1.writestring('EnableAutoUpgrade','no');
      if reg1.OpenKey('\SOFTWARE\Microsoft\MediaPlayer\PlayerUpgrade',true) then
      begin
        reg1.writestring('AskMeAgain','no');  reg1.writestring('EnableAutoUpgrade','no');
      end;
    end;
  end;

  case RzChkGroupMedia.ItemChecked[10] of //�Զ����������ı�ʶ���͸������ṩ��
  true:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor2:=1;  reg2.WriteBinaryData('SendUserGUID',Bufor2,SizeOf(Bufor2));
      end;
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor2:=0;  reg2.WriteBinaryData('SendUserGUID',Bufor2,SizeOf(Bufor2));
      end;
    end;
  end;

  case RzChkGroupMedia.ItemChecked[11] of //�Զ�����ȱ�ٵ�ý����Ϣ
  true:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor2:=1;  reg2.WriteBinaryData('SilentAcquisition',Bufor2,SizeOf(Bufor2));
      end;
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\MetadataRetrieval', 3);
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\MediaPlayer\Preferences',true) then
      begin
        Bufor2:=0;  reg2.WriteBinaryData('SilentAcquisition',Bufor2,SizeOf(Bufor2));
      end;
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\MetadataRetrieval', 0);
    end;
  end;

  case RzChkGroupMedia.ItemChecked[12] of //�����ֽ��и�������
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\CDRecordDRM', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\CDRecordDRM', 0);
  end;

  case RzChkGroupMedia.ItemChecked[13] of //����ʱ��ʾ��ý��ָ�ϡ�
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\StartInMediaGuide', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\MediaPlayer\Preferences\StartInMediaGuide', 0);
  end;

  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, NiL, NiL); //ˢ��
end;

procedure TFrmMain.ComBoxNetChange(Sender: TObject);
var i:byte;
begin //������� ����
  case ComBoxNet.ItemIndex of
    0: //һ�����
    begin
      for i:=0 to 4 do RzChkGroupNet.ItemChecked[i]:=true;
      for i:=5 to 10 do RzChkGroupNet.ItemChecked[i]:=false;
      for i:=0 to 3 do RzChkGroupIE.ItemChecked[i]:=true;
      for i:=4 to 6 do RzChkGroupIE.ItemChecked[i]:=false;
    end;
    1: //�������û�
    begin
      for i:=0 to 10 do RzChkGroupNet.ItemChecked[i]:=true;
      for i:=0 to 3 do RzChkGroupIE.ItemChecked[i]:=true;
      for i:=4 to 6 do RzChkGroupIE.ItemChecked[i]:=false;
    end;    
  end; //endcase
end;

procedure TFrmMain.RzBitBtn1Click(Sender: TObject);
begin //������� Ӧ��
  case RzChkGroupNet.ItemChecked[0] of //ȡ�����̵�Ĭ�Ϲ���
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareWks', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer', 0);
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareWks', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\AutoShareServer', 1);
    end;  
  end;

  case RzChkGroupNet.ItemChecked[1] of //������������ʱ����ʾ��������
  true:  RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\fPromptForPassword', 0);
  false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\fPromptForPassword', 1);
  end;

  case RzChkGroupNet.ItemChecked[2] of //��ֹ���뻺��
  true:  RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\network\DisablePwdCaching', 1);
  false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\network\DisablePwdCaching', 0);
  end;

  case RzChkGroupNet.ItemChecked[3] of //��ֹ Web ��ӡ
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\Printers\DisableWebPrinting', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\Printers\PublishPrinters', 0);
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\Printers\DisableWebPrinting', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Windows NT\Printers\PublishPrinters', 1);
    end;
  end;
  
  case RzChkGroupNet.ItemChecked[4] of //��ֹ�ֲ�ʽ COM
  true:  if reg1.OpenKey('\SOFTWARE\Microsoft\Ole',true) then reg1.writestring('EnableDCOM','N');
  false: if reg1.OpenKey('\SOFTWARE\Microsoft\Ole',true) then reg1.writestring('EnableDCOM','Y');
  end;

  case RzChkGroupNet.ItemChecked[5] of //��Everyone���˺Ű��������û�
  true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous', 1);
  false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous', 0);
  end;
  
  case RzChkGroupNet.ItemChecked[6] of //��ʾ����������б��еļ����
  true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\Hidden', 0);
  false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanserver\parameters\Hidden', 1); //��������
  end;

  case RzChkGroupNet.ItemChecked[7] of //��ʾ����������б��еı���
  true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanworkstation\parameters\Hidden', 0);
  false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\lanmanworkstation\parameters\Hidden', 1); //�����Լ�
  end;
  
  case RzChkGroupNet.ItemChecked[8] of //��ʾ "ӳ��/�Ͽ�����������"
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoNetConnectDisconnect', 0);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoNetConnectDisconnect', 1);
  end;
  
  case RzChkGroupNet.ItemChecked[9] of //�����ļ��ʹ�ӡ������
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFileSharing', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoPrintSharing', 0);
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFileSharing', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoPrintSharing', 1);
    end;
  end;
  
  case RzChkGroupNet.ItemChecked[10] of //���������û�����
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\ForceGuest', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\RestrictAnonymous', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM', 0);
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\ForceGuest', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\RestrictAnonymous', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Lsa\RestrictAnonymousSAM', 1);
    end;
  end;

  case RzChkGroupIE.ItemChecked[0] of //��ֹ IE ���󱨸�
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonEnabled', 0);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonEnabled', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonDisabled', 1);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonDisabled', 1);
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonEnabled', 1);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonEnabled', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonDisabled', 0);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\Main\IEWatsonDisabled', 0);      
    end;
  end;

  case RzChkGroupIE.ItemChecked[1] of //���� Flash
  true:  if reg1.OpenKey('\SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility',false) then reg1.DeleteKey('{D27CDB6E-AE6D-11CF-96B8-444553540000}'); //Flash Player 7
  false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Internet Explorer\ActiveX Compatibility\{D27CDB6E-AE6D-11CF-96B8-444553540000}\Compatibility Flags', 1024);
  end;

  case RzChkGroupIE.ItemChecked[2] of //������������Ƶ�Ͷ���
  true:
    begin
      if reg2.OpenKey('\SOFTWARE\Microsoft\Internet Explorer\Main',true) then
      begin
        reg2.writestring('Display Inline Videos','yes');
        reg2.writestring('Play_Animations','yes');  reg2.writestring('Play_Background_Sounds','yes');
      end;
    end;
  false:
    begin
      if reg2.OpenKey('\SOFTWARE\Microsoft\Internet Explorer\Main',true) then
      begin
        reg2.writestring('Display Inline Videos','no');
        reg2.writestring('Play_Animations','no');  reg2.writestring('Play_Background_Sounds','no');
      end;
    end;
  end;

  case RzChkGroupIE.ItemChecked[3] of //��ֹ �ű�����
  true:
    begin
      if reg2.OpenKey('\Software\Microsoft\Internet Explorer\Main',true) then
      begin
        reg2.writestring('Disable Script Debugger','yes');
        reg2.writestring('DisableScriptDebuggerIE','yes');
        reg2.writestring('Error Dlg Displayed On Every Error','no');
      end;
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\Internet Explorer\Main',true) then
      begin
        reg2.writestring('Disable Script Debugger','no');
        reg2.writestring('DisableScriptDebuggerIE','no');
        reg2.writestring('Error Dlg Displayed On Every Error','yes');
      end;
    end;
  end;

  case RzChkGroupIE.ItemChecked[4] of //IE �Զ�����
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Internet Explorer\Main\NoUpdateCheck', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions\NoUpdateCheck', 0);
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Internet Explorer\Main\NoUpdateCheck', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions\NoUpdateCheck', 1);
    end;
  end;

  case RzChkGroupIE.ItemChecked[5] of //ɾ�� IE �ּ��������
  true: if reg1.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies',false) then reg1.DeleteKey('Ratings') ;
  //false:
  end;

  case RzChkGroupIE.ItemChecked[6] of //��װ IE6 ֮ǰ���ע���
  true: RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Active Setup\Installed Components\{89820200-ECBD-11cf-8B85-00AA005B4383}\IsInstalled', 0);
  //false:
  end;

  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, NiL, NiL); //ˢ��
end;

procedure TFrmMain.ComBoxSerChange(Sender: TObject);
var i:byte;
begin //���� ����
  case ComBoxSer.ItemIndex of
    0: //һ�����
    begin
      for i:=0 to 8 do RzChkGroupSer.ItemChecked[i]:=false;
      RzChkGroupSer.ItemChecked[9]:=true;
      for i:=10 to 13 do RzChkGroupSer.ItemChecked[i]:=false;
      RzChkGroupSer.ItemChecked[14]:=true;
      for i:=15 to 20 do RzChkGroupSer.ItemChecked[i]:=false;
      for i:=21 to 24 do RzChkGroupSer.ItemChecked[i]:=true;
      RzRdiGroupSer.ItemIndex:=1;
    end;
    1: //�����ٶ�
    begin
      for i:=0 to 8 do RzChkGroupSer.ItemChecked[i]:=false;
      RzChkGroupSer.ItemChecked[9]:=true;
      for i:=10 to 13 do RzChkGroupSer.ItemChecked[i]:=false;
      RzChkGroupSer.ItemChecked[14]:=true;
      for i:=15 to 24 do RzChkGroupSer.ItemChecked[i]:=false;
      RzRdiGroupSer.ItemIndex:=1;
    end;
  end; //endcase
end;

procedure TFrmMain.RzBitBtnSerClick(Sender: TObject);
begin //���� Ӧ��
  case RzRdiGroupSer.ItemIndex of
  0: //ѡ��Ϊ�Զ������򲻸ı�
  begin

    if RzChkGroupSer.ItemChecked[0] //Alerter �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Alerter\Start', 2);

    if RzChkGroupSer.ItemChecked[1] //Automatic Updates �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wuauserv\Start', 2);

    if RzChkGroupSer.ItemChecked[2] //Background Intelligent Transfer �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\BITS\Start', 2);

    if RzChkGroupSer.ItemChecked[3] //ClipBook �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ClipSrv\Start', 2);

    if RzChkGroupSer.ItemChecked[4] //Distributed Link Tracking Client �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\TrkWks\Start', 2);

    if RzChkGroupSer.ItemChecked[5] //Help and Support �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Helpsvc\Start', 2);

    if RzChkGroupSer.ItemChecked[6] //Logical Disk Manager �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\dmserver\Start', 2);

    if RzChkGroupSer.ItemChecked[7] //Messenger �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Messenger\Start', 2);

    if RzChkGroupSer.ItemChecked[8] //Remote Registry �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\RemoteRegistry\Start', 2);

    if RzChkGroupSer.ItemChecked[9] //System Event Notification �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\SENS\Start', 2);

    if RzChkGroupSer.ItemChecked[10] //Task Scheduler �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Schedule\Start', 2);

    if RzChkGroupSer.ItemChecked[11] //Indexing Service �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\CiSvc\Start', 2);

    if RzChkGroupSer.ItemChecked[12] //TCP/IP NetBIOS Helper �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\LmHosts\Start', 2);

    if RzChkGroupSer.ItemChecked[13] //Telnet �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\TlntSvr\Start', 2);

    if RzChkGroupSer.ItemChecked[14] //Windows Management Instrumentation �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\winmgmt\Start', 2);

    if RzChkGroupSer.ItemChecked[15] //Windows Time �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\W32Time\Start', 2);

    if RzChkGroupSer.ItemChecked[16] //Wireless Zero Configuration(��������) �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\WZCSVC\Start', 2);

    if RzChkGroupSer.ItemChecked[17] //NVIDIA Driver Helper �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\NVSvc\Start', 2);

    if RzChkGroupSer.ItemChecked[18] //ATi HotKey Poller �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Ati HotKey Poller\Start', 2);

    if RzChkGroupSer.ItemChecked[19] //Error Reporting �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ERSvc\Start', 2);

    if RzChkGroupSer.ItemChecked[20] //System Restore �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\srservice\Start', 2);

    if RzChkGroupSer.ItemChecked[21] //DHCP Client(�Զ�����IP��ַ) �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Dhcp\Start', 2);

    if RzChkGroupSer.ItemChecked[22] //Themes(XP���������) �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Themes\Start', 2);

    if RzChkGroupSer.ItemChecked[23] //Security Center(��ȫ����) �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wscsvc\Start', 2);

    if RzChkGroupSer.ItemChecked[24] //Windows Firewall(����ǽ) �Զ�
    then RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\SharedAccess\Start', 2);

  end;

  1: //ѡ��Ϊ�Զ�������Ϊ�ֶ�
  begin

    case RzChkGroupSer.ItemChecked[0] of //Alerter
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Alerter\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Alerter\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[1] of //Automatic Updates
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wuauserv\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wuauserv\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[2] of //Background Intelligent Transfer
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\BITS\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\BITS\Start', 3);    
    end;

    case RzChkGroupSer.ItemChecked[3] of //ClipBook
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ClipSrv\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ClipSrv\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[4] of //Distributed Link Tracking Client
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\TrkWks\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\TrkWks\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[5] of //Help and Support
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Helpsvc\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Helpsvc\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[6] of //Logical Disk Manager
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\dmserver\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\dmserver\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[7] of //Messenger
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Messenger\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Messenger\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[8] of //Remote Registry
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\RemoteRegistry\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\RemoteRegistry\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[9] of //System Event Notification
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\SENS\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\SENS\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[10] of //Task Scheduler
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Schedule\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Schedule\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[11] of //Indexing Service
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\CiSvc\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\CiSvc\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[12] of //TCP/IP NetBIOS Helper
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\LmHosts\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\LmHosts\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[13] of //Telnet
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\TlntSvr\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\TlntSvr\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[14] of //Windows Management Instrumentation
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\winmgmt\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\winmgmt\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[15] of //Windows Time
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\W32Time\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\W32Time\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[16] of //Wireless Zero Configuration(��������)
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\WZCSVC\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\WZCSVC\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[17] of //NVIDIA Driver Helper
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\NVSvc\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\NVSvc\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[18] of //ATi HotKey Poller
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Ati HotKey Poller\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Ati HotKey Poller\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[19] of //Error Reporting
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ERSvc\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\ERSvc\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[20] of //System Restore
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\srservice\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\srservice\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[21] of //DHCP Client(�Զ�����IP��ַ)
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Dhcp\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Dhcp\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[22] of //Themes(XP���������)
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Themes\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Themes\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[23] of //Security Center(��ȫ����)
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wscsvc\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\wscsvc\Start', 3);
    end;

    case RzChkGroupSer.ItemChecked[24] of //Windows Firewall(����ǽ)
      true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\SharedAccess\Start', 2);
      false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\SharedAccess\Start', 3);
    end;

  end;

  end; //endcase

  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, NiL, NiL); //ˢ��
end;

procedure TFrmMain.EditMenuDelayKeyPress(Sender: TObject; var Key: Char);
begin //�˵���ʾ��ʱֻ������������
  if not ( key in ['0'..'9',#8] ) then key:=#0
end;

procedure TFrmMain.ComBox2000XPChange(Sender: TObject);
var i:byte;
begin //2000XP ����
  case ComBox2000XP.ItemIndex of
    0: //һ�����
    begin
      for i:=0 to 4 do RzChkGroupSystem.ItemChecked[i]:=true;
      for i:=5 to 10 do RzChkGroupSystem.ItemChecked[i]:=false;
      for i:=0 to 2 do RzChkGroupHardware.ItemChecked[i]:=true;
      for i:=3 to 4 do RzChkGroupHardware.ItemChecked[i]:=false;
      for i:=0 to 7 do RzChkGroupExplorer.ItemChecked[i]:=true;
      for i:=8 to 11 do RzChkGroupExplorer.ItemChecked[i]:=false;
      for i:=0 to 2 do RzChkGroupStartMenu.ItemChecked[i]:=true;
      for i:=3 to 6 do RzChkGroupStartMenu.ItemChecked[i]:=false;
      RzChkBoxMenuDelay.Checked:=true;
    end;
    1: //�����ٶ�
    begin
      for i:=0 to 6 do RzChkGroupSystem.ItemChecked[i]:=true;
      for i:=7 to 10 do RzChkGroupSystem.ItemChecked[i]:=false;
      for i:=0 to 2 do RzChkGroupHardware.ItemChecked[i]:=true;
      for i:=3 to 4 do RzChkGroupHardware.ItemChecked[i]:=false;
      for i:=0 to 8 do RzChkGroupExplorer.ItemChecked[i]:=true;
      for i:=9 to 11 do RzChkGroupExplorer.ItemChecked[i]:=false;
      for i:=0 to 6 do RzChkGroupStartMenu.ItemChecked[i]:=false;
      RzChkBoxMenuDelay.Checked:=true;
    end;
  end; //endcase
end;

procedure TFrmMain.RzBitBtn2000XPOKClick(Sender: TObject);
begin //2000XP Ӧ��
  case RzChkGroupSystem.ItemChecked[0] of //��ʾ����ϵͳʱ��״̬��Ϣ
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\VerboseStatus', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\HideShutdownScripts', 0); //�ػ��ű�
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\HideStartupScripts', 0); //�����ű�
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\System\HideLegacyLogonScripts', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\System\HideLogoffScripts', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\System\HideLogonScripts', 0);
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\VerboseStatus', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\HideShutdownScripts', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system\HideStartupScripts', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\System\HideLegacyLogonScripts', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\System\HideLogoffScripts', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\System\HideLogonScripts', 1);
    end;
  end;

  case RzChkGroupSystem.ItemChecked[1] of //�Զ���¼���ϻָ�����̨
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole\SetCommand', 1); //��������������
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole\SecurityLevel', 1); //�Զ���¼    
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole\SetCommand', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole\SecurityLevel', 0);        
    end;
  end;

  case RzChkGroupSystem.ItemChecked[2] of //��ֹת���� Dr.Watson
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\AutoReboot', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\CrashDumpEnabled', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\LogEvent', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\Overwrite', 0);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\SendAlert', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\NumberOfCrashes', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\DumpAllThreads', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\AppendToLogFile', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\CreateCrashDump', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\VisualNotification', 1); //�Ӿ�֪ͨ
      if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug',true)
      then reg1.writestring('Auto','0');
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\AutoReboot', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\CrashDumpEnabled', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\LogEvent', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\Overwrite', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\CrashControl\SendAlert', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\NumberOfCrashes', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\DumpAllThreads', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\AppendToLogFile', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\CreateCrashDump', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\DrWatson\VisualNotification', 1); //�Ӿ�֪ͨ
      if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AeDebug',true)
      then reg1.writestring('Auto','1');    
    end;
  end;

  case RzChkGroupSystem.ItemChecked[3] of //��ֹ�ѻ��ļ�
  true:
    begin
      if reg1.OpenKey('\SOFTWARE\Policies\Microsoft\Windows\NetCache',false) then reg1.DeleteValue('Enabled'); //��������
      if reg2.OpenKey('\Software\Policies\Microsoft\Windows\NetCache',false) then reg2.DeleteValue('NoConfigCache'); //��������
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\SyncAtLogon', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\SyncAtLogoff', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\NoReminders', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\GoOfflineAction', 1);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache\Enabled', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Webcheck\NoScheduledUpdates', 1);
    end;
  false:
    begin
      if reg1.OpenKey('\SOFTWARE\Policies\Microsoft\Windows\NetCache',false) then reg1.DeleteValue('Enabled'); //��������
      if reg2.OpenKey('\Software\Policies\Microsoft\Windows\NetCache',false) then reg2.DeleteValue('NoConfigCache'); //��������
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\SyncAtLogon', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\SyncAtLogoff', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\NoReminders', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\NetCache\GoOfflineAction', 0);
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache\Enabled', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Webcheck\NoScheduledUpdates', 0); //�ѻ���Ŀ���ƻ�ͬ��    
    end;
  end;

  case RzChkGroupSystem.ItemChecked[4] of //ȥ�������Ի����ļ����Ժ�ʱ��Ĺ��
  true:
    begin
      if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system',false) then
      begin
        reg1.WriteString('LegalNoticeCaption','');  reg1.WriteString('LegalNoticeText','');
      end;
      if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Winlogon',false) then
      begin
        reg1.WriteExpandString('LegalNoticeCaption','');  reg1.WriteExpandString('LegalNoticeText','');
      end;
      if reg2.OpenKey('\Control Panel',false) then reg2.DeleteKey('International') ;
    end;
  //false:
  end;

  case RzChkGroupSystem.ItemChecked[5] of //��ֹ�����
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoActiveDesktop', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoActiveDesktopChanges', 0);
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false) then
      begin
        reg2.DeleteValue('NoActiveDesktop');  reg2.DeleteValue('NoActiveDesktopChanges');
      end;
    end;
  end;

  case RzChkGroupSystem.ItemChecked[6] of //��ֹ�Զ�����
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\CDRAutoRun', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun', 255);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Cdrom\AutoRun', 1); //��Ϊ1���Զ�ˢ�¹������
      if reg4.OpenKey('\AudioCD\Shell',false) then reg4.writestring('','');
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\CDRAutoRun', 1);
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Cdrom\AutoRun', 1); //��Ϊ1���Զ�ˢ�¹������
      //RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoDriveTypeAutoRun', 149);
      if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false)
      then reg2.DeleteValue('NoDriveTypeAutoRun') ;
      if reg4.OpenKey('\AudioCD\Shell',true) then reg4.writestring('','play');
    end;
  end;

  case RzChkGroupSystem.ItemChecked[7] of //��ֹע���༭��
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools', 1);
  false: if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\System',false) then reg2.DeleteValue('DisableRegistryTools') ;
  end;

  case RzChkGroupSystem.ItemChecked[8] of //��������������ھӺ�IEͼ��
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoInternetIcon', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoNetHood', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoEntireNetwork', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWorkgroupContents', 1);
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',true) then
      begin
        reg2.DeleteValue('NoInternetIcon');   reg2.DeleteValue('NoNetHood');
        reg2.DeleteValue('NoEntireNetwork');  reg2.DeleteValue('NoWorkgroupContents');
      end;
    end;
  end;

  case RzChkGroupSystem.ItemChecked[9] of //��ֹWin�ȼ����
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWinKeys', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWinKeys', 0);
  end;

  case RzChkGroupSystem.ItemChecked[10] of //ɾ��Msconfig.exe������
  true: if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',false) then reg1.DeleteValue('MSConfig') ;
  //false:
  end;

  case RzChkGroupHardware.ItemChecked[0] of //����ʱ�Զ���С����
  true:
    begin
      if reg2.OpenKey('\Control Panel\Keyboard',true) then reg2.writestring('InitialKeyboardIndicators','2');
      if reg3.OpenKey('\.DEFAULT\Control Panel\Keyboard',true) then reg3.writestring('InitialKeyboardIndicators','2');
    end;
  false:
    begin
      if reg2.OpenKey('\Control Panel\Keyboard',true) then reg2.writestring('InitialKeyboardIndicators','0');
      if reg3.OpenKey('\.DEFAULT\Control Panel\Keyboard',true) then reg3.writestring('InitialKeyboardIndicators','0');
    end;
  end;

  case RzChkGroupHardware.ItemChecked[1] of //�ػ�ʱ�Զ��رյ�Դ
  true:
    begin
      if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',true) then reg1.writestring('PowerdownAfterShutdown','1');
      if reg1.OpenKey('\SOFTWARE\Policies\Microsoft\Windows NT',false) then reg1.DeleteValue('DontPowerOffAfterShutdown');
    end;
  false:
    begin
      if reg1.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon',true) then reg1.writestring('PowerdownAfterShutdown','0');
      if reg1.OpenKey('\SOFTWARE\Policies\Microsoft\Windows NT',true) then reg1.writestring('DontPowerOffAfterShutdown','1');
    end;
  end;

  case RzChkGroupHardware.ItemChecked[2] of //ǿ�� FIFO���ӿ����������ٶ�
  true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Class\FDC\0000\ForceFIFO', 1);
  false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\Class\FDC\0000\ForceFIFO', 0);
  end;

  case RzChkGroupHardware.ItemChecked[3] of //��ϵͳ���棨�ڴ���256M���ϣ�
  true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache', 1);
  false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\LargeSystemCache', 0);
  end;

  case RzChkGroupHardware.ItemChecked[4] of //����48λѰַ�����õ�֧�� 137G ����Ӳ��
  true:  RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\atapi\Parameters\EnableBigLba', 1);
  false: RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Services\atapi\Parameters\EnableBigLba', 0);
  end;

  case RzChkGroupExplorer.ItemChecked[0] of //����Ҽ���ӡ����Ƶ�/�ƶ�����
  true:
    begin
      if reg4.OpenKey('\AllFilesystemObjects\shellex\ContextMenuHandlers\Copy To',true) then reg4.writestring('','{C2FBB630-2971-11d1-A18C-00C04FD75D13}');
      if reg4.OpenKey('\AllFilesystemObjects\shellex\ContextMenuHandlers\Move To',true) then reg4.writestring('','{C2FBB631-2971-11d1-A18C-00C04FD75D13}');
    end;
  false:
    begin
      if reg4.OpenKey('\AllFilesystemObjects\shellex\ContextMenuHandlers',false) then
      begin
        reg4.DeleteKey('Copy To');  reg4.DeleteKey('Move To') ;
      end
    end;
  end;

  case RzChkGroupExplorer.ItemChecked[1] of //����Ҽ���ӡ��ü��±��򿪡�
  true:  if reg4.OpenKey('\*\shell\�ü��±���(&N)\command',true) then reg4.WriteString('','"notepad.exe" "%1"');
  false: if reg4.OpenKey('\*\shell',false) then reg4.DeleteKey('�ü��±���(&N)') ;
  end;

  case RzChkGroupExplorer.ItemChecked[2] of //ȡ���˵��ʹ��ڶ���
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Control Panel\Desktop\SmoothScroll', 0);
      if reg2.OpenKey('\Control Panel\Desktop\WindowMetrics',true) then reg2.writestring('MinAnimate','0');
      if reg2.OpenKey('\Control Panel\Desktop',true) then
      begin
        Bufor[0]:=176; Bufor[1]:=18; Bufor[2]:=2; Bufor[3]:=128;
        reg2.WriteBinaryData('UserPreferencesMask',Bufor,SizeOf(Bufor));
      end;    
    end;
  false:
    begin
      if reg2.OpenKey('\Control Panel\Desktop\WindowMetrics',true) then reg2.writestring('MinAnimate','0');
      if reg2.OpenKey('\Control Panel\Desktop',true) then
      begin
        Bufor[0]:=190; Bufor[1]:=30; Bufor[2]:=2; Bufor[3]:=128;
        reg2.WriteBinaryData('UserPreferencesMask',Bufor,SizeOf(Bufor));
      end;
    end;
  end;

  case RzChkGroupExplorer.ItemChecked[3] of //ѡ�������ܱ�����ϵͳ�ļ���ʱ����ʾ
  true:  if reg1.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden',false) then reg1.DeleteValue('DefaultValue');
  false: RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden\DefaultValue', 0);
  end;

  case RzChkGroupExplorer.ItemChecked[4] of //����ʾ��ݷ�ʽ�ϡ���ݷ�ʽ����������
  true:
    begin
      if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer',false) then
      begin
        Bufor[0]:=0; Bufor[1]:=0; Bufor[2]:=0; Bufor[3]:=0;
        reg2.WriteBinaryData('link',Bufor,SizeOf(Bufor));
      end;    
    end;
  false:
    begin
      if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer',false) then
      begin
        Bufor[0]:=17; Bufor[1]:=0; Bufor[2]:=0; Bufor[3]:=0;
        reg2.WriteBinaryData('link',Bufor,SizeOf(Bufor));
      end;
    end;
  end;

  case RzChkGroupExplorer.ItemChecked[5] of //��Դ�������Զ�ˢ�£��Զ����������ļ�
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Update\UpdateMode', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\SearchHidden', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\SearchSystemDirs', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\IncludeSubFolders', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\CaseSensitive', 0); //���ִ�Сд
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\SearchSlowFiles', 0); //�����Ŵ�
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SYSTEM\CurrentControlSet\Control\Update\UpdateMode', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\SearchHidden', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\SearchSystemDirs', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\IncludeSubFolders', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\CaseSensitive', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\SearchSlowFiles', 0);
    end;
  end;

  case RzChkGroupExplorer.ItemChecked[6] of //�Զ�������Դ������
  true:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell', 1);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell', 1);
    end;
  false:
    begin
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell', 0);
      RegSetDword(Reg2.RootKey, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoRestartShell', 0);
    end;
  end;

  case RzChkGroupExplorer.ItemChecked[7] of //Ϊÿ�����򴴽������Ľ���
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\DesktopProcess', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\DesktopProcess', 0);
  end;

  case RzChkGroupExplorer.ItemChecked[8] of //��ֹ���̿ռ䲻�㾯��
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoLowDiskSpaceChecks', 1);
  false: if reg2.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',false) then reg2.DeleteValue('NoLowDiskSpaceChecks') ;
  end;

  case RzChkGroupExplorer.ItemChecked[9] of //��ʾϵͳ�ļ��������ļ�
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSuperHidden', 1);
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Hidden', 2);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ShowSuperHidden', 0);
    end;
  end;

  case RzChkGroupExplorer.ItemChecked[10] of //ʹ����Դ��������"�ҵĵ���"
  true:  if reg4.OpenKey('\Folder\shell',false) then reg4.WriteString('','explore');
  false: if reg4.OpenKey('\Folder\shell',false) then reg4.WriteString('','open');
  end;

  case RzChkGroupExplorer.ItemChecked[11] of //����ʾ��ݷ�ʽ�ϵļ�ͷ
  true:
    begin
      if reg4.OpenKey('\InternetShortcut',false) then reg4.DeleteValue('IsShortcut') ;
      if reg4.OpenKey('\lnkfile',false) then reg4.DeleteValue('IsShortcut') ;
      if reg4.OpenKey('\piffile',false) then reg4.DeleteValue('IsShortcut') ;
    end;
  false:
    begin
      if reg4.OpenKey('\InternetShortcut',true) then reg4.WriteString('IsShortcut','1');
      if reg4.OpenKey('\lnkfile',true) then reg4.WriteString('IsShortcut','1');
      if reg4.OpenKey('\piffile',true) then reg4.WriteString('IsShortcut','1');
    end;
  end;

  case RzChkGroupStartMenu.ItemChecked[0] of //��ʾ������ĵ��ļ�¼
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoInstrumentation', 0); //�����û�����
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer\NoInstrumentation', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRecentDocsHistory', 0);
      RegSetDword(Reg1.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRecentDocsHistory', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ClearRecentDocsOnExit', 0);
      RegSetDword(Reg1.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ClearRecentDocsOnExit', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Start_ShowRecentDocs', 2);
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRecentDocsHistory', 1);
      RegSetDword(Reg1.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoRecentDocsHistory', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ClearRecentDocsOnExit', 1);
      RegSetDword(Reg1.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\ClearRecentDocsOnExit', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Start_ShowRecentDocs', 1);
    end;
  end;

  case RzChkGroupStartMenu.ItemChecked[1] of //���ø��Ի��˵�
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Intellimenus', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\IntelliMenus', 1);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoInstrumentation', 0); //�����û�����
      RegSetDword(Reg1.RootKey, 'SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer\NoInstrumentation', 0);
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Intellimenus', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\IntelliMenus', 0);
    end;
  end;

  case RzChkGroupStartMenu.ItemChecked[2] of //��ʾ������ʾ
  true:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\EnableBalloonTips', 1); //����ʼ�˵���������ʾ
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\BalloonTips', 1); //ϵͳ��������ʾ
    end;
  false:
    begin
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\EnableBalloonTips', 0);
      RegSetDword(Reg2.RootKey, 'Software\Microsoft\Search Assistant\BalloonTips', 0);
    end;
  end;

  case RzChkGroupStartMenu.ItemChecked[3] of //��������ĳ����б�
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoStartMenuMFUprogramsList', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoStartMenuMFUprogramsList', 0);
  end;

  case RzChkGroupStartMenu.ItemChecked[4] of //���ء����г���
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoStartMenuMorePrograms', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoStartMenuMorePrograms', 0);
  end;

  case RzChkGroupStartMenu.ItemChecked[5] of //���ظ��ӵĳ����б�
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoStartMenuPinnedList', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoStartMenuPinnedList', 0);
  end;

  case RzChkGroupStartMenu.ItemChecked[6] of //���������û���
  true:  RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoUserNameInStartMenu', 1);
  false: RegSetDword(Reg2.RootKey, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoUserNameInStartMenu', 0);
  end;

  if RzChkBoxMenuDelay.Checked and reg2.OpenKey('\Control Panel\Desktop',true) //�˵���ʾ��ʱ
  then reg2.writestring('MenuShowDelay',EditMenuDelay.Text);

  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, NiL, NiL); //ˢ��
end;

procedure TFrmMain.EditMenuDelayEnter(Sender: TObject);
begin //������༭��ʱ��ɫ
  TLabeledEdit(sender).Color:=$008EFFFF
end;

procedure TFrmMain.EditMenuDelayExit(Sender: TObject);
begin //����˳��༭��ʱ�ָ���ɫ
  TLabeledEdit(sender).Color:=clWhite
end;

procedure TFrmMain.tmr1Timer(Sender: TObject);
begin
   //�������ˮ���ƣ���һ��Random�����е�ֵԽС(>1)��ˮ���Ƴ��ֵ�Ƶ��Խ��
  if Random(12)= 1 then Water.Blob(-1,-1,Random(1)+1,Random(500)+50);

  Water.Render(Bmp,img1.Picture.Bitmap);
  img1.Repaint;
  //Application.ProcessMessages;
end;

procedure TFrmMain.img1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin //ˮ����Ч��������
  Water.Blob(x,y,2,100);
end;

procedure TFrmMain.Tab7AboutExit(Sender: TObject);
begin //�˳������ڡ���ǩʱ��ֹtmr1���Լ���CPUռ����
  tmr1.Enabled:=False;
end;

procedure TFrmMain.img1Click(Sender: TObject);
begin //������־ͼƬʱ����tmr1
  tmr1.Enabled:=True;
end;

end.

