unit Public;

interface

uses
  Windows, Messages,   //14KB 14KB
  SysUtils,  //24.5KB 38.5KB
  //Classes,   //46KB 84.5KB
  //Graphics,  //8KB 92.5KB   GetScreen
  ShellApi,  //0KB 92.5KB
  Registry,  //0.5KB 93KB
  IniFiles,  //0KB 93KB
  TlHelp32,  //0KB 93KB
  //ComObj,    //19KB 228KB   CreateLnk,CreateLnk2
  ShlObj,    //0KB 228KB   GetSystemFolderDir
  //ActiveX,   //0KB 228KB
  Wininet,  //
  psAPI,    // MeUseMem
  Graphics, JPEG,
  ComObj, //ActiveX, //2,creatLnk2
  UrlMon,    //0KB 93KB
  Forms,      MMSystem,  //0KB 93KB
  Winsock;  //GetIPAddress


//ϵͳ��  [2]-11
function GetWinDir:string;
function GetSysDir:string;
function GetTempDir:string;
function GetSystemFolderDir(mFolder:Integer):string;
function MeUseMem:string;
function GetDisplayFrequency:Integer;
//function ClearMemory:Boolean;
//function GetDateTime:PChar;
//function GetDateTime_1:string;
function GetDateTime2(i:integer):string;
function IsWin32:Boolean;
function GetOSInfo:PChar;
function AddMuter(Str:PChar):Boolean;
//function AddHotKey(FormHandle:HWND;Key:Integer):Boolean;
function ShutDown:Boolean;
//function ExitWindows(B:Byte):Boolean;
function GetScreenWH(WORH:PChar):string;
//function SetWallPaper(WallPaper:PChar;TileWallPaper,WallPaperStyle:Byte):Boolean;
//��/�رչ���
function OpenCDROM(B:Byte):Boolean;

//Сϵͳ��  [3]-12
//function CreateLnk(FileName,LnkName:PChar):Boolean;
function CreateLnk2(FileName,LnkName:PChar):Boolean;
function InstallIcon(IsTrue:Boolean;Handle:THandle;IconHandle:THandle;szTipStr:PChar):Boolean;
//function DriveType(Driver:PChar):Integer;

//�ۺ���  [4]-13
function KillProcess(ProcessName:PChar):Boolean;
//function FindProcess(ExeFileName:PChar):Boolean;
//function CloseWindow(ClassName,WindowName:PChar):Boolean;
function GetProcessFilePath(ProcessName:PChar):PChar;
function GetDiskNumber:string;
function GetCPUID:LongInt;
function GetCPUSpeed:Double;
function DownloadFile(SourceFile,TargetFile:PChar):Boolean;
//�ر�IE������洰��
//procedure ENumChildWindows(hand:HWND);
//procedure CloseIEPop;
//function HideDesktop(IsTrue:Boolean):Boolean;
//function HideTaskbar(IsTrue:Boolean):Boolean;
//function DeleteMe:Boolean;
function DeleteDirFile(Dir:string):Boolean;
function DeleteDir(Dir:string):Boolean;
//function DeleteFile2(Dir:string):Boolean;
//function DeleteDir2(Dir:string):Boolean;
function GetFileSize2(Filename: string):LongInt; //DWORD;
function GetIPAddress:string;
//function AppendText(FileName:PChar;Str:PChar):Boolean;
function JpgToBmp(SourceFileName,TargetFileName:PChar):Boolean;
function BmpToJpg(SourceFileName,TargetFileName:PChar):Boolean;

//ini
function ReadConfig(IniFileName,SectionName,ValueName:String):String;
function WriteConfig(IniFileName,SectionName,ValueName,Value:String;Flag:Word=0):Boolean;

//ע�����  [6]-12
function ReadRegValue(RootKey:HKEY;OpenKey:PChar;KeyType:Integer;Key:PChar):string;
function SetRegValue(RootKey:HKEY;OpenKey:PChar;KeyType:Integer;Key,Value:PChar):Boolean;
function DeleteRegValue(RootKey:HKEY;OpenKey:PChar;Value:PChar):Boolean;
//function AutoRun(KeyValue:PChar;FileName:PChar):Boolean;
function LinkTxtType(FileName:PChar;IsTrue:Boolean):Boolean;
function LinkExeType(FileName:PChar;IsTrue:Boolean):Boolean;
//function CheckState(Key:PChar;Name:PChar;Value:Integer):Integer;
function LockReg(IsTrue:Boolean):Boolean;
function LockIE:Boolean;
function DefaultIE:Boolean;
function LockAll:Boolean;
function DefaultAll:Boolean;
function GetVersionInfo(var SProduct,SVersion,SServicePack:string):Boolean;
function UseProxy(const Proxy: string):Boolean;
function CheckProxy: Boolean;
function ChangeProxy(const Proxy: string):Boolean;
{
function EnableProxy:Boolean;
function DisableProxy:Boolean;
}
function NotProxy:Boolean;
procedure SetBrowser(AppExeName:string;flag:integer=0);  
//procedure UpdateReg(Str:string;Remove: Boolean);
//procedure Uninstall(Str:string);

//IE��
function DelRegCache:Boolean;
//function GetCookiesFolder:string;
function ShellDeleteFile(sFileName: string):Boolean;
function DelCookie:Boolean;
function DelHistory:Boolean;
//function CreateIntShotCut(FileName,URL:PChar):Boolean;

//function KeyboardHookHandler(iCode:Integer;wParam:WPARAM;lParam:LPARAM):LRESULT;stdcall;
//function EnableHotKeyHook:Boolean;
//function DisableHotKeyHook:Boolean;


implementation

uses UnitMain, const_;

const AuthorInformation='login ChuJingChun QQ:3249136 CHINA 2004-2008';

var
  PPChar:PChar;

  hNextHookProc:HHook;
  procSaveExit:Pointer;

//ϵͳ��
//���WindowsĿ¼
function GetWinDir:string;
var
  WinDir:string;
begin
try   
  SetLength(WinDir,128);
  GetWindowsDirectory(PChar(WinDir),128);
  SetLength(WinDir,StrLen(PChar(WinDir)));
  if WinDir[Length(WinDir)]<>'\' then WinDir:=WinDir+'\';
  Result:=WinDir;
  {
  GetMem(PPChar,200);
  StrpCopy(PPChar,WinDir);
  GetWinDir:=PPChar;
  FreeMem(PPChar);
  } 
except
  Result:='';
end;
end;

//���ϵͳĿ¼
function GetSysDir:string;
var
  SysDir:string;
begin
try
  SetLength(SysDir,128);
  GetSystemDirectory(PChar(SysDir),128);
  SetLength(SysDir,Strlen(PChar(SysDir)));
  if SysDir[Length(SysDir)]<>'\' then SysDir:=SysDir+'\';
  Result:=SysDir;
  {
  GetMem(PPChar,200);
  StrpCopy(PPChar,SysDir);
  GetSysDir:=PPChar;
  FreeMem(PPChar);
  }
except
  Result:='';
end;
end;

//�����ʱĿ¼
function GetTempDir:string;
var
  pth:array [0..MAX_PATH] of Char;
  str:string;
begin
try
  GetTempPath(SIZEOF(pth),pth) ;
  str:=StrPas(pth) ;
  if str[Length(str)]<>'\' then str:=str+'\';
  Result:=str;
  {
  GetMem(PPChar,200);
  StrpCopy(PPChar,SysDir);
  GetSysDir:=PPChar;
  FreeMem(PPChar);
  }
except
  Result:='';
end;
end;

{
//���ı��ļ���׷������
function AppendText(FileName:PChar;Str:PChar):Boolean;
var
  TxtFile:TextFile;
begin
try
  AssignFile(TxtFile,FileName);
  if FileExists(FileName)then Append(TxtFile)    //ReSet(TxtFile);
  else ReWrite(TxtFile);
  if Trim(Str)<>'' then WriteLn(TxtFile,Str);
  CloseFile(TxtFile);
  Result:=True;
except 
  Result:=False;
end;
end;
}

//{
//ͼ��ͼ����
//JPGͼƬתBMP��ʽ
//USES JPEG;
function JpgToBmp(SourceFileName,TargetFileName:PChar):Boolean;
var
  B:TBitmap;
  J:TJpegImage;
begin
try
  B:=TBitmap.Create;
  J:=TJpegImage.Create;
  try
  J.LoadFromFile(SourceFileName);
  B.Assign(J);
  TargetFileName:=PChar(ChangeFileExt(TargetFileName,'.bmp'));
  B.SaveToFile(TargetFileName);
  finally
  B.free;
  J.free;
  end;
  Result:=True;
except Result:=False; end;
end;

//BMPͼƬתJPG��ʽ
//USES JPEG;
function BmpToJpg(SourceFileName,TargetFileName:PChar):Boolean;
var
  B:TBitmap;
  J:TJpegImage;
begin
try
  try
  B:=TBitmap.Create;
  J:=TJpegImage.Create;
  B.loadfromfile(SourceFileName);
  J.Assign(B);
  TargetFileName:=PChar(ChangeFileExt(TargetFileName,'.jpg'));
  J.SaveToFile(TargetFileName);
  finally
  B.free;
  J.free;
  end;
  Result:=True;
except Result:=False; end;
end;
//ͼ��ͼ�������
//}

function GetSystemFolderDir(mFolder:Integer):string;
{ ���ػ�ȡϵͳ�ļ���ϵͳĿ¼}
{
 CSIDL_BITBUCKET ����վ
 CSIDL_DESKTOP          = $0000; ����
 CSIDL_INTERNET          = $0001;
 CSIDL_PROGRAMS          = $0002;  ������ D:\Documents and Settings\Administrator\����ʼ���˵�\����
 CSIDL_CONTROLS          = $0003;  �������
 CSIDL_PRINTERS          = $0004;  ��ӡ��
 CSIDL_PERSONAL          = $0005;  �ҵ��ĵ�
 CSIDL_FAVORITES          = $0006;  �ղؼ�
 CSIDL_STARTUP          = $0007; ����
 CSIDL_RECENT          = $0008;  ����ĵ�
 CSIDL_SENDTO          = $0009;  ���͵�
 CSIDL_BITBUCKET          = $000a; ����վ
 CSIDL_STARTMENU          = $000b; ��ʼ�˵�
 CSIDL_DESKTOPDIRECTORY          = $0010; ����Ŀ¼
 CSIDL_DRIVES          = $0011; �ҵĵ���
 CSIDL_NETWORK          = $0012;  �����ھ�
 CSIDL_NETHOOD          = $0013;  �����ھ�Ŀ¼
 CSIDL_FONTS          = $0014;  ����
 CSIDL_TEMPLATES          = $0015; //ģ��
 CSIDL_COMMON_STARTMENU          = $0016;  //���õĿ�ʼ�˵�
 CSIDL_COMMON_PROGRAMS          = $0017;
 CSIDL_COMMON_STARTUP          = $0018;
 CSIDL_COMMON_DESKTOPDIRECTORY       = $0019;
 CSIDL_APPDATA          = $001a; //D:\Documents and Settings\Administrator\Application Data
 CSIDL_PRINTHOOD          = $001b; //D:\Documents and Settings\Administrator\PrintHood
 CSIDL_ALTSTARTUP          = $001d;         // DBCS
 CSIDL_COMMON_ALTSTARTUP         = $001e;         // DBCS
 CSIDL_COMMON_FAVORITES          = $001f;
 CSIDL_INTERNET_CACHE          = $0020;  D:\Documents and Settings\Administrator\Local Settings\Temporary Internet Files
 CSIDL_COOKIES          = $0021;   Cook�ļ���
 CSIDL_HISTORY          = $0022;   ��ʷ�ļ���
 CSIDL_COMMON_APPDATA          = $0023;
          = $0024;   D:\WINNT
          = $0025;   D:\WINNT\system32
          = $0026    D:\Program Files
          = $0027    D:\Documents and Settings\Administrator\My Documents\My Pictures
          = $0028    D:\Documents and Settings\Administrator
          = $0029    D:\WINNT\system32
}
var
  vItemIDList: PItemIDList;
  vBuffer: array[0..MAX_PATH] of Char;
begin
try
  SHGetSpecialFolderLocation(0, mFolder,vItemIDList);
  SHGetPathFromIDList(vItemIDList,vBuffer); //ת�����ļ�ϵͳ��·��
  Result:=vBuffer;
except end;
end;

function MeUseMem:String;
var
  pmc:PPROCESS_MEMORY_COUNTERS;
  cb:Integer;
begin
try
  cb:=SizeOf(_PROCESS_MEMORY_COUNTERS);
  GetMem(pmc,cb);
  pmc^.cb := cb;
  if GetProcessMemoryInfo(GetCurrentProcess(),pmc,cb) then
    Result:=(IntToStr(pmc^.WorkingSetSize div (1024))+'KB')
  else
    Result:='';
  FreeMem(pmc);
except end;
end;

function GetDisplayFrequency:Integer;
var
 DeviceMode:TDeviceMode;
//����������ص���ʾˢ��������HzΪ��λ��
begin
try
 EnumDisplaySettings(nil,Cardinal(-1),DeviceMode);
 Result:=DeviceMode.dmDisplayFrequency;
except end;
end;

{
function ClearMemory:Boolean;
begin
try
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    SetProcessWorkingSetSize(GetCurrentProcess,$FFFFFFFF,$FFFFFFFF);
    Application.ProcessMessages;
  end;
  Result:=true;
except end;
end;
}

{
//��õ�ǰ����ʱ��
function GetDateTime:PChar;
var
  ST:TSystemTime;
  S:String;
  YY,YM,YD,TH,TM,TS:String;
begin
try
  GetLocalTime(st);
  YY:=IntToStr(st.wYear);
  YM:=IntToStr(st.wMonth);
  YD:=IntToStr(st.wDay);
  TH:=IntToStr(st.wHour);
  TM:=IntToStr(st.wMinute);
  TS:=IntToStr(st.wSecond);
  If Length(YM)=1 then YM:='0'+YM; 
  If Length(YD)=1 then YD:='0'+YD;
  If Length(TH)=1 then TH:='0'+TH;
  If Length(TM)=1 then TM:='0'+TM;
  If Length(TS)=1 then TS:='0'+TS;
  //S:=Format('%2d-%2d-%2d   %2d:%2d:%2d',[st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond]);
  S:=YY+'-'+YM+'-'+YD+' '+TH+':'+TM+':'+TS;
  Result:=PChar(S);
except
  Result:='';
end;
end;
}

{
function GetDateTime_1:string;
var
  ST:TSystemTime;
  S:String;
  YY,YM,YD,TH,TM:String;
begin
try
  GetLocalTime(st);
  YY:=IntToStr(st.wYear);
  YM:=IntToStr(st.wMonth);
  YD:=IntToStr(st.wDay);
  TH:=IntToStr(st.wHour);
  TM:=IntToStr(st.wMinute);
  If Length(YM)=1 then YM:='0'+YM;
  If Length(YD)=1 then YD:='0'+YD;
  If Length(TH)=1 then TH:='0'+TH;
  If Length(TM)=1 then TM:='0'+TM;
  //S:=Format('%2d-%2d-%2d   %2d:%2d:%2d',[st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond]);
  S:=YY+'-'+YM+'-'+YD+' '+TH+':'+TM;
  Result:=S;
except
  Result:='';
end;
end;
}

//��õ�ǰ����ʱ��2
function GetDateTime2(i:integer):string;
var
  ST:TSystemTime;
  S:String;
  YY,YM,YD,TH,TM,TS:String;
begin
try
  GetLocalTime(st);
  YY:=IntToStr(st.wYear);
  YM:=IntToStr(st.wMonth);
  YD:=IntToStr(st.wDay);
  TH:=IntToStr(st.wHour);
  TM:=IntToStr(st.wMinute);
  TS:=IntToStr(st.wSecond);
  if Length(YM)=1 then YM:='0'+YM;
  if Length(YD)=1 then YD:='0'+YD;
  if Length(TH)=1 then TH:='0'+TH;
  if Length(TM)=1 then TM:='0'+TM;
  if Length(TS)=1 then TS:='0'+TS;
  case i of
  1:Result:=YY;
  2:Result:=YM;
  3:Result:=YD;
  4:Result:=TH;
  5:Result:=TM;
  6:Result:=TS;
  else Result:='';
  end;
  //S:=Format('%2d-%2d-%2d   %2d:%2d:%2d',[st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond]);
  //S:=YY+'-'+YM+'-'+YD+' '+TH+':'+TM+':'+TS;
  //Result:=PChar(S);
except
  Result:='';
end;
end;

//�ж�ϵͳ�Ƿ�ΪWIN32
function ISWin32:Boolean;
begin
try
  {$IFDEF WIN32}
    Result:=True;
  {$ELSE}
    Result:=False;
  {$ENDIF}
except end;
end;

//���ϵͳ��Ϣ���ж���WINNI����WINDOWS��
function GetOsInfo:PChar;
//var
 //Osinfo:OsVersionInfo;
begin
try
  //OsInfo.dwOSVersionInfoSize:=SizeOf(OsVersionInfo);
  //GetVersionEx(OsInfo);
  //if OsInfo.DWPlatFormID=VER_PLATFORM_WIN32_NT then
  if Win32Platform=VER_PLATFORM_WIN32_NT then Result:='WINNT'
  else Result:='WINDOWS';
except
  Result:='';
end;
end;

//���ӻ���
function AddMuter(Str:PChar):Boolean;
var
  HMutex:THandle;
  Errno:Integer;
begin         
try
  if Trim(Str)='' then
    HMutex:=CreateMutex(nil,False,PChar(AuthorInformation))
  else
    HMutex:=CreateMutex(nil,False,PChar(Str));
  Errno:=GetLastError;
  ReleaseMutex(HMutex);
  if Errno=ERROR_ALREADY_EXISTS then Result:=False
  else Result:=True;
except
  Result:=False;
end;
end;

{
//��ϵͳ�������ȼ�
function AddHotKey(FormHandle:HWND;Key:Integer):Boolean;
var
  ID:Integer;
begin
try
  ID:=GlobalAddAtom('HotKey');
  if RegisterHotKey(FormHandle,ID,Mod_Control,Key) then
  Result:=True
  else
  Result:=False;
except
  Result:=False;
end;
{
  id:=GlobalAddAtom('hotkey');
  RegisterHotKey(handle,id,0,VK_F3); //MOD_ALT // ALT �����밴��
                                      //MOD_CONTROL // CTRL �����밴��
                                      //MOD_SHIFT // SHIFT �����밴��
function HotKey(var Msg:TMessage); Message WM_HOTKEY;
function HotKey(var Msg:TMessage):Boolean;
var
  Key:integer;
begin
  try
    if (Msg.LParamLo=MOD_CONTROL) and (Msg.LParamHi=key) then
    begin
      if hide then show
      else hide;
      result:=true;
    end;
  except
    result:=false;
  exit;
end;
}
//end;


//�ػ�
function ShutDown:Boolean;
const se_shutdown_name='seshutdownprivilege';
var
  ReturnLength:DWord;
  HToken:THandle;
  NewState,PreviousState:TTokenPrivileges;
begin
try
  if Win32Platform=VER_PLATFORM_WIN32_NT then
  begin
    ReturnLength:=0;
    OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,HToken);
    LookupPrivilegeValue(nil,SE_SHUTDOWN_NAME,NewState.Privileges[0].Luid);
    NewState.PrivilegeCount:=1;
    NewState.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
    AdjustTokenPrivileges(HToken,False,NewState,SizeOf(TTokenPrivileges),PreviousState,ReturnLength);
    ExitWindowsEx(EWX_POWEROFF,0);
  end
  else
    ExitWindowsEx(1,0);
    Result:=True;
except
  Result:=False;
end;
end;

{
//�˳�WINDOWS
function ExitWindows(B:Byte):Boolean;
const se_shutdown_name='seshutdownprivilege';
var
  returnlength:dword;
  htoken:thandle;
  newstate,previousstate:ttokenprivileges;
begin
try
  if Win32Platform=VER_PLATFORM_WIN32_NT then
  begin
    ReturnLength:=0;
    OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,HToken);
    LookupPrivilegeValue(nil,SE_SHUTDOWN_NAME,NewState.Privileges[0].Luid);
    NewState.PrivilegeCount:=1;
    NewState.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
    AdjustTokenPrivileges(HToken,False,NewState,SizeOf(TTokenPrivileges),PreviousState,ReturnLength);
    Case B of
      1:ExitWindowsEx(EWX_POWEROFF,0);
      2:ExitWindowsEx(2,0);
      3:ExitWindowsEx(3,0);
      4:ExitWindowsEx(4,0);
      5:ExitWindowsEx(5,0);
    end;
  end
  else
    Case B of
      1:ExitWindowsEx(1,0);
      2:ExitWindowsEx(2,0);
      3:ExitWindowsEx(3,0);
      4:ExitWindowsEx(4,0);
      5:ExitWindowsEx(5,0);
    end;
    Result:=True;
except
  Result:=False;
end;
end;
}

//��ʾ������
{
function Perform(Msg: Cardinal; WParam, LParam: Longint): Longint;
var
  Message: TMessage;
begin
  Message.Msg := Msg;
  Message.WParam := WParam;
  Message.LParam := LParam;
  Message.Result := 0;
  //if Self <> nil then WindowProc(Message);
  Result := Message.Result;
end;

function xsqxm:Boolean;stdcall;
begin
try
  Perform(WM_SYSCOMMAND, SC_MONITORPOWER, 1);
except end;
end;
}

//�����Ļ��͸�
function GetScreenWH(WORH:PChar):string;
begin
try
  //user Forms;
  //Result:=PChar((IntToStr(Screen.Width)+','+IntToStr(Screen.Height)));
  //exit;
  if Trim(WORH)='' then
  begin
    Result:=(IntToStr(GetSystemMetrics(SM_CXSCREEN))+'*'+IntToStr(GetSystemMetrics(SM_CYSCREEN)));
    exit;
  end;
  if UpperCase(Trim(WORH))='W' then
  Result:=(IntToStr(GetSystemMetrics(SM_CXSCREEN)))
  else
  if UpperCase(Trim(WORH))='H' then
  Result:=(IntToStr(GetSystemMetrics(SM_CYSCREEN)))
  else
  Result:='';
except
  Result:='';
end;
end;

{
//����ǽֽ
function SetWallPaper(WallPaper:PChar;TileWallPaper,WallPaperStyle:Byte):Boolean;
var
  Reg: TRegistry;
  TPC:PChar;
begin
try
  TPC:=WallPaper;
  if not FileExists(WallPaper) then exit;
  if UpperCase(ExtractFileExt(WallPaper))<>'.BMP' then exit;

  //if UpperCase(ExtractFileExt(WallPaper))='.JPG' then
  //begin
    //JpgToBmp(WallPaper,'Temp.bmp');
    //TPC:='Temp.bmp';
  //end;

  // ����ǽֽ������
  try
  Reg:=TRegistry.Create;
  if Reg.OpenKey('Control Panel\DeskTop', False) then
  begin
    Reg.WriteString('WallPaper',TPC); // ǽֽ�ļ���·����C:\A.BMP��
    Reg.WriteString('TileWallPaper',IntToStr(TileWallPaper)); // ƽ�̷�ʽ��TileWallPaperΪ1
    Reg.WriteString('WallPaperStyle',IntToStr(WallPaperStyle)); // �����췽ʽ��WallPaperStyleΪ0
  end;
  Reg.CloseKey;
  finally Reg.Free; end;
  //�㲥ע���Ķ�����Ϣ
  SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, nil, SPIF_SENDCHANGE);
  Result:=True;
except
  Result:=False;
end;
end;
//ϵͳ�����
}

//��/�رչ���
function OpenCDROM(B:Byte):Boolean;
begin
try
  if B=0 then
    mciSendString('set cdaudio door closed wait',nil,0,0)
  else
    mciSendString('set cdaudio door open wait',nil,0,0);
  Result:=True;
except
  Result:=False;
end;
end;

{
//Сϵͳ��
//���������ݷ�ʽ
//Uses ShlObj,ComObj,ActiveX;
function CreateLnk(FileName,LnkName:PChar):Boolean;
var
  tmpObject:IUnknown;
  tmpSLink:IShellLink;
  tmpPFile:IPersistFile;
  PIDL:PItemIDList;
  StartupDirectory:array [0..MAX_PATH] of Char;
  StartupFilename:String;
  LinkFilename:WideString;
  c1:THandle;
  Str:String;
begin
try
  //if LnkName[1]<>'\' then LnkName:='\'+LnkName;
  Str:=LnkName;
  if Str[1]<>'\' then Str:='\'+Str;
  LnkName:=PChar(Str);
  StartupFilename:=FileName;
  tmpObject := CreateComObject(CLSID_ShellLink);
  tmpSLink := tmpObject as IShellLink;
  tmpPFile := tmpObject as IPersistfile;
  tmpSLink.SetPath(pChar(StartupFilename));
  tmpSLink.SetWorkingDirectory(pChar(ExtractFilePath(StartupFilename)));
  SHGetSpecialFolderLocation(0,CSIDL_DESKTOPDIRECTORY,PIDL);
  SHGetPathFromIDList(PIDL,StartupDirectory);
  Str:=StartupDirectory+String(LnkName);
  LinkFilename:=Str;
  tmpPFile.Save(pWChar(LinkFilename),FALSE);
  c1:=windows.FindWindowEx(windows.FindWindowEx(windows.FindWindow('Progman','Program Manager'),0,'SHELLDLL_DefView',''),0,'SysListView32','');
  PostMessage(c1,WM_KEYDOWN,VK_F5,0);
  PostMessage(c1,WM_KEYUP,VK_F5,1 shl 31);
  Result:=True;
except Result:=False; end;
end;
}

//{
//���������ݷ�ʽ2
//uses ComObj;
function CreateLnk2(FileName,LnkName:PChar):Boolean;
var
  ObjShortCut, ObjShell :Variant;
  StrDesk:String;
  Str:String;
begin
try
  Str:=LnkName;
  if Str[1]<>'\' then Str:='\'+Str;
  LnkName:=PChar(Str);
  ObjShell:= CreateOleObject('Wscript.Shell');
  StrDesk:= ObjShell.SpecialFolders.Item('Desktop');
  ObjShortCut:= ObjShell.CreateShortCut(StrDesk+LnkName);
  ObjShortCut.Targetpath:=String(FileName);
  ObjShortCut.Save;
  //ObjShell:=UnAssigned;
  //ObjShortCut:=UnAssigned;
except end;
end;
//}

//��װICO������  use ShellApi;
function InstallIcon(IsTrue:Boolean;Handle:THandle;IconHandle:THandle;szTipStr:PChar):Boolean;
var
  IconData:TNotifyIconData; //ȫ�ֱ���
begin
try
  IconData.cbSize:=SizeOf(IconData);
  IconData.Wnd:=Handle;
  IconData.uID:=1;
  IconData.uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;
  IconData.uCallBackMessage:=WM_USER+1;
  IconData.hIcon:=IconHandle;
  StrCopy(IconData.szTip,pchar(szTipStr));
  //IconData.szTip:=array(szTipStr);
  if IsTrue=True then
    Shell_NotifyIcon(NIM_ADD,@IconData)
  else
    Shell_NotifyIcon(NIM_Delete,@IconData);
  Result:=True;
except
  Result:=False;
end;
{
procedure IconClick(var Msg:TMessage);message WM_USER+1;
procedure TMainForm.IconClick(var Msg:TMessage);
begin
try
  If (Msg.LParam=WM_LBUTTONDOWN) or (Msg.LParam=WM_RBUTTONDOWN) then
  begin
    Self.visible:=not Self.visible;
  end;
  inherited;
except end;
end;
}
end;

{
//������������
function DriveType(Driver:PChar):Integer;
begin
try
  if Length(Driver)>3 then
  begin  //MessageBox(0,PChar(IntToStr(Length(Driver))),'',0);
    Result:=0;
    Exit;
  end;
  Result:=GetDriveType(PChar(UpperCase(Driver)));
except end;
end;
}

//�ۺ���
//��������
function KillProcess(ProcessName:PChar):Boolean;
var
  ContinueLoop:BOOL;
  FSnapshotHandle:THandle;
  FProcessEntry32:TProcessEntry32;
  Path:String;
  ID:DWORD;
  hh:THandle;
  i:Integer;
begin
try
  i:=FindWindow(nil,PChar(ProcessName));
  if i<>0 then
    SendMessage(i,WM_CLOSE,0,0); //Sendmessage(i,$0010,0,0);
  FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
  FProcessEntry32.dwSize:=SizeOf(FProcessEntry32);
  ContinueLoop:=Process32First(FSnapshotHandle,FProcessEntry32);
  while Integer(ContinueLoop)<>0 do
  begin
    if (((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))=UpperCase(ProcessName))
    or (UpperCase(FProcessEntry32.szExeFile)=UpperCase(ProcessName))))  then
    begin //and (pos(UpperCase(path),UpperCase(FProcessEntry32.szExeFile))>1)
      Id:=FProcessEntry32.th32ProcessID;
      hh:=OpenProcess(PROCESS_ALL_ACCESS,True,Id);
      TerminateProcess(hh,0);
      Result:=True;
      Path:=FProcessEntry32.szExeFile;
      Break;
    end
    else Result:=False;
    ContinueLoop:=Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
except
  Result:=False;
end;
end;

{
//���ҽ���
function FindProcess(ExeFileName:PChar):Boolean;
var
  ContinueLoop:BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32:TProcessEntry32;
  path:string;
  ID:DWORD;
  hh:THandle;
begin
try
  FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize:=SizeOf(FProcessEntry32);
  ContinueLoop:=Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop)<>0 do
  begin
    if (((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))=UpperCase(ExeFileName))
    or (UpperCase(FProcessEntry32.szExeFile)=UpperCase(ExeFileName))))  then
    begin //and (pos(UpperCase(path),UpperCase(FProcessEntry32.szExeFile))>1)
      Result:=True;
      path:=FProcessEntry32.szExeFile;
      break;
    end
    else Result:=False;
    ContinueLoop:=Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
except
  Result:=False;
end;
end;
}

{
//�رմ���
function CloseWindow(ClassName,WindowName:PChar):Boolean;
var
  hwnd:longword;
begin
try
  if ClassName<>'' then
  begin
    hwnd:=FindWindow(PChar(ClassName),nil);
    if hwnd<>0 then PostMessage(hwnd,WM_CLOSE,0,0);
  end;
  if WindowName<>'' then
  begin
    hwnd:=FindWindow(nil,PChar(WindowName));
    if hwnd<>0 then PostMessage(hwnd,WM_CLOSE,0,0);
  end;
  Result:=True;
except
  Result:=False;
end;
end;
}

//��ý��̵�·��
function GetProcessFilePath(ProcessName:PChar):PChar;
var
  ProcessSnapShotHandle: THandle;
  ProcessEntry: TProcessEntry32;
  ProcessHandle: THandle;
  Ret: BOOL;
  S:String;
  ModuleSnapShotHandle: THandle;
  ModuleEntry: TModuleEntry32;
  id:DWORD;
  hh:THandle;
Begin
try
  ProcessSnapShotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if ProcessSnapShotHandle>0 then
  begin
    ProcessEntry.dwSize:=SizeOf(TProcessEntry32);
    Ret:=Process32First(ProcessSnapShotHandle, ProcessEntry);
    while Ret do
    begin
      ModuleSnapShotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, ProcessEntry.th32ProcessID);
      if ModuleSnapShotHandle>0 then
      begin
        ModuleEntry.dwSize:=SizeOf(TModuleEntry32);
        Ret:=Module32First(ModuleSnapShotHandle, ModuleEntry);
        if Ret then
        begin
          S:=ModuleEntry.szExePath;
          if Pos(UpperCase(ProcessName),UpperCase(S))<>0 then
          begin
            Result:=PChar(ExtractFilePath(S));
            exit;
          end;
          CloseHandle(ModuleSnapShotHandle);
        end
      end;
      Ret:=Process32Next(ProcessSnapShotHandle, ProcessEntry)
    end;
    CloseHandle(ProcessSnapShotHandle);
  end;
except
  Result:='';
end;
end;

//���Ӳ�����к�
function GetDiskNumber:string;
const IDENTIFY_BUFFER_SIZE = 512;
type
   TIDERegs = packed record
    bFeaturesReg     : BYTE; // Used for specifying SMART "commands".
    bSectorCountReg  : BYTE; // IDE sector count register
    bSectorNumberReg : BYTE; // IDE sector number register
    bCylLowReg       : BYTE; // IDE low order cylinder value
    bCylHighReg      : BYTE; // IDE high order cylinder value
    bDriveHeadReg    : BYTE; // IDE drive/head register
    bCommandReg      : BYTE; // Actual IDE command.
    bReserved        : BYTE; // reserved for future use.  Must be zero.
end;
TSendCmdInParams = packed record
  //Buffer size in bytes
  cBufferSize  : DWORD;
  //Structure with drive register values.
  irDriveRegs  : TIDERegs;
  //Physical drive number to send command to (0,1,2,3).
  bDriveNumber : BYTE;
  bReserved    : Array[0..2] of Byte;
  dwReserved   : Array[0..3] of DWORD;
  bBuffer      : Array[0..0] of Byte;  // Input buffer.
end;
TIdSector = packed record
  wGenConfig                 : Word;
  wNumCyls                   : Word;
  wReserved                  : Word;
  wNumHeads                  : Word;
  wBytesPerTrack             : Word;
  wBytesPerSector            : Word;
  wSectorsPerTrack           : Word;
  wVendorUnique              : Array[0..2] of Word;
  sSerialNumber              : Array[0..19] of CHAR;
  wBufferType                : Word;
  wBufferSize                : Word;
  wECCSize                   : Word;
  sFirmwareRev               : Array[0..7] of Char;
  sModelNumber               : Array[0..39] of Char;
  wMoreVendorUnique          : Word;
  wDoubleWordIO              : Word;
  wCapabilities              : Word;
  wReserved1                 : Word;
  wPIOTiming                 : Word;
  wDMATiming                 : Word;
  wBS                        : Word;
  wNumCurrentCyls            : Word;
  wNumCurrentHeads           : Word;
  wNumCurrentSectorsPerTrack : Word;
  ulCurrentSectorCapacity    : DWORD;
  wMultSectorStuff           : Word;
  ulTotalAddressableSectors  : DWORD;
  wSingleWordDMA             : Word;
  wMultiWordDMA              : Word;
  bReserved                  : Array[0..127] of BYTE;
end;
PIdSector = ^TIdSector;
TDriverStatus = packed record
  //�������صĴ�����룬�޴��򷵻�0
  bDriverError : Byte;
  //IDE����Ĵ��������ݣ�ֻ�е�bDriverError Ϊ SMART_IDE_ERROR ʱ��Ч
  bIDEStatus   : Byte;
  bReserved    : Array[0..1] of Byte;
  dwReserved   : Array[0..1] of DWORD;
end;
TSendCmdOutParams = packed record
  //bBuffer�Ĵ�С
  cBufferSize  : DWORD;
  //������״̬
  DriverStatus : TDriverStatus;
  //���ڱ�������������������ݵĻ�������ʵ�ʳ�����cBufferSize����
  bBuffer      : Array[0..0] of BYTE;
end;
var
  hDevice : THandle;
  cbBytesReturned : DWORD;
  ptr : PChar;
  SCIP : TSendCmdInParams;
  aIdOutCmd : Array [0..(SizeOf(TSendCmdOutParams)+IDENTIFY_BUFFER_SIZE-1)-1] of Byte;
  IdOutCmd  : TSendCmdOutParams absolute aIdOutCmd;
procedure ChangeByteOrder( var Data; Size : Integer );
var
  ptr : PChar;
  i : Integer;
  c : Char;
begin
  ptr := @Data;
  for i := 0 to (Size shr 1)-1 do
  begin
    c := ptr^;
    ptr^ := (ptr+1)^;
    (ptr+1)^ := c;
    Inc(ptr,2);
  end;
end;
begin
try
  Result:='3'; // ��������򷵻ؿմ�
  if SysUtils.Win32Platform=VER_PLATFORM_WIN32_NT then
  begin// Windows NT, Windows 2000
    //��ʾ! �ı����ƿ���������������������ڶ����������� '\\.\PhysicalDrive1\'
    hDevice := CreateFile( '\\.\PhysicalDrive0', GENERIC_READ or GENERIC_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0 );
  end
  else // Version Windows 95 OSR2, Windows 98
    hDevice := CreateFile( '\\.\SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0 );
  if hDevice=INVALID_HANDLE_VALUE then Exit;
  try
    FillChar(SCIP,SizeOf(TSendCmdInParams)-1,#0);
    FillChar(aIdOutCmd,SizeOf(aIdOutCmd),#0);
    cbBytesReturned := 0;
    //Set up data structures for IDENTIFY command.
    with SCIP do
    begin
      cBufferSize  := IDENTIFY_BUFFER_SIZE;
      //bDriveNumber := 0;
      with irDriveRegs do
      begin
        bSectorCountReg  := 1;
        bSectorNumberReg := 1;
        //if Win32Platform=VER_PLATFORM_WIN32_NT then bDriveHeadReg := $A0
        //else bDriveHeadReg := $A0 or ((bDriveNum and 1) shl 4);
        bDriveHeadReg    := $A0;
        bCommandReg      := $EC;
      end;
    end;
    if not DeviceIoControl( hDevice, $0007c088, @SCIP, SizeOf(TSendCmdInParams)-1,
      @aIdOutCmd, SizeOf(aIdOutCmd), cbBytesReturned, nil ) then Exit;
  finally
    CloseHandle(hDevice);
  end;
  with PIdSector(@IdOutCmd.bBuffer)^ do
  begin
    ChangeByteOrder( sSerialNumber, SizeOf(sSerialNumber) );
    (PChar(@sSerialNumber)+SizeOf(sSerialNumber))^:=#0;
    Result:=(Trim(PChar(@sSerialNumber)));
  end;
except
  Result:='';
end;
end;

//���CPU��ID
function GetCPUID:LongInt;
var
  Temp:LongInt;
begin
try
  asm
    PUSH    EBX
    PUSH    EDI
    MOV     EDI,EAX
    MOV     EAX,1
    DW      $A20F
    MOV     TEMP,EDX
    POP     EDI
    POP     EBX
  end;
  Result:=Temp;
except
  Result:=0;
end;
end;

//�����ļ�
function DownloadFile(SourceFile,TargetFile:PChar):Boolean;
begin
try
  //MessageBox(0, PChar(IntToStr(UrlDownloadToFile(nil,Pchar(SourceFile),Pchar(TargetFile),0,nil))), '', 0);
  Result:=UrlDownloadToFile(nil,Pchar(SourceFile),Pchar(TargetFile),0,nil)=0;
except
  Result:=False;
end;
end;

//���CPU�ٶ�
function GetCPUSpeed:Double;
const
  DelayTime=500;
var
  TimerHi,TimerLo: DWORD;
  PriorityClass,Priority:Integer;
begin
try
  PriorityClass:=GetPriorityClass(GetCurrentProcess);
  Priority:=GetThreadPriority(GetCurrentThread);

  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

  Sleep(10);
  asm
    dw 310Fh // rdtsc
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh // rdtsc
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;

  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result:=(TimerLo/(1000.0*DelayTime));
except end;
end;

{
procedure ENumChildWindows(Hand:HWND);
var
  h:HWND;
  s:array[0..255] of Char;
  IsPopWindow:Bool;
begin
try
  IsPopWindow:=True;
  h:=GetWindow(hand,GW_child);
  while h>0 do
  begin
    GetClassName(h,s,256);
    if (StrPas(s)='WorkerA') or (StrPas(s)='WorkerW') then
    If IsWindowVisible(h) then IsPopWindow:=False;
    h:=GetWindow(h,GW_HWNDNEXT);
  end;
  if IsPopWindow then PostMessage(hand,WM_CLOSE,0,0);
except end;
end;

procedure CloseIEPop;
var
  H:HWnd;
  Text:array [0..255] of Char;
begin
try
  h:=GetWindow(GetDesktopWindow,GW_HWNDFIRST);
  while h<>0 do
  begin
    if GetWindowText(h,@Text, 255)>0 then
    if GetClassName(h,@Text, 255)>0 then
    if (StrPas(Text)='CabinetWClass') or (StrPas(Text)='IEFrame') then
      ENumChildWindows(h);
    h:=GetWindow(h, GW_HWNDNEXT);
  end;
except end;
end;
}

{
//���ػ�����ʾ����
function HideDesktop(IsTrue:Boolean):Boolean;
var
  hDesktop:THandle;
begin
try
  Hdesktop:=FindWindow('ProgMan',nil);
  if IsTrue then ShowWindow(hDesktop,SW_HIDE)
  else ShowWindow(hDesktop,SW_SHOW);
  Result:=True;
except
  Result:=False;
end;
end;

//���ػ�����ʾ״̬��
function HideTaskbar(IsTrue:Boolean):Boolean;
var
  wndHandle : THandle;
  wndClass : array[0..50] of Char;
begin
try
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  if IsTrue then ShowWindow(wndHandle, SW_HIDE)
  else ShowWindow(wndHandle, SW_SHOW);
except
  Result:=False;
end;
end;
}

{
//ɾ���Լ�
function DeleteMe:Boolean;
var
  BatFile: TextFile;
  BatFileName:PChar;
begin
try
  BatFileName := PChar(ExtractFilePath(ParamStr(0)) + '_deleteme.bat');
  AssignFile(BatFile, BatFileName);
  Rewrite(BatFile);
  Writeln(BatFile, ':try');
  Writeln(BatFile, 'del "' + ParamStr(0) + '"');
  Writeln(BatFile,
    'if exist "' + ParamStr(0) + '"' + ' goto try');
  Writeln(BatFile, 'del %0');  
  CloseFile(BatFile);
  WinExec(PChar(ExtractFilePath(ParamStr(0)) + '_deleteme.bat'),SW_HIDE);
  Result:=True;
  Halt;
except
  Result:=False;
end;
end;
}

{
//����Լ����̵ĸ�����
function CheckParentProc(FileName:PChar):Boolean;
var
  Pn: TProcesseNtry32;
  sHandle: THandle;
  H, ExplProc, ParentProc: Hwnd;
  Found: Boolean;
  Buffer: array[0..1023] of Char;
  Path:String;
  Tmp:PChar;
begin
try
  H:=0;
  ExplProc:=0;
  ParentProc:=0;
  //�õ�Windows��Ŀ¼
  SetString(Path,Buffer,GetWindowsDirectory(Buffer,Sizeof(Buffer)-1));
  Path:=UpperCase(Path +'\EXPLORER.EXE'); //�õ�Explorer��·��
  //�õ����н��̵��б����
  sHandle:=CreateToolHelp32SnapShot(TH32CS_SNAPALL,0);
  Found:=Process32First(sHandle, Pn); //���ҽ���
  while Found do //�������н���
  begin
    Tmp:=PChar(LowerCase(Pn.szExeFile));
    if Pos(LowerCase(ExtractFileName(FileName)),Tmp)<>0 then
    begin
      ParentProc:=Pn.th32ParentProcessID; //�õ������̵Ľ���ID
      //�����̵ľ��
      H:=OpenProcess(PROCESS_ALL_ACCESS,True,Pn.th32ParentProcessID);
    end
    else if UpperCase(Pn.szExeFile)=Path then
      ExplProc:=Pn.th32ProcessID;      //Explorer��PID
      Found:=Process32Next(sHandle,Pn); //������һ��
  end;
  //�ţ������̲���Explorer���ǵ���������
  if ParentProc<>ExplProc then
  begin
    //if FileExists('C:\txt.txt') then exit;
    TerminateProcess(H, 0); //ɱ֮����֮�����Ү�� :)
    ShutDown;
    Halt;
    Result:=True;
  end;
except
  Result:=False;
end;
end;
}

{
//ץȡ��Ļͼ���Ϊ�ļ�
function GetScreen(IncludeCur:Boolean;FileName:PChar):Boolean;
var
  DesktophWnd:hWnd;
  DesktopDC:hWnd;
  CursorhWnd:hWnd;
  CurPos:Tpoint;
  Rect:TRect;
  Bitmap:TBitmap;
  S:String;
begin
try
  S:=ChangeFileExt(FileName,'.bmp');
  DesktophWnd:=GetDesktopWindow();
  DesktopDC:=GetDC(DesktophWnd);
  GetWindowRect(DesktophWnd,Rect);
  if IncludeCur then
  begin
    CursorhWnd:=GetCursor();            //����ǰ���ָ����
    GetCursorPos(CurPos);
  end;                  //��ȡ��ǰ���ָ���λ������
  Bitmap:=TBitmap.Create;//����һ��Tbitmap���͵�ʵ������
  Bitmap.Width:=Rect.Right-Rect.Left;
  Bitmap.Height:=Rect.Bottom-Rect.Top;
  BitBlt(Bitmap.Canvas.Handle,0,0,Bitmap.Width, Bitmap.Height, DesktopDC,0,0,SRCCOPY);
  //��ץȡ����λͼ�����ϻ������
  if IncludeCur then
    DrawIcon(Bitmap.Canvas.Handle, CurPos.X, CurPos.Y, CursorhWnd);
  ReleaseDC(DesktophWnd,DesktopDC);
  Bitmap.SaveToFile(S); //ʹ���෽��SaveToFile�����ļ�
  Bitmap.Free;
  Result:=True;
except
  Result:=False;
end;
end;
//�ۺ������
}

{
//�ļ�����
function FileCopy(SourceFile,TargetFile:PChar):Boolean;
var
  FileLength:LongWord;
  FileBuf:Array of Byte;
  F:File;
begin
try
  if not FileExists(SourceFile) then
  begin
    Result:=False;
    exit;
  end;
  FileMode:=FMOpenRead;
  AssignFile(F,SourceFile);
  Reset(F,1);
  SetLength(FileBuf,FileSize(F));
  BlockRead(F,FileBuf[0],FileSize(F));
  FileLength:=FileSize(F);
  CloseFile(F);

  FileMode:=FMOpenWrite;
  AssignFile(F,TargetFile);
  ReWrite(F,1);
  BlockWrite(F,FileBuf[0],FileLength);
  CloseFile(F);
  Result:=True;
  //CopyFile(PChar(SourceFile),PChar(TargetFile),False);
except
  Result:=False;
end;
end;
}

{
//ɾ��Ŀ¼�µ��ļ�
function DeleteDirFile(Dir:string):Boolean;
var
 Rec: TSearchRec;
begin
try
 if Dir[Length(Dir)] <> '\' then
   Dir:= Dir + '\';
 if FindFirst(Dir + '*.*', faAnyFile, Rec) = 0 then
 repeat
   if (Rec.Name <> '.') and (Rec.Name <> '..') then
     if Rec.Attr and faDirectory > 0 then
       DeleteDirFile(Dir + Rec.Name)
     else
      DeleteFile(Dir + Rec.Name);
 until FindNext(Rec) <> 0;
 //RemoveDir(ExtractFileDir(Dir));
 FindClose(Rec);
except end;
end;
}

//{
//ɾ��Ŀ¼�µ��ļ�
function DeleteDirFile(Dir:string):Boolean;
var
  SR:TSearchrec;
  SA:string;
  Attr:integer;
  //S:String;
begin
try
  //S:=Dir;
  //if S[length(S)]<>'\' then S:=S+'\';
  //Dir:=PChar(S);
  if Dir[length(Dir)]<>'\' then Dir:=Dir+'\';
  if not DirectoryExists(Dir) then exit;
  SA:=Dir+'*.*';
  if FindFirst(SA,FAAnyFile,SR)=0 then
  begin
    repeat
      try
        if (SR.Name='.') or (SR.Name='..') then Continue;
        Attr:=FileGetAttr(SR.Name);
        //if (Attr and FAReadOnly<>0) then FileSetAttr(SR.Name,Attr -FAReadOnly);
        //if (Attr and FAHidden<>0) then FileSetAttr(SR.Name,Attr -FAHidden);
        //if (Attr and FASysfile<>0) then FileSetAttr(SR.Name,Attr -FASysfile);
        if SR.Attr and FADirectory<>0 then
        begin
          Continue;
        end
        else
        if FileExists(Dir+SR.Name) then
        DeleteFile(Dir+SR.Name);
        //DeleteFile(Dir+SR.Name);
      except
        Continue;
      end;
    until FindNext(SR)<>0;
    FindClose(sr);
    //if DirectoryExists(Dir) then ReMoveDir(Dir);
    //if DirectoryExists(Dir) then DeleteDir(Dir);
  end;
  Result:=True;
except end;
end;
//

//ɾ��Ŀ¼
function DeleteDir(Dir:string):Boolean;
var
  SR:TSearchrec;
  SA:string;
  Attr:integer;
  //S:String;
begin
try
  //S:=Dir;
  //if S[length(S)]<>'\' then S:=S+'\';
  //Dir:=PChar(S);
  if Dir[length(Dir)]<>'\' then Dir:=Dir+'\';
  if not DirectoryExists(Dir) then exit;
  SA:=Dir+'*.*';
  if FindFirst(SA,FAAnyFile,SR)=0 then
  begin
    repeat
      try
        if (SR.Name='.') or (SR.Name='..') then Continue;
        Attr:=FileGetAttr(SR.Name);
        //if (Attr and FAReadOnly<>0) then FileSetAttr(SR.Name,Attr -FAReadOnly);
        //if (Attr and FAHidden<>0) then FileSetAttr(SR.Name,Attr -FAHidden);
        //if (Attr and FASysfile<>0) then FileSetAttr(SR.Name,Attr -FASysfile);
        if SR.Attr and FADirectory<>0 then
        begin
          //if not DeleteDir(PChar(Dir+SR.Name)) then Result:=False;
          DeleteDir(PChar(Dir+SR.Name));
          if DirectoryExists(Dir+SR.Name) then ReMoveDir(Dir+SR.Name);
          if DirectoryExists(Dir+SR.Name) then DeleteDir(PChar(Dir+SR.Name));
        end
        else
        DeleteFile(Dir+SR.Name);
      except
        Continue;
        //break;
      end;
    until FindNext(SR)<>0;
    FindClose(sr);
    if DirectoryExists(Dir) then ReMoveDir(Dir);
    //if DirectoryExists(Dir) then DeleteDir(Dir);
  end;
  Result:=True;
except end;
end;
//}

{
//ɾ��Ŀ¼�µ��ļ�2
function DeleteFile2(Dir:string):Boolean;
var
  SR:TSearchrec;
  SA:string;
  Attr:integer;
  //S:String;
begin
try
  //S:=Dir;
  //if S[length(S)]<>'\' then S:=S+'\';
  //Dir:=PChar(S);
  if Dir[length(Dir)]<>'\' then Dir:=Dir+'\';
  if not DirectoryExists(Dir) then exit;
  //ShellDeleteFile(Dir+'\*.jpg');
  //ShellDeleteFile(Dir+'\*.htm');
  //ShellDeleteFile(Dir+'\*.js');
  ShellDeleteFile(Dir+'\*.*');
  Result:=True;
except end;
end;

//ɾ��Ŀ¼2
function DeleteDir2(Dir:string):Boolean;
var
  SR:TSearchrec;
  SA:string;
  Attr:integer;
  //S:String;
begin
try
  //S:=Dir;
  //if S[length(S)]<>'\' then S:=S+'\';
  //Dir:=PChar(S);
  if Dir[length(Dir)]<>'\' then Dir:=Dir+'\';
  if not DirectoryExists(Dir) then exit;
  SA:=Dir+'*.*';
  if FindFirst(SA,FAAnyFile,SR)=0 then
  begin
    repeat
      try
        if (SR.Name='.') or (SR.Name='..') then Continue;
        Attr:=FileGetAttr(SR.Name);
        //if (Attr and FAReadOnly<>0) then FileSetAttr(SR.Name,Attr -FAReadOnly);
        //if (Attr and FAHidden<>0) then FileSetAttr(SR.Name,Attr -FAHidden);
        //if (Attr and FASysfile<>0) then FileSetAttr(SR.Name,Attr -FASysfile);
        if SR.Attr and FADirectory<>0 then
        begin
          //if not DeleteDir(PChar(Dir+SR.Name)) then Result:=False;
          DeleteDir2(PChar(Dir+SR.Name));
          if DirectoryExists(Dir+SR.Name) then ReMoveDir(Dir+SR.Name);
          if DirectoryExists(Dir+SR.Name) then DeleteDir2(PChar(Dir+SR.Name));
        end
        else //DeleteFile(Dir+SR.Name);
        ShellDeleteFile(Dir+'\*.*');
      except
        Continue;
        //break;
      end;
    until FindNext(SR)<>0;
    FindClose(sr);
    if DirectoryExists(Dir) then ReMoveDir(Dir);
    //if DirectoryExists(Dir) then DeleteDir(Dir);
  end;
  Result:=True;
except end;
end;
}

function GetFileSize2(Filename: string):LongInt; //DWORD;
var
  Hfile : THandle;
begin
try
  HFILE := CreateFile(PChar(Filename), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if HFILE <> INVALID_HANDLE_value then
    begin
    Result := GetFileSize(HFILE, nil);
    CloseHandle(HFILE);
    end
  else  Result := 0;
except end;
end;

//{
//���IP��ַ
function GetIPAddress:string;
type
  TaPInAddr=Array[0..10] of PInAddr;
  PaPInAddr=^TaPInAddr;
var
  IPAddress:String;
  Buffer: Array[0..63] of Char;
  phe:PHostEnt;
  pptr:PaPInAddr;
  I: Integer;
  GInitData:TWSAData;
begin
try
  IPAddress:='';
  WSAStartup($101,GInitData);
  GetHostName(Buffer,SizeOf(Buffer));
  phe:=GetHostByName(buffer);
  if phe=nil then Exit;
  pPtr:=PaPInAddr(phe^.h_addr_list);
  I:=0;
  while pPtr^[I]<>nil do
  begin
    IPAddress:=inet_ntoa(pptr^[I]^);
    Inc(I);
  end;
  WSACleanup;
  Result:=(IPAddress);
except
  Result:='';
end;
end;
//}

{
//���ı��ļ���׷������
function AppendText(FileName:PChar;Str:PChar):Boolean;
var
  TxtFile:TextFile;
begin
try
  AssignFile(TxtFile,FileName);
  if FileExists(FileName)then Append(TxtFile)    //ReSet(TxtFile);
  else ReWrite(TxtFile);
  if Trim(Str)<>'' then WriteLn(TxtFile,Str);
  CloseFile(TxtFile);
  Result:=True;
except 
  Result:=False;
end;
end;
}

//ini
function ReadConfig(IniFileName,SectionName,ValueName:String):String;
var
  IniHandle:TIniFile;
begin
try
  //ShowMessage(IniFileName);
  if FileExists(IniFileName) then
  begin
    IniHandle := TIniFile.Create(IniFileName);
    Result:=IniHandle.ReadString(SectionName,ValueName,'');
    IniHandle.free;
  end;
except end;
end;

function WriteConfig(IniFileName,SectionName,ValueName,Value:String;Flag:Word=0):Boolean;
var
  IniHandle:TIniFile;
begin
try
  //ShowMessage(IniFileName);
  if FileExists(IniFileName) then
  begin
    IniHandle := TIniFile.Create(IniFileName);
    if (Flag = 0) or (Flag = 1) then
    IniHandle.WriteString(SectionName,ValueName,Value)
    else if (Flag = 2) then
    IniHandle.WriteInteger(SectionName,ValueName,StrToInt(Value));
    Result := true;
    IniHandle.free;
  end;
except end;
end;

//ע�����
//��ע�����ĳ���еļ�ֵ
//ReadRegValue(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion',0,'ProgramFilesDir');
function ReadRegValue(RootKey:HKEY;OpenKey:PChar;KeyType:Integer;Key:PChar):string;
var
  Reg:TRegistry;
begin
try
  Reg:=TRegistry.Create;
  Reg.RootKey:=RootKey;
  try
  if Reg.OpenKey(OpenKey,False) then
  begin
    Case KeyType of
      0:Result:=PChar(Reg.ReadString(Key));
      1:Result:=PChar(Reg.ReadInteger(Key));
      else Result:='';
    end;
  end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
except end;
end;

//����ע�����ĳ���еļ�ֵ
function SetRegValue(RootKey:HKEY;OpenKey:PChar;KeyType:Integer;Key,Value:PChar):Boolean;
var
  Reg:TRegistry;
begin    //RootKey:=HKEY_LOCAL_MACHINE;
try      //OpenKey:='Software\Microsoft\Windows\CurrentVersion\Run';
  try
  Reg:=TRegistry.Create;
  Reg.RootKey:=RootKey;
  Reg.openKey(OpenKey,True);
  if KeyType=0 then
  Reg.WriteString(Key,Value)
  else if KeyType=1 then
  Reg.Writeinteger(Key,StrToInt(Value))
  else
  begin
    Result:=False;
    Exit;
  end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  Result:=True;
except
  Result:=False;
end;
end;

//{
//ɾ��ע�����ĳ���еļ�ֵ
function DeleteRegValue(RootKey:HKEY;OpenKey:PChar;Value:PChar):Boolean;
var
  Reg:TRegistry;
begin    //RootKey:=HKEY_LOCAL_MACHINE;
try      //OpenKey:='Software\Microsoft\Windows\CurrentVersion\Run';
  try
  Reg:=TRegistry.Create;
  Reg.RootKey:=RootKey;
  Reg.OpenKey(OpenKey,True);
  if Reg.ValueExists(Value) then
  begin
    Reg.DeleteValue(Value);
    Result:=True;
    exit;
  end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  Result:=False;
except
  Result:=False;
end;
end;
//}

{
//ϵͳ�������Զ�����
function AutoRun(KeyValue:PChar;FileName:PChar):Boolean;
var
  Reg:TRegistry;
begin
try
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.OpenKey('SOFTWARE\MicroSoft\windows\CurrentVersion\Run',true);
    Reg.WriteString(KeyValue,FileName);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  Result:=True;
except
  Result:=False;
end;
end;
}

//����/ȡ����ִ���ļ�EXE��TXT�����ļ�����
function LinkTxtType(FileName:PChar;IsTrue:Boolean):Boolean;
var
  Reg:TRegistry;
begin
try
  if IsTrue then
  begin
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_CLASSES_ROOT;
    Reg.OpenKey('\txtfile\shell\open\command',TRUE);
    Reg.WriteString('',Trim(FileName)+' "%1" ');
    Reg.CloseKey;
    Reg.Free;
  end
  else
  begin
    Reg:=TRegistry.Create;
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('\txtfile\shell\open\command',TRUE);
    Reg.WriteString('','Notepad.exe'+' "%1" ');
    Reg.CloseKey;
    Reg.Free;
    {
    with TRegistry.Create do
    begin
      RootKey := HKEY_CLASSES_ROOT;
      OpenKey('\txtfile\shell\open\command',TRUE);
      WriteString('','Notepad.exe'+' "%1" ');
      Free;
    end;
    }
  end;
  Result:=True;
except
  Result:=False;
end;
end;

//����/ȡ����ִ���ļ�EXE��EXE�����ļ�����
function LinkExeType(FileName:PChar;IsTrue:Boolean):Boolean;
var
  Reg:TRegistry;
begin
try
  if IsTrue then
  begin
    Reg:=TRegistry.Create;
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('\exefile\shell\open\command',TRUE);
    Reg.WriteString('',Trim(FileName)+' "%1" ');
    Reg.CloseKey;
    Reg.Free;
  end
  else
  begin
    Reg:=TRegistry.Create;
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('\exefile\shell\open\command',TRUE);
    Reg.WriteString('','"%1" %*');
    Reg.CloseKey;
    Reg.Free;
    {
    with TRegistry.Create do
    begin
      RootKey := HKEY_CLASSES_ROOT;
      OpenKey('\txtfile\shell\open\command',TRUE);
      WriteString('','"%1" %*');
      Free;
    end;
    }
  end;
  Result:=True;
except
  Result:=False;
end;
end;

{
//������д���
function CheckState(Key:PChar;Name:PChar;Value:Integer):Integer;
var
  Reg:TRegistry;
  SCount:string;
  ICount:integer;
begin
try
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    if Trim(Key)<>'' then
    Reg.OpenKey('SOFTWARE\MicroSoft\'+Trim(Key),True)
    else
    Reg.OpenKey('SOFTWARE\MicroSoft\msd',True);
    if Value>0 then
    begin
      Reg.WriteString(Name,IntToStr(Value));
      Result:=Value;
      exit;
    end;
    SCount:=Reg.ReadString(Name);
    if Trim(SCount)='' then
    begin
      Reg.WriteString(Name,'1');
      Result:=1;
      Exit;
    end;
    ICount:=StrToInt(SCount);
    ICount:=ICount+1;
    Reg.WriteString(Name,IntToStr(ICount));
    Result:=ICount;
  finally
    Reg.Free;
  end;
except
  Result:=0;
end;
end;
}

//����/����ע���
function LockReg(IsTrue:Boolean):Boolean;
var
  Reg:TRegistry;
begin
try
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System',true);
    if IsTrue then Reg.WriteInteger('DisableRegistryTools',1)
    else  Reg.WriteInteger('DisableRegistryTools',0);
  finally
    Reg.CloseKey;
    Reg.free;
  end;
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_CURRENT_USER;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Policies\System',true);
    if IsTrue then
      Reg.WriteInteger('DisableRegistryTools',1)
    else
      Reg.WriteInteger('DisableRegistryTools',0);
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  Result:=True;
except
  Result:=False;
end;
end;

//����IE
function LockIE:Boolean;
{
var
  Reg:TRegistry;
}
begin
try
  try
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'HomePage','1');
  {
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Windows Title','Microsoft Internet Explorer');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Default_Page_URL','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Default_Search_URL','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Search Page','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');

  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Windows Title','Microsoft Internet Explorer');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Default_Page_URL','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Default_Search_URL','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Search Page','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');
  }

  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\Internet Setting\Zones\3',1,'1803','3');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Setting\Zones\3',1,'1803','3');

  finally
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'GeneralTal','1');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'SecurityTab','1');  //��ȫ
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ContentTab','1');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ConnecttionsTab','1');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ProgramsTab','1');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'AdvancedTab','1');  //�߼�
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Cache','1');  //[����]�е�[Internet��ʱ�ļ�]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'History','1');  //[����]�е�[��ʷ��¼]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Colors','1');  //IE����������ֺͱ�����ɫ
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Links','1');  //IE����������ӵ���ɫ
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Fonts','1');  //[Internetѡ��]��[����]�е�[����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Languages','1');  //[Internetѡ��]��[����]�е�[����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Accessibility','1');  //[Internetѡ��]��[����]�е�[��������]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Security_options_edit','1');  //[Internetѡ��]��[��ȫ]�е�[������İ�ȫ����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Ratings','1');  //[Internetѡ��]��[����]�е�[�ּ����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Certificates','1');  //[Internetѡ��]��[����]�е�[֤��]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'FormSuggest','1');  //[Internetѡ��]��[����]�еı��Զ���ɹ���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'FormSuggest Passwords','1');  //[Internetѡ��]��[����]�е������Զ���ɹ���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Profiles','1');  //[Internetѡ��]��[����]�е�[�����ļ�]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Connwiz Admin Lock','1');  //[Internetѡ��]��[����]�е�[��������]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Connection Settings','1');  //[Internetѡ��]��[����]�е�������������
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Proxy','1');  //[Internetѡ��]��[����]�еĴ������������
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','1');  //[Internetѡ��]��[����]�е��Զ����ù���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ResetWebSettings','1');  //[Internetѡ��]��[����]�е�����Web���ù���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Check_If_Default','1');  //[Internetѡ��]��[����]�еļ��Ĭ�����������
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Advanced','1');  //[Internetѡ��]��[�߼�]�е�����
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','1');  //[Internetѡ��]��[����]�е��Զ����ù���
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','1');  //[Internetѡ��]��[����]�е��Զ����ù���
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','1');  //[Internetѡ��]��[����]�е��Զ����ù���
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','1');  //[Internetѡ��]��[����]�е��Զ����ù���

  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'HomePage','1');
  end;
  Result:=True;
except
  Result:=False;
end;
end;

//�ָ�IE���⼰��ҳ
function DefaultIE:Boolean;
{
var
  Reg:TRegistry;
}
begin
try
  try
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'HomePage','0');
  
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Windows Title','Microsoft Internet Explorer');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Default_Page_URL','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Default_Search_URL','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Search Page','about:blank');
  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');

  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Windows Title','Microsoft Internet Explorer');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Default_Page_URL','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Default_Search_URL','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Search Page','about:blank');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Internet Explorer\Main',0,'Start Page','about:blank');

  SetRegValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Windows\CurrentVersion\Internet Setting\Zones\3',1,'1803','0');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Internet Setting\Zones\3',1,'1803','0');

  finally
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'GeneralTal','0');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'SecurityTab','0');  //��ȫ
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ContentTab','0');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ConnecttionsTab','0');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ProgramsTab','0');  //����
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'AdvancedTab','0');  //�߼�
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Cache','0');  //[����]�е�[Internet��ʱ�ļ�]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'History','0');  //[����]�е�[��ʷ��¼]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Colors','0');  //IE����������ֺͱ�����ɫ
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Links','0');  //IE����������ӵ���ɫ
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Fonts','0');  //[Internetѡ��]��[����]�е�[����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Languages','0');  //[Internetѡ��]��[����]�е�[����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Accessibility','0');  //[Internetѡ��]��[����]�е�[��������]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Security_options_edit','0');  //[Internetѡ��]��[��ȫ]�е�[������İ�ȫ����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Ratings','0');  //[Internetѡ��]��[����]�е�[�ּ����]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Certificates','0');  //[Internetѡ��]��[����]�е�[֤��]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'FormSuggest','0');  //[Internetѡ��]��[����]�еı��Զ���ɹ���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'FormSuggest Passwords','0');  //[Internetѡ��]��[����]�е������Զ���ɹ���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Profiles','0');  //[Internetѡ��]��[����]�е�[�����ļ�]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Connwiz Admin Lock','0');  //[Internetѡ��]��[����]�е�[��������]��
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Connection Settings','0');  //[Internetѡ��]��[����]�е�������������
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Proxy','0');  //[Internetѡ��]��[����]�еĴ������������
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','0');  //[Internetѡ��]��[����]�е��Զ����ù���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'ResetWebSettings','0');  //[Internetѡ��]��[����]�е�����Web���ù���
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Check_If_Default','0');  //[Internetѡ��]��[����]�еļ��Ĭ�����������
  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Advanced','0');  //[Internetѡ��]��[�߼�]�е�����
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','0');  //[Internetѡ��]��[����]�е��Զ����ù���
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','0');  //[Internetѡ��]��[����]�е��Զ����ù���
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','0');  //[Internetѡ��]��[����]�е��Զ����ù���
  //SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'Autoconfig','0');  //[Internetѡ��]��[����]�е��Զ����ù���

  SetRegValue(HKEY_CURRENT_USER,'Software\Policies\Microsoft\Internet Explorer\Control Panel',1,'HomePage','0');
  end;
{
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Microsoft\Internet Explorer\Main',true);
    Reg.WriteString('Start Page','about:blank');
    Reg.WriteString('Windows Title','Microsoft Internet Explorer');
    Result:=True;
  finally
    Reg.Free;
  end;
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Setting\Zones\3',true);
    Reg.Writeinteger('1803',0);
    Result:=True;
  finally
    Reg.Free;
  end;
  try
    Reg:=TRegistry.Create;
    Reg.RootKey:=HKEY_CURRENT_USER;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Internet Setting\Zones\3',true);
    Reg.Writeinteger('1803',0);
  finally
    Reg.Free;
  end;
}
  Result:=True;
except
  Result:=False;
end;
end;

//{
//�������е�
function LockAll:Boolean;
begin
try
  try
  LockReg(true);
  //LinkTxtType('',false);
  //LinkExeType('',false);
  LockIE;
  finally
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoRun','1');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoFind','1');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoLogoff','1');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoClose','1');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoSetFolders','1'); //[��ʼ]�˵���[����]���[�������]��[��������]��[��ӡ��]����ѡ��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoSetTaskbar','1'); //[��ʼ]�˵���[����]���[��������[��ʼ]�˵�]ѡ��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoViewContextMenu','1'); //ʹ������Ҽ��˵�
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoTrayContextMenu','1'); //��������ݲ˵��ĵ���
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoSetTaskBar','1'); //��ֹ��������������
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoCloseDragDropBands','1'); //��ݲ˵��е�[������]ѡ��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoDesktop','0'); //�Ƿ��������� 0:��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer',1,'Link','1');  //�����ݷ�ʽ�Ƿ���Сǰͷ 1:��
  end;
  Result:=True;
except
  Result:=False;
end;
end;
//}

//�޸�IE���⡢�ָ����±�����������ע���༭��
function DefaultAll:Boolean;
begin
try
  try
  LockReg(false);
  LinkTxtType('',false);
  LinkExeType('',false);
  DefaultIE;
  finally
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoRun','0');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoFind','0');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoLogoff','0');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoClose','0');
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoSetFolders','0'); //[��ʼ]�˵���[����]���[�������]��[��������]��[��ӡ��]����ѡ��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoSetTaskbar','0'); //[��ʼ]�˵���[����]���[��������[��ʼ]�˵�]ѡ��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoViewContextMenu','0'); //ʹ������Ҽ��˵�
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoTrayContextMenu','0'); //��������ݲ˵��ĵ���
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoSetTaskBar','0'); //��ֹ��������������
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoCloseDragDropBands','0'); //��ݲ˵��е�[������]ѡ��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer',1,'NoDesktop','0'); //�Ƿ��������� 0:��
  SetRegValue(HKEY_CURRENT_USER,'Software\Microsoft\Windows\CurrentVersion\Explorer',1,'Link','1');  //�����ݷ�ʽ�Ƿ���Сǰͷ 1:��
  end;
  Result:=True;
except
  Result:=False;
end;
end;
//ע��������

function GetVersionInfo(var SProduct,SVersion,SServicePack:string):boolean;
type
  _OSVERSIONINFOEXA = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of AnsiChar;
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: Word;
    wProductType: Byte;
    wReserved: Byte;
  end;
  _OSVERSIONINFOEXW = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar;
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: Word;
    wProductType: Byte;
    wReserved: Byte;
  end;
  { this record only support Windows 4.0 SP6 and latter , Windows 2000 ,XP, 2003 }
  OSVERSIONINFOEXA = _OSVERSIONINFOEXA;
  OSVERSIONINFOEXW = _OSVERSIONINFOEXW;
  OSVERSIONINFOEX = OSVERSIONINFOEXA;
const
  VER_PLATFORM_WIN32_CE = 3;
  { wProductType defines }
  VER_NT_WORKSTATION        = 1;
  VER_NT_DOMAIN_CONTROLLER  = 2;
  VER_NT_SERVER             = 3;
  { wSuiteMask defines }
  VER_SUITE_SMALLBUSINESS             = $0001;
  VER_SUITE_ENTERPRISE                = $0002;
  VER_SUITE_BACKOFFICE                = $0004;
  VER_SUITE_TERMINAL                  = $0010;
  VER_SUITE_SMALLBUSINESS_RESTRICTED  = $0020;
  VER_SUITE_DATACENTER                = $0080;
  VER_SUITE_PERSONAL                  = $0200;
  VER_SUITE_BLADE                     = $0400;
  VER_SUITE_SECURITY_APPLIANCE        = $1000;
var
  Info: OSVERSIONINFOEX;
  bEx: BOOL;
begin
  Result := False;
  FillChar(Info, SizeOf(OSVERSIONINFOEX), 0);
  Info.dwOSVersionInfoSize := SizeOf(OSVERSIONINFOEX);
  bEx := GetVersionEx(POSVERSIONINFO(@Info)^);
  if not bEx then
  begin
    Info.dwOSVersionInfoSize := SizeOf(OSVERSIONINFO);
    if not GetVersionEx(POSVERSIONINFO(@Info)^) then Exit;
  end;
  with Info do
  begin
    SVersion := IntToStr(dwMajorVersion) + '.' + IntToStr(dwMinorVersion)
                                + '.' + IntToStr(dwBuildNumber and $0000FFFF);
    SProduct := 'Microsoft Windows unknown';
    case Info.dwPlatformId of
      VER_PLATFORM_WIN32s: { Windows 3.1 and earliest }
        SProduct := 'Microsoft Win32s';
      VER_PLATFORM_WIN32_WINDOWS:
        case dwMajorVersion of
          4: { Windows95,98,ME }
            case dwMinorVersion of
              0:
                if szCSDVersion[1] in ['B', 'C'] then
                begin
                  SProduct := 'Microsoft Windows 95 OSR2';
                  SVersion := SVersion + szCSDVersion[1];
                end
                else
                  SProduct := 'Microsoft Windows 95';
              10:
                if szCSDVersion[1] = 'A' then
                begin
                  SProduct := 'Microsoft Windows 98 SE';
                  SVersion := SVersion + szCSDVersion[1];
                end
                else
                  SProduct := 'Microsoft Windows  98';
              90:
                SProduct := 'Microsoft Windows Millennium Edition';
            end;
        end;
      VER_PLATFORM_WIN32_NT:
      begin
        SServicePack := szCSDVersion;
        case dwMajorVersion of
          0..4:
            if bEx then
            begin
              case wProductType of
                VER_NT_WORKSTATION:
                  SProduct := 'Microsoft Windows NT Workstation 4.0';
                VER_NT_SERVER:
                  if wSuiteMask and VER_SUITE_ENTERPRISE <> 0 then
                    SProduct := 'Microsoft Windows NT Advanced Server 4.0'
                  else
                    SProduct := 'Microsoft Windows NT Server 4.0';
              end;
            end
            else  { NT351 and NT4.0 SP5 earliest}
              with TRegistry.Create do
              try
                RootKey := HKEY_LOCAL_MACHINE;
                if OpenKey('SYSTEM\CurrentControlSet\Control\ProductOptions', False) then
                begin
                  if ReadString('ProductType') = 'WINNT' then
                    SProduct := 'Microsoft Windows NT Workstation ' + SVersion
                  else if ReadString('ProductType') = 'LANMANNT' then
                    SProduct := 'Microsoft Windows NT Server ' + SVersion
                  else if ReadString('ProductType') = 'LANMANNT' then
                    SProduct := 'Microsoft Windows NT Advanced Server ' + SVersion;
                end;
              finally
                Free;
              end;
          5:
            case dwMinorVersion of
              0:  { Windows 2000 }
                case wProductType of
                  VER_NT_WORKSTATION:
                    SProduct := 'Microsoft Windows 2000 Professional';
                  VER_NT_SERVER:
                    if wSuiteMask and VER_SUITE_DATACENTER <> 0 then
                      SProduct := 'Microsoft Windows 2000 Datacenter Server'
                    else if wSuiteMask and VER_SUITE_ENTERPRISE <> 0 then
                      SProduct := 'Microsoft Windows 2000 Advanced Server'
                    else
                      SProduct := 'Microsoft Windows 2000 Server';
                end;
              1: { Windows XP }
                if wSuiteMask and VER_SUITE_PERSONAL <> 0 then
                  SProduct := 'Microsoft Windows XP Home Edition'
                else
                  SProduct := 'Microsoft Windows XP Professional';
              2: { Windows Server 2003 }
                if wSuiteMask and VER_SUITE_DATACENTER <> 0 then
                  SProduct := 'Microsoft Windows Server 2003 Datacenter Edition'
                else if wSuiteMask and VER_SUITE_ENTERPRISE <> 0 then
                  SProduct := 'Microsoft Windows Server 2003 Enterprise Edition'
                else if wSuiteMask and VER_SUITE_BLADE <> 0 then
                  SProduct := 'Microsoft Windows Server 2003 Web Edition'
                else
                  SProduct := 'Microsoft Windows Server 2003 Standard Edition';
            end;
        end;
      end;
      VER_PLATFORM_WIN32_CE: { Windows CE }
        SProduct := SProduct + ' CE';
    end;
  end;
  Result := True;
end;

//ʹ�ô���
function UseProxy(const Proxy: string):Boolean;
var
  Info: INTERNET_PROXY_INFO;
begin
try
  Info.dwAccessType := INTERNET_OPEN_TYPE_PROXY;
  Info.lpszProxy := PChar(Proxy);
  Info.lpszProxyBypass := PChar('');
  InternetSetOption(nil, INTERNET_OPTION_PROXY, @Info, SizeOf(Info));
  InternetSetOption(nil, INTERNET_OPTION_SETTINGS_CHANGED, nil, 0);
  Result:=true;
except end;
end;

//���IE����,�������ֱ��ʹ��.
function CheckProxy: Boolean;
var
  Reg: TRegistry;
  I: Integer;
  Fproxy: String;
begin
try
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', True) then
    begin
      I := Reg.ReadInteger('ProxyEnable');
      if I <> 1 then
      begin
        NotProxy;
        exit;
      end;
      Fproxy := Reg.ReadString('ProxyServer');
      if (Trim(Fproxy) = '') or (Pos('.', Fproxy) = 0) then exit;
      UseProxy(Fproxy);
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
except end;
end;

//���Ĵ���
function ChangeProxy(const Proxy: string):Boolean;
var
  Reg: TRegistry;
  //Info: INTERNET_PROXY_INFO;
  Fproxy:string;
begin
try
  FProxy := Proxy;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', True) then
    begin
      Reg.WriteString('ProxyServer', Fproxy);
      //Reg.WriteInteger('ProxyEnable', Integer(True));
      {
      Info.dwAccessType := INTERNET_OPEN_TYPE_PROXY;
      Info.lpszProxy := PChar(FProxy);
      Info.lpszProxyBypass := PChar('');
      InternetSetOption(nil, INTERNET_OPTION_PROXY, @Info, SizeOf(Info));
      InternetSetOption(nil, INTERNET_OPTION_SETTINGS_CHANGED, nil, 0);
      }
    end;
    Result:=true;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
except end;
end;

{
function EnableProxy:Boolean;
var
  Reg: TRegistry;
begin
try
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', True) then
    begin
      Reg.WriteInteger('ProxyEnable', Integer(True));
    end;
    Result:=true;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
except end;
end;

function DisableProxy:Boolean;
var
  Reg: TRegistry;
begin
try
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', True) then
    begin
      Reg.WriteInteger('ProxyEnable', Integer(false));
    end;
    Result:=true;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
except end;
end;
}

//���ô���
function NotProxy:Boolean;
var
  Reg: TRegistry;
  Info: INTERNET_PROXY_INFO;
begin
try
  {
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Internet Settings', True) then
    begin
      Reg.Writestring('ProxyServer', '');
      Reg.WriteInteger('ProxyEnable', Integer(False));
      Info.dwAccessType := INTERNET_OPEN_TYPE_DIRECT;
      Info.lpszProxy := nil;
      Info.lpszProxyBypass := nil;
      InternetSetOption(nil, INTERNET_OPTION_PROXY, @Info, SizeOf(Info));
      InternetSetOption(nil, INTERNET_OPTION_SETTINGS_CHANGED, nil, 0);
    end;
    Result:=true;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
  }
  Info.dwAccessType := INTERNET_OPEN_TYPE_DIRECT;
  Info.lpszProxy := nil;
  Info.lpszProxyBypass := nil;
  InternetSetOption(nil, INTERNET_OPTION_PROXY, @Info, SizeOf(Info));
  InternetSetOption(nil, INTERNET_OPTION_SETTINGS_CHANGED, nil, 0);
except end;
end;

//����ĳ�������ΪĬ�������
procedure SetBrowser(AppExeName:string;flag:integer=0);
var
  Reg:TRegistry;
  cmdStr:string;
  myArray:array[0..7] of Word;
  str1,str2:string;
  BrowserName2:string;
  ApplicationName:string;
  str:string;
begin
try
  case flag of
  0,1:
  begin
    ApplicationName:=AppExeName;
    BrowserName2:=BrowserName;
  end;
  2:
  begin
    //ApplicationName:='C:\Program Files\Internet Explorer\'+'iexplore.exe';
    str:=GetSystemFolderDir($0026);
    if Trim(str)<>'' then
    ApplicationName:=str+'\Internet Explorer\'+'iexplore.exe'
    else
    ApplicationName:='C:\Program Files'+'\Internet Explorer\'+'iexplore.exe';
    //ShowMessage(ApplicationName);
    if not FileExists(ApplicationName) then
    begin
      //ShowMessage('����ʧ�ܣ�');
      exit;
    end;
    BrowserName2:='ie';
  end;
  else
  begin
    ApplicationName:=AppExeName;
    BrowserName2:=BrowserName;
  end;
  end;

  cmdStr:='"'+ApplicationName+'" "%1"';

  myArray[0] := $00;
  myArray[1] := $46;
  myArray[2] := $73;
  myArray[3] := $48;
  myArray[4] := $a2;
  myArray[5] := $56;
  myArray[6] := $c2;
  myArray[7] := $01;
  //cmdStr := '"'+Application.ExeName+'" "%1"';

  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_CLASSES_ROOT;

    Reg.OpenKey('Applications\'+BrowserName2+'.exe\shell\',True);
    Reg.WriteString('',BrowserName2);
    Reg.WriteString('FriendlyCache', BrowserName2);
    Reg.WriteBinaryData('FriendlyCacheCTime',myArray, 8);
    Reg.CloseKey;
    Reg.OpenKey('Applications\'+BrowserName2+'.exe\shell\'+BrowserName2+'\command\', True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;

    Reg.OpenKey('file\shell\',True);
    Reg.WriteString('',BrowserName2);
    Reg.CloseKey;
    Reg.OpenKey('file\shell\'+BrowserName2+'\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;
    Reg.OpenKey('file\shell\open\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;

    Reg.OpenKey('ftp\shell\',True);
    Reg.WriteString('',BrowserName2);
    Reg.CloseKey;
    Reg.OpenKey('ftp\shell\'+BrowserName2+'\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;
    Reg.OpenKey('ftp\shell\open\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;

    Reg.OpenKey('htmlfile\shell\', True);
    Reg.WriteString('', BrowserName2);
    Reg.CloseKey;
    Reg.OpenKey('htmlfile\shell\'+BrowserName2+'\command\', True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;
    Reg.OpenKey('htmlfile\shell\open\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;

    Reg.OpenKey('http\shell\',True);
    Reg.WriteString('',BrowserName2);
    Reg.CloseKey;
    Reg.OpenKey('http\shell\'+BrowserName2+'\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;
    Reg.OpenKey('http\shell\open\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;

    Reg.OpenKey('https\shell\',True);
    Reg.WriteString('',BrowserName2);
    Reg.CloseKey;
    Reg.OpenKey('https\shell\'+BrowserName2+'\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;
    Reg.OpenKey('https\shell\open\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;

    Reg.OpenKey('InternetShortcut\shell\',True);
    Reg.WriteString('',BrowserName2);
    Reg.CloseKey;
    Reg.OpenKey('InternetShortcut\shell\'+BrowserName2+'\command\',True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;
    Reg.OpenKey('InternetShortcut\shell\open\command\', True);
    Reg.WriteString('',cmdStr);
    Reg.CloseKey;
  finally
    Reg.Free;
  end;
except end;
end;

{
procedure UpdateReg(Str:string;Remove: Boolean);    
const  Key = 'Software\Microsoft\Windows\CurrentVersion\Uninstall\EnjoyIE';begin  with TRegistry.Create do  try    RootKey := HKEY_LOCAL_MACHINE;    if Remove then DeleteKey(Key) else      if OpenKey(Key, True) then      begin        WriteString('DisplayName',BrowserName+'�����');        WriteString('UninstallString', Str + ' /u');      end;  finally    Free;  end;end;

procedure Uninstall(Str:string);
begin
try                       
    //Application.ShowMainForm:=false;
    UpdateReg(Str,true);
    //WritePrivateProfileString('RunData','Uninstall','1',PChar(WinDir+ToSysConfigFile));
    MessageBox(0,TitleStr+'�Ѿ��ɹ�ж��!','ж�سɹ�.',0);  //exit;
    try
      DeleteDirFile(ExtractFilePath(Str));
      DeleteDir(ExtractFilePath(Str));
    finally
    DeleteMe;
    KillProcess(PChar(Str));
    Halt;
    //Application.Terminate;
    //exit;
    end;
except end;
end;
}

//IE�࿪ʼ
function DelRegCache:Boolean;
var
  reg:TRegistry;
begin
try
  try
  reg:=Tregistry.create;
  reg.RootKey:=HKEY_CURRENT_USER;
  reg.DeleteKey('Software\Microsoft\Internet Explorer\TypedURLs');
  finally
   reg.Free;
  end;
  Result:=true;
except end;
end;

function GetCookiesFolder:string;
var
  pidl:pItemIDList;
  buffer:array [ 0..255 ] of char ;
begin
try
  SHGetSpecialFolderLocation(Application.Handle , CSIDL_COOKIES, pidl);

  SHGetPathFromIDList(pidl, buffer);
  result:=strpas(buffer);
except end;
end;

function ShellDeleteFile(sFileName: string): Boolean;
var
  FOS: TSHFileOpStruct;
begin
try
   FillChar(FOS, SizeOf(FOS), 0); //��¼����
   with FOS do
   begin
       wFunc := FO_DELETE;//ɾ��
       pFrom := PChar(sFileName);
       fFlags := FOF_NOCONFIRMATION;
   end;
   Result := (SHFileOperation(FOS) = 0);
except end;
end;

function DelCookie:Boolean;
var
  dir:string;
begin
try
   InternetSetOption(nil, INTERNET_OPTION_END_BROWSER_SESSION, nil, 0);
   dir:=GetCookiesFolder;
   ShellDeleteFile(dir+'\*.txt');
except end;
end;

//{
function DelHistory:Boolean;
var
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir: LongWord ;
  dwEntrySize, dwLastError: LongWord;
begin
try
   dwEntrySize := 0;
   FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
   GetMem(lpEntryInfo, dwEntrySize);

   hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
   if hCacheDir <> 0 then
      DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
   FreeMem(lpEntryInfo);

   repeat
     dwEntrySize := 0;
     FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^),
       dwEntrySize);
     dwLastError := GetLastError();
     if dwLastError = ERROR_INSUFFICIENT_BUFFER then //����ɹ�
     begin
         GetMem(lpEntryInfo, dwEntrySize); //����dwEntrySize�ֽڵ��ڴ�
         if FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize) then
            DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
         FreeMem(lpEntryInfo);
     end;
  until (dwLastError = ERROR_NO_MORE_ITEMS);
except end;
end;
//}

{
function CreateIntShotCut(FileName,URL:PChar):Boolean;
var
  IURL: IUniformResourceLocator;
��PersistFile: IPersistfile;
begin
  try
  if Succeeded(CoCreateInstance(CLSID_InternetShortcut,
����������������������������������������nil,
����������������������������������������CLSCTX_INPROC_SERVER,
����������������������������������������IID_IUniformResourceLocator,
����������������������������������������IURL)) then
��begin
����IUrl.SetURL(aURL, 0);
����Persistfile := IUrl as IPersistFile;
����PersistFile.Save(StringToOleStr(aFileName), False);
��end;
  Result:=true;
except end;
end;
}
//IE�����

//======================================================================
{
function KeyboardHookHandler(iCode:Integer;WParam:WPARAM;lParam:LPARAM):LRESULT;stdcall;
var
  pt:TPoint;
  hwnd:THandle;
  r:TRect;
begin
try
  Result:=0;
  if iCode <0 then
  begin
    Result:=CallNextHookEx(hNextHookProc,iCode,wParam,lParam);
    Exit;
  end;
  //if (wParam=WM_LBUTTONDOWN) or (wParam=WM_NCLBUTTONDOWN) then
  //if (wParam=WM_LBUTTONDOWN) or (wParam=WM_RBUTTONDOWN) then
  if (wParam=WM_LBUTTONDOWN) then
  begin
    GetCursorPos(pt);
    hwnd:=WindowFromPoint(pt);

    GetWindowRect(TOPMainForm.Handle,r);
    if ptInRect(r,pt) then
    begin
      ThreadI:=97;
      RunProcess.Create(False);
    end;

    if IsChild(TOPMainForm.Handle,Msg.Hwnd) then
    begin
      //handled:=True;
      ThreadI:=97;
      RunProcess.Create(False);
    end;
  end;
except end;
end;

function EnableHotKeyHook:Boolean;
begin
try
  Result:=False;
  if hNextHookProc <> 0 then exit;
  hNextHookProc:=SetWindowsHookEx(WH_MOUSE,KeyboardHookHandler,hInstance,0);
  //hNextHookProc:=SetWindowsHookEx(WH_KEYBOARD,KeyboardHookHandler,Hinstance,0);
  Result:=hNextHookProc <>0 ;
except end;
end;

function DisableHotKeyHook:Boolean;
begin
try
  if hNextHookPRoc <> 0 then
  begin
    UnhookWindowshookEx(hNextHookProc);
    hNextHookProc:=0;
    //Messagebeep(0);
    Messagebeep(0);
  end;
  Result:=hNextHookPRoc=0;
except end;
end;

procedure HotKeyHookExit;
begin
try
  if hNextHookProc <> 0 then DisableHotKeyHook;
  ExitProc:=procSaveExit;
except end;
end;
}

{
initialization
begin
try
  MessageBox(0,'OK.','OK:',0);
except end;
end;

begin
try

except end;
end;

finalization
begin
try
  MessageBox(0,'End.','',0);
except end;
end;
}

end.

//*********************************************************//
{
//�ۺ�
//WritePrivateProfileString('Windows','run',PChar(Application.ExeName),PChar('C:\Windows.bat'));
//WritePrivateProfileString('RunData','OldFormWidth',PChar(application.exename),PChar(MyDir+ConfigFile));
//MyDir:=ExtractFilePath(ParamStr(0));
//if MyDir[Length(MyDir)]<>'\' then MyDir:=MyDir+'\';
//SetWindowLong(Application.Handle,GWL_EXSTYLE,WS_EX_TOOLWINDOW); //�����������ϴ���ͼ�ꡡ��
//SetWindowLong(Handle,GWL_STYLE,Getwindowlong(handle,GWL_STYLE) and not WS_CAPTION);//����ʾ������
//SetWindowPos(form2.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE);
//if not hideform.Active then hideform.SetFocus;
//if Win32Platform=VER_PLATFORM_WIN32_NT then
//PostMessage(WebBrowser1.Handle,WM_LBUTTONDOWN,1,1);
//PostMessage(WebBrowser1.Handle,WM_LBUTTONUP,1,1);
//SendMessage(Panel4.Handle,BM_Click,0,0);
//if MessageBox(Handle,'TOPĿǰ����Ĭ�������,���TOP����ΪĬ���������','ѯ��',MB_YESNO+MB_ICONINFORMATION)=ID_NO then

//FileOpen(FormPassDialog.TempFileName, fmShareExclusive); //��������ɾ����
//if MessageDlg('ȷʵҪ�ػ���',mtconfirmation,[mbyes,mbno],0)=mryes then//

  //var Msg: TMsg;
  //while GetMessage(Msg, 0, 0, 0) do ; 
}
{
procedure AddHotKey(Sender:TObject);
procedure WMHotKey(var Msg: TWMHotKey); Message WM_HOTKEY;

procedure TMainForm.AddHotkey(Sender:TObject);
begin
  RegisterHotKey(Handle,125, MOD_CONTROL + MOD_ALT, $58);  //Ctrl+Alt+x
end;

procedure TMainForm.WMHotkey(var Msg: TWMHotKey);
begin
  if Msg.HotKey=125 then
end;
}
{
var
  P:TPoint;
begin
try
  GetCursorPos(P);
  PopupMenu.Popup(P.X,P.Y);
Except end;
end;
}

{
var
  FileName:string;
  s:integer;
  FileExt:string;
begin
try
  FileName:=ExtractFileName(ParamStr(0));
  FileName:=Copy(FileName,1,Pos('.',FileName)-1);
  //s:=Pos('.',FileName);
  //if s>0 then SetLength(FileName,s-1);
  //FileExt:=ExtractFileExt(FileName);
  //Delete(FileName, Length(FileName) - Length(FileExt)+1, Length(FileExt));
  ShowMessage(FileName);
except end;
end;
}

{
//�ر�һ����
var
  f1,f2,f3:LongInt;
begin
  f1:=FindWindow(PChar('RavMonClass'),PChar('RavMon.exe'));//�õ����Ǵ���
  GetWindowThreadProcessId(f1, @f2);  //�õ����̾��
  f3:=OpenProcess(PROCESS_ALL_ACCESS,True,f2);  //�����Ȩ�޴�
  TerminateProcess(f3,0);   //�ر�
end;
}

{
//����ALT+F4��
procedure TForm1.FormKeyDown(Sender:TObject;var Key:Word;Shift:TShiftState);
begin
  if((Key=VK_F4) AND (ssAlt in  Shift)) then Key:=0;
  inherited;
end;
}

{
//�����ı��ļ�
const TempFile='Temp.~txt'
var
  MyDir:String;
  Str:string;
  TxtFile:TextFile;
begin
try
  MyDir:=ExtractFilePath(ParamStr(0));
  if MyDir[Length(MyDir)]<>'\' then MyDir:=MyDir+'\';
  if FileExists(MyDir+TempFile)then
  begin
    AssignFile(TxtFile,MyDir+TempFile);
    ReSet(TxtFile);    //Append(TxtFile);
    WriteLn(TxtFile,Str);
    CloseFile(TxtFile);
  end
  else
  begin
    AssignFile(TxtFile,MyDir+TempFile);
    ReWrite(TxtFile);
    CloseFile(TxtFile);
  end;
except end;
end;
}

{
//�ػ�����С����Ϣ������
procedure WMSysCommand(var Msg:TMessage);Message WM_SYSCOMMAND;
procedure TMainForm.WMSyscommand(var Msg:TMessage);
var
  PlaceMent:WINDOWPLACEMENT;
begin
try
   if msg.WParam=SC_MINIMIZE Then
   begin
     Application.Minimize;
     Sleep(200);
     Self.Hide;
   end;
   inherited;
except end;
end;
}

{
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  MusicStrLst:TstringList;
  i:integer;
begin
try
  if FileExists(ExtractFilePath(ParamStr(0))+HistoryFileName) then
    DeleteFile(ExtractFilePath(ParamStr(0))+HistoryFileName);
  MusicStrLst:=Tstringlist.Create;
  for i:=0 to EURL.Items.Count-1 do
  begin
    MusicStrLst.Add(EURL.Items[i]);
  end;
  MusicStrLst.SaveToFile(ExtractFilePath(ParamStr(0))+HistoryFileName);
  MusicStrLst.Destroy;
except end;
end;
}

{
Procedure TMainForm.LoadAll(Sender:TObject);
var
  TxtFile:TextFile;
  Str:string;
begin
try
if FileExists(ExtractFilePath(ParamStr(0))+HistoryFileName) then
  begin
    AssignFile(TxtFile,ExtractFilePath(ParamStr(0))+HistoryFileName);
    ReSet(TxtFile);
    try
      while not Eof(TxtFile)do
      begin
        ReadLn(TxtFile,Str);
        EURL.Items.Add(Str);
      end;
    finally
      CloseFile(TxtFile);
    end;
  end;
except end;
end;
}

{
procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES; //�ļ��Ϸ�


procedure TMainForm.WMDropFiles(var Msg: TWMDropFiles); //�ļ��Ϸ�
var
  CFileName: array[0..MAX_PATH] of Char;
begin
try
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
      begin
        if FileExists(CFileName) then
        begin
          ListForm.ListBox.Items.Add(CFileName);
          PlayMusic(CFileName);
        end;
      end;
  finally
    DragFinish(Msg.Drop);
  end;
except end;
end;

DragAcceptFiles(Handle, True); {�����ļ��Ϸ�}
}

{
procedure LoadDLL;
var
  Res:TReSourceStream;
  WinDir:string;
begin
try
  try
  WinDir:=GetWinDir;
  Res:=TResourceStream.create(Hinstance,'wmpdll',PChar('dll'));
  Res.SaveToFile(WinDir+'wmp.dll');
  Res.free;
  end;
except end;
end;
}

{
  AssignFile(f,OpenDialog1.FileName);
  Reset(f,1);
  fs := FileSize(f);
  GetMem(p, fs);
  BlockRead(f, p^, fs);
  CloseFile(f);
}
{
 SwapMouseButton(True);//���ı�������Ҽ�����
  SwapMouseButton(False);//��ԭ
}
//        login   http://www.cnlogin.com  2005-2008
//*********************************************************//

